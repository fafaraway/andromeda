local F, C = unpack(select(2, ...))

local function ResetToggleTexture(button, texture)
    button:GetNormalTexture():SetTexCoord(unpack(C.TEX_COORD))
    button:GetNormalTexture():SetInside()
    button:SetNormalTexture(texture)
    button:GetPushedTexture():SetTexCoord(unpack(C.TEX_COORD))
    button:GetPushedTexture():SetInside()
    button:SetPushedTexture(texture)
end

table.insert(
    C.BlizzThemes,
    function()
        -- Dressup Frame

        local DressUpFrame = _G.DressUpFrame

        F.ReskinPortraitFrame(DressUpFrame)
        F.Reskin(_G.DressUpFrameOutfitDropDown.SaveButton)
        F.Reskin(_G.DressUpFrameCancelButton)
        F.Reskin(_G.DressUpFrameResetButton)
        F.StripTextures(_G.DressUpFrameOutfitDropDown)
        F.ReskinDropDown(_G.DressUpFrameOutfitDropDown)
        F.ReskinMinMax(DressUpFrame.MaximizeMinimizeFrame)

        F.Reskin(DressUpFrame.LinkButton)
        F.Reskin(DressUpFrame.ToggleOutfitDetailsButton)
        ResetToggleTexture(DressUpFrame.ToggleOutfitDetailsButton, 1392954) -- 70_professions_scroll_01

        F.StripTextures(DressUpFrame.OutfitDetailsPanel)
        local bg = F.SetBD(DressUpFrame.OutfitDetailsPanel)
        bg:SetInside(nil, 11, 11)

        hooksecurefunc(
            DressUpFrame.OutfitDetailsPanel,
            'Refresh',
            function(self)
                if self.slotPool then
                    for slot in self.slotPool:EnumerateActive() do
                        if not slot.bg then
                            slot.bg = F.ReskinIcon(slot.Icon)
                            F.ReskinIconBorder(slot.IconBorder, true, true)
                        end
                    end
                end
            end
        )

        _G.DressUpFrameOutfitDropDown:SetHeight(32)
        _G.DressUpFrameOutfitDropDown.SaveButton:SetPoint('LEFT', _G.DressUpFrameOutfitDropDown, 'RIGHT', -13, 2)
        _G.DressUpFrameResetButton:SetPoint('RIGHT', _G.DressUpFrameCancelButton, 'LEFT', -1, 0)

        DressUpFrame.ModelBackground:Hide()
        F.CreateBDFrame(DressUpFrame.ModelScene)

        F.ReskinCheck(_G.TransmogAndMountDressupFrame.ShowMountCheckButton)

        -- SideDressUp

        F.StripTextures(_G.SideDressUpFrame, 0)
        F.SetBD(_G.SideDressUpFrame)
        F.Reskin(_G.SideDressUpFrame.ResetButton)
        F.ReskinClose(_G.SideDressUpFrameCloseButton)

        _G.SideDressUpFrame:HookScript(
            'OnShow',
            function(self)
                _G.SideDressUpFrame:ClearAllPoints()
                _G.SideDressUpFrame:SetPoint('LEFT', self:GetParent(), 'RIGHT', 3, 0)
            end
        )

        -- Outfit frame

        F.StripTextures(_G.WardrobeOutfitFrame)
        F.SetBD(_G.WardrobeOutfitFrame, .7)

        hooksecurefunc(
            _G.WardrobeOutfitFrame,
            'Update',
            function(self)
                for i = 1, C_TransmogCollection.GetNumMaxOutfits() do
                    local button = self.Buttons[i]
                    if button and button:IsShown() and not button.styled then
                        F.ReskinIcon(button.Icon)
                        button.Selection:SetColorTexture(1, 1, 1, .25)
                        button.Highlight:SetColorTexture(C.r, C.g, C.b, .25)

                        button.styled = true
                    end
                end
            end
        )

        F.StripTextures(_G.WardrobeOutfitEditFrame)
        _G.WardrobeOutfitEditFrame.EditBox:DisableDrawLayer('BACKGROUND')
        F.SetBD(_G.WardrobeOutfitEditFrame)
        local bg = F.CreateBDFrame(_G.WardrobeOutfitEditFrame.EditBox, .25, true)
        bg:SetPoint('TOPLEFT', -5, -3)
        bg:SetPoint('BOTTOMRIGHT', 5, 3)
        F.Reskin(_G.WardrobeOutfitEditFrame.AcceptButton)
        F.Reskin(_G.WardrobeOutfitEditFrame.CancelButton)
        F.Reskin(_G.WardrobeOutfitEditFrame.DeleteButton)
    end
)
