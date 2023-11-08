local F, C, L = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')
local cargBags = F.Libs.cargBags
local iconsList = C.Assets.Textures
local LBG = F.Libs.LibButtonGlow

local iconColor = { 0.5, 0.5, 0.5 }
local bagTypeColor = {
    [0] = { 0, 0, 0, 0.25 }, -- 容器
    [1] = false, -- 灵魂袋
    [2] = { 0, 0.5, 0, 0.25 }, -- 草药袋
    [3] = { 0.8, 0, 0.8, 0.25 }, -- 附魔袋
    [4] = { 1, 0.8, 0, 0.25 }, -- 工程袋
    [5] = { 0, 0.8, 0.8, 0.25 }, -- 宝石袋
    [6] = { 0.5, 0.4, 0, 0.25 }, -- 矿石袋
    [7] = { 0.8, 0.5, 0.5, 0.25 }, -- 制皮包
    [8] = { 0.8, 0.8, 0.8, 0.25 }, -- 铭文包
    [9] = { 0.4, 0.6, 1, 0.25 }, -- 工具箱
    [10] = { 0.8, 0, 0, 0.25 }, -- 烹饪包
    [11] = { 0.2, 0.8, 0.2, 0.25 }, -- 材料包
}

local sortCache = {}
function INVENTORY:ReverseSort()
    for bag = 0, 4 do
        local numSlots = C_Container.GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local info = C_Container.GetContainerItemInfo(bag, slot)
            local texture = info and info.iconFileID
            local locked = info and info.isLocked

            if (slot <= numSlots / 2) and texture and not locked and not sortCache['b' .. bag .. 's' .. slot] then
                C_Container.PickupContainerItem(bag, slot)
                C_Container.PickupContainerItem(bag, numSlots + 1 - slot)
                sortCache['b' .. bag .. 's' .. slot] = true
            end
        end
    end

    INVENTORY.Bags.isSorting = false
    INVENTORY:UpdateAllBags()
end

local anchorCache = {}

local function CheckForBagReagent(name)
    local pass = true
    if name == 'BagReagent' and C_Container.GetContainerNumSlots(5) == 0 then
        pass = false
    end

    return pass
end

function INVENTORY:UpdateBagsAnchor(parent, bags)
    wipe(anchorCache)

    local index = 1
    local perRow = C.DB.Inventory.BagsPerRow
    anchorCache[index] = parent

    for i = 1, #bags do
        local bag = bags[i]
        if bag:GetHeight() > 45 and CheckForBagReagent(bag.name) then
            bag:Show()
            index = index + 1

            bag:ClearAllPoints()
            if (index - 1) % perRow == 0 then
                bag:SetPoint('BOTTOMRIGHT', anchorCache[index - perRow], 'BOTTOMLEFT', -5, 0)
            else
                bag:SetPoint('BOTTOMLEFT', anchorCache[index - 1], 'TOPLEFT', 0, 5)
            end
            anchorCache[index] = bag
        else
            bag:Hide()
        end
    end
end

function INVENTORY:UpdateBankAnchor(parent, bags)
    wipe(anchorCache)

    local index = 1
    local perRow = C.DB.Inventory.BankPerRow
    anchorCache[index] = parent

    for i = 1, #bags do
        local bag = bags[i]
        if bag:GetHeight() > 45 then
            bag:Show()
            index = index + 1

            bag:ClearAllPoints()
            if index <= perRow then
                bag:SetPoint('BOTTOMLEFT', anchorCache[index - 1], 'TOPLEFT', 0, 5)
            elseif index == perRow + 1 then
                bag:SetPoint('BOTTOMLEFT', anchorCache[index - perRow], 'BOTTOMRIGHT', 5, 0)
            elseif (index - 1) % perRow == 0 then
                bag:SetPoint('BOTTOMLEFT', anchorCache[index - perRow], 'BOTTOMRIGHT', 5, 0)
            else
                bag:SetPoint('BOTTOMLEFT', anchorCache[index - 1], 'TOPLEFT', 0, -5)
            end
            anchorCache[index] = bag
        else
            bag:Hide()
        end
    end
end

local function highlightFunction(button, match)
    button.searchOverlay:SetShown(not match)
end

local function IsItemMatched(str, text)
    if not str or str == '' then
        return
    end

    return strmatch(strlower(str), text)
end

