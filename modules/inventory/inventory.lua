local _G= _G
local pairs = pairs
local wipe = wipe
local ipairs = ipairs
local strmatch = string.match
local unpack = unpack
local ceil = math.ceil
local strfind = strfind
local CreateFrame = CreateFrame
local ToggleFrame = ToggleFrame
local EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC = EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC
local LE_ITEM_QUALITY_POOR = LE_ITEM_QUALITY_POOR
local LE_ITEM_QUALITY_RARE = LE_ITEM_QUALITY_RARE
local LE_ITEM_QUALITY_HEIRLOOM = LE_ITEM_QUALITY_HEIRLOOM
local LE_ITEM_CLASS_WEAPON = LE_ITEM_CLASS_WEAPON
local LE_ITEM_CLASS_ARMOR = LE_ITEM_CLASS_ARMOR
local LE_ITEM_CLASS_CONTAINER = LE_ITEM_CLASS_CONTAINER
local SortBankBags = SortBankBags
local SortReagentBankBags = SortReagentBankBags
local SortBags = SortBags
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemInfo = GetContainerItemInfo
local PickupContainerItem = PickupContainerItem
local C_NewItems_IsNewItem = C_NewItems.IsNewItem
local C_Timer_After = C_Timer.After
local C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID
local C_Soulbinds_IsItemConduitByItemInfo = C_Soulbinds.IsItemConduitByItemInfo
local IsCosmeticItem = IsCosmeticItem
local IsControlKeyDown  = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local DeleteCursorItem = DeleteCursorItem
local GetItemInfo = GetItemInfo
local GetContainerItemID = GetContainerItemID
local SplitContainerItem = SplitContainerItem
local GetInventoryItemID = GetInventoryItemID
local GetContainerItemLink = GetContainerItemLink
local ClearCursor = ClearCursor
local InCombatLockdown = InCombatLockdown
local PlaySound = PlaySound
local OpenAllBags = OpenAllBags
local CloseAllBags = CloseAllBags
local SetSortBagsRightToLeft = SetSortBagsRightToLeft
local SetInsertItemsLeftToRight = SetInsertItemsLeftToRight
local ToggleAllBags = ToggleAllBags
local IsAddOnLoaded = IsAddOnLoaded
local SOUNDKIT_IG_BACKPACK_OPEN = SOUNDKIT.IG_BACKPACK_OPEN
local SOUNDKIT_IG_BACKPACK_CLOSE = SOUNDKIT.IG_BACKPACK_CLOSE
local SOUNDKIT_IG_MINIMAP_OPEN = SOUNDKIT.IG_MINIMAP_OPEN
local SOUNDKIT_IG_CHARACTER_INFO_TAB = SOUNDKIT.IG_CHARACTER_INFO_TAB
local IsReagentBankUnlocked = IsReagentBankUnlocked
local StaticPopup_Show = StaticPopup_Show
local DepositReagentBank = DepositReagentBank
local REAGENT_BANK = REAGENT_BANK
local BANK = BANK
local REAGENTBANK_DEPOSIT = REAGENTBANK_DEPOSIT
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT
local VIDEO_OPTIONS_ENABLED = VIDEO_OPTIONS_ENABLED
local VIDEO_OPTIONS_DISABLED = VIDEO_OPTIONS_DISABLED
local ITEM_BNETACCOUNTBOUND = ITEM_BNETACCOUNTBOUND
local ITEM_SOULBOUND = ITEM_SOULBOUND
local ITEM_BIND_TO_BNETACCOUNT = ITEM_BIND_TO_BNETACCOUNT
local ITEM_ACCOUNTBOUND = ITEM_ACCOUNTBOUND
local BAG_FILTER_EQUIPMENT = BAG_FILTER_EQUIPMENT
local LOOT_JOURNAL_LEGENDARIES = LOOT_JOURNAL_LEGENDARIES
local BAG_FILTER_CONSUMABLES = BAG_FILTER_CONSUMABLES
local BAG_FILTER_JUNK = BAG_FILTER_JUNK
local COLLECTIONS = COLLECTIONS
local PREFERENCES = PREFERENCES
local AUCTION_CATEGORY_TRADE_GOODS = AUCTION_CATEGORY_TRADE_GOODS
local QUESTS_LABEL = QUESTS_LABEL

local F, C, L = unpack(select(2, ...))
local INVENTORY = F.INVENTORY
local cargBags = F.cargBags

local icons = {
    ['restore'] = C.AssetsPath .. 'inventory\\restore',
    ['toggle'] = C.AssetsPath .. 'inventory\\toggle',
    ['sort'] = C.AssetsPath .. 'inventory\\sort',
    ['reagen'] = C.AssetsPath .. 'inventory\\reagen',
    ['deposit'] = C.AssetsPath .. 'inventory\\deposit',
    ['delete'] = C.AssetsPath .. 'inventory\\delete',
    ['favourite'] = C.AssetsPath .. 'inventory\\favourite',
    ['split'] = C.AssetsPath .. 'inventory\\split',
    ['repair'] = C.AssetsPath .. 'inventory\\repair',
    ['sell'] = C.AssetsPath .. 'inventory\\sell',
    ['search'] = C.AssetsPath .. 'inventory\\search',
    ['junk'] = C.AssetsPath .. 'inventory\\junk'
}

