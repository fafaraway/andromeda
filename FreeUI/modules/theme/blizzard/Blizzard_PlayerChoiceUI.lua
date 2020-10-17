local F, C = unpack(select(2, ...))

local function WhitenProgressText(self)
	if self.styled then return end

	self:SetTextColor(1, 1, 1)
	self.SetTextColor = F.Dummy
	self.styled = true
end

local function ReskinFirstOptionButton(self)
	if not self or self.__bg then return end

	F.StripTextures(self, true)
	F.Reskin(self)
end

local function ReskinSecondOptionButton(self)
	if not self or self.__bg then return end

	F.Reskin(self, nil, true)
end

C.Themes["Blizzard_PlayerChoiceUI"] = function()
	hooksecurefunc(PlayerChoiceFrame, "Update", function(self)
		if not self.bg then
			self.BlackBackground:SetAlpha(0)
			self.Background:SetAlpha(0)
			self.NineSlice:SetAlpha(0)
			self.Title:DisableDrawLayer("BACKGROUND")
			self.Title.Text:SetTextColor(1, .8, 0)
			self.Title.Text:SetFontObject(SystemFont_Huge1)
			self.BorderFrame.Header:SetAlpha(0)
			F.CreateBDFrame(self.Title, .25)
			F.ReskinClose(self.CloseButton)
			self.CloseButton.Border:SetAlpha(0)
			self.bg = F.SetBD(self)
		end

		self.CloseButton:SetPoint("TOPRIGHT", self.bg, -2, -2)
		self.bg:SetShown(not IsInJailersTower())

		for i = 1, self:GetNumOptions() do
			local option = self.Options[i]
			option.Header.Text:SetTextColor(0, 0, 0)
			option.OptionText:SetTextColor(0, 0, 0)

			for i = 1, option.WidgetContainer:GetNumChildren() do
				local child = select(i, option.WidgetContainer:GetChildren())
				if child.Text then
					child.Text:SetTextColor(0, 0, 0)
				end

				if child.Spell then
					if not child.Spell.bg then
						child.Spell.Border:SetTexture("")
						child.Spell.IconMask:Hide()
						child.Spell.bg = F.ReskinIcon(child.Spell.Icon)
					end

					child.Spell.Text:SetTextColor(0, 0, 0)
				end

				for j = 1, child:GetNumChildren() do
					local child2 = select(j, child:GetChildren())
					if child2 then
						if child2.Text then
							WhitenProgressText(child2.Text)
						end
						if child2.LeadingText then
							WhitenProgressText(child2.LeadingText)
						end
						if child2.Icon and not child2.Icon.bg then
							child2.Icon.bg = F.ReskinIcon(child2.Icon)
						end
					end
				end
			end

			ReskinFirstOptionButton(option.OptionButtonsContainer.button1)
			ReskinSecondOptionButton(option.OptionButtonsContainer.button2)
		end
	end)

	-- artifact selection
	hooksecurefunc(PlayerChoiceFrame, "SetupRewards", function(self)
		for i = 1, self.numActiveOptions do
			local optionFrameRewards = self.Options[i].RewardsFrame.Rewards
			for button in optionFrameRewards.ItemRewardsPool:EnumerateActive() do
				if not button.styled then
					button.Name:SetTextColor(0, 0, 0)
					button.IconBorder:SetAlpha(0)
					F.ReskinIcon(button.Icon)

					button.styled = true
				end
			end
		end
		--[[
			pools haven't seen yet:
			optionFrameRewards.CurrencyRewardsPool
			optionFrameRewards.ReputationRewardsPool
		]]
	end)
end