function INVENTORY:CreateMoneyFrame()
    local moneyFrame = CreateFrame('Button', nil, self)
    moneyFrame:SetPoint('TOPLEFT', 6, 0)
    moneyFrame:SetSize(140, 26)

    local tag = self:SpawnPlugin('TagDisplay', '[money] [currencies]', moneyFrame)
    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.SetFS(tag, C.Assets.Fonts.Bold, 12, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    tag:SetPoint('TOPLEFT', 0, -4)
end

local function ToggleWidgetButtons(self)
    C.DB['Inventory']['HideWidgets'] = not C.DB['Inventory']['HideWidgets']

    local buttons = self.__owner.widgetButtons

    for index, button in pairs(buttons) do
        if index > 2 then
            button:SetShown(not C.DB['Inventory']['HideWidgets'])
        end
    end

    if C.DB['Inventory']['HideWidgets'] then
        -- self.tag:Show()
        self:SetPoint('RIGHT', buttons[2], 'LEFT', -1, 0)
        self.__texture:SetTexture(iconsList.BagSplit)
    else
        -- self.tag:Hide()
        self:SetPoint('RIGHT', buttons[#buttons], 'LEFT', -1, 0)
        self.__texture:SetTexture(iconsList.BagSplit)
    end
    self:Show()
end

function INVENTORY:CreateCollapseArrow()
    local bu = CreateFrame('Button', nil, self)
    bu:SetSize(16, 16)
    local tex = bu:CreateTexture()
    tex:SetAllPoints()
    tex:SetTexture(iconsList.BagSplit)
    bu.__texture = tex
    bu:SetScript('OnEnter', F.Texture_OnEnter)
    bu:SetScript('OnLeave', F.Texture_OnLeave)

    bu.__owner = self
    C.DB['Inventory']['HideWidgets'] = not C.DB['Inventory']['HideWidgets'] -- reset before toggle
    ToggleWidgetButtons(bu)
    bu:SetScript('OnClick', ToggleWidgetButtons)

    self.widgetArrow = bu
end

local function updateBagBar(bar)
    local spacing = 3
    local offset = 5
    local width, height = bar:LayoutButtons('grid', bar.columns, spacing, offset, -offset)
    bar:SetSize(width + offset * 2, height + offset * 2)
end

function INVENTORY:CreateBagBar(settings, columns)
    local bagBar = self:SpawnPlugin('BagBar', settings.Bags)
    bagBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -5)
    F.SetBD(bagBar)
    bagBar.highlightFunction = highlightFunction
    bagBar.isGlobal = true
    bagBar:Hide()
    bagBar.columns = columns
    bagBar.UpdateAnchor = updateBagBar
    bagBar:UpdateAnchor()

    self.BagBar = bagBar
end

local function CloseOrRestoreBags(self, btn)
    if btn == 'RightButton' then
        local bag = self.__owner.main
        local bank = self.__owner.bank
        local reagent = self.__owner.reagent

        C.DB['UIAnchorTemp'][bag:GetName()] = nil
        C.DB['UIAnchorTemp'][bank:GetName()] = nil
        C.DB['UIAnchorTemp'][reagent:GetName()] = nil

        bag:ClearAllPoints()
        bag:SetPoint(unpack(bag.__anchor))
        bank:ClearAllPoints()
        bank:SetPoint(unpack(bank.__anchor))
        reagent:ClearAllPoints()
        reagent:SetPoint(unpack(reagent.__anchor))
        PlaySound(_G.SOUNDKIT.IG_MINIMAP_OPEN)
    else
        _G.CloseAllBags()
    end
end

function INVENTORY:CreateRestoreButton(f)
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagRestore)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:RegisterForClicks('AnyUp')
    bu.__owner = f
    bu:SetScript('OnClick', CloseOrRestoreBags)
    bu.tipHeader = _G.CLOSE .. '/' .. _G.RESET
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

function INVENTORY:CreateReagentButton(f)
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagReagen)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:RegisterForClicks('AnyUp')
    bu:SetScript('OnClick', function(_, btn)
        if not IsReagentBankUnlocked() then
            _G.StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
        else
            PlaySound(_G.SOUNDKIT.IG_CHARACTER_INFO_TAB)
            _G.ReagentBankFrame:Show()
            _G.BankFrame.selectedTab = 2
            f.reagent:Show()
            f.bank:Hide()

            if btn == 'RightButton' then
                DepositReagentBank()
            end
        end
    end)

    bu.tipHeader = _G.REAGENT_BANK
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

function INVENTORY:CreateBankButton(f)
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagReagen)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:SetScript('OnClick', function()
        PlaySound(_G.SOUNDKIT.IG_CHARACTER_INFO_TAB)
        _G.ReagentBankFrame:Hide()
        _G.BankFrame.selectedTab = 1
        f.reagent:Hide()
        f.bank:Show()
    end)

    bu.tipHeader = _G.BANK
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

local function updateDepositButtonStatus(bu)
    if C.DB.Inventory.AutoDeposit then
        bu.Icon:SetVertexColor(C.r, C.g, C.b)
    else
        bu.Icon:SetVertexColor(unpack(iconColor))
    end
end

function INVENTORY:AutoDeposit()
    if C.DB.Inventory.AutoDeposit and not IsShiftKeyDown() then
        DepositReagentBank()
    end
end

function INVENTORY:CreateDepositButton()
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagDeposit)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:RegisterForClicks('AnyUp')
    bu:SetScript('OnClick', function(_, btn)
        if btn == 'RightButton' then
            C.DB.Inventory.AutoDeposit = not C.DB.Inventory.AutoDeposit
            updateDepositButtonStatus(bu)
        else
            DepositReagentBank()
        end
    end)

    bu.tipHeader = _G.REAGENTBANK_DEPOSIT
    F.AddTooltip(
        bu,
        'ANCHOR_TOP',
        L['Left click to deposit reagents, right click to switch deposit mode.|nIf the button is highlight, the reagents from your bags would auto deposit once you open the bank.'],
        'BLUE'
    )
    updateDepositButtonStatus(bu)

    return bu
end

local function ToggleBackpacks(self)
    local parent = self.__owner
    F:TogglePanel(parent.BagBar)
    if parent.BagBar:IsShown() then
        self.Icon:SetVertexColor(C.r, C.g, C.b)
        PlaySound(_G.SOUNDKIT.IG_BACKPACK_OPEN)
    else
        self.Icon:SetVertexColor(unpack(iconColor))
        PlaySound(_G.SOUNDKIT.IG_BACKPACK_CLOSE)
    end
end

function INVENTORY:CreateBagToggle()
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagToggle)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu.__owner = self
    bu:SetScript('OnClick', ToggleBackpacks)

    bu.tipHeader = _G.BACKPACK_TOOLTIP
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

function INVENTORY:CreateSortButton(name)
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagSort)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:SetScript('OnClick', function()
        if C.DB.Inventory.SortMode == 3 then
            _G.UIErrorsFrame:AddMessage(C.INFO_COLOR .. L['Inventory sort disabled!'])
            return
        end

        if name == 'Bank' then
            C_Container.SortBankBags()
        elseif name == 'Reagent' then
            C_Container.SortReagentBankBags()
        else
            if C.DB.Inventory.SortMode == 1 then
                C_Container.SortBags()
            elseif C.DB.Inventory.SortMode == 2 then
                if InCombatLockdown() then
                    _G.UIErrorsFrame:AddMessage(C.INFO_COLOR .. _G.ERR_NOT_IN_COMBAT)
                else
                    C_Container.SortBags()
                    wipe(sortCache)
                    INVENTORY.Bags.isSorting = true
                    F:Delay(0.5, INVENTORY.ReverseSort)
                end
            end
        end
    end)

    bu.tipHeader = L['Inventory Sort']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

