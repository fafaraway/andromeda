local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local frame = _G.SettingsPanel

    F.StripTextures(frame)
    F.SetBD(frame)
    F.ReskinClose(frame.ClosePanelButton)
    F.ReskinEditbox(frame.SearchBox)
    F.ReskinButton(frame.ApplyButton)
    F.ReskinButton(frame.CloseButton)

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

    local clBg = F.CreateBDFrame(frame.CategoryList, 0.25)
    clBg:SetInside()
    clBg:SetPoint('TOPLEFT', 1, 6)

    hooksecurefunc(frame.CategoryList.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                if child.Background then
                    child.Background:SetAlpha(0)
                    local line = child:CreateTexture(nil, 'ARTWORK')
                    line:SetPoint('BOTTOMRIGHT', child, -15, 3)
                    line:SetAtlas('Options_HorizontalDivider')
                    line:SetSize(170, C.MULT)
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

    local cBg = F.CreateBDFrame(frame.Container, 0.25)
    cBg:SetInside()
    cBg:SetPoint('TOPLEFT', 1, 6)
    F.ReskinButton(frame.Container.SettingsList.Header.DefaultsButton)
    F.ReskinTrimScroll(frame.Container.SettingsList.ScrollBar)

    local function ReskinDropdownArrow(button, direction)
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
        F.ReskinButton(button)
        button.__bg:SetInside(button, 6, 6)
        button.NormalTexture:SetAlpha(0)
        button.HighlightTexture:SetAlpha(0)

        ReskinDropdownArrow(option.DecrementButton, 'left')
        ReskinDropdownArrow(option.IncrementButton, 'right')
    end

    local function UpdateKeybindButtons(self)
        if not self.bindingsPool then
            return
        end

        for panel in self.bindingsPool:EnumerateActive() do
            if not panel.styled then
                F.ReskinButton(panel.Button1)
                F.ReskinButton(panel.Button2)
                if panel.CustomButton then
                    F.ReskinButton(panel.CustomButton)
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

    local function ReskinControlsGroup(controls)
        for i = 1, controls:GetNumChildren() do
            local element = select(i, controls:GetChildren())
            if element.SliderWithSteppers then
                F.ReskinStepperSlider(element.SliderWithSteppers)
            end

            if element.DropDown then
                ReskinOptionDropDown(element.DropDown)
            end

            if element.CheckBox then
                F.ReskinCheckbox(element.CheckBox)
                element.CheckBox.bg:SetInside(nil, 6, 6)

                hooksecurefunc(element, 'DesaturateHierarchy', forceSaturation)
            end
        end
    end

    hooksecurefunc(frame.Container.SettingsList.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                if child.NineSlice then
                    child.NineSlice:SetAlpha(0)

                    local bg = F.CreateBDFrame(child, 0.25)
                    bg:SetPoint('TOPLEFT', 15, -30)
                    bg:SetPoint('BOTTOMRIGHT', -30, -5)
                end

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
                        F.ReskinButton(child.Button)
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
                    F.ReskinButton(child.ToggleTest)
                    F.StripTextures(child.VUMeter)
                    local bg = F.CreateBDFrame(child.VUMeter, 0.3)
                    bg:SetInside(nil, 4, 4)
                    child.VUMeter.Status:SetStatusBarTexture(C.Assets.Textures.Backdrop)
                    child.VUMeter.Status:SetInside(bg)
                end

                if child.PushToTalkKeybindButton then
                    F.ReskinButton(child.PushToTalkKeybindButton)
                end

                if child.SliderWithSteppers then
                    F.ReskinStepperSlider(child.SliderWithSteppers)
                end

                if child.Button1 and child.Button2 then
                    F.ReskinButton(child.Button1)
                    F.ReskinButton(child.Button2)
                end

                if child.Controls then
                    for i = 1, #child.Controls do
                        local control = child.Controls[i]
                        if control.SliderWithSteppers then
                            F.ReskinStepperSlider(control.SliderWithSteppers)
                        end
                    end
                end

                if child.BaseTab then
                    F.StripTextures(child.BaseTab, 0)
                end

                if child.RaidTab then
                    F.StripTextures(child.RaidTab, 0)
                end

                if child.BaseQualityControls then
                    ReskinControlsGroup(child.BaseQualityControls)
                end

                if child.RaidQualityControls then
                    ReskinControlsGroup(child.RaidQualityControls)
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
                    F.ReskinButton(child)
                elseif child:IsObjectType('Frame') and child.Left and child.Middle and child.Right then
                    F.ReskinDropdown(child)
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
