local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	GameMenuFrameHeader:SetAlpha(0)
	GameMenuFrameHeader:ClearAllPoints()
	GameMenuFrameHeader:SetPoint("TOP", GameMenuFrame, 0, 7)
	F.StripTextures(GameMenuFrame)
	F.SetBD(GameMenuFrame, 0, 0, -1, 0)
	--F.CreateSD(GameMenuFrame)

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