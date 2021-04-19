local _G = _G
local unpack = unpack
local select = select
local strsplit = strsplit
local format = format
local ReloadUI = ReloadUI
local GetAddOnInfo = GetAddOnInfo
local DisableAddOn = DisableAddOn
local EnableAddOn = EnableAddOn
local LoadAddOn = LoadAddOn
local GetNumAddOns = GetNumAddOns
local GetAddOnEnableState = GetAddOnEnableState
local InCombatLockdown = InCombatLockdown
local StaticPopup_Show = StaticPopup_Show
local UnitInRaid = UnitInRaid
local UninviteUnit = UninviteUnit
local UnitName = UnitName
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitInParty = UnitInParty
local UnitCanCooperate = UnitCanCooperate
local UnitIsUnit = UnitIsUnit
local SendChatMessage = SendChatMessage
local GetUnitName = GetUnitName
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local C_PartyInfo_LeaveParty = C_PartyInfo.LeaveParty
local C_PartyInfo_ConvertToParty = C_PartyInfo.ConvertToParty
local C_PartyInfo_ConvertToRaid = C_PartyInfo.ConvertToRaid
local C_SpecializationInfo_CanPlayerUseTalentSpecUI = C_SpecializationInfo.CanPlayerUseTalentSpecUI
local ResetInstances = ResetInstances
local IsInInstance = IsInInstance
local LFGTeleport = LFGTeleport
local DoReadyCheck = DoReadyCheck
local InitiateRolePoll = InitiateRolePoll
local Screenshot = Screenshot
local GetUnitSpeed = GetUnitSpeed
local DoEmote = DoEmote
local BNSetCustomMessage = BNSetCustomMessage
local GetSpecialization = GetSpecialization
local SetSpecialization = SetSpecialization
local hooksecurefunc = hooksecurefunc
local ChatEdit_ParseText = ChatEdit_ParseText
local GetDefaultLanguage = GetDefaultLanguage
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local ERR_NOT_IN_GROUP = ERR_NOT_IN_GROUP
local ACCEPT = ACCEPT
local CANCEL = CANCEL

local F, C, L = unpack(select(2, ...))
local INSTALL = F.INSTALL
local ACTIONBAR = F.ACTIONBAR
local LLL = F.Libs.ACL:GetLocale('FreeUI')

_G.SlashCmdList.RELOADUI = function()
    ReloadUI()
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
    '/bind - Launch quick keybind mode',
}

local function PrintCommand()
    for _, v in ipairs(cmdList) do
        local command, desc = strsplit('-', tostring(v))
        print(format('%s|r - %s|r', C.YellowColor .. command, C.BlueColor .. desc))
    end
end

_G.SlashCmdList.FREEUI = function(str)
    local cmd, _ = strsplit(' ', str:lower(), 2)
    if cmd == 'reset' then
        StaticPopup_Show('FREEUI_RESET')
    elseif cmd == 'install' then
        INSTALL:HelloWorld()
    elseif cmd == 'unlock' then
        F:MoverConsole()
    elseif cmd == 'config' then
        F.ToggleGUI()
    elseif cmd == 'help' then
        PrintCommand()
    elseif cmd == 'ver' or cmd == 'version' then
        F:Print(C.AddonVersion)
    else
        PrintCommand()
    end
end
_G.SLASH_FREEUI1 = '/freeui'
_G.SLASH_FREEUI2 = '/free'

--	Enable/Disable addons
_G.SlashCmdList.DISABLE_ADDON = function(addon)
    local _, _, _, _, _, reason = GetAddOnInfo(addon)
    if reason ~= 'MISSING' then
        DisableAddOn(addon)
        ReloadUI()
    else
        print('|cffffff00' .. LLL['addon'] .. '\'' .. addon .. '\'' .. LLL['not found'] .. '|r')
    end
end
_G.SLASH_DISABLE_ADDON1 = '/dis'
_G.SLASH_DISABLE_ADDON2 = '/disable'

_G.SlashCmdList.ENABLE_ADDON = function(addon)
    local _, _, _, _, _, reason = GetAddOnInfo(addon)
    if reason ~= 'MISSING' then
        EnableAddOn(addon)
        LoadAddOn(addon)
        ReloadUI()
    else
        print('|cffffff00' .. LLL['addon'] .. '\'' .. addon .. '\'' .. LLL['not found'] .. '|r')
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
    ReloadUI()
end
_G.SLASH_ONLY_UI1 = '/onlyfree'

-- [[ group ]] --

--	Disband party or raid
local function DisbandRaidGroup()
    if InCombatLockdown() then
        return
    end
    if UnitInRaid('player') then
        SendChatMessage(LLL['Disbanding group'], 'RAID')
        for i = 1, GetNumGroupMembers() do
            local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
            if online and name ~= C.MyName then
                UninviteUnit(name)
            end
        end
    else
        SendChatMessage(LLL['Disbanding group'], 'PARTY')
        for i = _G.MAX_PARTY_MEMBERS, 1, -1 do
            if GetNumGroupMembers(i) then
                UninviteUnit(UnitName('party' .. i))
            end
        end
    end
    C_PartyInfo_LeaveParty()
end

_G.StaticPopupDialogs.DISBAND_RAID = {
    text = LLL['Are you sure you want to disband the group?'],
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept = DisbandRaidGroup,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
    preferredIndex = 5,
}

_G.SlashCmdList.GROUPDISBAND = function()
    StaticPopup_Show('DISBAND_RAID')
end
_G.SLASH_GROUPDISBAND1 = '/disband'

--	Convert party raid
_G.SlashCmdList.PARTYTORAID = function()
    if GetNumGroupMembers() > 0 then
        if UnitInRaid('player') and (UnitIsGroupLeader('player')) then
            C_PartyInfo_ConvertToParty()
        elseif UnitInParty('player') and (UnitIsGroupLeader('player')) then
            C_PartyInfo_ConvertToRaid()
        end
    else
        print('|cffffff00' .. ERR_NOT_IN_GROUP .. '|r')
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
    C_PartyInfo_LeaveParty()
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
        _G[format('ChatFrame%d', i)]:Clear()
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
    local canUse, failureReason = C_SpecializationInfo_CanPlayerUseTalentSpecUI()
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
hooksecurefunc('ChatEdit_OnSpacePressed', function(self)
    if (string.sub(self:GetText(), 1, 3) == '/tt' and
        (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target'))) then
        self:SetText(_G.SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
        ChatEdit_ParseText(self, 0)
    end
end)

_G.SLASH_WHISPERTARGET1 = '/tt'
_G.SlashCmdList.WHISPERTARGET = function(str)
    if (UnitCanCooperate('player', 'target')) then
        SendChatMessage(str, 'WHISPER', GetDefaultLanguage('player'), GetUnitName('target', true):gsub(' ', ''))
    end
end
