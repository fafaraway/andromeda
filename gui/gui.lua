local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')

local guiTab = {}
local guiPage = {}
GUI.Tab = guiTab
GUI.Page = guiPage
GUI.NeedUIReload = nil

local tabsList = {
    L['General'],
    L['Notification'],
    L['Infobar'],
    L['Chat'],
    L['Aura'],
    L['Actionbar'],
    L['Combat'],
    L['Announcement'],
    L['Backpack'],
    L['Map'],
    L['Tooltip'],
    L['Unitframe'],
    L['Groupframe'],
    L['Nameplate'],
    L['Theme'],
    L['Profile'],
    L['Credit']
}

local iconsList = {
    'Interface\\ICONS\\Ability_BossDarkVindicator_AuraofContempt',
    'Interface\\ICONS\\Ability_Mage_ColdAsIce',
    'Interface\\ICONS\\Ability_Paladin_LightoftheMartyr',
    'Interface\\ICONS\\Spell_Shadow_Seduction',
    'Interface\\ICONS\\Spell_Shadow_Shadesofdarkness',
    'Interface\\ICONS\\Ability_Warrior_BloodFrenzy',
    'Interface\\ICONS\\Ability_Warrior_Challange',
    'Interface\\ICONS\\Ability_Warrior_RallyingCry',
    'Interface\\ICONS\\INV_Misc_Bag_30',
    'Interface\\ICONS\\Achievement_Ashran_Tourofduty',
    'Interface\\ICONS\\Ability_Priest_BindingPrayers',
    'Interface\\ICONS\\Spell_Priest_Pontifex',
    'Interface\\ICONS\\Ability_Mage_MassInvisibility',
    'Interface\\ICONS\\Ability_Paladin_BeaconsOfLight',
    'Interface\\ICONS\\Ability_Hunter_BeastWithin',
    'Interface\\ICONS\\INV_Misc_Blingtron',
    'Interface\\ICONS\\Raf-Icon'
}

GUI.TexturesList = {
    [1] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex', name = L['Default']},
    [2] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex', name = L['Gradient']},
    [3] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex', name = L['Flat']}
}

local function AddTextureToOption(parent, index)
    local tex = parent[index]:CreateTexture()
    tex:SetInside(nil, 4, 4)
    tex:SetTexture(GUI.TexturesList[index].texture)
    tex:SetVertexColor(.6, .6, .6)
end

local function UpdateValue(key, value, newValue)
    if key == 'ACCOUNT' then
        if newValue ~= nil then
            _G.FREE_ADB[value] = newValue
        else
            return _G.FREE_ADB[value]
        end
    else
        if newValue ~= nil then
            C.DB[key][value] = newValue
        else
            return C.DB[key][value]
        end
    end
end

local function CreateGearButton(self, name)
    local bu = CreateFrame('Button', name, self)
    bu:SetSize(20, 20)
    bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
    bu.Icon:SetAllPoints()
    bu.Icon:SetTexture(C.Assets.gear_tex)
    bu.Icon:SetVertexColor(.6, .6, .6)
    bu:SetHighlightTexture(C.Assets.gear_tex)

    return bu
end

local function CombatLockdown(event)
    if not _G.FreeUI_GUI then
        return
    end

    if event == 'PLAYER_REGEN_DISABLED' then
        if _G.FreeUI_GUI:IsShown() then
            _G.FreeUI_GUI:Hide()
            F:RegisterEvent('PLAYER_REGEN_ENABLED', CombatLockdown)
        end
    else
        _G.FreeUI_GUI:Show()
        F:UnregisterEvent(event, CombatLockdown)
    end
end

local function CheckUIReload(name)
    if not string.find(name, '%*') then
        GUI.NeedUIReload = true
    end
end

