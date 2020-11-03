local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.StripTextures(GameMenuFrame.Header)
	GameMenuFrame.Header:ClearAllPoints()
	GameMenuFrame.Header:SetPoint("TOP", GameMenuFrame, 0, 7)
	F.SetBD(GameMenuFrame)
	GameMenuFrame.Border:Hide()

	local buttons = {
		GameMenuButtonHelp,
		GameMenuButtonWhatsNew,
		GameMenuButtonStore,
		GameMenuButtonOptions,
		GameMenuButtonUIOptions,
		GameMenuButtonKeybindings,
		GameMenuButtonMacros,
		GameMenuButtonAddons,
		GameMenuButtonLogout,
		GameMenuButtonQuit,
		GameMenuButtonContinue
	}

	for _, button in next, buttons do
		F.Reskin(button)
	end
end)
