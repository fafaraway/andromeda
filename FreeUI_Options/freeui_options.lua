local F, C
local _, ns = ...

-- [[ Functions ]]

ns.categories = {}
ns.buttons = {}
ns.protectOptions = {}

local checkboxes = {}
local sliders = {}
local dropdowns = {}
local panels = {}

local old = {} -- to keep track of whether or not reload is needed
local needsReload = false
local userChangedSlider = true -- to use SetValue without running OnValueChanged code
local baseName = "FreeUIOptionsPanel"

local r, g, b

local function setReloadNeeded(isNeeded)
	FreeUIOptionsPanel.reloadText:SetShown(isNeeded)
	ns.needReload = isNeeded -- for the popup when clicking okay
end

local function SaveValue(f, value)
	if not C.options[f.group] then C.options[f.group] = {} end
	if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

	C.options[f.group][f.option] = value -- these are the saved variables
	C[f.group][f.option] = value -- and this is from the lua options
end

local function toggleChildren(self, checked)
	local tR, tG, tB
	if checked then
		tR, tG, tB = 1, 1, 1
	else
		tR, tG, tB = .5, .5, .5
	end

	for _, child in next, self.children do
		child:SetEnabled(checked)
		child.Text:SetTextColor(tR, tG, tB)
	end
end

local function toggle(self)
	local checked = self:GetChecked() == 1

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
		for checkbox, value in pairs(old) do
			if C[checkbox.group][checkbox.option] ~= value then
				setReloadNeeded(true)
				break
			else
				setReloadNeeded(false)
			end
		end
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

local function onValueChanged(self, value)
	value = floor(value+0.5)

	if self.textInput then
		self.textInput:SetText(value)
	end

	if userChangedSlider then
		SaveValue(self, value)

		setReloadNeeded(true)
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

local function onEscapePressed(self)
	self:ClearFocus()
end

local function onEnterPressed(self)
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

ns.CreateNumberSlider = function(parent, option, lowText, highText, low, high, step, alignRight, needsReload)
	local slider = createSlider(parent, option, lowText, highText, low, high, step, needsReload)

	local f = CreateFrame("EditBox", baseName..option.."TextInput", slider)
	f:SetAutoFocus(false)
	f:SetWidth(60)
	f:SetHeight(20)
	f:SetMaxLetters(8)
	f:SetFontObject(GameFontHighlight)

	f:SetPoint("LEFT", slider, "RIGHT", 20, 0)

	f:SetScript("OnEscapePressed", onEscapePressed)
	f:SetScript("OnEnterPressed", onEnterPressed)

	slider.textInput = f

	return slider
end

local offset = 60
local activeTab = nil

local function setActiveTab(tab)
	activeTab = tab
	activeTab:SetBackdropColor(r, g, b, .2)
	activeTab.panel:Show()
end

local onTabClick = function(tab)
	activeTab:SetBackdropColor(0, 0, 0, 0)
	activeTab.panel:Hide()
	setActiveTab(tab)
end

local function colourTab(f)
	f.Text:SetTextColor(1, 1, 1)
end

local function clearTab(f)
	f.Text:SetTextColor(1, .82, 0)
end

ns.addCategory = function(name)
	local tag = strlower(name)

	local panel = CreateFrame("Frame", baseName..name, FreeUIOptionsPanel)
	panel:SetSize(623, 568)
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
	tab:SetPoint("TOPLEFT", 16, -offset)
	tab:SetSize(160, 44)

	local icon = tab:CreateTexture(nil, "OVERLAY")
	icon:SetSize(32, 32)
	icon:SetPoint("LEFT", tab, "LEFT", 8, 0)
	icon:SetTexCoord(.08, .92, .08, .92)
	tab.Icon = icon

	tab.Text = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	tab.Text:SetPoint("LEFT", icon, "RIGHT", 8, 0)
	tab.Text:SetText(ns.localization[tag])

	tab:SetScript("OnMouseUp", onTabClick)
	tab:SetScript("OnEnter", colourTab)
	tab:SetScript("OnLeave", clearTab)

	tab.panel = panel
	panel.tab = tab
	panel.tag = tag

	FreeUIOptionsPanel[tag] = panel

	tinsert(panels, panel)

	offset = offset + 52
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

	userChangedSlider = false

	for _, slider in pairs(sliders) do
		slider:SetValue(C[slider.group][slider.option])
		slider.textInput:SetText(floor(C[slider.group][slider.option]*1000)/1000)
		slider.textInput:SetCursorPosition(0)
	end

	userChangedSlider = true
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
		FreeUIOptionsGlobal[C.myRealm][C.myName] = self:GetChecked() == 1
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
	F.CreateBD(resetFrame)
	F.ReskinClose(FreeUIOptionsPanel.CloseButton)
	F.ReskinCheck(FreeUIOptionsPanel.ProfileBox)
	F.ReskinCheck(resetFrame.Data)
	F.ReskinCheck(resetFrame.Options)

	for _, panel in pairs(panels) do
		F.CreateBD(panel.tab, 0)
		F.CreateGradient(panel.tab)
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

	for _, slider in pairs(sliders) do
		F.ReskinSlider(slider)
		F.ReskinInput(slider.textInput)
	end

	for _, setting in pairs(ns.classOptions) do
		local colour = C.classcolours[strupper(setting.option)]
		setting.Text:SetTextColor(colour.r, colour.g, colour.b)
	end

	F.ReskinInput(resetFrame.charBox)

	local colour = C.classcolours["PALADIN"]
	FreeUIOptionsPanel.classmod.paladinHP.Text:SetTextColor(colour.r, colour.g, colour.b)
	FreeUIOptionsPanel.classmod.paladinRF.Text:SetTextColor(colour.r, colour.g, colour.b)

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