local F, C = unpack(select(2, ...))

C.Themes['Blizzard_AzeriteUI'] = function()
    F.ReskinPortraitFrame(_G.AzeriteEmpoweredItemUI)
    _G.AzeriteEmpoweredItemUIBg:Hide()
    _G.AzeriteEmpoweredItemUI.ClipFrame.BackgroundFrame.Bg:Hide()
end

C.Themes['Blizzard_AzeriteEssenceUI'] = function()
    local r, g, b = C.r, C.g, C.b

    F.ReskinPortraitFrame(_G.AzeriteEssenceUI)
    F.StripTextures(_G.AzeriteEssenceUI.PowerLevelBadgeFrame)
    F.ReskinScroll(_G.AzeriteEssenceUI.EssenceList.ScrollBar)

    local headerButton = _G.AzeriteEssenceUI.EssenceList.HeaderButton
    headerButton:DisableDrawLayer('BORDER')
    headerButton:DisableDrawLayer('BACKGROUND')
    local bg = F.CreateBDFrame(headerButton, 0, true)
    bg:SetPoint('TOPLEFT', headerButton.ExpandedIcon, -4, 6)
    bg:SetPoint('BOTTOMRIGHT', headerButton.ExpandedIcon, 4, -6)
    headerButton:SetScript(
        'OnEnter',
        function()
            bg:SetBackdropColor(r, g, b, .25)
        end
    )
    headerButton:SetScript(
        'OnLeave',
        function()
            bg:SetBackdropColor(0, 0, 0, 0)
        end
    )

    for _, milestoneFrame in pairs(_G.AzeriteEssenceUI.Milestones) do
        if milestoneFrame.LockedState then
            milestoneFrame.LockedState.UnlockLevelText:SetTextColor(.6, .8, 1)
            milestoneFrame.LockedState.UnlockLevelText.SetTextColor = nop
        end
    end

    hooksecurefunc(
        _G.AzeriteEssenceUI.EssenceList,
        'Refresh',
        function(self)
            for _, button in ipairs(self.buttons) do
                if not button.bg then
                    local bg = F.CreateBDFrame(button, .25)
                    bg:SetPoint('TOPLEFT', 1, 0)
                    bg:SetPoint('BOTTOMRIGHT', 0, 2)

                    F.ReskinIcon(button.Icon)
                    button.PendingGlow:SetTexture('')
                    local hl = button:GetHighlightTexture()
                    hl:SetColorTexture(r, g, b, .25)
                    hl:SetInside(bg)

                    button.bg = bg
                end
                button.Background:SetTexture('')

                if button:IsShown() then
                    if button.PendingGlow:IsShown() then
                        button.bg:SetBackdropBorderColor(1, .8, 0)
                    else
                        button.bg:SetBackdropBorderColor(0, 0, 0)
                    end
                end
            end
        end
    )
end

local function reskinReforgeUI(frame, index)
    F.StripTextures(frame, index)
    F.CreateBDFrame(frame.Background)
    F.SetBD(frame)
    F.ReskinClose(frame.CloseButton)
    F.ReskinIcon(frame.ItemSlot.Icon)

    local buttonFrame = frame.ButtonFrame
    F.StripTextures(buttonFrame)
    buttonFrame.MoneyFrameEdge:SetAlpha(0)
    local bg = F.CreateBDFrame(buttonFrame, .25)
    bg:SetPoint('TOPLEFT', buttonFrame.MoneyFrameEdge, 3, 0)
    bg:SetPoint('BOTTOMRIGHT', buttonFrame.MoneyFrameEdge, 0, 2)
    if buttonFrame.AzeriteRespecButton then
        F.Reskin(buttonFrame.AzeriteRespecButton)
    end
    if buttonFrame.ActionButton then
        F.Reskin(buttonFrame.ActionButton)
    end
    if buttonFrame.Currency then
        F.ReskinIcon(buttonFrame.Currency.icon)
    end

    if frame.DescriptionCurrencies then
        hooksecurefunc(frame.DescriptionCurrencies, 'SetCurrencies', F.SetCurrenciesHook)
    end
end

C.Themes['Blizzard_AzeriteRespecUI'] = function()
    reskinReforgeUI(_G.AzeriteRespecFrame, 15)
end

C.Themes['Blizzard_ItemInteractionUI'] = function()
    reskinReforgeUI(_G.ItemInteractionFrame)
end
