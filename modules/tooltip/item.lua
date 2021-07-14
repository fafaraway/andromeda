local _G = _G
local unpack = unpack
local select = select
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local IsAltKeyDown = IsAltKeyDown

local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local function ItemInfo(self)
    local _, link = self:GetItem()
    local bagCount = GetItemCount(link)
    local bankCount = GetItemCount(link, true) - bagCount
    local itemStackCount = select(8, GetItemInfo(link))

    if not IsAltKeyDown() then
        return
    end

    self:AddLine(' ')

    if bankCount > 0 then
        self:AddDoubleLine(_G.BAGSLOT .. '/' .. _G.BANK .. ':', C.BlueColor .. bagCount .. '/' .. bankCount)
    elseif bagCount > 1 then
        self:AddDoubleLine(_G.BAGSLOT .. ':', C.BlueColor .. bagCount)
    end

    if itemStackCount and itemStackCount > 1 then
        self:AddDoubleLine(L['Stack'] .. ':', C.BlueColor .. itemStackCount)
    end
end

function TOOLTIP:ItemCountAndStack()
    _G.GameTooltip:HookScript('OnTooltipSetItem', ItemInfo)
end
