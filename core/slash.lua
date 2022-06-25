local F, C = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

F:RegisterSlash('/free', function(msg)
    local str, _ = string.split(' ', string.lower(msg), 2)
    if string.match(str, 'reset') or string.match(str, 'init') then
        StaticPopup_Show('ANDROMEDA_RESET_ALL')
    elseif string.match(str, 'install') or string.match(str, 'tutorial') then
        F:GetModule('Installation'):HelloWorld()
    elseif string.match(str, 'unlock') or string.match(str, 'layout') then
        F:MoverConsole()
    elseif string.match(str, 'gui') or string.match(str, 'config') then
        F.ToggleGUI()
    elseif string.match(str, 'help') then
        GUI:ToggleCheatSheet()
    elseif string.match(str, 'discord') or string.match(str, 'feedback') then
        F:Print('discord: https://discord.gg/86wbfZXxn7')
    elseif string.match(str, 'ver') then
        F:Printf('version: %s', C.ADDON_VERSION)
    else
        GUI:ToggleCheatSheet()
        -- PlaySoundFile(C.Assets.Sound.PhubIntro, 'Master')
    end
end)

-- Leave group
F:RegisterSlash('/lg', function()
    C_PartyInfo.LeaveParty()
end)

--	Disband party or raid
F:RegisterSlash('/disband', function()
    StaticPopup_Show('ANDROMEDA_DISBAND_GROUP')
end)

--	Convert party raid
F:RegisterSlash('/convert', function()
    if GetNumGroupMembers() > 0 then
        if UnitInRaid('player') and (UnitIsGroupLeader('player')) then
            C_PartyInfo.ConvertToParty()
        elseif UnitInParty('player') and (UnitIsGroupLeader('player')) then
            C_PartyInfo.ConvertToRaid()
        end
    else
        F:Print('|cffff2020' .. _G.ERR_NOT_IN_GROUP .. '|r')
    end
end)

-- Ready check
F:RegisterSlash('/rdc', function()
    DoReadyCheck()
end)

-- Role poll
F:RegisterSlash('/role', function()
    InitiateRolePoll()
end)

-- Reset instance
F:RegisterSlash('/ri', function()
    ResetInstances()
end)

-- Teleport LFG instance
F:RegisterSlash('/tp', function()
    if IsInInstance() then
        LFGTeleport(true)
    else
        LFGTeleport()
    end
end)

-- Take screenshot
F:RegisterSlash('/ss', function()
    Screenshot()
end)

-- Mount special pose
F:RegisterSlash('/ms', function()
    if IsMounted() then
        DoEmote('MOUNTSPECIAL')
    else
        F:Print('You are |cffff2020NOT|r mounted.')
    end
end)

-- Set BattleNet broadcast
F:RegisterSlash('/bb', function(msg)
    BNSetCustomMessage(msg)
end)

-- Switch specialization
F:RegisterSlash('/spec', function(msg)
    local specID = tonumber(msg)
    if specID then
        local canUse, failureReason = C_SpecializationInfo.CanPlayerUseTalentSpecUI()
        if canUse then
            if GetSpecialization() ~= specID then
                SetSpecialization(specID)
            end
        else
            F:Print('|cffff2020' .. failureReason)
        end
    else
        F:Print('Please enter the |cffff2020SPECIALIZATION NUMBER|r.')
    end
end)

