local _, ns = ...


local F, C
local realm = GetRealmName()
local name = UnitName('player')


-- [[ Variables ]]

-- cache old values to check whether UI needs to be reloaded
local old = {}
local oldRadioValues = {}
local oldColours = {}

local userChangedSlider = true -- to use SetValue without triggering OnValueChanged
local baseName = 'FreeUIOptionsFrame'


-- [[ Options frame ]]

local function createOptionsFrame(name)
	local f = CreateFrame('Frame', name, UIParent)
	f:SetSize(600, 600)
	f:SetPoint('CENTER')
	f:SetFrameStrata('HIGH')
	f:EnableMouse(true)
	tinsert(UISpecialFrames, f:GetName())

	f.line = f:CreateTexture()
	f.line:SetSize(1, 500)
	f.line:SetPoint('TOPLEFT', 180, -60)
	f.line:SetColorTexture(.5, .5, .5, .1)

	f.close = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.close:SetPoint('BOTTOMRIGHT', -6, 6)
	f.close:SetSize(80, 24)
	f.close:SetText(CLOSE)
	f.close:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		f:Hide()
	end)
	tinsert(ns.buttons, f.close)

	f.okay = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.okay:SetPoint('RIGHT', f.close, 'LEFT', -6, 0)
	f.okay:SetSize(80, 24)
	f.okay:SetText(OKAY)
	f.okay:Disable()
	tinsert(ns.buttons, f.okay)

	f.needReload = f:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	f.needReload:SetPoint('BOTTOM', 0, 12)
	f.needReload:SetText(ns.localization.misc.need_reload)
	f.needReload:Hide()

	--[[ local credit = CreateFrame('Frame', 'FreeUICreditsPanel', UIParent)
	credit:SetSize(500, 500)
	credit:SetPoint('CENTER')
	credit:SetFrameStrata('DIALOG')
	credit:EnableMouse(true)
	credit:Hide()
	credit:SetScript('OnHide', function()
		f:SetAlpha(1)
	end)
	tinsert(UISpecialFrames, credit:GetName())

	credit.close = CreateFrame('Button', nil, credit, 'UIPanelButtonTemplate')
	credit.close:SetSize(80, 24)
	credit.close:SetPoint('BOTTOM', 0, 25)
	credit.close:SetText(CLOSE)
	credit.close:SetScript('OnClick', function()
		credit:Hide()
	end)
	tinsert(ns.buttons, credit.close)

	f.reset = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.reset:SetSize(120, 24)
	f.reset:SetText(ns.localization.misc.reset)
	f.reset:SetPoint('BOTTOMLEFT', f, 'BOTTOMLEFT', 30, 50)
	tinsert(ns.buttons, f.reset)

	f.credit = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.credit:SetSize(120, 24)
	f.credit:SetText(ns.localization.misc.credit)
	f.credit:SetPoint('BOTTOM', f.reset, 'TOP', 0, 4)
	f.credit:SetScript('OnClick', function()
		credit:Show()
		f:SetAlpha(.2)
	end)
	tinsert(ns.buttons, f.credit)

	f.install = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.install:SetSize(120, 24)
	f.install:SetText(ns.localization.misc.install)
	f.install:SetPoint('BOTTOM', f.credit, 'TOP', 0, 4)
	tinsert(ns.buttons, f.install) ]]

	f.profile = CreateFrame('CheckButton', nil, f, 'InterfaceOptionsCheckButtonTemplate')
	f.profile:SetSize(24, 24)
	f.profile:SetPoint('BOTTOMLEFT', 6, 6)
	f.profile.Text:SetText(ns.localization.misc.profile)
	f.profile.tooltipText = ns.localization.misc.profile_tip
end


-- [[ Functions ]]

-- when an option needs a reload
local function setReloadNeeded(isNeeded)
	FreeUIOptionsFrame.needReload:SetShown(isNeeded)
	ns.needReload = isNeeded -- for the popup when clicking okay

	if isNeeded then
		FreeUIOptionsFrame.okay:Enable()
	else
		FreeUIOptionsFrame.okay:Disable()
	end
end

-- check if a reload is needed
local function checkIsReloadNeeded()
	for frame, value in pairs(old) do
		if C[frame.group][frame.option] ~= value then
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
		if savedTable[1] ~= oldTable[1] or savedTable[2] ~= oldTable[2] or savedTable[3] ~= oldTable[3] then
			setReloadNeeded(true)
			return
		end
	end

	-- if the tables were empty, or all of the old values match their current ones
	setReloadNeeded(false)
