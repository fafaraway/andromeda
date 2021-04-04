local _G = _G
local unpack = unpack
local select = select
local ipairs = ipairs
local tinsert = tinsert
local wipe = wipe
local strfind = strfind
local gsub = gsub
local C_FriendList_GetWhoInfo = C_FriendList.GetWhoInfo
local C_FriendList_GetNumWhoResults = C_FriendList.GetNumWhoResults
local GetQuestDifficultyColor = GetQuestDifficultyColor
local GetRealZoneText = GetRealZoneText
local GetGuildInfo = GetGuildInfo
local GetGuildTradeSkillInfo = GetGuildTradeSkillInfo
local GetGuildRosterInfo = GetGuildRosterInfo
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local UnitRace = UnitRace
local UnitClass = UnitClass
local GetCVar = GetCVar
local UnitLevel = UnitLevel
local UnitEffectiveLevel = UnitEffectiveLevel
local hooksecurefunc = hooksecurefunc
local HybridScrollFrame_GetOffset = HybridScrollFrame_GetOffset
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local UIDropDownMenu_GetSelectedID = UIDropDownMenu_GetSelectedID
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS

local F, C = unpack(select(2, ...))
local OUF = F.OUF

-- Colors
local function classColor(class, showRGB)
    local color = C.ClassColors[C.ClassList[class] or class]
    if not color then
        color = C.ClassColors['PRIEST']
    end

    if showRGB then
        return color.r, color.g, color.b
    else
        return '|c' .. color.colorStr
    end
end

local function diffColor(level)
    return F:RGBToHex(GetQuestDifficultyColor(level))
end

local rankColor = {1, 0, 0, 1, 1, 0, 0, 1, 0}

local repColor = {1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1}

local function smoothColor(cur, max, color)
    local r, g, b = OUF:RGBColorGradient(cur, max, unpack(color))
    return F:RGBToHex(r, g, b)
end

-- Guild
local currentView
local function setView(view)
    currentView = view
end

local function updateGuildView()
    currentView = currentView or GetCVar('guildRosterView')

    local playerArea = GetRealZoneText()
    local buttons = _G.GuildRosterContainer.buttons

    for _, button in ipairs(buttons) do
        if button:IsShown() and button.online and button.guildIndex then
            if currentView == 'tradeskill' then
                local _, _, _, headerName, _, _, _, _, _, _, _, zone = GetGuildTradeSkillInfo(button.guildIndex)
                if not headerName and zone == playerArea then
                    button.string2:SetText('|cff00ff00' .. zone)
                end
            else
                local _, rank, rankIndex, level, _, zone, _, _, _, _, _, _, _, _, _, repStanding = GetGuildRosterInfo(button.guildIndex)
                if currentView == 'playerStatus' then
                    button.string1:SetText(diffColor(level) .. level)
                    if zone == playerArea then
                        button.string3:SetText('|cff00ff00' .. zone)
                    end
                elseif currentView == 'guildStatus' then
                    if rankIndex and rank then
                        button.string2:SetText(smoothColor(rankIndex, 10, rankColor) .. rank)
                    end
                elseif currentView == 'achievement' then
                    button.string1:SetText(diffColor(level) .. level)
                elseif currentView == 'reputation' then
                    button.string1:SetText(diffColor(level) .. level)
                    if repStanding then
                        button.string3:SetText(smoothColor(repStanding - 4, 5, repColor) .. _G['FACTION_STANDING_LABEL' .. repStanding])
                    end
                end
            end
        end
    end
end

local function updateGuildUI(event, addon)
    if addon ~= 'Blizzard_GuildUI' then
        return
    end
    hooksecurefunc('GuildRoster_SetView', setView)
    hooksecurefunc('GuildRoster_Update', updateGuildView)
    hooksecurefunc(_G.GuildRosterContainer, 'update', updateGuildView)

    F:UnregisterEvent(event, updateGuildUI)
end
F:RegisterEvent('ADDON_LOADED', updateGuildUI)

-- Whoframe
local columnTable = {}
local function updateWhoList()
    local scrollFrame = _G.WhoListScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons
    local numButtons = #buttons
    local numWhos = C_FriendList_GetNumWhoResults()

    local playerZone = GetRealZoneText()
    local playerGuild = GetGuildInfo('player')
    local playerRace = UnitRace('player')

    for i = 1, numButtons do
        local button = buttons[i]
        local index = offset + i
        if index <= numWhos then
            local nameText = button.Name
            local levelText = button.Level
            local variableText = button.Variable

            local info = C_FriendList_GetWhoInfo(index)
            local guild, level, race, zone, class = info.fullGuildName, info.level, info.raceStr, info.area, info.filename
            if zone == playerZone then
                zone = '|cff00ff00' .. zone
            end
            if guild == playerGuild then
                guild = '|cff00ff00' .. guild
            end
            if race == playerRace then
                race = '|cff00ff00' .. race
            end

            wipe(columnTable)
            tinsert(columnTable, zone)
            tinsert(columnTable, guild)
            tinsert(columnTable, race)

            nameText:SetTextColor(classColor(class, true))
            levelText:SetText(diffColor(level) .. level)
            variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(_G.WhoFrameDropDown)])
        end
    end
end
hooksecurefunc('WhoList_Update', updateWhoList)
hooksecurefunc(_G.WhoListScrollFrame, 'update', updateWhoList)

local blizzHexColors = {}
for class, color in pairs(RAID_CLASS_COLORS) do
    blizzHexColors[color.colorStr] = class
end

-- FrameXML/ChatFrame.lua
do
    local AddMessage = {}

    local function FixClassColors(frame, message, ...)
        if type(message) == 'string' and strfind(message, '|cff') then
            for hex, class in pairs(blizzHexColors) do
                local color = C.ClassColors[class]
                message = color and gsub(message, hex, color.colorStr) or message
            end
        end
        return AddMessage[frame](frame, message, ...)
    end

    for i = 1, NUM_CHAT_WINDOWS do
        local frame = _G['ChatFrame' .. i]
        AddMessage[frame] = frame.AddMessage
        frame.AddMessage = FixClassColors
    end
end

-- FrameXML/LevelUpDisplay.lua
hooksecurefunc('BossBanner_ConfigureLootFrame', function(lootFrame, data)
    local color = C.ClassColors[data.className]
    lootFrame.PlayerName:SetTextColor(color.r, color.g, color.b)
end)

-- FrameXML/PaperDollFrame.lua
hooksecurefunc('PaperDollFrame_SetLevel', function()
    local className, class = UnitClass('player')
    local color = C.ClassColors[class].colorStr

    local primaryTalentTree, specName = GetSpecialization()
    if primaryTalentTree then
        primaryTalentTree, specName = GetSpecializationInfo(primaryTalentTree)
    end

    local level = UnitLevel('player')
    local effectiveLevel = UnitEffectiveLevel('player')
    if effectiveLevel ~= level then
        level = _G.EFFECTIVE_LEVEL_FORMAT:format(effectiveLevel, level)
    end

    if specName and specName ~= '' then
        _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL, level, color, specName, className)
    else
        _G.CharacterLevelText:SetFormattedText(_G.PLAYER_LEVEL_NO_SPEC, level, color, className)
    end
end)

-- FrameXML/RaidWarning.lua
do
    local AddMessage = _G.RaidNotice_AddMessage
    _G.RaidNotice_AddMessage = function(frame, message, ...)
        if strfind(message, '|cff') then
            for hex, class in pairs(blizzHexColors) do
                local color = C.ClassColors[class]
                message = gsub(message, hex, color.colorStr)
            end
        end
        return AddMessage(frame, message, ...)
    end
end
