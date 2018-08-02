local F, C = unpack(select(2, ...))

-- yClassColors by yleaf
-- colorize player names by their class in friend list, who list, guild list, etc..


local _, ns = ...
local ycc = {}
ns.ycc = ycc

local GUILD_INDEX_MAX = 12
local SMOOTH = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}
ycc.myName = UnitName"player"

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local RAID_CLASS_COLORS = C.classcolours or RAID_CLASS_COLORS
local WHITE_HEX = "|cffffffff"

local function Hex(r, g, b)
	if type(r) == "table" then
		if r.r then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	if not r or not g or not b then
		r, g, b = 1, 1, 1
	end

	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

-- http://www.wowwiki.com/ColorGradient
local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select("#", ...) / 3
	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

ycc.guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			local c = Hex(ColorGradient(i/GUILD_INDEX_MAX, unpack(SMOOTH)))
			if c then
				t[i] = c
				return c
			else
				t[i] = t[0]
			end
		end
	end
})
ycc.guildRankColor[0] = WHITE_HEX

ycc.diffColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and GetQuestDifficultyColor(i)
		t[i] = c and Hex(c) or t[0]

		return t[i]
	end
})
ycc.diffColor[0] = WHITE_HEX

ycc.classColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if c then
			t[i] = Hex(c)
			return t[i]
		else
			return WHITE_HEX
		end
	end
})

local GUILDREP = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
	0, 1, 1,
	0, 0, 1,
}
ycc.repColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			local c = Hex(ColorGradient(i/5, unpack(GUILDREP)))
			if c then
				t[i] = c
				return c
			else
				t[i] = t[0]
			end
		end
	end
})

local WHITE = {1, 1, 1}
ycc.classColorRaw = setmetatable({}, {
	__index = function(t, i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if not c then return WHITE end
		t[i] = c

		return c
	end
})

if CUSTOM_CLASS_COLORS then
	CUSTOM_CLASS_COLORS:RegisterCallback(function()
		wipe(ycc.classColorRaw)
		wipe(ycc.classColor)
	end)
end


-- battlefield
--[[hooksecurefunc("WorldStateScoreFrame_Update", function()
	local inArena = IsActiveBattlefieldArena()
	local offset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)

	for i = 1, 20 do
		local index = offset + i
		local name, _, _, _, _, faction, _, _, class = GetBattlefieldScore(index)
		-- faction: Battlegrounds: Horde = 0, Alliance = 1 / Arenas: Green Team = 0, Yellow Team = 1
		if name then
			local n, r = strsplit("-", name, 2)
			n = ycc.classColor[class]..n.."|r"
			if name == ycc.myName then n = "> "..n.." <" end

			if r then
				local color
				if inArena then
					if faction == 1 then
						color = "|cffffd100"
					else
						color = "|cff19ff19"
					end
				else
					if faction == 1 then
						color = "|cff00adf0"
					else
						color = "|cffff1919"
					end
				end
				r = color..r.."|r"
				n = n.."|cffffffff - |r"..r
			end

			local button = _G["WorldStateScoreButton"..i]
			button.name.text:SetText(n)
		end
	end
end)
]]

-- friends
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")
local function friendsFrame()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local buttons = scrollFrame.buttons
	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		local button = buttons[i]
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local name, level, class, area, connected, _, _ = GetFriendInfo(button.id)
				if connected then
					nameText = ycc.classColor[class]..name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[level]..level.."|r", class)
					if area == playerArea then
						infoText = format("|cff00ff00%s|r", area)
					end
				end
			elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local _, presenceName, _, _, _, gameID, client, isOnline = BNGetFriendInfo(button.id)
				if isOnline and client == BNET_CLIENT_WOW then
					local _, charName, _, _, _, faction, _, class, _, zoneName = BNGetGameAccountInfo(gameID)
					if presenceName and charName and class and faction == UnitFactionGroup("player") then
						nameText = presenceName.." "..FRIENDS_WOW_NAME_COLOR_CODE.."("..ycc.classColor[class]..charName..FRIENDS_WOW_NAME_COLOR_CODE..")"
						if zoneName == playerArea then
							infoText = format("|cff00ff00%s|r", zoneName)
						end
					end
				end
			end
		end

		if nameText then button.name:SetText(nameText) end
		if infoText then button.info:SetText(infoText) end
	end
end
hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", friendsFrame)
hooksecurefunc("FriendsFrame_UpdateFriends", friendsFrame)


-- guild
local _VIEW

local function setview(view)
	_VIEW = view
end

local function update()
	_VIEW = _VIEW or GetCVar"guildRosterView"
	local playerArea = GetRealZoneText()
	local buttons = GuildRosterContainer.buttons

	for _, button in ipairs(buttons) do
		-- why the fuck no continue?
		if button:IsShown() and button.online and button.guildIndex then
			if _VIEW == "tradeskill" then
				local _, _, _, headerName, _, _, _, _, _, _, _, zone = GetGuildTradeSkillInfo(button.guildIndex)
				if (not headerName) and UnitName("player") then
					if zone == playerArea then
						button.string2:SetText("|cff00ff00"..zone)
					end
				end
			else
				local _, rank, rankIndex, level, _, zone, _, _, _, _, _, _, _, _, _, repStanding = GetGuildRosterInfo(button.guildIndex)
				if _VIEW == "playerStatus" then
					button.string1:SetText(ycc.diffColor[level]..level)
					if zone == playerArea then
						button.string3:SetText("|cff00ff00"..zone)
					end
				elseif _VIEW == "guildStatus" then
					if rankIndex and rank then
						button.string2:SetText(ycc.guildRankColor[rankIndex]..rank)
					end
				elseif _VIEW == "achievement" then
					button.string1:SetText(ycc.diffColor[level]..level)
				elseif _VIEW == "reputation" then
					button.string1:SetText(ycc.diffColor[level]..level)
					if repStanding then
						button.string3:SetText(ycc.repColor[repStanding-4].._G["FACTION_STANDING_LABEL"..repStanding])
					end
				end
			end
		end
	end
end

local loaded = CreateFrame("Frame")
loaded:RegisterEvent("ADDON_LOADED")
loaded:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "Blizzard_GuildUI" then return end

	hooksecurefunc("GuildRoster_SetView", setview)
	hooksecurefunc("GuildRoster_Update", update)
	hooksecurefunc(GuildRosterContainer, "update", update)

	self:UnregisterEvent(event)
end)


-- lfr
hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, _, className, _, _, _, class = SearchLFGGetResults(index)
	if name == ycc.myName then return end
	if class and name and level then
		button.name:SetText(ycc.classColor[class]..name)
		button.class:SetText(ycc.classColor[class]..className)
		button.level:SetText(ycc.diffColor[level]..level)
	end
end)


-- who
local columnTable
hooksecurefunc("WhoList_Update", function()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo("player")
	local playerRace = UnitRace("player")

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local index = whoOffset + i
		local nameText = getglobal("WhoFrameButton"..i.."Name")
		local levelText = getglobal("WhoFrameButton"..i.."Level")
		local variableText = getglobal("WhoFrameButton"..i.."Variable")

		local name, guild, level, race, _, zone, classFileName = GetWhoInfo(index)
		if name then
			if zone == playerZone then zone = "|cff00ff00"..zone end
			if guild == playerGuild then guild = "|cff00ff00"..guild end
			if race == playerRace then race = "|cff00ff00"..race end

			columnTable = {zone, guild, race}
			local c = ycc.classColorRaw[classFileName]
			nameText:SetTextColor(c.r, c.g, c.b)
			levelText:SetText(ycc.diffColor[level]..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
		end
	end
end)