local function updateRepairButtonStatus(bu)
    if _G.ANDROMEDA_ADB['RepairType'] == 1 then
        bu.Icon:SetVertexColor(C.r, C.g, C.b)
        bu.text = L['Repair your equipment automatically when you visit an able vendor.|nPriority use of guild funds.']
        bu.title = L['Auto Repair'] .. ': ' .. C.GREEN_COLOR .. _G.VIDEO_OPTIONS_ENABLED
    elseif _G.ANDROMEDA_ADB['RepairType'] == 2 then
        bu.Icon:SetVertexColor(C.r, C.g, C.b)
        bu.text = L['Repair your equipment automatically when you visit an able vendor.|nDo not use guild funds.']
        bu.title = L['Auto Repair'] .. ': ' .. C.GREEN_COLOR .. _G.VIDEO_OPTIONS_ENABLED
    else
        bu.Icon:SetVertexColor(unpack(iconColor))
        bu.text = nil
        bu.title = L['Auto Repair'] .. ': ' .. C.GREEN_COLOR .. _G.VIDEO_OPTIONS_DISABLED
    end
end

function INVENTORY:CreateRepairButton()
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagRepair)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:SetScript('OnClick', function(self)
        _G.ANDROMEDA_ADB['RepairType'] = mod(_G.ANDROMEDA_ADB['RepairType'] + 1, 3)
        updateRepairButtonStatus(bu)
        self:GetScript('OnEnter')(self)
    end)

    bu.tipHeader = L['Auto Repair']
    F.AddTooltip(bu, 'ANCHOR_TOP', L['Repair your equipment automatically when you visit an able vendor.'], 'BLUE')
    updateRepairButtonStatus(bu)
    return bu
end

local function updateSellButtonStatus(bu)
    if C.DB.Inventory.AutoSellJunk then
        bu.Icon:SetVertexColor(C.r, C.g, C.b)
        bu.text = L['Sell junk items automtically when you visit an able vendor.']
        bu.title = L['Auto Sell Junk'] .. ': ' .. C.GREEN_COLOR .. _G.VIDEO_OPTIONS_ENABLED
    else
        bu.Icon:SetVertexColor(unpack(iconColor))
        bu.text = nil
        bu.title = L['Auto Sell Junk'] .. ': ' .. C.GREEN_COLOR .. _G.VIDEO_OPTIONS_DISABLED
    end
end

function INVENTORY:CreateSellButton()
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagSell)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu:SetScript('OnClick', function(self)
        C.DB.Inventory.AutoSellJunk = not C.DB.Inventory.AutoSellJunk
        updateSellButtonStatus(bu)
        self:GetScript('OnEnter')(self)
    end)

    bu.tipHeader = L['Auto Sell Junk']
    F.AddTooltip(bu, 'ANCHOR_TOP', L['Sell junk items automtically when you visit an able vendor.'], 'BLUE')
    updateSellButtonStatus(bu)
    return bu
end

local smartFilter = {
    default = function(item, text)
        text = strlower(text)
        if text == 'boe' then
            return item.bindOn == 'equip'
        else
            return IsItemMatched(item.subType, text) or IsItemMatched(item.equipLoc, text) or IsItemMatched(item.name, text)
        end
    end,
    _default = 'default',
}

function INVENTORY:CreateSearchButton()
    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagSearch)
    bu.Icon:SetVertexColor(unpack(iconColor))

    bu.tipHeader = L['Search']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    local searchBar = self:SpawnPlugin('SearchBar', bu)
    searchBar.highlightFunction = highlightFunction
    searchBar.isGlobal = true
    searchBar:SetPoint('RIGHT', bu, 'RIGHT', -6, 0)
    searchBar:SetSize(80, 26)
    searchBar:DisableDrawLayer('BACKGROUND')
    searchBar.tipHeader = L['Search']
    F.AddTooltip(searchBar, 'ANCHOR_TOP', L["You can type in item names or item equip locations.|n'boe' for items that bind on equip and 'quest' for quest items."], 'BLUE')

    local bg = F.CreateBDFrame(searchBar, 0, true)
    bg:SetPoint('TOPLEFT', -5, -5)
    bg:SetPoint('BOTTOMRIGHT', 5, 5)
    searchBar.textFilters = smartFilter

    searchBar:SetScript('OnShow', function()
        bu:SetSize(80, 26)
    end)

    searchBar:SetScript('OnHide', function()
        bu:SetSize(16, 16)
    end)

    return bu
end

function INVENTORY:GetContainerEmptySlot(bagID)
    for slotID = 1, C_Container.GetContainerNumSlots(bagID) do
        if not C_Container.GetContainerItemID(bagID, slotID) then
            return slotID
        end
    end
end

function INVENTORY:GetEmptySlot(name)
    if name == 'Bag' then
        for bagID = 0, 4 do
            local slotID = INVENTORY:GetContainerEmptySlot(bagID)
            if slotID then
                return bagID, slotID
            end
        end
    elseif name == 'Bank' then
        local slotID = INVENTORY:GetContainerEmptySlot(-1)
        if slotID then
            return -1, slotID
        end
        for bagID = 6, 12 do
            local slotID = INVENTORY:GetContainerEmptySlot(bagID)
            if slotID then
                return bagID, slotID
            end
        end
    elseif name == 'Reagent' then
        local slotID = INVENTORY:GetContainerEmptySlot(-3)
        if slotID then
            return -3, slotID
        end
    elseif name == 'BagReagent' then
        local slotID = INVENTORY:GetContainerEmptySlot(5)
        if slotID then
            return 5, slotID
        end
    end
end

function INVENTORY:FreeSlotOnDrop()
    local bagID, slotID = INVENTORY:GetEmptySlot(self.__name)
    if slotID then
        C_Container.PickupContainerItem(bagID, slotID)
    end
end

local freeSlotContainer = {
    ['Bag'] = true,
    ['Bank'] = true,
    ['Reagent'] = true,
    ['BagReagent'] = true,
}

