local _G = _G
local min = min
local max = max
local wipe = wipe
local tinsert = tinsert
local format = format
local tonumber = tonumber
local strupper = strupper
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local GetInstanceInfo = GetInstanceInfo
local ReloadUI = ReloadUI
local StaticPopup_Show = StaticPopup_Show
local EasyMenu = EasyMenu
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local EJ_GetInstanceInfo = EJ_GetInstanceInfo
local StaticPopupDialogs = StaticPopupDialogs
local ADD = ADD
local RESET = RESET
local YES = YES
local NO = NO
local DUNGEONS = DUNGEONS
local RAID = RAID
local KEY_NUMLOCK_MAC = KEY_NUMLOCK_MAC

local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local UNITFRAME = F:GetModule('Unitframe')
local NAMEPLATE = F:GetModule('Nameplate')
local ACTIONBAR = F:GetModule('Actionbar')
local CHAT = F:GetModule('Chat')

local extraGUIs = {}

local function TogglePanel(guiName)
    for name, frame in pairs(extraGUIs) do
        if name == guiName then
            F:TogglePanel(frame)
        else
            frame:Hide()
        end
    end
end

local function HidePanels()
    for _, frame in pairs(extraGUIs) do
        frame:Hide()
    end
end

local function CreateExtraGUI(parent, name, title, bgFrame)
    local frame = CreateFrame('Frame', name, parent)
    frame:SetSize(260, 640)
    frame:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)
    F.SetBD(frame)

    if title then
        F.CreateFS(frame, C.Assets.Fonts.Regular, 14, nil, title, 'YELLOW', true, 'TOPLEFT', 10, -25)
    end

    if bgFrame then
        frame.bg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
        frame.bg:SetSize(240, 540)
        frame.bg:SetPoint('TOPLEFT', 10, -50)
        frame.bg.bg = F.CreateBDFrame(frame.bg, .25)
        frame.bg.bg:SetBackdropColor(.04, .04, .04, .25)
    end

    if not parent.extraGUIHook then
        parent:HookScript('OnHide', HidePanels)
        parent.extraGUIHook = true
    end
    extraGUIs[name] = frame

    return frame
end

local function SortBars(barTable)
    local num = 1
    for _, bar in pairs(barTable) do
        bar:SetPoint('TOPLEFT', 0, -32 * (num - 1))
        num = num + 1
    end
end

local function createBarTest(parent, spellID, barTable, key)
    local spellName = GetSpellInfo(spellID)
    local texture = GetSpellTexture(spellID)

    local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
    bar:SetSize(200, 32)
    F.CreateBD(bar, .5)
    barTable[spellID] = bar

    local icon, close = GUI:CreateBarWidgets(bar, texture)
    F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID, 'BLUE')
    close:SetScript(
        'OnClick',
        function()
            bar:Hide()
            barTable[spellID] = nil
            if C.NPMajorSpellsList[spellID] then
                _G.FREE_ADB[key][spellID] = false
            else
                _G.FREE_ADB[key][spellID] = nil
            end
            SortBars(barTable)
        end
    )

    local name = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, spellName, nil, true, 'LEFT', 30, 0)
    name:SetWidth(120)
    name:SetJustifyH('LEFT')

    SortBars(barTable)
end

local function LabelOnEnter(self)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_RIGHT', 0, 3)
    _G.GameTooltip:AddLine(self.text)
    _G.GameTooltip:AddLine(self.tip, .6, .8, 1, 1)
    _G.GameTooltip:Show()
end

local function CreateLabel(parent, text, tip)
    local font = C.Assets.Fonts.Regular
    local label = F.CreateFS(parent, font, 11, nil, text, 'YELLOW', true, 'CENTER', 0, 22)
    if not tip then
        return
    end
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetAllPoints(label)
    frame.text = text
    frame.tip = tip
    frame:SetScript('OnEnter', LabelOnEnter)
    frame:SetScript('OnLeave', F.HideTooltip)
end

local function ClearEdit(options)
    for i = 1, #options do
        GUI:ClearEdit(options[i])
    end
end

function GUI:CreateDropdown(parent, text, x, y, data, tip, width, height)
    local dd = F.CreateDropDown(parent, width or 90, height or 30, data)
    dd:SetPoint('TOPLEFT', x, y)
    CreateLabel(dd, text, tip)

    return dd
end

function GUI:ClearEdit(element)
    if element.Type == 'EditBox' then
        element:ClearFocus()
        element:SetText('')
    elseif element.Type == 'CheckBox' then
        element:SetChecked(false)
    elseif element.Type == 'DropDown' then
        element.Text:SetText('')
        for i = 1, #element.options do
            element.options[i].selected = false
        end
    end
end

function GUI:CreateEditbox(parent, text, x, y, tip, width, height)
    local eb = F.CreateEditBox(parent, width or 90, height or 24)
    eb:SetPoint('TOPLEFT', x, y)
    eb:SetMaxLetters(255)
    CreateLabel(eb, text, tip)

    return eb
end

function GUI:CreateScroll(parent, width, height, text)
    local scroll = CreateFrame('ScrollFrame', nil, parent, 'UIPanelScrollFrameTemplate')
    scroll:SetSize(width, height)
    scroll:SetPoint('TOPLEFT', 10, -50)

    if text then
        F.CreateFS(scroll, C.Assets.Fonts.Regular, 12, 'OUTLINE', text, nil, true, 'TOPLEFT', 5, 20)
    end

    scroll.bg = F.CreateBDFrame(scroll)
    scroll.bg:SetBackdropColor(.04, .04, .04, .25)

    scroll.child = CreateFrame('Frame', nil, scroll)
    scroll.child:SetSize(width, 1)
    scroll:SetScrollChild(scroll.child)
    F.ReskinScroll(scroll.ScrollBar)

    return scroll
end

