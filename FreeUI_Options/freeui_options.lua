local F, C
local _, ns = ...

-- [[ Variables ]]

ns.locale = GetLocale()
ns.localization = {}

ns.categories = {}
ns.buttons = {}
ns.protectOptions = {}
-- highlight new options
ns.newCategories = {}
ns.newOptions = {}

local checkboxes = {}
local radiobuttons = {}
local sliders = {}
local colourpickers = {}
local panels = {}

-- cache old values to check whether UI needs to be reloaded
local old = {}
local oldRadioValues = {}
local oldColours = {}

local overrideReload = false
local userChangedSlider = true -- to use SetValue without triggering OnValueChanged
local baseName = "FreeUIOptionsPanel"

local r, g, b

-- [[ Functions ]]

-- when an option needs a reload
local function setReloadNeeded(isNeeded)
	FreeUIOptionsPanel.reloadText:SetShown(isNeeded)
	ns.needReload = isNeeded -- for the popup when clicking okay
end

-- check if a reload is needed
local function checkIsReloadNeeded()
	if not overrideReload then -- can't check sliders for old value, always flag for reload when they change
		for checkbox, value in pairs(old) do
			if C[checkbox.group][checkbox.option] ~= value then
				setReloadNeeded(true)
				return
			end
		end

		for radioOptionGroup, radioOptionValues in pairs(oldRadioValues) do
			for option, value in pairs(radioOptionValues) do
				if C[radioOptionGroup][option] ~= value then
					setReloadNeeded(true)
					return
				end
			end
		end

		for colourOption, oldTable in pairs(oldColours) do
			local savedTable = C[colourOption.group][colourOption.option]
			if savedTable.r ~= oldTable.r or savedTable.g ~= oldTable.g or savedTable.b ~= oldTable.b then
				setReloadNeeded(true)
				return
			end
		end

		-- if the tables were empty, or all of the old values match their current ones
		setReloadNeeded(false)
	end
end

-- Called by every widget to save a value
local function SaveValue(f, value)
	if not C.options[f.group] then C.options[f.group] = {} end
	if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

	C.options[f.group][f.option] = value -- these are the saved variables
	C[f.group][f.option] = value -- and this is from the lua options
end

-- [[ Widgets ]]

-- Check boxes

local function toggleChildren(self, checked)
	local tR, tG, tB
	if checked then
		tR, tG, tB = 1, 1, 1
	else
		tR, tG, tB = .5, .5, .5
	end

	for _, child in next, self.children do
		if child.radioHeader then -- radio button group
			child.radioHeader:SetTextColor(tR, tG, tB)

			for _, radioButton in pairs(child.buttons) do
				radioButton:SetEnabled(checked)
				radioButton.text:SetTextColor(tR, tG, tB)
			end
		else
			child:SetEnabled(checked)
			child.Text:SetTextColor(tR, tG, tB)
		end
	end
end

local function toggle(self)
	local checked = self:GetChecked()

	if checked then
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		PlaySound("igMainMenuOptionCheckBoxOff")
	end

	SaveValue(self, checked)
	if self.children then toggleChildren(self, checked) end

	if self.needsReload then
		if old[self] == nil then
			old[self] = not checked
		end

		checkIsReloadNeeded()
	end
end

ns.CreateCheckBox = function(parent, option, tooltipText, needsReload)
	local f = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")

	f.group = parent.tag
	f.option = option

	f.Text:SetText(ns.localization[parent.tag..option])
	if tooltipText then f.tooltipText = ns.localization[parent.tag..option.."Tooltip"] end

	if needsReload then
		f.tooltipText = f.tooltipText and format("%s\n\n%s", f.tooltipText, ns.localization.requiresReload) or ns.localization.requiresReload
	end

	f.needsReload = needsReload

	f:SetScript("OnClick", toggle)
	parent[option] = f

	tinsert(checkboxes, f)

	return f
end

