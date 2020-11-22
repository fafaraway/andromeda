local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.StripTextures(HelpFrame)
	F.SetBD(HelpFrame)
	F.ReskinClose(HelpFrameCloseButton)
	F.StripTextures(HelpBrowser.BrowserInset)

	F.StripTextures(BrowserSettingsTooltip)
	F.SetBD(BrowserSettingsTooltip)
	F.Reskin(BrowserSettingsTooltip.CookiesButton)

	F.StripTextures(TicketStatusFrameButton)
	F.SetBD(TicketStatusFrameButton)

	F.SetBD(ReportCheatingDialog)
	ReportCheatingDialog.Border:Hide()
	F.Reskin(ReportCheatingDialogReportButton)
	F.Reskin(ReportCheatingDialogCancelButton)
	F.StripTextures(ReportCheatingDialogCommentFrame)
	F.CreateBDFrame(ReportCheatingDialogCommentFrame, .25)
end)
