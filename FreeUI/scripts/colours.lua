local F, C, L = unpack(select(2, ...))

local myName = UnitName("player")

local GUILD_INDEX_MAX = 12
local SMOOTH = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local WHITE_HEX = '|cffffffff'

local function Hex(r, g, b)
	if type(r) == "table" then
		if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end

	if(not r or not g or not b) then
		r, g, b = 1, 1, 1
	end

	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

-- http://www.wowwiki.com/ColorGradient
local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			local c = Hex(ColorGradient(i/GUILD_INDEX_MAX, unpack(SMOOTH)))
			if(c) then
				t[i] = c
				return c
			else
				t[i] = t[0]
			end
		end
	end
})
guildRankColor[0] = WHITE_HEX

local diffColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and GetQuestDifficultyColor(i)
		t[i] = c and Hex(c) or t[0]
		return t[i]
	end
})
diffColor[0] = WHITE_HEX

local classColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and C.classcolours[BC[i] or i]
		if(c) then
			t[i] = Hex(c)
			return t[i]
		else
			return WHITE_HEX
		end
	end
})

local classColorRaw = setmetatable({}, {
	__index = function(t, i)
		local c = i and C.classcolours[BC[i] or i]
		if not c then return 1, 1, 1 end
		t[i] = c
		return c
	end
})

hooksecurefunc("WorldStateScoreFrame_Update", function()
	local inArena = IsActiveBattlefieldArena()
	local offset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)

	for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local index = offset + i
		local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index)
		-- faction: Battlegrounds: Horde = 0, Alliance = 1 / Arenas: Green Team = 0, Yellow Team = 1
		if name then
			local n, r = strsplit('-', name, 2)
			n = classColor[class] .. n .. '|r'

			if n == myName and not r then
				n = '> ' .. n .. ' <'
			end

			if r then
				local color
				if inArena then
					if faction == 1 then
						color = '|cffffd100'
					else
						color = '|cff19ff19'
					end
				else
					if faction == 1 then
						color = '|cff00adf0'
					else
						color = '|cffff1919'
					end
				end
				r = color .. r .. '|r'
				n = n .. '|cffffffff - |r' .. r
			end

			local button = _G["WorldStateScoreButton" .. i]
			button.name.text:SetText(n)
		end
	end
end)

local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%$d', '%$s') -- '%2$s %1$d-–≥–æ —É—Ä–æ–≤–Ω—è'

local function friendsFrame()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local button, index

	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		button = buttons[i]
		index = offset + i
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local name, level, class, area, connected = GetFriendInfo(button.id)
				if connected then
					nameText = classColor[class] .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, diffColor[level] .. level .. '|r', class)
					if(area == playerArea) then
						infoText = format('|cff00ff00%s|r', area)
					end
				end
			elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
				if isOnline and client == BNET_CLIENT_WOW then
					local _, _, _, realmName, realmID, faction, race, class, guild, zoneName, level = BNGetGameAccountInfo(toonID)
					if presenceName and toonName and class then
						nameText = presenceName ..' '.. FRIENDS_WOW_NAME_COLOR_CODE .. '(' .. classColor[class] .. classColor[class] .. toonName .. FRIENDS_WOW_NAME_COLOR_CODE .. ')'
						if zoneName == playerArea then
							infoText = format('|cff00ff00%s|r', zoneName)
						end
					end
				end
			end
		end

		if(nameText) then
			button.name:SetText(nameText)
		end
		if(infoText) then
			button.info:SetText(infoText)
		end
	end
end
hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", friendsFrame)
hooksecurefunc("FriendsFrame_UpdateFriends", friendsFrame)

local defaultView = "playerStatus"
local currentView = defaultView

local function viewChanged(view)
	currentView = view or defaultView
end

