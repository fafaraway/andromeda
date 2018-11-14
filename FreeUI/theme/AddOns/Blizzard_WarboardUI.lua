local F, C = unpack(select(2, ...))

C.themes["Blizzard_WarboardUI"] = function()
	local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame
	F.ReskinClose(WarboardQuestChoiceFrame.CloseButton)

	WarboardQuestChoiceFrame.Background:Hide()
	WarboardQuestChoiceFrame.Title.Left:Hide()
	WarboardQuestChoiceFrame.Title.Right:Hide()
	WarboardQuestChoiceFrame.Title.Middle:Hide()
	WarboardQuestChoiceFrame.BorderFrame:Hide()

	_G.WarboardQuestChoiceFrameTopRightCorner:Hide()
	WarboardQuestChoiceFrame.topLeftCorner:Hide()
	WarboardQuestChoiceFrame.topBorderBar:Hide()
	_G.WarboardQuestChoiceFrameBotRightCorner:Hide()
	_G.WarboardQuestChoiceFrameBotLeftCorner:Hide()
	_G.WarboardQuestChoiceFrameBottomBorder:Hide()
	WarboardQuestChoiceFrame.leftBorderBar:Hide()
	_G.WarboardQuestChoiceFrameRightBorder:Hide()

	F.CreateBD(WarboardQuestChoiceFrame)
	F.CreateSD(WarboardQuestChoiceFrame)
 
	hooksecurefunc(WarboardQuestChoiceFrame, "Update", function(self)
		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			option.OptionText:SetTextColor(0, 0, 0)
			option.Header.Text:SetTextColor(0, 0, 0)
			--option.Background:SetAlpha(0)
			if not option.styled then
				F.Reskin(option.OptionButtonsContainer.OptionButton1)
				for i = 1, option.WidgetContainer:GetNumChildren() do
					local child = select(i, option.WidgetContainer:GetChildren())

					if child.Text then
						child.Text:SetTextColor(0, 0, 0)
						child.Text.SetTextColor = F.Dummy
					end
					option.Header.Text:SetTextColor(0, 0, 0)
					option.Header.SetTextColor = F.Dummy
					option.OptionText:SetTextColor(0, 0, 0)
					option.OptionText.SetTextColor = F.Dummy
				end
				F.Reskin(option.OptionButtonsContainer.OptionButton1)
				F.Reskin(option.OptionButtonsContainer.OptionButton2)
				option.styled = true
			end
		end
	end)

	


end