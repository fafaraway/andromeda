local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals next

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\GameTooltip.lua ]]
    function Hook.GameTooltip_OnHide(gametooltip)
        Base.SetBackdropColor(gametooltip)
    end
end

do --[[ SharedXML\GameTooltipTemplate.xml ]]
    function Skin.GameTooltipTemplate(gametooltip)
        Base.SetBackdrop(gametooltip)

        -- BlizzWTF: the global name for this frame conflicts with ReputationParagonTooltipStatusBar
        local status = gametooltip:GetChildren()
        status:SetHeight(4)
        status:SetPoint("TOPLEFT", gametooltip, "BOTTOMLEFT", 1, 0)
        status:SetPoint("TOPRIGHT", gametooltip, "BOTTOMRIGHT", -1, 0)
        Base.SetTexture(status:GetStatusBarTexture(), "gradientUp")

        local statusBG = status:CreateTexture(nil, "BACKGROUND")
        statusBG:SetColorTexture(0, 0, 0)
        statusBG:SetPoint("TOPLEFT", -1, 1)
        statusBG:SetPoint("BOTTOMRIGHT", 1, -1)
    end
    function Skin.ShoppingTooltipTemplate(gametooltip)
        Base.SetBackdrop(gametooltip)
    end
    function Skin.TooltipStatusBarTemplate(statusbar)
    end
    function Skin.TooltipProgressBarTemplate(frame)
        local bar = frame.Bar
        Base.SetBackdrop(bar, Aurora.frameColor:GetRGBA())
        bar:SetBackdropBorderColor(Aurora.buttonColor:GetRGB())

        local texture = bar:GetStatusBarTexture()
        Base.SetTexture(texture, "gradientUp")
        texture:SetDrawLayer("BORDER")

        bar.BorderLeft:Hide()
        bar.BorderRight:Hide()
        bar.BorderMid:Hide()

        local LeftDivider = bar.LeftDivider
        LeftDivider:SetColorTexture(Aurora.buttonColor:GetRGB())
        LeftDivider:SetSize(1, 15)
        LeftDivider:SetPoint("LEFT", 73, 0)

        local RightDivider = bar.RightDivider
        RightDivider:SetColorTexture(Aurora.buttonColor:GetRGB())
        RightDivider:SetSize(1, 15)
        RightDivider:SetPoint("RIGHT", -73, 0)

        _G.select(7, bar:GetRegions()):Hide()
    end
end

do --[[ FrameXML\GameTooltip.xml ]]
    function Skin.EmbeddedItemTooltip(frame)
        Base.CropIcon(frame.Icon)
        local bg = _G.CreateFrame("Frame", nil, frame)
        bg:SetPoint("TOPLEFT", frame.Icon, -1, 1)
        bg:SetPoint("BOTTOMRIGHT", frame.Icon, 1, -1)
        Base.SetBackdrop(bg, 0,0,0,0)
        frame._auroraIconBorder = bg
    end
end

function private.FrameXML.GameTooltip()
    if private.disabled.tooltips then return end

    _G.hooksecurefunc("GameTooltip_OnHide", Hook.GameTooltip_OnHide)

    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip1)
    Skin.ShoppingTooltipTemplate(_G.ShoppingTooltip2)
    Skin.GameTooltipTemplate(_G.GameTooltip)
end
