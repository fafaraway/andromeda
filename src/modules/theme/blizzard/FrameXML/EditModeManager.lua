local F, C = unpack(select(2, ...))

local function reskinOptionCheck(button)
    F.ReskinCheckbox(button)
    button.bg:SetInside(button, 6, 6)
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local frame = _G.EditModeManagerFrame

    F.StripTextures(frame)
    F.SetBD(frame)
    F.ReskinClose(frame.CloseButton)
    F.ReskinButton(frame.RevertAllChangesButton)
    F.ReskinButton(frame.SaveChangesButton)
    F.ReskinDropdown(frame.LayoutDropdown.DropDownMenu)
    reskinOptionCheck(frame.ShowGridCheckButton.Button)
    reskinOptionCheck(frame.EnableSnapCheckButton.Button)
    if C.IS_NEW_PATCH_10_1 then
        reskinOptionCheck(frame.EnableAdvancedOptionsCheckButton.Button)
    end
    F.ReskinStepperSlider(frame.GridSpacingSlider.Slider, true)
    if frame.Tutorial then
        frame.Tutorial.Ring:Hide()
    end

    local ssd = _G.EditModeSystemSettingsDialog
    F.StripTextures(ssd)
    F.SetBD(ssd)
    F.ReskinClose(ssd.CloseButton)

    hooksecurefunc(frame.AccountSettings, 'OnEditModeEnter', function(self)
        local settings = C.IS_NEW_PATCH_10_1 and self.SettingsContainer.ScrollChild.BasicOptionsContainer or self.Settings

        if not settings then
            return
        end

        for i = 1, settings:GetNumChildren() do
            local option = select(i, settings:GetChildren())
            if option.Button and not option.styled then
                reskinOptionCheck(option.Button)
                option.styled = true
            end
        end
    end)

    hooksecurefunc(ssd, 'UpdateExtraButtons', function(self)
        local revertButton = self.Buttons and self.Buttons.RevertChangesButton
        if revertButton and not revertButton.styled then
            F.ReskinButton(revertButton)
            revertButton.styled = true
        end

        for button in self.pools:EnumerateActiveByTemplate('EditModeSystemSettingsDialogExtraButtonTemplate') do
            if not button.styled then
                F.ReskinButton(button)
                button.styled = true
            end
        end

        for check in self.pools:EnumerateActiveByTemplate('EditModeSettingCheckboxTemplate') do
            if not check.styled then
                F.ReskinCheckbox(check.Button)
                check.Button.bg:SetInside(nil, 6, 6)
                check.styled = true
            end
        end

        for dropdown in self.pools:EnumerateActiveByTemplate('EditModeSettingDropdownTemplate') do
            if not dropdown.styled then
                F.ReskinDropdown(dropdown.Dropdown.DropDownMenu)
                dropdown.styled = true
            end
        end

        for slider in self.pools:EnumerateActiveByTemplate('EditModeSettingSliderTemplate') do
            if not slider.styled then
                F.ReskinStepperSlider(slider.Slider, true)
                slider.styled = true
            end
        end
    end)

    local ucd = _G.EditModeUnsavedChangesDialog
    F.StripTextures(ucd)
    F.SetBD(ucd)
    F.ReskinButton(ucd.SaveAndProceedButton)
    F.ReskinButton(ucd.ProceedButton)
    F.ReskinButton(ucd.CancelButton)

    local function ReskinLayoutDialog(dialog)
        F.StripTextures(dialog)
        F.SetBD(dialog)
        F.ReskinButton(dialog.AcceptButton)
        F.ReskinButton(dialog.CancelButton)

        local check = dialog.CharacterSpecificLayoutCheckButton
        if check then
            F.ReskinCheckbox(check.Button)
            check.Button.bg:SetInside(nil, 6, 6)
        end

        local editbox = dialog.LayoutNameEditBox
        if editbox then
            F.ReskinEditbox(editbox)
            editbox.__bg:SetPoint('TOPLEFT', -5, -5)
            editbox.__bg:SetPoint('BOTTOMRIGHT', 5, 5)
        end

        local importBox = dialog.ImportBox
        if importBox then
            F.StripTextures(importBox)
            F.CreateBDFrame(importBox, 0.25)
        end
    end

    ReskinLayoutDialog(_G.EditModeNewLayoutDialog)
    ReskinLayoutDialog(_G.EditModeImportLayoutDialog)
end)