function GUI:CreateBarWidgets(parent, texture)
    local icon = CreateFrame('Frame', nil, parent)
    icon:SetSize(16, 16)
    icon:SetPoint('LEFT', 5, 0)
    F.PixelIcon(icon, texture, true)

    local close = CreateFrame('Button', nil, parent)
    close:SetSize(16, 16)
    close:SetPoint('RIGHT', -5, 0)
    close.Icon = close:CreateTexture(nil, 'ARTWORK')
    close.Icon:SetAllPoints()
    close.Icon:SetTexture(C.Assets.close_tex)
    close.Icon:SetVertexColor(1, 0, 0)
    close:SetHighlightTexture(close.Icon:GetTexture())

    return icon, close
end

local function CreateGroupTitle(parent, text, offset)
    if parent.groupTitle then
        return
    end

    F.CreateFS(parent.child, C.Assets.Fonts.Regular, 13, nil, text, 'YELLOW', true, 'TOP', 0, offset)
    local line = F.SetGradient(parent.child, 'H', .5, .5, .5, .25, .25, 200, C.Mult)
    line:SetPoint('TOPLEFT', 10, offset - 20)

    parent.groupTitle = true
end

local function Checkbox_OnClick(self)
    local key = self.__key
    local value = self.__value
    C.DB[key][value] = not C.DB[key][value]
    self:SetChecked(C.DB[key][value])
    self.__func()
end

local function CreateCheckbox(parent, offset, key, value, text, func)
    local box = F.CreateCheckbox(parent.child, true)
    box:SetSize(20, 20)
    box:SetHitRectInsets(-5, -5, -5, -5)
    box:SetPoint('TOPLEFT', 10, offset)
    F.CreateFS(box, C.Assets.Fonts.Regular, 12, nil, text, nil, true, 'LEFT', 22, 0)

    box:SetChecked(C.DB[key][value])
    box.__value = value
    box.__key = key
    box:SetScript('OnClick', Checkbox_OnClick)
    box.__func = func

    return box
end

local function CreateColorSwatch(parent, value, text, defaultV, offset, x, y)
    local swatch = F.CreateColorSwatch(parent, text, value)
    swatch.__default = defaultV

    if x and y then
        swatch:SetPoint('TOPLEFT', x, y)
    else
        swatch:SetPoint('TOPLEFT', 10, offset)
    end
end

local function Slider_OnValueChanged(self, v)
    local current
    if self.__step < 1 then
        current = tonumber(format('%.1f', v))
    else
        current = tonumber(format('%.0f', v))
    end

    self.value:SetText(current)
    C.DB[self.__key][self.__value] = current
    self.__update()
end

local function CreateSlider(parent, key, value, text, minV, maxV, step, defaultV, x, y, func)
    local slider = F.CreateSlider(parent.child, text, minV, maxV, step, x, y, 180)
    slider:SetValue(C.DB[key][value])
    slider.value:SetText(C.DB[key][value])
    slider.__key = key
    slider.__value = value
    slider.__update = func
    slider.__default = defaultV
    slider.__step = step
    slider:SetScript('OnValueChanged', Slider_OnValueChanged)
end

--[[ Static Popup ]]
StaticPopupDialogs['FREEUI_RESET_MAJOR_SPELLS'] = {
    text = C.RedColor .. L['Are you sure to restore default list?'],
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        _G.FREE_ADB['NPMajorSpells'] = {}
        ReloadUI()
    end,
    whileDead = 1
}

StaticPopupDialogs['FREEUI_RESET_PARTY_SPELLS'] = {
    text = C.RedColor .. L['Are you sure to restore default list?'],
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        wipe(_G.FREE_ADB['PartySpellsList'])
        ReloadUI()
    end,
    whileDead = 1
}

StaticPopupDialogs['FREEUI_RESET_RAID_DEBUFFS'] = {
    text = C.RedColor .. L['Are you sure to restore default list?'],
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        _G.FREE_ADB['RaidDebuffsList'] = {}
        ReloadUI()
    end,
    whileDead = 1
}

--[[ Aura ]]
function GUI:SetupAuraSize(parent)
    local guiName = 'FreeUI_GUI_Aura'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local buffDatas = {
        [1] = {
            key = 'BuffSize',
            value = '40',
            text = L['Size'],
            min = 20,
            max = 60
        },
        [2] = {
            key = 'BuffPerRow',
            value = '12',
            text = L['Per Row'],
            min = 6,
            max = 20
        }
    }

    local debuffDatas = {
        [1] = {
            key = 'DebuffSize',
            value = '50',
            text = L['Size'],
            min = 20,
            max = 60
        },
        [2] = {
            key = 'DebuffPerRow',
            value = '12',
            text = L['Per Row'],
            min = 6,
            max = 20
        }
    }

    local offset = -10
    for _, v in ipairs(buffDatas) do
        CreateGroupTitle(scroll, L['Buff Icon'], offset)
        CreateSlider(scroll, 'Aura', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(debuffDatas) do
        CreateGroupTitle(scroll, L['Debuff Icon'], offset - 50)
        CreateSlider(scroll, 'Aura', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100)
        offset = offset - 65
    end
end

--[[ Inventory ]]
function GUI:SetupInventoryFilter(parent)
    local guiName = 'FreeUI_GUI_Inventory_Filter'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, L.GUI.INVENTORY.FILTER_SETUP)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    scroll:ClearAllPoints()
    scroll:SetPoint('TOPLEFT', 10, -50)

    local filterOptions = {
        [1] = 'item_filter_junk',
        [2] = 'item_filter_consumable',
        [3] = 'item_filter_azerite',
        [4] = 'item_filter_equipment',
        [5] = 'item_filter_gear_set',
        [6] = 'item_filter_legendary',
        [7] = 'item_filter_collection',
        [8] = 'item_filter_favourite',
        [9] = 'item_filter_trade',
        [10] = 'item_filter_quest'
    }

    local function filterOnClick(self)
        local value = self.__value
        C.DB['inventory'][value] = not C.DB['inventory'][value]
        self:SetChecked(C.DB['inventory'][value])
        GUI.UpdateInventoryStatus()
    end

    local offset = 20
    for _, value in ipairs(filterOptions) do
        local box = createOptionCheck(scroll, offset, L.GUI.INVENTORY[strupper(value)])
        box:SetChecked(C.DB['inventory'][value])
        box.__value = value
        box:SetScript('OnClick', filterOnClick)

        offset = offset + 35
    end
