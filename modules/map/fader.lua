local F, C = unpack(select(2, ...))
local MAP = F:GetModule('Map')

local function EnterCombat()
    F:UIFrameFadeOut(_G.Minimap.holder, 0.1, _G.Minimap.holder:GetAlpha(), 0)
    F:UIFrameFadeOut(_G.Minimap, 0.1, _G.Minimap:GetAlpha(), 0)
end

local function LeaveCombat()
    F:UIFrameFadeIn(_G.Minimap.holder, 0.1, _G.Minimap.holder:GetAlpha(), 1)
    F:UIFrameFadeIn(_G.Minimap, 0.1, _G.Minimap:GetAlpha(), 1)
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
