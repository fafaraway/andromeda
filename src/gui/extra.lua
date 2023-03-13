local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local ACTIONBAR = F:GetModule('ActionBar')
local ANNOUNCEMENT = F:GetModule('Announcement')
local MAP = F:GetModule('Map')
local INVENTORY = F:GetModule('Inventory')
local VIGNETTING = F:GetModule('Vignetting')
local AURA = F:GetModule('Aura')
local oUF = F.Libs.oUF

local extraGUIs = {}

-- utility

local function togglePanel(guiName)
    for name, frame in pairs(extraGUIs) do
        if name == guiName then
            F:TogglePanel(frame)
        else
            frame:Hide()
        end
    end
end

local function hidePanels()
    for _, frame in pairs(extraGUIs) do
        frame:Hide()
    end
end

local function resetOption(element)
    if element.Type == 'editbox' then
        element:ClearFocus()
        element:SetText('')
    elseif element.Type == 'checkbox' then
        element:SetChecked(false)
    elseif element.Type == 'dropdown' then
        element.Text:SetText('')
        for i = 1, #element.options do
            element.options[i].selected = false
        end
    end
end

local function clearOption(options)
    for i = 1, #options do
        resetOption(options[i])
    end
end

local function createPanel(parent, name, title, bgFrame)
    local frame = CreateFrame('Frame', name, parent)
    frame:SetSize(GUI.exWidth, GUI.height)
    frame:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)
    F.SetBD(frame)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    if title then
        F.CreateFS(frame, C.Assets.Fonts.Bold, 13, outline or nil, title, 'YELLOW', outline and 'NONE' or 'THICK', 'TOPLEFT', 10, -30)
    end

    if bgFrame then
        frame.bg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
        frame.bg:SetPoint('TOPLEFT', 10, -50)
        frame.bg:SetPoint('bottomright', -10, 50)
        frame.bg.bg = F.CreateBDFrame(frame.bg, 0.25)
    end

    if not parent.extraGUIHook then
        parent:HookScript('OnHide', hidePanels)
        parent.extraGUIHook = true
    end
    extraGUIs[name] = frame

    return frame
end

local function createScrollFrame(parent, width, height, text, noBg)
    local scroll = CreateFrame('ScrollFrame', nil, parent, 'UIPanelScrollFrameTemplate')
    scroll:SetSize(width, height)
    if parent.bg then
        scroll:SetPoint('TOPLEFT', 10, -45)
    else
        scroll:SetPoint('TOPLEFT', 10, -50)
    end

    local outline = _G.ANDROMEDA_ADB.FontOutline
    if text then
        F.CreateFS(scroll, C.Assets.Fonts.Bold, 13, outline or nil, text, nil, outline and 'NONE' or 'THICK', 'TOPLEFT', 5, 32)
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

local function sortSpellBar(barTable)
    local num = 1
    for _, bar in pairs(barTable) do
        bar:SetPoint('TOPLEFT', 0, -30 * (num - 1))
        num = num + 1
    end
end

local function createSpellBarWidget(parent, texture)
    local icon = CreateFrame('Frame', nil, parent)
    icon:SetSize(16, 16)
    icon:SetPoint('LEFT', 5, 0)
    F.PixelIcon(icon, texture, true)

    local close = CreateFrame('Button', nil, parent)
    close:SetSize(16, 16)
    close:SetPoint('RIGHT', -5, 0)
    close.Icon = close:CreateTexture(nil, 'ARTWORK')
    close.Icon:SetAllPoints()
    close.Icon:SetTexture(C.Assets.Textures.Close)
    close.Icon:SetVertexColor(1, 0, 0)
    close:SetHighlightTexture(close.Icon:GetTexture())

    return icon, close
end

local function createSpellBar(parent, spellID, barTable, tableName, isNew)
    local spellName = GetSpellInfo(spellID)
    local texture = GetSpellTexture(spellID)

    local bar = CreateFrame('Frame', nil, parent.child, 'BackdropTemplate')
    bar:SetSize(200, 28)
    bar.bg = F.CreateBDFrame(bar, 0.25)
    barTable[spellID] = bar

    local icon, delBtn = createSpellBarWidget(bar, texture)
    F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
    delBtn:SetScript('OnClick', function()
        bar:Hide()

        if C[tableName][spellID] then
            _G.ANDROMEDA_ADB[tableName][spellID] = false
        else
            _G.ANDROMEDA_ADB[tableName][spellID] = nil
        end

        barTable[spellID] = nil
        sortSpellBar(barTable)
    end)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    local font = C.Assets.Fonts.Condensed
    local name = F.CreateFS(bar, font, 12, outline or nil, spellName, nil, outline and 'NONE' or 'THICK', 'LEFT', 26, 0)
    name:SetWidth(160)
    name:SetJustifyH('LEFT')

    if isNew then
        name:SetTextColor(0, 1, 0)
    end

    sortSpellBar(barTable)
end

local function isSpellIdExisted(table, spellID)
    local modValue = _G.ANDROMEDA_ADB[table][spellID]
    local locValue = C[table][spellID]

    return modValue or (modValue == nil and locValue)
end

local function addButton_OnClick(self)
    local parent = self.__owner
    local newTable = parent.barTable
    local tableName = parent.tableName
    local spellID = tonumber(parent.editBox:GetText())

    if not spellID or not GetSpellInfo(spellID) then
        _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
        return
    end

    if isSpellIdExisted(tableName, spellID) then
        _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
        return
    end

    _G.ANDROMEDA_ADB[tableName][spellID] = true

    createSpellBar(parent.scrollArea, spellID, newTable, tableName, true)

    parent.editBox:SetText('')
end

local function label_OnEnter(self)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_RIGHT', 0, 3)
    _G.GameTooltip:AddLine(self.text)
    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddLine(self.tip, 0.6, 0.8, 1, 1)
    _G.GameTooltip:Show()
end

local function createLabel(parent, text, tip)
    local outline = _G.ANDROMEDA_ADB.FontOutline
    local font = C.Assets.Fonts.Regular
    local label = F.CreateFS(parent, font, 11, outline or nil, text, nil, outline and 'NONE' or 'THICK')
    label:SetPoint('BOTTOM', parent, 'TOP', 0, 4)
    if not tip then
        return
    end
    local frame = CreateFrame('Frame', nil, parent)
    frame:SetAllPoints(label)
    frame.text = text
    frame.tip = tip
    frame:SetScript('OnEnter', label_OnEnter)
    frame:SetScript('OnLeave', F.HideTooltip)
end

local function createEditbox(parent, text, x, y, tip, width, height)
    local eb = F.CreateEditbox(parent, width or 90, height or 24)
    eb:SetPoint('TOPLEFT', x, y)
    eb:SetMaxLetters(255)
    createLabel(eb, text)

    if tip then
        eb.tipHeader = L['Hint']
        F.AddTooltip(eb, 'ANCHOR_RIGHT', tip, 'BLUE')
    end

    return eb
end

local function createGroupTitle(parent, text, offset)
    if parent.groupTitle then
        return
    end

    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.CreateFS(parent.child, C.Assets.Fonts.Regular, 13, outline or nil, text, 'YELLOW', outline and 'NONE' or 'THICK', 'TOP', 0, offset)
    local line = F.SetGradient(parent.child, 'H', 0.5, 0.5, 0.5, 0.25, 0.25, 200, C.MULT)
    line:SetPoint('TOPLEFT', 10, offset - 20)

    parent.groupTitle = true
end

local function checkbox_OnClick(self)
    local key = self.__key
    local value = self.__value
    C.DB[key][value] = not C.DB[key][value]
    self:SetChecked(C.DB[key][value])
    if self.__func then
        self.__func()
    end
end