end

--[[ Actionbar ]]
function GUI:SetupActionbarFade(parent)
    local guiName = 'FreeUI_GUI_Actionbar_Fade'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local function OnUpdate()
        ACTIONBAR:UpdateActionBarFade()
    end

    local conditions = {
        [1] = {
            value = 'ConditionCombat',
            text = L['Enter combat']
        },
        [2] = {
            value = 'ConditionTarget',
            text = L['Have target or focus']
        },
        [3] = {
            value = 'ConditionDungeon',
            text = L['Inside dungeon']
        },
        [4] = {
            value = 'ConditionPvP',
            text = L['Inside battlefield or arena']
        },
        [5] = {
            value = 'ConditionVehicle',
            text = L['Enter vehicle']
        }
    }

    local sliders = {
        [1] = {
            text = L['Fade out alpha'],
            key = 'FadeOutAlpha',
            value = C.CharacterSettings.Actionbar.FadeOutAlpha
        },
        [2] = {
            text = L['Fade out duration'],
            key = 'FadeOutDuration',
            value = C.CharacterSettings.Actionbar.FadeOutDuration
        },
        [3] = {
            text = L['Fade in alpha'],
            key = 'FadeInAlpha',
            value = C.CharacterSettings.Actionbar.FadeInAlpha
        },
        [4] = {
            text = L['Fade in duration'],
            key = 'FadeInDuration',
            value = C.CharacterSettings.Actionbar.FadeInDuration
        }
    }

    local offset = -10
    for _, v in ipairs(conditions) do
        CreateGroupTitle(scroll, L['Condition'], offset)
        CreateCheckbox(scroll, offset - 30, 'Actionbar', v.value, v.text, OnUpdate)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(sliders) do
        CreateGroupTitle(scroll, L['Fading'], offset - 30)
        CreateSlider(scroll, 'Actionbar', v.key, v.text, 0, 1, .1, v.value, 20, offset - 80, OnUpdate)
        offset = offset - 65
    end
end

function GUI:SetupAdditionalbar(parent)
    local guiName = 'FreeUI_GUI_Additionalbar'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local function OnUpdate()
        ACTIONBAR:UpdateCustomBar()
    end

    local datas = {
        [1] = {
            key = 'CBButtonNumber',
            value = '12',
            text = L['Maximum Number'],
            min = 1,
            max = 12
        },
        [2] = {
            key = 'CBButtonPerRow',
            value = '12',
            text = L['Per Row'],
            min = 1,
            max = 12
        },
        [3] = {
            key = 'CBButtonSize',
            value = '34',
            text = L['Size'],
            min = 20,
            max = 60
        },
        [4] = {
            key = 'CBMargin',
            value = '3',
            text = L['Margin'],
            min = 1,
            max = 10
        },
        [5] = {
            key = 'CBPadding',
            value = '3',
            text = L['Pading'],
            min = 1,
            max = 10
        }
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Additional Bar Customization'], offset)
        CreateSlider(scroll, 'Actionbar', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, OnUpdate)
        offset = offset - 65
    end
end

--[[ Nameplate ]]
function GUI:SetupNPAuraFilter(parent)
    local guiName = 'FreeUI_GUI_NamePlate_Aura_Filter'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)

    local frameData = {
        [1] = {
            text = L.GUI.NAMEPLATE.AURA_WHITE_LIST,
            tip = L.GUI.NAMEPLATE.AURA_WHITE_LIST_TIP,
            offset = -25,
            barList = {}
        },
        [2] = {
            text = L.GUI.NAMEPLATE.AURA_BLACK_LIST,
            tip = L.GUI.NAMEPLATE.AURA_BLACK_LIST_TIP,
            offset = -315,
            barList = {}
        }
    }

    local function createBar(parent, index, spellID)
        local name, _, texture = GetSpellInfo(spellID)
        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(180, 30)
        F.CreateBD(bar, .3)
        frameData[index].barList[spellID] = bar

        local icon, close = GUI:CreateBarWidgets(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript(
            'OnClick',
            function()
                bar:Hide()
                _G.FREE_ADB['NPAuraFilter'][index][spellID] = nil
                frameData[index].barList[spellID] = nil
                SortBars(frameData[index].barList)
            end
        )

        local spellName = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 30, 0)
        spellName:SetWidth(180)
        spellName:SetJustifyH('LEFT')
        if index == 2 then
            spellName:SetTextColor(1, 0, 0)
        end

        SortBars(frameData[index].barList)
    end

    local function addClick(parent, index)
        local spellID = tonumber(parent.box:GetText())
        if not spellID or not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.NAMEPLATE.AURA_INCORRECT_ID)
            return
        end
        if _G.FREE_ADB['NPAuraFilter'][index][spellID] then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.NAMEPLATE.AURA_EXISTING_ID)
            return
        end

        _G.FREE_ADB['NPAuraFilter'][index][spellID] = true
        createBar(parent.child, index, spellID)
        parent.box:SetText('')
    end

    for index, value in ipairs(frameData) do
        F.CreateFS(panel, C.Assets.Fonts.Regular, 14, nil, value.text, 'YELLOW', true, 'TOPLEFT', 20, value.offset)
        local frame = CreateFrame('Frame', nil, panel, 'BackdropTemplate')
        frame:SetSize(240, 250)
        frame:SetPoint('TOPLEFT', 10, value.offset - 25)
        frame.bg = F.CreateBDFrame(frame, .25)
        frame.bg:SetBackdropColor(.04, .04, .04, .25)

        local scroll = GUI:CreateScroll(frame, 200, 200)
        scroll:ClearAllPoints()
        scroll:SetPoint('BOTTOMLEFT', 10, 10)
        -- scroll.bg = F.CreateBDFrame(scroll)
        -- scroll.bg:SetBackdropColor(.04, .04, .04, .25)
        scroll.box = F.CreateEditBox(frame, 145, 25)
        scroll.box:SetPoint('TOPLEFT', 10, -10)
        F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', value.tip, 'BLUE')
        scroll.add = F.CreateButton(frame, 70, 25, ADD)
        scroll.add:SetPoint('TOPRIGHT', -8, -10)
        scroll.add:SetScript(
            'OnClick',
            function()
                addClick(scroll, index)
            end
        )

        for spellID in pairs(_G.FREE_ADB['NPAuraFilter'][index]) do
            createBar(scroll.child, index, spellID)
        end
    end
