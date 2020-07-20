local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not C.Theme.reskin_blizz then return end

    local r, g, b = C.r, C.g, C.b

	F.StripTextures(HelpFrame)
	F.SetBD(HelpFrame)
	F.StripTextures(HelpFrame.Header)
    F.ReskinClose(HelpFrameCloseButton)

	F.StripTextures(HelpFrameMainInset)
	F.StripTextures(HelpFrameLeftInset)
	F.StripTextures(HelpBrowser.BrowserInset)

	F.CreateBDFrame(HelpFrameGM_ResponseScrollFrame1, .25)
	F.CreateBDFrame(HelpFrameGM_ResponseScrollFrame2, .25)
	F.CreateBDFrame(HelpFrameReportBugScrollFrame, .25)
	F.CreateBDFrame(HelpFrameSubmitSuggestionScrollFrame, .25)
	F.StripTextures(ReportCheatingDialogCommentFrame)
	F.CreateBDFrame(ReportCheatingDialogCommentFrame, .25)

	local scrolls = {
		"HelpFrameKnowledgebaseScrollFrameScrollBar",
		"HelpFrameReportBugScrollFrameScrollBar",
		"HelpFrameSubmitSuggestionScrollFrameScrollBar",
		"HelpFrameGM_ResponseScrollFrame1ScrollBar",
		"HelpFrameGM_ResponseScrollFrame2ScrollBar",
		"HelpFrameKnowledgebaseScrollFrame2ScrollBar",
	}
	for _, scroll in next, scrolls do
		F.ReskinScroll(_G[scroll])
	end

	local buttons = {
		"HelpFrameAccountSecurityOpenTicket",
		"HelpFrameCharacterStuckStuck",
		"HelpFrameOpenTicketHelpOpenTicket",
		"HelpFrameKnowledgebaseSearchButton",
		"HelpFrameGM_ResponseNeedMoreHelp",
		"HelpFrameGM_ResponseCancel",
		"HelpFrameReportBugSubmit",
		"HelpFrameSubmitSuggestionSubmit"
	}
	for _, button in next, buttons do
		F.Reskin(_G[button])
	end

	F.StripTextures(HelpFrameKnowledgebase)
	F.ReskinInput(HelpFrameKnowledgebaseSearchBox)

	select(3, HelpFrameReportBug:GetChildren()):Hide()
	select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
	select(5, HelpFrameGM_Response:GetChildren()):Hide()
	select(6, HelpFrameGM_Response:GetChildren()):Hide()
	HelpFrameReportBugScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameReportBugScrollFrame, "TOPRIGHT", 1, -16)
	HelpFrameSubmitSuggestionScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 1, -16)
	HelpFrameGM_ResponseScrollFrame1ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
	HelpFrameGM_ResponseScrollFrame2ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)

	for i = 1, 15 do
		local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
		bu:DisableDrawLayer("ARTWORK")
		F.CreateBD(bu, 0)
		F.CreateGradient(bu)
	end

	local function colourTab(f)
		f.text:SetTextColor(1, 1, 1)
	end

	local function clearTab(f)
		f.text:SetTextColor(1, .8, 0)
	end

	local function styleTab(bu)
		bu.selected:SetColorTexture(r, g, b, .2)
		bu.selected:SetDrawLayer("BACKGROUND")
		bu.text:SetFont(C.Assets.Fonts.Normal, 14, "OUTLINE")
		F.Reskin(bu, true)
		bu:SetScript("OnEnter", colourTab)
		bu:SetScript("OnLeave", clearTab)
	end

	for i = 1, 6 do
		styleTab(_G["HelpFrameButton"..i])
	end
	styleTab(HelpFrameButton16)

	HelpFrameAccountSecurityOpenTicket.text:SetFont(C.Assets.Fonts.Normal, 14, "OUTLINE")
	HelpFrameOpenTicketHelpOpenTicket.text:SetFont(C.Assets.Fonts.Normal, 14, "OUTLINE")

	HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
	F.ReskinIcon(HelpFrameCharacterStuckHearthstone.IconTexture)

	F.Reskin(HelpBrowserNavHome)
	F.Reskin(HelpBrowserNavReload)
	F.Reskin(HelpBrowserNavStop)
	F.Reskin(HelpBrowserBrowserSettings)
	F.ReskinArrow(HelpBrowserNavBack, "left")
	F.ReskinArrow(HelpBrowserNavForward, "right")

	HelpBrowserNavHome:SetSize(18, 18)
	HelpBrowserNavReload:SetSize(18, 18)
	HelpBrowserNavStop:SetSize(18, 18)
	HelpBrowserBrowserSettings:SetSize(18, 18)

	HelpBrowserNavHome:SetPoint("BOTTOMLEFT", HelpBrowser, "TOPLEFT", 2, 4)
	HelpBrowserBrowserSettings:SetPoint("TOPRIGHT", HelpFrameCloseButton, "BOTTOMLEFT", -4, -1)
	LoadingIcon:ClearAllPoints()
	LoadingIcon:SetPoint("LEFT", HelpBrowserNavStop, "RIGHT")

	F.StripTextures(BrowserSettingsTooltip)
	F.SetBD(BrowserSettingsTooltip)
	F.Reskin(BrowserSettingsTooltip.CookiesButton)
	F.Reskin(ReportCheatingDialogReportButton)
	F.Reskin(ReportCheatingDialogCancelButton)

	F.StripTextures(TicketStatusFrameButton)
	F.SetBD(TicketStatusFrameButton)
	F.SetBD(ReportCheatingDialog)
	ReportCheatingDialog.Border:Hide()
end)