local function createCheckbox(parent, offset, key, value, text, func, tip)
    local box = F.CreateCheckbox(parent.child, true)
    box:SetSize(18, 18)
    box:SetHitRectInsets(-5, -5, -5, -5)
    box:SetPoint('TOPLEFT', 10, offset)

    local outline = _G.ANDROMEDA_ADB.FontOutline
    box.label = F.CreateFS(box, C.Assets.Fonts.Regular, 12, outline or nil, text, nil, outline and 'NONE' or 'THICK')
    box.label:SetPoint('LEFT', box, 'RIGHT', 4, 0)

    box:SetChecked(C.DB[key][value])
    box.__value = value
    box.__key = key
    box:SetScript('OnClick', checkbox_OnClick)
    box.__func = func

    if tip then
        box.tipHeader = text
        F.AddTooltip(box, 'ANCHOR_TOPLEFT', tip, 'BLUE')
    end

    return box
end

local function createColorSwatch(parent, text, value, defaultV, offset, x, y)
    local swatch = F.CreateColorSwatch(parent, text, value)
    swatch:SetSize(22, 14)
    swatch.__default = defaultV

    if x and y then
        swatch:SetPoint('TOPLEFT', x, y)
    else
        swatch:SetPoint('TOPLEFT', 14, offset)
    end

    return swatch
end

local function slider_OnValueChanged(self, v)
    local current = F:Round(tonumber(v), 2)
    self.value:SetText(current)
    C.DB[self.__key][self.__value] = current

    if self.__update then
        self.__update()
    end
end

local function createSlider(parent, key, value, text, minV, maxV, step, defaultV, x, y, func, tip)
    local slider = F.CreateSlider(parent.child, text, minV, maxV, step, x, y, 180)
    slider:SetValue(C.DB[key][value])
    slider.value:SetText(C.DB[key][value])
    slider.__key = key
    slider.__value = value
    slider.__update = func
    slider.__default = defaultV
    slider.__step = step
    slider:SetScript('OnValueChanged', slider_OnValueChanged)

    if tip then
        slider.tipHeader = tostring(key)
        F.AddTooltip(slider, 'ANCHOR_TOPLEFT', tip, 'BLUE')
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
    local dd = F.CreateDropdown(parent, width or 90, height or 30, data)
    dd:SetPoint('TOPLEFT', x, y)
    createLabel(dd, text)

    if tip then
        dd.tipHeader = L['Hint']
        F.AddTooltip(dd, 'ANCHOR_RIGHT', tip, 'BLUE')
    end

    return dd
end

