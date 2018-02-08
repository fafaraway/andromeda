local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_BattlefieldMinimap()
    _G.BattlefieldMinimapTab:DisableDrawLayer("BACKGROUND")

    local bg = F.CreateBDFrame(_G.BattlefieldMinimap, 1.0 - _G.BattlefieldMinimapOptions.opacity)
    _G.BattlefieldMinimap:SetPoint("TOPLEFT", _G.BattlefieldMinimapTab, "BOTTOMLEFT")
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", -5, 3)
    local r, g, b = bg:GetBackdropColor()

    _G.BattlefieldMinimapCorner:Hide()
    _G.BattlefieldMinimapBackground:Hide()
    _G.BattlefieldMinimapCloseButton:Hide()

    _G.hooksecurefunc("BattlefieldMinimap_UpdateOpacity", function()
        local alpha = 1.0 - _G.BattlefieldMinimapOptions.opacity
        bg:SetBackdropColor(r, g, b, alpha)
        bg:SetBackdropBorderColor(r, g, b, alpha)
    end)
end
