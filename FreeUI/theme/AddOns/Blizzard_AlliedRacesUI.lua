local F, C = unpack(select(2, ...))

C.themes["Blizzard_AlliedRacesUI"] = function()
	F.ReskinPortraitFrame(AlliedRacesFrame)
	F.SetBD(AlliedRacesFrame)
	AlliedRacesFrame.NineSlice:Hide()
	--AlliedRacesFrame.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.HeaderBackground:Hide()
	--AlliedRacesFrame.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.Title:Hide()

	F.ReskinScroll(AlliedRacesFrame.RaceInfoFrame.ScrollFrame.ScrollBar)
	select(2, AlliedRacesFrame.ModelFrame:GetRegions()):Hide()

	AlliedRacesFrame:HookScript("OnShow", function(self)
		local parent = self.RaceInfoFrame.ScrollFrame.Child
		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())

			if bu.Icon and not bu.styled then
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				select(3, bu:GetRegions()):Hide()
				F.CreateBG(bu.Icon)

				bu.styled = true
			end

			if bu.Bullet and not bu.styled then
				bu.Text:SetTextColor(1, .8, 0)

				bu.styled = true
			end
		end
	end)
end