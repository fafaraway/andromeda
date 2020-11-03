local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	-- Tooltip close buttons
	F.ReskinClose(ItemRefTooltip.CloseButton)
	F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
	F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)

	if not FREE_ADB.reskin_blizz then return end

	-- Tooltips
	function F:ReskinGarrisonTooltip()
		for i = 1, 9 do
			select(i, self:GetRegions()):Hide()
		end
		if self.Icon then F.ReskinIcon(self.Icon) end
		if self.CloseButton then F.ReskinClose(self.CloseButton) end
	end

	F.ReskinGarrisonTooltip(FloatingGarrisonMissionTooltip)
	F.ReskinGarrisonTooltip(GarrisonFollowerTooltip)
	F.ReskinGarrisonTooltip(FloatingGarrisonFollowerTooltip)
	F.ReskinGarrisonTooltip(GarrisonFollowerAbilityTooltip)
	F.ReskinGarrisonTooltip(FloatingGarrisonFollowerAbilityTooltip)
	F.ReskinGarrisonTooltip(GarrisonShipyardFollowerTooltip)
	F.ReskinGarrisonTooltip(FloatingGarrisonShipyardFollowerTooltip)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(tooltipFrame)
		-- Abilities
		if tooltipFrame.numAbilitiesStyled == nil then
			tooltipFrame.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled
		local abilities = tooltipFrame.Abilities
		local ability = abilities[numAbilitiesStyled]
		while ability do
			F.ReskinIcon(ability.Icon)

			numAbilitiesStyled = numAbilitiesStyled + 1
			ability = abilities[numAbilitiesStyled]
		end

		tooltipFrame.numAbilitiesStyled = numAbilitiesStyled

		-- Traits
		if tooltipFrame.numTraitsStyled == nil then
			tooltipFrame.numTraitsStyled = 1
		end

		local numTraitsStyled = tooltipFrame.numTraitsStyled
		local traits = tooltipFrame.Traits
		local trait = traits[numTraitsStyled]
		while trait do
			F.ReskinIcon(trait.Icon)

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end

		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)
end)