end

function GUI:SetupMajorSpells(parent)
    local guiName = 'FreeUI_GUI_NamePlate_Castbar_Glow'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local function refreshMajorSpells()
        NAMEPLATE:RefreshMajorSpells()
    end

    local panel = CreateExtraGUI(parent, guiName, L.GUI.NAMEPLATE.CASTBAR_GLOW_SETTING, true)
    panel:SetScript('OnHide', refreshMajorSpells)
    parent.panel = panel

    local frame = panel.bg
    local scroll = GUI:CreateScroll(frame, 200, 480)
    scroll.box = GUI:CreateEditbox(frame, nil, 10, -10, nil, 110, 24)
    scroll.box.title = L.GUI.SPELL_ID
    F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', L.GUI.SPELL_ID_TIP, 'BLUE')

    local barTable = {}

    scroll.add = F.CreateButton(frame, 50, 24, ADD)
    scroll.add:SetPoint('LEFT', scroll.box, 'RIGHT', 5, 0)
    scroll.add.__owner = scroll
    scroll.add:SetScript(
        'OnClick',
        function(button)
            local parent = button.__owner
            local spellID = tonumber(parent.box:GetText())
            if not spellID or not GetSpellInfo(spellID) then
                _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.INCORRECT_ID)
                return
            end
            local modValue = _G.FREE_ADB['NPMajorSpells'][spellID]
            if modValue or modValue == nil and C.NPMajorSpellsList[spellID] then
                _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.EXISTING_ID)
                return
            end
            _G.FREE_ADB['NPMajorSpells'][spellID] = true
            createBarTest(parent.child, spellID, barTable, 'NPMajorSpells')
            parent.box:SetText('')
        end
    )

    scroll.reset = F.CreateButton(frame, 50, 24, RESET)
    scroll.reset:SetPoint('LEFT', scroll.add, 'RIGHT', 5, 0)
    scroll.reset:SetScript(
        'OnClick',
        function()
            StaticPopup_Show('FREEUI_RESET_MAJOR_SPELLS')
        end
    )

    for spellID, value in pairs(NAMEPLATE.MajorSpellsList) do
        if value then
            createBarTest(scroll.child, spellID, barTable, 'NPMajorSpells')
        end
    end
end