local function createOptionDropdown(parent, title, yOffset, options, tooltip, key, value, default, func)
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
    local guiName = C.ADDON_TITLE .. 'GUIAuraSize'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Layout'], offset)
        createCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateAuraSize)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.buff) do
        createGroupTitle(scroll, L['Buff'], offset - 30)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 80, UpdateAuraSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.debuff) do
        createGroupTitle(scroll, L['Debuff'], offset - 80)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 130, UpdateAuraSize)
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
    local guiName = C.ADDON_TITLE .. 'GUIInventoryFilter'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Item Filter'], offset)
        createCheckbox(scroll, offset - 30, 'Inventory', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupInventorySize(parent)
    local guiName = C.ADDON_TITLE .. 'GUIInventorySize'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Size and Spacing'], offset)
        createSlider(scroll, 'Inventory', v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateBagSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(colDatas) do
        createGroupTitle(scroll, L['Columns'], offset - 50)
        createSlider(scroll, 'Inventory', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100, UpdateBagSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(rowDatas) do
        createGroupTitle(scroll, L['Rows'], offset - 100)
        createSlider(scroll, 'Inventory', v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 150, UpdateInventoryAnchor)
        offset = offset - 65
    end
end

function GUI:SetupMinItemLevelToShow(parent)
    local guiName = C.ADDON_TITLE .. 'GUIMinItemLevelToShow'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
    createGroupTitle(scroll, L['Item Level'], offset)
    createSlider(scroll, 'Inventory', datas.key, datas.text, datas.min, datas.max, datas.step, datas.value, 20, offset - 50, UpdateInventoryStatus)
end

-- Actionbar
local barsList = { 'Bar1', 'Bar2', 'Bar3', 'Bar4', 'Bar5', 'Bar6', 'Bar7', 'Bar8', 'BarPet' }
local function UpdateActionBarSize()
    for _, v in ipairs(barsList) do
        ACTIONBAR:UpdateSize(v)
    end
end

function GUI:SetupActionBarSize(parent)
    local guiName = C.ADDON_TITLE .. 'GUIActionBarSize'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
    local db = C.CharacterSettings.Actionbar
    local mKey = 'Actionbar'

    local datas = {
        bar1 = {
            [1] = { key = 'Bar1ButtonSize', value = db.Bar1ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar1ButtonNum', value = db.Bar1ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar1ButtonPerRow', value = db.Bar1ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar1FontSize', value = db.Bar1FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar2 = {
            [1] = { key = 'Bar2ButtonSize', value = db.Bar2ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar2ButtonNum', value = db.Bar2ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar2ButtonPerRow', value = db.Bar2ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar2FontSize', value = db.Bar2FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar3 = {
            [1] = { key = 'Bar3ButtonSize', value = db.Bar3ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar3ButtonNum', value = db.Bar3ButtonNum, text = L['Number'], min = 0, max = 12, step = 1 },
            [3] = { key = 'Bar3ButtonPerRow', value = db.Bar3ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar3FontSize', value = db.Bar3FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar4 = {
            [1] = { key = 'Bar4ButtonSize', value = db.Bar4ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar4ButtonNum', value = db.Bar4ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar4ButtonPerRow', value = db.Bar4ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar4FontSize', value = db.Bar4FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar5 = {
            [1] = { key = 'Bar5ButtonSize', value = db.Bar5ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar5ButtonNum', value = db.Bar5ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar5ButtonPerRow', value = db.Bar5ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar5FontSize', value = db.Bar5FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },

        bar6 = {
            [1] = { key = 'Bar6ButtonSize', value = db.Bar6ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar6ButtonNum', value = db.Bar6ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar6ButtonPerRow', value = db.Bar6ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar6FontSize', value = db.Bar6FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar7 = {
            [1] = { key = 'Bar7ButtonSize', value = db.Bar7ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar7ButtonNum', value = db.Bar7ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar7ButtonPerRow', value = db.Bar7ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar7FontSize', value = db.Bar7FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },
        bar8 = {
            [1] = { key = 'Bar8ButtonSize', value = db.Bar8ButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'Bar8ButtonNum', value = db.Bar8ButtonNum, text = L['Number'], min = 1, max = 12, step = 1 },
            [3] = { key = 'Bar8ButtonPerRow', value = db.Bar8ButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [4] = { key = 'Bar8FontSize', value = db.Bar8FontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },

        barPet = {
            [1] = { key = 'BarPetButtonSize', value = db.BarPetButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'BarPetButtonPerRow', value = db.BarPetButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [3] = { key = 'BarPetFontSize', value = db.BarPetFontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },

        barStance = {
            [1] = { key = 'BarStanceButtonSize', value = db.BarStanceButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
            [2] = { key = 'BarStanceButtonPerRow', value = db.BarStanceButtonPerRow, text = L['Per Row'], min = 1, max = 12, step = 1 },
            [3] = { key = 'BarStanceFontSize', value = db.BarStanceFontSize, text = L['Font Size'], min = 8, max = 16, step = 1 },
        },

        barExtra = {
            [1] = { key = 'BarExtraButtonSize', value = db.BarExtraButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
        },

        barVehicle = {
            [1] = { key = 'BarVehicleButtonSize', value = db.BarVehicleButtonSize, text = L['Size'], min = 20, max = 60, step = 1 },
        },
    }

    local offset = -10
    for _, v in ipairs(datas.bar1) do
        createGroupTitle(scroll, L['Bar 1'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar2) do
        createGroupTitle(scroll, L['Bar 2'], offset - 50)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 100, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar3) do
        createGroupTitle(scroll, L['Bar 3'], offset - 100)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 150, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar4) do
        createGroupTitle(scroll, L['Bar 4'], offset - 150)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 200, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar5) do
        createGroupTitle(scroll, L['Bar 5'], offset - 200)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 250, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar6) do
        createGroupTitle(scroll, L['Bar 6'], offset - 250)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 300, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar7) do
        createGroupTitle(scroll, L['Bar 7'], offset - 300)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 350, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.bar8) do
        createGroupTitle(scroll, L['Bar 8'], offset - 350)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 400, UpdateActionBarSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.barPet) do
        createGroupTitle(scroll, L['Pet Bar'], offset - 400)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 450, ACTIONBAR.UpdatePetBar)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.barStance) do
        createGroupTitle(scroll, L['Stance Bar'], offset - 450)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 500, ACTIONBAR.UpdateStanceBar)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.barExtra) do
        createGroupTitle(scroll, L['Extra Button'], offset - 500)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 550, ACTIONBAR.UpdateStanceBar)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.barVehicle) do
        createGroupTitle(scroll, L['Vehicle Button'], offset - 550)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 600, ACTIONBAR.UpdateStanceBar)
        offset = offset - 65
    end
end

local function UpdateActionBarFader()
    if not ACTIONBAR.fadeParent then
        return
    end

    ACTIONBAR:UpdateFaderState()
    ACTIONBAR.fadeParent:SetAlpha(C.DB.Actionbar.FadeOutAlpha)
end

function GUI:SetupActionbarFader(parent)
    local guiName = C.ADDON_TITLE .. 'GUIActionbarFader'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
    local db = C.CharacterSettings.Actionbar
    local mKey = 'Actionbar'

    local datas = {
        bars = {
            [1] = { value = 'FadeBar1', text = L['Enable Fade on Bar 1'] },
            [2] = { value = 'FadeBar2', text = L['Enable Fade on Bar 2'] },
            [3] = { value = 'FadeBar3', text = L['Enable Fade on Bar 3'] },
            [4] = { value = 'FadeBar4', text = L['Enable Fade on Bar 4'] },
            [5] = { value = 'FadeBar5', text = L['Enable Fade on Bar 5'] },
            [6] = { value = 'FadeBar6', text = L['Enable Fade on Bar 6'] },
            [7] = { value = 'FadeBar7', text = L['Enable Fade on Bar 7'] },
            [8] = { value = 'FadeBar8', text = L['Enable Fade on Bar 8'] },
            [9] = { value = 'FadeBarPet', text = L['Enable Fade on PetBar'] },
            [10] = { value = 'FadeBarStance', text = L['Enable Fade on StanceBar'] },
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
        createGroupTitle(scroll, L['Bars'], offset)
        createCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateActionBarFader)
        offset = offset - 35
    end

    offset = offset - 35
    scroll.groupTitle = nil

    for _, v in ipairs(datas.conditions) do
        createGroupTitle(scroll, L['Conditions'], offset)
        createCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateActionBarFader)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.sliders) do
        createGroupTitle(scroll, L['Fading Parameters'], offset - 30)
        createSlider(scroll, mKey, v.key, v.text, 0, 1, 0.1, v.value, 20, offset - 80, UpdateActionBarFader)
        offset = offset - 65
    end
end

function GUI:SetupCooldownCount(parent)
    local guiName = C.ADDON_TITLE .. 'GUICooldownCount'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Cooldown'], offset)
        createCheckbox(scroll, offset - 30, mKey, v.value, v.text, nil, v.tip)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.slider) do
        createGroupTitle(scroll, L['Threhold'], offset - 30)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 80, nil, v.tip)
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
    local guiName = C.ADDON_TITLE .. 'GUINamePlateAuraFilter'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    panel:SetScript('OnHide', RefreshNameplateAuraFilters)

    local frameData = {
        [1] = {
            text = L['Auras White List'],
            tip = L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
            offset = -25,
            barList = {},
        },
        [2] = {
            text = L['Auras Black List'],
            tip = L['Fill in SpellID, must be a number.|nSpell name is not supported.'],
            offset = -315,
            barList = {},
        },
    }

    local function createBar(parent, index, spellID)
        local name, _, texture = GetSpellInfo(spellID)
        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 28)
        bar.bg = F.CreateBD(bar, 0.25)
        frameData[index].barList[spellID] = bar

        local icon, close = createSpellBarWidget(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript('OnClick', function()
            bar:Hide()

            if index == 1 then
                if C.NameplateAuraWhiteList[spellID] then
                    _G.ANDROMEDA_ADB['NameplateAuraWhiteList'][spellID] = false
                else
                    _G.ANDROMEDA_ADB['NameplateAuraWhiteList'][spellID] = nil
                end
            elseif index == 2 then
                if C.NameplateAuraBlackList[spellID] then
                    _G.ANDROMEDA_ADB['NameplateAuraBlackList'][spellID] = false
                else
                    _G.ANDROMEDA_ADB['NameplateAuraBlackList'][spellID] = nil
                end
            end

            frameData[index].barList[spellID] = nil
            sortSpellBar(frameData[index].barList)
        end)

        local outline = _G.ANDROMEDA_ADB.FontOutline
        local spellName = F.CreateFS(bar, C.Assets.Fonts.Condensed, 12, outline or nil, name, nil, outline and 'NONE' or 'THICK', 'LEFT', 26, 0)
        spellName:SetWidth(180)
        spellName:SetJustifyH('LEFT')
        if index == 2 then
            spellName:SetTextColor(1, 0, 0)
        end

        sortSpellBar(frameData[index].barList)
    end

    local function isAuraExisted(index, spellID)
        local key = index == 1 and 'NameplateAuraWhiteList' or 'NameplateAuraBlackList'
        local modValue = _G.ANDROMEDA_ADB[key][spellID]
        local locValue = (index == 1 and C.NameplateAuraWhiteList[spellID]) or (index == 2 and C.NameplateAuraBlackList[spellID])

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

        local key = index == 1 and 'NameplateAuraWhiteList' or 'NameplateAuraBlackList'
        _G.ANDROMEDA_ADB[key][spellID] = true

        createBar(parent.child, index, spellID)
        parent.box:SetText('')
    end

    local filterIndex
    StaticPopupDialogs['ANDROMEDA_RESET_NAMEPLATE_AURAS'] = {
        text = C.RED_COLOR .. L['Reset to default list?'],
        button1 = _G.YES,
        button2 = _G.NO,
        OnAccept = function()
            local key = filterIndex == 1 and 'NameplateAuraWhiteList' or 'NameplateAuraBlackList'
            wipe(_G.ANDROMEDA_ADB[key])
        end,
        whileDead = 1,
    }

    local outline = _G.ANDROMEDA_ADB.FontOutline
    for index, value in ipairs(frameData) do
        F.CreateFS(panel, C.Assets.Fonts.Bold, 13, outline or nil, value.text, 'YELLOW', outline and 'NONE' or 'THICK', 'TOPLEFT', 10, value.offset - 5)
        local frame = CreateFrame('Frame', nil, panel, 'BackdropTemplate')
        frame:SetSize(240, 250)
        frame:SetPoint('TOPLEFT', 10, value.offset - 25)
        frame.bg = F.CreateBDFrame(frame, 0.25)

        local scroll = createScrollFrame(frame, 200, 200, nil, true)
        scroll:ClearAllPoints()
        scroll:SetPoint('BOTTOMLEFT', 10, 10)

        scroll.box = F.CreateEditbox(frame, 130, 24)
        scroll.box:SetPoint('TOPLEFT', 10, -10)
        scroll.box.tipHeader = L['Hint']
        F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', value.tip, 'BLUE')

        scroll.add = F.CreateButton(frame, 35, 24, _G.ADD, 11)
        scroll.add:SetPoint('TOPRIGHT', -10, -10)
        scroll.add:SetScript('OnClick', function()
            addClick(scroll, index)
        end)

        scroll.reset = F.CreateButton(frame, 35, 24, _G.RESET, 11)
        scroll.reset:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
        scroll.reset:SetScript('OnClick', function()
            filterIndex = index
            StaticPopup_Show('ANDROMEDA_RESET_NAMEPLATE_AURAS')
        end)

        local key = index == 1 and 'NameplateAuraWhiteList' or 'NameplateAuraBlackList'
        for spellID, value in pairs(NAMEPLATE[key]) do
            if value then
                createBar(scroll.child, index, spellID)
            end
        end
    end
end

do
    local function refreshMajorSpells()
        NAMEPLATE:RefreshMajorSpellsFilter()
    end

    function GUI:SetupNameplateMajorSpells(parent)
        local guiName = C.ADDON_TITLE .. 'GUINamePlateMajorSpells'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Major Spells List'], true)
        panel:SetScript('OnHide', refreshMajorSpells)
        parent.panel = panel

        panel.barTable = {}
        panel.tableName = 'MajorSpellsList'

        local scrollArea = createScrollFrame(panel.bg, 200, 485)
        panel.scrollArea = scrollArea

        local editBox = createEditbox(panel.bg, nil, 10, -10, nil, 130, 24)
        panel.editBox = editBox
        editBox.tipHeader = L['Hint']
        F.AddTooltip(editBox, 'ANCHOR_RIGHT', L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 'BLUE')

        local addBtn = F.CreateButton(panel.bg, 35, 24, _G.ADD, 11)
        addBtn:SetPoint('TOPRIGHT', -10, -10)
        addBtn:HookScript('OnClick', addButton_OnClick)
        addBtn.__owner = panel

        local resetBtn = F.CreateButton(panel.bg, 35, 24, _G.RESET, 11)
        resetBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
        resetBtn:HookScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_MAJOR_SPELLS_LIST')
        end)

        for spellID, value in pairs(NAMEPLATE[panel.tableName]) do
            if value then
                createSpellBar(scrollArea, spellID, panel.barTable, panel.tableName)
            end
        end
    end
end

local function UpdateNameplateCVars()
    NAMEPLATE:UpdateNameplateCVars()
end

function GUI:SetupNameplateCVars(parent)
    local guiName = C.ADDON_TITLE .. 'GUINamePlateCvars'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Nameplate CVars'], offset)
        createSlider(scroll, 'Nameplate', v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateNameplateCVars)
        offset = offset - 65
    end
end

local function UpdateClickableSize()
    NAMEPLATE:UpdateClickableSize()
end

function GUI:SetupNameplateSize(parent)
    local guiName = C.ADDON_TITLE .. 'GUINamePlateSize'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Nameplate Size'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, RefreshAllPlates)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.clickableSize) do
        createGroupTitle(scroll, L['Clickable Size'], offset - 50)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100, UpdateClickableSize)
        offset = offset - 65
    end
end

function GUI:SetupNameplateFriendlySize(parent)
    local guiName = C.ADDON_TITLE .. 'GUINamePlateFriendlySize'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Friendly Nameplate Size'], offset)
        createSlider(scroll, 'Nameplate', v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, RefreshAllPlates)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.clickableSize) do
        createGroupTitle(scroll, L['Clickable Size'], offset - 50)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 100, UpdateClickableSize)
        offset = offset - 65
    end