local function CheckBoundStatus(itemLink, bagID, slotID, string)
    local tip = F.ScanTip
    tip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
    if bagID and type(bagID) == 'string' then
        tip:SetInventoryItem(bagID, slotID)
    elseif bagID and type(bagID) == 'number' then
        tip:SetBagItem(bagID, slotID)
    else
        tip:SetHyperlink(itemLink)
    end

    for i = 2, 5 do
        local line = _G[tip:GetName() .. 'TextLeft' .. i]
        if line then
            local text = line:GetText() or ''
            local found = strfind(text, string)
            if found then
                return true
            end
        end
    end

    return false
end

local sortCache = {}

function INVENTORY:ReverseSort()
    for bag = 0, 4 do
        local numSlots = GetContainerNumSlots(bag)
        for slot = 1, numSlots do
            local texture, _, locked = GetContainerItemInfo(bag, slot)
            if (slot <= numSlots / 2) and texture and not locked and
                not sortCache['b' .. bag .. 's' .. slot] then
                PickupContainerItem(bag, slot)
                PickupContainerItem(bag, numSlots + 1 - slot)
                sortCache['b' .. bag .. 's' .. slot] = true
            end
        end
    end

    INVENTORY.Bags.isSorting = false
    INVENTORY:UpdateAllBags()
end

function INVENTORY:UpdateAnchors(parent, bags)
    if not parent:IsShown() then
        return
    end

    local anchor = parent
    for _, bag in ipairs(bags) do
        if bag:GetHeight() > 45 then
            bag:Show()
        else
            bag:Hide()
        end
        if bag:IsShown() then
            bag:SetPoint('BOTTOMLEFT', anchor, 'TOPLEFT', 0, 5)
            anchor = bag
        end
    end
end

local function highlightFunction(button, match)
    button:SetAlpha(match and 1 or .3)
end

function INVENTORY:CreateCurrencyFrame()
    local currencyFrame = CreateFrame('Button', nil, self)
    currencyFrame:SetPoint('TOPLEFT', 6, 0)
    currencyFrame:SetSize(140, 26)

    local tag = self:SpawnPlugin('TagDisplay', '[money]  [currencies]', currencyFrame)
    F:SetFS(tag, C.Assets.Fonts.Bold, 11, nil, '', nil, 'THICK')
    tag:SetPoint('TOPLEFT', 0, -3)
end

function INVENTORY:CreateBagBar(settings, columns)
    local bagBar = self:SpawnPlugin('BagBar', settings.Bags)
    local width, height = bagBar:LayoutButtons('grid', columns, 5, 5, -5)
    bagBar:SetSize(width + 10, height + 10)
    bagBar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -5)
    F.SetBD(bagBar)
    bagBar.highlightFunction = highlightFunction
    bagBar.isGlobal = true
    bagBar:Hide()

    self.BagBar = bagBar
end

function INVENTORY:CreateRestoreButton(f)
    local bu = F.CreateButton(self, 16, 16, true, icons.restore)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:SetScript('OnClick', function()
        C.DB['ui_anchor_temp'][f.main:GetName()] = nil
        C.DB['ui_anchor_temp'][f.bank:GetName()] = nil
        C.DB['ui_anchor_temp'][f.reagent:GetName()] = nil
        f.main:ClearAllPoints()
        f.main:SetPoint('BOTTOMRIGHT', -C.UIGap, C.UIGap)
        f.bank:ClearAllPoints()
        f.bank:SetPoint('BOTTOMRIGHT', f.main, 'BOTTOMLEFT', -10, 0)
        f.reagent:ClearAllPoints()
        f.reagent:SetPoint('BOTTOMLEFT', f.bank)
        PlaySound(SOUNDKIT_IG_MINIMAP_OPEN)
    end)
    bu.title = L['INVENTORY_ANCHOR_RESET']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

function INVENTORY:CreateReagentButton(f)
    local bu = F.CreateButton(self, 16, 16, true, icons.reagen)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:RegisterForClicks('AnyUp')
    bu:SetScript('OnClick', function(_, btn)
        if not IsReagentBankUnlocked() then
            StaticPopup_Show('CONFIRM_BUY_REAGENTBANK_TAB')
        else
            PlaySound(SOUNDKIT_IG_CHARACTER_INFO_TAB)
            _G.ReagentBankFrame:Show()
            _G.BankFrame.selectedTab = 2
            f.reagent:Show()
            f.bank:Hide()
            if btn == 'RightButton' then
                DepositReagentBank()
            end
        end
    end)
    bu.title = REAGENT_BANK
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

function INVENTORY:CreateBankButton(f)
    local bu = F.CreateButton(self, 16, 16, true, icons.reagen)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:SetScript('OnClick', function()
        PlaySound(SOUNDKIT_IG_CHARACTER_INFO_TAB)
        _G.ReagentBankFrame:Hide()
        _G.BankFrame.selectedTab = 1
        f.reagent:Hide()
        f.bank:Show()
    end)
    bu.title = BANK
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

local function updateDepositButtonStatus(bu)
    if C.DB.inventory.auto_deposit then
        bu.Icon:SetVertexColor(C.r, C.g, C.b, 1)
    else
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
    end
end

function INVENTORY:AutoDeposit()
    if C.DB.inventory.auto_deposit then
        DepositReagentBank()
    end
end

function INVENTORY:CreateDepositButton()
    local bu = F.CreateButton(self, 16, 16, true, icons.deposit)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:RegisterForClicks('AnyUp')
    bu:SetScript('OnClick', function(_, btn)
        if btn == 'RightButton' then
            C.DB.inventory.auto_deposit = not C.DB.inventory.auto_deposit
            updateDepositButtonStatus(bu)
        else
            DepositReagentBank()
        end
    end)
    bu.title = REAGENTBANK_DEPOSIT
    F.AddTooltip(bu, 'ANCHOR_TOP', L['INVENTORY_AUTO_DEPOSIT'], 'BLUE')
    updateDepositButtonStatus(bu)
    return bu
