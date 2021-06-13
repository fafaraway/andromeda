local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local format = format
local strsplit = strsplit
local ReloadUI = ReloadUI
local GetAutoCompleteRealms = GetAutoCompleteRealms
local GetMoney = GetMoney
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local InCombatLockdown = InCombatLockdown
local IsInRaid = IsInRaid
local UninviteUnit = UninviteUnit
local UnitExists = UnitExists
local UnitName = UnitName
local LeaveParty = LeaveParty
local SendChatMessage = SendChatMessage

local F, C, L = unpack(select(2, ...))

--[[ Layout ]]
_G.StaticPopupDialogs.FREEUI_RESET_LAYOUT = {
    text = L['|cffff2020Are you sure to reset the Interface Layout?|r'],
    button1 = _G.OKAY,
    button2 = _G.CANCEL,
    OnAccept = function()
        wipe(C.DB.UIAnchor)
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

--[[ GUI ]]
_G.StaticPopupDialogs.FREEUI_RELOADUI = {
    text = L['|cffff2020Are you sure to reload the Interface to apply settings?|r'],
    button1 = _G.APPLY,
    button2 = _G.CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
    OnAccept = function()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true
}

_G.StaticPopupDialogs.FREEUI_RESET_MAJOR_SPELLS = {
    text = C.RedColor .. L['|cffff2020Are you sure to restore default Major Spells List?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_ADB['NPMajorSpells'] = {}
        ReloadUI()
    end,
    whileDead = 1
}

_G.StaticPopupDialogs.FREEUI_RESET_ANNOUNCEABLE_SPELLS = {
    text = C.RedColor .. L['|cffff2020Are you sure to restore default Announceable Spells List?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_ADB['AnnounceableSpellsList'] = {}
        ReloadUI()
    end,
    whileDead = 1
}

_G.StaticPopupDialogs.FREEUI_RESET_PARTY_SPELLS = {
    text = C.RedColor .. L['|cffff2020Are you sure to restore default Party Spells List?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        wipe(_G.FREE_ADB['PartySpellsList'])
        ReloadUI()
    end,
    whileDead = 1
}

_G.StaticPopupDialogs.FREEUI_RESET_RAID_DEBUFFS = {
    text = C.RedColor .. L['|cffff2020Are you sure to restore default Raid Debuffs List?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_ADB['RaidDebuffsList'] = {}
        ReloadUI()
    end,
    whileDead = 1
}

--[[ Profile Management ]]
_G.StaticPopupDialogs.FREEUI_IMPORT_PROFILE = {
    text = L['|cffff2020Are you sure to import the settings?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        GUI:ImportData()
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

_G.StaticPopupDialogs.FREEUI_RESET_ALL = {
    text = L['|cffff2020Are you sure to reset ALL the settings?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_DB = {}
        _G.FREE_ADB = {}
        _G.FREE_PDB = {}
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

_G.StaticPopupDialogs.FREEUI_RESET_CURRENT_PROFILE = {
    text = L['|cffff2020Are you sure to reset your current profile?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        wipe(C.DB)
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

_G.StaticPopupDialogs.FREEUI_APPLY_PROFILE = {
    text = L['|cffff2020Are you sure to switch to the selected profile?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        _G.FREE_ADB['ProfileIndex'][C.MyFullName] = GUI.currentProfile
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

_G.StaticPopupDialogs.FREEUI_REPLACE_CURRENT_PROFILE = {
    text = L['|cffff2020Are you sure to replace your current profile with the selected one?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        local profileIndex = _G.FREE_ADB['ProfileIndex'][C.MyFullName]
        if GUI.currentProfile == 1 then
            _G.FREE_PDB[profileIndex - 1] = _G.FREE_DB
        elseif profileIndex == 1 then
            _G.FREE_DB = _G.FREE_PDB[GUI.currentProfile - 1]
        else
            _G.FREE_PDB[profileIndex - 1] = _G.FREE_PDB[GUI.currentProfile - 1]
        end
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

_G.StaticPopupDialogs.FREEUI_REPLACE_SELECTED_PROFILE = {
    text = L['|cffff2020Are you sure to replace the selected profile with your current one?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        if GUI.currentProfile == 1 then
            _G.FREE_DB = C.DB
        else
            _G.FREE_PDB[GUI.currentProfile - 1] = C.DB
        end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

_G.StaticPopupDialogs.FREEUI_DELETE_UNIT_PROFILE = {
    text = '',
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function(self)
        local name, realm = strsplit('-', self.text.text_arg1)
        if _G.FREE_ADB['GoldStatistic'][realm] and _G.FREE_ADB['GoldStatistic'][realm][name] then
            _G.FREE_ADB['GoldStatistic'][realm][name] = nil
        end
        _G.FREE_ADB['ProfileIndex'][self.text.text_arg1] = nil
    end,
    OnShow = function(self)
        local r, g, b
        local class = self.text.text_arg2
        if class == 'NONE' then
            r, g, b = .5, .5, .5
        else
            r, g, b = F:ClassColor(class)
        end
        self.text:SetText(format(L['|cffff2020Are you sure to delete %s%s|r profile?|r'], F.HexRGB(r, g, b), self.text.text_arg1))
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false
}

--[[ Infobar Gold Statistics ]]
local crossRealms = GetAutoCompleteRealms()
if not crossRealms or #crossRealms == 0 then
    crossRealms = {[1] = C.MyRealm}
end

_G.StaticPopupDialogs.FREEUI_RESET_GOLD = {
    text = L['|cffff2020Are you sure to reset All Gold Statistics?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        for _, realm in pairs(crossRealms) do
            if _G.FREE_ADB['GoldStatistic'][realm] then
                wipe(_G.FREE_ADB['GoldStatistic'][realm])
            end
        end

        _G.FREE_ADB['GoldStatistic'][C.MyRealm][C.MyName] = {GetMoney(), C.MyClass}
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true
}

--[[ Inventory Custom Junk List ]]
_G.StaticPopupDialogs.FREEUI_RESET_JUNK_LIST = {
    text = L['|cffff2020Are you sure to reset Junk Items List?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        wipe(_G.FREE_ADB.CustomJunkList)
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true
}

--[[ Group Tool ]]
_G.StaticPopupDialogs['FREEUI_DISBAND_GROUP'] = {
    text = L['|cffff2020Are you sure to disband your group?|r'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        if InCombatLockdown() then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. _G.ERR_NOT_IN_COMBAT)
            return
        end
        if IsInRaid() then
            SendChatMessage(_G.TEAM_DISBAND .. '...', 'RAID')
            for i = 1, GetNumGroupMembers() do
                local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                if online and name ~= C.MyName then
                    UninviteUnit(name)
                end
            end
        else
            for i = _G.MAX_PARTY_MEMBERS, 1, -1 do
                if UnitExists('party' .. i) then
                    UninviteUnit(UnitName('party' .. i))
                end
            end
        end
        LeaveParty()
    end,
    timeout = 0,
    whileDead = 1
}