local function updateTradeSkills()
	for i, button in ipairs(GuildRosterContainer.buttons) do
		if button:IsShown() and button.online and button.guildIndex then
			local skillID, isCollapsed, iconTexture, headerName, numOnline, numVisible, numPlayers, playerDisplayName, playerFullName, class, online, zone, skill, classFileName, isMobile, isAway = GetGuildTradeSkillInfo(button.guildIndex)
			if playerDisplayName then
				playerDisplayName = classColor[classFileName]..playerDisplayName
				if isMobile then
					if isAway == 2 then
						playerDisplayName = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t"..playerDisplayName
					elseif isAway == 1 then
						playerDisplayName = "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t"..playerDisplayName
					else
						playerDisplayName = ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255)..playerDisplayName
					end
				end
				button.string1:SetText(playerDisplayName)
			end
		end
	end
end

local function updateGuild()
	if currentView == "tradeskill" then return end

	local myZone = GetRealZoneText()

	for i, button in ipairs(GuildRosterContainer.buttons) do
		if button:IsShown() and button.online and button.guildIndex then
			local fullName, rank, rankIndex, level, class, zone, note, officernote, online, isAway, classFileName, achievementPnts, achievementRank, isMobile = GetGuildRosterInfo(button.guildIndex)

			if currentView == "playerStatus" then
				button.string1:SetText(diffColor[level]..level)

				if not (isMobile and not online) and zone == myZone then
					button.string3:SetText("|cff00ff00"..zone)
					button.string3:SetTextColor(0, 1, 0)
				end
			elseif currentView == "guildStatus" then
				if rankIndex and rank then
					button.string2:SetText(guildRankColor[rankIndex]..rank)
				end
			else
				button.string1:SetText(diffColor[level]..level)
			end
		end
	end
end

local guildLoaded = false
hooksecurefunc("GuildFrame_LoadUI", function()
	if guildLoaded then return end
	guildLoaded = true

	local cvar = GetCVar("guildRosterView")
	currentView = (cvar ~= "" and cvar) or defaultView

	hooksecurefunc("GuildRoster_SetView", viewChanged)
	hooksecurefunc("GuildRoster_Update", updateGuild)
	hooksecurefunc(GuildRosterContainer, "update", updateGuild)
	hooksecurefunc("GuildRoster_UpdateTradeSkills", updateTradeSkills)

	hooksecurefunc("GuildRosterButton_SetStringText", function(buttonString, text, isOnline, class)
		if isOnline then
			if class then
				local c = C.classcolours[class]
				buttonString:SetTextColor(c.r, c.g, c.b)
			end
		end
	end)
end)

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, areaName, className, comment, partyMembers, status, class, encountersTotal, encountersComplete, isIneligible, isLeader, isTank, isHealer, isDamage = SearchLFGGetResults(index)

	if class and name and level and name ~= myName then
		button.name:SetText(classColor[class] .. name)
		button.class:SetText(classColor[class] .. className)
		button.level:SetText(diffColor[level] .. level)
	end
end)

hooksecurefunc("WhoList_Update", function()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo'player'
	local playerRace = UnitRace'player'

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local index = whoOffset + i
		local nameText = getglobal('WhoFrameButton'..i..'Name')
		local levelText = getglobal('WhoFrameButton'..i..'Level')
		local classText = getglobal('WhoFrameButton'..i..'Class')
		local variableText = getglobal('WhoFrameButton'..i..'Variable')

		local name, guild, level, race, class, zone, classFileName = GetWhoInfo(index)
		if(name) then
			if zone == playerZone then
				zone = '|cff00ff00' .. zone
			end
			if guild == playerGuild then
				guild = '|cff00ff00' .. guild
			end
			if race == playerRace then
				race = '|cff00ff00' .. race
			end
			local columnTable = { zone, guild, race }

			local c = classColorRaw[classFileName]
			nameText:SetTextColor(c.r, c.g, c.b)
			classText:SetTextColor(c.r, c.g, c.b)
			levelText:SetText(diffColor[level] .. level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
		end
	end
end)