end

-- Called by every widget to save a value
local function SaveValue(f, value)
	if not C.options[f.group] then C.options[f.group] = {} end
	if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

	C.options[f.group][f.option] = value -- these are the saved variables
	C[f.group][f.option] = value -- and this is from the lua options
end


-- [[ Widgets ]]

-- Toggle
local function toggleChildren(self, checked)
	local tR, tG, tB
	if checked then
		tR, tG, tB = 1, 1, 1
	else
		tR, tG, tB = .3, .3, .3
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

		if child.lowText then
			child.lowText:SetTextColor(tR, tG, tB)
			child.highText:SetTextColor(tR, tG, tB)
			child.textInput.num:SetTextColor(tR, tG, tB)
			child:GetThumbTexture():SetVertexColor(tR, tG, tB)
		end
	end
end

local function toggle(self)
	local checked = self:GetChecked()

	if checked then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
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

-- Check boxes
ns.CreateCheckBox = function(parent, option, extra)
	local f = CreateFrame('CheckButton', nil, parent.child, 'InterfaceOptionsCheckButtonTemplate')
	f:SetSize(20, 20)
	f.group = parent.tag
	f.option = option

	f.Text:SetPoint('LEFT', f, 'RIGHT', 2, 0)
	f.Text:SetText(ns.localization[strlower(parent.tag)][option] or option)

	f.tooltipText = ns.localization[strlower(parent.tag)][option..'_tip'] or option

	f.needsReload = true

	f:SetScript('OnClick', toggle)

	parent[option] = f

	tinsert(ns.checkboxes, f)

	return f
end

-- Radios
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

	PlaySound('856')

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
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:SetText(self.tooltipText)
end

local function radioOnLeave(self)
	GameTooltip:Hide()
end

ns.CreateRadioButtonGroup = function(parent, option, numValues, tooltipText, needsReload)
	local group = {}
	group.buttons = {}

	for i = 1, numValues do
		local f = CreateFrame('CheckButton', nil, parent.child, 'UIRadioButtonTemplate')

		f.parent = parent
		f.group = parent.tag
		f.option = option
		f.index = i

		f.text:SetFontObject(GameFontHighlight)
		f.text:SetText(ns.localization[strlower(parent.tag)][option..i] or option..i)
		if tooltipText then
			f.tooltipText = ns.localization[strlower(parent.tag)][option..i..'_tip'] or option..i
		end

		if f.tooltipText then
			f:HookScript('OnEnter', radioOnEnter)
			f:HookScript('OnLeave', radioOnLeave)
		end

		f.needsReload = needsReload

		f:SetScript('OnClick', toggleRadio)
		parent[option..i] = f

		-- return value
		tinsert(group.buttons, f)

		-- handling input, style, ...
		tinsert(ns.radiobuttons, f)

		if i > 1 then
			f:SetPoint('TOP', parent[option..i-1], 'BOTTOM', 0, -8)
		end
	end

	local firstOption = parent[option..1]

	-- add header
	local header = firstOption:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	header:SetPoint('BOTTOMLEFT', firstOption, 'TOPLEFT', 2, 5)
	header:SetText(ns.localization[parent.tag..'_'..option])
	group.radioHeader = header

	return group
end

-- Sliders
local function onValueChanged(self, value)
	if self.step < 1 then
		value = tonumber(string.format('%.2f', value))
	else
		value = floor(value + 0.5)
	end

	if self.textInput then
		self.textInput:SetText(value)
	end

	if userChangedSlider then
		SaveValue(self, value)

		if self.needsReload then
			if self.step < 1 then
				self.oldValue = tonumber(string.format('%.2f', self.oldValue))
			end
			old[self] = self.oldValue

			checkIsReloadNeeded()
		end
	end
end

