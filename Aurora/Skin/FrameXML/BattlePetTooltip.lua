local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\BattlePetTooltip.lua
end ]]

--[[ do FrameXML\BattlePetTooltip.xml
end ]]

function private.FrameXML.BattlePetTooltip()
    if private.disabled.tooltips then return end

    Skin.BattlePetTooltipTemplate(_G.BattlePetTooltip)
end
