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
    F.ReskinPortraitFrame(MacroFrame)
    F.CreateBDFrame(_G.MacroFrameScrollFrame, 0.25)
    if C.IS_NEW_PATCH_10_1 then
        F.ReskinTrimScroll(_G.MacroFrameScrollFrame.ScrollBar)
    else
        F.ReskinScroll(_G.MacroFrameScrollFrameScrollBar)
    end
    F.ReskinButton(_G.MacroDeleteButton)
    F.ReskinButton(_G.MacroNewButton)
    F.ReskinButton(_G.MacroExitButton)
    F.ReskinButton(_G.MacroEditButton)
    F.ReskinButton(_G.MacroSaveButton)
    F.ReskinButton(_G.MacroCancelButton)
end
