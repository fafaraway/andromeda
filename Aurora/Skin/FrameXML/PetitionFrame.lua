local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

function private.FrameXML.PetitionFrame()
    Skin.ButtonFrameTemplate(_G.PetitionFrame)

    -- BlizzWTF: The portrait in the template is not being used.
    local portrait, bg, scrollTop, scrollBottom, scrollMiddle, scrollUp, scrollDown = _G.select(18, _G.PetitionFrame:GetRegions())
    portrait:Hide()
    bg:Hide()
    scrollTop:Hide()
    scrollBottom:Hide()
    scrollMiddle:Hide()
    scrollUp:Hide()
    scrollDown:Hide()

    _G.PetitionFrameCharterTitle:SetPoint("TOPLEFT", 8, -private.FRAME_TITLE_HEIGHT)
    _G.PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
    _G.PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)
    _G.PetitionFrameInstructions:SetPoint("RIGHT", -8, 0)

    -- BlizzWTF: This should use the title text included in the template
    _G.PetitionFrameNpcNameText:SetAllPoints(_G.PetitionFrame.TitleText)

    Skin.UIPanelButtonTemplate(_G.PetitionFrameCancelButton)
    _G.PetitionFrameCancelButton:SetPoint("BOTTOMRIGHT", -4, 4)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameSignButton)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameRequestButton)
    Skin.UIPanelButtonTemplate(_G.PetitionFrameRenameButton)
    _G.PetitionFrameRenameButton:ClearAllPoints()
    _G.PetitionFrameRenameButton:SetPoint("TOPLEFT", _G.PetitionFrameRequestButton, "TOPRIGHT", 1, 0)
    _G.PetitionFrameRenameButton:SetPoint("BOTTOMRIGHT", _G.PetitionFrameCancelButton, "BOTTOMLEFT", -1, 0)
    --[[
        select(18, _G.PetitionFrame:GetRegions()):Hide()
        select(19, _G.PetitionFrame:GetRegions()):Hide()
        select(23, _G.PetitionFrame:GetRegions()):Hide()
        select(24, _G.PetitionFrame:GetRegions()):Hide()
        _G.PetitionFrameTop:Hide()
        _G.PetitionFrameBottom:Hide()
        _G.PetitionFrameMiddle:Hide()

        F.ReskinPortraitFrame(_G.PetitionFrame, true)
        F.Reskin(_G.PetitionFrameSignButton)
        F.Reskin(_G.PetitionFrameRequestButton)
        F.Reskin(_G.PetitionFrameRenameButton)
        F.Reskin(_G.PetitionFrameCancelButton)
    ]]
end
