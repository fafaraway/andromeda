local F, C = unpack(select(2, ...))
local oUF = FreeUI.oUF

-- yClassColors, by yleaf

local format, strsplit, ipairs, tinsert, strfind, gsub, strmatch, strsub, pairs, type = string.format, string.split, ipairs, table.insert, string.find, string.gsub, string.match, string.sub, pairs, type


-- Colors
local function classColor(class, showRGB)
	local color = C.ClassColors[C.ClassList[class] or class]
	if not color then color = C.ClassColors['PRIEST'] end

	if showRGB then
		return color.r, color.g, color.b
	else
		return '|c'..color.colorStr
	end
end

local function diffColor(level)
	return F.HexRGB(GetQuestDifficultyColor(level))
end

local rankColor = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0
}

local repColor = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
	0, 1, 1,
	0, 0, 1,
}

local function smoothColor(cur, max, color)
	local r, g, b = oUF:RGBColorGradient(cur, max, unpack(color))
	return F.HexRGB(r, g, b)
end

-- Guild
local currentView
local function setView(view)
	currentView = view
end

local function updateGuildView()
	currentView = currentView or GetCVar('guildRosterView')

	local playerArea = GetRealZoneText()
	local buttons = GuildRosterContainer.buttons

	for _, button in ipairs(buttons) do
		if button:IsShown() and button.online and button.guildIndex then
			if currentView == 'tradeskill' then
				local _, _, _, headerName, _, _, _, _, _, _, _, zone = GetGuildTradeSkillInfo(button.guildIndex)
				if not headerName and zone == playerArea then
					button.string2:SetText('|cff00ff00'..zone)
				end
			else
				local _, rank, rankIndex, level, _, zone, _, _, _, _, _, _, _, _, _, repStanding = GetGuildRosterInfo(button.guildIndex)
				if currentView == 'playerStatus' then
					button.string1:SetText(diffColor(level)..level)
					if zone == playerArea then
						button.string3:SetText('|cff00ff00'..zone)
					end
				elseif currentView == 'guildStatus' then
					if rankIndex and rank then
						button.string2:SetText(smoothColor(rankIndex, 10, rankColor)..rank)
					end
				elseif currentView == 'achievement' then
					button.string1:SetText(diffColor(level)..level)
				elseif currentView == 'reputation' then
					button.string1:SetText(diffColor(level)..level)
					if repStanding then
						button.string3:SetText(smoothColor(repStanding-4, 5, repColor).._G['FACTION_STANDING_LABEL'..repStanding])
					end
				end
			end
		end
	end
end

local function updateGuildUI(event, addon)
	if addon ~= 'Blizzard_GuildUI' then return end
	hooksecurefunc('GuildRoster_SetView', setView)
	hooksecurefunc('GuildRoster_Update', updateGuildView)
	hooksecurefunc(GuildRosterContainer, 'update', updateGuildView)

	F:UnregisterEvent(event, updateGuildUI)
end
F:RegisterEvent('ADDON_LOADED', updateGuildUI)

-- Friends
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')

local function friendsFrame()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local buttons = scrollFrame.buttons
	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		local button = buttons[i]
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local info = C_FriendList.GetFriendInfoByIndex(button.id)
				if info and info.connected then
					nameText = classColor(info.className)..info.name..'|r, '..format(FRIENDS_LEVEL_TEMPLATE, diffColor(info.level)..info.level..'|r', info.className)
					if info.area == playerArea then
						infoText = format('|cff00ff00%s|r', info.area)
					end
				end
			elseif button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
				local _, presenceName, _, _, _, gameID, client, isOnline = BNGetFriendInfo(button.id)
				if isOnline and client == BNET_CLIENT_WOW then
					local _, charName, _, _, _, faction, _, class, _, zoneName = BNGetGameAccountInfo(gameID)
					if presenceName and charName and class and faction == UnitFactionGroup('player') then
						nameText = presenceName..' '..FRIENDS_WOW_NAME_COLOR_CODE..'('..classColor(class)..charName..FRIENDS_WOW_NAME_COLOR_CODE..')'
						if zoneName == playerArea then
							infoText = format('|cff00ff00%s|r', zoneName)
						end
					end
				end
			end
		end

		if nameText then button.name:SetText(nameText) end
		if infoText then button.info:SetText(infoText) end
	end
