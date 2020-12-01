local F, C = unpack(select(2, ...))

--/run LoadAddOn"Blizzard_ChromieTimeUI" ChromieTimeFrame:Show()
C.Themes["Blizzard_ChromieTimeUI"] = function()
	local frame = ChromieTimeFrame

	F.StripTextures(frame)
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	F.Reskin(frame.SelectButton)

	local header = frame.Title
	header:DisableDrawLayer("BACKGROUND")
	header.Text:SetFontObject(SystemFont_Huge1)
	F.CreateBDFrame(header, .25)

	frame.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(0, 0, 0)
	frame.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(0, 0, 0)
end
