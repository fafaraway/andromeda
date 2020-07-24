local F, C = unpack(select(2, ...))

C.Themes["Blizzard_MacroUI"] = function()
	MacroHorizontalBarLeft:Hide()
	F.StripTextures(MacroFrameTab1)
	F.StripTextures(MacroFrameTab2)

	F.StripTextures(MacroPopupFrame)
	F.StripTextures(MacroPopupFrame.BorderBox)
	F.StripTextures(MacroPopupScrollFrame)
	MacroFrameTextBackground:SetBackdrop(nil)

	MacroPopupFrame:SetHeight(525)
	MacroNewButton:ClearAllPoints()
	MacroNewButton:SetPoint("RIGHT", MacroExitButton, "LEFT", -1, 0)

	local function reskinMacroButton(button)
		if button.styled then return end

		button:DisableDrawLayer("BACKGROUND")
		button:SetCheckedTexture(C.Assets.button_checked)
		local hl = button:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetInside()

		local icon = _G[button:GetName().."Icon"]
		icon:SetTexCoord(unpack(C.TexCoord))
		icon:SetInside()
		F.CreateBDFrame(icon, .25)

		button.styled = true
	end

	reskinMacroButton(MacroFrameSelectedMacroButton)

	for i = 1, MAX_ACCOUNT_MACROS do
		reskinMacroButton(_G["MacroButton"..i])
	end

	MacroPopupFrame:HookScript("OnShow", function(self)
		for i = 1, NUM_MACRO_ICONS_SHOWN do
			reskinMacroButton(_G["MacroPopupButton"..i])
		end
		self:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", 3, 0)
	end)

	F.ReskinPortraitFrame(MacroFrame)
	F.CreateBDFrame(MacroFrameScrollFrame, .25)
	F.SetBD(MacroPopupFrame)
	MacroPopupEditBox:DisableDrawLayer("BACKGROUND")
	F.ReskinInput(MacroPopupEditBox)
	F.Reskin(MacroDeleteButton)
	F.Reskin(MacroNewButton)
	F.Reskin(MacroExitButton)
	F.Reskin(MacroEditButton)
	F.Reskin(MacroPopupFrame.BorderBox.OkayButton)
	F.Reskin(MacroPopupFrame.BorderBox.CancelButton)
	F.Reskin(MacroSaveButton)
	F.Reskin(MacroCancelButton)
	F.ReskinScroll(MacroButtonScrollFrameScrollBar)
	F.ReskinScroll(MacroFrameScrollFrameScrollBar)
	F.ReskinScroll(MacroPopupScrollFrameScrollBar)
end