end
hooksecurefunc(FriendsFrameFriendsScrollFrame, 'update', friendsFrame)
hooksecurefunc('FriendsFrame_UpdateFriends', friendsFrame)

-- Whoframe
local columnTable = {}
local function updateWhoList()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo('player')
	local playerRace = UnitRace('player')

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local index = whoOffset + i
		local nameText = _G['WhoFrameButton'..i..'Name']
		local levelText = _G['WhoFrameButton'..i..'Level']
		local variableText = _G['WhoFrameButton'..i..'Variable']
		local info = C_FriendList.GetWhoInfo(index)
		if info then
			local guild, level, race, zone, class = info.fullGuildName, info.level, info.raceStr, info.area, info.filename
			if zone == playerZone then zone = '|cff00ff00'..zone end
			if guild == playerGuild then guild = '|cff00ff00'..guild end
			if race == playerRace then race = '|cff00ff00'..race end

			wipe(columnTable)
			tinsert(columnTable, zone)
			tinsert(columnTable, guild)
			tinsert(columnTable, race)

			nameText:SetTextColor(classColor(class, true))
			levelText:SetText(diffColor(level)..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
		end
	end
end
hooksecurefunc('WhoList_Update', updateWhoList)


-- Chatframe
local blizzHexColors = {}
for class, color in pairs(C.ClassColors) do
	blizzHexColors[color.colorStr] = class
end

function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	if not arg2 then
		return arg2
	end

	local chatType = strsub(event, 10)
	if strsub(chatType, 1, 7) == 'WHISPER' then
		chatType = 'WHISPER'
	elseif strsub(chatType, 1, 7) == 'CHANNEL' then
		chatType = 'CHANNEL'..arg8
	end

	if chatType == 'GUILD' then
		arg2 = Ambiguate(arg2, 'guild')
	else
		arg2 = Ambiguate(arg2, 'none')
	end

	local info = ChatTypeInfo[chatType]
	if info and info.colorNameByClass and arg12 and arg12 ~= '' and arg12 ~= 0 then
		local _, class = GetPlayerInfoByGUID(arg12)
		local color = class and C.ClassColors[class]
		if color then
			return format('|c%s%s|r', color.colorStr, arg2)
		end
	end

	return arg2
end

do
	local AddMessage = {}

	local function FixClassColors(frame, message, ...) -- 3174
		if type(message) == 'string' and strfind(message, '|cff') then -- type check required for shitty addons that pass nil or non-string values
			for hex, class in pairs(blizzHexColors) do
				local color = C.ClassColors[class]
				message = color and gsub(message, hex, color.colorStr) or message -- color check required for Warmup, maybe others
			end
		end
		return AddMessage[frame](frame, message, ...)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G['ChatFrame'..i]
		AddMessage[frame] = frame.AddMessage
		frame.AddMessage = FixClassColors
	end
end


-- Reputation
hooksecurefunc('ReputationFrame_Update', function(showLFGPulse)
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionBar = _G['ReputationBar'..i..'ReputationBar']

		if factionIndex <= numFactions then
			local name, description, standingID = GetFactionInfo(factionIndex)
			local colorIndex = standingID

			local color = oUF.colors.reaction[colorIndex]
			factionBar:SetStatusBarColor(color[1], color[2], color[3])
		end
	end
end)

hooksecurefunc(ReputationBarMixin, 'Update', function(self)
	local name, reaction, minBar, maxBar, value, factionID = GetWatchedFactionInfo();
	local colorIndex = reaction;

	local color = oUF.colors.reaction[colorIndex];
	self:SetBarColor(color[1], color[2], color[3], 1);
end)