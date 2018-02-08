local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\ItemRef.lua
end ]]

--[[ do FrameXML\ItemRef.xml
end ]]

function private.FrameXML.ItemRef()
    if private.disabled.tooltips then return end

    Skin.ShoppingTooltipTemplate(_G.ItemRefShoppingTooltip1)
    Skin.ShoppingTooltipTemplate(_G.ItemRefShoppingTooltip2)

    Skin.GameTooltipTemplate(_G.ItemRefTooltip)
    Skin.UIPanelCloseButton(_G.ItemRefCloseButton)
    _G.ItemRefCloseButton:SetPoint("TOPRIGHT", -3, -3)
end