local function toggleRadio(self)
	local previousValue

	local index = 1
	local radioButton = self.parent[self.option..index]
	while radioButton do
		if radioButton.isChecked then
			previousValue = index

			if radioButton ~= self then
				radioButton.isChecked = false
				radioButton:SetChecked(false)
			end
		end

		index = index + 1
		radioButton = self.parent[self.option..index]
	end

	self:SetChecked(true) -- don't allow deselecting
	self.isChecked = true

	PlaySound("igMainMenuOptionCheckBoxOn")

	SaveValue(self, self.index)

	if self.needsReload then
		if oldRadioValues[self.group] == nil then
			oldRadioValues[self.group] = {}

			if oldRadioValues[self.group][self.option] == nil then
				oldRadioValues[self.group][self.option] = previousValue
			end
		end

		checkIsReloadNeeded()
	end
end

local function radioOnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
end

local function radioOnLeave(self)
	GameTooltip:Hide()
end

ns.CreateRadioButtonGroup = function(parent, option, numValues, tooltipText, needsReload)
	local group = {}
	group.buttons = {}

	for i = 1, numValues do
		local f = CreateFrame("CheckButton", nil, parent, "UIRadioButtonTemplate")

		f.parent = parent
		f.group = parent.tag
		f.option = option
		f.index = i

		f.text:SetFontObject(GameFontHighlight)
		f.text:SetText(ns.localization[parent.tag..option..i])
		if tooltipText then
			f.tooltipText = ns.localization[parent.tag..option..i.."Tooltip"]
		end

		if needsReload then
			f.tooltipText = f.tooltipText and format("%s\n\n%s", f.tooltipText, ns.localization.requiresReload) or ns.localization.requiresReload
		end

		if f.tooltipText then
			f:HookScript("OnEnter", radioOnEnter)
			f:HookScript("OnLeave", radioOnLeave)
		end

		f.needsReload = needsReload

		f:SetScript("OnClick", toggleRadio)
		parent[option..i] = f

		-- return value
		tinsert(group.buttons, f)

		-- handling input, style, ...
		tinsert(radiobuttons, f)

		if i > 1 then
			f:SetPoint("TOP", parent[option..i-1], "BOTTOM", 0, -8)
		end
	end

	local firstOption = parent[option..1]

	-- add header
	local header = firstOption:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	header:SetPoint("BOTTOMLEFT", firstOption, "TOPLEFT", 2, 5)
	header:SetText(ns.localization[parent.tag..option])
	group.radioHeader = header

	return group
end

-- Sliders

local function onValueChanged(self, value)
	value = floor(value+0.5)

	if self.textInput then
		self.textInput:SetText(value)
	end

	if userChangedSlider then
		SaveValue(self, value)

		if self.needsReload then
			-- if not true, don't set to false - something else might have changed it
			setReloadNeeded(true)
		end

		overrideReload = true
	end
end

local function createSlider(parent, option, lowText, highText, low, high, step, needsReload)
	local f = CreateFrame("Slider", baseName..option, parent, "OptionsSliderTemplate")

	BlizzardOptionsPanel_Slider_Enable(f)

	f.group = parent.tag
	f.option = option

	_G[baseName..option.."Text"]:SetText(ns.localization[parent.tag..option])
	_G[baseName..option.."Low"]:SetText(lowText)
	_G[baseName..option.."High"]:SetText(highText)
	f:SetMinMaxValues(low, high)
	f:SetValueStep(step)

	if needsReload then
		f.tooltipText = ns.localization.requiresReload
	end

	f.needsReload = needsReload

	f:SetScript("OnValueChanged", onValueChanged)
	parent[option] = f

	tinsert(sliders, f)

	return f
end

local function onSliderEscapePressed(self)
	self:ClearFocus()
end

