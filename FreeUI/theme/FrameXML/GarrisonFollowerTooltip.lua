local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	local function restyleGarrisonFollowerTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		F.CreateBD(frame)
		F.CreateSD(frame)
	end

	local function restyleGarrisonFollowerAbilityTooltipTemplate(frame)
		for i = 1, 9 do
			select(i, frame:GetRegions()):Hide()
		end

		local icon = frame.Icon

		icon:SetTexCoord(unpack(C.TexCoord))
		F.CreateBG(icon)

		F.CreateBD(frame)
		F.CreateSD(frame)
	end

	restyleGarrisonFollowerTooltipTemplate(GarrisonFollowerTooltip)
	restyleGarrisonFollowerAbilityTooltipTemplate(GarrisonFollowerAbilityTooltip)

	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonFollowerTooltip)
	F.ReskinClose(FloatingGarrisonFollowerTooltip.CloseButton)

	restyleGarrisonFollowerAbilityTooltipTemplate(FloatingGarrisonFollowerAbilityTooltip)
	F.ReskinClose(FloatingGarrisonFollowerAbilityTooltip.CloseButton)

	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonShipyardFollowerTooltip)
	F.ReskinClose(FloatingGarrisonShipyardFollowerTooltip.CloseButton)

	hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(tooltipFrame)
		-- Abilities

		if tooltipFrame.numAbilitiesStyled == nil then
			tooltipFrame.numAbilitiesStyled = 1
		end

		local numAbilitiesStyled = tooltipFrame.numAbilitiesStyled

		local abilities = tooltipFrame.Abilities

		local ability = abilities[numAbilitiesStyled]
		while ability do
			local icon = ability.Icon

			icon:SetTexCoord(unpack(C.TexCoord))
			F.CreateBG(icon)

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
			local icon = trait.Icon

			icon:SetTexCoord(unpack(C.TexCoord))
			F.CreateBG(icon)

			numTraitsStyled = numTraitsStyled + 1
			trait = traits[numTraitsStyled]
		end

		tooltipFrame.numTraitsStyled = numTraitsStyled
	end)
	
	-- Mission tooltip
	
	restyleGarrisonFollowerTooltipTemplate(FloatingGarrisonMissionTooltip)
	F.ReskinClose(FloatingGarrisonMissionTooltip.CloseButton)
end)