end

function GUI:SetupNameplateCastbarSize(parent)
    local guiName = C.ADDON_TITLE .. 'GUINamePlateCastbarSize'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
    local db = C.CharacterSettings.Nameplate

    local datas = { key = 'CastbarHeight', value = db.CastbarHeight, text = L['Height'], min = 6, max = 20, step = 1 }

    local offset = -10
    createGroupTitle(scroll, L['Nameplate Castbar'], offset)
    createSlider(scroll, 'Nameplate', datas.key, datas.text, datas.min, datas.max, datas.step, datas.value, 20, offset - 50)
end

function GUI:SetupNameplateExecuteIndicator(parent)
    local guiName = C.ADDON_TITLE .. 'GUINameplateExecuteIndicator'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
    createSlider(scroll, 'Nameplate', datas.key, datas.text, datas.min, datas.max, datas.step, datas.value, 20, offset)
end

local function RefreshSpecialUnitsList()
    NAMEPLATE:RefreshSpecialUnitsList()
end

function GUI:SetupNameplateUnitFilter(parent)
    local guiName = C.ADDON_TITLE .. 'GUINamePlateUnitFilter'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName, L['Special Units List'], true)
    panel:SetScript('OnHide', RefreshSpecialUnitsList)

    local barTable = {}

    local function createBar(parent, text, isNew)
        local npcID = tonumber(text)

        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 28)
        F.CreateBD(bar, 0.25)
        barTable[text] = bar

        local icon, close = createSpellBarWidget(bar, npcID and 136243 or 132288)
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
            sortSpellBar(barTable)
        end)

        local outline = _G.ANDROMEDA_ADB.FontOutline
        local name = F.CreateFS(bar, C.Assets.Fonts.Condensed, 12, outline or nil, text, nil, outline and 'NONE' or 'THICK', 'LEFT', 26, 0)
        name:SetWidth(180)
        name:SetJustifyH('LEFT')
        if isNew then
            name:SetTextColor(0, 1, 0)
        end
        if npcID then
            F.GetNpcName(npcID, function(npcName)
                name:SetText(npcName)
                if npcName == _G.UNKNOWN then
                    name:SetTextColor(1, 0, 0)
                end
            end)
        end

        sortSpellBar(barTable)
    end

    local frame = panel.bg
    local scroll = createScrollFrame(frame, 200, 485)

    local swatch = createColorSwatch(frame, nil, C.DB['Nameplate']['SpecialUnitColor'])
    swatch:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)
    swatch.__default = C.CharacterSettings['Nameplate']['SpecialUnitColor']
    swatch:SetSize(24, 24)

    scroll.box = F.CreateEditbox(frame, 100, 24)
    scroll.box:SetPoint('LEFT', swatch, 'RIGHT', 5, 0)
    scroll.box.tipHeader = L['Hint']
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

    scroll.add = F.CreateButton(frame, 35, 24, _G.ADD, 11)
    scroll.add:SetPoint('TOPRIGHT', -10, -10)
    scroll.add.__owner = scroll
    scroll.add:SetScript('OnClick', addClick)

    scroll.reset = F.CreateButton(frame, 35, 24, _G.RESET, 11)
    scroll.reset:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.reset:SetScript('OnClick', function()
        StaticPopup_Show('ANDROMEDA_RESET_NAMEPLATE_SPECIAL_UNIT_FILTER')
    end)

    for npcID in pairs(NAMEPLATE.SpecialUnitsList) do
        createBar(scroll.child, npcID)
    end
end

function GUI:SetupNameplateColorByDot(parent)
    local guiName = C.ADDON_TITLE .. 'GUINamePlateColorByDot'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName, L['Dot Spells List'], true)

    local barTable = {}

    local function createBar(parent, spellID, isNew)
        local spellName = GetSpellInfo(spellID)
        local texture = GetSpellTexture(spellID)

        local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
        bar:SetSize(200, 28)
        F.CreateBD(bar, 0.25)
        barTable[spellID] = bar

        local icon, close = createSpellBarWidget(bar, texture)
        F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
        close:SetScript('OnClick', function()
            bar:Hide()
            barTable[spellID] = nil
            C.DB['Nameplate']['DotSpellsList'][spellID] = nil
            sortSpellBar(barTable)
        end)

        local outline = _G.ANDROMEDA_ADB.FontOutline
        local name = F.CreateFS(bar, C.Assets.Fonts.Condensed, 12, outline or nil, spellName, nil, outline and 'NONE' or 'THICK', 'LEFT', 26, 0)
        name:SetWidth(180)
        name:SetJustifyH('LEFT')
        if isNew then
            name:SetTextColor(0, 1, 0)
        end

        sortSpellBar(barTable)
    end

    local frame = panel.bg
    local scroll = createScrollFrame(frame, 200, 485)

    local swatch = createColorSwatch(frame, nil, C.DB['Nameplate']['DotColor'])
    swatch:SetPoint('TOPLEFT', frame, 'TOPLEFT', 10, -10)
    swatch.__default = C.CharacterSettings['Nameplate']['DotColor']
    swatch:SetSize(24, 24)

    scroll.box = F.CreateEditbox(frame, 100, 24)
    scroll.box:SetPoint('LEFT', swatch, 'RIGHT', 5, 0)
    scroll.box.tipHeader = L['Hint']
    F.AddTooltip(scroll.box, 'ANCHOR_TOPRIGHT', L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 'BLUE')

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

    scroll.add = F.CreateButton(frame, 35, 24, _G.ADD, 11)
    scroll.add:SetPoint('TOPRIGHT', -10, -10)
    scroll.add.__owner = scroll
    scroll.add:SetScript('OnClick', addClick)

    scroll.reset = F.CreateButton(frame, 35, 24, _G.RESET, 11)
    scroll.reset:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
    scroll.reset:SetScript('OnClick', function()
        StaticPopup_Show('ANDROMEDA_RESET_NAMEPLATE_DOT_SPELLS')
    end)

    for npcID in pairs(C.DB['Nameplate']['DotSpellsList']) do
        createBar(scroll.child, npcID)
    end