end

function INVENTORY:CreateBagToggle()
    local bu = F.CreateButton(self, 16, 16, true, icons.toggle)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:SetScript('OnClick', function()
        ToggleFrame(self.BagBar)
        if self.BagBar:IsShown() then
            bu.Icon:SetVertexColor(C.r, C.g, C.b, 1)
            PlaySound(SOUNDKIT_IG_BACKPACK_OPEN)
        else
            bu.Icon:SetVertexColor(.5, .5, .5, 1)
            PlaySound(SOUNDKIT_IG_BACKPACK_CLOSE)
        end
    end)

    bu.title = L['INVENTORY_BAGS']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

function INVENTORY:CreateSortButton(name)
    local bu = F.CreateButton(self, 16, 16, true, icons.sort)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:SetScript('OnClick', function()
        if C.DB.inventory.sort_mode == 3 then
            _G.UIErrorsFrame:AddMessage(C.InfoColor .. L['INVENTORY_SORT_DISABLED'])
            return
        end

        if name == 'Bank' then
            SortBankBags()
        elseif name == 'Reagent' then
            SortReagentBankBags()
        else
            if C.DB.inventory.sort_mode == 1 then
                SortBags()
            elseif C.DB.inventory.sort_mode == 2 then
                if InCombatLockdown() then
                    _G.UIErrorsFrame:AddMessage(C.InfoColor .. ERR_NOT_IN_COMBAT)
                else
                    SortBags()
                    wipe(sortCache)
                    INVENTORY.Bags.isSorting = true
                    C_Timer_After(.5, INVENTORY.ReverseSort)
                end
            end
        end
    end)
    bu.title = L['INVENTORY_SORT']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    return bu
end

local function updateRepairButtonStatus(bu)
    if C.DB.inventory.auto_repair then
        bu.Icon:SetVertexColor(C.r, C.g, C.b, 1)
        bu.text = L['INVENTORY_AUTO_REPAIR_TIP']
        bu.title = L['INVENTORY_AUTO_REPAIR'] .. ': ' .. C.GreenColor .. VIDEO_OPTIONS_ENABLED
    else
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
        bu.text = nil
        bu.title = L['INVENTORY_AUTO_REPAIR'] .. ': ' .. C.GreenColor .. VIDEO_OPTIONS_DISABLED
    end
end

function INVENTORY:CreateRepairButton()
    local bu = F.CreateButton(self, 16, 16, true, icons.repair)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:SetScript('OnClick', function(self)
        C.DB.inventory.auto_repair = not C.DB.inventory.auto_repair
        updateRepairButtonStatus(bu)
        self:GetScript('OnEnter')(self)
    end)

    bu.title = L['INVENTORY_AUTO_REPAIR']
    F.AddTooltip(bu, 'ANCHOR_TOP', L['INVENTORY_AUTO_REPAIR_TIP'], 'BLUE')
    updateRepairButtonStatus(bu)
    return bu
end

local function updateSellButtonStatus(bu)
    if C.DB.inventory.auto_sell_junk then
        bu.Icon:SetVertexColor(C.r, C.g, C.b, 1)
        bu.text = L['INVENTORY_SELL_JUNK_TIP']
        bu.title = L['INVENTORY_SELL_JUNK'] .. ': ' .. C.GreenColor .. VIDEO_OPTIONS_ENABLED
    else
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
        bu.text = nil
        bu.title = L['INVENTORY_SELL_JUNK'] .. ': ' .. C.GreenColor .. VIDEO_OPTIONS_DISABLED
    end
end

function INVENTORY:CreateSellButton()
    local bu = F.CreateButton(self, 16, 16, true, icons.sell)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu:SetScript('OnClick', function(self)
        C.DB.inventory.auto_sell_junk = not C.DB.inventory.auto_sell_junk
        updateSellButtonStatus(bu)
        self:GetScript('OnEnter')(self)
    end)

    bu.title = L['INVENTORY_SELL_JUNK']
    F.AddTooltip(bu, 'ANCHOR_TOP', L['INVENTORY_SELL_JUNK_TIP'], 'BLUE')
    updateSellButtonStatus(bu)
    return bu
end

function INVENTORY:CreateSearchButton()
    local bu = F.CreateButton(self, 16, 16, true, icons.search)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)

    bu.title = L['INVENTORY_SEARCH']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    local searchBar = self:SpawnPlugin('SearchBar', bu)
    searchBar.highlightFunction = highlightFunction
    searchBar.isGlobal = true
    searchBar:SetPoint('RIGHT', bu, 'RIGHT', -6, 0)
    searchBar:SetSize(80, 26)
    searchBar:DisableDrawLayer('BACKGROUND')
    F.AddTooltip(searchBar, 'ANCHOR_TOP', L['INVENTORY_SEARCH_ENABLED'], 'info')

    local bg = F.CreateBDFrame(searchBar, 0, true)
    bg:SetPoint('TOPLEFT', -5, -5)
    bg:SetPoint('BOTTOMRIGHT', 5, 5)

    searchBar:SetScript('OnShow', function()
        bu:SetSize(80, 26)
    end)

    searchBar:SetScript('OnHide', function()
        bu:SetSize(16, 16)
    end)

    return bu
end

function INVENTORY:GetContainerEmptySlot(bagID)
    for slotID = 1, GetContainerNumSlots(bagID) do
        if not GetContainerItemID(bagID, slotID) then
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
        for bagID = 5, 11 do
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
    end
end