function GUI:SetupNameplateSize(parent)
    local guiName = 'FreeUI_GUI_NamePlate_Setup'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = {
            key = 'Width',
            value = '100',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'Height',
            value = '8',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Nameplate Size'], offset)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50)
        offset = offset - 65
    end
end

local function UpdateCVars()
    NAMEPLATE:UpdatePlateVerticalSpacing()
    NAMEPLATE:UpdatePlateHorizontalSpacing()
    NAMEPLATE:UpdatePlateAlpha()
    NAMEPLATE:UpdatePlateOccludedAlpha()
    NAMEPLATE:UpdatePlateScale()
    NAMEPLATE:UpdatePlateTargetScale()
end

function GUI:SetupNameplateCVars(parent)
    local guiName = 'FreeUI_GUI_Nameplate_CVars'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local cvarsDatas = {
        [1] = {
            key = 'MinScale',
            value = .7,
            text = L['MinScale'],
            min = .5,
            max = 1,
            step = .1
        },
        [2] = {
            key = 'TargetScale',
            value = 1,
            text = L['TargetScale'],
            min = 1,
            max = 2,
            step = .1
        },
        [3] = {
            key = 'MinAlpha',
            value = .6,
            text = L['TargetScale'],
            min = .5,
            max = 1,
            step = .1
        },
        [4] = {
            key = 'OccludedAlpha',
            value = .2,
            text = L['OccludedAlpha'],
            min = .2,
            max = 1,
            step = .1
        },
        [5] = {
            key = 'VerticalSpacing',
            value = .7,
            text = L['VerticalSpacing'],
            min = .3,
            max = 3,
            step = .1
        },
        [6] = {
            key = 'HorizontalSpacing',
            value = .3,
            text = L['HorizontalSpacing'],
            min = .3,
            max = 3,
            step = .1
        }
    }

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local offset = -10
    for _, v in ipairs(cvarsDatas) do
        CreateGroupTitle(scroll, L['Nameplate CVars'], offset)
        CreateSlider(scroll, 'Nameplate', v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateCVars)
        offset = offset - 65
    end
end

--[[ Unitframe ]]
function GUI:SetupUnitFrameSize(parent)
    local guiName = 'FreeUI_GUI_Unitframe_Setup'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local playerDatas = {
        [1] = {
            key = 'PlayerWidth',
            value = '160',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'PlayerHeight',
            value = '6',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local petDatas = {
        [1] = {
            key = 'PetWidth',
            value = '60',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'PetHeight',
            value = '6',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local targetDatas = {
        [1] = {
            key = 'TargetWidth',
            value = '160',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'TargetHeight',
            value = '6',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local totDatas = {
        [1] = {
            key = 'ToTWidth',
            value = '60',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'ToTHeight',
            value = '6',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local focusDatas = {
        [1] = {
            key = 'FocusWidth',
            value = '60',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'FocusHeight',
            value = '6',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local tofDatas = {
        [1] = {
            key = 'ToFWidth',
            value = '60',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'ToFHeight',
            value = '6',
            text = L['Height'],
            min = 4,
            max = 40
        }
    }

    local powerDatas = {
        [1] = {
            key = 'PowerBarHeight',
            value = '2',
            text = L['Power Height'],
            min = 1,
            max = 10
        },
        [2] = {
            key = 'AlternativePowerBarHeight',
            value = '2',
            text = L['Alternat Power Height'],
            min = 1,
            max = 10
        }
    }

    local offset = -10
    for _, v in ipairs(playerDatas) do
        CreateGroupTitle(scroll, L['Player Frame'], offset)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(petDatas) do
        CreateGroupTitle(scroll, L['Pet Frame'], offset - 50)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(targetDatas) do
        CreateGroupTitle(scroll, L['Target Frame'], offset - 100)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 150)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(totDatas) do
        CreateGroupTitle(scroll, L['Target of Target Frame'], offset - 150)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 200)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(focusDatas) do
        CreateGroupTitle(scroll, L['Focus Frame'], offset - 200)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 250)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(tofDatas) do
        CreateGroupTitle(scroll, L['Target of Focus Frame'], offset - 250)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 300)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(powerDatas) do
        CreateGroupTitle(scroll, L['Power Bar'], offset - 300)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 350)
        offset = offset - 65
    end
end

function GUI:SetupGroupFrameSize(parent)
    local guiName = 'FreeUI_GUI_Groupframe_Setup'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local partyDatas = {
        [1] = {
            key = 'PartyWidth',
            value = '62',
            text = L['Width'],
            min = 10,
            max = 200
        },
        [2] = {
            key = 'PartyHeight',
            value = '28',
            text = L['Height'],
            min = 10,
            max = 200
        },
        [3] = {
            key = 'PartyGap',
            value = '6',
            text = L['Gap'],
            min = 4,
            max = 20
        }
    }

    local raidDatas = {
        [1] = {
            key = 'RaidWidth',
            value = '38',
            text = L['Width'],
            min = 40,
            max = 400
        },
        [2] = {
            key = 'RaidHeight',
            value = '30',
            text = L['Height'],
            min = 4,
            max = 40
        },
        [3] = {
            key = 'RaidGap',
            value = '5',
            text = L['Gap'],
            min = 4,
            max = 20
        }
    }

    local offset = -10
    for _, v in ipairs(partyDatas) do
        CreateGroupTitle(scroll, L['Party Frame'], offset)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(raidDatas) do
        CreateGroupTitle(scroll, L['Raid Frame'], offset - 50)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100)
        offset = offset - 65
    end
end

function GUI:SetupUnitFrameFader(parent)
    local guiName = 'FreeUI_GUI_Unitframe_Fader'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local checkboxDatas = {
        [1] = {
            value = 'InInstance',
            text = L['Inside dungeon']
        },
        [2] = {
            value = 'InPvP',
            text = L['Inside battlefield or arena']
        },
        [3] = {
            value = 'InCombat',
            text = L['Enter combat']
        },
        [4] = {
            value = 'Targeting',
            text = L['Have target or focus']
        },
        [5] = {
            value = 'Casting',
            text = L['Casting']
        },
        [6] = {
            value = 'Injured',
            text = L['Injured']
        },
        [7] = {
            value = 'ManaNotFull',
            text = L['Mana not full']
        },
        [8] = {
            value = 'HavePower',
            text = L['Have power(rage/energy)']
        }
    }

    local sliderDatas = {
        [1] = {
            key = 'MinAlpha',
            value = '0',
            text = L['Fade out alpha']
        },
        [2] = {
            key = 'MaxAlpha',
            value = '1',
            text = L['Fade in alpha']
        },
        [3] = {
            key = 'OutDuration',
            value = '.3',
            text = L['Fade out duration']
        },
        [4] = {
            key = 'InDuration',
            value = '.3',
            text = L['Fade in duration']
        }
    }

    local offset = -10
    for _, v in ipairs(checkboxDatas) do
        CreateGroupTitle(scroll, L['Condition'], offset)
        CreateCheckbox(scroll, offset - 30, 'Unitframe', v.value, v.text)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(sliderDatas) do
        CreateGroupTitle(scroll, L['Fading'], offset - 30)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, 0, 1, .1, v.value, 20, offset - 80)
        offset = offset - 65
    end
end

function GUI:SetupCastbar(parent)
    local guiName = 'FreeUI_GUI_Castbar_Setup'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local playerDatas = {
        [1] = {
            key = 'PlayerCastbarWidth',
            value = '200',
            text = L['Width'],
            min = 60,
            max = 400
        },
        [2] = {
            key = 'PlayerCastbarHeight',
            value = '16',
            text = L['Height'],
            min = 6,
            max = 40
        }
    }

    local targetDatas = {
        [1] = {
            key = 'TargetCastbarWidth',
            value = '160',
            text = L['Width'],
            min = 60,
            max = 400
        },
        [2] = {
            key = 'TargetCastbarHeight',
            value = '10',
            text = L['Height'],
            min = 6,
            max = 40
        }
    }

    local focusDatas = {
        [1] = {
            key = 'FocusCastbarWidth',
            value = '200',
            text = L['Width'],
            min = 60,
            max = 400
        },
        [2] = {
            key = 'FocusCastbarHeight',
            value = '16',
            text = L['Height'],
            min = 6,
            max = 40
        }
    }

    local offset = -10
    for _, v in ipairs(playerDatas) do
        CreateGroupTitle(scroll, L['Player castbar'], offset)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(targetDatas) do
        CreateGroupTitle(scroll, L['Target castbar'], offset - 50)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(focusDatas) do
        CreateGroupTitle(scroll, L['Focus castbar'], offset - 100)
        CreateSlider(scroll, 'Unitframe', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 150)
        offset = offset - 65
    end
end

local function UpdatePartyWatcherSpells()
    UNITFRAME:UpdatePartyWatcherSpells()
end

function GUI:SetupPartyWatcher(parent)
    local guiName = 'FreeUI_GUI_PartySpell_Setup'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, nil, true)
    panel:SetScript('OnHide', UpdatePartyWatcherSpells)

    local barTable = {}
    local ARCANE_TORRENT = GetSpellInfo(25046)

    local function createBar(parent, spellID, duration)
        local spellName = GetSpellInfo(spellID)
        if spellName == ARCANE_TORRENT then
            return
        end
        local texture = GetSpellTexture(spellID)

        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 30)
        F.CreateBD(bar, .25)
        barTable[spellID] = bar

        local icon, close = GUI:CreateBarWidgets(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript(
            'OnClick',
            function()
                bar:Hide()
                if C.PartySpellsList[spellID] then
                    _G.FREE_ADB['PartySpellsList'][spellID] = 0
                else
                    _G.FREE_ADB['PartySpellsList'][spellID] = nil
                end
                barTable[spellID] = nil
                SortBars(barTable)
            end
        )

        local font = C.Assets.Fonts.Regular
        local name = F.CreateFS(bar, font, 12, nil, spellName, nil, true, 'LEFT', 30, 0)
        name:SetWidth(120)
        name:SetJustifyH('LEFT')

        local timer = F.CreateFS(bar, font, 12, nil, duration, nil, true, 'RIGHT', -30, 0)
        timer:SetWidth(60)
        timer:SetJustifyH('RIGHT')
        timer:SetTextColor(0, 1, 0)

        SortBars(barTable)
    end

    local frame = panel.bg
    local options = {}

    options[1] = GUI:CreateEditbox(frame, L['Spell ID'], 10, -30, L["|nEnter spell ID, must be a number.|nYou can get ID on spell's tooltip.|nSpell name is not supported."], 107, 24)
    options[2] =
        GUI:CreateEditbox(
        frame,
        L['Spell Cooldown'],
        122,
        -30,
        L[
            "|nEnter the spell's cooldown duration.|nParty watcher only support regular spells and abilities.For spells like 'Aspect of the Wild' (BM Hunter), you need to sync cooldown with your party members."
        ],
        108,
        24
    )

    local scroll = GUI:CreateScroll(frame, 200, 440)
    scroll:ClearAllPoints()
    scroll:SetPoint('TOPLEFT', 10, -94)

    scroll.reset = F.CreateButton(frame, 51, 24, RESET, 11)
    scroll.reset:SetPoint('TOPLEFT', 10, -60)
    scroll.reset.text:SetTextColor(1, 0, 0)

    scroll.reset:SetScript(
        'OnClick',
        function()
            StaticPopup_Show('FREEUI_RESET_PARTY_SPELLS')
        end
    )

    local function addClick(scroll, options)
        local spellID, duration = tonumber(options[1]:GetText()), tonumber(options[2]:GetText())
        if not spellID or not duration then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.INCOMPLETE_INPUT)
            return
        end

        if not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.INCORRECT_SPELLID)
            return
        end

        local modDuration = _G.FREE_ADB['PartySpellsList'][spellID]

        if modDuration and modDuration ~= 0 or C.PartySpellsList[spellID] and not modDuration then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.EXISTING_ID)
            return
        end

        _G.FREE_ADB['PartySpellsList'][spellID] = duration
        createBar(scroll.child, spellID, duration)
        ClearEdit(options)
    end

    scroll.add = F.CreateButton(frame, 51, 24, ADD, 11)
    scroll.add:SetPoint('TOPRIGHT', -10, -60)
    scroll.add:SetScript(
        'OnClick',
        function()
            addClick(scroll, options)
        end
    )

    scroll.clear = F.CreateButton(frame, 51, 24, KEY_NUMLOCK_MAC, 11)
    scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.clear:SetScript(
        'OnClick',
        function()
            ClearEdit(options)
        end
    )

    local menuList = {}
    local function AddSpellFromPreset(_, spellID, duration)
        options[1]:SetText(spellID)
        options[2]:SetText(duration)
        _G.DropDownList1:Hide()
    end

    local index = 1
    for class, value in pairs(C.PartySpellsDB) do
        local color = F:RGBToHex(F:ClassColor(class))
        local localClassName = LOCALIZED_CLASS_NAMES_MALE[class]
        menuList[index] = {
            text = color .. localClassName,
            notCheckable = true,
            hasArrow = true,
            menuList = {}
        }

        for spellID, duration in pairs(value) do
            local spellName, _, texture = GetSpellInfo(spellID)
            if spellName then
                tinsert(
                    menuList[index].menuList,
                    {
                        text = spellName,
                        icon = texture,
                        tCoordLeft = .08,
                        tCoordRight = .92,
                        tCoordTop = .08,
                        tCoordBottom = .92,
                        arg1 = spellID,
                        arg2 = duration,
                        func = AddSpellFromPreset,
                        notCheckable = true
                    }
                )
            end
        end
        index = index + 1
    end
    scroll.preset = F.CreateButton(frame, 51, 24, L['Preset'], 11)
    scroll.preset:SetPoint('RIGHT', scroll.clear, 'LEFT', -5, 0)
    scroll.preset:SetScript(
        'OnClick',
        function(self)
            EasyMenu(menuList, F.EasyMenu, self, -100, 100, 'MENU', 1)
        end
    )

    for spellID, duration in pairs(UNITFRAME.PartySpellsList) do
        createBar(scroll.child, spellID, duration)
    end
