local F, C = unpack(select(2, ...))

if not IsAddOnLoaded("FreeUI_Options") then return end

local realm = GetCVar("realmName")
local name = UnitName("player")

-- create the profile boolean
if not FreeUIOptionsGlobal then FreeUIOptionsGlobal = {} end
if FreeUIOptionsGlobal[realm] == nil then FreeUIOptionsGlobal[realm] = {} end
if FreeUIOptionsGlobal[realm][name] == nil then FreeUIOptionsGlobal[realm][name] = false end

-- create the main options table
if FreeUIOptions == nil then FreeUIOptions = {} end

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

for group, options in pairs(profile) do
	if C[group] then
		local hasOptions = false
		for option, value in pairs(options) do
			if C[group][option] ~= nil then
				if C[group][option] == value then
					profile[group][option] = nil
				else
					hasOptions = true
					C[group][option] = value
				end
			end
		end
		if not hasOptions then profile[group] = nil end
	else
		profile[group] = nil
	end
end

C.options = profile