local function createSlider(parent, option, lowText, highText, low, high, step, needsReload)
	local f = CreateFrame('Slider', baseName..option, parent.child, 'OptionsSliderTemplate')
	
	BlizzardOptionsPanel_Slider_Enable(f)

	f.group = parent.tag
	f.option = option

	f.text = _G[baseName..option..'Text']
	f.lowText = _G[baseName..option..'Low']
	f.highText = _G[baseName..option..'High']

	f.text:SetFontObject(GameFontNormalTiny)
	f.text:SetText(ns.localization[strlower(parent.tag)][option] or option)
	f.lowText:SetText(lowText)
	f.highText:SetText(highText)
	
	f.text:SetTextColor(1, 1, 1)
	f.lowText:SetTextColor(.8, .8, .8)
	f.highText:SetTextColor(.8, .8, .8)

	f:SetWidth(120)

	f:SetMinMaxValues(low, high)
	f:SetObeyStepOnDrag(true)
	f:SetValueStep(step)

	f.tooltipText = ns.localization[strlower(parent.tag)][option..'_tip'] or ns.localization[strlower(parent.tag)][option]

	f.needsReload = needsReload
	f.step = step

	f:SetScript('OnValueChanged', onValueChanged)
	parent[option] = f

	tinsert(ns.sliders, f)

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

	local f = CreateFrame('EditBox', baseName..option..'TextInput', slider, 'InputBoxTemplate')
	f:SetAutoFocus(false)
	f:SetWidth(36)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	
	f:SetPoint('TOP', slider, 'BOTTOM', 0, -10)

	f.num = f:GetRegions()
	if f.num:GetObjectType() == 'FontString' then
		f.num:SetJustifyH('CENTER')
		f.num:SetTextColor(.8, .8, .8)
	end

	f:SetScript('OnEscapePressed', onSliderEscapePressed)
	f:SetScript('OnEnterPressed', onSliderEnterPressed)
	f:SetScript('OnEditFocusGained', nil)
	f:SetScript('OnEditFocusLost', onSliderEnterPressed)

	slider.textInput = f



	return slider
end

-- EditBox
local function onEnterPressed(self)
	local value = self.valueNumber and tonumber(self:GetText()) or tostring(self:GetText())
	SaveValue(self, value)
	self:ClearFocus()
	old[self] = self.oldValue
	checkIsReloadNeeded()
end

ns.CreateEditBox = function(parent, option, needsReload, number)
	local f = CreateFrame('EditBox', parent:GetName()..option..'TextInput', parent, 'InputBoxTemplate')
	f:SetAutoFocus(false)
	f:SetWidth(55)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	f:SetFontObject(GameFontHighlight)

	f:SetPoint('LEFT', 40, 0)

	f.value = ''
	f.valueNumber = number and true or false

	f:SetScript('OnEscapePressed', onSliderEscapePressed)
	f:SetScript('OnEscapePressed', function(self) self:ClearFocus() self:SetText(f.value) end)
	f:SetScript('OnEnterPressed', onEnterPressed)
	f:SetScript('OnEditFocusGained', function() f.value = f:GetText() end)
	f:SetScript('OnEditFocusLost', onEnterPressed)

	local label = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	label:SetWidth(440)
	label:SetHeight(20)
	label:SetJustifyH('LEFT')
	label:SetPoint('LEFT', f, 'RIGHT', 10, 0)
	label:SetText(ns.localization[strlower(parent.tag)][option] or option)

	f.tooltipText = --[[ ns.localization[strlower(parent.tag)][option..'_tip'] or  ]]label

	f:SetScript('OnEnter', function()
		GameTooltip:SetOwner(f, 'ANCHOR_RIGHT', 5, 5)
		GameTooltip:SetText(f.tooltipText, 130/255, 197/255, 1, 1, true)
	end)

	f:SetScript('OnLeave', function()
		GameTooltip:Hide()
	end)

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload
	parent[option] = f

	tinsert(ns.editboxes, f)

	return f
end

-- Colour pickers
local currentColourOption

local function round(x)
	return floor((x * 100) + .5) / 100
end

local function setColour()
	local newR, newG, newB = ColorPickerFrame:GetColorRGB()
	newR, newG, newB = round(newR), round(newG), round(newB)

	currentColourOption:SetBackdropBorderColor(newR, newG, newB)
	currentColourOption:SetBackdropColor(newR, newG, newB, 0.3)
	SaveValue(currentColourOption, {newR, newG, newB})

	checkIsReloadNeeded()
end

local function resetColour(previousValues)
	local oldR, oldG, oldB = unpack(previousValues)

	currentColourOption:SetBackdropBorderColor(oldR, oldG, oldB)
	currentColourOption:SetBackdropColor(oldR, oldG, oldB, 0.3)
	SaveValue(currentColourOption, {oldR, oldG, oldB})

	checkIsReloadNeeded()
end

