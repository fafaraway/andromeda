local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	F.StripTextures(ChatConfigFrame)
	F.SetBD(ChatConfigFrame)
	F.StripTextures(ChatConfigFrame.Header)

	hooksecurefunc("ChatConfig_UpdateCheckboxes", function(frame)
		if not FCF_GetCurrentChatFrame() then return end

		local nameString = frame:GetName().."CheckBox"
		for index in ipairs(frame.checkBoxTable) do
			local checkBoxName = nameString..index
			local checkbox = _G[checkBoxName]
			if checkbox and not checkbox.styled then
				checkbox:SetBackdrop(nil)
				local bg = F.CreateBDFrame(checkbox, .25)
				bg:SetInside()
				F.ReskinCheck(_G[checkBoxName.."Check"])

				checkbox.styled = true
			end
		end
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
		if frame.styled then return end

		local nameString = frame:GetName().."CheckBox"
		for index, value in ipairs(checkBoxTable) do
			local checkBoxName = nameString..index
			F.ReskinCheck(_G[checkBoxName])

			if value.subTypes then
				for i in ipairs(value.subTypes) do
					F.ReskinCheck(_G[checkBoxName.."_"..i])
				end
			end
		end

		frame.styled = true
	end)

	hooksecurefunc(ChatConfigFrameChatTabManager, "UpdateWidth", function(self)
		for tab in self.tabPool:EnumerateActive() do
			if not tab.styled then
				F.StripTextures(tab)

				tab.styled = true
			end
		end
	end)

	for i = 1, 5 do
		F.StripTextures(_G["CombatConfigTab"..i])
	end

	local line = ChatConfigFrame:CreateTexture()
	line:SetSize(C.Mult, 460)
	line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
	line:SetColorTexture(1, 1, 1, .25)

	local backdrops = {
		ChatConfigCategoryFrame,
		ChatConfigBackgroundFrame,
		ChatConfigCombatSettingsFilters,
		CombatConfigColorsHighlighting,
		CombatConfigColorsColorizeUnitName,
		CombatConfigColorsColorizeSpellNames,
		CombatConfigColorsColorizeDamageNumber,
		CombatConfigColorsColorizeDamageSchool,
		CombatConfigColorsColorizeEntireLine,
		ChatConfigChatSettingsLeft,
		ChatConfigOtherSettingsCombat,
		ChatConfigOtherSettingsPVP,
		ChatConfigOtherSettingsSystem,
		ChatConfigOtherSettingsCreature,
		ChatConfigChannelSettingsLeft,
		CombatConfigMessageSourcesDoneBy,
		CombatConfigColorsUnitColors,
		CombatConfigMessageSourcesDoneTo,
	}
	for _, frame in pairs(backdrops) do
		F.StripTextures(frame)
	end

	local combatBoxes = {
		CombatConfigColorsHighlightingLine,
		CombatConfigColorsHighlightingAbility,
		CombatConfigColorsHighlightingDamage,
		CombatConfigColorsHighlightingSchool,
		CombatConfigColorsColorizeUnitNameCheck,
		CombatConfigColorsColorizeSpellNamesCheck,
		CombatConfigColorsColorizeSpellNamesSchoolColoring,
		CombatConfigColorsColorizeDamageNumberCheck,
		CombatConfigColorsColorizeDamageNumberSchoolColoring,
		CombatConfigColorsColorizeDamageSchoolCheck,
		CombatConfigColorsColorizeEntireLineCheck,
		CombatConfigFormattingShowTimeStamp,
		CombatConfigFormattingShowBraces,
		CombatConfigFormattingUnitNames,
		CombatConfigFormattingSpellNames,
		CombatConfigFormattingItemNames,
		CombatConfigFormattingFullText,
		CombatConfigSettingsShowQuickButton,
		CombatConfigSettingsSolo,
		CombatConfigSettingsParty,
		CombatConfigSettingsRaid
	}
	for _, box in pairs(combatBoxes) do
		F.ReskinCheck(box)
	end

	local bg = F.CreateBDFrame(ChatConfigCombatSettingsFilters, .25)
	bg:SetPoint("TOPLEFT", 3, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 1)

	F.Reskin(CombatLogDefaultButton)
	F.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
	F.Reskin(CombatConfigSettingsSaveButton)
	F.Reskin(ChatConfigFrameOkayButton)
	F.Reskin(ChatConfigFrameDefaultButton)
	F.Reskin(ChatConfigFrameRedockButton)
	F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")
	F.ReskinInput(CombatConfigSettingsNameEditBox)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	F.ReskinColorSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	F.ReskinColorSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)
	F.ReskinScroll(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)

	ChatConfigMoveFilterUpButton:SetSize(22, 22)
	ChatConfigMoveFilterDownButton:SetSize(22, 22)

	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
	ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)
end)
