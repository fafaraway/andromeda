local F, C = unpack(select(2, ...))

C.Themes['Blizzard_MacroUI'] = function()
    _G.MacroHorizontalBarLeft:Hide()
    F.StripTextures(_G.MacroFrameTab1)
    F.StripTextures(_G.MacroFrameTab2)

    F.StripTextures(_G.MacroPopupFrame)
    F.StripTextures(_G.MacroPopupFrame.BorderBox)
    F.StripTextures(_G.MacroPopupScrollFrame)
    _G.MacroFrameTextBackground:HideBackdrop()

    _G.MacroPopupFrame:SetHeight(525)
    _G.MacroNewButton:ClearAllPoints()
    _G.MacroNewButton:SetPoint('RIGHT', _G.MacroExitButton, 'LEFT', -1, 0)

    local function reskinMacroButton(button)
        if button.styled then
            return
        end

        button:DisableDrawLayer('BACKGROUND')
        button:SetCheckedTexture(C.Assets.button_checked)
        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, .25)
        hl:SetInside()

        local icon = _G[button:GetName() .. 'Icon']
        icon:SetTexCoord(unpack(C.TexCoord))
        icon:SetInside()
        F.CreateBDFrame(icon, .25)

        button.styled = true
    end

    reskinMacroButton(_G.MacroFrameSelectedMacroButton)

    for i = 1, _G.MAX_ACCOUNT_MACROS do
        reskinMacroButton(_G['MacroButton' .. i])
    end

    _G.MacroPopupFrame:HookScript(
        'OnShow',
        function(self)
            for i = 1, _G.NUM_MACRO_ICONS_SHOWN do
                reskinMacroButton(_G['MacroPopupButton' .. i])
            end
            self:SetPoint('TOPLEFT', _G.MacroFrame, 'TOPRIGHT', 3, 0)
        end
    )

    F.ReskinPortraitFrame(_G.MacroFrame)
    F.CreateBDFrame(_G.MacroFrameScrollFrame, .25)
    F.SetBD(_G.MacroPopupFrame)
    _G.MacroPopupEditBox:DisableDrawLayer('BACKGROUND')
    F.ReskinInput(_G.MacroPopupEditBox)
    F.Reskin(_G.MacroDeleteButton)
    F.Reskin(_G.MacroNewButton)
    F.Reskin(_G.MacroExitButton)
    F.Reskin(_G.MacroEditButton)
    F.Reskin(_G.MacroPopupFrame.BorderBox.OkayButton)
    F.Reskin(_G.MacroPopupFrame.BorderBox.CancelButton)
    F.Reskin(_G.MacroSaveButton)
    F.Reskin(_G.MacroCancelButton)
    F.ReskinScroll(_G.MacroButtonScrollFrameScrollBar)
    F.ReskinScroll(_G.MacroFrameScrollFrameScrollBar)
    F.ReskinScroll(_G.MacroPopupScrollFrameScrollBar)
end