local function SelectTab(i)
    local r, g, b = C.r, C.g, C.b
    local gradStyle = _G.FREE_ADB.GradientStyle
    local buttonColor = _G.FREE_ADB.ButtonBackdropColor

    for num = 1, #tabsList do
        if num == i then
            if gradStyle then
                guiTab[num].__gradient:SetGradientAlpha('Vertical', 0, 0, 0, .25, r, g, b, .25)
            else
                guiTab[num].__gradient:SetVertexColor(r, g, b, .25)
            end
            guiTab[num].checked = true
            guiPage[num]:Show()
        else
            if gradStyle then
                guiTab[num].__gradient:SetGradientAlpha('Vertical', 0, 0, 0, .25, buttonColor.r, buttonColor.g, buttonColor.b, .25)
            else
                guiTab[num].__gradient:SetVertexColor(0, 0, 0, 0)
            end
            guiTab[num].checked = false
            guiPage[num]:Hide()
        end
    end
end

local function Tab_OnClick(self)
    PlaySound(_G.SOUNDKIT.GS_TITLE_OPTION_OK)
    SelectTab(self.index)
end

local function Tab_OnEnter(self)
    if self.checked then
        return
    end
end

local function Tab_OnLeave(self)
    if self.checked then
        return
    end
end

local function CreateTab(parent, i, name)
    local tab = CreateFrame('Button', nil, parent, 'BackdropTemplate')
    tab:SetSize(140, 26)
    F.Reskin(tab)
    tab.index = i
    tab:SetPoint('TOPLEFT', 10, -31 * i - 20)

    tab.icon = tab:CreateTexture(nil, 'OVERLAY')
    tab.icon:SetSize(20, 20)
    tab.icon:SetPoint('LEFT', tab, 3, 0)
    tab.icon:SetTexture(iconsList[i])
    F.ReskinIcon(tab.icon)

    tab.text = F.CreateFS(tab, C.Assets.Fonts.Bold, 13, nil, name, nil, true)
    tab.text:SetPoint('LEFT', tab.icon, 'RIGHT', 6, 0)

    tab:HookScript('OnEnter', Tab_OnEnter)
    tab:HookScript('OnLeave', Tab_OnLeave)
    tab:HookScript('OnClick', Tab_OnClick)

    return tab
end

local function Checkbox_OnClick(self)
    UpdateValue(self.__key, self.__value, self:GetChecked())
    CheckUIReload(self.__name)
    if self.__callback then
        self:__callback()
    end
end

local function Editbox_OnEscapePressed(self)
    self:SetText(UpdateValue(self.__key, self.__value))
end

local function Editbox_OnEnterPressed(self)
    UpdateValue(self.__key, self.__value, self:GetText())
    CheckUIReload(self.__name)
    if self.__callback then
        self:__callback()
    end
end

local function Slider_OnValueChanged(self, v)
    local current = F:Round(tonumber(v), 2)
    UpdateValue(self.__key, self.__value, current)
    CheckUIReload(self.__name)
    self.value:SetText(current)
    if self.__callback then
        self:__callback()
    end
end

local function updateDropdownSelection(self)
    local dd = self.__owner
    for i = 1, #dd.__options do
        local option = dd.options[i]
        if i == UpdateValue(dd.__key, dd.__value) then
            option:SetBackdropColor(C.r, C.g, C.b, .25)
            option.selected = true
        else
            option:SetBackdropColor(.1, .1, .1, .25)
            option.selected = false
        end
    end
end

local function updateDropdownClick(self)
    local dd = self.__owner
    UpdateValue(dd.__key, dd.__value, self.index)
    CheckUIReload(dd.__name)
    if dd.__callback then
        dd:__callback()
    end
end