local function onSliderEnterPressed(self)
	local slider = self:GetParent()
	local min, max = slider:GetMinMaxValues()

	local value = tonumber(self:GetText())
	if value and value >= floor(min) and value <= floor(max) then
		slider:SetValue(value)
	else
		self:SetText(floor(slider:GetValue()*1000)/1000)
	end

	self:ClearFocus()
end

ns.CreateNumberSlider = function(parent, option, lowText, highText, low, high, step, needsReload)
	local slider = createSlider(parent, option, lowText, highText, low, high, step, needsReload)

	local f = CreateFrame("EditBox", baseName..option.."TextInput", slider, "InputBoxTemplate")
	f:SetAutoFocus(false)
	f:SetWidth(60)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	f:SetFontObject(GameFontHighlight)

	f:SetPoint("LEFT", slider, "RIGHT", 20, 0)

	f:SetScript("OnEscapePressed", onSliderEscapePressed)
	f:SetScript("OnEnterPressed", onSliderEnterPressed)
	f:SetScript("OnEditFocusGained", nil)
	f:SetScript("OnEditFocusLost", onSliderEnterPressed)

	slider.textInput = f

	return slider
end

-- Colour pickers

-- we update this in onColourSwatchClicked, need it for setColour / resetColour
-- because it can't be passed as parameter
local currentColourOption

local function round(x)
	return floor((x * 100) + .5) / 100
end

local function setColour()
	local newR, newG, newB = ColorPickerFrame:GetColorRGB()
	newR, newG, newB = round(newR), round(newG), round(newB)

	currentColourOption.tex:SetVertexColor(newR, newG, newB)
	SaveValue(currentColourOption, {r = newR, g = newG, b = newB})

	checkIsReloadNeeded()
end

local function resetColour(restore)
	local oldR, oldG, oldB = restore.r, restore.g, restore.b

	currentColourOption.tex:SetVertexColor(oldR, oldG, oldB)
	SaveValue(currentColourOption, {r = oldR, g = oldG, b = oldB})

	checkIsReloadNeeded()
end

local function onColourSwatchClicked(self)
	local colourTable = C[self.group][self.option]
	local currentR, currentG, currentB = colourTable.r, colourTable.g, colourTable.b

	currentColourOption = self

	if self.needsReload and oldColours[self] == nil then
		oldColours[self] = {r = currentR, g = currentG, b = currentB}
	end

	ColorPickerFrame:SetColorRGB(currentR, currentG, currentB)
	ColorPickerFrame.previousValues = {r = currentR, g = currentG, b = currentB}
	ColorPickerFrame.func = setColour
	ColorPickerFrame.cancelFunc = resetColour
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

ns.CreateColourPicker = function(parent, option, needsReload)
	local f = CreateFrame("Button", nil, parent)
	f:SetSize(16, 16)

	local tex = f:CreateTexture(nil, "OVERLAY")
	tex:SetAllPoints()
	f.tex = tex

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload

	f:SetScript("OnClick", onColourSwatchClicked)
	parent[option] = f

	tinsert(colourpickers, f)

	return f
end

-- [[ Categories and tabs ]]

local offset = 58
local activeTab = nil

local function setActiveTab(tab)
	activeTab = tab

	activeTab:SetBackdropColor(r, g, b, .15)
	activeTab.topLine:Show()
	activeTab.bottomLine:Show()

	activeTab.panel:Show()
end

local onTabClick = function(tab)
	activeTab.panel:Hide()

	activeTab:SetBackdropColor(0, 0, 0, 0)
	activeTab.topLine:Hide()
	activeTab.bottomLine:Hide()

	setActiveTab(tab)
end

local function colourTab(f)
	f.Text:SetTextColor(1, 1, 1)
end

local function clearTab(f)
	f.Text:SetTextColor(.9, .9, .9)
end

