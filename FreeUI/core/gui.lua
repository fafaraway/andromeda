local F, C = unpack(select(2, ...))

if not IsAddOnLoaded("FreeUI_Options") then return end

local realm = C.myRealm
local name = C.myName

-- create the profile boolean
if not FreeUIOptionsGlobal then FreeUIOptionsGlobal = {} end
if FreeUIOptionsGlobal[realm] == nil then FreeUIOptionsGlobal[realm] = {} end
if FreeUIOptionsGlobal[realm][name] == nil then FreeUIOptionsGlobal[realm][name] = false end

-- create the main options table
if FreeUIOptions == nil then FreeUIOptions = {} end

local function copyTable(source, target)
	for key, value in pairs(source) do
		if type(value) == "table" then
			target[key] = {}
			copyTable(value, target[key])
		else
			target[key] = value
		end
	end
end

-- determine which settings to use
local profile
if FreeUIOptionsGlobal[realm][name] == true then
	if FreeUIOptionsPerChar == nil then
		FreeUIOptionsPerChar = {}
		CopyTable(FreeUIOptions, FreeUIOptionsPerChar)
	end
	profile = FreeUIOptionsPerChar
else
	profile = FreeUIOptions
end

--[[for group, options in pairs(profile) do
	if C[group] then
		for option, value in pairs(options) do
			if C[group][option] ~= nil then
				C[group][option] = value
			end
		end
	else
		profile[group] = nil
	end
end]]

local groups = {["general"] = true, ["actionbars"] = true, ["classmod"] = true, ["performance"] = true}

for group, options in pairs(C) do
	if groups[group] then
		if profile[group] == nil then profile[group] = {} end

		for option, value in pairs(options) do
			if profile[group][option] == nil then
				profile[group][option] = value
			else
				C[group][option] = profile[group][option]
			end
		end
	end
end

C.options = profile