local function CreateOption(i)
    local parent, offset = guiPage[i].child, 20

    for _, option in pairs(GUI.OptionsList[i]) do
        local optType, key, value, name, horizon, data, callback, tip = unpack(option)
        if optType == 1 then -- checkbox
            local cb = F.CreateCheckbox(parent, true, nil, true)
            cb:SetSize(20, 20)
            cb:SetHitRectInsets(-5, -5, -5, -5)

            if horizon then
                cb:SetPoint('TOPLEFT', 250, -offset + 35)
            else
                cb:SetPoint('TOPLEFT', 20, -offset)
                offset = offset + 35
            end

            cb.__key = key
            cb.__value = value
            cb.__name = name
            cb.__callback = callback

            cb.label = F.CreateFS(cb, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 22, -1)

            cb:SetChecked(UpdateValue(key, value))
            cb:SetScript('OnClick', Checkbox_OnClick)

            if data and type(data) == 'function' then
                local bu = CreateGearButton(parent)
                bu:SetPoint('LEFT', cb.label, 'RIGHT', -2, 1)
                bu:SetScript('OnClick', data)
            end

            if tip then
                cb.title = name
                F.AddTooltip(cb, 'ANCHOR_TOPLEFT', tip, 'BLUE', true)
            end
        elseif optType == 2 then -- editbox
            local eb = F.CreateEditBox(parent, 170, 24)
            eb:SetMaxLetters(999)

            if horizon then
                eb:SetPoint('TOPLEFT', 260, -offset + 45)
            else
                eb:SetPoint('TOPLEFT', 20, -offset - 25)
                offset = offset + 70
            end

            eb.__key = key
            eb.__value = value
            eb.__name = name
            eb.__callback = callback
            eb.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]

            eb.label = F.CreateFS(eb, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'CENTER', 0, 20)
            eb:SetText(UpdateValue(key, value))

            eb:HookScript('OnEscapePressed', Editbox_OnEscapePressed)
            eb:HookScript('OnEnterPressed', Editbox_OnEnterPressed)

            if tip then
                eb.title = name
                F.AddTooltip(eb, 'ANCHOR_TOPLEFT', tip, 'BLUE', true)
            end
        elseif optType == 3 then -- slider
            local min, max, step = unpack(data)

            local x, y
            if horizon then
                x, y = 250, -offset + 45
            else
                x, y = 15, -offset - 25
                offset = offset + 70
            end

            local s = F.CreateSlider(parent, name, min, max, step, x, y, 190)
            s.__key = key
            s.__value = value
            s.__name = name
            s.__callback = callback
            s.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]

            s:SetValue(UpdateValue(key, value))
            s:SetScript('OnValueChanged', Slider_OnValueChanged)

            s.value:SetText(F:Round(UpdateValue(key, value), 2))

            if tip then
                s.title = name
                F.AddTooltip(s, 'ANCHOR_TOPLEFT', tip, 'BLUE', true)
            end
        elseif optType == 4 then -- dropdown
            if value == 'TextureStyle' then
                for _, v in ipairs(GUI.TexturesList) do
                    table.insert(data, v.name)
                end
            end

            local dd = F.CreateDropDown(parent, 170, 20, data)
            if horizon then
                dd:SetPoint('TOPLEFT', 260, -offset + 35)
            else
                dd:SetPoint('TOPLEFT', 26, -offset - 35)
                offset = offset + 70
            end

            dd.Text:SetText(data[UpdateValue(key, value)])

            dd.__key = key
            dd.__value = value
            dd.__name = name
            dd.__options = data
            dd.__callback = callback
            dd.button.__owner = dd
            dd.button:HookScript('OnClick', updateDropdownSelection)

            for i = 1, #data do
                dd.options[i]:HookScript('OnClick', updateDropdownClick)
                if value == 'TextureStyle' then
                    AddTextureToOption(dd.options, i) -- texture preview
                end
            end

            dd.label = F.CreateFS(dd, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'CENTER', 0, 18)
            if tip then
                dd.title = name
                F.AddTooltip(dd, 'ANCHOR_RIGHT', tip, 'BLUE', true)
            end
        elseif optType == 5 then -- colorswatch
            local swatch = F.CreateColorSwatch(parent, name, UpdateValue(key, value))
            local width = 25 + (horizon or 0) * 115
            if horizon then
                swatch:SetPoint('TOPLEFT', width, -offset + 30)
            else
                swatch:SetPoint('TOPLEFT', width, -offset - 5)
                offset = offset + 35
            end

            swatch.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]
        else -- blank, no optType
            if not key then
                local line = F.SetGradient(parent, 'H', .5, .5, .5, .25, .25, 460, C.Mult)
                line:SetPoint('TOPLEFT', 20, -offset - 12)
            end
            offset = offset + 35
        end
    end

    local footer = CreateFrame('Frame', nil, parent) -- Fix bottom space
    footer:SetSize(20, 20)
    footer:SetPoint('TOPLEFT', 25, -offset)