function INVENTORY:FreeSlotOnDrop()
    local bagID, slotID = INVENTORY:GetEmptySlot(self.__name)
    if slotID then
        PickupContainerItem(bagID, slotID)
    end
end

local freeSlotContainer = {['Bag'] = true, ['Bank'] = true, ['Reagent'] = true}

function INVENTORY:CreateFreeSlots()
    local name = self.name
    if not freeSlotContainer[name] then
        return
    end

    local slot = CreateFrame('Button', name .. 'FreeSlot', self, 'BackdropTemplate')
    slot:SetSize(self.iconSize, self.iconSize)
    slot:SetHighlightTexture(C.Assets.bd_tex)
    slot:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
    slot:GetHighlightTexture():SetInside()
    F.CreateBD(slot, .25)
    slot:SetBackdropColor(0, 0, 0, .25)

    slot:SetScript('OnMouseUp', INVENTORY.FreeSlotOnDrop)
    slot:SetScript('OnReceiveDrag', INVENTORY.FreeSlotOnDrop)
    F.AddTooltip(slot, 'ANCHOR_RIGHT', L['INVENTORY_FREE_SLOTS'])
    slot.__name = name

    local tag = self:SpawnPlugin('TagDisplay', '[space]', slot)
    F:SetFS(tag, C.Assets.Fonts.Regular, 11, nil, '', 'CLASS', 'THICK')
    tag:SetPoint('BOTTOMRIGHT', -2, 2)
    tag.__name = name

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

local splitEnable
local function saveSplitCount(self)
    local count = self:GetText() or ''
    C.DB.inventory.split_count = tonumber(count) or 1
end

function INVENTORY:CreateSplitButton()
    local enabledText = C.BlueColor .. L['INVENTORY_SPLIT_MODE_ENABLED']

    local splitFrame = CreateFrame('Frame', nil, self)
    splitFrame:SetSize(100, 50)
    splitFrame:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
    F.CreateFS(splitFrame, C.Assets.Fonts.Regular, 12, nil, L['INVENTORY_SPLIT_COUNT'], 'YELLOW',
               'THICK', 'TOP', 1, -5)
    F.SetBD(splitFrame)
    splitFrame:Hide()
    local editbox = F.CreateEditBox(splitFrame, 90, 20)
    editbox:SetPoint('BOTTOMLEFT', 5, 5)
    editbox:SetJustifyH('CENTER')
    editbox:SetScript('OnTextChanged', saveSplitCount)

    local bu = F.CreateButton(self, 16, 16, true, icons.split)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu.__turnOff = function()
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
        bu.text = nil
        splitFrame:Hide()
        splitEnable = nil
    end
    bu:SetScript('OnClick', function(self)
        INVENTORY:SelectToggleButton(1)
        splitEnable = not splitEnable
        if splitEnable then
            bu.Icon:SetVertexColor(C.r, C.g, C.b, 1)
            self.text = enabledText
            splitFrame:Show()
            editbox:SetText(C.DB.inventory.split_count)
        else
            self.__turnOff()
        end
        self:GetScript('OnEnter')(self)
    end)
    bu:SetScript('OnHide', bu.__turnOff)
    bu.title = L['INVENTORY_QUICK_SPLIT']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    toggleButtons[1] = bu

    return bu
end

local function splitOnClick(self)
    if not splitEnable then
        return
    end

    PickupContainerItem(self.bagID, self.slotID)

    local texture, itemCount, locked = GetContainerItemInfo(self.bagID, self.slotID)
    if texture and not locked and itemCount and itemCount > C.DB.inventory.split_count then
        SplitContainerItem(self.bagID, self.slotID, C.DB.inventory.split_count)

        local bagID, slotID = INVENTORY:GetEmptySlot('Bag')
        if slotID then
            PickupContainerItem(bagID, slotID)
        end
    end
end

local favouriteEnable
function INVENTORY:CreateFavouriteButton()
    local enabledText = C.BlueColor .. L['INVENTORY_PICK_FAVOURITE_ENABLED']

    local bu = F.CreateButton(self, 16, 16, true, icons.favourite)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu.__turnOff = function()
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
        bu.text = nil
        favouriteEnable = nil
    end
    bu:SetScript('OnClick', function(self)
        INVENTORY:SelectToggleButton(2)
        favouriteEnable = not favouriteEnable
        if favouriteEnable then
            self.Icon:SetVertexColor(C.r, C.g, C.b, 1)
            self.text = enabledText
        else
            self.__turnOff()
        end
        self:GetScript('OnEnter')(self)
    end)

    bu:SetScript('OnHide', bu.__turnOff)
    bu.title = L['INVENTORY_PICK_FAVOURITE']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    toggleButtons[2] = bu

    return bu
end

local function favouriteOnClick(self)
    if not favouriteEnable then
        return
    end

    local texture, _, _, quality, _, _, _, _, _, itemID =
        GetContainerItemInfo(self.bagID, self.slotID)
    if texture and quality > LE_ITEM_QUALITY_POOR then
        if C.DB.inventory.favourite_items[itemID] then
            C.DB.inventory.favourite_items[itemID] = nil
        else
            C.DB.inventory.favourite_items[itemID] = true
        end
        ClearCursor()
        INVENTORY:UpdateAllBags()
    end
end

