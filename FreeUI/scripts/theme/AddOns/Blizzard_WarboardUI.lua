local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarboardUI"] = function()
	local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame

	F.ReskinClose(WarboardQuestChoiceFrame.CloseButton)

	WarboardQuestChoiceFrame.BorderFrame.Header:SetAlpha(0)
	WarboardQuestChoiceFrame.Background:Hide()
	WarboardQuestChoiceFrame.NineSlice:Hide()
	WarboardQuestChoiceFrame.Title.Left:Hide()
	WarboardQuestChoiceFrame.Title.Middle:Hide()
	WarboardQuestChoiceFrame.Title.Right:Hide()

	F.CreateBD(WarboardQuestChoiceFrame)
	F.CreateSD(WarboardQuestChoiceFrame)

	hooksecurefunc(WarboardQuestChoiceFrame, "Update", function(self)
		if self.CloseButton.Border then self.CloseButton.Border:SetAlpha(0) end

		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			option.OptionText:SetTextColor(0, 0, 0)
			option.Header.Text:SetTextColor(0, 0, 0)

			for i = 1, option.WidgetContainer:GetNumChildren() do
				local child = select(i, option.WidgetContainer:GetChildren())
				if child.Text then
					child.Text:SetTextColor(0, 0, 0)
				end

				if child.Spell then
					if not child.Spell.bg then
						child.Spell.Border:Hide()
						child.Spell.IconMask:Hide()
						child.Spell.bg = F.ReskinIcon(child.Spell.Icon)
					end

					child.Spell.Text:SetTextColor(0, 0, 0)
				end

				for j = 1, child:GetNumChildren() do
					local child2 = select(j, child:GetChildren())
					if child2 then
						if child2.Text then
							child2.Text:SetTextColor(0, 0, 0)
						end

						if child2.LeadingText then
							child2.LeadingText:SetTextColor(0, 0, 0)
						end

						if child2.Icon and not child2.Icon.bg then
							child2.Icon.bg = F.ReskinIcon(child2.Icon)
						end
					end
				end
			end

			if not option.styled then
				F.Reskin(option.OptionButtonsContainer.OptionButton1)
				F.Reskin(option.OptionButtonsContainer.OptionButton2)

				option.styled = true
			end
		end
	end)
end