local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local ACTIONBAR = F:GetModule('ActionBar')
local CHAT = F:GetModule('Chat')
local ANNOUNCEMENT = F:GetModule('Announcement')
local MAP = F:GetModule('Map')
local INVENTORY = F:GetModule('Inventory')
local VIGNETTING = F:GetModule('Vignetting')
local BAR = F:GetModule('ActionBar')
local AURA = F:GetModule('Aura')
local oUF = F.Libs.oUF

local extraGUIs = {}

-- Functions

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
    frame:SetSize(GUI.exWidth, GUI.height)
    frame:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)
    F.SetBD(frame)

    if title then
        F.CreateFS(frame, C.Assets.Font.Regular, 14, nil, title, 'YELLOW', true, 'TOPLEFT', 10, -25)
    end

    if bgFrame then
        frame.bg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
        frame.bg:SetPoint('TOPLEFT', 10, -50)
        frame.bg:SetPoint('bottomright', -10, 50)
        frame.bg.bg = F.CreateBDFrame(frame.bg, 0.25)
    end

    if not parent.extraGUIHook then
        parent:HookScript('OnHide', HidePanels)
        parent.extraGUIHook = true
    end
    extraGUIs[name] = frame

    return frame
end

function GUI:CreateScroll(parent, width, height, text, noBg)
    local scroll = CreateFrame('ScrollFrame', nil, parent, 'UIPanelScrollFrameTemplate')
    scroll:SetSize(width, height)
    if parent.bg then
        scroll:SetPoint('TOPLEFT', 10, -45)
    else
        scroll:SetPoint('TOPLEFT', 10, -50)
    end

    if text then
        F.CreateFS(scroll, C.Assets.Font.Regular, 12, 'OUTLINE', text, nil, true, 'TOPLEFT', 5, 20)
    end

    if not noBg then
        scroll.bg = F.CreateBDFrame(scroll, 0.25)
    end

    scroll.child = CreateFrame('Frame', nil, scroll)
    scroll.child:SetSize(width, 1)
    scroll:SetScrollChild(scroll.child)
    F.ReskinScroll(scroll.ScrollBar)

    return scroll
end

local function SortBars(barTable)
    local num = 1
    for _, bar in pairs(barTable) do
        bar:SetPoint('TOPLEFT', 0, -32 * (num - 1))
        num = num + 1
    end
end

local function CreateBars(parent, spellID, table1, table2, table3)
    -- table1 barTable
    -- table2 C.table
    -- table3 FREE_ADB.table
    local spellName = GetSpellInfo(spellID)
    local texture = GetSpellTexture(spellID)

    local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
    bar:SetSize(200, 30)
    F.CreateBD(bar, 0.25)
    table1[spellID] = bar

    local icon, delBtn = GUI:CreateBarWidgets(bar, texture)
    F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
    delBtn:SetScript('OnClick', function()
        bar:Hide()

        if C[table2][spellID] then
            _G.FREE_ADB[table3][spellID] = false
        else
            _G.FREE_ADB[table3][spellID] = nil
        end

        table1[spellID] = nil
        SortBars(table1)
    end)

    local name = F.CreateFS(bar, C.Assets.Font.Regular, 12, nil, spellName, nil, true, 'LEFT', 30, 0)
    name:SetWidth(120)
    name:SetJustifyH('LEFT')

    SortBars(table1)
end

--[[

 ]]

local function createBars(parent, spellID, newTable, tableName)
    -- table1 barTable
    -- table2 C.table
    -- table3 FREE_ADB.table
    local spellName = GetSpellInfo(spellID)
    local texture = GetSpellTexture(spellID)

    local bar = CreateFrame('Frame', nil, parent.child, 'BackdropTemplate')
    bar:SetSize(200, 30)
    F.CreateBD(bar, 0.25)
    newTable[spellID] = bar

    local icon, delBtn = GUI:CreateBarWidgets(bar, texture)
    F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
    delBtn:SetScript('OnClick', function()
        bar:Hide()

        if C[tableName][spellID] then
            _G.FREE_ADB[tableName][spellID] = false
        else
            _G.FREE_ADB[tableName][spellID] = nil
        end

        newTable[spellID] = nil
        SortBars(newTable)
    end)

    local name = F.CreateFS(bar, C.Assets.Font.Regular, 12, nil, spellName, nil, true, 'LEFT', 30, 0)
    name:SetWidth(160)
    name:SetJustifyH('LEFT')

    SortBars(newTable)
end

local function addOnClick(btn)
    local parent = btn.__owner
    local newTable = parent.barTable
    local tableName = parent.tableName

    local spellID = tonumber(parent.editBox:GetText())
    if not spellID or not GetSpellInfo(spellID) then
        _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
        return
    end

    local modValue = _G.FREE_ADB[tableName][spellID]
    if modValue or modValue == nil and C[tableName][spellID] then
        _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
        return
    end

    _G.FREE_ADB[tableName][spellID] = true

    createBars(parent.scrollArea, spellID, newTable, tableName)

    parent.editBox:SetText('')
end

--[[

 ]]

local function Label_OnEnter(self)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_RIGHT', 0, 3)
    _G.GameTooltip:AddLine(self.text)
    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddLine(self.tip, 0.6, 0.8, 1, 1)
    _G.GameTooltip:Show()
end

local function CreateLabel(parent, text, tip)
    local font = C.Assets.Font.Regular
    local label = F.CreateFS(parent, font, 11, nil, text, nil, true)
    label:SetPoint('BOTTOM', parent, 'TOP', 0, 4)
    if not tip then
        return
    end
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetAllPoints(label)
    frame.text = text
    frame.tip = tip
    frame:SetScript('OnEnter', Label_OnEnter)
    frame:SetScript('OnLeave', F.HideTooltip)
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

local function ClearEdit(options)
    for i = 1, #options do
        GUI:ClearEdit(options[i])
    end
end

-- Widgets

local function createEditBox(parent, text, x, y, tip, width, height)
    local eb = F.CreateEditBox(parent, width or 90, height or 24)
    eb:SetPoint('TOPLEFT', x, y)
    eb:SetMaxLetters(255)
    CreateLabel(eb, text)

    if tip then
        eb.title = L['Hint']
        F.AddTooltip(eb, 'ANCHOR_RIGHT', tip, 'BLUE', true)
    end

    return eb
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
    close.Icon:SetTexture(C.Assets.Texture.Close)
    close.Icon:SetVertexColor(1, 0, 0)
    close:SetHighlightTexture(close.Icon:GetTexture())

    return icon, close
end

local function CreateGroupTitle(parent, text, offset)
    if parent.groupTitle then
        return
    end

    F.CreateFS(parent.child, C.Assets.Font.Regular, 13, nil, text, 'YELLOW', true, 'TOP', 0, offset)
    local line = F.SetGradient(parent.child, 'H', 0.5, 0.5, 0.5, 0.25, 0.25, 200, C.MULT)
    line:SetPoint('TOPLEFT', 10, offset - 20)

    parent.groupTitle = true
end

local function Checkbox_OnClick(self)
    local key = self.__key
    local value = self.__value
    C.DB[key][value] = not C.DB[key][value]
    self:SetChecked(C.DB[key][value])
    if self.__func then
        self.__func()
    end
end

local function CreateCheckbox(parent, offset, key, value, text, func, tip)
    local box = F.CreateCheckbox(parent.child, true)
    box:SetSize(18, 18)
    box:SetHitRectInsets(-5, -5, -5, -5)
    box:SetPoint('TOPLEFT', 10, offset)
    box.label = F.CreateFS(box, C.Assets.Font.Regular, 12, nil, text, nil, true)
    box.label:SetPoint('LEFT', box, 'RIGHT', 4, 0)

    box:SetChecked(C.DB[key][value])
    box.__value = value
    box.__key = key
    box:SetScript('OnClick', Checkbox_OnClick)
    box.__func = func

    if tip then
        box.title = text
        F.AddTooltip(box, 'ANCHOR_TOPLEFT', tip, 'BLUE', true)
    end

    return box
end

local function CreateColorSwatch(parent, value, text, defaultV, offset, x, y)
    local swatch = F.CreateColorSwatch(parent, text, value)
    swatch:SetSize(22, 14)
    swatch.__default = defaultV

    if x and y then
        swatch:SetPoint('TOPLEFT', x, y)
    else
        swatch:SetPoint('TOPLEFT', 14, offset)
    end
end

local function Slider_OnValueChanged(self, v)
    local current = F:Round(tonumber(v), 2)
    self.value:SetText(current)
    C.DB[self.__key][self.__value] = current

    if self.__update then
        self.__update()
    end
end

local function CreateSlider(parent, key, value, text, minV, maxV, step, defaultV, x, y, func, tip)
    local slider = F.CreateSlider(parent.child, text, minV, maxV, step, x, y, 180)
    slider:SetValue(C.DB[key][value])
    slider.value:SetText(C.DB[key][value])
    slider.__key = key
    slider.__value = value
    slider.__update = func
    slider.__default = defaultV
    slider.__step = step
    slider:SetScript('OnValueChanged', Slider_OnValueChanged)

    if tip then
        slider.title = tostring(key)
        F.AddTooltip(slider, 'ANCHOR_TOPLEFT', tip, 'BLUE', true)
    end
end

local function updateDropdownHighlight(self)
    local dd = self.__owner
    for i = 1, #dd.__options do
        local option = dd.options[i]
        if i == C.DB[dd.__key][dd.__value] then
            option:SetBackdropColor(C.r, C.g, C.b, 0.25)
            option.selected = true
        else
            option:SetBackdropColor(0.1, 0.1, 0.1, 0.25)
            option.selected = false
        end
    end
end

local function updateDropdownState(self)
    local dd = self.__owner
    C.DB[dd.__key][dd.__value] = self.index
    if dd.__func then
        dd.__func()
    end
end

local function createDropdown(parent, text, x, y, data, tip, width, height)
    local dd = F.CreateDropDown(parent, width or 90, height or 30, data)
    dd:SetPoint('TOPLEFT', x, y)
    CreateLabel(dd, text)

    if tip then
        dd.title = L['Hint']
        F.AddTooltip(dd, 'ANCHOR_RIGHT', tip, 'BLUE', true)
    end

    return dd
end

