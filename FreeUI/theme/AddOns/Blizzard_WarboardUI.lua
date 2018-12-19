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
		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			option.OptionText:SetTextColor(0, 0, 0)
			option.Header.Text:SetTextColor(0, 0, 0)
			--option.Background:SetAlpha(0)
			if not option.styled then
				F.CreateBD(option.OptionButtonsContainer.OptionButton1)
				F.CreateBC(option.OptionButtonsContainer.OptionButton1)
				for i = 1, option.WidgetContainer:GetNumChildren() do
					local child = select(i, option.WidgetContainer:GetChildren())

					if child.Text then
						child.Text:SetTextColor(0, 0, 0)
						child.Text:SetShadowColor(0, 0, 0, 0)
						child.Text.SetTextColor = F.Dummy
					end
					option.Header.Text:SetTextColor(0, 0, 0)
					option.Header.SetTextColor = F.Dummy
					option.OptionText:SetTextColor(0, 0, 0)
					option.OptionText.SetTextColor = F.Dummy
				end
				F.CreateBD(option.OptionButtonsContainer.OptionButton1)
				F.CreateBC(option.OptionButtonsContainer.OptionButton1)
				F.CreateBD(option.OptionButtonsContainer.OptionButton2)
				F.CreateBC(option.OptionButtonsContainer.OptionButton2)
				option.styled = true
			end
		end
	end)

	


end