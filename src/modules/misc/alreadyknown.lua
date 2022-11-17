local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local COLOR = { r = 0.1, g = 1, b = 0.1 }
local knowables = {
    [Enum.ItemClass.Consumable] = true,
    [Enum.ItemClass.Recipe] = true,
    [Enum.ItemClass.Miscellaneous] = true,
    [Enum.ItemClass.ItemEnhancement] = true,
}
local knowns = {}

local function isPetCollected(speciesID)
    if not speciesID or speciesID == 0 then
        return
    end
    local numOwned = C_PetJournal.GetNumCollectedInfo(speciesID)
    if numOwned > 0 then
        return true
    end
end

local function IsAlreadyKnown(link, index)
    if not link then
        return
    end

    local linkType, linkID = strmatch(link, '|H(%a+):(%d+)')
    linkID = tonumber(linkID)

    if linkType == 'battlepet' then
        return isPetCollected(linkID)
    elseif linkType == 'item' then
        local name, _, _, level, _, _, _, _, _, _, _, itemClassID = GetItemInfo(link)
        if not name then
            return
        end

        if itemClassID == Enum.ItemClass.Battlepet and index then
            local data = C_TooltipInfo.GetGuildBankItem(GetCurrentGuildBankTab(), index)
            if data then
                local argVal = data.args and data.args[2]
                if argVal.field == 'battlePetSpeciesID' then
                    return isPetCollected(argVal.intVal)
                end
            end
        elseif TOOLTIP.ConduitData[linkID] and TOOLTIP.ConduitData[linkID] >= level then
            return true
        else
            if knowns[link] then
                return true
            end
            if not knowables[itemClassID] then
                return
            end

            local data = C_TooltipInfo.GetHyperlink(link, nil, nil, true)
            if data then
                for i = 1, #data.lines do
                    local lineData = data.lines[i]
                    local argVal = lineData and lineData.args
                    if argVal then
                        local text = argVal[2] and argVal[2].stringVal
                        if text then
                            if strfind(text, _G.COLLECTED) or text == _G.ITEM_SPELL_KNOWN then
                                knowns[link] = true
                                return true
                            end
                        end
                    end
                end
            end
        end
    end
end

-- merchant frame
local function Hook_UpdateMerchantInfo()
    local numItems = GetMerchantNumItems()
    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        local index = (_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE + i
        if index > numItems then
            return
        end

        local button = _G['MerchantItem' .. i .. 'ItemButton']
        if button and button:IsShown() then
            local _, _, _, _, numAvailable, isUsable = GetMerchantItemInfo(index)
            if isUsable and IsAlreadyKnown(GetMerchantItemLink(index)) then
                local r, g, b = COLOR.r, COLOR.g, COLOR.b
                if numAvailable == 0 then
                    r, g, b = r * 0.5, g * 0.5, b * 0.5
                end
                _G.SetItemButtonTextureVertexColor(button, r, g, b)
            end
        end
    end
end
hooksecurefunc('MerchantFrame_UpdateMerchantInfo', Hook_UpdateMerchantInfo)

local function Hook_UpdateBuybackInfo()
    local numItems = GetNumBuybackItems()
    for index = 1, _G.BUYBACK_ITEMS_PER_PAGE do
        if index > numItems then
            return
        end

        local button = _G['MerchantItem' .. index .. 'ItemButton']
        if button and button:IsShown() then
            local _, _, _, _, _, isUsable = GetBuybackItemInfo(index)
            if isUsable and IsAlreadyKnown(GetBuybackItemLink(index)) then
                _G.SetItemButtonTextureVertexColor(button, COLOR.r, COLOR.g, COLOR.b)
            end
        end
    end
end
hooksecurefunc('MerchantFrame_UpdateBuybackInfo', Hook_UpdateBuybackInfo)

-- auction house
local function Hook_UpdateAuctionItems(self)
    for i = 1, self.ScrollTarget:GetNumChildren() do
        local child = select(i, self.ScrollTarget:GetChildren())
        if child.cells then
            local button = child.cells[2]
            local itemKey = button and button.rowData and button.rowData.itemKey
            if itemKey and itemKey.itemID then
                local itemLink
                if itemKey.itemID == 82800 then
                    itemLink = format('|Hbattlepet:%d::::::|h[Dummy]|h', itemKey.battlePetSpeciesID)
                else
                    itemLink = format('|Hitem:%d', itemKey.itemID)
                end

                if itemLink and IsAlreadyKnown(itemLink) then
                    -- Highlight
                    child.SelectedHighlight:Show()
                    child.SelectedHighlight:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
                    child.SelectedHighlight:SetAlpha(0.25)
                    -- Icon
                    button.Icon:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
                    button.IconBorder:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
                else
                    -- Highlight
                    child.SelectedHighlight:SetVertexColor(1, 1, 1)
                    -- Icon
                    button.Icon:SetVertexColor(1, 1, 1)
                    button.IconBorder:SetVertexColor(1, 1, 1)
                end
            end
        end
    end
end

-- guild bank frame
local MAX_GUILDBANK_SLOTS_PER_TAB = _G.MAX_GUILDBANK_SLOTS_PER_TAB or 98
local NUM_SLOTS_PER_GUILDBANK_GROUP = _G.NUM_SLOTS_PER_GUILDBANK_GROUP or 14

local function GuildBankFrame_Update(self)
    if self.mode ~= 'bank' then
        return
    end

    local button, index, column
    local tab = GetCurrentGuildBankTab()
    for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
        index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
        if index == 0 then
            index = NUM_SLOTS_PER_GUILDBANK_GROUP
        end

        column = ceil((i - 0.5) / NUM_SLOTS_PER_GUILDBANK_GROUP)
        button = self.Columns[column].Buttons[index]
        if button and button:IsShown() then
            local texture, _, locked = GetGuildBankItemInfo(tab, i)
            if texture and not locked then
                if IsAlreadyKnown(GetGuildBankItemLink(tab, i), i) then
                    _G.SetItemButtonTextureVertexColor(button, COLOR.r, COLOR.g, COLOR.b)
                else
                    _G.SetItemButtonTextureVertexColor(button, 1, 1, 1)
                end
            end
        end
    end
end

local hookCount = 0
local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:SetScript('OnEvent', function(_, event, addon)
    if addon == 'Blizzard_AuctionHouseUI' then
        hooksecurefunc(_G.AuctionHouseFrame.BrowseResultsFrame.ItemList.ScrollBox, 'Update', Hook_UpdateAuctionItems)
        hookCount = hookCount + 1
    elseif addon == 'Blizzard_GuildBankUI' then
        hooksecurefunc(_G.GuildBankFrame, 'Update', GuildBankFrame_Update)
        hookCount = hookCount + 1
    end

    if hookCount >= 2 then
        f:UnregisterEvent(event)
    end
end)