local function onColourSwatchClicked(self)
	local colourTable = C[self.group][self.option]

	local r, g, b = unpack(colourTable)
	r, g, b = round(r), round(g), round(b)
	local originalR, originalG, originalB = r, g, b

	currentColourOption = self

	if self.needsReload and oldColours[self] == nil then
		oldColours[self] = {r, g, b}
	end

	ColorPickerFrame:SetColorRGB(r, g, b)
	ColorPickerFrame.previousValues = {originalR, originalG, originalB}
	ColorPickerFrame.func = setColour
	ColorPickerFrame.cancelFunc = resetColour
	
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

ns.CreateColourPicker = function(parent, option, needsReload)
	local f = CreateFrame('Button', nil, parent)
	f:SetSize(40, 20)

	local colortext = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	colortext:SetText(COLOR)
	colortext:SetPoint("CENTER")
	colortext:SetJustifyH("CENTER")
	f:SetWidth(colortext:GetWidth() + 5)

	local label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetText(ns.localization[strlower(parent.tag)][option] or option)
	label:SetWidth(440)
	label:SetHeight(20)
	label:SetJustifyH("LEFT")
	label:SetPoint("LEFT", 40, 0)


	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload

	f:SetScript('OnClick', onColourSwatchClicked)

	parent[option] = f

	tinsert(ns.colourpickers, f)

	return f
end

-- DropDown
--[[ local DropDownText = {
	['interface\\addons\\FreeUI\\assets\\font\\supereffective.ttf'] = 'Pixel font',
	[STANDARD_TEXT_FONT] = 'Normal font'
}

ns.CreateDropDown = function(parent, option, needsReload, text, tableValue)
	local f = CreateFrame('Frame', parent:GetName()..option..'DropDown', parent, 'UIDropDownMenuTemplate')
	UIDropDownMenu_SetWidth(f, 110)

	UIDropDownMenu_Initialize(f, function(self)
		local info = UIDropDownMenu_CreateInfo()
		info.func = self.SetValue
		for _, value in pairs(tableValue) do
			info.text = DropDownText[value] or value
			info.arg1 = value
			info.checked = value == f.selectedValue
			UIDropDownMenu_AddButton(info)
		end
	end)

	function f:SetValue(newValue)
		f.selectedValue = newValue
		local text = DropDownText[newValue] or newValue
		UIDropDownMenu_SetText(f, text)
		SaveValue(f, newValue)
		old[f] = f.oldValue
		checkIsReloadNeeded()
		CloseDropDownMenus()
	end

	local label = f:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	if text then
		label:SetText(text)
	else
		label:SetText(ns.localization[parent.tag..'_'..option])
	end
	label:SetWidth(440)
	label:SetHeight(20)
	label:SetJustifyH('LEFT')
	label:SetPoint('LEFT', 150, 4)

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload

	parent[option] = f

	tinsert(ns.dropdowns, f)

	return f
end ]]


-- [[ Categories and tabs ]]

local offset = 60
local activeTab = nil

createOptionsFrame(baseName)

ns.SetActiveTab = function(tab)
	activeTab = tab
	activeTab:SetBackdropColor(C.r, C.g, C.b, .25)
	activeTab.panel:Show()
end

local onTabClick = function(tab)
	activeTab.panel:Hide()
	activeTab:SetBackdropColor(0, 0, 0, 0)
	ns.SetActiveTab(tab)
end

ns.AddCategory = function(name)
	local tag = name
	--local tag = strlower(name)

	local panel = CreateFrame('ScrollFrame', baseName..name, FreeUIOptionsFrame, 'UIPanelScrollFrameTemplate')
	panel:SetSize(380, 500)
	panel:SetPoint('TOPLEFT', 190, -60)
	panel:Hide()

	panel.child = CreateFrame('Frame', nil, panel)
	panel.child:SetPoint('TOPLEFT', 0, 0)
	panel.child:SetPoint('BOTTOMRIGHT', 0, 0)
	panel.child:SetSize(420, 660)

	panel:SetScrollChild(panel.child)

	panel.Title = panel.child:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	panel.Title:SetPoint('TOPLEFT', 14, -16)
	panel.Title:SetText(ns.localization[strlower(tag)]['header'] or tag)

	panel.subText = panel.child:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	panel.subText:SetPoint('TOPLEFT', panel.Title, 'BOTTOMLEFT', 0, -8)
	panel.subText:SetJustifyH('LEFT')
	panel.subText:SetJustifyV('TOP')
	panel.subText:SetSize(420, 30)
	panel.subText:SetText(ns.localization[strlower(tag)]['desc'] or tag)

	local tab = CreateFrame('Button', nil, FreeUIOptionsFrame)
	tab:SetPoint('TOPLEFT', 10, -offset)
	tab:SetSize(160, 28)

	local icon = tab:CreateTexture(nil, 'OVERLAY')
	icon:SetSize(20, 20)
	icon:SetPoint('LEFT', tab, 6, 0)
	icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
	icon:SetTexCoord(.08, .92, .08, .92)
	tab.icon = icon

	tab.Text = tab:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med3')
	tab.Text:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
	tab.Text:SetTextColor(.9, .9, .9)
	tab.Text:SetText(ns.localization[strlower(tag)]['header'] or tag)

	tab:SetScript('OnMouseUp', onTabClick)

	tab.panel = panel
	panel.tab = tab
	panel.tag = tag

	FreeUIOptionsFrame[tag] = panel

	tinsert(ns.panels, panel)

	offset = offset + 34