ns.addCategory = function(name)
	local tag = strlower(name)

	local panel = CreateFrame("Frame", baseName..name, FreeUIOptionsPanel)
	panel:SetSize(638, 568)
	panel:SetPoint("RIGHT", -42, 0)
	panel:Hide()

	panel.Title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	panel.Title:SetPoint("TOPLEFT", 8, -16)
	panel.Title:SetText(ns.localization[tag])

	panel.subText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	panel.subText:SetPoint("TOPLEFT", panel.Title, "BOTTOMLEFT", 0, -8)
	panel.subText:SetJustifyH("LEFT")
	panel.subText:SetJustifyV("TOP")
	panel.subText:SetSize(607, 32)
	panel.subText:SetText(ns.localization[tag.."SubText"])

	local tab = CreateFrame("Frame", nil, FreeUIOptionsPanel)
	tab:SetPoint("TOPLEFT", 1, -offset)
	tab:SetSize(189, 34)

	local icon = tab:CreateTexture(nil, "OVERLAY")
	icon:SetSize(25, 25)
	icon:SetPoint("LEFT", tab, 6, -1)
	icon:SetTexCoord(.08, .92, .08, .92)
	tab.Icon = icon

	tab.Text = tab:CreateFontString(nil, "ARTWORK", "SystemFont_Shadow_Med3")
	tab.Text:SetPoint("LEFT", icon, "RIGHT", 8, 0)
	tab.Text:SetTextColor(.9, .9, .9)
	tab.Text:SetText(ns.localization[tag])

	local topLine = tab:CreateTexture(nil, "OVERLAY")
	topLine:SetHeight(1)
	topLine:SetPoint("TOPLEFT")
	topLine:SetPoint("TOPRIGHT")
	topLine:Hide()
	tab.topLine = topLine

	local bottomLine = tab:CreateTexture(nil, "OVERLAY")
	bottomLine:SetHeight(1)
	bottomLine:SetPoint("BOTTOMLEFT", 0, -1)
	bottomLine:SetPoint("BOTTOMRIGHT", 0, -1)
	bottomLine:Hide()
	tab.bottomLine = bottomLine

	tab:SetScript("OnMouseUp", onTabClick)
	tab:SetScript("OnEnter", colourTab)
	tab:SetScript("OnLeave", clearTab)

	tab.panel = panel
	panel.tab = tab
	panel.tag = tag

	FreeUIOptionsPanel[tag] = panel

	tinsert(panels, panel)

	offset = offset + 35
end

ns.addSubCategory = function(category, name)
	local header = category:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	header:SetText(name)

	local line = category:CreateTexture(nil, "ARTWORK")
	line:SetSize(450, 1)
	line:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
	line:SetTexture(1, 1, 1, .2)

	return header, line
end

-- [[ Init ]]

local function changeProfile()
	local profile
	if FreeUIOptionsGlobal[C.myRealm][C.myName] == true then
		if FreeUIOptionsPerChar == nil then
			FreeUIOptionsPerChar = {}
		end
		profile = FreeUIOptionsPerChar
	else
		profile = FreeUIOptions
	end

	for group, options in pairs(profile) do
		if C[group] then
			for option, value in pairs(options) do
				if C[group][option] == nil or (group == "unitframes" and (tonumber(profile[group][option]) or type(profile[group][option]) == "table")) then
					profile[group][option] = nil
				else
					C[group][option] = value
				end
			end
		else
			profile[group] = nil
		end
	end

	C.options = profile
end

local function displaySettings()
	for _, box in pairs(checkboxes) do
		box:SetChecked(C[box.group][box.option])
		if box.children then toggleChildren(box, box:GetChecked()) end
	end

	for _, radio in pairs(radiobuttons) do
		local isChecked = C[radio.group][radio.option] == radio.index

		radio:SetChecked(isChecked)
		radio.isChecked = isChecked -- need this for storing the previous value when user changes setting
	end

	userChangedSlider = false

	for _, slider in pairs(sliders) do
		slider:SetValue(C[slider.group][slider.option])
		slider.textInput:SetText(floor(C[slider.group][slider.option]*1000)/1000)
		slider.textInput:SetCursorPosition(0)
	end

	userChangedSlider = true

	for _, picker in pairs(colourpickers) do
		local colourTable = C[picker.group][picker.option]
		picker.tex:SetVertexColor(colourTable.r, colourTable.g, colourTable.b)
	end