end

local function UpdateRaidDebuffs()
    UNITFRAME:UpdateRaidDebuffs()
end

function GUI:SetupRaidDebuffs(parent)
    local guiName = 'FreeUI_GUI_RaidDebuffs'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, nil, true)
    panel:SetScript('OnHide', UpdateRaidDebuffs)

    local setupBars
    local frame = panel.bg
    local bars, options = {}, {}

    local iType = GUI:CreateDropdown(frame, L['Type'], 10, -30, {DUNGEONS, RAID}, nil, 107, 24)
    for i = 1, 2 do
        iType.options[i]:HookScript(
            'OnClick',
            function()
                for j = 1, 2 do
                    GUI:ClearEdit(options[j])
                    if i == j then
                        options[j]:Show()
                    else
                        options[j]:Hide()
                    end
                end

                for k = 1, #bars do
                    bars[k]:Hide()
                end
            end
        )
    end

    local dungeons = {}
    for dungeonID = 1182, 1189 do
        local name = EJ_GetInstanceInfo(dungeonID)
        if name then
            tinsert(dungeons, name)
        end
    end

    local raids = {[1] = EJ_GetInstanceInfo(1190)}

    if C.IsNewPatch then
        raids[2] = EJ_GetInstanceInfo(1193)
        local newInst = EJ_GetInstanceInfo(1194)
        tinsert(dungeons, newInst)
    end

    options[1] = GUI:CreateDropdown(frame, DUNGEONS, 123, -30, dungeons, nil, 107, 24)
    options[1]:Hide()
    options[2] = GUI:CreateDropdown(frame, RAID, 123, -30, raids, nil, 107, 24)
    options[2]:Hide()

    options[3] = GUI:CreateEditbox(frame, L['Spell ID'], 10, -90, L["|nEnter spell ID, must be a number.|nYou can get ID on spell's tooltip.|nSpell name is not supported."], 107, 24)
    options[4] =
        GUI:CreateEditbox(
        frame,
        L['Priority'],
        123,
        -90,
        L[
            "|nSpell's priority when visible.|nWhen multiple spells exist, it only remain the one that owns highest priority.|nDefault priority is 2, if you leave it blank.|nThe maximun priority is 6, and the icon would flash if you set so."
        ],
        107,
        24
    )

    local function analyzePrio(priority)
        priority = priority or 2
        priority = min(priority, 6)
        priority = max(priority, 1)
        return priority
    end

    local function isAuraExisted(instName, spellID)
        print(instName)
        print(spellID)
        print(C.RaidDebuffsList[instName][spellID])
        local localPrio = C.RaidDebuffsList[instName][spellID]
        local savedPrio = _G.FREE_ADB['RaidDebuffsList'][instName] and _G.FREE_ADB['RaidDebuffsList'][instName][spellID]
        if (localPrio and savedPrio and savedPrio == 0) or (not localPrio and not savedPrio) then
            return false
        end
        return true
    end

    local function addClick(options)
        local dungeonName = options[1].Text:GetText()
        local raidName = options[2].Text:GetText()
        local spellID = tonumber(options[3]:GetText())
        local priority = tonumber(options[4]:GetText())
        local instName = dungeonName or raidName
        if not instName or not spellID then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L['You need to complete all optinos.'])
            return
        end
        if spellID and not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L['Incorrect SpellID.'])
            return
        end
        if isAuraExisted(instName, spellID) then
            _G.UIErrorsFrame:AddMessage(C.RedColor .. L['The SpellID is existed.'])
            return
        end

        priority = analyzePrio(priority)
        if not _G.FREE_ADB['RaidDebuffsList'][instName] then
            _G.FREE_ADB['RaidDebuffsList'][instName] = {}
        end
        _G.FREE_ADB['RaidDebuffsList'][instName][spellID] = priority
        setupBars(instName)
        GUI:ClearEdit(options[3])
        GUI:ClearEdit(options[4])
    end

    local scroll = GUI:CreateScroll(frame, 200, 380)
    scroll:ClearAllPoints()
    scroll:SetPoint('TOPLEFT', 10, -150)
    scroll.reset = F.CreateButton(frame, 70, 24, RESET)
    scroll.reset:SetPoint('TOPLEFT', 10, -120)
    scroll.reset.text:SetTextColor(1, 0, 0)
    scroll.reset:SetScript(
        'OnClick',
        function()
            StaticPopup_Show('FREEUI_RESET_RAID_DEBUFFS')
        end
    )
    scroll.add = F.CreateButton(frame, 70, 24, ADD)
    scroll.add:SetPoint('TOPRIGHT', -10, -120)
    scroll.add:SetScript(
        'OnClick',
        function()
            addClick(options)
        end
    )
    scroll.clear = F.CreateButton(frame, 70, 24, KEY_NUMLOCK_MAC)
    scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.clear:SetScript(
        'OnClick',
        function()
            ClearEdit(options)
        end
    )

    local function iconOnEnter(self)
        local spellID = self:GetParent().spellID
        if not spellID then
            return
        end
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:ClearLines()
        _G.GameTooltip:SetSpellByID(spellID)
        _G.GameTooltip:Show()
    end

    local function createBar(index, texture)
        local bar = CreateFrame('Frame', nil, scroll.child, 'BackdropTemplate')
        bar:SetSize(200, 30)
        F.CreateBD(bar, .25)
        bar.index = index

        local icon, close = GUI:CreateBarWidgets(bar, texture)
        icon:SetScript('OnEnter', iconOnEnter)
        icon:SetScript('OnLeave', F.HideTooltip)
        bar.icon = icon

        close:SetScript(
            'OnClick',
            function()
                bar:Hide()
                if C.RaidDebuffsList[bar.instName][bar.spellID] then
                    if not _G.FREE_ADB['RaidDebuffsList'][bar.instName] then
                        _G.FREE_ADB['RaidDebuffsList'][bar.instName] = {}
                    end
                    _G.FREE_ADB['RaidDebuffsList'][bar.instName][bar.spellID] = 0
                else
                    _G.FREE_ADB['RaidDebuffsList'][bar.instName][bar.spellID] = nil
                end
                setupBars(bar.instName)
            end
        )

        local spellName = F.CreateFS(bar, C.Assets.Fonts.Regular, 11, nil, '', nil, true, 'LEFT', 26, 0)
        spellName:SetWidth(120)
        spellName:SetJustifyH('LEFT')
        bar.spellName = spellName

        local prioBox = F.CreateEditBox(bar, 24, 24)
        prioBox:SetPoint('RIGHT', close, 'LEFT', -1, 0)
        prioBox:SetTextInsets(10, 0, 0, 0)
        prioBox:SetMaxLetters(1)
        prioBox:SetTextColor(0, 1, 0)
        prioBox.bg:SetBackdropColor(1, 1, 1, .3)
        prioBox:HookScript(
            'OnEscapePressed',
            function(self)
                self:SetText(bar.priority)
            end
        )
        prioBox:HookScript(
            'OnEnterPressed',
            function(self)
                local prio = analyzePrio(tonumber(self:GetText()))
                if not _G.FREE_ADB['RaidDebuffsList'][bar.instName] then
                    _G.FREE_ADB['RaidDebuffsList'][bar.instName] = {}
                end
                _G.FREE_ADB['RaidDebuffsList'][bar.instName][bar.spellID] = prio
                self:SetText(prio)
            end
        )
        prioBox.title = L['Priority']
        F.AddTooltip(prioBox, 'ANCHOR_RIGHT', L['|nPriority limit in 1-6.|nPress ENTER KEY when you finish typing.'], 'BLUE')
        bar.prioBox = prioBox

        return bar
    end

    local function applyData(index, instName, spellID, priority)
        local name, _, texture = GetSpellInfo(spellID)
        if not bars[index] then
            bars[index] = createBar(index, texture)
        end
        bars[index].instName = instName
        bars[index].spellID = spellID
        bars[index].priority = priority
        bars[index].spellName:SetText(name)
        bars[index].prioBox:SetText(priority)
        bars[index].icon.Icon:SetTexture(texture)
        bars[index]:Show()
    end

    function setupBars(self)
        local instName = self.text or self
        local index = 0

        if C.RaidDebuffsList[instName] then
            for spellID, priority in pairs(C.RaidDebuffsList[instName]) do
                if not (_G.FREE_ADB['RaidDebuffsList'][instName] and _G.FREE_ADB['RaidDebuffsList'][instName][spellID]) then
                    index = index + 1
                    applyData(index, instName, spellID, priority)
                end
            end
        end

        if _G.FREE_ADB['RaidDebuffsList'][instName] then
            for spellID, priority in pairs(_G.FREE_ADB['RaidDebuffsList'][instName]) do
                if priority > 0 then
                    index = index + 1
                    applyData(index, instName, spellID, priority)
                end
            end
        end

        for i = 1, #bars do
            if i > index then
                bars[i]:Hide()
            end
        end

        for i = 1, index do
            bars[i]:SetPoint('TOPLEFT', 0, -35 * (i - 1))
        end
    end

    for i = 1, 2 do
        for j = 1, #options[i].options do
            options[i].options[j]:HookScript('OnClick', setupBars)
        end
    end

    local function autoSelectInstance()
        local instName, instType = GetInstanceInfo()
        if instType == 'none' then
            return
        end
        for i = 1, 2 do
            local option = options[i]
            for j = 1, #option.options do
                local name = option.options[j].text
                if instName == name then
                    iType.options[i]:Click()
                    options[i].options[j]:Click()
                end
            end
        end
    end
    autoSelectInstance()
    panel:HookScript('OnShow', autoSelectInstance)
