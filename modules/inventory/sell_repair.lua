local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemInfo = GetContainerItemInfo
local GetItemInfo = GetItemInfo
local GetRepairAllCost = GetRepairAllCost
local UseContainerItem = UseContainerItem
local IsControlKeyDown = IsControlKeyDown
local GetMoney = GetMoney
local CanMerchantRepair = CanMerchantRepair
local RepairAllItems = RepairAllItems
local IsInGuild = IsInGuild
local CanGuildBankRepair = CanGuildBankRepair
local GetGuildBankWithdrawMoney = GetGuildBankWithdrawMoney

local F, C = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')

local isShown, autoRepair, repairAllCost, canRepair
local sellCount, stop, cache = 0, true, {}
local errorText = _G.ERR_VENDOR_DOESNT_BUY

local function stopSelling()
    stop = true
    sellCount = 0
end

local function startSelling()
    if stop then
        return
    end
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            if stop then
                return
            end
            local link = GetContainerItemLink(bag, slot)
            if link then
                local price = select(11, GetItemInfo(link))
                local _, count, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(bag, slot)
                if (quality == 0 or _G.FREE_ADB['CustomJunkList'][itemID]) and (not INVENTORY:IsPetTrashCurrency(itemID)) and price > 0 and not cache['b' .. bag .. 's' .. slot] then
                    sellCount = sellCount + price * count
                    cache['b' .. bag .. 's' .. slot] = true
                    UseContainerItem(bag, slot)
                    F:Delay(.2, startSelling)
                    return
                end
            end
        end
    end
end

local function updateSelling(event, ...)
    if not C.DB.Inventory.AutoSellJunk then
        return
    end

    local _, arg = ...
    if event == 'MERCHANT_SHOW' then
        if IsControlKeyDown() then
            return
        end
        stop = false
        wipe(cache)
        startSelling()
        F:RegisterEvent('UI_ERROR_MESSAGE', updateSelling)
    elseif event == 'UI_ERROR_MESSAGE' and arg == errorText then
        stopSelling(false)
    elseif event == 'MERCHANT_CLOSED' then
        stopSelling(true)
    end
end

local function delayFunc()
    autoRepair(true)
end

function autoRepair(override)
    if isShown and not override then
        return
    end
    isShown = true

    local myMoney = GetMoney()
    repairAllCost, canRepair = GetRepairAllCost()

    if canRepair and repairAllCost > 0 and C.DB.Inventory.AutoRepair then
        if (not override) and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
            RepairAllItems(true)
        else
            if myMoney > repairAllCost then
                RepairAllItems()

                return
            else
                F:Print(C.RedColor .. _G.GUILDBANK_REPAIR_INSUFFICIENT_FUNDS)
                F:CreateNotification(_G.MINIMAP_TRACKING_REPAIR, _G.GUILDBANK_REPAIR_INSUFFICIENT_FUNDS, nil, 'Interface\\ICONS\\Ability_Repair')
                return
            end
        end

        F:Delay(.5, delayFunc)
    end
end

local function merchantClose()
    isShown = false
    F:UnregisterEvent('MERCHANT_CLOSED', merchantClose)
end

local function merchantShow()
    if IsControlKeyDown() or not C.DB.Inventory.AutoRepair or not CanMerchantRepair() then
        return
    end
    autoRepair()
    F:RegisterEvent('MERCHANT_CLOSED', merchantClose)
end

function INVENTORY:AutoSellJunk()
    F:RegisterEvent('MERCHANT_SHOW', updateSelling)
    F:RegisterEvent('MERCHANT_CLOSED', updateSelling)
end

function INVENTORY:AutoRepair()
    F:RegisterEvent('MERCHANT_SHOW', merchantShow)
end