end

local function ScrollBar_OnMouseWheel(self, delta)
    local scrollBar = self.ScrollBar
    scrollBar:SetValue(scrollBar:GetValue() - delta * 35)
end

local function CreateGUI()
    if _G.FreeUI_GUI then
        _G.FreeUI_GUI:Show()
        return
    end

    local guiFrame = CreateFrame('Frame', 'FreeUI_GUI', _G.UIParent)
    table.insert(_G.UISpecialFrames, 'FreeUI_GUI')
    guiFrame:SetSize(700, 640)
    guiFrame:SetPoint('CENTER')
    guiFrame:SetFrameStrata('HIGH')
    guiFrame:EnableMouse(true)
    F.CreateMF(guiFrame)
    F.SetBD(guiFrame)

    local verticalLine = F.SetGradient(guiFrame, 'V', .5, .5, .5, .25, .25, C.Mult, 540)
    verticalLine:SetPoint('TOPLEFT', 160, -50)

    F.CreateFS(guiFrame, C.AssetsPath .. 'fonts\\header.ttf', 22, nil, C.AddonName, nil, 'THICK', 'TOP', 0, -4)
    F.CreateFS(guiFrame, C.Assets.Fonts.Regular, 10, nil, 'Version: ' .. C.AddonVersion, {.7, .7, .7}, 'THICK', 'TOP', 0, -30)

    local lineLeft = F.SetGradient(guiFrame, 'H', .7, .7, .7, 0, .7, 120, C.Mult)
    lineLeft:SetPoint('TOP', -60, -26)

    local lineRight = F.SetGradient(guiFrame, 'H', .7, .7, .7, .7, 0, 120, C.Mult)
    lineRight:SetPoint('TOP', 60, -26)

    local btnClose = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
    btnClose:SetPoint('BOTTOMRIGHT', -6, 6)
    btnClose:SetSize(80, 24)
    btnClose:SetText(_G.CLOSE)
    btnClose:SetScript(
        'OnClick',
        function()
            PlaySound(_G.SOUNDKIT.IG_MAINMENU_OPTION)
            guiFrame:Hide()
        end
    )
    F.Reskin(btnClose)

    local btnApply = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
    btnApply:SetPoint('RIGHT', btnClose, 'LEFT', -6, 0)
    btnApply:SetSize(80, 24)
    btnApply:SetText(_G.APPLY)
    -- btnApply:Disable()
    btnApply:SetScript(
        'OnClick',
        function()
            guiFrame:Hide()
            if GUI.NeedUIReload then
                _G.StaticPopup_Show('FREEUI_RELOADUI')
                GUI.NeedUIReload = nil
            end
        end
    )
    F.Reskin(btnApply)

    for i, name in pairs(tabsList) do
        guiTab[i] = CreateTab(guiFrame, i, name)

        guiPage[i] = CreateFrame('ScrollFrame', nil, guiFrame, 'UIPanelScrollFrameTemplate')
        guiPage[i]:SetPoint('TOPLEFT', 170, -50)
        guiPage[i]:SetSize(500, 540)
        guiPage[i].__bg = F.CreateBDFrame(guiPage[i], .25)
        guiPage[i]:Hide()

        guiPage[i].child = CreateFrame('Frame', nil, guiPage[i])
        guiPage[i].child:SetSize(500, 1)
        guiPage[i]:SetScrollChild(guiPage[i].child)
        F.ReskinScroll(guiPage[i].ScrollBar)
        guiPage[i]:SetScript('OnMouseWheel', ScrollBar_OnMouseWheel)

        CreateOption(i)
    end

    GUI:CreateProfileGUI(guiPage[16])
    GUI:CreateCreditsFrame(guiPage[17])

    SelectTab(1)
