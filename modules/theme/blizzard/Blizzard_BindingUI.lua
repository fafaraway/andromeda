local F, C = unpack(select(2, ...))

C.Themes["Blizzard_BindingUI"] = function()
	local r, g, b = C.r, C.g, C.b

	local KeyBindingFrame = KeyBindingFrame

	F.StripTextures(KeyBindingFrame.Header)
	F.StripTextures(KeyBindingFrame.categoryList)
	KeyBindingFrame.bindingsContainer:SetBackdrop(nil)

	F.StripTextures(KeyBindingFrame)
	F.SetBD(KeyBindingFrame)
	F.Reskin(KeyBindingFrame.defaultsButton)
	F.Reskin(KeyBindingFrame.quickKeybindButton)
	F.Reskin(KeyBindingFrame.unbindButton)
	F.Reskin(KeyBindingFrame.okayButton)
	F.Reskin(KeyBindingFrame.cancelButton)
	F.ReskinCheck(KeyBindingFrame.characterSpecificButton)
	F.ReskinScroll(KeyBindingFrameScrollFrameScrollBar)

	for i = 1, KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]
		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)
	end

	hooksecurefunc("BindingButtonTemplate_SetupBindingButton", function(_, button)
		if not button.styled then
			local selected = button.selectedHighlight
			selected:SetTexture(C.Assets.bd_tex)
			selected:SetInside()
			selected:SetColorTexture(r, g, b, .25)
			F.Reskin(button)

			button.styled = true
		end
	end)

	local line = KeyBindingFrame:CreateTexture(nil, "ARTWORK")
	line:SetSize(C.Mult, 546)
	line:SetPoint("LEFT", 205, 10)
	line:SetColorTexture(1, 1, 1, .25)

	-- QuickKeybindFrame

	local frame = QuickKeybindFrame
	F.StripTextures(frame)
	F.StripTextures(frame.Header)
	F.SetBD(frame)
	F.ReskinCheck(frame.characterSpecificButton)
	frame.characterSpecificButton:SetSize(24, 24)
	F.Reskin(frame.okayButton)
	F.Reskin(frame.defaultsButton)
	F.Reskin(frame.cancelButton)
end
