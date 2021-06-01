--[[
    Alt + Click to buy a stack
 ]]

local _G = _G
local unpack = unpack
local select = select
local IsAltKeyDown = IsAltKeyDown
local GetMerchantItemLink = GetMerchantItemLink
local GetItemInfo = GetItemInfo
local BuyMerchantItem = BuyMerchantItem
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local GetMerchantItemInfo = GetMerchantItemInfo
local hooksecurefunc = hooksecurefunc

local F, C, L = unpack(select(2, ...))
local EM = F:RegisterModule('EnhancedMerchant')

function EM:OnModifiedClick()
    if not IsAltKeyDown() then
        return
    end

    local id = self:GetID()
    local itemLink = GetMerchantItemLink(id)

    if not itemLink then
        return
    end

    local maxStack = select(8, GetItemInfo(itemLink))
    if maxStack and maxStack > 1 then
        local numAvailable = select(5, GetMerchantItemInfo(id))
        if numAvailable > -1 then
            BuyMerchantItem(id, numAvailable)
        else
            BuyMerchantItem(id, GetMerchantItemMaxStack(id))
        end
    end
end


function EM:OnLogin()
    hooksecurefunc('MerchantItemButton_OnModifiedClick', EM.OnModifiedClick)

    _G.ITEM_VENDOR_STACK_BUY = _G.ITEM_VENDOR_STACK_BUY .. '\n|cffff0000<' .. L['Alt+Click to buy a stack'] .. '>|r'
end