end

function F.ToggleGUI()
    if _G.FreeUI_GUI then
        if _G.FreeUI_GUI:IsShown() then
            _G.FreeUI_GUI:Hide()
        else
            _G.FreeUI_GUI:Show()
        end
    else
        CreateGUI()
    end
    _G.PlaySound(_G.SOUNDKIT.IG_MAINMENU_OPTION)
end

local function MainMenu_OnShow(self)
    _G.GameMenuButtonLogout:SetPoint('TOP', GUI.FreeUIButton, 'BOTTOM', 0, -14)
    self:SetHeight(self:GetHeight() + GUI.FreeUIButton:GetHeight() + 15 + 20)

    _G.GameMenuButtonStore:ClearAllPoints()
    _G.GameMenuButtonStore:SetPoint('TOP', _G.GameMenuButtonHelp, 'BOTTOM', 0, -4)

    _G.GameMenuButtonWhatsNew:ClearAllPoints()
    _G.GameMenuButtonWhatsNew:SetPoint('TOP', _G.GameMenuButtonStore, 'BOTTOM', 0, -4)

    _G.GameMenuButtonUIOptions:ClearAllPoints()
    _G.GameMenuButtonUIOptions:SetPoint('TOP', _G.GameMenuButtonOptions, 'BOTTOM', 0, -4)

    _G.GameMenuButtonKeybindings:ClearAllPoints()
    _G.GameMenuButtonKeybindings:SetPoint('TOP', _G.GameMenuButtonUIOptions, 'BOTTOM', 0, -4)

    _G.GameMenuButtonMacros:ClearAllPoints()
    _G.GameMenuButtonMacros:SetPoint('TOP', _G.GameMenuButtonKeybindings, 'BOTTOM', 0, -4)

    _G.GameMenuButtonAddons:ClearAllPoints()
    _G.GameMenuButtonAddons:SetPoint('TOP', _G.GameMenuButtonMacros, 'BOTTOM', 0, -4)

    _G.GameMenuButtonQuit:ClearAllPoints()
    _G.GameMenuButtonQuit:SetPoint('TOP', _G.GameMenuButtonLogout, 'BOTTOM', 0, -4)
end

local function Button_OnClick()
    if InCombatLockdown() then
        _G.UIErrorsFrame:AddMessage(C.RedColor .. _G.ERR_NOT_IN_COMBAT)
        return
    end

    CreateGUI()
    _G.HideUIPanel(_G.GameMenuFrame)

    PlaySound(_G.SOUNDKIT.IG_MAINMENU_OPTION)
end

local function CreateFreeUIButton()
    local bu = CreateFrame('Button', 'GameMenuFrameFreeUI', _G.GameMenuFrame, 'GameMenuButtonTemplate')
    bu:SetText(C.AddonName)
    bu:SetPoint('TOP', _G.GameMenuButtonAddons, 'BOTTOM', 0, -14)
    if _G.FREE_ADB.ReskinBlizz then
        F.Reskin(bu)
    end

    GUI.FreeUIButton = bu

    _G.GameMenuFrame:HookScript('OnShow', MainMenu_OnShow)
    bu:SetScript('OnClick', Button_OnClick)
end

function GUI:OnLogin()
    CreateFreeUIButton()

    F:RegisterEvent('PLAYER_REGEN_DISABLED', CombatLockdown)
end
