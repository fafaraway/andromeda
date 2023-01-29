local F, C = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')

local stop = true
local cache = {}

local function startSelling()
    if stop then
        return
    end

    for bag = 0, 5 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            if stop then
                return
            end

            local info = C_Container.GetContainerItemInfo(bag, slot)
            if info then
                local quality, link, noValue, itemID = info.quality, info.hyperlink, info.hasNoValue, info.itemID
                local isInSet = C_Container.GetContainerItemEquipmentSetInfo(bag, slot)
                local hasTransmog = not C_TransmogCollection.GetItemInfo(link) or C_TransmogCollection.PlayerHasTransmogByItemInfo(link)

                if
                    link
                    and not noValue
                    and not isInSet
                    and not INVENTORY:IsPetTrashCurrency(itemID)
                    and hasTransmog
                    and (quality == 0 or _G.ANDROMEDA_ADB['CustomJunkList'][itemID])
                    and not cache['b' .. bag .. 's' .. slot]
                then
                    cache['b' .. bag .. 's' .. slot] = true
                    C_Container.UseContainerItem(bag, slot)
                    F:Delay(0.15, startSelling)

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
        if IsAltKeyDown() then
            return
        end
        stop = false
        wipe(cache)
        startSelling()
        F:RegisterEvent('UI_ERROR_MESSAGE', updateSelling)
    elseif event == 'UI_ERROR_MESSAGE' and arg == _G.ERR_VENDOR_DOESNT_BUY or event == 'MERCHANT_CLOSED' then
        stop = true
    end
end

function INVENTORY:AutoSellJunk()
    F:RegisterEvent('MERCHANT_SHOW', updateSelling)
    F:RegisterEvent('MERCHANT_CLOSED', updateSelling)
end