end

local function removeCharData(self)
	self:ClearFocus()

	local realm = C.myRealm
	local name = self:GetText()

	self:SetText("")

	if name ~= "" then
		local somethingDeleted = false

		for varType, varTable in pairs(FreeUIGlobalConfig[realm]) do
			if varTable[name] ~= nil then
				varTable[name] = nil
				somethingDeleted = true
			end
		end

		if FreeUIOptionsGlobal[realm][name] ~= nil then
			FreeUIOptionsGlobal[realm][name] = nil
			somethingDeleted = true
		end

		if somethingDeleted then
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffData for "..name.." removed.", unpack(C.class))
		else
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffData for "..name.." not found. Check the spelling of the name.", unpack(C.class))
		end
	end
end

local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_LOGIN")
init:SetScript("OnEvent", function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)
	r, g, b = unpack(C.class)

	local FreeUIOptionsPanel = FreeUIOptionsPanel

	if C.unitframes.enable then
		FreeUIOptionsPanel:HookScript("OnShow", function()
			oUF_FreePlayer:SetAlpha(0)
			oUF_FreeTarget:SetAlpha(0)
		end)

		FreeUIOptionsPanel:HookScript("OnHide", function()
			oUF_FreePlayer:SetAlpha(1)
			oUF_FreeTarget:SetAlpha(1)
		end)
	end

	local resetFrame = FreeUIOptionsPanel.resetFrame
	local layout = FreeUIOptionsPanel.unitframes.Layout

	resetFrame.Okay:SetScript("OnClick", function()
		local somethingChecked = false

		if resetFrame.Data:GetChecked() then
			FreeUIGlobalConfig = {}
			FreeUIConfig = {}
			somethingChecked = true
		end
		if resetFrame.Options:GetChecked() then
			FreeUIOptions = {}
			FreeUIOptionsPerChar = {}
			FreeUIOptionsGlobal[C.myRealm][C.myName] = false
			C.options = FreeUIOptions
			somethingChecked = true
		end

		removeCharData(resetFrame.charBox)

		if somethingChecked then
			ReloadUI()
		else
			resetFrame:Hide()
		end
	end)

	resetFrame.charBox:SetScript("OnEnterPressed", removeCharData)

	FreeUIOptionsPanel.ProfileBox:SetChecked(FreeUIOptionsGlobal[C.myRealm][C.myName])
	FreeUIOptionsPanel.ProfileBox:SetScript("OnClick", function(self)
		FreeUIOptionsGlobal[C.myRealm][C.myName] = self:GetChecked()
		changeProfile()
		displaySettings()
	end)

	layout:SetText((FreeUIConfig.layout == 2) and "Dps/Tank Layout" or "Healer Layout")
	layout:SetScript("OnClick", function()
		FreeUIConfig.layout = (FreeUIConfig.layout == 2) and 1 or 2
		ReloadUI()
	end)

	F.CreateBD(FreeUIOptionsPanel)
	F.CreateBD(FreeUIOptionsPanel.popup)
	F.CreateBD(FreeUIOptionsPanel.credits)
	F.CreateBD(resetFrame)
	F.ReskinClose(FreeUIOptionsPanel.CloseButton)
	F.ReskinClose(FreeUIOptionsPanel.credits.CloseButton)
	F.ReskinCheck(FreeUIOptionsPanel.ProfileBox)
	F.ReskinCheck(resetFrame.Data)
	F.ReskinCheck(resetFrame.Options)

	for _, panel in pairs(panels) do
		panel.tab:SetBackdrop({
			bgFile = C.media.backdrop,
			insets = {top = 1},
		})
		panel.tab:SetBackdropColor(0, 0, 0, 0)
		panel.tab.topLine:SetTexture(r, g, b, .2)
		panel.tab.bottomLine:SetTexture(r, g, b, .2)

		local bg = F.CreateBG(panel.tab.Icon)
		bg:SetDrawLayer("ARTWORK")
	end

	setActiveTab(FreeUIOptionsPanel.general.tab)

	for _, button in pairs(ns.buttons) do
		F.Reskin(button)
	end

	for _, box in pairs(checkboxes) do
		F.ReskinCheck(box)
	end

	for _, radio in pairs(radiobuttons) do
		F.ReskinRadio(radio)
	end

	for _, slider in pairs(sliders) do
		F.ReskinSlider(slider)
		F.ReskinInput(slider.textInput)
	end

	for _, picker in pairs(colourpickers) do
		picker.tex:SetTexture(C.media.backdrop)
		F.CreateBG(picker)
	end

	for _, setting in pairs(ns.classOptions) do
		local colour = C.classcolours[setting.className]
		setting.Text:SetTextColor(colour.r, colour.g, colour.b)
	end

	F.ReskinInput(resetFrame.charBox)

	for _, newCategory in pairs(ns.newCategories) do
		local new = F.CreateFS(newCategory.tab)
		new:SetTextColor(r, g, b)
		new:SetPoint("RIGHT", -5, 0)
		new:SetText(ns.localization.NEW)
	end

	for _, newOption in pairs(ns.newOptions) do
		local text = newOption.text or newOption.Text

		local new = F.CreateFS(newOption)
		new:SetTextColor(r, g, b)
		new:SetPoint("LEFT", text, "RIGHT", 3, 6)
		new:SetText(ns.localization.NEW)
	end

	local function updateFontSamples()
		if userChangedSlider then
			if C.appearance.fontSizeNormal ~= nil and C.appearance.fontSizeLarge ~= nil then
				F.SetFS(FreeUIOptionsPanel.appearance.normalSample, C.FONT_SIZE_NORMAL)
				F.SetFS(FreeUIOptionsPanel.appearance.largeSample, C.FONT_SIZE_LARGE)
			end
		end
	end

	F.SetFS(FreeUIOptionsPanel.appearance.normalSample, C.FONT_SIZE_NORMAL)
	F.SetFS(FreeUIOptionsPanel.appearance.largeSample, C.FONT_SIZE_LARGE)

	FreeUIOptionsPanel.appearance.normalSample:SetText(ns.localization.appearancesampleText)
	FreeUIOptionsPanel.appearance.largeSample:SetText(ns.localization.appearancesampleText)

	F.AddOptionsCallback("appearance", "fontUseAlternativeFont", updateFontSamples)
	F.AddOptionsCallback("appearance", "fontSizeNormal", updateFontSamples)
	F.AddOptionsCallback("appearance", "fontSizeLarge", updateFontSamples)
	F.AddOptionsCallback("appearance", "fontOutline", updateFontSamples)
	F.AddOptionsCallback("appearance", "fontOutlineStyle", updateFontSamples, "radio")
	F.AddOptionsCallback("appearance", "fontShadow", updateFontSamples)

	local function testNotificationCallback()
		print(ns.localization.notificationPreviewCallbackText)
	end

	FreeUIOptionsPanel.notifications.previewButton:SetScript("OnClick", function()
		F.Notification("FreeUI", ns.localization.notificationPreviewText, testNotificationCallback)
	end)

	displaySettings()
end)

local protect = CreateFrame("Frame")
protect:RegisterEvent("PLAYER_REGEN_ENABLED")
protect:RegisterEvent("PLAYER_REGEN_DISABLED")
protect:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		for _, option in next, ns.protectOptions do
			option.Text:SetTextColor(1, 1, 1)
			option:Enable()
		end
	else
		for _, option in next, ns.protectOptions do
			option.Text:SetTextColor(.5, .5, .5)
			option:Disable()
		end
	end
end)