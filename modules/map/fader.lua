local F, C = unpack(select(2, ...))
local MAP = F:GetModule('Map')

local function EnterCombat()
    F:UIFrameFadeOut(Minimap.Holder, 0.1, Minimap.Holder:GetAlpha(), 0)
    F:UIFrameFadeOut(Minimap, 0.1, Minimap:GetAlpha(), 0)
end

local function LeaveCombat()
    F:UIFrameFadeIn(Minimap.Holder, 0.1, Minimap.Holder:GetAlpha(), 1)
    F:UIFrameFadeIn(Minimap, 0.1, Minimap:GetAlpha(), 1)
end

function MAP:UpdateMinimapFader()
    if C.DB.Map.HiddenInCombat then
        F:RegisterEvent('PLAYER_REGEN_DISABLED', EnterCombat)
        F:RegisterEvent('PLAYER_REGEN_ENABLED', LeaveCombat)
    else
        F:UnregisterEvent('PLAYER_REGEN_DISABLED', EnterCombat)
        F:UnregisterEvent('PLAYER_REGEN_ENABLED', LeaveCombat)
    end
end
