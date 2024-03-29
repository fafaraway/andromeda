local F, C = unpack(select(2, ...))

local function reskinTalentFrameDialog(dialog)
    F.StripTextures(dialog)
    F.SetBD(dialog)
    if dialog.AcceptButton then
        F.ReskinButton(dialog.AcceptButton)
    end
    if dialog.CancelButton then
        F.ReskinButton(dialog.CancelButton)
    end
    if dialog.DeleteButton then
        F.ReskinButton(dialog.DeleteButton)
    end

    F.ReskinEditbox(dialog.NameControl.EditBox)
    dialog.NameControl.EditBox.__bg:SetPoint('TOPLEFT', -5, -10)
    dialog.NameControl.EditBox.__bg:SetPoint('BOTTOMRIGHT', 5, 10)
end

C.Themes['Blizzard_ClassTalentUI'] = function()
    local frame = _G.ClassTalentFrame
    frame.TalentsTab.Background:SetAlpha(0.4)
    frame.TalentsTab.BlackBG:SetAlpha(0)
    frame.TalentsTab.BottomBar:SetAlpha(0)
    frame.SpecTab.Background:SetAlpha(0.4)
    frame.SpecTab.BlackBG:SetAlpha(0)

    F.ReskinPortraitFrame(frame)
    F.ReskinButton(frame.TalentsTab.ApplyButton)
    F.ReskinDropdown(frame.TalentsTab.LoadoutDropDown.DropDownControl.DropDownMenu)
    F.ReskinButton(frame.TalentsTab.InspectCopyButton)
    F.ReskinEditbox(frame.TalentsTab.SearchBox)
    frame.TalentsTab.SearchBox.__bg:SetPoint('TOPLEFT', -4, -5)
    frame.TalentsTab.SearchBox.__bg:SetPoint('BOTTOMRIGHT', 0, 5)

    for i = 1, 2 do
        local tab = select(i, frame.TabSystem:GetChildren())
        F.ReskinTab(tab)
    end

    hooksecurefunc(frame.SpecTab, 'UpdateSpecFrame', function(self)
        for specContentFrame in self.SpecContentFramePool:EnumerateActive() do
            if not specContentFrame.styled then
                F.ReskinButton(specContentFrame.ActivateButton)

                local role = GetSpecializationRole(specContentFrame.specIndex)
                if role then
                    F.ReskinSmallRole(specContentFrame.RoleIcon, role)
                end

                if specContentFrame.SpellButtonPool then
                    for button in specContentFrame.SpellButtonPool:EnumerateActive() do
                        button.Ring:Hide()
                        F.ReskinIcon(button.Icon)
                    end
                end

                specContentFrame.styled = true
            end
        end
    end)

    local dialog = _G.ClassTalentLoadoutImportDialog
    if dialog then
        reskinTalentFrameDialog(dialog)

        F.StripTextures(dialog.ImportControl.InputContainer)
        F.CreateBDFrame(dialog.ImportControl.InputContainer, 0.25)
    end

    local cd = _G.ClassTalentLoadoutCreateDialog
    if cd then
        reskinTalentFrameDialog(cd)
    end

    local ed = _G.ClassTalentLoadoutEditDialog
    if ed then
        reskinTalentFrameDialog(ed)

        local editbox = ed.LoadoutName
        if editbox then
            F.ReskinEditbox(editbox)
            editbox.__bg:SetPoint('TOPLEFT', -5, -5)
            editbox.__bg:SetPoint('BOTTOMRIGHT', 5, 5)
        end

        local check = ed.UsesSharedActionBars
        if check then
            F.ReskinCheckbox(check.CheckButton)
            check.CheckButton.bg:SetInside(nil, 6, 6)
        end
    end
end
