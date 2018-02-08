local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local F = _G.unpack(private.Aurora)
local Skin = private.Aurora.Skin

function private.FrameXML.WorldMapFrame()
    if not private.disabled.tooltips then
        Skin.ShoppingTooltipTemplate(_G.WorldMapCompareTooltip1)
        Skin.ShoppingTooltipTemplate(_G.WorldMapCompareTooltip2)
        Skin.GameTooltipTemplate(_G.WorldMapTooltip)
        Skin.EmbeddedItemTooltip(_G.WorldMapTooltip.ItemTooltip)
    end

    local WorldMapFrame = _G.WorldMapFrame
    local BorderFrame = WorldMapFrame.BorderFrame

    WorldMapFrame.UIElementsFrame.CloseQuestPanelButton:GetRegions():Hide()
    WorldMapFrame.UIElementsFrame.OpenQuestPanelButton:GetRegions():Hide()
    BorderFrame.Bg:Hide()
    select(2, BorderFrame:GetRegions()):Hide()
    BorderFrame.portrait:SetTexture("")
    BorderFrame.portraitFrame:SetTexture("")
    for i = 5, 7 do
        select(i, BorderFrame:GetRegions()):SetAlpha(0)
    end
    BorderFrame.TopTileStreaks:SetTexture("")
    for i = 10, 14 do
        select(i, BorderFrame:GetRegions()):Hide()
    end
    BorderFrame.ButtonFrameEdge:Hide()
    BorderFrame.InsetBorderTop:Hide()
    BorderFrame.Inset.Bg:Hide()
    BorderFrame.Inset:DisableDrawLayer("BORDER")

    F.SetBD(BorderFrame, 1, 0, -3, 2)
    F.ReskinClose(BorderFrame.CloseButton)
    F.ReskinArrow(WorldMapFrame.UIElementsFrame.CloseQuestPanelButton, "Left")
    F.ReskinArrow(WorldMapFrame.UIElementsFrame.OpenQuestPanelButton, "Right")
    F.ReskinDropDown(_G.WorldMapLevelDropDown)
    F.ReskinNavBar(_G.WorldMapFrameNavBar)

    BorderFrame.CloseButton:SetPoint("TOPRIGHT", -9, -6)

    _G.WorldMapLevelDropDown:SetPoint("TOPLEFT", -7, 2)
    _G.WorldMapLevelDropDown.Text:SetPoint("LEFT", 14, 2)
    _G.WorldMapLevelDropDown.Text:SetPoint("RIGHT", -38, 2)

    -- [[ Size up / down buttons ]]
    Skin.MaximizeMinimizeButtonFrameTemplate(BorderFrame.MaxMinButtonFrame)
    BorderFrame.MaxMinButtonFrame:ClearAllPoints()
    BorderFrame.MaxMinButtonFrame:SetPoint("TOPRIGHT", BorderFrame.CloseButton, "TOPLEFT", -1, 0)

    -- [[ Misc ]]
    _G.WorldMapFrameTutorialButton.Ring:Hide()
    _G.WorldMapFrameTutorialButton:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -12, 12)

    do
        local topLine = WorldMapFrame.UIElementsFrame:CreateTexture()
        topLine:SetColorTexture(0, 0, 0)
        topLine:SetHeight(1)
        topLine:SetPoint("TOPLEFT", 0, 1)
        topLine:SetPoint("TOPRIGHT", 1, 1)

        local rightLine = WorldMapFrame.UIElementsFrame:CreateTexture()
        rightLine:SetColorTexture(0, 0, 0)
        rightLine:SetWidth(1)
        rightLine:SetPoint("BOTTOMRIGHT", 1, 0)
        rightLine:SetPoint("TOPRIGHT", 1, 1)
    end

    -- [[ Tracking options ]]
    local TrackingOptions = WorldMapFrame.UIElementsFrame.TrackingOptionsButton

    TrackingOptions:GetRegions():Hide()
    TrackingOptions.Background:Hide()
    TrackingOptions.IconOverlay:SetTexture("")
    TrackingOptions.Button.Border:Hide()
end
