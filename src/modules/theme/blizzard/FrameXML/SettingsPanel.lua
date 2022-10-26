local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not C.IS_NEW_PATCH then
        return
    end

    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local frame = _G.SettingsPanel

    F.StripTextures(frame)
    F.SetBD(frame)
    F.ReskinClose(frame.ClosePanelButton)
    F.ReskinEditBox(frame.SearchBox)
    F.Reskin(frame.ApplyButton)
    F.Reskin(frame.CloseButton)

    local function resetTabAnchor(tab)
        tab.Text:SetPoint('BOTTOM', 0, 4)
    end
    local function reskinSettingsTab(tab)
        if not tab then
            return
        end
        F.StripTextures(tab, 0)
        resetTabAnchor(tab)
        hooksecurefunc(tab, 'OnSelected', resetTabAnchor)
    end
    reskinSettingsTab(frame.GameTab)
    reskinSettingsTab(frame.AddOnsTab)

    F.CreateBDFrame(frame.CategoryList, 0.25):SetInside()
    hooksecurefunc(frame.CategoryList.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                if child.Background then
                    child.Background:SetAlpha(0)
                    local line = child:CreateTexture(nil, 'ARTWORK')
                    line:SetPoint('BOTTOMRIGHT', child, -15, 3)
                    line:SetAtlas('Options_HorizontalDivider')
                    line:SetSize(170, C.Mult)
                end

                local toggle = child.Toggle
                if toggle then
                    F.ReskinCollapse(toggle)
                    toggle:GetPushedTexture():SetAlpha(0)
                    toggle.bg:SetPoint('TOPLEFT', 2, -4)
                end

                child.styled = true
            end
        end
    end)

    F.CreateBDFrame(frame.Container, 0.25):SetInside()
    F.Reskin(frame.Container.SettingsList.Header.DefaultsButton)
    F.ReskinTrimScroll(frame.Container.SettingsList.ScrollBar, true)

    local function ReskinDropDownArrow(button, direction)
        button.NormalTexture:SetAlpha(0)
        button.PushedTexture:SetAlpha(0)
        button:GetHighlightTexture():SetAlpha(0)

        local dis = button:GetDisabledTexture()
        F.SetupArrow(dis, direction)
        dis:SetVertexColor(0, 0, 0, 0.7)
        dis:SetDrawLayer('OVERLAY')
        dis:SetInside(button, 4, 4)

        local tex = button:CreateTexture(nil, 'ARTWORK')
        tex:SetInside(button, 4, 4)
        F.SetupArrow(tex, direction)
        button.__texture = tex
        button:HookScript('OnEnter', F.Texture_OnEnter)
        button:HookScript('OnLeave', F.Texture_OnLeave)
    end

    local function ReskinOptionDropDown(option)
        local button = option.Button
        F.Reskin(button)
        button.__bg:SetInside(button, 6, 6)
        button.NormalTexture:SetAlpha(0)
        button.HighlightTexture:SetAlpha(0)

        ReskinDropDownArrow(option.DecrementButton, 'left')
        ReskinDropDownArrow(option.IncrementButton, 'right')
    end

    local function UpdateKeybindButtons(self)
        if not self.bindingsPool then
            return
        end
        for panel in self.bindingsPool:EnumerateActive() do
            if not panel.styled then
                F.Reskin(panel.Button1)
                F.Reskin(panel.Button2)
                if panel.CustomButton then
                    F.Reskin(panel.CustomButton)
                end
                panel.styled = true
            end
        end
    end

    local function UpdateHeaderExpand(self, expanded)
        local atlas = expanded and 'Soulbinds_Collection_CategoryHeader_Collapse' or 'Soulbinds_Collection_CategoryHeader_Expand'
        self.__texture:SetAtlas(atlas, true)

        UpdateKeybindButtons(self)
    end

    local function forceSaturation(self)
        self.CheckBox:DesaturateHierarchy(1)
    end

    hooksecurefunc(frame.Container.SettingsList.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                if child.CheckBox then
                    F.ReskinCheckbox(child.CheckBox)
                    child.CheckBox.bg:SetInside(nil, 6, 6)
                    hooksecurefunc(child, 'DesaturateHierarchy', forceSaturation)
                end
                if child.DropDown then
                    ReskinOptionDropDown(child.DropDown)
                end
                if child.ColorBlindFilterDropDown then
                    ReskinOptionDropDown(child.ColorBlindFilterDropDown)
                end
                for j = 1, 13 do
                    local control = child['Control' .. j]
                    if control then
                        if control.DropDown then
                            ReskinOptionDropDown(control.DropDown)
                        end
                    end
                end
                if child.Button then
                    if child.Button:GetWidth() < 250 then
                        F.Reskin(child.Button)
                    else
                        F.StripTextures(child.Button)
                        child.Button.Right:SetAlpha(0)
                        local bg = F.CreateBDFrame(child.Button, 0.25)
                        bg:SetPoint('TOPLEFT', 2, -1)
                        bg:SetPoint('BOTTOMRIGHT', -2, 3)
                        local hl = child.Button:CreateTexture(nil, 'HIGHLIGHT')
                        hl:SetColorTexture(C.r, C.g, C.b, 0.25)
                        hl:SetInside(bg)
                        hl:SetBlendMode('ADD')

                        child.__texture = bg:CreateTexture(nil, 'OVERLAY')
                        child.__texture:SetPoint('RIGHT', -10, 0)
                        UpdateHeaderExpand(child, false)
                        hooksecurefunc(child, 'EvaluateVisibility', UpdateHeaderExpand)
                    end
                end
                if child.ToggleTest then
                    F.Reskin(child.ToggleTest)
                    F.StripTextures(child.VUMeter)
                    local bg = F.CreateBDFrame(child.VUMeter, 0.3)
                    bg:SetInside(nil, 4, 4)
                    child.VUMeter.Status:SetStatusBarTexture(C.Assets.Textures.Backdrop)
                    child.VUMeter.Status:SetInside(bg)
                end
                if child.PushToTalkKeybindButton then
                    F.Reskin(child.PushToTalkKeybindButton)
                end
                if child.SliderWithSteppers then
                    F.ReskinStepperSlider(child.SliderWithSteppers)
                end
                if child.Button1 and child.Button2 then
                    F.Reskin(child.Button1)
                    F.Reskin(child.Button2)
                end

                child.styled = true
            end
        end
    end)

    local CUFPanels = {
        'CompactUnitFrameProfiles',
        'CompactUnitFrameProfilesGeneralOptionsFrame',
    }
    for _, name in pairs(CUFPanels) do
        local frame = _G[name]
        if frame then
            for i = 1, frame:GetNumChildren() do
                local child = select(i, frame:GetChildren())
                if child:IsObjectType('CheckButton') then
                    F.ReskinCheckbox(child)
                elseif child:IsObjectType('Button') then
                    F.Reskin(child)
                elseif child:IsObjectType('Frame') and child.Left and child.Middle and child.Right then
                    F.ReskinDropDown(child)
                end
            end
        end
    end
    if _G.CompactUnitFrameProfilesSeparator then
        _G.CompactUnitFrameProfilesSeparator:SetAtlas('Options_HorizontalDivider')
    end
    if _G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG then
        _G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()
        F.CreateBDFrame(_G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG, 0.25)
    end
end)