function INVENTORY:CreateFreeSlots()
    local name = self.name
    if not freeSlotContainer[name] then
        return
    end

    local slot = CreateFrame('Button', name .. 'FreeSlot', self, 'BackdropTemplate')
    slot:SetSize(self.iconSize, self.iconSize)
    slot:SetHighlightTexture(C.Assets.Textures.Backdrop)
    slot:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.25)
    slot:GetHighlightTexture():SetInside()
    F.CreateBD(slot, 0.25)
    slot:SetBackdropColor(0, 0, 0, 0.25)

    slot:SetScript('OnMouseUp', INVENTORY.FreeSlotOnDrop)
    slot:SetScript('OnReceiveDrag', INVENTORY.FreeSlotOnDrop)
    F.AddTooltip(slot, 'ANCHOR_RIGHT', L['Free slots'])
    slot.__name = name

    local tag = self:SpawnPlugin('TagDisplay', '[space]', slot)
    local outline = _G.ANDROMEDA_ADB.FontOutline
    F.SetFS(tag, C.Assets.Fonts.Bold, 11, outline or nil, '', 'CLASS', outline and 'NONE' or 'THICK')
    tag:SetPoint('BOTTOMRIGHT', -2, 2)
    tag.__name = name
    slot.tag = tag

    self.freeSlot = slot
end

local toggleButtons = {}
function INVENTORY:SelectToggleButton(id)
    for index, button in pairs(toggleButtons) do
        if index ~= id then
            button.__turnOff()
        end
    end
end

local favouriteEnable

function INVENTORY.GetCustomGroupTitle(index)
    return C.DB['Inventory']['CustomNamesList'][index] or (_G.PREFERENCES .. ' ' .. index)
end

function INVENTORY:RenameCustomGroup(index)
    INVENTORY.selectGroupIndex = index
    StaticPopup_Show('ANDROMEDA_INVENTORY_RENAME_CUSTOM_GROUP')
end

function INVENTORY:MoveItemToCustomBag(index)
    local itemID = INVENTORY.selectItemID
    if index == 0 then
        if C.DB['Inventory']['CustomItemsList'][itemID] then
            C.DB['Inventory']['CustomItemsList'][itemID] = nil
        end
    else
        C.DB['Inventory']['CustomItemsList'][itemID] = index
    end
    INVENTORY:UpdateAllBags()
end

function INVENTORY:IsItemInCustomBag()
    local index = self.arg1
    local itemID = INVENTORY.selectItemID
    return (index == 0 and not C.DB['Inventory']['CustomItemsList'][itemID]) or (C.DB['Inventory']['CustomItemsList'][itemID] == index)
end

local menuList = {
    {
        text = '',
        icon = 134400,
        isTitle = true,
        notCheckable = true,
        tCoordLeft = 0.08,
        tCoordRight = 0.92,
        tCoordTop = 0.08,
        tCoordBottom = 0.92,
    },
    {
        text = _G.NONE,
        arg1 = 0,
        func = INVENTORY.MoveItemToCustomBag,
        checked = INVENTORY.IsItemInCustomBag,
    },
}

function INVENTORY:CreateFavouriteButton()
    for i = 1, 5 do
        tinsert(menuList, {
            text = INVENTORY.GetCustomGroupTitle(i),
            arg1 = i,
            func = INVENTORY.MoveItemToCustomBag,
            checked = INVENTORY.IsItemInCustomBag,
            hasArrow = true,
            menuList = { { text = _G.BATTLE_PET_RENAME, arg1 = i, func = INVENTORY.RenameCustomGroup } },
        })
    end
    INVENTORY.CustomMenu = menuList

    local enabledText = L["You can now star items.|nIf 'Item Filter' enabled, the item you starred will add to Preferences filter slots.|nThis is not available to junk."]

    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagFavourite)
    bu.Icon:SetVertexColor(unpack(iconColor))

    bu.__turnOff = function()
        bu.Icon:SetVertexColor(unpack(iconColor))
        bu.text = nil
        favouriteEnable = nil
    end

    bu:SetScript('OnClick', function(self)
        INVENTORY:SelectToggleButton(2)
        favouriteEnable = not favouriteEnable
        if favouriteEnable then
            self.Icon:SetVertexColor(C.r, C.g, C.b)
            self.text = enabledText
        else
            self.__turnOff()
        end
        self:GetScript('OnEnter')(self)
    end)

    bu:SetScript('OnHide', bu.__turnOff)
    bu.tipHeader = L['Mark Favourite']
    F.AddTooltip(bu, 'ANCHOR_TOP', bu.text, 'BLUE')

    toggleButtons[2] = bu

    return bu
end

local function favouriteOnClick(self)
    if not favouriteEnable then
        return
    end

    local info = C_Container.GetContainerItemInfo(self.bagId, self.slotId)
    local texture = info and info.iconFileID
    local quality = info and info.quality
    local link = info and info.hyperlink
    local itemID = info and info.itemID

    if texture and quality > Enum.ItemQuality.Poor then
        ClearCursor()
        INVENTORY.selectItemID = itemID
        INVENTORY.CustomMenu[1].text = link
        INVENTORY.CustomMenu[1].icon = texture
        EasyMenu(INVENTORY.CustomMenu, F.EasyMenu, self, 0, 0, 'MENU')
    end
end

local customJunkEnable
function INVENTORY:CreateCustomJunkButton()
    local enabledText =
        L["Click to tag item as junk.|nIf 'Auto sell junk' enabled, these items would be sold as well.|nThe list is saved account-wide, and won't be in the export data.|nYou can hold CTRL + ALT and click to wipe the custom junk list."]

    local bu = F.CreateButton(self, 16, 16, true, iconsList.BagJunk)
    bu.Icon:SetVertexColor(unpack(iconColor))
    bu.__turnOff = function()
        bu.Icon:SetVertexColor(unpack(iconColor))
        bu.text = nil
        customJunkEnable = nil
    end
    bu:SetScript('OnClick', function(self)
        if IsAltKeyDown() and IsControlKeyDown() then
            _G.StaticPopup_Show('ANDROMEDA_INVENTORY_RESET_JUNK_LIST')
            return
        end

        INVENTORY:SelectToggleButton(3)
        customJunkEnable = not customJunkEnable
        if customJunkEnable then
            self.Icon:SetVertexColor(C.r, C.g, C.b)
            self.text = enabledText
        else
            bu.__turnOff()
        end
        INVENTORY:UpdateAllBags()
        self:GetScript('OnEnter')(self)
    end)

    bu:SetScript('OnHide', bu.__turnOff)
    bu.tipHeader = L['Mark Junk']
    F.AddTooltip(bu, 'ANCHOR_TOP', bu.text, 'BLUE')

    toggleButtons[3] = bu

    return bu
end

