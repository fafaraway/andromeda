local F, C = unpack(select(2, ...))
local INVENTORY = F:GetModule('Inventory')

local stop = true
local cache = {}

local function start()
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
                if
                    not cache['b' .. bag .. 's' .. slot]
                    and info.hyperlink
                    and not info.hasNoValue
                    and (info.quality == 0 or _G.ANDROMEDA_ADB['CustomJunkList'][info.itemID])
                    and (not INVENTORY:IsPetTrashCurrency(info.itemID))
                    and (not C_TransmogCollection.GetItemInfo(info.hyperlink) or not F.IsUnknownTransmog(bag, slot))
                then
                    cache['b' .. bag .. 's' .. slot] = true
                    C_Container.UseContainerItem(bag, slot)
                    F:Delay(0.15, start)

                    return
                end
            end
        end
    end
end

local function update(event, ...)
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
        start()
        F:RegisterEvent('UI_ERROR_MESSAGE', update)
    elseif event == 'UI_ERROR_MESSAGE' and arg == _G.ERR_VENDOR_DOESNT_BUY or event == 'MERCHANT_CLOSED' then
        stop = true
    end
end

function INVENTORY:AutoSellJunk()
    F:RegisterEvent('MERCHANT_SHOW', update)
    F:RegisterEvent('MERCHANT_CLOSED', update)
end
