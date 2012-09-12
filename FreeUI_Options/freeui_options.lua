local F, C
local _, ns = ...

-- [[ Functions ]]

ns.categories = {}

local old = {}

local buttons = {}
local checkboxes = {}
local sliders = {}
local dropdowns = {}
local editboxes = {}
local tabs = {}

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
end

local onTabClick = function(tab)
	activeTab:SetBackdropColor(0, 0, 0, 0)
	setActiveTab(tab)
end

ns.addCategory = function(tag, name)
	local bu = CreateFrame("Frame", nil, FreeUIOptionsPanel)
	bu:SetPoint("TOPLEFT", 16, -offset)
	bu:SetSize(160, 50)

	bu.Text = bu:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	bu.Text:SetPoint("CENTER")
	bu.Text:SetText(ns.localization[tag])

	bu:SetScript("OnMouseUp", onTabClick)

	FreeUIOptionsPanel[name.."Button"] = bu

	tinsert(tabs, bu)

	offset = offset + 61
end

-- [[ Callbacks ]]

ns.refresh = function()
	for _, box in pairs(checkboxes) do
		box:SetChecked(C[box.group][box.option])
	end
end

ns.okay = function()
	-- refresh the 'old' table for the next options.cancel()
	F.CopyTable(C.options, old)
end

ns.cancel = function()
	-- copy the old values to the saved vars if they exist
	F.CopyTableExisting(old, C.options)
	-- also update the table that is actually used by the scripts
	F.CopyTableExisting(old, C)
end

ns.default = function()
	-- clear saved vars to reset to lua options, and set profile boolean to global
	FreeUIOptions = {}
	FreeUIOptionsPerChar = {}
	FreeUIOptionsGlobal[GetCVar("realmName")][UnitName("player")] = false
	C.options = FreeUIOptions
end

-- [[ Init ]]

local init = CreateFrame("Frame")
init:RegisterEvent("PLAYER_LOGIN")
init:SetScript("OnEvent", function()
	if not FreeUI then return end

	F, C = unpack(FreeUI)

	r, g, b = unpack(C.class)

	-- in case we hit cancel
	for _, group in pairs(ns.categories) do
		old[group] = {}
		F.CopyTable(C[group], old[group])
	end

	-- styling

	F.CreateBD(FreeUIOptionsPanel)
	F.CreateSD(FreeUIOptionsPanel)

	for _, tab in pairs(tabs) do
		F.CreateBD(tab, 0)
		F.CreateGradient(tab)
	end

	setActiveTab(FreeUIOptionsPanel.GeneralButton)

	F.Reskin(FreeUIOptionsPanel.Okay)
	F.Reskin(FreeUIOptionsPanelInstall)
	F.Reskin(FreeUIOptionsPanelReset)
	F.ReskinClose(FreeUIOptionsPanel.CloseButton)
	F.ReskinCheck(FreeUIOptionsPanel.Profile)

	for _, box in pairs(checkboxes) do
		F.ReskinCheck(box)
	end
end)