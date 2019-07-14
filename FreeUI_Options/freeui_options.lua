local F, C, INSTALL
local _, ns = ...

local realm = GetRealmName()
local name = UnitName('player')


-- [[ Variables ]]

ns.locale = GetLocale()
ns.localization = {}

ns.categories = {}
ns.buttons = {}


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
local baseName = 'FreeUIOptionsPanel'

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
	end
end

local function toggle(self)
	local checked = self:GetChecked()

	if checked then
		PlaySound('856')
	else
		PlaySound('857')
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
	local f = CreateFrame('CheckButton', nil, parent.child, 'InterfaceOptionsCheckButtonTemplate')

	f.group = parent.tag
	f.option = option

	f.Text:SetText(ns.localization[parent.tag..option])
	if tooltipText then f.tooltipText = ns.localization[parent.tag..option..'Tooltip'] end

	f.needsReload = needsReload

	f:SetScript('OnClick', toggle)
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
	GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
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
		f.text:SetText(ns.localization[parent.tag..option..i])
		if tooltipText then
			f.tooltipText = ns.localization[parent.tag..option..i..'Tooltip']
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
		tinsert(radiobuttons, f)

		if i > 1 then
			f:SetPoint('TOP', parent[option..i-1], 'BOTTOM', 0, -8)
		end
	end

	local firstOption = parent[option..1]

	-- add header
	local header = firstOption:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	header:SetPoint('BOTTOMLEFT', firstOption, 'TOPLEFT', 2, 5)
	header:SetText(ns.localization[parent.tag..option])
	group.radioHeader = header

	return group
end

-- Sliders

local function onValueChanged(self, value)
	if self.option == 'uiScale' then
		value = string.format('%.2f', value)
	else
		value = floor(value+0.5)
	end

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
	local f = CreateFrame('Slider', baseName..option, parent.child, 'OptionsSliderTemplate')

	BlizzardOptionsPanel_Slider_Enable(f)

	f.group = parent.tag
	f.option = option


	_G[baseName..option..'Text']:SetFontObject(GameFontHighlightSmall)
	_G[baseName..option..'Text']:SetText(ns.localization[parent.tag..option])
	_G[baseName..option..'Low']:SetText(lowText)
	_G[baseName..option..'High']:SetText(highText)
	f:SetMinMaxValues(low, high)
	f:SetValueStep(step)

	f.tooltipText = ns.localization[parent.tag..option..'Tooltip']

	f.needsReload = needsReload

	f:SetScript('OnValueChanged', onValueChanged)
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

	local f = CreateFrame('EditBox', baseName..option..'TextInput', slider, 'InputBoxTemplate')
	f:SetAutoFocus(false)
	f:SetWidth(60)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	
	f:SetPoint('LEFT', slider, 'RIGHT', 20, 0)

	f.num = f:GetRegions()
	if f.num:GetObjectType() == 'FontString' then
		f.num:SetJustifyH("CENTER")
	end

	f:SetScript('OnEscapePressed', onSliderEscapePressed)
	f:SetScript('OnEnterPressed', onSliderEnterPressed)
	f:SetScript('OnEditFocusGained', nil)
	f:SetScript('OnEditFocusLost', onSliderEnterPressed)

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
	local f = CreateFrame('Button', nil, parent)
	f:SetSize(16, 16)

	local tex = f:CreateTexture(nil, 'OVERLAY')
	tex:SetAllPoints()
	f.tex = tex

	f.group = parent.tag
	f.option = option

	f.needsReload = needsReload

	f:SetScript('OnClick', onColourSwatchClicked)
	parent[option] = f

	tinsert(colourpickers, f)

	return f
end

-- [[ Categories and tabs ]]

local offset = 58
local activeTab = nil

local function setActiveTab(tab)
	activeTab = tab
	activeTab:SetBackdropColor(r, g, b, .6)
	activeTab.panel:Show()
end

local onTabClick = function(tab)
	activeTab.panel:Hide()
	activeTab:SetBackdropColor(0, 0, 0, 0)
	setActiveTab(tab)
end

ns.addCategory = function(name)
	local tag = strlower(name)

	local panel = CreateFrame('ScrollFrame', baseName..name, FreeUIOptionsPanel, 'UIPanelScrollFrameTemplate')
	panel:SetSize(460, 600)
	panel:SetPoint('TOPLEFT', 190, -60)
	panel:Hide()

	panel.child = CreateFrame('Frame', nil, panel)
	panel.child:SetPoint("TOPLEFT", 0, 0)
	panel.child:SetPoint("BOTTOMRIGHT", 0, 0)
	panel.child:SetSize(460, 800)

	panel:SetScrollChild(panel.child)

	panel.Title = panel.child:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	panel.Title:SetPoint('TOPLEFT', 8, -16)
	panel.Title:SetText(ns.localization[tag])

	panel.subText = panel.child:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	panel.subText:SetPoint('TOPLEFT', panel.Title, 'BOTTOMLEFT', 0, -8)
	panel.subText:SetJustifyH('LEFT')
	panel.subText:SetJustifyV('TOP')
	panel.subText:SetSize(600, 30)
	panel.subText:SetText(ns.localization[tag..'SubText'])

	local tab = CreateFrame('Button', nil, FreeUIOptionsPanel)
	tab:SetPoint('TOPLEFT', 10, -offset)
	tab:SetSize(160, 30)

	local icon = tab:CreateTexture(nil, 'OVERLAY')
	icon:SetSize(20, 20)
	icon:SetPoint('LEFT', tab, 6, 0)
	icon:SetTexCoord(.08, .92, .08, .92)
	tab.Icon = icon

	tab.Text = tab:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med3')
	tab.Text:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
	tab.Text:SetTextColor(.9, .9, .9)
	tab.Text:SetText(ns.localization[tag])

	tab:SetScript('OnMouseUp', onTabClick)

	tab.panel = panel
	panel.tab = tab
	panel.tag = tag

	FreeUIOptionsPanel[tag] = panel

	tinsert(panels, panel)

	offset = offset + 36
