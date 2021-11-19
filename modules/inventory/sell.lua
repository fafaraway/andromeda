local F, C = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')

local stop, cache = true, {}
local errorText = _G.ERR_VENDOR_DOESNT_BUY

local function StartSelling()
    if stop then
        return
    end
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            if stop then
                return
            end

            local _, _, _, quality, _, _, link, _, noValue, itemID = GetContainerItemInfo(bag, slot)
            if link and not noValue and not INVENTORY:IsPetTrashCurrency(itemID) and (quality == 0 or _G.FREE_ADB['CustomJunkList'][itemID]) and not cache['b' .. bag .. 's' .. slot] then
                cache['b' .. bag .. 's' .. slot] = true
                UseContainerItem(bag, slot)
                F:Delay(.2, StartSelling)
                return
            end
        end
    end
end

local function UpdateSelling(event, ...)
    if not C.DB.Inventory.AutoSellJunk then
        return
    end

    local _, arg = ...
    if event == 'MERCHANT_SHOW' then
        if IsAltKeyDown() then
            return
        end
        stop = false
        table.wipe(cache)
        StartSelling()
        F:RegisterEvent('UI_ERROR_MESSAGE', UpdateSelling)
    elseif event == 'UI_ERROR_MESSAGE' and arg == errorText or event == 'MERCHANT_CLOSED' then
        stop = true
    end
end

function INVENTORY:AutoSellJunk()
    F:RegisterEvent('MERCHANT_SHOW', UpdateSelling)
    F:RegisterEvent('MERCHANT_CLOSED', UpdateSelling)
end
