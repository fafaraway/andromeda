local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local HideUIPanel = HideUIPanel
local PlaySound = PlaySound
local SOUNDKIT_GS_TITLE_OPTION_OK = SOUNDKIT.GS_TITLE_OPTION_OK
local SOUNDKIT_IG_MAINMENU_OPTION = SOUNDKIT.IG_MAINMENU_OPTION
local StaticPopup_Show = StaticPopup_Show
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local CLOSE = CLOSE
local APPLY = APPLY

local F, C, L = unpack(select(2, ...))
local GUI = F.GUI

local guiTab = {}
local guiPage = {}
GUI.Tab = guiTab
GUI.Page = guiPage

local tabsList = {
    L.GUI.GENERAL.NAME,
    L.GUI.NOTIFICATION.NAME,
    L.GUI.INFOBAR.NAME,
    L.GUI.CHAT.NAME,
    L.GUI.AURA.NAME,
    L.GUI.ACTIONBAR.NAME,
    L.GUI.COMBAT.NAME,
    L.GUI.ANNOUNCEMENT.NAME,
    L.GUI.INVENTORY.NAME,
    L.GUI.MAP.NAME,
    L.GUI.TOOLTIP.NAME,
    L.GUI.UNITFRAME.NAME,
    L.GUI.GROUPFRAME.NAME,
    L.GUI.NAMEPLATE.NAME,
    L.GUI.APPEARANCE.NAME,
    L.GUI.PROFILE.NAME,
    L.GUI.CREDITS.NAME,
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
    'Interface\\ICONS\\Raf-Icon',
}

GUI.TexturesList = {
    [1] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex', name = L.GUI.GENERAL.TEXTURE_NORM},
    [2] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex', name = L.GUI.GENERAL.TEXTURE_GRAD},
    [3] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex', name = L.GUI.GENERAL.TEXTURE_FLAT},
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

local function SelectTab(i)
    local r, g, b = C.r, C.g, C.b
    local color = _G.FREE_ADB.ButtonBackdropColor

    for num = 1, #tabsList do
        if num == i then
            guiTab[num].__gradient:SetVertexColor(r / 2, g / 2, b / 2)
            guiTab[num].checked = true
            guiPage[num]:Show()
        else
            guiTab[num].__gradient:SetVertexColor(color.r, color.g, color.b)
            guiTab[num].checked = false
            guiPage[num]:Hide()
        end
    end
end

local function Tab_OnClick(self)
    PlaySound(SOUNDKIT_GS_TITLE_OPTION_OK)
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

    tab.text = F.CreateFS(tab, C.Assets.Fonts.Bold, 13, 'OUTLINE', name, nil, true)
    tab.text:SetPoint('LEFT', tab.icon, 'RIGHT', 6, 0)

    tab:HookScript('OnEnter', Tab_OnEnter)
    tab:HookScript('OnLeave', Tab_OnLeave)
    tab:HookScript('OnClick', Tab_OnClick)

    return tab
end

local function CreateOption(i)
    local r, g, b = C.r, C.g, C.b
    local parent, offset = guiPage[i].child, 20

    for _, option in pairs(GUI.OptionsList[i]) do
        local optType, key, value, name, horizon, data, callback, tip = unpack(option)
        if optType == 1 then -- checkbox
            local cb = F.CreateCheckBox(parent, true, nil, true)
            cb:SetSize(20, 20)
            cb:SetHitRectInsets(-5, -5, -5, -5)

            cb.label = F.CreateFS(cb, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 22, 0)

            if horizon then
                cb:SetPoint('TOPLEFT', 250, -offset + 30)
            else
                cb:SetPoint('TOPLEFT', 20, -offset)
                offset = offset + 30
            end

            cb:SetChecked(UpdateValue(key, value))

            cb:SetScript('OnClick', function()
                UpdateValue(key, value, cb:GetChecked())
                if callback then
                    callback()
                end
            end)

            if data and type(data) == 'function' then
                local bu = CreateGearButton(parent)
                bu:SetPoint('LEFT', cb.label, 'RIGHT', -2, 1)
                bu:SetScript('OnClick', data)
            end

            if tip then
                cb.title = name
                F.AddTooltip(cb, 'ANCHOR_TOPLEFT', tip, 'BLUE')
            end
        elseif optType == 2 then -- editbox
            local eb = F.CreateEditBox(parent, 150, 24)
            eb:SetMaxLetters(999)

            eb.label = F.CreateFS(eb, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'CENTER', 0, 20)

            if horizon then
                eb:SetPoint('TOPLEFT', 260, -offset + 46)
            else
                eb:SetPoint('TOPLEFT', 20, -offset - 24)
                offset = offset + 70
            end

            eb:SetText(UpdateValue(key, value))

            eb:HookScript('OnEscapePressed', function()
                eb:SetText(UpdateValue(key, value))
            end)

            eb:HookScript('OnEnterPressed', function()
                UpdateValue(key, value, eb:GetText())
                if callback then
                    callback()
                end
            end)

            if tip then
                F.AddTooltip(eb, 'ANCHOR_TOPLEFT', tip, 'BLUE')
            end
        elseif optType == 3 then -- slider
            local min, max, step = unpack(data)

            local x, y
            if horizon then
                x, y = 244, -offset + 40
            else
                x, y = 14, -offset - 30
                offset = offset + 70
            end

            local s = F.CreateSlider(parent, name, min, max, step, x, y, 180, tip)
            s.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]

            s:SetValue(UpdateValue(key, value))

            s:SetScript('OnValueChanged', function(_, v)
                local current = F:Round(tonumber(v), 2)
                UpdateValue(key, value, current)
                s.value:SetText(current)
                if callback then
                    callback()
                end
            end)

            s.value:SetText(F:Round(UpdateValue(key, value), 2))

            if tip then
                s.title = name
                F.AddTooltip(s, 'ANCHOR_TOPLEFT', tip, 'BLUE')
            end
        elseif optType == 4 then -- dropdown
            if value == 'TextureStyle' then
                for _, v in ipairs(GUI.TexturesList) do
                    tinsert(data, v.name)
                end
            end

            local dd = F.CreateDropDown(parent, 160, 20, data)
            if horizon then
                dd:SetPoint('TOPLEFT', 254, -offset + 35)
            else
                dd:SetPoint('TOPLEFT', 26, -offset - 35)
                offset = offset + 70
            end

            dd.Text:SetText(data[UpdateValue(key, value)])

            local opt = dd.options
            dd.button:HookScript('OnClick', function()
                for num = 1, #data do
                    if num == UpdateValue(key, value) then
                        opt[num]:SetBackdropColor(r, g, b, .25)
                        opt[num].selected = true
                    else
                        opt[num]:SetBackdropColor(0, 0, 0, .25)
                        opt[num].selected = false
                    end
                end
            end)
            for i in pairs(data) do
                opt[i]:HookScript('OnClick', function()
                    UpdateValue(key, value, i)
                    if callback then
                        callback()
                    end
                end)
                if value == 'TextureStyle' then
                    AddTextureToOption(opt, i) -- texture preview
                end
            end

            dd.label = F.CreateFS(dd, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'CENTER', 0, 18)
            if tip then
                dd.title = name
                F.AddTooltip(dd, 'ANCHOR_RIGHT', tip, 'BLUE')
            end
        elseif optType == 5 then -- colorswatch
            local swatch = F.CreateColorSwatch(parent, name, UpdateValue(key, value))
            local width = 25 + (horizon or 0) * 115
            if horizon then
                swatch:SetPoint('TOPLEFT', width, -offset + 27)
            else
                swatch:SetPoint('TOPLEFT', width, -offset - 5)
                offset = offset + 32
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

    local footer = CreateFrame('Frame', nil, parent)
    footer:SetSize(20, 20)
    footer:SetPoint('TOPLEFT', 25, -offset)
