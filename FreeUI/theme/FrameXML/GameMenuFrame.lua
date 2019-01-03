local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	GameMenuFrameHeader:SetAlpha(0)
	GameMenuFrameHeader:ClearAllPoints()
	GameMenuFrameHeader:SetPoint("TOP", GameMenuFrame, 0, 4)
	F.StripTextures(GameMenuFrame)
	F.CreateBD(GameMenuFrame)
	F.CreateSD(GameMenuFrame)

	hooksecurefunc("GameMenuFrame_UpdateVisibleButtons", function()
		if not IsAddOnLoaded("FreeUI_Options") then return end
		GameMenuFrame:SetHeight(360)
	end)

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