local function customJunkOnClick(self)
    if not customJunkEnable then
        return
    end

    local info = C_Container.GetContainerItemInfo(self.bagId, self.slotId)
    local texture = info and info.iconFileID
    local itemID = info and info.itemID

    local price = select(11, GetItemInfo(itemID))
    if texture and price > 0 then
        if _G.ANDROMEDA_ADB['CustomJunkList'][itemID] then
            _G.ANDROMEDA_ADB['CustomJunkList'][itemID] = nil
        else
            _G.ANDROMEDA_ADB['CustomJunkList'][itemID] = true
        end
        ClearCursor()
        INVENTORY:UpdateAllBags()
    end
end

function INVENTORY:ButtonOnClick(btn)
    if btn ~= 'LeftButton' then
        return
    end

    favouriteOnClick(self)
    customJunkOnClick(self)
end

function INVENTORY:UpdateAllBags()
    if self.Bags and self.Bags:IsShown() then
        self.Bags:BAG_UPDATE()
    end
end

function INVENTORY:OpenBags()
    _G.OpenAllBags(true)
end

function INVENTORY:CloseBags()
    _G.CloseAllBags()
end

function INVENTORY:OnLogin()
    if not C.DB.Inventory.Enable then
        return
    end

    INVENTORY:AutoSellJunk()
    INVENTORY:AutoRepair()

    local iconSize = C.DB.Inventory.SlotSize
    local showNewItem = C.DB.Inventory.NewItemFlash
    local hasCanIMogIt = IsAddOnLoaded('CanIMogIt')
    local hasPawn = IsAddOnLoaded('Pawn')

    local Backpack = cargBags:NewImplementation(C.ADDON_TITLE .. 'Backpack')
    Backpack:RegisterBlizzard()
    Backpack:HookScript('OnShow', function()
        PlaySound(_G.SOUNDKIT.IG_BACKPACK_OPEN)
    end)
    Backpack:HookScript('OnHide', function()
        PlaySound(_G.SOUNDKIT.IG_BACKPACK_CLOSE)
    end)

    INVENTORY.Bags = Backpack
    INVENTORY.BagsType = {}
    INVENTORY.BagsType[0] = 0 -- backpack
    INVENTORY.BagsType[-1] = 0 -- bank
    INVENTORY.BagsType[-3] = 0 -- reagent

    local f = {}
    local filters = INVENTORY:GetFilters()
    local MyContainer = Backpack:GetContainerClass()
    INVENTORY.ContainerGroups = { ['Bag'] = {}, ['Bank'] = {} }

    local function AddNewContainer(bagType, index, name, filter)
        local newContainer = MyContainer:New(name, { BagType = bagType, Index = index })
        newContainer:SetFilter(filter, true)
        INVENTORY.ContainerGroups[bagType][index] = newContainer
    end

    function Backpack:OnInit()
        for i = 1, 5 do
            AddNewContainer('Bag', i, 'BagCustom' .. i, filters['bagCustom' .. i])
        end
        AddNewContainer('Bag', 6, 'BagReagent', filters.onlyBagReagent)
        AddNewContainer('Bag', 17, 'Junk', filters.bagsJunk)
        AddNewContainer('Bag', 9, 'EquipSet', filters.bagEquipSet)
        AddNewContainer('Bag', 7, 'AzeriteItem', filters.bagAzeriteItem)
        AddNewContainer('Bag', 8, 'Equipment', filters.bagEquipment)
        AddNewContainer('Bag', 10, 'BagCollection', filters.bagCollection)
        AddNewContainer('Bag', 15, 'Consumable', filters.bagConsumable)
        AddNewContainer('Bag', 11, 'BagGoods', filters.bagGoods)
        AddNewContainer('Bag', 16, 'BagQuest', filters.bagQuest)
        AddNewContainer('Bag', 12, 'BagAnima', filters.bagAnima)
        AddNewContainer('Bag', 13, 'BagRelic', filters.bagRelic)
        AddNewContainer('Bag', 14, 'BagStone', filters.bagStone)

        f.main = MyContainer:New('Bag', { Bags = 'bags', BagType = 'Bag' })
        f.main.__anchor = { 'BOTTOMRIGHT', -C.UI_GAP, C.UI_GAP }
        f.main:SetPoint(unpack(f.main.__anchor))
        f.main:SetFilter(filters.onlyBags, true)

        for i = 1, 5 do
            AddNewContainer('Bank', i, 'BankCustom' .. i, filters['bankCustom' .. i])
        end
        AddNewContainer('Bank', 8, 'BankEquipSet', filters.bankEquipSet)
        AddNewContainer('Bank', 6, 'BankAzeriteItem', filters.bankAzeriteItem)
        AddNewContainer('Bank', 9, 'BankLegendary', filters.bankLegendary)
        AddNewContainer('Bank', 7, 'BankEquipment', filters.bankEquipment)
        AddNewContainer('Bank', 10, 'BankCollection', filters.bankCollection)
        AddNewContainer('Bank', 13, 'BankConsumable', filters.bankConsumable)
        AddNewContainer('Bank', 11, 'BankGoods', filters.bankGoods)
        AddNewContainer('Bank', 14, 'BankQuest', filters.bankQuest)
        AddNewContainer('Bank', 12, 'BankAnima', filters.bankAnima)

        f.bank = MyContainer:New('Bank', { Bags = 'bank', BagType = 'Bank' })
        f.bank.__anchor = { 'BOTTOMLEFT', C.UI_GAP, C.UI_GAP }
        f.bank:SetPoint(unpack(f.bank.__anchor))
        f.bank:SetFilter(filters.onlyBank, true)
        f.bank:Hide()

        f.reagent = MyContainer:New('Reagent', { Bags = 'bankreagent', BagType = 'Bank' })
        f.reagent:SetFilter(filters.onlyReagent, true)
        f.reagent.__anchor = { 'BOTTOMLEFT', f.bank }
        f.reagent:SetPoint(unpack(f.reagent.__anchor))
        f.reagent:Hide()

        for bagType, groups in pairs(INVENTORY.ContainerGroups) do
            for _, container in ipairs(groups) do
                local parent = Backpack.contByName[bagType]
                container:SetParent(parent)
                F.CreateMF(container, parent, true)
            end
        end
    end

    local initBagType
    function Backpack:OnBankOpened()
        _G.BankFrame:Show()
        self:GetContainer('Bank'):Show()

        if not initBagType then
            INVENTORY:UpdateAllBags()
            INVENTORY:UpdateBagSize()
            initBagType = true
        end
    end

    function Backpack:OnBankClosed()
        _G.BankFrame.selectedTab = 1
        _G.BankFrame:Hide()
        self:GetContainer('Bank'):Hide()
        self:GetContainer('Reagent'):Hide()
        _G.ReagentBankFrame:Hide()
    end

    local MyButton = Backpack:GetItemButtonClass()
    MyButton:Scaffold('Default')

    function MyButton:OnCreate()
        self:SetNormalTexture(0)
        self:SetPushedTexture(0)
        self:SetHighlightTexture(C.Assets.Textures.Backdrop)
        self:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.25)
        self:GetHighlightTexture():SetInside()
        self:SetSize(iconSize, iconSize)

        self.Icon:SetInside()
        self.Icon:SetTexCoord(unpack(C.TEX_COORD))
        local outline = _G.ANDROMEDA_ADB.FontOutline
        F.SetFS(self.Count, C.Assets.Fonts.Bold, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'BOTTOMRIGHT', -2, 2)
        self.Cooldown:SetInside()
        self.IconOverlay:SetInside()
        self.IconOverlay2:SetInside()

        F.CreateBD(self, 0.25)
        self:SetBackdropColor(0, 0, 0, 0.25)

        local parentFrame = CreateFrame('Frame', nil, self)
        parentFrame:SetAllPoints()
        parentFrame:SetFrameLevel(5)

        self.Favourite = parentFrame:CreateTexture(nil, 'ARTWORK')
        self.Favourite:SetTexture('')
        self.Favourite:SetSize(16, 16)
        self.Favourite:SetPoint('TOPLEFT')

        self.Quest = parentFrame:CreateTexture(nil, 'ARTWORK')
        self.Quest:SetTexture('Interface\\Buttons\\AdventureGuideMicrobuttonAlert')
        self.Quest:SetSize(24, 24)
        self.Quest:SetPoint('TOPLEFT', -2, -2)

        self.iLvl = F.CreateFS(self, C.Assets.Fonts.Bold, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'BOTTOMRIGHT', -2, 2)
        self.BindType = F.CreateFS(self, C.Assets.Fonts.Condensed, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK', 'TOPLEFT', 2, -2)

        -- self:HookScript('OnHide', function()
        --     if anim:IsPlaying() then
        --         anim:Stop()
        --     end
        -- end)
        self.ShowNewItems = showNewItem
        if showNewItem then
			self.glowFrame = F.CreateGlowFrame(self, iconSize)
		end

        self:HookScript('OnClick', INVENTORY.ButtonOnClick)

        if hasCanIMogIt then
            self.canIMogIt = parentFrame:CreateTexture(nil, 'OVERLAY')
            self.canIMogIt:SetSize(13, 13)
            self.canIMogIt:SetPoint(unpack(_G.CanIMogIt.ICON_LOCATIONS[_G.CanIMogItOptions['iconLocation']]))
        end

        if not self.ProfessionQualityOverlay then
            self.ProfessionQualityOverlay = self:CreateTexture(nil, 'OVERLAY')
            self.ProfessionQualityOverlay:SetPoint('TOPLEFT', -3, 2)
        end
    end

    function MyButton:ItemOnEnter()
        if self.glowFrame then
            LBG.HideOverlayGlow(self.glowFrame)
        end
    end

    local function isItemNeedsLevel(item)
        return item.link and item.quality > 1 and (INVENTORY:IsItemHasLevel(item) or item.classID == Enum.ItemClass.Gem)
    end

    local function isItemExist(item)
        return item.link
    end

    local function GetIconOverlayAtlas(item)
        if not item.link then
            return
        end

        if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(item.link) then
            return 'AzeriteIconFrame'
        elseif IsCosmeticItem(item.link) then
            return 'CosmeticIconFrame'
        elseif C_Soulbinds.IsItemConduitByItemInfo(item.link) then
            return 'ConduitIconFrame', 'ConduitIconFrame-Corners'
        end
    end

    local function UpdateCanIMogIt(self, item)
        if not self.canIMogIt then
            return
        end

        local text, unmodifiedText = _G.CanIMogIt:GetTooltipText(nil, item.bagId, item.slotId)
        if text and text ~= '' then
            local icon = _G.CanIMogIt.tooltipOverlayIcons[unmodifiedText]
            self.canIMogIt:SetTexture(icon)
            self.canIMogIt:Show()
        else
            self.canIMogIt:Hide()
        end
    end

    local function UpdatePawnArrow(self, item)
        if not hasPawn then
            return
        end
        if not _G.PawnIsContainerItemAnUpgrade then
            return
        end
        if self.UpgradeIcon then
            self.UpgradeIcon:SetShown(_G.PawnIsContainerItemAnUpgrade(item.bagId, item.slotId))
        end
    end

    function MyButton:OnUpdateButton(item)
        if self.JunkIcon then
            if (_G.MerchantFrame:IsShown() or customJunkEnable) and (item.quality == Enum.ItemQuality.Poor or _G.ANDROMEDA_ADB['CustomJunkList'][item.id]) and item.hasPrice then
                self.JunkIcon:Show()
            else
                self.JunkIcon:Hide()
            end
        end

        self.IconOverlay:SetVertexColor(1, 1, 1)
        self.IconOverlay:Hide()
        self.IconOverlay2:Hide()

        local atlas, secondAtlas = GetIconOverlayAtlas(item)
        if atlas then
            self.IconOverlay:SetAtlas(atlas)
            self.IconOverlay:Show()

            if secondAtlas then
                local color = C.QualityColors[item.quality or 1]
                self.IconOverlay:SetVertexColor(color.r, color.g, color.b)
                self.IconOverlay2:SetAtlas(secondAtlas)
                self.IconOverlay2:Show()
            end
        end

        if self.ProfessionQualityOverlay then
            self.ProfessionQualityOverlay:SetAtlas(nil)
            SetItemCraftingQualityOverlay(self, item.link)
        end

        if C.DB['Inventory']['CustomItemsList'][item.id] and not C.DB.Inventory.ItemFilter then
            self.Favourite:Show()
        else
            self.Favourite:Hide()
        end

        if self.ShowNewItems then
            if C_NewItems.IsNewItem(item.bagId, item.slotId) then
                LBG.ShowOverlayGlow(self.glowFrame)
            else
                LBG.HideOverlayGlow(self.glowFrame)
            end
        end

        self.iLvl:SetText('')
        if C.DB.Inventory.ItemLevel then
            local level = item.level -- ilvl for keystone and battlepet

            if not level and isItemNeedsLevel(item) then
                local ilvl = F.GetItemLevel(item.link, item.bagId ~= -1 and item.bagId, item.slotId) -- SetBagItem return nil for default bank slots
                if ilvl then
                    level = ilvl
                end
            end

            if level then
                local color = C.QualityColors[item.quality]
                self.iLvl:SetText(level)
                self.iLvl:SetTextColor(color.r, color.g, color.b)
            end
        end

        if C.DB.Inventory.SpecialBagsColor then
            local bagType = INVENTORY.BagsType[item.bagId]
            local color = bagTypeColor[bagType] or bagTypeColor[0]
            self:SetBackdropColor(unpack(color))
        else
            self:SetBackdropColor(0, 0, 0, 0.25)
        end

        if C.DB.Inventory.BindType and isItemExist(item) then
            local itemLink = C_Container.GetContainerItemLink(item.bagId, item.slotId)
            if not itemLink then
                return
            end

            local _, _, itemRarity, _, _, _, _, _, _, _, _, _, _, bindType = GetItemInfo(itemLink)
            if F.IsBoA(item.bagId, item.slotId) or itemRarity == 7 or itemRarity == 8 then
                self.BindType:SetText('|cff00ccffBOA|r')
            elseif not F.IsSoulBound(item.bagId, item.slotId) and bindType == 2 then
                self.BindType:SetText('|cff1eff00BOE|r')
            else
                self.BindType:SetText('')
            end
        else
            self.BindType:SetText('')
        end

        -- Hide empty tooltip
        if not item.texture and _G.GameTooltip:GetOwner() == self then
            _G.GameTooltip:Hide()
        end

        -- Support CanIMogIt
        UpdateCanIMogIt(self, item)

        -- Support Pawn
        UpdatePawnArrow(self, item)
    end

    function MyButton:OnUpdateQuest(item)
        if item.questID and not item.questActive then
            self.Quest:Show()
        else
            self.Quest:Hide()
        end

        if item.questID or item.isQuestItem then
            self:SetBackdropBorderColor(0.8, 0.8, 0, 1)
        elseif item.quality and item.quality > -1 then
            local color = C.QualityColors[item.quality]
            self:SetBackdropBorderColor(color.r, color.g, color.b, 1)
        else
            self:SetBackdropBorderColor(0, 0, 0, 0.2)
        end
    end

    function INVENTORY:UpdateAllAnchors()
        INVENTORY:UpdateBagsAnchor(f.main, INVENTORY.ContainerGroups['Bag'])
        INVENTORY:UpdateBankAnchor(f.bank, INVENTORY.ContainerGroups['Bank'])
    end

    function INVENTORY:GetContainerColumns(bagType)
        if bagType == 'Bag' then
            return C.DB['Inventory']['BagColumns']
        elseif bagType == 'Bank' then
            return C.DB['Inventory']['BankColumns']
        end
    end

    function MyContainer:OnContentsChanged(gridOnly)
        self:SortButtons('bagSlot')

        local columns = INVENTORY:GetContainerColumns(self.Settings.BagType)
        local offset = C.DB.Inventory.Offset
        local spacing = C.DB.Inventory.Spacing
        local xOffset = 5
        local yOffset = -offset + xOffset
        local _, height = self:LayoutButtons('grid', columns, spacing, xOffset, yOffset)
        local width = columns * (iconSize + spacing) - spacing
        if self.freeSlot then
            if C.DB.Inventory.CombineFreeSlots then
                local numSlots = #self.buttons + 1
                local row = ceil(numSlots / columns)
                local col = numSlots % columns
                if col == 0 then
                    col = columns
                end
                local xPos = (col - 1) * (iconSize + spacing)
                local yPos = -1 * (row - 1) * (iconSize + spacing)

                self.freeSlot:ClearAllPoints()
                self.freeSlot:SetPoint('TOPLEFT', self, 'TOPLEFT', xPos + xOffset, yPos + yOffset)
                self.freeSlot:Show()

                if height < 0 then
                    height = iconSize
                elseif col == 1 then
                    height = height + iconSize + spacing
                end
            else
                self.freeSlot:Hide()
            end
        end
        self:SetSize(width + xOffset * 2, height + offset)

        if not gridOnly then
            INVENTORY:UpdateAllAnchors()
        end
    end

    function MyContainer:OnCreate(name, settings)
        self.Settings = settings
        self:SetFrameStrata('HIGH')
        self:SetClampedToScreen(true)
        F.SetBD(self)
        if settings.Bags then
            F.CreateMF(self, nil, true)
        end

        self.iconSize = iconSize
        INVENTORY.CreateFreeSlots(self)

        local label
        if strmatch(name, 'AzeriteItem$') then
            label = L['Azerite armor']
        elseif strmatch(name, 'Equipment$') then
            label = _G.BAG_FILTER_EQUIPMENT
        elseif strmatch(name, 'EquipSet$') then
            label = L['Equipement Set']
        elseif name == 'BankLegendary' then
            label = _G.LOOT_JOURNAL_LEGENDARIES
        elseif strmatch(name, 'Consumable$') then
            label = _G.BAG_FILTER_CONSUMABLES
        elseif name == 'Junk' then
            label = _G.BAG_FILTER_JUNK
        elseif strmatch(name, 'Collection') then
            label = _G.COLLECTIONS
        elseif strmatch(name, 'Goods') then
            label = _G.AUCTION_CATEGORY_TRADE_GOODS
        elseif strmatch(name, 'Quest') then
            label = _G.QUESTS_LABEL
        elseif strmatch(name, 'Anima') then
            label = _G.POWER_TYPE_ANIMA
        elseif name == 'BagRelic' then
            label = L['Korthia Relics']
        elseif strmatch(name, 'Custom%d') then
            label = INVENTORY.GetCustomGroupTitle(settings.Index)
        elseif name == 'BagReagent' then
            label = L['Reagent Bag']
        elseif name == 'BagStone' then
            label = GetSpellInfo(404861)
        end

        local outline = _G.ANDROMEDA_ADB.FontOutline
        if label then
            self.label = F.CreateFS(self, C.Assets.Fonts.Bold, 11, outline or nil, label, nil, outline and 'NONE' or 'THICK', 'TOPLEFT', 5, -4)
            return
        end

        INVENTORY.CreateMoneyFrame(self)

        local buttons = {}
        buttons[1] = INVENTORY.CreateRestoreButton(self, f)
        buttons[2] = INVENTORY.CreateSortButton(self, name)
        if name == 'Bag' then
            INVENTORY.CreateBagBar(self, settings, 5)
            buttons[3] = INVENTORY.CreateBagToggle(self)
            buttons[4] = INVENTORY.CreateRepairButton(self)
            buttons[5] = INVENTORY.CreateSellButton(self)
            buttons[6] = INVENTORY.CreateFavouriteButton(self)
            buttons[7] = INVENTORY.CreateCustomJunkButton(self)
            buttons[8] = INVENTORY.CreateSearchButton(self)
        elseif name == 'Bank' then
            INVENTORY.CreateBagBar(self, settings, 7)
            buttons[3] = INVENTORY.CreateBagToggle(self)
            buttons[4] = INVENTORY.CreateReagentButton(self, f)
        elseif name == 'Reagent' then
            buttons[3] = INVENTORY.CreateDepositButton(self)
            buttons[4] = INVENTORY.CreateBankButton(self, f)
        end

        for i = 1, #buttons do
            local bu = buttons[i]
            if not bu then
                break
            end
            if i == 1 then
                bu:SetPoint('TOPRIGHT', -5, -2)
            else
                bu:SetPoint('RIGHT', buttons[i - 1], 'LEFT', -3, 0)
            end
        end

        self.widgetButtons = buttons

        if name == 'Bag' then
            INVENTORY.CreateCollapseArrow(self)
        end

        self:HookScript('OnShow', F.RestoreMF)
    end

    local function updateBagSize(button)
        button:SetSize(iconSize, iconSize)
        -- button.glowFrame:SetSize(iconSize + 8, iconSize + 8)
        -- button.Count:SetFont()
        -- button.iLvl:SetFont()
    end

    function INVENTORY:UpdateBagSize()
        iconSize = C.DB['Inventory']['SlotSize']

        for _, container in pairs(Backpack.contByName) do
            container:ApplyToButtons(updateBagSize)
            if container.freeSlot then
                container.freeSlot:SetSize(iconSize, iconSize)
                -- container.freeSlot.tag:SetFont()
            end

            if container.BagBar then
                for _, bagButton in pairs(container.BagBar.buttons) do
                    bagButton:SetSize(iconSize, iconSize)
                end
                container.BagBar:UpdateAnchor()
            end

            container:OnContentsChanged(true)
        end
    end

    local BagButton = Backpack:GetClass('BagButton', true, 'BagButton')
    function BagButton:OnCreate()
        self:SetNormalTexture(0)
        self:SetPushedTexture(0)
        self:SetHighlightTexture(C.Assets.Textures.Backdrop)
        self:GetHighlightTexture():SetVertexColor(1, 1, 1, 0.25)
        self:GetHighlightTexture():SetInside()

        self:SetSize(iconSize, iconSize)
        F.CreateBD(self, 0.25)
        self.Icon:SetInside()
        self.Icon:SetTexCoord(unpack(C.TEX_COORD))
    end

    function BagButton:OnUpdateButton()
        self:SetBackdropBorderColor(0, 0, 0)

        local id = GetInventoryItemID('player', (self.GetInventorySlot and self:GetInventorySlot()) or self.invID)
        if not id then
            return
        end

        local _, _, quality, _, _, _, _, _, _, _, _, classID, subClassID = GetItemInfo(id)
        if not quality or quality == 1 then
            quality = 0
        end

        local color = C.QualityColors[quality]
        if not self.hidden and not self.notBought then
            self:SetBackdropBorderColor(color.r, color.g, color.b)
        end

        if classID == Enum.ItemClass.Container then
            INVENTORY.BagsType[self.bagId] = subClassID or 0
        else
            INVENTORY.BagsType[self.bagId] = 0
        end
    end

    -- Sort order
    C_Container.SetSortBagsRightToLeft(C.DB.Inventory.SortMode == 1)
    C_Container.SetInsertItemsLeftToRight(false)

    -- Init
    _G.ToggleAllBags()
    _G.ToggleAllBags()
    INVENTORY.initComplete = true

    F:RegisterEvent('TRADE_SHOW', INVENTORY.OpenBags)
    F:RegisterEvent('TRADE_CLOSED', INVENTORY.CloseBags)
    F:RegisterEvent('BANKFRAME_OPENED', INVENTORY.AutoDeposit)

    -- Fixes
    _G.BankFrame.GetRight = function()
        return f.bank:GetRight()
    end
    _G.BankFrameItemButton_Update = nop

    -- Get rid of blizz annoying tutorial
    local passedSystems = {
        ['TutorialReagentBag'] = true,
    }
    hooksecurefunc(_G.HelpTip, 'Show', function(self, _, info)
        if info and passedSystems[info.system] then
            self:HideAllSystem(info.system)
        end
    end)
    SetCVarBitfield('closedInfoFrames', _G.LE_FRAME_TUTORIAL_EQUIP_REAGENT_BAG, true)
    SetCVar('professionToolSlotsExampleShown', 1)
    SetCVar('professionAccessorySlotsExampleShown', 1)

    -- Shift key alert
    local function onUpdate(self, elapsed)
        if IsShiftKeyDown() then
            self.elapsed = (self.elapsed or 0) + elapsed
            if self.elapsed > 5 then
                _G.UIErrorsFrame:AddMessage(C.RED_COLOR .. L['Your SHIFT key may be stuck.'])
                self.elapsed = 0
            end
        end
    end
    local shiftUpdater = CreateFrame('Frame', nil, f.main)
    shiftUpdater:SetScript('OnUpdate', onUpdate)
end