end

ns.AddSubCategory = function(category, name)
	local header = category.child:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	header:SetText(name or category:GetName())
	header:SetTextColor(233/255, 197/255, 93/255)

	local line = category.child:CreateTexture(nil, 'ARTWORK')
	line:SetSize(380, 1)
	line:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -4)
	line:SetColorTexture(.5, .5, .5, .1)

	return header, line
end


-- [[ Init ]]

local function changeProfile()
	local profile

	if FreeUIOptionsGlobal[realm][name] == true then
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
				if C[group][option] == nil or (group == 'unitframes' and (tonumber(profile[group][option]) or type(profile[group][option]) == 'table')) then
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
	for _, box in pairs(ns.checkboxes) do
		box:SetChecked(C[box.group][box.option])
		if box.children then toggleChildren(box, box:GetChecked()) end
	end

	for _, radio in pairs(ns.radiobuttons) do
		local isChecked = C[radio.group][radio.option] == radio.index

		radio:SetChecked(isChecked)
		radio.isChecked = isChecked -- need this for storing the previous value when user changes setting
	end

	userChangedSlider = false

	for _, slider in pairs(ns.sliders) do
		slider:SetValue(C[slider.group][slider.option])
		slider.textInput:SetText(floor(C[slider.group][slider.option]*1000)/1000)
		slider.textInput:SetCursorPosition(0)
		slider.oldValue = C[slider.group][slider.option]
	end

	userChangedSlider = true

	for _, editbox in pairs(ns.editboxes) do
		editbox:SetText(C[editbox.group][editbox.option])
		editbox:SetCursorPosition(0)
		editbox.oldValue = C[editbox.group][editbox.option]
	end

	-- for _, dropdown in pairs(ns.dropdowns) do
	-- 	local text = DropDownText[C[dropdown.group][dropdown.option]] or C[dropdown.group][dropdown.option]
	-- 	UIDropDownMenu_SetText(dropdown, text)
	-- 	dropdown.selectedValue = C[dropdown.group][dropdown.option]
	-- 	dropdown.oldValue = C[dropdown.group][dropdown.option]
	-- end
end