end

local function UpdateNamePlateTags()
    NAMEPLATE:UpdateTags()
end

function GUI:SetupNameplateNameLength(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupNameplateNameLength'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scrollArea = createScrollFrame(panel, 220, 540)

    local mKey = 'Nameplate'
    local db = C.CharacterSettings.Nameplate

    local datas = {
        [1] = { key = 'NameLength', value = db.NameLength, text = L['Nameplate Name Length'], min = 0, max = 20 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        createGroupTitle(scrollArea, L['Name Length'], offset)
        createSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateNamePlateTags)
        offset = offset - 65
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

    UNITFRAME:UpdateClassPower()
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
    local guiName = C.ADDON_TITLE .. 'GUISetupPartyFrame'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Party Frame'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdatePartyFrameSize)
        offset = offset - 65
    end

    local options = {}
    for i = 1, 4 do
        options[i] = UNITFRAME.PartyDirections[i].name
    end

    createOptionDropdown(scroll, L['Growth Direction'], offset - 60, options, nil, mKey, 'PartyDirec', 1, UpdatePartyFrameSize)
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
    local guiName = C.ADDON_TITLE .. 'GUISetupRaidFrame'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Raid Frame'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateRaidFrameSize)
        offset = offset - 65
    end

    local options = {}
    for i = 1, 8 do
        options[i] = UNITFRAME.RaidDirections[i].name
    end

    createOptionDropdown(
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
    local guiName = C.ADDON_TITLE .. 'GUISetupSimpleRaidFrame'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'SMRScale', value = db.SMRScale, text = L['Scale'], min = 6, max = 20 },
        [2] = { key = 'SMRPerCol', value = db.SMRPerCol, text = L['Units Per Column'], min = 5, max = 40 },
        [3] = { key = 'SMRGroups', value = db.SMRGroups, text = L['Groups to Show'], min = 1, max = 8 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        createGroupTitle(scroll, L['Simple Raid Frames'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateSimpleRaidFrameSize)
        offset = offset - 65
    end

    local options = {}
    for i = 1, 4 do
        options[i] = UNITFRAME.RaidDirections[i].name
    end

    createOptionDropdown(scroll, L['Growth Direction'], offset - 60, options, nil, mKey, 'SMRDirec', 1)
    createOptionDropdown(scroll, L['Group By'], offset - 110, { _G.GROUP, _G.CLASS, _G.ROLE }, nil, mKey, 'SMRGroupBy', 1, UpdateSimpleRaidFrameSize)
end

function GUI:SetupUnitFrame(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupUnitFrame'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Player Frame'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.pet) do
        createGroupTitle(scroll, L['Pet Frame'], offset - 50)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 100, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.target) do
        createGroupTitle(scroll, L['Target Frame'], offset - 100)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 150, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.tot) do
        createGroupTitle(scroll, L['Target of Target Frame'], offset - 150)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 200, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.focus) do
        createGroupTitle(scroll, L['Focus Frame'], offset - 200)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 250, UpdateUnitFrameSize)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.tof) do
        createGroupTitle(scroll, L['Target of Focus Frame'], offset - 250)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 300, UpdateUnitFrameSize)
        offset = offset - 65
    end
end

function GUI:SetupBossFrame(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupBossFrame'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Boss Frame'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
        offset = offset - 65
    end
end

function GUI:SetupArenaFrame(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupArenaFrame'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Arena Frame'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
        offset = offset - 65
    end
end

function GUI:SetupClassPower(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupClassPower'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Class Power'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.checkbox) do
        createGroupTitle(scroll, L['Runes'], offset - 100)
        createCheckbox(scroll, offset - 130, mKey, v.value, v.text, nil, v.tip)
        offset = offset - 35
    end
end

local function UpdateFader()
    UNITFRAME:UpdateFader()
end

function GUI:SetupUnitFrameFader(parent)
    local guiName = C.ADDON_TITLE .. 'GUIUnitFrameFader'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Conditions'], offset)
        createCheckbox(scroll, offset - 30, mKey, v.value, v.text, UpdateFader)
        offset = offset - 35
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.fader) do
        createGroupTitle(scroll, L['Fading Parameters'], offset - 30)
        createSlider(scroll, mKey, v.key, v.text, 0, 1, 0.1, v.value, 20, offset - 80, UpdateFader)
        offset = offset - 65
    end
end

function GUI:SetupUnitFrameRangeCheck(parent)
    local guiName = C.ADDON_TITLE .. 'GUIRangeCheck'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
    createGroupTitle(scroll, L['Range Check'], offset)
    createSlider(scroll, 'Unitframe', datas.key, datas.text, datas.min, datas.max, datas.step, datas.value, 20, offset - 50)
end

function GUI:SetupCastbar(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupCastbar'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Player Castbar'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 50)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.target) do
        createGroupTitle(scroll, L['Target Castbar'], offset - 50)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 100)
        offset = offset - 65
    end

    scroll.groupTitle = nil

    for _, v in ipairs(datas.focus) do
        createGroupTitle(scroll, L['Focus Castbar'], offset - 100)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, v.step, v.value, 20, offset - 150)
        offset = offset - 65
    end
end

