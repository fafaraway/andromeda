local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('INFOBAR')

-- #TODO
local tthead, ttsubh, ttoff = {r = 0.4, g = 0.78, b = 1}, {r = 0.75, g = 0.9, b = 1}, {r = .3, g = 1, b = .3}
local activezone, inactivezone = {r = 0.3, g = 1.0, b = 0.3}, {r = 0.65, g = 0.65, b = 0.65}
local guildInfoString = "%s [%d]"
local guildInfoString2 = "%s %d/%d"
local guildMotDString = "  %s |cffaaaaaa- |cffffffff%s"
local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s"
local levelNameStatusString = "|cff%02x%02x%02x%d|r %s %s"
local nameRankString = "%s |cff999999-|cffffffff %s"
local noteString = "  '%s'"
local officerNoteString = "  o: '%s'"

local guildTable, guildXP, guildMotD = {}, {}, ""
local totalOnline = 0

local function BuildGuildTable()
	totalOnline = 0
	wipe(guildTable)
	local _, name, rank, level, zone, note, officernote, connected, status, class, isMobile
	for i = 1, GetNumGuildMembers() do
		name, rank, _, level, _, zone, note, officernote, connected, status, class, _, _, isMobile = GetGuildRosterInfo(i)

		if status == 1 then
			status = "|cffff0000["..AFK.."]|r"
		elseif status == 2 then
			status = "|cffff0000["..DND.."]|r"
		else
			status = ""
		end

		guildTable[i] = { name, rank, level, zone, note, officernote, connected, status, class, isMobile }
		if connected then totalOnline = totalOnline + 1 end
	end
	table.sort(guildTable, function(a, b)
		if a and b then
			return a[1] < b[1]
		end
	end)
end

local function UpdateGuildMessage()
	guildMotD = GetGuildRosterMOTD()
end

local function inviteClick(self, arg1, arg2, checked)
	menuFrame:Hide()
	InviteUnit(arg1)
end

local function whisperClick(self,arg1,arg2,checked)
	menuFrame:Hide()
	SetItemRef( "player:"..arg1, ("|Hplayer:%1$s|h[%1$s]|h"):format(arg1), "LeftButton" )
end

local function ToggleGuildFrame()
	if IsInGuild() then
		if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
		GuildFrame_Toggle()
		GuildFrame_TabClicked(GuildFrameTab2)
	else
		if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
		LookingForGuildFrame_Toggle()
	end
end


local FreeUIFriendsButton = INFOBAR.FreeUIGuildButton

function INFOBAR:Guild()
	if not C.DB.infobar.guild then return end

	FreeUIGuildButton = INFOBAR:addButton('', INFOBAR.POSITION_RIGHT, 100)

	FreeUIGuildButton:RegisterEvent('GUILD_ROSTER_UPDATE')
	FreeUIGuildButton:RegisterEvent('PLAYER_GUILD_UPDATE')
	FreeUIGuildButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIGuildButton:SetScript('OnEvent', function(self, event, ...)
		if not IsInGuild() then
			self.Text:SetText(L['INFOBAR_GUILD']..": "..C.InfoColor..L['INFOBAR_GUILD_NONE'])
			return
		end

		--GuildRoster()

		totalOnline = select(3, GetNumGuildMembers())
		self.Text:SetText(L['INFOBAR_GUILD']..": "..C.InfoColor..totalOnline)
	end)

	FreeUIGuildButton.onMouseUp = function(self, btn)
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end

		if IsInGuild() then
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
			GuildFrame_Toggle()
			GuildFrame_TabClicked(GuildFrameTab2)
		else
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
			LookingForGuildFrame_Toggle()
		end
	end
	FreeUIGuildButton:HookScript('OnMouseUp', FreeUIGuildButton.onMouseUp)

	FreeUIGuildButton:HookScript('OnEnter', function(self)
		if InCombatLockdown() or not IsInGuild() then return end

		--GuildRoster()
		UpdateGuildMessage()
		BuildGuildTable()

		local name, rank, level, zone, note, officernote, connected, status, class, isMobile
		local zonec, classc, levelc
		local online = totalOnline
		local GuildInfo, GuildRank, GuildLevel = GetGuildInfo("player")

		GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -15) or 15)
		GameTooltip:ClearLines()

		if GuildInfo and GuildLevel then
			GameTooltip:AddDoubleLine(GuildInfo, string.format('%s: %s/%s', GUILD_ONLINE_LABEL, online, #guildTable),.9, .8, .6, 1, 1, 1)

		end

		if guildMotD ~= "" then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(string.format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1)
		end

		local col = F.RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b)

		local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()

		if standingID ~= 8 then -- Not Max Rep
			barMax = barMax - barMin
			barValue = barValue - barMin
			barMin = 0
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(string.format("%s:|r |cFFFFFFFF%s/%s (%s%%)",col..COMBAT_FACTION_CHANGE, F.Numb(barValue), F.Numb(barMax), math.ceil((barValue / barMax) * 100)))
		end

		if online > 1 then
			local Count = 0

			GameTooltip:AddLine(" ")
			for i = 1, #guildTable do
				if online <= 1 then
					break
				end

				name, rank, level, zone, note, officernote, connected, status, class, isMobile = unpack(guildTable[i])

				if connected and name ~= UnitName("player") then
					if Count > ((C.ScreenHeight / 10) / 2) then
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(format("+ "..INSPECT_GUILD_NUM_MEMBERS, online - Count),ttsubh.r,ttsubh.g,ttsubh.b)

						break
					end

					if GetRealZoneText() == zone then zonec = activezone else zonec = inactivezone end
					classc, levelc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class], GetQuestDifficultyColor(level)

					if isMobile then zone = "" end

					if IsShiftKeyDown() then
						GameTooltip:AddDoubleLine(string.format(nameRankString, name, rank), zone, classc.r, classc.g, classc.b, zonec.r, zonec.g, zonec.b)
						if note ~= "" then GameTooltip:AddLine(string.format(noteString, note), ttsubh.r, ttsubh.g, ttsubh.b, 1) end
						if officernote ~= "" then GameTooltip:AddLine(string.format(officerNoteString, officernote), ttoff.r, ttoff.g, ttoff.b ,1) end
					else
						GameTooltip:AddDoubleLine(string.format(levelNameStatusString, levelc.r*255, levelc.g*255, levelc.b*255, level, name, status), zone, classc.r,classc.g,classc.b, zonec.r,zonec.g,zonec.b)
					end

					Count = Count + 1
				end
			end
		end


		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left..L['INFOBAR_OPEN_GUILD_PANEL']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	FreeUIGuildButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end
