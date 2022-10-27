local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    F.StripTextures(_G.HelpFrame)
    F.SetBD(_G.HelpFrame)
    if C.IS_NEW_PATCH then
        F.ReskinClose(_G.HelpFrame.CloseButton)
    else
        F.ReskinClose(_G.HelpFrameCloseButton)
    end
    F.StripTextures(_G.HelpBrowser.BrowserInset)

    F.StripTextures(_G.BrowserSettingsTooltip)
    F.SetBD(_G.BrowserSettingsTooltip)
    F.Reskin(_G.BrowserSettingsTooltip.CookiesButton)

    F.StripTextures(_G.TicketStatusFrameButton)
    F.SetBD(_G.TicketStatusFrameButton)

    F.SetBD(_G.ReportCheatingDialog)
    _G.ReportCheatingDialog.Border:Hide()
    F.Reskin(_G.ReportCheatingDialogReportButton)
    F.Reskin(_G.ReportCheatingDialogCancelButton)
    F.StripTextures(_G.ReportCheatingDialogCommentFrame)
    F.CreateBDFrame(_G.ReportCheatingDialogCommentFrame, 0.25)
end)
