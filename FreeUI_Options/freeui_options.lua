local F, C
local _, ns = ...

-- [[ Functions ]]

ns.categories = {}

local buttons = {}
local checkboxes = {}
local sliders = {}
local dropdowns = {}
local editboxes = {}
local panels = {}

local r, g, b

local function SaveValue(f, value)
	if not C.options[f.group] then C.options[f.group] = {} end
	if not C.options[f.group][f.option] then C.options[f.group][f.option] = {} end

	C.options[f.group][f.option] = value -- these are the saved variables
	C[f.group][f.option] = value -- and this is from the lua options
end

local function toggle(f)
	SaveValue(f, f:GetChecked() == 1)
end

ns.CreateCheckBox = function(parent, name, option)
	local f = CreateFrame("CheckButton", parent:GetName()..name, parent, "InterfaceOptionsCheckButtonTemplate")

	f.group = parent.tag
	f.option = option
	f.Text:SetText(ns.localization[parent.tag..option])

	f:SetScript("OnClick", toggle)

	tinsert(checkboxes, f)

	return f
end

local offset = 160
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

ns.addCategory = function(tag, name)
	local panel = CreateFrame("Frame", "FreeUIOptionsPanel"..name, FreeUIOptionsPanel)
	panel:SetSize(623, 568)
	panel:SetPoint("RIGHT", -16, 0)
	panel:Hide()

	panel.Title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	panel.Title:SetPoint("TOPLEFT", 8, -8)
	panel.Title:SetText(ns.localization[tag])

	panel.subText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	panel.subText:SetPoint("TOPLEFT", panel.Title, "BOTTOMLEFT", 0, -8)
	panel.subText:SetJustifyV("TOP")
	panel.subText:SetHeight(32)
	panel.subText:SetText(ns.localization[tag.."SubText"])

	local tab = CreateFrame("Frame", nil, FreeUIOptionsPanel)
	tab:SetPoint("TOPLEFT", 16, -offset)
	tab:SetSize(160, 50)

	tab.Text = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	tab.Text:SetPoint("CENTER")
	tab.Text:SetText(ns.localization[tag])

	tab:SetScript("OnMouseUp", onTabClick)

	tab.panel = panel
	panel.tab = tab
	panel.tag = tag

	FreeUIOptionsPanel[tag] = panel

	tinsert(panels, panel)

	offset = offset + 61
end

-- [[ Init ]]

local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_LOGIN")
init:SetScript("OnEvent", function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)

	r, g, b = unpack(C.class)

	-- styling

	F.CreateBD(FreeUIOptionsPanel)
	F.CreateSD(FreeUIOptionsPanel)

	for _, panel in pairs(panels) do
		F.CreateBD(panel.tab, 0)
		F.CreateBD(panel, .25)
		F.CreateGradient(panel.tab)
	end

	setActiveTab(FreeUIOptionsPanel.general.tab)

	F.Reskin(FreeUIOptionsPanel.Okay)
	F.Reskin(FreeUIOptionsPanelInstall)
	F.Reskin(FreeUIOptionsPanelReset)
	F.Reskin(GameMenuButtonFreeUI)
	F.ReskinClose(FreeUIOptionsPanel.CloseButton)
	F.ReskinCheck(FreeUIOptionsPanel.Profile)

	for _, box in pairs(checkboxes) do
		F.ReskinCheck(box)
	end
end)