local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Skin = Aurora.Base, Aurora.Skin

function private.FrameXML.BNet()
    --[[ BNToastFrame ]]--
    Base.SetBackdrop(_G.BNToastFrame)

    _G.BNToastFrameGlowFrame.glow:SetColorTexture(1, 1, 1, 0.5)
    _G.BNToastFrameGlowFrame.glow:SetAllPoints()

    _G.BNToastFrameCloseButton:SetPushedTexture("")
    _G.BNToastFrameCloseButton:SetHighlightTexture([[Interface\FriendsFrame\ClearBroadcastIcon]])
    _G.BNToastFrameCloseButton:SetNormalTexture([[Interface\FriendsFrame\ClearBroadcastIcon]])
    _G.BNToastFrameCloseButton:GetNormalTexture():SetAlpha(0.5)

    Base.SetBackdrop(_G.BNToastFrame.TooltipFrame)


    --[[ BNetReportFrame ]]--
    Base.SetBackdrop(_G.BNetReportFrame)

    _G.BNetReportFrameCommentTopLeft:Hide()
    _G.BNetReportFrameCommentTopRight:Hide()
    _G.BNetReportFrameCommentTop:Hide()
    _G.BNetReportFrameCommentBottomLeft:Hide()
    _G.BNetReportFrameCommentBottomRight:Hide()
    _G.BNetReportFrameCommentBottom:Hide()
    _G.BNetReportFrameCommentLeft:Hide()
    _G.BNetReportFrameCommentRight:Hide()
    _G.BNetReportFrameCommentMiddle:Hide()

    local commentBorder = _G.CreateFrame("Frame", nil, _G.BNetReportFrame)
    commentBorder:SetPoint("TOPLEFT", _G.BNetReportFrameCommentTopLeft)
    commentBorder:SetPoint("BOTTOMRIGHT", _G.BNetReportFrameCommentBottomRight)
    Base.SetBackdrop(commentBorder)

    local scrollframe = _G.BNetReportFrameCommentScrollFrame
    Skin.UIPanelScrollFrameTemplate(scrollframe)

    scrollframe.ScrollBar:ClearAllPoints()
    scrollframe.ScrollBar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", -18, -13)
    scrollframe.ScrollBar:SetPoint("BOTTOMLEFT", scrollframe, "BOTTOMRIGHT", -18, 13)

    scrollframe.ScrollBar.ScrollUpButton:SetPoint("BOTTOM", scrollframe.ScrollBar, "TOP")
    scrollframe.ScrollBar.ScrollDownButton:SetPoint("TOP", scrollframe.ScrollBar, "BOTTOM")

    Skin.UIPanelButtonTemplate(_G.BNetReportFrameReportButton)
    Skin.UIPanelButtonTemplate(_G.BNetReportFrameCancelButton)


    --[[ TimeAlertFrame ]]--
    Base.SetBackdrop(_G.TimeAlertFrameBG)

    _G.TimeAlertFrameGlowFrame.glow:SetColorTexture(1, 1, 1, 0.5)
    _G.TimeAlertFrameGlowFrame.glow:SetAllPoints()
end