function GUI:SetupCastbarColor(parent)
    local guiName = C.ADDON_TITLE .. 'GUICastbarColor'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
    local db = C.DB.Unitframe

    local datas = {
        [1] = { key = 'CastingColor', value = db.CastingColor, text = L['Regular Casting'] },
        [2] = { key = 'UninterruptibleColor', value = db.UninterruptibleColor, text = L['Uninterruptible Casting'] },
        [3] = { key = 'CompleteColor', value = db.CompleteColor, text = L['Casting Complete'] },
        [4] = { key = 'FailColor', value = db.FailColor, text = L['Casting Fail'] },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        createGroupTitle(scroll, L['Castbar Color'], offset)
        createColorSwatch(scroll, v.text, v.value, C.CharacterSettings.Unitframe[v.key], offset - 34)

        offset = offset - 30
    end
end

local function UpdateGroupTags()
    UNITFRAME:UpdateGroupTags()
end

function GUI:SetupNameLength(parent)
    local guiName = C.ADDON_TITLE .. 'GUISetupNameLength'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scrollArea = createScrollFrame(panel, 220, 540)

    local mKey = 'Unitframe'
    local db = C.CharacterSettings.Unitframe

    local datas = {
        [1] = { key = 'PartyNameLength', value = db.PartyNameLength, text = L['Party Name Length'], min = 0, max = 10 },
        [2] = { key = 'RaidNameLength', value = db.RaidNameLength, text = L['Raid Name Length'], min = 0, max = 10 },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        createGroupTitle(scrollArea, L['Name Length'], offset)
        createSlider(scrollArea, mKey, v.key, v.text, v.min, v.max, 1, v.value, 20, offset - 50, UpdateGroupTags)
        offset = offset - 65
    end
end

-- Party watcher

do
    local function refreshPartyWatcher()
        UNITFRAME:UpdatePartyWatcherSpellsList()
    end

    function GUI:SetupPartyWatcher(parent)
        local guiName = C.ADDON_TITLE .. 'GUISetupPartyWatcher'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Party Spells List'], true)
        panel:SetScript('OnHide', refreshPartyWatcher)
        parent.panel = panel

        panel.barTable = {}
        panel.tableName = 'PartySpellsList'

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
            panel.barTable[spellID] = bar

            local icon, close = createSpellBarWidget(bar, texture)
            F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
            close:SetScript('OnClick', function()
                bar:Hide()
                if C.PartySpellsList[spellID] then
                    _G.ANDROMEDA_ADB['PartySpellsList'][spellID] = 0
                else
                    _G.ANDROMEDA_ADB['PartySpellsList'][spellID] = nil
                end
                panel.barTable[spellID] = nil
                sortSpellBar(panel.barTable)
            end)

            local outline = _G.ANDROMEDA_ADB.FontOutline
            local font = C.Assets.Fonts.Condensed
            local name = F.CreateFS(bar, font, 11, outline or nil, spellName, nil, outline and 'NONE' or 'THICK', 'LEFT', 30, 0)
            name:SetWidth(120)
            name:SetJustifyH('LEFT')

            local timer = F.CreateFS(bar, font, 11, outline or nil, duration, nil, outline and 'NONE' or 'THICK', 'RIGHT', -30, 0)
            timer:SetWidth(60)
            timer:SetJustifyH('RIGHT')
            timer:SetTextColor(0, 1, 0)

            sortSpellBar(panel.barTable)
        end

        local options = {}
        options[1] = createEditbox(panel.bg, nil, 10, -10, L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 60, 24)
        options[2] =
            createEditbox(panel.bg, nil, 76, -10, L["Enter the spell's cooldown duration.|nParty watcher only support regular spells and abilities.|nFor spells like 'Aspect of the Wild' (BM Hunter), you need to sync cooldown with your party members."], 60, 24)

        local scrollArea = createScrollFrame(panel.bg, 200, 485)
        panel.scrollArea = scrollArea

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

            local modDuration = _G.ANDROMEDA_ADB['PartySpellsList'][spellID]

            if modDuration and modDuration ~= 0 or C.PartySpellsList[spellID] and not modDuration then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
                return
            end

            _G.ANDROMEDA_ADB['PartySpellsList'][spellID] = duration
            createBar(scroll.child, spellID, duration)
            clearOption(options)
        end

        local addBtn = F.CreateButton(panel.bg, 35, 24, _G.ADD, 11)
        addBtn.__owner = panel
        addBtn:SetPoint('TOPRIGHT', -10, -10)
        addBtn:SetScript('OnClick', function()
            addClick(scrollArea, options)
        end)

        local rstBtn = F.CreateButton(panel.bg, 35, 24, _G.RESET, 11)
        rstBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
        rstBtn:SetScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_PARTY_SPELLS')
        end)

        for spellID, duration in pairs(UNITFRAME.PartySpellsList) do
            createSpellBar(scrollArea, spellID, panel.barTable, panel.tableName)
        end
    end
end

-- Debuff watcher

do
    local function refreshDebuffWatcher()
        UNITFRAME:UpdateRaidDebuffsList()
    end

    local function addNewDungeon(dungeons, dungeonID)
        local name = EJ_GetInstanceInfo(dungeonID)
        if name then
            tinsert(dungeons, name)
        end
    end

    local function analyzePrio(priority)
        priority = priority or 2
        priority = min(priority, 6)
        priority = max(priority, 1)

        return priority
    end

    local function isAuraExisted(instName, spellID)
        F:Debug(instName, spellID, C.RaidDebuffsList[instName][spellID])

        local localPrio = C.RaidDebuffsList[instName][spellID]
        local savedPrio = _G.ANDROMEDA_ADB['RaidDebuffsList'][instName] and _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spellID]
        if (localPrio and savedPrio and savedPrio == 0) or (not localPrio and not savedPrio) then
            return false
        end

        return true
    end

    function GUI:SetupDebuffWatcher(parent)
        local guiName = C.ADDON_TITLE .. 'GUISetupDebuffWatcher'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Instance Debuffs List'], true)
        panel:SetScript('OnHide', refreshDebuffWatcher)

        local setupBars
        local frame = panel.bg
        local bars, options = {}, {}

        local iType = createDropdown(frame, L['Instance Type'], 10, -30, { _G.DUNGEONS, _G.RAID, _G.OTHER }, L['Select the type of instance.|nThe list of debuffs is saved separately for each instance.'], 107, 24)
        iType.title = L['Hint']
        for i = 1, 3 do
            iType.options[i]:HookScript('OnClick', function()
                for j = 1, 2 do
                    resetOption(options[j])
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

        local dungeons = {}
        for dungeonID = 1196, 1204 do
            if dungeonID ~= 1200 then
                addNewDungeon(dungeons, dungeonID)
            end
        end
        addNewDungeon(dungeons, 313) -- 青龙寺
        addNewDungeon(dungeons, 537) -- 影月墓地
        addNewDungeon(dungeons, 721) -- 英灵殿
        addNewDungeon(dungeons, 800) -- 群星庭院

        local raids = {
            [1] = EJ_GetInstanceInfo(1200),
        }

        options[1] = createDropdown(frame, _G.DUNGEONS, 123, -30, dungeons, L['Select a specific dungeon.'], 107, 24)
        options[1].title = L['Hint']
        options[1]:Hide()
        options[2] = createDropdown(frame, _G.RAID, 123, -30, raids, L['Select a specific raid.'], 107, 24)
        options[2].title = L['Hint']
        options[2]:Hide()
        options[3] = createEditbox(frame, L['SpellID'], 10, -90, L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 107, 24)
        options[4] = createEditbox(
            frame,
            L['Priority'],
            123,
            -90,
            L["Spell's priority when visible.|nWhen multiple spells exist, it only remain the one that owns highest priority.|nDefault priority is 2, if you leave it blank.|nThe maximun priority is 6, and the icon would flash if you set so."],
            107,
            24
        )

        local function addClick(options)
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

            if isAuraExisted(instName, spellID) then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
                return
            end

            priority = analyzePrio(priority)
            if not _G.ANDROMEDA_ADB['RaidDebuffsList'][instName] then
                _G.ANDROMEDA_ADB['RaidDebuffsList'][instName] = {}
            end
            _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spellID] = priority
            setupBars(instName)
            resetOption(options[3])
            resetOption(options[4])
        end

        local scroll = createScrollFrame(frame, 200, 380)
        scroll:ClearAllPoints()
        scroll:SetPoint('TOPLEFT', 10, -150)

        scroll.reset = F.CreateButton(frame, 70, 24, _G.RESET, 11)
        scroll.reset:SetPoint('TOPLEFT', 10, -120)
        scroll.reset:SetScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_RAID_DEBUFFS')
        end)

        scroll.add = F.CreateButton(frame, 70, 24, _G.ADD, 11)
        scroll.add:SetPoint('TOPRIGHT', -10, -120)
        scroll.add:SetScript('OnClick', function()
            addClick(options)
        end)

        scroll.clear = F.CreateButton(frame, 70, 24, _G.KEY_NUMLOCK_MAC, 11)
        scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -5, 0)
        scroll.clear:SetScript('OnClick', function()
            clearOption(options)
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

            local icon, close = createSpellBarWidget(bar, texture)
            icon:SetScript('OnEnter', iconOnEnter)
            icon:SetScript('OnLeave', F.HideTooltip)
            bar.icon = icon

            close:SetScript('OnClick', function()
                bar:Hide()
                if C.RaidDebuffsList[bar.instName][bar.spellID] then
                    if not _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName] then
                        _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName] = {}
                    end
                    _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName][bar.spellID] = 0
                else
                    _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName][bar.spellID] = nil
                end
                setupBars(bar.instName)
            end)

            local outline = _G.ANDROMEDA_ADB.FontOutline
            local spellName = F.CreateFS(bar, C.Assets.Fonts.Condensed, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'LEFT', 26, 0)
            spellName:SetWidth(120)
            spellName:SetJustifyH('LEFT')
            bar.spellName = spellName

            local prioBox = F.CreateEditbox(bar, 22, 22)
            prioBox:SetPoint('RIGHT', close, 'LEFT', -3, 0)
            --prioBox:SetTextInsets(10, 0, 0, 0)
            prioBox:SetJustifyH('CENTER')
            prioBox:SetMaxLetters(1)
            prioBox:SetTextColor(0, 1, 0)
            prioBox.bg:SetBackdropColor(1, 1, 1, 0.3)
            prioBox:HookScript('OnEscapePressed', function(self)
                self:SetText(bar.priority)
            end)
            prioBox:HookScript('OnEnterPressed', function(self)
                local prio = analyzePrio(tonumber(self:GetText()))
                if not _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName] then
                    _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName] = {}
                end
                _G.ANDROMEDA_ADB['RaidDebuffsList'][bar.instName][bar.spellID] = prio
                self:SetText(prio)
            end)
            prioBox.tipHeader = L['Priority']
            F.AddTooltip(prioBox, 'ANCHOR_RIGHT', L['Priority limit in 1-6.|nPress ENTER key when you finish typing.'], 'BLUE')
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

            if C.RaidDebuffsList[instName] then
                for spellID, priority in pairs(C.RaidDebuffsList[instName]) do
                    if not (_G.ANDROMEDA_ADB['RaidDebuffsList'][instName] and _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spellID]) then
                        index = index + 1
                        applyData(index, instName, spellID, priority)
                    end
                end
            end

            if _G.ANDROMEDA_ADB['RaidDebuffsList'][instName] then
                for spellID, priority in pairs(_G.ANDROMEDA_ADB['RaidDebuffsList'][instName]) do
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