end

ns.addSubCategory = function(category, name)
	local header = category.child:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	header:SetText(name)
	header:SetTextColor(.5, .5, .5)

	local line = category.child:CreateTexture(nil, 'ARTWORK')
	line:SetSize(480, 1)
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


local init = CreateFrame('Frame')
init:RegisterEvent('PLAYER_LOGIN')
init:SetScript('OnEvent', function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)
	r, g, b = C.r, C.g, C.b
	INSTALL = F:GetModule('Install')

	StaticPopupDialogs['FREEUI_RESET'] = {
		text = ns.localization.resetCheck,
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			FreeUIGlobalConfig = {}
			FreeUIConfig = {}
			FreeUIOptionsGlobal[realm][name] = false
			FreeUIOptions = {}
			FreeUIOptionsPerChar = {}
			
			C.options = FreeUIOptions
			
			ReloadUI()
		end,
		whileDead = true,
		hideOnEscape = true,
	}

	local FreeUIOptionsPanel = FreeUIOptionsPanel

	FreeUIOptionsPanel.ProfileBox:SetChecked(FreeUIOptionsGlobal[realm][name])
	FreeUIOptionsPanel.ProfileBox:SetScript('OnClick', function(self)
		FreeUIOptionsGlobal[realm][name] = self:GetChecked()
		changeProfile()
		displaySettings()

		ReloadUI()
	end)

	FreeUIOptionsPanel.InstallButton:SetScript('OnClick', function()
		INSTALL.HelloWorld()
		FreeUIOptionsPanel:Hide()
	end)

	FreeUIOptionsPanel.ResetButton:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_RESET')
	end)

	F.CreateMF(FreeUIOptionsPanel)

	F.CreateBD(FreeUIOptionsPanel)
	F.CreateSD(FreeUIOptionsPanel)

	F.CreateBD(FreeUIOptionsPanel.CreditsFrame)
	F.CreateSD(FreeUIOptionsPanel.CreditsFrame)

	F.ReskinClose(FreeUIOptionsPanel.CloseButton)
	F.ReskinClose(FreeUIOptionsPanel.CreditsFrame.CloseButton)
	F.ReskinCheck(FreeUIOptionsPanel.ProfileBox)

	for _, panel in pairs(panels) do
		panel.tab:SetBackdropColor(0, 0, 0, 0)
		local bg = F.CreateBDFrame(panel.tab.Icon)
		F.Reskin(panel.tab)
		F.ReskinScroll(panel.ScrollBar)
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
		F.SetFS(slider.textInput)
		slider.textInput.num:SetTextColor(r, g, b)
		--F.SetFS(slider.text)
	end

	for _, picker in pairs(colourpickers) do
		picker.tex:SetTexture(C.media.bdTex)
		F.CreateBG(picker)
	end

	
	local title = F.CreateFS(FreeUIOptionsPanel, {C.font.normal, 18}, C.Title, nil, nil, true, 'TOP', 0, -10)
	local version = F.CreateFS(FreeUIOptionsPanel, 'pixel', C.Version, nil, 'grey', false, 'TOP', 0, -34)
	
	local lineLeft = CreateFrame('Frame', nil, FreeUIOptionsPanel)
	lineLeft:SetPoint('TOP', -50, -30)
	F.CreateGF(lineLeft, 100, 1, 'Horizontal', .7, .7, .7, 0, .7)
	lineLeft:SetFrameStrata('HIGH')

	local lineRight = CreateFrame('Frame', nil, FreeUIOptionsPanel)
	lineRight:SetPoint('TOP', 50, -30)
	F.CreateGF(lineRight, 100, 1, 'Horizontal', .7, .7, .7, .7, 0)
	lineRight:SetFrameStrata('HIGH')


	displaySettings()


	local menuButton = CreateFrame('Button', 'GameMenuFrameNDui', GameMenuFrame, 'GameMenuButtonTemplate')
	menuButton:SetText(C.Title)
	menuButton:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	GameMenuFrame:HookScript('OnShow', function(self)
		GameMenuButtonLogout:SetPoint('TOP', menuButton, 'BOTTOM', 0, -14)
		self:SetHeight(self:GetHeight() + menuButton:GetHeight() + 15)
	end)

	menuButton:SetScript('OnClick', function()
		FreeUIOptionsPanel:Show()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)
	F.Reskin(menuButton)
end)


