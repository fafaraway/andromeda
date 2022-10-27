local F, C = unpack(select(2, ...))

local function colorMinimize(f)
    if f:IsEnabled() then
        f.minimize:SetVertexColor(C.r, C.g, C.b)
    end
end

local function clearMinimize(f)
    f.minimize:SetVertexColor(1, 1, 1)
end

local function updateMinorButtonState(button)
    if button:GetChecked() then
        button.bg:SetBackdropColor(1, 0.8, 0, 0.25)
    else
        button.bg:SetBackdropColor(0, 0, 0, 0.25)
    end
end

tinsert(C.BlizzThemes, function()
    for i = 1, 4 do
        local frame = _G['StaticPopup' .. i]
        local bu = _G['StaticPopup' .. i .. 'ItemFrame']
        local icon = _G['StaticPopup' .. i .. 'ItemFrameIconTexture']
        local close = _G['StaticPopup' .. i .. 'CloseButton']

        local gold = _G['StaticPopup' .. i .. 'MoneyInputFrameGold']
        local silver = _G['StaticPopup' .. i .. 'MoneyInputFrameSilver']
        local copper = _G['StaticPopup' .. i .. 'MoneyInputFrameCopper']

        _G['StaticPopup' .. i .. 'ItemFrameNameFrame']:Hide()

        bu:SetNormalTexture(C.Assets.Textures.Blank)
        bu:SetHighlightTexture(C.Assets.Textures.Blank)
        bu:SetPushedTexture(C.Assets.Textures.Blank)
        bu.bg = F.ReskinIcon(icon)
        F.ReskinIconBorder(bu.IconBorder)

        local bg = F.CreateBDFrame(bu, 0.25)
        bg:SetPoint('TOPLEFT', bu.bg, 'TOPRIGHT', 2, 0)
        bg:SetPoint('BOTTOMRIGHT', bu.bg, 115, 0)

        silver:SetPoint('LEFT', gold, 'RIGHT', 1, 0)
        copper:SetPoint('LEFT', silver, 'RIGHT', 1, 0)

        frame.Border:Hide()
        F.SetBD(frame)
        for j = 1, 4 do
            F.Reskin(frame['button' .. j])
        end
        F.Reskin(frame.extraButton)
        F.ReskinClose(close)

        close.minimize = close:CreateTexture(nil, 'OVERLAY')
        close.minimize:SetSize(9, C.MULT)
        close.minimize:SetPoint('CENTER')
        close.minimize:SetTexture(C.Assets.Textures.Backdrop)
        close.minimize:SetVertexColor(1, 1, 1)
        close:HookScript('OnEnter', colorMinimize)
        close:HookScript('OnLeave', clearMinimize)

        F.ReskinInput(_G['StaticPopup' .. i .. 'EditBox'], 20)
        F.ReskinInput(gold)
        F.ReskinInput(silver)
        F.ReskinInput(copper)
    end

    hooksecurefunc('StaticPopup_Show', function(which, _, _, data)
        local info = StaticPopupDialogs[which]

        if not info then
            return
        end

        local dialog = _G.StaticPopup_FindVisible(which, data)

        if not dialog then
            local index = 1
            if info.preferredIndex then
                index = info.preferredIndex
            end
            for i = index, _G.STATICPOPUP_NUMDIALOGS do
                local frame = _G['StaticPopup' .. i]
                if not frame:IsShown() then
                    dialog = frame
                    break
                end
            end

            if not dialog and info.preferredIndex then
                for i = 1, info.preferredIndex do
                    local frame = _G['StaticPopup' .. i]
                    if not frame:IsShown() then
                        dialog = frame
                        break
                    end
                end
            end
        end

        if not dialog then
            return
        end

        if info.closeButton then
            local closeButton = _G[dialog:GetName() .. 'CloseButton']

            closeButton:SetNormalTexture(C.Assets.Textures.Blank)
            closeButton:SetPushedTexture(C.Assets.Textures.Blank)

            if info.closeButtonIsHide then
                closeButton.__texture:Hide()
                closeButton.minimize:Show()
            else
                closeButton.__texture:Show()
                closeButton.minimize:Hide()
            end
        end
    end)

    -- Pet battle queue popup

    F.SetBD(_G.PetBattleQueueReadyFrame)
    F.CreateBDFrame(_G.PetBattleQueueReadyFrame.Art)
    _G.PetBattleQueueReadyFrame.Border:Hide()
    F.Reskin(_G.PetBattleQueueReadyFrame.AcceptButton)
    F.Reskin(_G.PetBattleQueueReadyFrame.DeclineButton)

    -- PlayerReportFrame
    F.StripTextures(_G.ReportFrame)
    F.SetBD(_G.ReportFrame)
    F.ReskinClose(_G.ReportFrame.CloseButton)
    F.Reskin(_G.ReportFrame.ReportButton)
    F.ReskinDropDown(_G.ReportFrame.ReportingMajorCategoryDropdown)
    F.ReskinEditBox(_G.ReportFrame.Comment)

    hooksecurefunc(_G.ReportFrame, 'AnchorMinorCategory', function(self)
        if self.MinorCategoryButtonPool then
            for button in self.MinorCategoryButtonPool:EnumerateActive() do
                if not button.styled then
                    F.StripTextures(button)
                    button.bg = F.CreateBDFrame(button, 0.25)
                    button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                    button:HookScript('OnClick', updateMinorButtonState)

                    button.styled = true
                end

                updateMinorButtonState(button)
            end
        end
    end)
end)