-- Corner spell

do
    local function refreshCornerSpell()
        UNITFRAME:UpdateCornerSpellsList()
    end

    function GUI:SetupCornerSpell(parent)
        local guiName = C.ADDON_TITLE .. 'GUISetupCornerSpell'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Corner Spells List'], true)
        panel:SetScript('OnHide', refreshCornerSpell)
        parent.panel = panel

        local barList = {}

        local decodeAnchor = {
            ['TL'] = 'TOPLEFT',
            ['T'] = 'TOP',
            ['TR'] = 'TOPRIGHT',
            ['L'] = 'LEFT',
            ['R'] = 'RIGHT',
            ['BL'] = 'BOTTOMLEFT',
            ['B'] = 'BOTTOM',
            ['BR'] = 'BOTTOMRIGHT',
        }

        local anchors = {
            'TL', 'T', 'TR',
            'L', 'R',
            'BL', 'B', 'BR',
        }

        local function createBar(parent, spellID, anchor, r, g, b, showAll)
            local name, _, texture = GetSpellInfo(spellID)
            local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
            bar:SetSize(200, 28)
            F.CreateBD(bar, 0.25)
            barList[spellID] = bar

            local icon, close = createSpellBarWidget(bar, texture)
            F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
            close:SetScript('OnClick', function()
                bar:Hide()
                local value = C.CornerSpellsList[C.MY_CLASS][spellID]
                if value then
                    _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS][spellID] = {}
                else
                    _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS][spellID] = nil
                end
                barList[spellID] = nil
                sortSpellBar(barList)
            end)

            name = L[anchor] or name
            local outline = _G.ANDROMEDA_ADB.FontOutline
            local font = C.Assets.Fonts.Condensed
            local text = F.CreateFS(bar, font, 12, outline or nil, name, nil, outline and 'NONE' or 'THICK', 'LEFT', 26, 0)
            text:SetWidth(160)
            text:SetJustifyH('LEFT')
            if anchor then
                text:SetTextColor(r, g, b)
            end
            if showAll then
                F.CreateFS(bar, font, 12, outline or nil, 'ALL', nil, outline and 'NONE' or 'THICK', 'RIGHT', -30, 0)
            end

            sortSpellBar(barList)
        end

        local function addClick(parent)
            local spellID = tonumber(panel.editBox:GetText())

            if not spellID or not GetSpellInfo(spellID) then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Incorrect SpellID'])
                return
            end

            local anchor, r, g, b, showAll
            anchor, r, g, b = parent.dd.Text:GetText(), parent.swatch.tex:GetColor()
            showAll = parent.showAll:GetChecked() or nil

            local modValue = _G.ANDROMEDA_ADB['CornerSpells'][C.MY_CLASS][spellID]
            if (modValue and next(modValue)) or (C.CornerSpellsList[C.MY_CLASS][spellID] and not modValue) then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['The SpellID is existed'])
                return
            end
            anchor = decodeAnchor[anchor]
            _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS][spellID] = { anchor, { r, g, b }, showAll }

            createBar(parent.child, spellID, anchor, r, g, b, showAll)
            panel.editBox:SetText('')
        end

        local function optionOnEnter(self)
            _G.GameTooltip:SetOwner(self, 'ANCHOR_TOP')
            _G.GameTooltip:ClearLines()
            _G.GameTooltip:AddLine(L[decodeAnchor[self.text]], 1, 1, 1)
            _G.GameTooltip:Show()
        end

        local scrollArea = createScrollFrame(panel.bg, 200, 485)
        panel.scrollArea = scrollArea

        scrollArea.dd = F.CreateDropdown(panel.bg, 40, 24, anchors)
        scrollArea.dd:SetPoint('TOPLEFT', 10, -10)
        scrollArea.dd.options[1]:Click()
        for i = 1, 8 do
            scrollArea.dd.options[i]:HookScript('OnEnter', optionOnEnter)
            scrollArea.dd.options[i]:HookScript('OnLeave', F.HideTooltip)
        end

        local editBox = createEditbox(panel.bg, nil, nil, nil, nil, 40, 24)
        editBox:SetPoint('TOPLEFT', scrollArea.dd, 'TOPRIGHT', 5, 0)
        panel.editBox = editBox
        editBox.tipHeader = L['Hint']
        F.AddTooltip(editBox, 'ANCHOR_TOPRIGHT', L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 'BLUE')

        local swatch = F.CreateColorSwatch(panel.bg)
        swatch:SetPoint('LEFT', editBox, 'RIGHT', 5, 0)
        swatch:SetSize(22, 22)
        scrollArea.swatch = swatch

        local showAll = F.CreateCheckbox(panel.bg, true)
        showAll:SetPoint('LEFT', swatch, 'RIGHT', 3, 0)
        showAll:SetSize(24, 24)
        showAll.tipHeader = L['Hint']
        F.AddTooltip(showAll, 'ANCHOR_TOPRIGHT', L['If unchecked, you can only see the aura you cast.|nIf checked, the aura would be tracked from all casters.'], 'BLUE')
        scrollArea.showAll = showAll

        local addBtn = F.CreateButton(panel.bg, 35, 24, _G.ADD, 11)
        addBtn.__owner = panel
        addBtn:SetPoint('TOPRIGHT', -10, -10)
        addBtn:SetScript('OnClick', function()
            addClick(scrollArea)
        end)

        local rstBtn = F.CreateButton(panel.bg, 35, 24, _G.RESET, 11)
        rstBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
        rstBtn:SetScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_CORNER_SPELLS')
        end)






        for spellID, value in pairs(UNITFRAME.CornerSpellsList) do
            local r, g, b = unpack(value[2])
            createBar(scrollArea.child, spellID, value[1], r, g, b, value[3])
        end
    end
end

-- Raid buff/debuff