end

local function ScrollBarHook(self, delta)
    local scrollBar = self.ScrollBar
    scrollBar:SetValue(scrollBar:GetValue() - delta * 35)
end

local function CreateGUI()
    if _G.FreeUI_GUI then
        _G.FreeUI_GUI:Show()
        return
    end

    local guiFrame = CreateFrame('Frame', 'FreeUI_GUI', _G.UIParent)
    tinsert(_G.UISpecialFrames, 'FreeUI_GUI')
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
    btnClose:SetText(CLOSE)
    btnClose:SetScript('OnClick', function()
        PlaySound(SOUNDKIT_IG_MAINMENU_OPTION)
        guiFrame:Hide()
    end)
    F.Reskin(btnClose)

    local btnApply = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
    btnApply:SetPoint('RIGHT', btnClose, 'LEFT', -6, 0)
    btnApply:SetSize(80, 24)
    btnApply:SetText(APPLY)
    -- btnApply:Disable()
    btnApply:SetScript('OnClick', function()
        StaticPopup_Show('FREEUI_RELOAD')
        guiFrame:Hide()
    end)
    F.Reskin(btnApply)

    for i, name in pairs(tabsList) do
        guiTab[i] = CreateTab(guiFrame, i, name)

        guiPage[i] = CreateFrame('ScrollFrame', nil, guiFrame, 'UIPanelScrollFrameTemplate')
        guiPage[i]:SetPoint('TOPLEFT', 170, -50)
        guiPage[i]:SetSize(500, 540)
        guiPage[i].__bg = F.CreateBDFrame(guiPage[i])
        guiPage[i].__bg:SetBackdropColor(.04, .04, .04, .25)
        guiPage[i]:Hide()

        guiPage[i].child = CreateFrame('Frame', nil, guiPage[i])
        guiPage[i].child:SetSize(500, 1)
        guiPage[i]:SetScrollChild(guiPage[i].child)
        F.ReskinScroll(guiPage[i].ScrollBar)
        guiPage[i]:SetScript('OnMouseWheel', ScrollBarHook)

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

function GUI:OnLogin()
    local bu = CreateFrame('Button', 'GameMenuFrameFreeUI', _G.GameMenuFrame, 'GameMenuButtonTemplate')
    bu:SetText(C.AddonName)
    bu:SetPoint('TOP', _G.GameMenuButtonAddons, 'BOTTOM', 0, -14)
    if _G.FREE_ADB.ReskinBlizz then
        F.Reskin(bu)
    end

    _G.GameMenuFrame:HookScript('OnShow', function(self)
        _G.GameMenuButtonLogout:SetPoint('TOP', bu, 'BOTTOM', 0, -14)
        self:SetHeight(self:GetHeight() + bu:GetHeight() + 15 + 20)

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
    end)

    bu:SetScript('OnClick', function()
        if InCombatLockdown() then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. ERR_NOT_IN_COMBAT)
            return
        end
        CreateGUI()
        HideUIPanel(_G.GameMenuFrame)
        PlaySound(SOUNDKIT_IG_MAINMENU_OPTION)
    end)

    F:RegisterEvent('PLAYER_REGEN_DISABLED', CombatLockdown)
end
