local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--[[ do FrameXML\FloatingPetBattleTooltip.lua
end ]]

do --[[ FrameXML\FloatingPetBattleTooltip.xml ]]
    function Skin.BattlePetTooltipTemplate(frame)
        Skin.TooltipBorderedFrameTemplate(frame)
    end
end

function private.FrameXML.FloatingPetBattleTooltip()
    if private.disabled.tooltips then return end

    Skin.SharedPetBattleAbilityTooltipTemplate(_G.FloatingPetBattleAbilityTooltip)
    Skin.UIPanelCloseButton(_G.FloatingPetBattleAbilityTooltip.CloseButton)
    _G.FloatingPetBattleAbilityTooltip.CloseButton:SetPoint("TOPRIGHT", -3, -3)

    Skin.BattlePetTooltipTemplate(_G.FloatingBattlePetTooltip)
    _G.FloatingBattlePetTooltip.Delimiter:SetHeight(1)
    Skin.UIPanelCloseButton(_G.FloatingBattlePetTooltip.CloseButton)
    _G.FloatingBattlePetTooltip.CloseButton:SetPoint("TOPRIGHT", -3, -3)
end