do
    local function refreshBuffsIndicator()
        UNITFRAME:UpdateRaidBuffsWhiteList()
    end

    function GUI:SetupRaidBuff(parent)
        local guiName = C.ADDON_TITLE .. 'GUISetupRaidBuff'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Buffs White List'], true)
        panel:SetScript('OnHide', refreshBuffsIndicator)
        parent.panel = panel

        panel.barTable = {}
        panel.tableName = 'RaidBuffsWhiteList'

        local scrollArea = createScrollFrame(panel.bg, 200, 485)
        panel.scrollArea = scrollArea

        local editBox = createEditbox(panel.bg, nil, 10, -10, nil, 130, 24)
        panel.editBox = editBox
        editBox.tipHeader = L['Hint']
        F.AddTooltip(editBox, 'ANCHOR_RIGHT', L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 'BLUE')

        local addBtn = F.CreateButton(panel.bg, 35, 24, _G.ADD, 11)
        addBtn.__owner = panel
        addBtn:SetPoint('TOPRIGHT', -10, -10)
        addBtn:HookScript('OnClick', addButton_OnClick)

        local resetBtn = F.CreateButton(panel.bg, 35, 24, _G.RESET, 11)
        resetBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
        resetBtn:HookScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_RAID_BUFFS_WHITE')
        end)

        for spellID, value in pairs(UNITFRAME[panel.tableName]) do
            if value then
                createSpellBar(scrollArea, spellID, panel.barTable, panel.tableName)
            end
        end

        -- local cb = F.CreateCheckbox(panel.bg, true)
        -- cb:SetPoint('BOTTOMRIGHT', panel.bg, 'TOPRIGHT', 0, 5)
        -- cb:SetChecked(C.DB.Unitframe.RaidBuffAuto)
        -- cb:SetSize(18, 18)
        -- cb:SetScript('OnClick', function()
        --     C.DB.Unitframe.RaidBuffAuto = cb:GetChecked()
        -- end)
        -- cb.tipHeader = L['Hint']
        -- F.AddTooltip(cb, 'ANCHOR_TOPRIGHT', L['If checked, use blizzard API logic to display buffs, no longer use the white list below, up to 3.'], 'BLUE')
    end

    local function refreshDebuffsIndicator()
        UNITFRAME:UpdateRaidDebuffsBlackList()
    end

    function GUI:SetupRaidDebuff(parent)
        local guiName = C.ADDON_TITLE .. 'GUISetupRaidDebuff'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Debuffs Black List'], true)
        panel:SetScript('OnHide', refreshDebuffsIndicator)
        parent.panel = panel

        panel.barTable = {}
        panel.tableName = 'RaidDebuffsBlackList'

        local scrollArea = createScrollFrame(panel.bg, 200, 485)
        panel.scrollArea = scrollArea

        local editBox = createEditbox(panel.bg, nil, 10, -10, nil, 130, 24)
        panel.editBox = editBox
        editBox.tipHeader = L['Hint']
        F.AddTooltip(editBox, 'ANCHOR_RIGHT', L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 'BLUE')

        local addBtn = F.CreateButton(panel.bg, 35, 24, _G.ADD, 11)
        addBtn.__owner = panel
        addBtn:SetPoint('TOPRIGHT', -10, -10)
        addBtn:HookScript('OnClick', addButton_OnClick)

        local resetBtn = F.CreateButton(panel.bg, 35, 24, _G.RESET, 11)
        resetBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
        resetBtn:HookScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_RAID_DEBUFFS_BLACK')
        end)

        for spellID, value in pairs(UNITFRAME[panel.tableName]) do
            if value then
                createSpellBar(scrollArea, spellID, panel.barTable, panel.tableName)
            end
        end
    end
end

-- General

function GUI:SetupAutoScreenshot(parent)
    local guiName = C.ADDON_TITLE .. 'GUIAutoScreenshot'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

    local datas = {
        [1] = { value = 'EarnedNewAchievement', text = L['Earned new achievement'] },
        [2] = { value = 'ChallengeModeCompleted', text = L['Mythic+ completed'] },
        [3] = { value = 'PlayerLevelUp', text = L['Level up'] },
        [4] = { value = 'PlayerDead', text = _G.DEAD },
    }

    local offset = -10
    for _, data in ipairs(datas) do
        createGroupTitle(scroll, L['Auto Screenshot'], offset)
        createCheckbox(scroll, offset - 30, 'General', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupCustomClassColor(parent)
    local guiName = C.ADDON_TITLE .. 'GUICustomClassColor'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

    local colors = _G.ANDROMEDA_ADB.CustomClassColors

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
        [13] = { text = 'EVOKER', value = colors.EVOKER },
    }

    local offset = -10
    for _, v in ipairs(datas) do
        createGroupTitle(scroll, L['Class Color Customization'], offset)
        createColorSwatch(scroll, v.text, v.value, C.AccountSettings.CustomClassColors[v.text], offset - 34)

        offset = offset - 30
    end
end

local function UpdateVignettingVisibility()
    VIGNETTING:UpdateVisibility()
end

function GUI:SetupVignettingVisibility(parent)
    local guiName = C.ADDON_TITLE .. 'GUIVignetting'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
    createSlider(scroll, 'General', datas.key, datas.text, datas.min, datas.max, datas.step, datas.value, 20, offset, UpdateVignettingVisibility)
end

-- Chat



-- Combat
function GUI:SetupSimpleFloatingCombatText(parent)
    local guiName = C.ADDON_TITLE .. 'GUIFCT'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

    local datas = {
        [1] = { value = 'Incoming', text = L['Incoming'] },
        [2] = { value = 'Outgoing', text = L['Outgoing'] },
        [3] = { value = 'Pet', text = L['Pet'] },
        [4] = { value = 'Periodic', text = L['Periodic'] },
        [5] = { value = 'Merge', text = L['Merge'] },
    }

    local offset = -10
    for _, data in ipairs(datas) do
        createGroupTitle(scroll, L['Floating Combat Text'], offset)
        createCheckbox(scroll, offset - 30, 'Combat', data.value, data.text)
        offset = offset - 35
    end
end

function GUI:SetupSoundAlert(parent)
    local guiName = C.ADDON_TITLE .. 'GUISoundAlert'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)

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
        createGroupTitle(scroll, L['Sound Alert'], offset)
        createCheckbox(scroll, offset - 30, 'Combat', data.value, data.text)
        offset = offset - 35
    end
end

-- Announcement
do
    local function refreshAnnounceableSpells()
        ANNOUNCEMENT:RefreshSpells()
    end

    function GUI:SetupAnnounceableSpells(parent)
        local guiName = C.ADDON_TITLE .. 'GUIAnnounceableSpells'
        togglePanel(guiName)
        if extraGUIs[guiName] then
            return
        end

        local panel = createPanel(parent, guiName, L['Announceable Spells List'], true)
        panel:SetScript('OnHide', refreshAnnounceableSpells)
        parent.panel = panel

        panel.barTable = {}
        panel.tableName = 'AnnounceableSpellsList'

        local scrollArea = createScrollFrame(panel.bg, 200, 485)
        panel.scrollArea = scrollArea

        local editBox = createEditbox(panel.bg, nil, 10, -10, nil, 130, 24)
        panel.editBox = editBox
        editBox.tipHeader = L['Hint']
        F.AddTooltip(editBox, 'ANCHOR_RIGHT', L['Fill in SpellID, must be a number.|nSpell name is not supported.'], 'BLUE')

        local addBtn = F.CreateButton(panel.bg, 35, 24, _G.ADD, 11)
        addBtn.__owner = panel
        addBtn:SetPoint('TOPRIGHT', -10, -10)
        addBtn:HookScript('OnClick', addButton_OnClick)

        local resetBtn = F.CreateButton(panel.bg, 35, 24, _G.RESET, 11)
        resetBtn:SetPoint('RIGHT', addBtn, 'LEFT', -5, 0)
        resetBtn:HookScript('OnClick', function()
            StaticPopup_Show('ANDROMEDA_RESET_ANNOUNCEABLE_SPELLS')
        end)

        for spellID, value in pairs(ANNOUNCEMENT[panel.tableName]) do
            if value then
                createSpellBar(scrollArea, spellID, panel.barTable, panel.tableName)
            end
        end
    end
end

-- Map
local function UpdateMapScale()
    MAP:UpdateMinimapScale()
end

function GUI:SetupMapScale(parent)
    local guiName = C.ADDON_TITLE .. 'GUIMapScale'
    togglePanel(guiName)
    if extraGUIs[guiName] then
        return
    end

    local panel = createPanel(parent, guiName)
    local scroll = createScrollFrame(panel, 220, 540)
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
        createGroupTitle(scroll, L['Map Scale'], offset)
        createSlider(scroll, mKey, v.key, v.text, v.min, v.max, 0.1, v.value, 20, offset - 50, UpdateMapScale)
        offset = offset - 65
    end
end
