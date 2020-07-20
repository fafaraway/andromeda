local F, C = unpack(select(2, ...))

C.Themes["Blizzard_AdventureMap"] = function()
	local dialog = AdventureMapQuestChoiceDialog

	F.StripTextures(dialog)
	F.SetBD(dialog)
	F.Reskin(dialog.AcceptButton)
	F.Reskin(dialog.DeclineButton)
	F.ReskinClose(dialog.CloseButton)
	F.ReskinScroll(dialog.Details.ScrollBar)

	dialog:HookScript("OnShow", function(self)
		if self.styled then return end

		for i = 6, 7 do
			local bu = select(i, dialog:GetChildren())
			if bu then
				F.ReskinIcon(bu.Icon)
				local bg = F.CreateBDFrame(bu.Icon, .25)
				bg:SetPoint("BOTTOMRIGHT")
				bu.ItemNameBG:Hide()
			end
		end
		dialog.Details.Child.TitleHeader:SetTextColor(1, .8, 0)
		dialog.Details.Child.ObjectivesHeader:SetTextColor(1, .8, 0)

		self.styled = true
	end)
end