local function CreateOptionDropdown(parent, title, yOffset, options, tooltip, key, value, default, func)
    local dd = createDropdown(parent.child, title, 20, yOffset, options, tooltip, 180, 20)
    dd.__key = key
    dd.__value = value
    dd.__default = default
    dd.__options = options
    dd.__func = func
    dd.Text:SetText(options[C.DB[key][value]])

    dd.button.__owner = dd
    dd.button:HookScript('OnClick', updateDropdownHighlight)

    for i = 1, #options do
        dd.options[i]:HookScript('OnClick', updateDropdownState)
    end
end

-- Module Extra GUI

-- Aura
local function UpdateAuraSize()
    if not AURA.settings then
        return
    end
    AURA:UpdateOptions()
    AURA:UpdateHeader(AURA.BuffFrame)
    AURA.BuffFrame.mover:SetSize(AURA.BuffFrame:GetSize())
end

function GUI:SetupAuraSize(parent)
    local guiName = C.ADDON_NAME .. 'GUIAuraSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Aura
    local mKey = 'Aura'

    local datas = {
        buff = {
            [1] = { key = 'BuffSize', value = db.BuffSize, text = L['Size'], min = 24, max = 50, step = 1 },
            [2] = { key = 'BuffPerRow', value = db.BuffPerRow, text = L['Per Row'], min = 6, max = 20, step = 1 },
        },
        debuff = {
            [1] = { key = 'DebuffSize', value = db.DebuffSize, text = L['Size'], min = 24, max = 50, step = 1 },
            [2] = { key = 'DebuffPerRow', value = db.DebuffSize, text = L['Per Row'], min = 6, max = 20, step = 1 },
        },
        layout = {
            [1] = { value = 'BuffReverse', text = L['Buffs Reverse Growth'] },
            [2] = { value = 'DebuffReverse', text = L['Debuffs Reverse Growth'] },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.layout) do
        CreateGroupTitle(scroll, L['Layout'], offset)
        CreateCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateAuraSize)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.buff) do
        CreateGroupTitle(scroll, L['Buff'], offset - 30)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 80, UpdateAuraSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.debuff) do
        CreateGroupTitle(scroll, L['Debuff'], offset - 80)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 130, UpdateAuraSize)
        offset = offset - 65
    end
end

-- Inventory
local function UpdateBagSize()
    INVENTORY:UpdateBagSize()
end

local function UpdateInventoryAnchor()
    INVENTORY:UpdateAllAnchors()
end

local function UpdateInventoryStatus()
    INVENTORY:UpdateAllBags()
end

