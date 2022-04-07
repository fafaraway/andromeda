local F, C, L = unpack(select(2, ...))

local cmdList = {
    '/free install - Open installation panel',
    '/free config - Open config panel',
    '/free unlock - Unlock the interface to let you easily move elements',
    '/free reset - Reset all saved options to their default values.',
    '/disband - Disband group',
    '/convert - Convert party/raid',
    '/reset - Reset instance',
    '/rdc or /ready - Ready check',
    '/rpc or /role - Role check',
    '/lg - Leave group',
    '/rl or /reload - Reload interface',
    '/ss - Take a screenshot',
    '/clear - Clear chat',
    '/bb - Set BattleNet broadcast',
    '/spec - Switch specialization',
    '/bind - Launch quick keybind mode',
}

local function CreateHelpFrame()
    local f = CreateFrame('Frame', 'FreeUIHelpFrame', _G.UIParent, 'BackdropTemplate')
    f:SetSize(400, 400)
    f:SetPoint('CENTER')
    f:SetFrameStrata('HIGH')
    F.SetBD(f)
end

local function Commands()
    -- for _, v in ipairs(cmdList) do
    --     local command, desc = string.split('-', tostring(v))
    --     print(string.format('%s|r - %s|r', C.YELLOW_COLOR .. command, C.BLUE_COLOR .. desc))
    -- end

end

local function Version()
    print(string.format(C.ADDON_NAME .. C.CLASS_COLOR .. '%s', C.ADDON_VERSION))
end

local function Reset()
    _G.StaticPopup_Show('FREEUI_RESET_ALL')
end

local function Install()
    F:GetModule('Installation'):HelloWorld()
end

local function Unlock()
    F:MoverConsole()
end

local function GUI()
    F.ToggleGUI()
end

-- _G.SlashCmdList.FREEUI = function(str)
--     local cmd, _ = string.split(' ', str:lower(), 2)
--     if cmd == 'reset' then
--         Reset()
--     elseif cmd == 'install' then
--         Install()
--     elseif cmd == 'unlock' or cmd == 'layout' then
--         Unlock()
--     elseif cmd == 'gui' or cmd == 'config' then
--         GUI()
--     elseif cmd == 'help' then
--         Commands()
--     elseif cmd == 'ver' or cmd == 'version' then
--         Version()
--     else
--         Commands()
--     end
-- end
-- _G.SLASH_FREEUI1 = '/freeui'
-- _G.SLASH_FREEUI2 = '/free'

F:RegisterSlash('/free', function(msg)
    local str, _ = string.split(' ', string.lower(msg), 2)
    if str == 'reset' then
        Reset()
    elseif str == 'install' then
        Install()
    elseif str == 'unlock' or str == 'layout' then
        Unlock()
    elseif str == 'gui' or str == 'config' then
        GUI()
    elseif str == 'help' then
        Commands()
    elseif str == 'ver' or str == 'version' then
        Version()
    else
        Commands()
    end
end)

-- Disable all addons except FreeUI and debug tool
F:RegisterSlash('/onlyfree', function()
    for i = 1, GetNumAddOns() do
        local name = GetAddOnInfo(i)
        if name ~= 'FreeUI' and name ~= '!BaudErrorFrame' and GetAddOnEnableState(C.NAME, name) == 2 then
            DisableAddOn(name, C.NAME)
        end
    end
    _G.ReloadUI()
end)

--	Disband party or raid
F:RegisterSlash('/disband', function()
    StaticPopup_Show('FREEUI_DISBAND_GROUP')
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

F:RegisterSlash('/rdc', function()
    DoReadyCheck()
end)

F:RegisterSlash('/role', function()
    InitiateRolePoll()
end)

F:RegisterSlash('/ri', function()
    ResetInstances()
end)

F:RegisterSlash('/tp', function()
    if IsInInstance() then
        LFGTeleport(true)
    else
        LFGTeleport()
    end
end)

F:RegisterSlash('/lg', function()
    C_PartyInfo.LeaveParty()
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
    if editBox:GetText():sub(1, 3) == '/tt' and (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target')) then
        editBox:SetText(_G.SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
        ChatEdit_ParseText(editBox, 0)
    end
end)

F:RegisterSlash('/tt', function(msg)
    if UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target') then
        SendChatMessage(msg, 'WHISPER', nil, GetUnitName('target', true))
    end
end)

-- Clear chat
F:RegisterSlash('/clear', function()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        _G[string.format('ChatFrame%d', i)]:Clear()
    end
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
    if WorldMapFrame:IsShown() then
        mapID = WorldMapFrame:GetMapID()
    else
        mapID = C_Map.GetBestMapForUnit('player')
    end
    local str = 'Map ID: |cffe9c55d' .. mapID .. '|r - ' .. C_Map.GetMapInfo(mapID).name

    F:Print(str)
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
        local name, link, rarity, level, minLevel, type, subType, _, _, _, _, classID, subClassID, bindType = GetItemInfo(itemID)
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
    F:Print('C.ScreenWidth ' .. C.ScreenWidth)
    F:Print('C.ScreenHeight ' .. C.ScreenHeight)
    F:Print('C.MULT ' .. C.MULT)
    F:Print('UIScale ' .. _G.FREE_ADB.UIScale)
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

-- Dev tool
F:RegisterSlash('/rl', function()
    ReloadUI()
end)

F:RegisterSlash('/fs', function()
    _G.UIParentLoadAddOn('Blizzard_DebugTools')
    _G.FrameStackTooltip_Toggle(false, true, true)
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
