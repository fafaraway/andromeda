local F, C, L = unpack(select(2, ...))

_G.SlashCmdList.RELOADUI = function()
    _G.ReloadUI()
end
_G.SLASH_RELOADUI1 = '/rl'
_G.SLASH_RELOADUI2 = '/reload'

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
    '/bind - Launch quick keybind mode'
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
    --     print(string.format('%s|r - %s|r', C.YellowColor .. command, C.BlueColor .. desc))
    -- end

    CreateHelpFrame()
end

local function Version()
    print(string.format(C.AddonName .. C.MyColor.. '%s', C.AddonVersion))
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

_G.SlashCmdList.FREEUI = function(str)
    local cmd, _ = string.split(' ', str:lower(), 2)
    if cmd == 'reset' then
        Reset()
    elseif cmd == 'install' then
        Install()
    elseif cmd == 'unlock' or cmd == 'layout' then
        Unlock()
    elseif cmd == 'gui' or cmd == 'config' then
        GUI()
    elseif cmd == 'help' then
        Commands()
    elseif cmd == 'ver' or cmd == 'version' then
        Version()
    else
        Commands()
    end
end
_G.SLASH_FREEUI1 = '/freeui'
_G.SLASH_FREEUI2 = '/free'

--	Enable/Disable addons
_G.SlashCmdList.DISABLE_ADDON = function(addon)
    local _, _, _, _, _, reason = GetAddOnInfo(addon)
    if reason ~= 'MISSING' then
        DisableAddOn(addon)
        _G.ReloadUI()
    else
        print('|cffffff00' .. L['Addon'] .. "'" .. addon .. "'" .. L['not found'] .. '|r')
    end
end
_G.SLASH_DISABLE_ADDON1 = '/dis'
_G.SLASH_DISABLE_ADDON2 = '/disable'

_G.SlashCmdList.ENABLE_ADDON = function(addon)
    local _, _, _, _, _, reason = GetAddOnInfo(addon)
    if reason ~= 'MISSING' then
        EnableAddOn(addon)
        LoadAddOn(addon)
        _G.ReloadUI()
    else
        print('|cffffff00' .. L['Addon'] .. " '" .. addon .. "' " .. L['not found'] .. '|r')
    end
end
_G.SLASH_ENABLE_ADDON1 = '/en'
_G.SLASH_ENABLE_ADDON2 = '/enable'

_G.SlashCmdList.ONLY_UI = function()
    for i = 1, GetNumAddOns() do
        local name = GetAddOnInfo(i)
        if name ~= 'FreeUI' and name ~= '!BaudErrorFrame' and GetAddOnEnableState(C.MyName, name) == 2 then
            DisableAddOn(name, C.MyName)
        end
    end
    _G.ReloadUI()
end
_G.SLASH_ONLY_UI1 = '/onlyfree'

-- [[ group ]] --

--	Disband party or raid
_G.SlashCmdList.GROUPDISBAND = function()
    _G.StaticPopup_Show('FREEUI_DISBAND_GROUP')
end
_G.SLASH_GROUPDISBAND1 = '/disband'

--	Convert party raid
_G.SlashCmdList.PARTYTORAID = function()
    if GetNumGroupMembers() > 0 then
        if UnitInRaid('player') and (UnitIsGroupLeader('player')) then
            C_PartyInfo.ConvertToParty()
        elseif UnitInParty('player') and (UnitIsGroupLeader('player')) then
            C_PartyInfo.ConvertToRaid()
        end
    else
        print('|cffffff00' .. _G.ERR_NOT_IN_GROUP .. '|r')
    end
end
_G.SLASH_PARTYTORAID1 = '/toraid'
_G.SLASH_PARTYTORAID2 = '/toparty'
_G.SLASH_PARTYTORAID3 = '/convert'

-- Instance reset
_G.SlashCmdList.INSTRESET = function()
    ResetInstances()
end
_G.SLASH_INSTRESET1 = '/reset'

-- Instance teleport
_G.SlashCmdList.INSTTELEPORT = function()
    local inInstance = IsInInstance()
    if inInstance then
        LFGTeleport(true)
    else
        LFGTeleport()
    end
end
_G.SLASH_INSTTELEPORT1 = '/tp'

_G.SlashCmdList.READYCHECK = function()
    DoReadyCheck()
end
_G.SLASH_READYCHECK1 = '/rdc'
_G.SLASH_READYCHECK2 = '/ready'

_G.SlashCmdList.ROLECHECK = function()
    InitiateRolePoll()
end
_G.SLASH_ROLECHECK1 = '/rpc'
_G.SLASH_ROLECHECK2 = '/role'

_G.SlashCmdList.LEAVEGROUP = function()
    C_PartyInfo.LeaveParty()
end
_G.SLASH_LEAVEGROUP1 = '/lg'
_G.SLASH_LEAVEGROUP2 = '/leave'

--[[ misc ]]
-- Take screenshot
_G.SlashCmdList.SCREENSHOT = function()
    Screenshot()
end
_G.SLASH_SCREENSHOT1 = '/ss'

-- Clear chat
_G.SlashCmdList.CLEARCHAT = function()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        _G[string.format('ChatFrame%d', i)]:Clear()
    end
end
_G.SLASH_CLEARCHAT1 = '/clear'

-- Mount special pose
_G.SlashCmdList.MOUNTSPECIAL = function()
    if GetUnitSpeed('player') == 0 then
        DoEmote('MOUNTSPECIAL')
    end
end
_G.SLASH_MOUNTSPECIAL1 = '/ms'

-- Set BattleNet broadcast
_G.SlashCmdList.BNBROADCAST = function(msg)
    BNSetCustomMessage(msg)
end
_G.SLASH_BNBROADCAST1 = '/bb'

-- Switch specialization
_G.SlashCmdList.SPEC = function(spec)
    local canUse, failureReason = C_SpecializationInfo.CanPlayerUseTalentSpecUI()
    if canUse then
        if GetSpecialization() ~= tonumber(spec) then
            SetSpecialization(spec)
        end
    else
        print('|cffffff00' .. failureReason .. '|r')
    end
end
_G.SLASH_SPEC1 = '/spec'

-- Whisper target
hooksecurefunc(
    'ChatEdit_OnSpacePressed',
    function(self)
        if (string.sub(self:GetText(), 1, 3) == '/tt' and (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target'))) then
            self:SetText(_G.SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
            _G.ChatEdit_ParseText(self, 0)
        end
    end
)

_G.SLASH_WHISPERTARGET1 = '/tt'
_G.SlashCmdList.WHISPERTARGET = function(str)
    if (UnitCanCooperate('player', 'target')) then
        SendChatMessage(str, 'WHISPER', GetDefaultLanguage('player'), GetUnitName('target', true):gsub(' ', ''))
    end
end