local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)

	StaticPopupDialogs['FREEUI_RESET'] = {
		text = ns.localization.misc.reset_check,
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			FreeUIGlobalConfig = {}
			FreeUIConfig = {}
			FreeUIOptionsGlobal[realm][name] = false
			FreeUIOptions = {}
			FreeUIOptionsPerChar = {}
			
			C.options = FreeUIOptions
			
			ReloadUI()
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
		preferredIndex = 5,
	}
	
	StaticPopupDialogs['FREEUI_PROFILE'] = {
		text = ns.localization.misc.profile_check,
		button1 = ACCEPT,
		button2 = CANCEL,
		OnAccept = function()
			if FreeUIOptionsFrame.profile:GetChecked() then
				FreeUIOptionsGlobal[realm][name] = true
			else
				FreeUIOptionsGlobal[realm][name] = false
			end
			changeProfile()
			ReloadUI()
		end,
		OnCancel = function()
			if FreeUIOptionsFrame.profile:GetChecked() then
				FreeUIOptionsFrame.profile:SetChecked(false)
			else
				FreeUIOptionsFrame.profile:SetChecked(true)
			end
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = false,
		preferredIndex = 5,
	}
	
	StaticPopupDialogs['FREEUI_RELOAD'] = {
		text = ns.localization.misc.reload_check,
		button1 = APPLY,
		button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
		OnAccept = function()
			ReloadUI()
		end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = true,
		preferredIndex = 5,
	}

	F.CreateMF(FreeUIOptionsFrame)
	F.CreateBDFrame(FreeUIOptionsFrame, nil, true)
	--F.CreateBDFrame(FreeUICreditsPanel, nil, true)

	FreeUIOptionsFrame.profile:SetChecked(FreeUIOptionsGlobal[realm][name])
	FreeUIOptionsFrame.profile:SetScript("OnClick", function()
		StaticPopup_Show("FREEUI_PROFILE")
	end)
	F.ReskinCheck(FreeUIOptionsFrame.profile)

	--[[ FreeUIOptionsFrame.install:SetScript('OnClick', function()
		F:GetModule('Install'):HelloWorld()
		FreeUIOptionsFrame:Hide()
	end)

	FreeUIOptionsFrame.reset:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_RESET')
	end) ]]

	FreeUIOptionsFrame.okay:SetScript('OnClick', function()
		f:Hide()
		if ns.needReload then
			StaticPopup_Show('FREEUI_RELOAD')
		end
	end)


	for _, panel in pairs(ns.panels) do
		panel.Title:SetTextColor(C.r, C.g, C.b)
		panel.subText:SetTextColor(.8, .8, .8)

		F.CreateBDFrame(panel, .5, true)
		F.ReskinScroll(panel.ScrollBar)
		
		F.ReskinIcon(panel.tab.icon)
		F.Reskin(panel.tab)
		panel.tab:SetBackdropColor(.03, .03, .03, .25)
		panel.tab.Text:SetFont(C.Assets.Fonts.Normal, 14, 'OUTLINE')
	end

	ns.SetActiveTab(FreeUIOptionsFrame.General.tab)

	for _, button in pairs(ns.buttons) do
		F.Reskin(button)
	end

	for _, checkbox in pairs(ns.checkboxes) do
		F.ReskinCheck(checkbox, true)
	end

	for _, radio in pairs(ns.radiobuttons) do
		F.ReskinRadio(radio)
	end

	for _, slider in pairs(ns.sliders) do
		F.ReskinSlider(slider)
		F.ReskinInput(slider.textInput)
		F.SetFS(slider.textInput, C.Assets.Fonts.Normal, 11, 'OUTLINE')
		F.SetFS(slider.lowText, C.Assets.Fonts.Normal, 11, 'OUTLINE')
		F.SetFS(slider.highText, C.Assets.Fonts.Normal, 11, 'OUTLINE')
	end

	for _, picker in pairs(ns.colourpickers) do
		local bg = F.CreateBDFrame(picker)
		local value = C[picker.group][picker.option]
		bg:SetBackdropColor(unpack(value))
		--picker.text:SetTextColor(unpack(value))
	end

	for _, editbox in pairs(ns.editboxes) do
		F.ReskinEditBox(editbox)
	end

	for _, dropdown in pairs(ns.dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	local logo = FreeUIOptionsFrame:CreateTexture()
	logo:SetSize(512, 128)
	logo:SetPoint('TOP')
	logo:SetTexture(C.Assets.Textures.logo_small)
	logo:SetScale(.3)
	logo:SetGradientAlpha('Vertical', C.r, C.g, C.b, 1, 1, 1, 1, 1)

	local desc = F.CreateFS(FreeUIOptionsFrame, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', 'configuration', {.5,.5,.5}, true, 'TOP', 0, -36)

	local lineLeft = CreateFrame('Frame', nil, FreeUIOptionsFrame)
	lineLeft:SetPoint('TOP', -60, -30)
	F.CreateGF(lineLeft, 120, 1, 'Horizontal', .7, .7, .7, 0, .7)
	lineLeft:SetFrameStrata('HIGH')

	local lineRight = CreateFrame('Frame', nil, FreeUIOptionsFrame)
	lineRight:SetPoint('TOP', 60, -30)
	F.CreateGF(lineRight, 120, 1, 'Horizontal', .7, .7, .7, .7, 0)
	lineRight:SetFrameStrata('HIGH')

	displaySettings()


	-- Insert FreeUI GUI button into game menu
	local b = CreateFrame('Button', 'GameMenuFrameFreeUI', GameMenuFrame, 'GameMenuButtonTemplate')
	b:SetText(C.Title)
	b:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	if C.Theme.reskin_blizz then F.Reskin(b) end

	GameMenuFrame:HookScript('OnShow', function(self)
		GameMenuButtonLogout:SetPoint('TOP', b, 'BOTTOM', 0, -14)
		self:SetHeight(self:GetHeight() + b:GetHeight() + 15)
	end)

	b:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		HideUIPanel(GameMenuFrame)
		FreeUIOptionsFrame:Show()
	end)
end)

