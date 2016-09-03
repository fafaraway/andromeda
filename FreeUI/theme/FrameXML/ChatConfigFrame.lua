local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	F.CreateBD(ChatConfigFrame)

	ChatConfigFrameHeader:SetTexture("")
	ChatConfigFrameHeader:ClearAllPoints()
	ChatConfigFrameHeader:SetPoint("TOP")

	--[[ Catagories ]]
	ChatConfigCategoryFrame:SetBackdrop(nil)
	local line = ChatConfigFrame:CreateTexture()
	line:SetSize(1, 460)
	line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
	line:SetColorTexture(1, 1, 1, .2)

	ChatConfigBackgroundFrame:SetBackdrop(nil)

	--[[ Chat Settings ]]
	F.CreateBD(ChatConfigChatSettingsClassColorLegend, .25)

	--[[ Channel Settings ]]
	F.CreateBD(ChatConfigChannelSettingsClassColorLegend, .25)

	--[[ Combat Settings ]]
	ChatConfigCombatSettingsFilters:SetBackdrop(nil)

	local combatBG = CreateFrame("Frame", nil, ChatConfigCombatSettingsFilters)
	combatBG:SetPoint("TOPLEFT", 3, 0)
	combatBG:SetPoint("BOTTOMRIGHT", 0, 1)
	combatBG:SetFrameLevel(ChatConfigCombatSettingsFilters:GetFrameLevel()-1)
	F.CreateBD(combatBG, .25)

	F.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
	F.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
	F.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)

	ChatConfigMoveFilterUpButton:SetSize(28, 28)
	ChatConfigMoveFilterDownButton:SetSize(28, 28)
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
	ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)
	F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
	F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")

	for i = 1, 5 do
		_G["CombatConfigTab"..i.."Left"]:Hide()
		_G["CombatConfigTab"..i.."Middle"]:Hide()
		_G["CombatConfigTab"..i.."Right"]:Hide()
	end

	-- Combat Highlighting
	CombatConfigColorsHighlighting:SetBackdrop(nil)
	local highlightBoxes = {"CombatConfigColorsHighlightingLine", "CombatConfigColorsHighlightingAbility", "CombatConfigColorsHighlightingDamage", "CombatConfigColorsHighlightingSchool"}
	for _, box in next, highlightBoxes do
		F.ReskinCheck(_G[box])
	end

	-- Combat Colorize
	local colorizeBoxes = {"CombatConfigColorsColorizeUnitNameCheck", "CombatConfigColorsColorizeSpellNamesCheck", "CombatConfigColorsColorizeSpellNamesSchoolColoring", "CombatConfigColorsColorizeDamageNumberCheck", "CombatConfigColorsColorizeDamageNumberSchoolColoring", "CombatConfigColorsColorizeDamageSchoolCheck", "CombatConfigColorsColorizeEntireLineCheck"}
	for _, box in next, colorizeBoxes do
		F.ReskinCheck(_G[box])
	end

	CombatConfigColorsColorizeUnitName:SetBackdrop(nil)
	CombatConfigColorsColorizeSpellNames:SetBackdrop(nil)
	CombatConfigColorsColorizeDamageNumber:SetBackdrop(nil)
	CombatConfigColorsColorizeDamageSchool:SetBackdrop(nil)
	CombatConfigColorsColorizeEntireLine:SetBackdrop(nil)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
	F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
	F.ReskinColourSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
	F.ReskinColourSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)

	-- Combat Formatting
	local formatBoxes = {"CombatConfigFormattingShowTimeStamp", "CombatConfigFormattingShowBraces", "CombatConfigFormattingUnitNames", "CombatConfigFormattingSpellNames", "CombatConfigFormattingItemNames", "CombatConfigFormattingFullText"}
	for _, box in next, formatBoxes do
		F.ReskinCheck(_G[box])
	end

	-- Combat Settings
	local settingsBoxes = {"CombatConfigSettingsShowQuickButton", "CombatConfigSettingsSolo", "CombatConfigSettingsParty", "CombatConfigSettingsRaid"}
	for _, box in next, settingsBoxes do
		F.ReskinCheck(_G[box])
	end
	F.ReskinInput(CombatConfigSettingsNameEditBox)
	F.Reskin(CombatConfigSettingsSaveButton)

	F.Reskin(ChatConfigFrame.DefaultButton)
	--ChatConfigFrame.DefaultButton:SetWidth(125)
	F.Reskin(ChatConfigFrame.RedockButton)
	F.Reskin(CombatLogDefaultButton)
	ChatConfigFrame.DefaultButton:SetPoint("BOTTOMLEFT", 10, 10)
	ChatConfigFrame.RedockButton:SetPoint("BOTTOMLEFT", ChatConfigFrame.DefaultButton, "BOTTOMRIGHT", 5, 0)

	F.Reskin(ChatConfigFrameOkayButton)
	ChatConfigFrameOkayButton:ClearAllPoints()
	ChatConfigFrameOkayButton:SetPoint("BOTTOMRIGHT", -10, 10)

	hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
		if frame.styled then return end

		frame:SetBackdrop(nil)

		local checkBoxNameString = frame:GetName().."CheckBox"

		if checkBoxTemplate == "ChatConfigCheckBoxTemplate" then
			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index
				local checkbox = _G[checkBoxName]

				checkbox:SetBackdrop(nil)

				local bg = CreateFrame("Frame", nil, checkbox)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
				F.CreateBD(bg, .25)

				F.ReskinCheck(_G[checkBoxName.."Check"])
			end
		elseif checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate" or checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index
				local checkbox = _G[checkBoxName]

				checkbox:SetBackdrop(nil)

				local bg = CreateFrame("Frame", nil, checkbox)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
				F.CreateBD(bg, .25)

				F.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])

				F.ReskinCheck(_G[checkBoxName.."Check"])

				if checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
					F.ReskinCheck(_G[checkBoxName.."ColorClasses"])
				end
			end
		end

		frame.styled = true
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate)
		if frame.styled then return end

		local checkBoxNameString = frame:GetName().."CheckBox"

		for index, value in ipairs(checkBoxTable) do
			local checkBoxName = checkBoxNameString..index

			F.ReskinCheck(_G[checkBoxName])

			if value.subTypes then
				local subCheckBoxNameString = checkBoxName.."_"

				for k, v in ipairs(value.subTypes) do
					F.ReskinCheck(_G[subCheckBoxNameString..k])
				end
			end
		end

		frame.styled = true
	end)

	hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable, swatchTemplate)
		if frame.styled then return end

		frame:SetBackdrop(nil)

		local nameString = frame:GetName().."Swatch"

		for index, value in ipairs(swatchTable) do
			local swatchName = nameString..index
			local swatch = _G[swatchName]

			swatch:SetBackdrop(nil)

			local bg = CreateFrame("Frame", nil, swatch)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, 1)
			bg:SetFrameLevel(swatch:GetFrameLevel()-1)
			F.CreateBD(bg, .25)

			F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
		end

		frame.styled = true
	end)
end)