local customJunkEnable
function INVENTORY:CreateCustomJunkButton()
    local enabledText = C.RedColor .. L['INVENTORY_MARK_JUNK_ENABLED']

    local bu = F.CreateButton(self, 16, 16, true, icons.junk)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu.__turnOff = function()
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
        bu.text = nil
        customJunkEnable = nil
    end
    bu:SetScript('OnClick', function(self)
        if IsAltKeyDown() and IsControlKeyDown() then
            StaticPopup_Show('FREEUI_RESET_JUNK_LIST')
            return
        end

        INVENTORY:SelectToggleButton(3)
        customJunkEnable = not customJunkEnable
        if customJunkEnable then
            self.Icon:SetVertexColor(C.r, C.g, C.b, 1)
            self.text = enabledText
        else
            bu.__turnOff()
        end
        INVENTORY:UpdateAllBags()
        self:GetScript('OnEnter')(self)
    end)

    bu:SetScript('OnHide', bu.__turnOff)
    bu.title = L['INVENTORY_MARK_JUNK']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    toggleButtons[3] = bu

    return bu
end

local function customJunkOnClick(self)
    if not customJunkEnable then
        return
    end

    local texture, _, _, _, _, _, _, _, _, itemID = GetContainerItemInfo(self.bagID, self.slotID)
    local price = select(11, GetItemInfo(itemID))
    if texture and price > 0 then
        if _G.FREE_ADB['CustomJunkList'][itemID] then
            _G.FREE_ADB['CustomJunkList'][itemID] = nil
        else
            _G.FREE_ADB['CustomJunkList'][itemID] = true
        end
        ClearCursor()
        INVENTORY:UpdateAllBags()
    end
end

local deleteEnable
function INVENTORY:CreateDeleteButton()
    local enabledText = C.RedColor .. L['INVENTORY_QUICK_DELETE_ENABLED']

    local bu = F.CreateButton(self, 16, 16, true, icons.delete)
    bu.Icon:SetVertexColor(.5, .5, .5, 1)
    bu.__turnOff = function()
        bu.Icon:SetVertexColor(.5, .5, .5, 1)
        bu.text = nil
        deleteEnable = nil
    end
    bu:SetScript('OnClick', function(self)
        INVENTORY:SelectToggleButton(4)
        deleteEnable = not deleteEnable
        if deleteEnable then
            self.Icon:SetVertexColor(C.r, C.g, C.b, 1)
            self.text = enabledText
        else
            bu.__turnOff()
        end

        self:GetScript('OnEnter')(self)
    end)

    bu:SetScript('OnHide', bu.__turnOff)
    bu.title = L['INVENTORY_QUICK_DELETE']
    F.AddTooltip(bu, 'ANCHOR_TOP')

    toggleButtons[4] = bu

    return bu
end

local function deleteButtonOnClick(self)
    if not deleteEnable then
        return
    end

    local texture, _, _, quality = GetContainerItemInfo(self.bagID, self.slotID)
    if IsControlKeyDown() and IsAltKeyDown() and texture and
        (quality < LE_ITEM_QUALITY_RARE or quality == LE_ITEM_QUALITY_HEIRLOOM) then
        PickupContainerItem(self.bagID, self.slotID)
        DeleteCursorItem()
    end
end

function INVENTORY:ButtonOnClick(btn)
    if btn ~= 'LeftButton' then
        return
    end
    splitOnClick(self)
    favouriteOnClick(self)
    customJunkOnClick(self)
    deleteButtonOnClick(self)
end

function INVENTORY:UpdateAllBags()
    if self.Bags and self.Bags:IsShown() then
        self.Bags:BAG_UPDATE()
    end
end

function INVENTORY:OpenBags()
    OpenAllBags(true)
end

function INVENTORY:CloseBags()
    CloseAllBags()
end

