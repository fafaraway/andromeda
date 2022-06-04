local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local alertBagsFull
local shouldAlertBags = false
local last = 0

local function OnUpdate(self, elapsed)
    last = last + elapsed
    if last > 1 then
        self:SetScript('OnUpdate', nil)
        last = 0
        shouldAlertBags = true
        alertBagsFull(self)
    end
end

alertBagsFull = function(self)
    local totalFree, freeSlots, bagFamily = 0
    for i = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS do
        freeSlots, bagFamily = GetContainerNumFreeSlots(i)
        if bagFamily == 0 then
            totalFree = totalFree + freeSlots
        end
    end

    if totalFree == 0 then
        if shouldAlertBags then
            F:CreateNotification(_G.INVTYPE_BAG, _G.TUTORIAL_TITLE58, nil, 'Interface\\ICONS\\INV_Misc_Bag_08')
            shouldAlertBags = false
        else
            self:SetScript('OnUpdate', OnUpdate)
        end
    else
        shouldAlertBags = false
    end
end

function NOTIFICATION:BagFullNotify()
    if not C.DB.Notification.BagFull then
        return
    end

    local f = CreateFrame('Frame')
    f:RegisterEvent('BAG_UPDATE')
    f:RegisterEvent('PLAYER_ENTERING_WORLD')
    f:SetScript('OnEvent', function(self, event)
        if event == 'BAG_UPDATE' then
            alertBagsFull(self)
        end
    end)
end
