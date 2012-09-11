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

	-- in case we hit cancel
	for _, group in pairs(ns.categories) do
		old[group] = {}
		F.CopyTable(C[group], old[group])
	end

	local layoutToUse
	local layout = FreeUIOptionsPanelLayout
	if FreeUIConfig.layout == 1 then
		layout:SetText("Healer layout")
		layoutToUse = 2
	else
		layout:SetText("Dps/Tank layout")
		layoutToUse = 1
	end

	layout:SetScript("OnClick", function()
		FreeUIConfig.layout = layoutToUse
		ReloadUI()
	end)
	layout.text:SetText("Switch to the "..( FreeUIConfig.layout==1 and "Healer" or "Dps/Tank").." unitframe layout. This will reload the UI.")

	-- styling

	F.Reskin(layout)
	F.Reskin(FreeUIOptionsPanelInstall)
	F.Reskin(FreeUIOptionsPanelReset)

	for _, box in pairs(checkboxes) do
		F.ReskinCheck(box)
	end
end)