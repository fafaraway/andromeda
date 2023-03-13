local F, C, L = unpack(select(2, ...))
local IN = F:RegisterModule('IgnoreNote')

local unitName
local noteTex = 'Interface\\Buttons\\UI-GuildButton-PublicNote-Up'
local noteStr = '|T' .. noteTex .. ':12|t %s'

local function getButtonName(button)
    local name = button.name:GetText()
    if not name then
        return
    end
    if not strmatch(name, '-') then
        name = name .. '-' .. C.MY_REALM
    end
    return name
end

function IN:IgnoreButton_OnClick()
    unitName = getButtonName(self)
    StaticPopup_Show('ANDROMEDA_IGNORE_NOTE', unitName)
end

function IN:IgnoreButton_OnEnter()
    local name = getButtonName(self)
    local savedNote = _G.ANDROMEDA_ADB['IgnoreNotesList'][name]
    if savedNote then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_NONE')
        _G.GameTooltip:SetPoint('TOPLEFT', self, 'TOPRIGHT', 35, 0)
        _G.GameTooltip:ClearLines()
        _G.GameTooltip:AddLine(name)
        _G.GameTooltip:AddLine(format(noteStr, savedNote), 1, 1, 1, 1)
        _G.GameTooltip:Show()
    end
end

function IN:IgnoreButton_Hook()
    if self.Title then
        return
    end

    if not self.hooked then
        self.name:SetFontObject(_G.Game14Font)
        self:HookScript('OnDoubleClick', IN.IgnoreButton_OnClick)
        self:HookScript('OnEnter', IN.IgnoreButton_OnEnter)
        self:HookScript('OnLeave', F.HideTooltip)

        self.noteTex = self:CreateTexture()
        self.noteTex:SetSize(16, 16)
        self.noteTex:SetTexture(noteTex)
        self.noteTex:SetPoint('RIGHT', -5, 0)

        self.hooked = true
    end

    self.noteTex:SetShown(_G.ANDROMEDA_ADB['IgnoreNotesList'][getButtonName(self)])
end

StaticPopupDialogs['ANDROMEDA_IGNORE_NOTE'] = {
    text = _G.SET_FRIENDNOTE_LABEL,
    button1 = _G.OKAY,
    button2 = _G.CANCEL,
    OnShow = function(self)
        local savedNote = _G.ANDROMEDA_ADB['IgnoreNotesList'][unitName]
        if savedNote then
            self.editBox:SetText(savedNote)
            self.editBox:HighlightText()
        end
    end,
    OnAccept = function(self)
        local text = self.editBox:GetText()
        if text and text ~= '' then
            _G.ANDROMEDA_ADB['IgnoreNotesList'][unitName] = text
        else
            _G.ANDROMEDA_ADB['IgnoreNotesList'][unitName] = nil
        end
    end,
    EditBoxOnEscapePressed = function(editBox)
        editBox:GetParent():Hide()
    end,
    EditBoxOnEnterPressed = function(editBox)
        local text = editBox:GetText()
        if text and text ~= '' then
            _G.ANDROMEDA_ADB['IgnoreNotesList'][unitName] = text
        else
            _G.ANDROMEDA_ADB['IgnoreNotesList'][unitName] = nil
        end
        editBox:GetParent():Hide()
    end,
    whileDead = 1,
    hasEditBox = 1,
    editBoxWidth = 250,
}

function IN:OnLogin()
    local ignoreHelpInfo = {
        text = L['You can add note for ignore list by double click.'],
        buttonStyle = _G.HelpTip.ButtonStyle.GotIt,
        targetPoint = _G.HelpTip.Point.RightEdgeCenter,
        onAcknowledgeCallback = F.HelpInfoAcknowledge,
        callbackArg = 'IgnoreNote',
    }

    _G.IgnoreListFrame:HookScript('OnShow', function(frame)
        if not _G.ANDROMEDA_ADB['HelpTips']['IgnoreNote'] then
            _G.HelpTip:Show(frame, ignoreHelpInfo)
        end
    end)

    hooksecurefunc(_G.IgnoreListFrame.ScrollBox, 'Update', function(self)
        self:ForEachFrame(IN.IgnoreButton_Hook)
    end)

    _G.FriendsFrameUnsquelchButton:HookScript('OnClick', function()
        local name = C_FriendList.GetIgnoreName(C_FriendList.GetSelectedIgnore())
        if name then
            if not strmatch(name, '-') then
                name = name .. '-' .. C.MY_REALM
            end
            _G.ANDROMEDA_ADB['IgnoreNotesList'][name] = nil
        end
    end)
end