function GUI:SetupInventoryFilter(parent)
    local guiName = C.ADDON_NAME .. 'GUIInventoryFilter'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = { value = 'FilterJunk', text = _G.BAG_FILTER_JUNK },
        [2] = { value = 'FilterQuestItem', text = _G.QUESTS_LABEL },
        [3] = { value = 'FilterTradeGoods', text = _G.AUCTION_CATEGORY_TRADE_GOODS },
        [4] = { value = 'FilterConsumable', text = _G.BAG_FILTER_CONSUMABLES },
        [5] = { value = 'FilterAnima', text = _G.POWER_TYPE_ANIMA },
        [6] = { value = 'FilterRelic', text = L['Korthia Relics'] },
        [7] = { value = 'FilterEquipment', text = _G.BAG_FILTER_EQUIPMENT },
        [8] = { value = 'FilterEquipSet', text = L['Equipement Set'] },
        [9] = { value = 'FilterLegendary', text = _G.LOOT_JOURNAL_LEGENDARIES },
        [10] = { value = 'FilterCollection', text = _G.COLLECTIONS },
        [11] = { value = 'FilterFavourite', text = _G.PREFERENCES },
    }

    local offset = -10
    for _, data in ipairs(datas) do
        CreateGroupTitle(scroll, L['Item Filter'], offset)
        CreateCheckbox(scroll, offset - 30, 'Inventory', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupInventorySize(parent)
    local guiName = C.ADDON_NAME .. 'GUIInventorySize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local values = C.DB.Inventory

    local sizeDatas = {
        [1] = { key = 'SlotSize', value = values.SlotSize, text = L['Slot Size'], min = 20, max = 60, step = 1 },
        [2] = { key = 'Spacing', value = values.Spacing, text = L['Slot Spacing'], min = 3, max = 6, step = 1 },
    }

    local colDatas = {
        [1] = { key = 'BagColumns', value = values.BagColumns, text = L['Bag Columns'], min = 6, max = 20, step = 1 },
        [2] = { key = 'BankColumns', value = values.BagColumns, text = L['Bank Columns'], min = 6, max = 20, step = 1 },
    }

    local rowDatas = {
        [1] = { key = 'BagsPerRow', value = values.BagsPerRow, text = L['Bags Per Row'], min = 2, max = 10, step = 1 },
        [2] = { key = 'BankPerRow', value = values.BankPerRow, text = L['Bank Per Row'], min = 2, max = 10, step = 1 },
    }

    local offset = -10
    for _, v in ipairs(sizeDatas) do
        CreateGroupTitle(scroll, L['Size and Spacing'], offset)
        CreateSlider(scroll, 'Inventory', v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateBagSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(colDatas) do
        CreateGroupTitle(scroll, L['Columns'], offset - 50)
        CreateSlider(scroll, 'Inventory', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100, UpdateBagSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(rowDatas) do
        CreateGroupTitle(scroll, L['Rows'], offset - 100)
        CreateSlider(
            scroll,
            'Inventory',
            v.key,
            v.text,
            v.min,
            v.max,
            1,
            v.value,
            20,
            offset - 150,
            UpdateInventoryAnchor
        )
        offset = offset - 65
    end
end

function GUI:SetupMinItemLevelToShow(parent)
    local guiName = C.ADDON_NAME .. 'GUIMinItemLevelToShow'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local values = C.DB.Inventory

    local datas = {
        key = 'MinItemLevelToShow',
        value = values.MinItemLevelToShow,
        text = L['Min'],
        min = 0,
        max = 1,
        step = 0.1,
    }

    local offset = -10
    CreateGroupTitle(scroll, L['Item Level'], offset)
    CreateSlider(
        scroll,
        'Inventory',
        datas.key,
        datas.text,
        datas.min,
        datas.max,
        datas.step,
        datas.value,
        20,
        offset - 50,
        UpdateInventoryStatus
    )
end

-- Actionbar
local barsList = { 'Bar1', 'Bar2', 'Bar3', 'Bar4', 'Bar5' }
local function UpdateActionBarSize()
    for _, v in ipairs(barsList) do
        BAR:UpdateActionBarSize(v)
    end
end

local function UpdateExtraBar()
    BAR:UpdateExtraBar()
end

function GUI:SetupActionBarSize(parent)
    local guiName = C.ADDON_NAME .. 'GUIActionBarSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Actionbar
    local mKey = 'Actionbar'

    local datas = {
        bar1 = {
            [1] = { key = 'Bar1Size', value = db.Bar1Size, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar1Num', value = db.Bar1Num, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar1PerRow', value = db.Bar1PerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar1Font', value = db.Bar1Font, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar2 = {
            [1] = { key = 'Bar2Size', value = db.Bar2Size, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar2Num', value = db.Bar2Num, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar2PerRow', value = db.Bar2PerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar2Font', value = db.Bar2Font, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar3 = {
            [1] = { key = 'Bar3Size', value = db.Bar3Size, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar3Num', value = db.Bar3Num, text = L['Number'], min = 0, max = 12, step = 1 },
            [3] = { key = 'Bar3PerRow', value = db.Bar3PerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar3Font', value = db.Bar3Font, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar4 = {
            [1] = { key = 'Bar4Size', value = db.Bar4Size, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar4Num', value = db.Bar4Num, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar4PerRow', value = db.Bar4PerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar4Font', value = db.Bar4Font, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar5 = {
            [1] = { key = 'Bar5Size', value = db.Bar5Size, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar5Num', value = db.Bar5Num, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar5PerRow', value = db.Bar5PerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar5Font', value = db.Bar5Font, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        extrabar = {
            [1] = { key = 'BarExtraSize', value = db.BarExtraSize, text = L['Size'], min = 20, max = 60, step = 1 },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.bar1) do
        CreateGroupTitle(scroll, L['Bar 1'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar2) do
        CreateGroupTitle(scroll, L['Bar 2'], offset - 50)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 100, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar3) do
        CreateGroupTitle(scroll, L['Bar 3'], offset - 100)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 150, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar4) do
        CreateGroupTitle(scroll, L['SideBar 1'], offset - 150)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 200, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar5) do
        CreateGroupTitle(scroll, L['SideBar 2'], offset - 200)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 250, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.extrabar) do
        CreateGroupTitle(scroll, L['Extra Button'], offset - 250)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 300, UpdateExtraBar)
        offset = offset - 65
    end
end

local function UpdateVehicleButton()
    BAR:UpdateVehicleButton()
end

local function UpdateStanceBar()
    BAR:UpdateStanceBar()
end

function GUI:SetupVehicleButtonSize(parent)
    local guiName = C.ADDON_NAME .. 'GUIVehicleButtonSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.DB.Actionbar
    local mKey = 'Actionbar'

    local datas = {
        key = 'VehicleButtonSize',
        value = db.VehicleButtonSize,
        text = L['Button Size'],
        min = 20,
        max = 80,
        step = 1,
    }

    local offset = -10
    CreateGroupTitle(scroll, L['Leave Vehicle Button'], offset)
    CreateSlider(
        scroll,
        mKey,
        datas.key,
        datas.text,
        datas.min,
        datas.max,
        datas.step,
        datas.value,
        20,
        offset - 50,
        UpdateVehicleButton
    )
end

function GUI:SetupStanceBarSize(parent)
    local guiName = C.ADDON_NAME .. 'GUIStanceBarSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.DB.Actionbar
    local mKey = 'Actionbar'

    local datas = {
        [1] = {
            key = 'BarStanceSize',
            value = db.BarStanceSize,
            text = L['Button Size'],
            min = 20,
            max = 80,
            step = 1,
        },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Stance Bar'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateStanceBar)
        offset = offset - 65
    end
end

local function UpdateActionBarFader()
    ACTIONBAR:UpdateFaderState()
end

function GUI:SetupActionbarFader(parent)
    local guiName = C.ADDON_NAME .. 'GUIActionbarFader'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Actionbar
    local mKey = 'Actionbar'

    local datas = {
        bars = {
            [1] = { value = 'FadeBar1', text = L['Enable Fade on Bar1'] },
            [2] = { value = 'FadeBar2', text = L['Enable Fade on Bar2'] },
            [3] = { value = 'FadeBar3', text = L['Enable Fade on Bar3'] },
            [4] = { value = 'FadeBar4', text = L['Enable Fade on SideBar1'] },
            [5] = { value = 'FadeBar5', text = L['Enable Fade on SideBar2'] },
            [6] = { value = 'FadePetBar', text = L['Enable Fade on PetBar'] },
            [7] = { value = 'FadeStanceBar', text = L['Enable Fade on StanceBar'] },
        },
        conditions = {
            [1] = { value = 'Instance', text = L['Inside Instance'] },
            [2] = { value = 'Combat', text = L['Enter Combat'] },
            [3] = { value = 'Target', text = L['Have Target or Focus'] },
            [4] = { value = 'Casting', text = L['Casting'] },
            [5] = { value = 'Health', text = L['Injured'] },
            [6] = { value = 'Vehicle', text = L['Enter Vehicle'] },
        },
        sliders = {
            [1] = { text = L['Fade Out Alpha'], key = 'FadeOutAlpha', value = db.FadeOutAlpha },
            [2] = { text = L['Fade Out Duration'], key = 'FadeOutDuration', value = db.FadeOutDuration },
            [3] = { text = L['Fade In Alpha'], key = 'FadeInAlpha', value = db.FadeInAlpha },
            [4] = { text = L['Fade In Duration'], key = 'FadeInDuration', value = db.FadeInDuration },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.bars) do
        CreateGroupTitle(scroll, L['Bars'], offset)
        CreateCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateActionBarFader)
        offset = offset - 35
    end

    offset = offset - 35
    scroll.groupTitle = nil

    for _, v in ipairs(datas.conditions) do
        CreateGroupTitle(scroll, L['Conditions'], offset)
        CreateCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateActionBarFader)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.sliders) do
        CreateGroupTitle(scroll, L['Fading Parameters'], offset - 30)
        CreateSlider(scroll, mKey, v.key, v.text, 0, 1, 0.1, v.value, 20, offset - 80, UpdateActionBarFader)
        offset = offset - 65
    end
end

function GUI:SetupCooldownCount(parent)
    local guiName = C.ADDON_NAME .. 'GUICooldownCount'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Cooldown
    local mKey = 'Cooldown'

    local datas = {
        checkbox = {
            [1] = {
                value = 'OnlyNumbers',
                text = L['Only Numbers'],
                tip = L["Display only numbers, hide the 'd/h/m' suffix.|nEg. 2 mins presents as 2 instead of 2m."],
            },
            [2] = {
                value = 'IgnoreWA',
                text = L['Ignore WeakAuras'],
                tip = L['Cooldown timer ignore WeakAuras icon.|nYou can still use WeakAuras own timer.'],
            },
        },
        slider = {
            [1] = {
                key = 'MmssTH',
                value = db.MmssTH,
                min = 60,
                max = 600,
                step = 1,
                text = L['MM:SS Threshold'],
                tip = L['If cooldown less than current threhold, display cooldown in format MM:SS.|nEg. 2 mins and half presents as 2:30.'],
            },
            [2] = {
                key = 'TenthTH',
                value = db.TenthTH,
                min = 0,
                max = 60,
                step = 1,
                text = L['Tenth Threshold'],
                tip = L['If cooldown less than current threhold, display cooldown in format decimal.|nEg. 3 secs will display as 3.0.'],
            },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.checkbox) do
        CreateGroupTitle(scroll, L['Cooldown'], offset)
        CreateCheckbox(scroll, offset - 30, mKey, v.value, v.text, nil, v.tip)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.slider) do
        CreateGroupTitle(scroll, L['Threhold'], offset - 30)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 80, nil, v.tip)
        offset = offset - 65
    end
end

-- Nameplate

local function RefreshAllPlates()
    NAMEPLATE:RefreshAllPlates()
end

local function RefreshNameplateAuraFilters()
    NAMEPLATE:RefreshNameplateAuraFilters()
end

function GUI:SetupNameplateAuraFilter(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateAuraFilter'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    panel:SetScript('OnHide', RefreshNameplateAuraFilters)

    local frameData = {
        [1] = {
            text = L['Nameplate Aura White List'],
            tip = L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
            offset = -25,
            barList = {},
        },
        [2] = {
            text = L['Nameplate Aura Black List'],
            tip = L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
            offset = -315,
            barList = {},
        },
    }

    local function createBar(parent, index, spellID)
        local name, _, texture = GetSpellInfo(spellID)
        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 30)
        bar.bg = F.CreateBD(bar, 0.25)
        frameData[index].barList[spellID] = bar

        local icon, close = GUI:CreateBarWidgets(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript('OnClick', function()
            bar:Hide()

            if
                (index == 1 and C.NameplateAuraWhiteList[spellID])
                or (index == 2 and C.NameplateAuraBlackList[spellID])
            then
                _G.FREE_ADB['NameplateAuraFilterList'][index][spellID] = false
            else
                _G.FREE_ADB['NameplateAuraFilterList'][index][spellID] = nil
            end

            frameData[index].barList[spellID] = nil
            SortBars(frameData[index].barList)
        end)

        local spellName = F.CreateFS(bar, C.Assets.Font.Regular, 12, nil, name, nil, true, 'LEFT', 30, 0)
        spellName:SetWidth(180)
        spellName:SetJustifyH('LEFT')
        if index == 2 then
            spellName:SetTextColor(1, 0, 0)
        end

        SortBars(frameData[index].barList)
    end

    local function isAuraExisted(index, spellID)
        local modValue = _G.FREE_ADB['NameplateAuraFilterList'][index][spellID]
        local locValue = (index == 1 and C.NameplateAuraWhiteList[spellID])
            or (index == 2 and C.NameplateAuraBlackList[spellID])

        return modValue or (modValue == nil and locValue)
    end

    local function addClick(parent, index)
        local spellID = tonumber(parent.box:GetText())
        if not spellID or not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
            return
        end

        if isAuraExisted(index, spellID) then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
            return
        end

        _G.FREE_ADB['NameplateAuraFilterList'][index][spellID] = true
        createBar(parent.child, index, spellID)
        parent.box:SetText('')
    end

    local filterIndex
    StaticPopupDialogs['FREEUI_RESET_NAMEPLATE_AURA_FILTER'] = {
        text = C.RED_COLOR .. L['Reset to default list?'],
        button1 = _G.YES,
        button2 = _G.NO,
        OnAccept = function()
            wipe(_G.FREE_ADB['NameplateAuraFilterList'][filterIndex])
            ReloadUI()
        end,
        whileDead = 1,
    }

    for index, value in ipairs(frameData) do
        F.CreateFS(panel, C.Assets.Font.Regular, 14, nil, value.text, 'YELLOW', true, 'TOPLEFT', 20, value.offset)
        local frame = CreateFrame('Frame', nil, panel, 'BackdropTemplate')
        frame:SetSize(240, 250)
        frame:SetPoint('TOPLEFT', 10, value.offset - 25)
        frame.bg = F.CreateBDFrame(frame, 0.25)

        local scroll = GUI:CreateScroll(frame, 200, 200, nil, true)
        scroll:ClearAllPoints()
        scroll:SetPoint('BOTTOMLEFT', 10, 10)

        scroll.box = F.CreateEditBox(frame, 130, 25)
        scroll.box:SetPoint('TOPLEFT', 10, -10)
        F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', value.tip, 'BLUE')

        scroll.add = F.CreateButton(frame, 40, 25, _G.ADD, 11)
        scroll.add:SetPoint('TOPRIGHT', -8, -10)
        scroll.add:SetScript('OnClick', function()
            addClick(scroll, index)
        end)

        scroll.reset = F.CreateButton(frame, 40, 25, _G.RESET, 11)
        scroll.reset:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
        scroll.reset:SetScript('OnClick', function()
            filterIndex = index
            StaticPopup_Show('FREEUI_RESET_NAMEPLATE_AURA_FILTER')
        end)

        for spellID, value in pairs(NAMEPLATE.AuraFilterList[index]) do
            if value then
                createBar(scroll.child, index, spellID)
            end
        end
    end
end

local function RefreshMajorSpellsFilter()
    NAMEPLATE:RefreshMajorSpellsFilter()
end

function GUI:SetupNameplateMajorSpells(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateCastbarGlow'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, L['Major Spells Filter'], true)
    panel:SetScript('OnHide', RefreshMajorSpellsFilter)
    parent.panel = panel

    panel.barTable = {}
    panel.tableName = 'MajorSpellsList'

    local scrollArea = GUI:CreateScroll(panel.bg, 200, 485)
    panel.scrollArea = scrollArea

    local editBox = createEditBox(panel.bg, nil, 10, -10, nil, 110, 24)
    panel.editBox = editBox
    editBox.title = L['Hint']
    F.AddTooltip(
        editBox,
        'ANCHOR_RIGHT',
        L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
        'BLUE',
        true
    )

    local addBtn = F.CreateButton(panel.bg, 50, 24, _G.ADD)
    addBtn:SetPoint('TOPRIGHT', -8, -10)
    addBtn:HookScript('OnClick', addOnClick)
    addBtn.__owner = panel

    local resetBtn = F.CreateButton(panel.bg, 50, 24, _G.RESET)
    resetBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
    resetBtn:HookScript('OnClick', function()
        StaticPopup_Show('FREEUI_RESET_MAJOR_SPELLS_LIST')
    end)

    for spellID, value in pairs(NAMEPLATE[panel.tableName]) do
        if value then
            createBars(scrollArea, spellID, panel.barTable, panel.tableName)
        end
    end
end

local function UpdateNameplateCVars()
    NAMEPLATE:UpdateNameplateCVars()
end

function GUI:SetupNameplateCVars(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateCvars'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Nameplate

    local datas = {
        [1] = { key = 'MinScale', value = db.MinScale, text = L['MinScale'], min = 0.5, max = 1, step = 0.1 },
        [2] = { key = 'TargetScale', value = db.TargetScale, text = L['TargetScale'], min = 1, max = 2, step = 0.1 },
        [3] = { key = 'MinAlpha', value = db.MinAlpha, text = L['TargetScale'], min = 0.5, max = 1, step = 0.1 },
        [4] = {
            key = 'OccludedAlpha',
            value = db.OccludedAlpha,
            text = L['OccludedAlpha'],
            min = 0.2,
            max = 1,
            step = 0.1,
        },
        [5] = {
            key = 'VerticalSpacing',
            value = db.VerticalSpacing,
            text = L['VerticalSpacing'],
            min = 0.3,
            max = 3,
            step = 0.1,
        },
        [6] = {
            key = 'HorizontalSpacing',
            value = db.HorizontalSpacing,
            text = L['HorizontalSpacing'],
            min = 0.3,
            max = 3,
            step = 0.1,
        },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Nameplate CVars'], offset)
        CreateSlider(
            scroll,
            'Nameplate',
            v.key,
            v.text,
            v.min,
            v.max,
            v.step,
            v.value,
            20,
            offset - 50,
            UpdateNameplateCVars
        )
        offset = offset - 65
    end
end

local function UpdateClickableSize()
    NAMEPLATE:UpdateClickableSize()
end

function GUI:SetupNameplateSize(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Nameplate
    local mKey = 'Nameplate'

    local datas = {
        size = {
            [1] = { key = 'Width', value = db.Width, text = L['Width'], min = 40, max = 400, step = 1 },
            [2] = { key = 'Height', value = db.Height, text = L['Height'], min = 4, max = 40, step = 1 },
        },
        clickableSize = {
            [1] = {
                key = 'ClickableWidth',
                value = db.ClickableWidth,
                text = L['Width'],
                min = 40,
                max = 400,
                step = 1,
            },
            [2] = {
                key = 'ClickableHeight',
                value = db.ClickableHeight,
                text = L['Height'],
                min = 4,
                max = 40,
                step = 1,
            },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.size) do
        CreateGroupTitle(scroll, L['Nameplate Size'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, RefreshAllPlates)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.clickableSize) do
        CreateGroupTitle(scroll, L['Clickable Size'], offset - 50)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100, UpdateClickableSize)
        offset = offset - 65
    end
end

function GUI:SetupNameplateFriendlySize(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateFriendlySize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Nameplate
    local mKey = 'Nameplate'

    local datas = {
        size = {
            [1] = { key = 'FriendlyWidth', value = db.FriendlyWidth, text = L['Width'], min = 1, max = 200, step = 1 },
            [2] = {
                key = 'FriendlyHeight',
                value = db.FriendlyHeight,
                text = L['Height'],
                min = 1,
                max = 40,
                step = 1,
            },
        },
        clickableSize = {
            [1] = {
                key = 'FriendlyClickableWidth',
                value = db.FriendlyClickableWidth,
                text = L['Width'],
                min = 1,
                max = 200,
                step = 1,
            },
            [2] = {
                key = 'FriendlyClickableHeight',
                value = db.FriendlyClickableHeight,
                text = L['Height'],
                min = 1,
                max = 40,
                step = 1,
            },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.size) do
        CreateGroupTitle(scroll, L['Friendly Nameplate Size'], offset)
        CreateSlider(
            scroll,
            'Nameplate',
            v.key,
            v.text,
            v.min,
            v.max,
            v.step,
            v.value,
            20,
            offset - 50,
            RefreshAllPlates
        )
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.clickableSize) do
        CreateGroupTitle(scroll, L['Clickable Size'], offset - 50)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100, UpdateClickableSize)
        offset = offset - 65
    end
end

function GUI:SetupNameplateCastbarSize(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateCastbarSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Nameplate

    local datas = { key = 'CastbarHeight', value = db.CastbarHeight, text = L['Height'], min = 6, max = 20, step = 1 }

    local offset = -10
    CreateGroupTitle(scroll, L['Nameplate Castbar'], offset)
    CreateSlider(
        scroll,
        'Nameplate',
        datas.key,
        datas.text,
        datas.min,
        datas.max,
        datas.step,
        datas.value,
        20,
        offset - 50
    )
end

function GUI:SetupNameplateExecuteIndicator(parent)
    local guiName = C.ADDON_NAME .. 'GUINameplateExecuteIndicator'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local values = C.DB.Nameplate

    local datas = {
        key = 'ExecuteRatio',
        value = values.ExecuteRatio,
        text = L['Execute Ratio'],
        min = 1,
        max = 90,
        step = 1,
    }

    local offset = -30
    CreateSlider(scroll, 'Nameplate', datas.key, datas.text, datas.min, datas.max, datas.step, datas.value, 20, offset)
end

local function RefreshSpecialUnitsList()
    NAMEPLATE:RefreshSpecialUnitsList()
end

function GUI:SetupNameplateUnitFilter(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateUnitFilter'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, nil, true)
    panel:SetScript('OnHide', RefreshSpecialUnitsList)

    local barTable = {}

    local function createBar(parent, text, isNew)
        local npcID = tonumber(text)

        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 30)
        F.CreateBD(bar, 0.25)
        barTable[text] = bar

        local icon, close = GUI:CreateBarWidgets(bar, npcID and 136243 or 132288)
        if npcID then
            F.AddTooltip(icon, 'ANCHOR_RIGHT', 'ID: ' .. npcID)
        end
        close:SetScript('OnClick', function()
            bar:Hide()
            barTable[text] = nil
            if C.SpecialUnitsList[text] then
                C.DB['Nameplate']['SpecialUnitsList'][text] = false
            else
                C.DB['Nameplate']['SpecialUnitsList'][text] = nil
            end
            SortBars(barTable)
        end)

        local name = F.CreateFS(bar, C.Assets.Font.Regular, 12, nil, text, nil, true, 'LEFT', 30, 0)
        name:SetWidth(180)
        name:SetJustifyH('LEFT')
        if isNew then
            name:SetTextColor(0, 1, 0)
        end
        if npcID then
            F.GetNPCName(npcID, function(npcName)
                name:SetText(npcName)
                if npcName == _G.UNKNOWN then
                    name:SetTextColor(1, 0, 0)
                end
            end)
        end

        SortBars(barTable)
    end

    local frame = panel.bg
    local scroll = GUI:CreateScroll(frame, 200, 485)

    local swatch = F.CreateColorSwatch(frame, nil, C.DB['Nameplate']['SpecialUnitColor'])
    swatch:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)
    swatch.__default = C.CharacterSettings['Nameplate']['SpecialUnitColor']
    swatch:SetSize(25, 25)

    scroll.box = F.CreateEditBox(frame, 100, 25)
    scroll.box:SetPoint('LEFT', swatch, 'RIGHT', 5, 0)
    F.AddTooltip(scroll.box, 'ANCHOR_TOPRIGHT', L['Enter NPC ID or name directly.'], 'BLUE')

    local function addClick(button)
        local parent = button.__owner
        local text = tonumber(parent.box:GetText()) or parent.box:GetText()
        if text and text ~= '' then
            local modValue = C.DB['Nameplate']['SpecialUnitsList'][text]
            if modValue or modValue == nil and C.SpecialUnitsList[text] then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
                return
            end
            C.DB['Nameplate']['SpecialUnitsList'][text] = true
            createBar(parent.child, text, true)
            parent.box:SetText('')
        end
    end

    scroll.add = F.CreateButton(frame, 40, 25, _G.ADD, 11)
    scroll.add:SetPoint('TOPRIGHT', -8, -10)
    scroll.add.__owner = scroll
    scroll.add:SetScript('OnClick', addClick)

    scroll.reset = F.CreateButton(frame, 40, 25, _G.RESET, 11)
    scroll.reset:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.reset:SetScript('OnClick', function()
        StaticPopup_Show('FREEUI_RESET_NAMEPLATE_SPECIAL_UNIT_FILTER')
    end)

    for npcID in pairs(NAMEPLATE.SpecialUnitsList) do
        createBar(scroll.child, npcID)
    end
end

function GUI:SetupNameplateColorByDot(parent)
    local guiName = C.ADDON_NAME .. 'GUINamePlateColorByDot'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, nil, true)

    local barTable = {}

    local function createBar(parent, spellID, isNew)
        local spellName = GetSpellInfo(spellID)
        local texture = GetSpellTexture(spellID)

        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 30)
        F.CreateBD(bar, 0.25)
        barTable[spellID] = bar

        local icon, close = GUI:CreateBarWidgets(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript('OnClick', function()
            bar:Hide()
            barTable[spellID] = nil
            C.DB['Nameplate']['DotSpellsList'][spellID] = nil
            SortBars(barTable)
        end)

        local name = F.CreateFS(bar, C.Assets.Font.Regular, 12, nil, spellName, nil, true, 'LEFT', 30, 0)
        name:SetWidth(180)
        name:SetJustifyH('LEFT')
        if isNew then
            name:SetTextColor(0, 1, 0)
        end

        SortBars(barTable)
    end

    local frame = panel.bg
    local scroll = GUI:CreateScroll(frame, 200, 485)

    local swatch = F.CreateColorSwatch(frame, nil, C.DB['Nameplate']['DotColor'])
    swatch:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)
    swatch.__default = C.CharacterSettings['Nameplate']['DotColor']
    swatch:SetSize(25, 25)

    scroll.box = F.CreateEditBox(frame, 100, 25)
    scroll.box:SetPoint('LEFT', swatch, 'RIGHT', 5, 0)
    F.AddTooltip(
        scroll.box,
        'ANCHOR_TOPRIGHT',
        L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
        'BLUE'
    )

    local function addClick(button)
        local parent = button.__owner
        local spellID = tonumber(parent.box:GetText())

        if not spellID or not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
            return
        end

        if C.DB['Nameplate']['DotSpellsList'][spellID] then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
            return
        end

        C.DB['Nameplate']['DotSpellsList'][spellID] = true
        createBar(parent.child, spellID, true)
        parent.box:SetText('')
    end

    scroll.add = F.CreateButton(frame, 40, 25, _G.ADD, 11)
    scroll.add:SetPoint('TOPRIGHT', -8, -10)
    scroll.add.__owner = scroll
    scroll.add:SetScript('OnClick', addClick)

    scroll.reset = F.CreateButton(frame, 40, 25, _G.RESET, 11)
    scroll.reset:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.reset:SetScript('OnClick', function()
        StaticPopup_Show('FREEUI_RESET_NAMEPLATE_DOT_SPELLS')
    end)

    for npcID in pairs(C.DB['Nameplate']['DotSpellsList']) do
        createBar(scroll.child, npcID)
    end
end

-- Unitframe

local function SetUnitFrameSize(self, unit)
    local width = C.DB.Unitframe[unit .. 'Width']
    local healthHeight = C.DB.Unitframe[unit .. 'HealthHeight']
    local powerHeight = C.DB.Unitframe[unit .. 'PowerHeight']
    local height = healthHeight + powerHeight + C.MULT
    self:SetSize(width, height)
    self.Health:SetHeight(healthHeight)
    self.Power:SetHeight(powerHeight)
end

local function UpdateUnitFrameSize()
    SetUnitFrameSize(_G.oUF_Player, 'Player')
    SetUnitFrameSize(_G.oUF_Pet, 'Pet')
    SetUnitFrameSize(_G.oUF_Target, 'Target')
    SetUnitFrameSize(_G.oUF_TargetTarget, 'TargetTarget')
    SetUnitFrameSize(_G.oUF_Focus, 'Focus')
    SetUnitFrameSize(_G.oUF_FocusTarget, 'FocusTarget')

    UNITFRAME:UpdateAuras()
end

local function UpdatePartyFrameSize()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'party' then
            SetUnitFrameSize(frame, 'Party')
        end
    end
    if UNITFRAME.CreateAndUpdatePartyHeader then
        UNITFRAME:CreateAndUpdatePartyHeader()
    end
    UNITFRAME:UpdatePartyElements()
end

function GUI:SetupPartyFrame(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupPartyFrame'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'PartyWidth', value = db.PartyWidth, text = L['Width'], min = 10, max = 200 },
        [2] = {
            key = 'PartyHealthHeight',
            value = db.PartyHealthHeight,
            text = L['Health Height'],
            min = 10,
            max = 200,
        },
        [3] = { key = 'PartyPowerHeight', value = db.PartyPowerHeight, text = L['Power Height'], min = 1, max = 20 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Party Frame'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdatePartyFrameSize)
        offset = offset - 65
    end

    local options = {}
    for i = 1, 4 do
        options[i] = UNITFRAME.PartyDirections[i].name
    end

    CreateOptionDropdown(
        scroll,
        L['Growth Direction'],
        offset - 60,
        options,
        nil,
        mKey,
        'PartyDirec',
        1,
        UpdatePartyFrameSize
    )
end

local function UpdateRaidFrameDirection()
    if UNITFRAME.CreateAndUpdateRaidHeader then
        UNITFRAME:CreateAndUpdateRaidHeader()
        UNITFRAME:UpdateRaidTeamIndex()
    end
end

local function UpdateRaidFrameSize()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'raid' and not frame.raidType then
            SetUnitFrameSize(frame, 'Raid')
        end
    end
    if UNITFRAME.CreateAndUpdateRaidHeader then
        UNITFRAME:CreateAndUpdateRaidHeader()
        UNITFRAME:UpdateAllHeaders()
    end
end

function GUI:SetupRaidFrame(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupRaidFrame'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'RaidWidth', value = db.RaidWidth, text = L['Width'], min = 10, max = 200 },
        [2] = { key = 'RaidHealthHeight', value = db.RaidHealthHeight, text = L['Health Height'], min = 10, max = 200 },
        [3] = { key = 'RaidPowerHeight', value = db.RaidPowerHeight, text = L['Power Height'], min = 1, max = 20 },
        [4] = { key = 'NumGroups', value = db.NumGroups, text = L['Groups to Show'], min = 1, max = 8 },
        [5] = { key = 'RaidRows', value = db.RaidRows, text = L['Groups per row'], min = 1, max = 8 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Raid Frame'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateRaidFrameSize)
        offset = offset - 65
    end

    local options = {}
    for i = 1, 8 do
        options[i] = UNITFRAME.RaidDirections[i].name
    end

    CreateOptionDropdown(
        scroll,
        L['Growth Direction'],
        offset - 60,
        options,
        L['Change the growth direction for RaidFrames.|nDirection on the left is the growth method within your group. Direction on the right is the growth method between groups.'],
        mKey,
        'RaidDirec',
        1,
        UpdateRaidFrameDirection
    )
end

local function UpdateSimpleRaidFrameSize()
    for _, frame in pairs(oUF.objects) do
        if frame.raidType == 'simple' then
            local scale = C.DB.Unitframe.SMRScale / 10
            local frameWidth = 100 * scale
            local frameHeight = 20 * scale
            local powerHeight = 2 * scale
            local healthHeight = frameHeight - powerHeight
            frame:SetSize(frameWidth, frameHeight)
            frame.Health:SetHeight(healthHeight)
            frame.Power:SetHeight(powerHeight)
        end
    end

    if UNITFRAME.UpdateSimpleModeHeader then
        UNITFRAME:UpdateSimpleModeHeader()
    end
end

function GUI:SetupSimpleRaidFrame(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupSimpleRaidFrame'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'SMRScale', value = db.SMRScale, text = L['Scale'], min = 6, max = 20 },
        [2] = { key = 'SMRPerCol', value = db.SMRPerCol, text = L['Units Per Column'], min = 5, max = 40 },
        [3] = { key = 'SMRGroups', value = db.SMRGroups, text = L['Groups to Show'], min = 1, max = 8 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Simple Raid Frames'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateSimpleRaidFrameSize)
        offset = offset - 65
    end

    local options = {}
    for i = 1, 4 do
        options[i] = UNITFRAME.RaidDirections[i].name
    end

    CreateOptionDropdown(scroll, L['Growth Direction'], offset - 60, options, nil, mKey, 'SMRDirec', 1)
    CreateOptionDropdown(
        scroll,
        L['Group By'],
        offset - 110,
        { _G.GROUP, _G.CLASS, _G.ROLE },
        nil,
        mKey,
        'SMRGroupBy',
        1,
        UpdateSimpleRaidFrameSize
    )
end

function GUI:SetupUnitFrame(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupUnitFrame'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        player = {
            [1] = { key = 'PlayerWidth', value = db.PlayerWidth, text = L['Width'], min = 10, max = 400, step = 1 },
            [2] = {
                key = 'PlayerHealthHeight',
                value = db.PlayerHealthHeight,
                text = L['Health Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [3] = {
                key = 'PlayerPowerHeight',
                value = db.PlayerPowerHeight,
                text = L['Power Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [4] = {
                key = 'PlayerAuraPerRow',
                value = db.PlayerAuraPerRow,
                text = L['Auras Per Row'],
                min = 0,
                max = 10,
                step = 1,
            },
        },
        pet = {
            [1] = { key = 'PetWidth', value = db.PetWidth, text = L['Width'], min = 10, max = 400, step = 1 },
            [2] = {
                key = 'PetHealthHeight',
                value = db.PetHealthHeight,
                text = L['Health Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [3] = {
                key = 'PetPowerHeight',
                value = db.PetPowerHeight,
                text = L['Power Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [4] = {
                key = 'PetAuraPerRow',
                value = db.PetAuraPerRow,
                text = L['Auras Per Row'],
                min = 0,
                max = 10,
                step = 1,
            },
        },
        target = {
            [1] = { key = 'TargetWidth', value = db.TargetWidth, text = L['Width'], min = 10, max = 400, step = 1 },
            [2] = {
                key = 'TargetHealthHeight',
                value = db.TargetHealthHeight,
                text = L['Health Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [3] = {
                key = 'TargetPowerHeight',
                value = db.TargetPowerHeight,
                text = L['Power Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [4] = {
                key = 'TargetAuraPerRow',
                value = db.TargetAuraPerRow,
                text = L['Auras Per Row'],
                min = 0,
                max = 10,
                step = 1,
            },
        },
        tot = {
            [1] = {
                key = 'TargetTargetWidth',
                value = db.TargetTargetWidth,
                text = L['Width'],
                min = 10,
                max = 400,
                step = 1,
            },
            [2] = {
                key = 'TargetTargetHealthHeight',
                value = db.TargetTargetHealthHeight,
                text = L['Health Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [3] = {
                key = 'TargetTargetPowerHeight',
                value = db.TargetTargetPowerHeight,
                text = L['Power Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [4] = {
                key = 'TargetTargetAuraPerRow',
                value = db.TargetTargetAuraPerRow,
                text = L['Auras Per Row'],
                min = 0,
                max = 10,
                step = 1,
            },
        },
        focus = {
            [1] = { key = 'FocusWidth', value = db.FocusWidth, text = L['Width'], min = 10, max = 400, step = 1 },
            [2] = {
                key = 'FocusHealthHeight',
                value = db.FocusHealthHeight,
                text = L['Health Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [3] = {
                key = 'FocusPowerHeight',
                value = db.FocusPowerHeight,
                text = L['Power Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [4] = {
                key = 'FocusAuraPerRow',
                value = db.FocusAuraPerRow,
                text = L['Auras Per Row'],
                min = 0,
                max = 10,
                step = 1,
            },
        },
        tof = {
            [1] = {
                key = 'FocusTargetWidth',
                value = db.FocusTargetWidth,
                text = L['Width'],
                min = 10,
                max = 400,
                step = 1,
            },
            [2] = {
                key = 'FocusTargetHealthHeight',
                value = db.FocusTargetHealthHeight,
                text = L['Health Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [3] = {
                key = 'FocusTargetPowerHeight',
                value = db.FocusTargetPowerHeight,
                text = L['Power Height'],
                min = 1,
                max = 40,
                step = 1,
            },
            [4] = {
                key = 'FocusTargetAuraPerRow',
                value = db.FocusTargetAuraPerRow,
                text = L['Auras Per Row'],
                min = 0,
                max = 10,
                step = 1,
            },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.player) do
        CreateGroupTitle(scroll, L['Player Frame'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.pet) do
        CreateGroupTitle(scroll, L['Pet Frame'], offset - 50)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 100, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.target) do
        CreateGroupTitle(scroll, L['Target Frame'], offset - 100)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 150, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.tot) do
        CreateGroupTitle(scroll, L['Target of Target Frame'], offset - 150)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 200, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.focus) do
        CreateGroupTitle(scroll, L['Focus Frame'], offset - 200)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 250, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.tof) do
        CreateGroupTitle(scroll, L['Target of Focus Frame'], offset - 250)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 300, UpdateUnitFrameSize)
        offset = offset - 65
    end
end

function GUI:SetupBossFrame(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupBossFrame'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local bossDatas = {
        [1] = { key = 'BossWidth', value = db.BossWidth, text = L['Width'], min = 10, max = 400, step = 1 },
        [2] = {
            key = 'BossHealthHeight',
            value = db.BossHealthHeight,
            text = L['Health Height'],
            min = 1,
            max = 40,
            step = 1,
        },
        [3] = {
            key = 'BossPowerHeight',
            value = db.BossPowerHeight,
            text = L['Power Height'],
            min = 1,
            max = 40,
            step = 1,
        },
        [4] = {
            key = 'BossAuraPerRow',
            value = db.BossAuraPerRow,
            text = L['Auras Per Row'],
            min = 0,
            max = 10,
            step = 1,
        },
        [5] = { key = 'BossGap', value = db.BossGap, text = L['Gap'], min = 10, max = 100, step = 1 },
    }

    local offset = -10
    for _, v in ipairs(bossDatas) do
        CreateGroupTitle(scroll, L['Boss Frame'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
        offset = offset - 65
    end
end

function GUI:SetupArenaFrame(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupArenaFrame'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local bossDatas = {
        [1] = { key = 'ArenaWidth', value = db.ArenaWidth, text = L['Width'], min = 10, max = 400, step = 1 },
        [2] = {
            key = 'ArenaHealthHeight',
            value = db.ArenaHealthHeight,
            text = L['Health Height'],
            min = 1,
            max = 40,
            step = 1,
        },
        [3] = {
            key = 'ArenaPowerHeight',
            value = db.ArenaPowerHeight,
            text = L['Power Height'],
            min = 1,
            max = 40,
            step = 1,
        },
        [4] = {
            key = 'ArenaAuraPerRow',
            value = db.ArenaAuraPerRow,
            text = L['Auras Per Row'],
            min = 0,
            max = 10,
            step = 1,
        },
        [5] = { key = 'ArenaGap', value = db.ArenaGap, text = L['Gap'], min = 10, max = 100, step = 1 },
    }

    local offset = -10
    for _, v in ipairs(bossDatas) do
        CreateGroupTitle(scroll, L['Arena Frame'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
        offset = offset - 65
    end
end

function GUI:SetupClassPower(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupClassPower'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Unitframe
    local mKey = 'Unitframe'

    local datas = {
        slider = {
            [1] = {
                key = 'ClassPowerHeight',
                value = db.ClassPowerHeight,
                text = L['Height'],
                min = 1,
                max = 20,
                step = 1,
            },
        },
        checkbox = { [1] = { value = 'RunesTimer', text = L['Runes Timer'], tip = L['Display timer for DK Runes.'] } },
    }

    local offset = -10
    for _, v in ipairs(datas.slider) do
        CreateGroupTitle(scroll, L['Class Power'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.checkbox) do
        CreateGroupTitle(scroll, L['Runes'], offset - 100)
        CreateCheckbox(scroll, offset - 130, mKey, v.value, v.text, nil, v.tip)
        offset = offset - 35
    end
end

local function UpdateFader()
    UNITFRAME:UpdateFader()
end

function GUI:SetupUnitFrameFader(parent)
    local guiName = C.ADDON_NAME .. 'GUIUnitFrameFader'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local mKey = 'Unitframe'

    local datas = {
        conditions = {
            [1] = { value = 'Instance', text = L['Inside Instance'] },
            [2] = { value = 'Combat', text = L['Enter Combat'] },
            [3] = { value = 'Target', text = L['Have Target or Focus'] },
            [4] = { value = 'Casting', text = L['Casting'] },
            [5] = { value = 'Health', text = L['Injured'] },
        },
        fader = {
            [1] = { key = 'MinAlpha', value = '0', text = L['Fade Out Alpha'] },
            [2] = { key = 'MaxAlpha', value = '1', text = L['Fade In Alpha'] },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.conditions) do
        CreateGroupTitle(scroll, L['Conditions'], offset)
        CreateCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateFader)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.fader) do
        CreateGroupTitle(scroll, L['Fading Parameters'], offset - 30)
        CreateSlider(scroll, mKey, v.key, v.text, 0, 1, 0.1, v.value, 20, offset - 80, UpdateFader)
        offset = offset - 65
    end
end

function GUI:SetupUnitFrameRangeCheck(parent)
    local guiName = C.ADDON_NAME .. 'GUIRangeCheck'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.CharacterSettings.Unitframe

    local datas = {
        key = 'OutRangeAlpha',
        value = db.RangeCheckAlpha,
        text = L['Out Range Alpha'],
        min = 0.1,
        max = 1,
        step = 0.1,
    }

    local offset = -10
    CreateGroupTitle(scroll, L['Range Check'], offset)
    CreateSlider(
        scroll,
        'Unitframe',
        datas.key,
        datas.text,
        datas.min,
        datas.max,
        datas.step,
        datas.value,
        20,
        offset - 50
    )
end

function GUI:SetupCastbar(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupCastbar'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        player = {
            [1] = {
                key = 'PlayerCastbarWidth',
                value = db.PlayerCastbarWidth,
                text = L['Width'],
                min = 30,
                max = 600,
                step = 1,
            },
            [2] = {
                key = 'PlayerCastbarHeight',
                value = db.PlayerCastbarHeight,
                text = L['Height'],
                min = 4,
                max = 60,
                step = 1,
            },
        },
        target = {
            [1] = {
                key = 'TargetCastbarWidth',
                value = db.TargetCastbarWidth,
                text = L['Width'],
                min = 30,
                max = 600,
                step = 1,
            },
            [2] = {
                key = 'TargetCastbarHeight',
                value = db.TargetCastbarHeight,
                text = L['Height'],
                min = 4,
                max = 60,
                step = 1,
            },
        },
        focus = {
            [1] = {
                key = 'FocusCastbarWidth',
                value = db.FocusCastbarWidth,
                text = L['Width'],
                min = 30,
                max = 600,
                step = 1,
            },
            [2] = {
                key = 'FocusCastbarHeight',
                value = db.FocusCastbarHeight,
                text = L['Height'],
                min = 4,
                max = 60,
                step = 1,
            },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.player) do
        CreateGroupTitle(scroll, L['Player Castbar'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.target) do
        CreateGroupTitle(scroll, L['Target Castbar'], offset - 50)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 100)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.focus) do
        CreateGroupTitle(scroll, L['Focus Castbar'], offset - 100)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 150)
        offset = offset - 65
    end
end

function GUI:SetupCastbarColor(parent)
    local guiName = C.ADDON_NAME .. 'GUICastbarColor'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local db = C.DB.Unitframe

    local datas = {
        [1] = { key = 'CastingColor', value = db.CastingColor, text = L['Regular Casting'] },
        [2] = { key = 'UninterruptibleColor', value = db.UninterruptibleColor, text = L['Uninterruptible Casting'] },
        [3] = { key = 'CompleteColor', value = db.CompleteColor, text = L['Casting Complete'] },
        [4] = { key = 'FailColor', value = db.FailColor, text = L['Casting Fail'] },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Castbar Color'], offset)
        CreateColorSwatch(scroll, v.value, v.text, C.CharacterSettings.Unitframe[v.key], offset - 34)

        offset = offset - 30
    end
end

local function UpdatePartyWatcherSpells()
    UNITFRAME:UpdatePartyWatcherSpells()
end

function GUI:SetupPartyWatcher(parent)
    local guiName = C.ADDON_NAME .. 'GUIPartySpellSetup'
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
        F.CreateBD(bar, 0.25)
        barTable[spellID] = bar

        local icon, close = GUI:CreateBarWidgets(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript('OnClick', function()
            bar:Hide()
            if C.PartySpellsList[spellID] then
                _G.FREE_ADB['PartySpellsList'][spellID] = 0
            else
                _G.FREE_ADB['PartySpellsList'][spellID] = nil
            end
            barTable[spellID] = nil
            SortBars(barTable)
        end)

        local font = C.Assets.Font.Regular
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

    options[1] = createEditBox(
        frame,
        L['SpellID'],
        10,
        -30,
        L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
        107,
        24
    )
    options[2] = createEditBox(
        frame,
        L['Spell Cooldown'],
        122,
        -30,
        L["Enter the spell's cooldown duration.|nParty watcher only support regular spells and abilities.|nFor spells like 'Aspect of the Wild' (BM Hunter), you need to sync cooldown with your party members."],
        108,
        24
    )

    local scroll = GUI:CreateScroll(frame, 200, 440)
    scroll:ClearAllPoints()
    scroll:SetPoint('TOPLEFT', 10, -94)

    scroll.reset = F.CreateButton(frame, 51, 24, _G.RESET, 11)
    scroll.reset:SetPoint('TOPLEFT', 10, -60)
    scroll.reset.text:SetTextColor(1, 0, 0)

    scroll.reset:SetScript('OnClick', function()
        StaticPopup_Show('FREEUI_RESET_PARTY_SPELLS')
    end)

    local function addClick(scroll, options)
        local spellID, duration = tonumber(options[1]:GetText()), tonumber(options[2]:GetText())
        if not spellID or not duration then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['You need to complete all optinos'])
            return
        end

        if not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
            return
        end

        local modDuration = _G.FREE_ADB['PartySpellsList'][spellID]

        if modDuration and modDuration ~= 0 or C.PartySpellsList[spellID] and not modDuration then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
            return
        end

        _G.FREE_ADB['PartySpellsList'][spellID] = duration
        createBar(scroll.child, spellID, duration)
        ClearEdit(options)
    end

    scroll.add = F.CreateButton(frame, 51, 24, _G.ADD, 11)
    scroll.add:SetPoint('TOPRIGHT', -10, -60)
    scroll.add:SetScript('OnClick', function()
        addClick(scroll, options)
    end)

    scroll.clear = F.CreateButton(frame, 51, 24, _G.KEY_NUMLOCK_MAC, 11)
    scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.clear:SetScript('OnClick', function()
        ClearEdit(options)
    end)

    local menuList = {}
    local function AddSpellFromPreset(_, spellID, duration)
        options[1]:SetText(spellID)
        options[2]:SetText(duration)
        _G.DropDownList1:Hide()
    end

    local index = 1
    for class, value in pairs(C.PartySpellsDB) do
        local color = F:RgbToHex(F:ClassColor(class))
        local localClassName = _G.LOCALIZED_CLASS_NAMES_MALE[class]
        menuList[index] = { text = color .. localClassName, notCheckable = true, hasArrow = true, menuList = {} }

        for spellID, duration in pairs(value) do
            local spellName, _, texture = GetSpellInfo(spellID)
            if spellName then
                table.insert(menuList[index].menuList, {
                    text = spellName,
                    icon = texture,
                    tCoordLeft = 0.08,
                    tCoordRight = 0.92,
                    tCoordTop = 0.08,
                    tCoordBottom = 0.92,
                    arg1 = spellID,
                    arg2 = duration,
                    func = AddSpellFromPreset,
                    notCheckable = true,
                })
            end
        end
        index = index + 1
    end
    scroll.preset = F.CreateButton(frame, 51, 24, L['Preset'], 11)
    scroll.preset:SetPoint('RIGHT', scroll.clear, 'LEFT', -5, 0)
    scroll.preset:SetScript('OnClick', function(self)
        EasyMenu(menuList, F.EasyMenu, self, -100, 100, 'MENU', 1)
    end)

    for spellID, duration in pairs(UNITFRAME.PartySpellsList) do
        createBar(scroll.child, spellID, duration)
    end
end



do

    local function UpdateDebuffWatcher()
        UNITFRAME:UpdateDebuffWatcher()
    end

    function GUI:SetupDebuffWatcher(parent)
        local guiName = C.ADDON_NAME .. 'GUISetupDebuffWatcher'
        TogglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = CreateExtraGUI(parent, guiName, L['Instance Debuffs Filter'], true)
        panel:SetScript('OnHide', UpdateDebuffWatcher)

        local setupBars
        local frame = panel.bg
        local bars, options = {}, {}

        local iType = createDropdown(
            frame,
            L['Instance Type'],
            10,
            -30,
            { _G.DUNGEONS, _G.RAID, _G.OTHER },
            L['Select the type of instance.|nThe list of debuffs is saved separately for each instance.'],
            107,
            24
        )
        iType.title = L['Hint']
        for i = 1, 3 do
            iType.options[i]:HookScript('OnClick', function()
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

                if i == 3 then
                    setupBars(0) -- add OTHER spells
                end
            end)
        end

        local function addNewDungeon(dungeons, dungeonID)
            local name = EJ_GetInstanceInfo(dungeonID)
            if name then
                table.insert(dungeons, name)
            end
        end

        local dungeons = {}
        for dungeonID = 1182, 1189 do
            addNewDungeon(dungeons, dungeonID)
        end

        local raids = {
            [1] = EJ_GetInstanceInfo(1190),
            [2] = EJ_GetInstanceInfo(1193),
            [3] = EJ_GetInstanceInfo(1195)
        }

        options[1] = createDropdown(frame, _G.DUNGEONS, 123, -30, dungeons, L['Select a specific dungeon.'], 107, 24)
        options[1].title = L['Hint']
        options[1]:Hide()
        options[2] = createDropdown(frame, _G.RAID, 123, -30, raids, L['Select a specific raid.'], 107, 24)
        options[2].title = L['Hint']
        options[2]:Hide()
        options[3] = createEditBox(
            frame,
            L['SpellID'],
            10,
            -90,
            L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
            107,
            24
        )
        options[4] = createEditBox(
            frame,
            L['Priority'],
            123,
            -90,
            L["Spell's priority when visible.|nWhen multiple spells exist, it only remain the one that owns highest priority.|nDefault priority is 2, if you leave it blank.|nThe maximun priority is 6, and the icon would flash if you set so."],
            107,
            24
        )

        local function analyzePrio(priority)
            priority = priority or 2
            priority = math.min(priority, 6)
            priority = math.max(priority, 1)
            return priority
        end

        local function isDebuffExisted(instName, spellID)
            print(instName)
            print(spellID)
            print(C.DebuffWatcherList[instName][spellID])
            local localPrio = C.DebuffWatcherList[instName][spellID]
            local savedPrio = _G.FREE_ADB['DebuffWatcherList'][instName]
                and _G.FREE_ADB['DebuffWatcherList'][instName][spellID]
            if (localPrio and savedPrio and savedPrio == 0) or (not localPrio and not savedPrio) then
                return false
            end
            return true
        end

        local function addOnClick(options)
            local dungeonName = options[1].Text:GetText()
            local raidName = options[2].Text:GetText()
            local spellID = tonumber(options[3]:GetText())
            local priority = tonumber(options[4]:GetText())
            local instName = dungeonName or raidName or (iType.Text:GetText() == _G.OTHER and 0)

            if not instName or not spellID then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['You need to complete all optinos'])
                return
            end
            if spellID and not GetSpellInfo(spellID) then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
                return
            end
            if isDebuffExisted(instName, spellID) then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
                return
            end

            priority = analyzePrio(priority)
            if not _G.FREE_ADB['DebuffWatcherList'][instName] then
                _G.FREE_ADB['DebuffWatcherList'][instName] = {}
            end
            _G.FREE_ADB['DebuffWatcherList'][instName][spellID] = priority
            setupBars(instName)
            GUI:ClearEdit(options[3])
            GUI:ClearEdit(options[4])
        end




        local scroll = GUI:CreateScroll(frame, 200, 380)
        scroll:ClearAllPoints()
        scroll:SetPoint('TOPLEFT', 10, -150)
        scroll.reset = F.CreateButton(frame, 70, 24, _G.RESET)
        scroll.reset:SetPoint('TOPLEFT', 10, -120)
        scroll.reset.text:SetTextColor(1, 0, 0)
        scroll.reset:SetScript('OnClick', function()
            StaticPopup_Show('FREEUI_RESET_RAID_DEBUFFS')
        end)
        scroll.add = F.CreateButton(frame, 70, 24, _G.ADD)
        scroll.add:SetPoint('TOPRIGHT', -10, -120)
        scroll.add:SetScript('OnClick', function()
            addOnClick(options)
        end)
        scroll.clear = F.CreateButton(frame, 70, 24, _G.KEY_NUMLOCK_MAC)
        scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
        scroll.clear:SetScript('OnClick', function()
            ClearEdit(options)
        end)

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
            F.CreateBD(bar, 0.25)
            bar.index = index

            local icon, close = GUI:CreateBarWidgets(bar, texture)
            icon:SetScript('OnEnter', iconOnEnter)
            icon:SetScript('OnLeave', F.HideTooltip)
            bar.icon = icon

            close:SetScript('OnClick', function()
                bar:Hide()
                if C.DebuffWatcherList[bar.instName][bar.spellID] then
                    if not _G.FREE_ADB['DebuffWatcherList'][bar.instName] then
                        _G.FREE_ADB['DebuffWatcherList'][bar.instName] = {}
                    end
                    _G.FREE_ADB['DebuffWatcherList'][bar.instName][bar.spellID] = 0
                else
                    _G.FREE_ADB['DebuffWatcherList'][bar.instName][bar.spellID] = nil
                end
                setupBars(bar.instName)
            end)

            local spellName = F.CreateFS(bar, C.Assets.Font.Regular, 11, nil, '', nil, true, 'LEFT', 26, 0)
            spellName:SetWidth(120)
            spellName:SetJustifyH('LEFT')
            bar.spellName = spellName

            local prioBox = F.CreateEditBox(bar, 24, 24)
            prioBox:SetPoint('RIGHT', close, 'LEFT', -1, 0)
            prioBox:SetTextInsets(10, 0, 0, 0)
            prioBox:SetMaxLetters(1)
            prioBox:SetTextColor(0, 1, 0)
            prioBox.bg:SetBackdropColor(1, 1, 1, 0.3)
            prioBox:HookScript('OnEscapePressed', function(self)
                self:SetText(bar.priority)
            end)
            prioBox:HookScript('OnEnterPressed', function(self)
                local prio = analyzePrio(tonumber(self:GetText()))
                if not _G.FREE_ADB['DebuffWatcherList'][bar.instName] then
                    _G.FREE_ADB['DebuffWatcherList'][bar.instName] = {}
                end
                _G.FREE_ADB['DebuffWatcherList'][bar.instName][bar.spellID] = prio
                self:SetText(prio)
            end)
            prioBox.title = L['Priority']
            F.AddTooltip(
                prioBox,
                'ANCHOR_RIGHT',
                L['Priority limit in 1-6.|nPress ENTER key when you finish typing.'],
                'BLUE',
                true
            )
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
            local instName = tonumber(self) or self.text or self
            local index = 0

            if C.DebuffWatcherList[instName] then
                for spellID, priority in pairs(C.DebuffWatcherList[instName]) do
                    if
                        not (
                            _G.FREE_ADB['DebuffWatcherList'][instName]
                            and _G.FREE_ADB['DebuffWatcherList'][instName][spellID]
                        )
                    then
                        index = index + 1
                        applyData(index, instName, spellID, priority)
                    end
                end
            end

            if _G.FREE_ADB['DebuffWatcherList'][instName] then
                for spellID, priority in pairs(_G.FREE_ADB['DebuffWatcherList'][instName]) do
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
end

local function UpdateGroupTags()
    UNITFRAME:UpdateGroupTags()
end

function GUI:SetupNameLength(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupNameLength'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scrollArea = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'PartyNameLength', value = db.PartyNameLength, text = L['Party Name Length'], min = 0, max = 10 },
        [2] = { key = 'RaidNameLength', value = db.RaidNameLength, text = L['Raid Name Length'], min = 0, max = 10 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scrollArea, L['Name Length'], offset)
        CreateSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateGroupTags)
        offset = offset - 65
    end
end

local function UpdateGroupAuras()
    UNITFRAME:UpdateGroupAuras()
end

function GUI:SetupPartyBuff(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupPartyBuffSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scrollArea = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'PartyBuffSize', value = db.PartyBuffSize, text = L['Icon Size'], min = 8, max = 36, step = 1 },
        [2] = { key = 'PartyBuffNum', value = db.PartyBuffNum, text = L['Icon Number'], min = 1, max = 6, step = 1 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scrollArea, L['Party Buff'], offset)
        CreateSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateGroupAuras)
        offset = offset - 65
    end
end

function GUI:SetupPartyDebuff(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupPartyDebuff'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scrollArea = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = {
            key = 'PartyDebuffSize',
            value = db.PartyDebuffSize,
            text = L['Icon Size'],
            min = 8,
            max = 36,
            step = 1,
        },
        [2] = {
            key = 'PartyDebuffNum',
            value = db.PartyDebuffNum,
            text = L['Icon Number'],
            min = 1,
            max = 6,
            step = 1,
        },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scrollArea, L['Party Debuff'], offset)
        CreateSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateGroupAuras)
        offset = offset - 65
    end
end

function GUI:SetupRaidBuff(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupRaidBuff'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scrollArea = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'RaidBuffSize', value = db.RaidBuffSize, text = L['Icon Size'], min = 8, max = 36, step = 1 },
        [2] = { key = 'RaidBuffNum', value = db.RaidBuffNum, text = L['Icon Number'], min = 1, max = 6, step = 1 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scrollArea, L['Raid Buff'], offset)
        CreateSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateGroupAuras)
        offset = offset - 65
    end
end

function GUI:SetupRaidDebuff(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupRaidDebuff'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scrollArea = GUI:CreateScroll(panel, 200, 535)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = {
            key = 'RaidDebuffSize',
            value = db.RaidDebuffSize,
            text = L['Icon Size'],
            min = 8,
            max = 36,
            step = 1,
        },
        [2] = { key = 'RaidDebuffNum', value = db.RaidDebuffNum, text = L['Icon Number'], min = 1, max = 6, step = 1 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scrollArea, L['Raid Debuff'], offset)
        CreateSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateGroupAuras)
        offset = offset - 65
    end
end

local function RefreshPartyAurasFilter()
    UNITFRAME:RefreshPartyAurasFilter()
end

function GUI:SetupPartyAura(parent)
    local guiName = C.ADDON_NAME .. 'GUISetupPartyAura'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, L['Party Actived Auras Filter'], true)
    panel:SetScript('OnHide', RefreshPartyAurasFilter)
    parent.panel = panel

    panel.barTable = {}
    panel.tableName = 'PartyAurasList'

    local scrollArea = GUI:CreateScroll(panel.bg, 200, 485)
    panel.scrollArea = scrollArea

    local editBox = createEditBox(panel.bg, nil, 10, -10, nil, 110, 24)
    panel.editBox = editBox
    editBox.title = L['Hint']
    F.AddTooltip(
        editBox,
        'ANCHOR_RIGHT',
        L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
        'BLUE',
        true
    )

    local addBtn = F.CreateButton(panel.bg, 50, 24, _G.ADD)
    addBtn:SetPoint('TOPRIGHT', -8, -10)
    addBtn:HookScript('OnClick', addOnClick)
    addBtn.__owner = panel

    local resetBtn = F.CreateButton(panel.bg, 50, 24, _G.RESET)
    resetBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
    resetBtn:HookScript('OnClick', function()
        StaticPopup_Show('FREEUI_RESET_PARTY_AURA_LIST')
    end)

    for spellID, value in pairs(UNITFRAME[panel.tableName]) do
        if value then
            createBars(scrollArea, spellID, panel.barTable, panel.tableName)
        end
    end
end




-- General

function GUI:SetupAutoScreenshot(parent)
    local guiName = C.ADDON_NAME .. 'GUIAutoScreenshot'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = { value = 'EarnedNewAchievement', text = L['Earned new achievement'] },
        [2] = { value = 'ChallengeModeCompleted', text = L['Mythic+ completed'] },
        [3] = { value = 'PlayerLevelUp', text = L['Level up'] },
        [4] = { value = 'PlayerDead', text = L['Dead'] },
    }

    local offset = -10
    for _, data in ipairs(datas) do
        CreateGroupTitle(scroll, L['Auto Screenshot'], offset)
        CreateCheckbox(scroll, offset - 30, 'General', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupCustomClassColor(parent)
    local guiName = C.ADDON_NAME .. 'GUICustomClassColor'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local colors = _G.FREE_ADB.CustomClassColors

    local datas = {
        [1] = { text = 'HUNTER', value = colors.HUNTER },
        [2] = { text = 'WARRIOR', value = colors.WARRIOR },
        [3] = { text = 'SHAMAN', value = colors.SHAMAN },
        [4] = { text = 'MAGE', value = colors.MAGE },
        [5] = { text = 'PRIEST', value = colors.PRIEST },
        [6] = { text = 'DEATHKNIGHT', value = colors.DEATHKNIGHT },
        [7] = { text = 'WARLOCK', value = colors.WARLOCK },
        [8] = { text = 'DEMONHUNTER', value = colors.DEMONHUNTER },
        [9] = { text = 'ROGUE', value = colors.ROGUE },
        [10] = { text = 'DRUID', value = colors.DRUID },
        [11] = { text = 'MONK', value = colors.MONK },
        [12] = { text = 'PALADIN', value = colors.PALADIN },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Class Color Customization'], offset)
        CreateColorSwatch(scroll, v.value, v.text, C.AccountSettings.CustomClassColors[v.text], offset - 34)

        offset = offset - 30
    end
end

local function UpdateVignettingVisibility()
    VIGNETTING:UpdateVisibility()
end

function GUI:SetupVignettingVisibility(parent)
    local guiName = C.ADDON_NAME .. 'GUIVignetting'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local values = C.DB.General

    local datas = {
        key = 'VignettingAlpha',
        value = values.VignettingAlpha,
        text = L['Vignetting Alpha'],
        min = 0,
        max = 1,
        step = 0.1,
    }

    local offset = -30
    CreateSlider(
        scroll,
        'General',
        datas.key,
        datas.text,
        datas.min,
        datas.max,
        datas.step,
        datas.value,
        20,
        offset,
        UpdateVignettingVisibility
    )
end

-- Chat
local function UpdateChatSize()
    CHAT:UpdateChatSize()
end

function GUI:SetupChatSize(parent)
    local guiName = C.ADDON_NAME .. 'GUIChatSize'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = { key = 'Width', value = '300', text = L['Width'], min = 50, max = 500 },
        [2] = { key = 'Height', value = '100', text = L['Height'], min = 50, max = 500 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Chat Window Size'], offset)
        CreateSlider(scroll, 'Chat', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateChatSize)
        offset = offset - 65
    end
end

local function UpdateTextFading()
    CHAT:UpdateTextFading()
end

function GUI:SetupChatTextFading(parent)
    local guiName = C.ADDON_NAME .. 'GUIChatTextFading'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local mKey = 'Chat'
    local db = C.CharacterSettings.Chat

    local datas = {
        [1] = { key = 'TimeVisible', value = db.TimeVisible, text = L['Time Visible'], min = 10, max = 300 },
        [2] = { key = 'FadeDuration', value = db.FadeDuration, text = L['Fade Duration'], min = 1, max = 6 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Chat Text Fading'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateTextFading)
        offset = offset - 65
    end
end

-- Combat
function GUI:SetupSimpleFloatingCombatText(parent)
    local guiName = C.ADDON_NAME .. 'GUIFCT'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = { value = 'Incoming', text = L['Incoming'] },
        [2] = { value = 'Outgoing', text = L['Outgoing'] },
        [3] = { value = 'Pet', text = L['Pet'] },
        [4] = { value = 'Periodic', text = L['Periodic'] },
        [5] = { value = 'Merge', text = L['Merge'] },
    }

    local offset = -10
    for _, data in ipairs(datas) do
        CreateGroupTitle(scroll, L['Floating Combat Text'], offset)
        CreateCheckbox(scroll, offset - 30, 'Combat', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupSoundAlert(parent)
    local guiName = C.ADDON_NAME .. 'GUISoundAlert'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)

    local datas = {
        [1] = { value = 'Interrupt', text = L['Interrupt'] },
        [2] = { value = 'Dispel', text = L['Dispel'] },
        [3] = { value = 'SpellSteal', text = L['Spell Steal'] },
        [4] = { value = 'SpellMiss', text = L['Spell Miss'] },
        [5] = { value = 'LowHealth', text = L['Low Health'] },
        [6] = { value = 'LowMana', text = L['Low Mana'] },
    }

    local offset = -10
    for _, data in ipairs(datas) do
        CreateGroupTitle(scroll, L['Sound Alert'], offset)
        CreateCheckbox(scroll, offset - 30, 'Combat', data.value, data.text)
        offset = offset - 35
    end
end

-- Announcement
local function RefreshAnnounceableSpells()
    ANNOUNCEMENT:RefreshSpells()
end

function GUI:SetupAnnounceableSpells(parent)
    local guiName = C.ADDON_NAME .. 'GUIAnnounceableSpells'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName, nil, true)
    panel:SetScript('OnHide', RefreshAnnounceableSpells)
    parent.panel = panel

    local barTable = {}

    local frame = panel.bg
    local scroll = GUI:CreateScroll(frame, 200, 480)
    scroll.box = createEditBox(frame, nil, 10, -10, nil, 110, 24)
    scroll.box.title = L['SpellID']
    F.AddTooltip(
        scroll.box,
        'ANCHOR_RIGHT',
        L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
        'BLUE',
        true
    )

    scroll.add = F.CreateButton(frame, 50, 24, _G.ADD)
    scroll.add:SetPoint('LEFT', scroll.box, 'RIGHT', 5, 0)
    scroll.add.__owner = scroll
    scroll.add:SetScript('OnClick', function(button)
        local parent = button.__owner
        local spellID = tonumber(parent.box:GetText())

        if not spellID or not GetSpellInfo(spellID) then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
            return
        end

        local modValue = _G.FREE_ADB['AnnounceableSpellsList'][spellID]
        if modValue or modValue == nil and C.AnnounceableSpellsList[spellID] then
            _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
            return
        end

        _G.FREE_ADB['AnnounceableSpellsList'][spellID] = true
        CreateBars(scroll, spellID, barTable, 'AnnounceableSpellsList', 'AnnounceableSpellsList')
        parent.box:SetText('')
    end)

    scroll.reset = F.CreateButton(frame, 50, 24, _G.RESET)
    scroll.reset:SetPoint('LEFT', scroll.add, 'RIGHT', 5, 0)
    scroll.reset:SetScript('OnClick', function()
        StaticPopup_Show('FREEUI_RESET_ANNOUNCEABLE_SPELLS')
    end)

    for spellID, value in pairs(ANNOUNCEMENT.AnnounceableSpellsList) do
        if value then
            CreateBars(scroll, spellID, barTable, 'AnnounceableSpellsList', 'AnnounceableSpellsList')
        end
    end
end

-- Map
local function UpdateMapScale()
    MAP:UpdateMinimapScale()
end

function GUI:SetupMapScale(parent)
    local guiName = C.ADDON_NAME .. 'GUIMapScale'
    TogglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = CreateExtraGUI(parent, guiName)
    local scroll = GUI:CreateScroll(panel, 220, 540)
    local mKey = 'Map'
    local db = C.CharacterSettings.Map

    local datas = {
        [1] = { key = 'WorldMapScale', value = db.WorldMapScale, text = L['World Map Scale'], min = 0.5, max = 2 },
        [2] = {
            key = 'MaxWorldMapScale',
            value = db.MaxWorldMapScale,
            text = L['Max World Map Scale'],
            min = 0.5,
            max = 1,
        },
        [3] = { key = 'MinimapScale', value = db.MinimapScale, text = L['Minimap Scale'], min = 0.5, max = 2 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        CreateGroupTitle(scroll, L['Map Scale'], offset)
        CreateSlider(scroll, mKey, v.key, v.text, v.min, v.max, 0.1, v.value, 20, offset - 50, UpdateMapScale)
        offset = offset - 65
    end
end
