local F, C, L = unpack(select(2, ...))

StaticPopupDialogs.FREEUI_RELOADUI_REQUIRED = {
    text = C.RED_COLOR .. L['ReloadUI Required'],
    button1 = _G.APPLY,
    button2 = _G.CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
    OnAccept = function()
        ReloadUI()
    end,
    whileDead = 1,
}

-- Layout
StaticPopupDialogs.FREEUI_RESET_LAYOUT = {
    text = C.RED_COLOR .. L['Are you sure to reset the Interface Layout?'],
    button1 = _G.OKAY,
    button2 = _G.CANCEL,
    OnAccept = function()
        table.wipe(C.DB.UIAnchor)
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

-- GUI
StaticPopupDialogs.FREEUI_RELOADUI = {
    text = C.RED_COLOR .. L['Are you sure to reload the Interface to apply settings?'],
    button1 = _G.APPLY,
    button2 = _G.CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
    OnAccept = function()
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
}

StaticPopupDialogs.FREEUI_RESET_MAJOR_SPELLS = {
    text = C.RED_COLOR .. L['Are you sure to restore default Major Spells List?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_ADB['NPMajorSpells'] = {}
        _G.ReloadUI()
    end,
    whileDead = 1,
}

StaticPopupDialogs.FREEUI_RESET_ANNOUNCEABLE_SPELLS = {
    text = C.RED_COLOR .. L['Are you sure to restore default Announceable Spells List?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_ADB['AnnounceableSpellsList'] = {}
        _G.ReloadUI()
    end,
    whileDead = 1,
}

StaticPopupDialogs.FREEUI_RESET_PARTY_SPELLS = {
    text = C.RED_COLOR .. L['Are you sure to restore default Party Spells List?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        table.wipe(_G.FREE_ADB['PartySpellsList'])
        _G.ReloadUI()
    end,
    whileDead = 1,
}

StaticPopupDialogs.FREEUI_RESET_RAID_DEBUFFS = {
    text = C.RED_COLOR .. L['Are you sure to restore default Raid Debuffs List?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_ADB['DebuffWatcherList'] = {}
        _G.ReloadUI()
    end,
    whileDead = 1,
}

StaticPopupDialogs['FREEUI_RESET_NAMEPLATE_SPECIAL_UNIT_FILTER'] = {
    text = L['Reset to default list?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        C.DB['Nameplate']['SpecialUnitsList'] = {}
        ReloadUI()
    end,
    whileDead = 1,
}

StaticPopupDialogs['FREEUI_RESET_NAMEPLATE_DOT_SPELLS'] = {
    text = L['Reset to default list?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        C.DB['Nameplate']['DotSpellsList'] = {}
        ReloadUI()
    end,
    whileDead = 1,
}

-- Profile Management
StaticPopupDialogs.FREEUI_IMPORT_PROFILE = {
    text = C.RED_COLOR .. L['Are you sure to import the settings?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        GUI:ImportData()
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

StaticPopupDialogs.FREEUI_RESET_ALL = {
    text = C.RED_COLOR .. L['Are you sure to reset ALL the settings?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        _G.FREE_DB = {}
        _G.FREE_ADB = {}
        _G.FREE_PDB = {}
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

StaticPopupDialogs.FREEUI_RESET_CURRENT_PROFILE = {
    text = C.RED_COLOR .. L['Are you sure to reset your current profile?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        table.wipe(C.DB)
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

StaticPopupDialogs.FREEUI_APPLY_PROFILE = {
    text = C.RED_COLOR .. L['Are you sure to switch to the selected profile?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        _G.FREE_ADB['ProfileIndex'][C.MY_FULL_NAME] = GUI.currentProfile
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

StaticPopupDialogs.FREEUI_REPLACE_CURRENT_PROFILE = {
    text = C.RED_COLOR .. L['Are you sure to replace your current profile with the selected one?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        local GUI = F:GetModule('GUI')
        local profileIndex = _G.FREE_ADB['ProfileIndex'][C.MY_FULL_NAME]
        if GUI.currentProfile == 1 then
            _G.FREE_PDB[profileIndex - 1] = _G.FREE_DB
        elseif profileIndex == 1 then
            _G.FREE_DB = _G.FREE_PDB[GUI.currentProfile - 1]
        else
            _G.FREE_PDB[profileIndex - 1] = _G.FREE_PDB[GUI.currentProfile - 1]
        end
        _G.ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

StaticPopupDialogs.FREEUI_REPLACE_SELECTED_PROFILE = {
    text = C.RED_COLOR .. L['Are you sure to replace the selected profile with your current one?'],
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
    hideOnEscape = false,
}

StaticPopupDialogs.FREEUI_DELETE_UNIT_PROFILE = {
    text = '',
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function(self)
        local name, realm = string.split('-', self.text.text_arg1)
        if _G.FREE_ADB['GoldStatistic'][realm] and _G.FREE_ADB['GoldStatistic'][realm][name] then
            _G.FREE_ADB['GoldStatistic'][realm][name] = nil
        end
        _G.FREE_ADB['ProfileIndex'][self.text.text_arg1] = nil
    end,
    OnShow = function(self)
        local r, g, b
        local class = self.text.text_arg2
        if class == 'NONE' then
            r, g, b = 0.5, 0.5, 0.5
        else
            r, g, b = F:ClassColor(class)
        end
        self.text:SetText(
            string.format(
                C.RED_COLOR .. L['Are you sure to delete %s%s|r profile?'],
                F:RgbToHex(r, g, b),
                self.text.text_arg1
            )
        )
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = false,
}

-- Inventory Custom Junk List
StaticPopupDialogs.FREEUI_RESET_JUNK_LIST = {
    text = C.RED_COLOR .. L['Are you sure to reset Junk Items List?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        table.wipe(_G.FREE_ADB.CustomJunkList)
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
}

-- Group Tool
StaticPopupDialogs['FREEUI_DISBAND_GROUP'] = {
    text = C.RED_COLOR .. L['Are you sure to disband your group?'],
    button1 = _G.YES,
    button2 = _G.NO,
    OnAccept = function()
        if InCombatLockdown() then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. _G.ERR_NOT_IN_COMBAT)
            return
        end
        if IsInRaid() then
            SendChatMessage(_G.TEAM_DISBAND .. '...', 'RAID')
            for i = 1, GetNumGroupMembers() do
                local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                if online and name ~= C.MY_NAME then
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
        C_PartyInfo.LeaveParty()
    end,
    timeout = 0,
    whileDead = 1,
}
