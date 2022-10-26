local F, C = unpack(select(2, ...))

C.Themes['Blizzard_MacroUI'] = function()
    local MacroFrame = _G.MacroFrame

    _G.MacroHorizontalBarLeft:Hide()
    F.StripTextures(_G.MacroFrameTab1)
    F.StripTextures(_G.MacroFrameTab2)

    F.StripTextures(_G.MacroPopupFrame)
    F.StripTextures(_G.MacroPopupFrame.BorderBox)
    _G.MacroFrameTextBackground:HideBackdrop()

    _G.MacroPopupFrame:SetHeight(525)
    _G.MacroNewButton:ClearAllPoints()
    _G.MacroNewButton:SetPoint('RIGHT', _G.MacroExitButton, 'LEFT', -1, 0)

    if C.IS_NEW_PATCH then
        F.ReskinTrimScroll(MacroFrame.MacroSelector.ScrollBar)

        local function handleMacroButton(button)
            local bg = F.ReskinIcon(button.Icon)
            button:DisableDrawLayer('BACKGROUND')
            button.SelectedTexture:SetColorTexture(1, 0.8, 0, 0.5)
            button.SelectedTexture:SetInside(bg)
            local hl = button:GetHighlightTexture()
            hl:SetColorTexture(1, 1, 1, 0.25)
            hl:SetInside(bg)
        end
        handleMacroButton(_G.MacroFrameSelectedMacroButton)

        hooksecurefunc(MacroFrame.MacroSelector.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local child = select(i, self.ScrollTarget:GetChildren())
                if not child.styled then
                    handleMacroButton(child)

                    child.styled = true
                end
            end
        end)

        F.ReskinIconSelector(_G.MacroPopupFrame)
    else
        local function reskinMacroButton(button)
            if button.styled then
                return
            end

            button:DisableDrawLayer('BACKGROUND')
            button:SetCheckedTexture(C.Assets.Textures.ButtonChecked)
            local hl = button:GetHighlightTexture()
            hl:SetColorTexture(1, 1, 1, 0.25)
            hl:SetInside()

            local icon = _G[button:GetName() .. 'Icon']
            icon:SetTexCoord(unpack(C.TEX_COORD))
            icon:SetInside()
            F.CreateBDFrame(icon, 0.25)

            button.styled = true
        end

        reskinMacroButton(_G.MacroFrameSelectedMacroButton)

        for i = 1, _G.MAX_ACCOUNT_MACROS do
            reskinMacroButton(_G['MacroButton' .. i])
        end

        _G.MacroPopupFrame:HookScript('OnShow', function(self)
            for i = 1, _G.NUM_MACRO_ICONS_SHOWN do
                reskinMacroButton(_G['MacroPopupButton' .. i])
            end
            self:SetPoint('TOPLEFT', MacroFrame, 'TOPRIGHT', 3, 0)
        end)

        _G.MacroPopupEditBox:DisableDrawLayer('BACKGROUND')
        F.ReskinInput(_G.MacroPopupEditBox)
        F.ReskinScroll(_G.MacroButtonScrollFrameScrollBar)
        F.ReskinScroll(_G.MacroFrameScrollFrameScrollBar)
        F.ReskinScroll(_G.MacroPopupScrollFrameScrollBar)
        F.SetBD(_G.MacroPopupFrame)
        F.Reskin(_G.MacroPopupFrame.BorderBox.OkayButton)
        F.Reskin(_G.MacroPopupFrame.BorderBox.CancelButton)
    end

    F.ReskinPortraitFrame(MacroFrame)
    F.CreateBDFrame(_G.MacroFrameScrollFrame, 0.25)
    F.Reskin(_G.MacroDeleteButton)
    F.Reskin(_G.MacroNewButton)
    F.Reskin(_G.MacroExitButton)
    F.Reskin(_G.MacroEditButton)
    F.Reskin(_G.MacroSaveButton)
    F.Reskin(_G.MacroCancelButton)
end