-- Whisper current target
hooksecurefunc('ChatEdit_OnSpacePressed', function(editBox)
    if
        editBox:GetText():sub(1, 3) == '/tt'
        and (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target'))
    then
        editBox:SetText(_G.SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
        ChatEdit_ParseText(editBox, 0)
    end
end)

F:RegisterSlash('/tt', function(msg)
    if UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target') then
        SendChatMessage(msg, 'WHISPER', nil, GetUnitName('target', true))
    end
end)

-- Support cmd /way if TomTom disabled
do
    local pointString = C.INFO_COLOR
        .. '|Hworldmap:%d+:%d+:%d+|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a%s (%s, %s)%s]|h|r'

    local function GetCorrectCoord(x)
        x = tonumber(x)
        if x then
            if x > 100 then
                return 100
            elseif x < 0 then
                return 0
            end

            return x
        end
    end

    F:RegisterSlash('/way', function(msg)
        if IsAddOnLoaded('TomTom') then
            return
        end
        msg = string.gsub(msg, '(%d)[%.,] (%d)', '%1 %2')
        local x, y, z = string.match(msg, '(%S+)%s(%S+)(.*)')
        if x and y then
            local mapID = C_Map.GetBestMapForUnit('player')
            if mapID then
                local mapInfo = C_Map.GetMapInfo(mapID)
                local mapName = mapInfo and mapInfo.name
                if mapName then
                    x = GetCorrectCoord(x)
                    y = GetCorrectCoord(y)

                    if x and y then
                        print(string.format(pointString, mapID, x * 100, y * 100, mapName, x, y, z or ''))
                    end
                end
            end
        end
    end)
end

-- Clear chat
F:RegisterSlash('/clear', function()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        _G[string.format('ChatFrame%d', i)]:Clear()
    end
end)

-- Dev tool
F:RegisterSlash('/rl', function()
    ReloadUI()
end)

F:RegisterSlash('/fs', function()
    _G.UIParentLoadAddOn('Blizzard_DebugTools')
    _G.FrameStackTooltip_Toggle(false, true, true)
end)

-- Disable all addons except andromeda and debug tool
F:RegisterSlash('/debugmode', function()
    for i = 1, GetNumAddOns() do
        local name = GetAddOnInfo(i)
        if name ~= C.ADDON_NAME and name ~= '!BaudErrorFrame' and name ~= 'REHack' and GetAddOnEnableState(C.MY_NAME, name) == 2 then
            DisableAddOn(name, C.MY_NAME)
        end
    end
    _G.ReloadUI()
end)

-- Print NPC ID
local pattern = '%w+%-.-%-.-%-.-%-.-%-(.-)%-'
local function GetNPCID(unit)
    if unit and UnitExists(unit) then
        local npcGUID = UnitGUID(unit)
        return npcGUID and (tonumber(npcGUID:match(pattern)))
    end
end

F:RegisterSlash('/npcid', function()
    local npcID = GetNPCID('target')
    if npcID then
        local str = 'NPC ID: ' .. npcID
        F:Print(str)
    end
end)

-- Print quest info
F:RegisterSlash('/questid', function(msg)
    local questID = tonumber(msg)
    if questID then
        local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(questID)
        local status = isCompleted and '|cff20ff20COMPLETE|r' or '|cffff2020NOT complete|r'
        local str = 'Quest |cffe9c55d' .. questID .. '|r is ' .. status

        F:Print(str)
    end
end)

-- Print map info
F:RegisterSlash('/mapid', function()
    local mapID
    if _G.WorldMapFrame:IsShown() then
        mapID = _G.WorldMapFrame:GetMapID()
    else
        mapID = C_Map.GetBestMapForUnit('player')
    end

    F:Printf('Map ID: |cffe9c55d%s|r (%s)', mapID, C_Map.GetMapInfo(mapID).name)
end)

-- Print instance info
F:RegisterSlash('/instinfo', function()
    local name, instanceType, difficultyID, difficultyName, _, _, _, instanceMapID = GetInstanceInfo()
    F:Print(C.LINE_STRING)
    F:Print('Name ' .. C.INFO_COLOR .. name)
    F:Print('instanceType ' .. C.INFO_COLOR .. instanceType)
    F:Print('difficultyID ' .. C.INFO_COLOR .. difficultyID)
    F:Print('difficultyName ' .. C.INFO_COLOR .. difficultyName)
    F:Print('instanceMapID ' .. C.INFO_COLOR .. instanceMapID)
    F:Print(C.LINE_STRING)
end)

-- Print item info
F:RegisterSlash('/iteminfo', function(msg)
    local itemID = tonumber(msg)
    if itemID then
        local name, link, rarity, level, minLevel, type, subType, _, _, _, _, classID, subClassID, bindType =
            GetItemInfo(
                itemID
            )
        if name then
            F:Print(C.LINE_STRING)
            F:Print('Name ' .. C.INFO_COLOR .. name)
            F:Print('Link ' .. link)
            F:Print('Rarity ' .. C.INFO_COLOR .. rarity)
            F:Print('Level ' .. C.INFO_COLOR .. level)
            F:Print('MinLevel ' .. C.INFO_COLOR .. minLevel)
            F:Print('Type ' .. C.INFO_COLOR .. type)
            F:Print('SubType ' .. C.INFO_COLOR .. subType)
            F:Print('ClassID ' .. C.INFO_COLOR .. classID)
            F:Print('SubClassID ' .. C.INFO_COLOR .. subClassID)
            F:Print('BindType ' .. C.INFO_COLOR .. bindType)
            F:Print(C.LINE_STRING)
        else
            F:Print('Item ' .. itemID .. ' |cffff2020NOT found|r')
        end
    end
end)

-- Print item info
F:RegisterSlash('/scaleinfo', function()
    F:Print(C.LINE_STRING)
    F:Print('C.SCREEN_WIDTH ' .. C.SCREEN_WIDTH)
    F:Print('C.SCREEN_HEIGHT ' .. C.SCREEN_HEIGHT)
    F:Print('C.MULT ' .. C.MULT)
    F:Print('UIScale ' .. _G.ANDROMEDA_ADB.UIScale)
    F:Print('UIParentScale ' .. _G.UIParent:GetScale())
    F:Print(C.LINE_STRING)
end)

-- DBM test
F:RegisterSlash('/dbmtest', function()
    if IsAddOnLoaded('DBM-Core') then
        _G.DBM:DemoMode()
    else
        F:Print(C.RED_COLOR .. 'DBM is not loaded.')
    end
end)

--[[ do
    local sortedKeys = {}
    for k in pairs(tempTable) do
        sortedKeys[#sortedKeys + 1] = k
    end
    table.sort(sortedKeys)
    for i, k in ipairs(sortedKeys) do
        local v = tempTable[k]
        F:Print(k, v)
    end
end ]]