function INVENTORY:OnLogin()
    if not C.DB.inventory.enable then
        return
    end

    INVENTORY:AutoSellJunk()
    INVENTORY:AutoRepair()

    local bagsScale = C.DB.inventory.scale
    local bagsWidth = C.DB.inventory.bag_columns
    local bankWidth = C.DB.inventory.bank_columns
    local iconSize = C.DB.inventory.slot_size
    local showNewItem = C.DB.inventory.new_item_flash
    local hasCanIMogIt = IsAddOnLoaded('CanIMogIt')
    local hasPawn = IsAddOnLoaded('Pawn')

    local Backpack = cargBags:NewImplementation('FreeUI_Backpack')
    Backpack:RegisterBlizzard()
    Backpack:SetScale(bagsScale)
    Backpack:HookScript('OnShow', function()
        PlaySound(SOUNDKIT_IG_BACKPACK_OPEN)
    end)
    Backpack:HookScript('OnHide', function()
        PlaySound(SOUNDKIT_IG_BACKPACK_CLOSE)
    end)

    INVENTORY.Bags = Backpack
    INVENTORY.BagsType = {}
    INVENTORY.BagsType[0] = 0 -- backpack
    INVENTORY.BagsType[-1] = 0 -- bank
    INVENTORY.BagsType[-3] = 0 -- reagent

    local f = {}
    local filters = INVENTORY:GetFilters()
    local MyContainer = Backpack:GetContainerClass()
    local ContainerGroups = {['Bag'] = {}, ['Bank'] = {}}

    local function AddNewContainer(bagType, index, name, filter)
        local width = bagsWidth
        if bagType == 'Bank' then
            width = bankWidth
        end

        local newContainer = MyContainer:New(name, {Columns = width, BagType = bagType})
        newContainer:SetFilter(filter, true)
        ContainerGroups[bagType][index] = newContainer
    end

    function Backpack:OnInit()
        local MyContainer = self:GetContainerClass()

        AddNewContainer('Bag', 9, 'Junk', filters.bagsJunk)
        AddNewContainer('Bag', 8, 'BagFavourite', filters.bagFavourite)
        AddNewContainer('Bag', 3, 'EquipSet', filters.bagEquipSet)
        AddNewContainer('Bag', 1, 'AzeriteItem', filters.bagAzeriteItem)
        AddNewContainer('Bag', 2, 'Equipment', filters.bagEquipment)
        AddNewContainer('Bag', 4, 'BagCollection', filters.bagCollection)
        AddNewContainer('Bag', 6, 'Consumable', filters.bagConsumable)
        AddNewContainer('Bag', 5, 'BagGoods', filters.bagGoods)
        AddNewContainer('Bag', 7, 'BagQuest', filters.bagQuest)

        f.main = MyContainer:New('Bag', {Columns = bagsWidth, Bags = 'bags'})
        f.main:SetPoint('BOTTOMRIGHT', -C.UIGap, C.UIGap)
        f.main:SetFilter(filters.onlyBags, true)

        AddNewContainer('Bank', 9, 'BankFavourite', filters.bankFavourite)
        AddNewContainer('Bank', 3, 'BankEquipSet', filters.bankEquipSet)
        AddNewContainer('Bank', 1, 'BankAzeriteItem', filters.bankAzeriteItem)
        AddNewContainer('Bank', 4, 'BankLegendary', filters.bankLegendary)
        AddNewContainer('Bank', 2, 'BankEquipment', filters.bankEquipment)
        AddNewContainer('Bank', 5, 'BankCollection', filters.bankCollection)
        AddNewContainer('Bank', 7, 'BankConsumable', filters.bankConsumable)
        AddNewContainer('Bank', 6, 'BankGoods', filters.bankGoods)
        AddNewContainer('Bank', 8, 'BankQuest', filters.bankQuest)

        f.bank = MyContainer:New('Bank', {Columns = bankWidth, Bags = 'bank'})
        f.bank:SetPoint('BOTTOMRIGHT', f.main, 'BOTTOMLEFT', -10, 0)
        f.bank:SetFilter(filters.onlyBank, true)
        f.bank:Hide()

        f.reagent = MyContainer:New('Reagent', {Columns = bankWidth, Bags = 'bankreagent'})
        f.reagent:SetFilter(filters.onlyReagent, true)
        f.reagent:SetPoint('BOTTOMLEFT', f.bank)
        f.reagent:Hide()

        for bagType, groups in pairs(ContainerGroups) do
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
            INVENTORY:UpdateAllBags() -- Initialize bagType
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
        self:SetNormalTexture(nil)
        self:SetPushedTexture(nil)
        self:SetHighlightTexture(C.Assets.bd_tex)
        self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)
        self:GetHighlightTexture():SetInside()
        self:SetSize(iconSize, iconSize)

        self.Icon:SetInside()
        self.Icon:SetTexCoord(unpack(C.TexCoord))
        F:SetFS(self.Count, C.Assets.Fonts.Regular, 11, 'OUTLINE', '', nil, true, 'BOTTOMRIGHT', -2,
                2)
        self.Cooldown:SetInside()
        self.IconOverlay:SetInside()
        self.IconOverlay2:SetInside()

        F.CreateBD(self, .25)
        self:SetBackdropColor(0, 0, 0, .25)

        local parentFrame = CreateFrame('Frame', nil, self)
        parentFrame:SetAllPoints()
        parentFrame:SetFrameLevel(5)

        self.Favourite = parentFrame:CreateTexture(nil, 'ARTWORK')
        self.Favourite:SetTexture(C.Assets.classify_tex)
        self.Favourite:SetTexCoord(.5, 1, .5, 1)
        self.Favourite:SetSize(16, 16)
        self.Favourite:SetPoint('TOPLEFT', 0, 0)

        self.Quest = parentFrame:CreateTexture(nil, 'ARTWORK')
        self.Quest:SetTexture(C.Assets.classify_tex)
        self.Quest:SetTexCoord(.5, 1, 0, .5)
        self.Quest:SetSize(24, 24)
        self.Quest:SetPoint('TOPLEFT', -2, -2)

        self.iLvl = F.CreateFS(self, C.Assets.Fonts.Regular, 11, 'OUTLINE', '', nil, true,
                               'BOTTOMRIGHT', -2, 2)
        self.BindType = F.CreateFS(self, C.Assets.Fonts.Regular, 11, 'OUTLINE', '', nil, true,
                                   'TOPLEFT', 2, -2)

        local flash = self:CreateTexture(nil, 'ARTWORK')
        flash:SetTexture('Interface\\Cooldown\\star4')
        flash:SetPoint('TOPLEFT', -20, 20)
        flash:SetPoint('BOTTOMRIGHT', 20, -20)
        flash:SetBlendMode('ADD')
        flash:SetAlpha(0)
        local anim = flash:CreateAnimationGroup()
        anim:SetLooping('REPEAT')
        anim.rota = anim:CreateAnimation('Rotation')
        anim.rota:SetDuration(1)
        anim.rota:SetDegrees(-90)
        anim.fader = anim:CreateAnimation('Alpha')
        anim.fader:SetFromAlpha(0)
        anim.fader:SetToAlpha(.5)
        anim.fader:SetDuration(.5)
        anim.fader:SetSmoothing('OUT')
        anim.fader2 = anim:CreateAnimation('Alpha')
        anim.fader2:SetStartDelay(.5)
        anim.fader2:SetFromAlpha(.5)
        anim.fader2:SetToAlpha(0)
        anim.fader2:SetDuration(1.2)
        anim.fader2:SetSmoothing('OUT')
        self:HookScript('OnHide', function()
            if anim:IsPlaying() then
                anim:Stop()
            end
        end)
        self.anim = anim

        self.ShowNewItems = showNewItem

        self:HookScript('OnClick', INVENTORY.ButtonOnClick)

        if hasCanIMogIt then
            self.canIMogIt = parentFrame:CreateTexture(nil, 'OVERLAY')
            self.canIMogIt:SetSize(13, 13)
            self.canIMogIt:SetPoint(unpack(
                                        _G.CanIMogIt.ICON_LOCATIONS[_G.CanIMogItOptions['iconLocation']]))
        end
    end

    function MyButton:ItemOnEnter()
        if self.ShowNewItems then
            if self.anim:IsPlaying() then
                self.anim:Stop()
            end
        end
    end

    local bagTypeColor = {
        [0] = {0, 0, 0, .25}, -- 容器
        [1] = false, -- 弹药袋
        [2] = {0, .5, 0, .25}, -- 草药袋
        [3] = {.8, 0, .8, .25}, -- 附魔袋
        [4] = {1, .8, 0, .25}, -- 工程袋
        [5] = {0, .8, .8, .25}, -- 宝石袋
        [6] = {.5, .4, 0, .25}, -- 矿石袋
        [7] = {.8, .5, .5, .25}, -- 制皮包
        [8] = {.8, .8, .8, .25}, -- 铭文包
        [9] = {.4, .6, 1, .25}, -- 工具箱
        [10] = {.8, 0, 0, .25} -- 烹饪包
    }

    local function isItemNeedsLevel(item)
        return item.link and item.level and item.rarity > 1 and
                   (item.subType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC or item.classID ==
                       LE_ITEM_CLASS_WEAPON or item.classID == LE_ITEM_CLASS_ARMOR)
    end

    local function isItemExist(item)
        return item.link
    end

    local function GetIconOverlayAtlas(item)
        if not item.link then
            return
        end

        if C_AzeriteEmpoweredItem_IsAzeriteEmpoweredItemByID(item.link) then
            return 'AzeriteIconFrame'
        elseif IsCosmeticItem(item.link) then
            return 'CosmeticIconFrame'
        elseif C_Soulbinds_IsItemConduitByItemInfo(item.link) then
            return 'ConduitIconFrame', 'ConduitIconFrame-Corners'
        end
    end

    local function UpdateCanIMogIt(self, item)
        if not self.canIMogIt then
            return
        end

        local text, unmodifiedText = _G.CanIMogIt:GetTooltipText(nil, item.bagID, item.slotID)
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
            self.UpgradeIcon:SetShown(_G.PawnIsContainerItemAnUpgrade(item.bagID, item.slotID))
        end
    end

    function MyButton:OnUpdate(item)
        if self.JunkIcon then
            if (_G.MerchantFrame:IsShown() or customJunkEnable) and
                (item.rarity == LE_ITEM_QUALITY_POOR or _G.FREE_ADB['CustomJunkList'][item.id]) and
                item.sellPrice > 0 then
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
                local color = C.QualityColors[item.rarity or 1]
                self.IconOverlay:SetVertexColor(color.r, color.g, color.b)
                self.IconOverlay2:SetAtlas(secondAtlas)
                self.IconOverlay2:Show()
            end
        end

        if C.DB.inventory.favourite_items[item.id] then
            self.Favourite:Show()
        else
            self.Favourite:Hide()
        end

        if self.ShowNewItems then
            if C_NewItems_IsNewItem(item.bagID, item.slotID) then
                self.anim:Play()
            else
                if self.anim:IsPlaying() then
                    self.anim:Stop()
                end
            end
        end

        self.iLvl:SetText('')
        if C.DB.inventory.item_level and isItemNeedsLevel(item) then
            local level = F:GetItemLevel(item.link, item.bagID, item.slotID) or item.level

            if level > C.DB.inventory.item_level_to_show then
                local color = C.QualityColors[item.rarity]
                self.iLvl:SetText(level)
                self.iLvl:SetTextColor(color.r, color.g, color.b)
            end
        end

        if C.DB.inventory.special_color then
            local bagType = INVENTORY.BagsType[item.bagID]
            local color = bagTypeColor[bagType] or bagTypeColor[0]
            self:SetBackdropColor(unpack(color))
        else
            self:SetBackdropColor(0, 0, 0, .25)
        end

        if C.DB.inventory.bind_type and isItemExist(item) then
            local itemLink = GetContainerItemLink(item.bagID, item.slotID)
            if not itemLink then
                return
            end

            local isBOA =
                CheckBoundStatus(item.link, item.bagID, item.slotID, ITEM_BNETACCOUNTBOUND) or
                    CheckBoundStatus(item.link, item.bagID, item.slotID, ITEM_BIND_TO_BNETACCOUNT) or
                    CheckBoundStatus(item.link, item.bagID, item.slotID, ITEM_ACCOUNTBOUND)
            local isSoulBound = CheckBoundStatus(item.link, item.bagID, item.slotID, ITEM_SOULBOUND)
            local _, _, itemRarity, _, _, _, _, _, _, _, _, _, _, bindType = GetItemInfo(itemLink)

            if isBOA or itemRarity == 7 or itemRarity == 8 then
                self.BindType:SetText('|cff00ccffBOA|r')
            elseif bindType == 2 and not isSoulBound then
                self.BindType:SetText('|cff1eff00BOE|r')
            else
                self.BindType:SetText('')
            end
        else
            self.BindType:SetText('')
        end

        -- Hide empty tooltip
        if not GetContainerItemInfo(item.bagID, item.slotID) then
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
            self:SetBackdropBorderColor(.8, .8, 0, 1)
        elseif item.rarity and item.rarity > -1 then
            local color = C.QualityColors[item.rarity]
            self:SetBackdropBorderColor(color.r, color.g, color.b, 1)
        else
            self:SetBackdropBorderColor(0, 0, 0, .2)
        end
    end

    function MyContainer:OnContentsChanged()
        self:SortButtons('bagSlot')

        local columns = self.Settings.Columns
        local offset = C.DB.inventory.offset
        local spacing = C.DB.inventory.spacing
        local xOffset = 5
        local yOffset = -offset + xOffset
        local _, height = self:LayoutButtons('grid', columns, spacing, xOffset, yOffset)
        local width = columns * (iconSize + spacing) - spacing
        if self.freeSlot then
            if C.DB.inventory.combine_free_slots then
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

        INVENTORY:UpdateAnchors(f.main, ContainerGroups['Bag'])
        INVENTORY:UpdateAnchors(f.bank, ContainerGroups['Bank'])
    end

    function MyContainer:OnCreate(name, settings)
        self.Settings = settings
        self:SetFrameStrata('HIGH')
        self:SetClampedToScreen(true)
        F.SetBD(self)
        if settings.Bags then
            F.CreateMF(self, nil, true)
        end

        local label
        if strmatch(name, 'AzeriteItem$') then
            label = L['INVENTORY_AZERITEARMOR']
        elseif strmatch(name, 'Equipment$') then
            label = BAG_FILTER_EQUIPMENT
        elseif strmatch(name, 'EquipSet$') then
            label = L.GUI.INVENTORY.ITEM_FILTER_GEAR_SET
        elseif name == 'BankLegendary' then
            label = LOOT_JOURNAL_LEGENDARIES
        elseif strmatch(name, 'Consumable$') then
            label = BAG_FILTER_CONSUMABLES
        elseif name == 'Junk' then
            label = BAG_FILTER_JUNK
        elseif strmatch(name, 'Collection') then
            label = COLLECTIONS
        elseif strmatch(name, 'Favourite') then
            label = PREFERENCES
        elseif strmatch(name, 'Goods') then
            label = AUCTION_CATEGORY_TRADE_GOODS
        elseif strmatch(name, 'Quest') then
            label = QUESTS_LABEL
        end

        if label then
            self.label = F.CreateFS(self, C.Assets.Fonts.Regular, 12, nil, label, nil, 'THICK',
                                    'TOPLEFT', 5, -4)
            return
        end

        INVENTORY.CreateCurrencyFrame(self)

        local buttons = {}
        buttons[1] = INVENTORY.CreateRestoreButton(self, f)
        if name == 'Bag' then
            INVENTORY.CreateBagBar(self, settings, 4)
            buttons[2] = INVENTORY.CreateBagToggle(self)
            buttons[4] = INVENTORY.CreateRepairButton(self)
            buttons[5] = INVENTORY.CreateSellButton(self)
            buttons[6] = INVENTORY.CreateSplitButton(self)
            buttons[7] = INVENTORY.CreateFavouriteButton(self)
            buttons[8] = INVENTORY.CreateCustomJunkButton(self)
            buttons[9] = INVENTORY.CreateDeleteButton(self)
            buttons[10] = INVENTORY.CreateSearchButton(self)
        elseif name == 'Bank' then
            INVENTORY.CreateBagBar(self, settings, 7)
            buttons[2] = INVENTORY.CreateReagentButton(self, f)
            buttons[4] = INVENTORY.CreateBagToggle(self)
        elseif name == 'Reagent' then
            buttons[2] = INVENTORY.CreateBankButton(self, f)
            buttons[4] = INVENTORY.CreateDepositButton(self)
        end
        buttons[3] = INVENTORY.CreateSortButton(self, name)

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

        self:HookScript('OnShow', F.RestoreMF)

        self.iconSize = iconSize
        INVENTORY.CreateFreeSlots(self)
    end

    local BagButton = Backpack:GetClass('BagButton', true, 'BagButton')
    function BagButton:OnCreate()
        self:SetNormalTexture(nil)
        self:SetPushedTexture(nil)
        self:SetHighlightTexture(C.Assets.bd_tex)
        self:GetHighlightTexture():SetVertexColor(1, 1, 1, .25)

        self:SetSize(iconSize, iconSize)
        F.CreateBD(self, .25)
        self.Icon:SetInside()
        self.Icon:SetTexCoord(unpack(C.TexCoord))
    end

    function BagButton:OnUpdate()
        self:SetBackdropBorderColor(0, 0, 0)

        local id = GetInventoryItemID('player',
                                      (self.GetInventorySlot and self:GetInventorySlot()) or
                                          self.invID)
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

        if classID == LE_ITEM_CLASS_CONTAINER then
            INVENTORY.BagsType[self.bagID] = subClassID or 0
        else
            INVENTORY.BagsType[self.bagID] = 0
        end
    end

    -- Sort order
    SetSortBagsRightToLeft(C.DB.inventory.sort_mode == 1)
    SetInsertItemsLeftToRight(false)

    -- Init
    ToggleAllBags()
    ToggleAllBags()
    INVENTORY.initComplete = true

    F:RegisterEvent('TRADE_SHOW', INVENTORY.OpenBags)
    F:RegisterEvent('TRADE_CLOSED', INVENTORY.CloseBags)
    F:RegisterEvent('BANKFRAME_OPENED', INVENTORY.AutoDeposit)

    -- Fixes
    _G.BankFrame.GetRight = function()
        return f.bank:GetRight()
    end
    _G.BankFrameItemButton_Update = F.Dummy
end