end

--[[ General ]]
function GUI:SetupAutoTakeScreenshot(parent)
    local guiName = 'FreeUI_GUI_Auto_Screenshot'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = {
            value = 'EarnedNewAchievement',
            text = L['Earned new achievement']
        },
        [2] = {
            value = 'ChallengeModeCompleted',
            text = L['Mythic+ completed']
        },
        [3] = {
            value = 'PlayerLevelUp',
            text = L['Level up']
        },
        [4] = {
            value = 'PlayerDead',
            text = L['Dead']
        }
    }

    local offset = -10
    for _, data in ipairs(datas) do
        CreateGroupTitle(scroll, L['Auto Screenshot Event'], offset)
        CreateCheckbox(scroll, offset - 30, 'General', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupCustomClassColor(parent)
    local guiName = 'FreeUI_GUI_CustomClassColor'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local colors = _G.FREE_ADB.CustomClassColors

    local datas = {
        [1] = {text = 'HUNTER', value = colors.HUNTER},
        [2] = {text = 'WARRIOR', value = colors.WARRIOR},
        [3] = {text = 'SHAMAN', value = colors.SHAMAN},
        [4] = {text = 'MAGE', value = colors.MAGE},
        [5] = {text = 'PRIEST', value = colors.PRIEST},
        [6] = {text = 'DEATHKNIGHT', value = colors.DEATHKNIGHT},
        [7] = {text = 'WARLOCK', value = colors.WARLOCK},
        [8] = {text = 'DEMONHUNTER', value = colors.DEMONHUNTER},
        [9] = {text = 'ROGUE', value = colors.ROGUE},
        [10] = {text = 'DRUID', value = colors.DRUID},
        [11] = {text = 'MONK', value = colors.MONK},
        [12] = {text = 'PALADIN', value = colors.PALADIN}
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Class Color Customization'], offset)
        CreateColorSwatch(scroll, v.value, v.text, C.AccountSettings.CustomClassColors[v.text], offset - 30)

        offset = offset - 30
    end
end

--[[ Chat ]]
local function UpdateChatSize()
    CHAT:UpdateChatSize()
end

function GUI:SetupChatSize(parent)
    local guiName = 'FreeUI_GUI_Chat_Size'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = {
            key = 'Width',
            value = '300',
            text = L['Width'],
            min = 50,
            max = 500
        },
        [2] = {
            key = 'Height',
            value = '100',
            text = L['Height'],
            min = 50,
            max = 500
        }
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Chat Window Size'], offset)
        CreateSlider(scroll, 'Chat', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateChatSize)
        offset = offset - 65
    end
end
