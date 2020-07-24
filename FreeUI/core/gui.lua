local F, C = unpack(select(2, ...))


local characterSettings = {
	['BfA'] = false,
	['classic'] = false,
	['installation_complete'] = false,
	['ui_anchor'] = {},
	['ui_anchor_temp'] = {},
	['map_reveal'] = false,
	['quick_quest'] = false,
	['bind_type'] = 1,
	['favourite_items'] = {},
	['click_cast'] = {},
}

local accountSettings = {
	['ui_scale'] = 1,
	['ui_padding'] = 33,
	['total_gold'] = {},
	['auto_sell_junk'] = false,
	['auto_repair'] = false,
	['custom_junk_list'] = {},
	['number_format'] = 1,
	['keystone_info'] = {},
}

local function initSettings(source, target, fullClean)
	for i, j in pairs(source) do
		if type(j) == "table" then
			if target[i] == nil then target[i] = {} end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then target[i] = j end
		end
	end

	for i, j in pairs(target) do
		if source[i] == nil then target[i] = nil end
		if fullClean and type(j) == "table" then
			for k, v in pairs(j) do
				if type(v) ~= "table" and source[i] and source[i][k] == nil then
					target[i][k] = nil
				end
			end
		end
	end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, addon)
	if addon ~= 'FreeUI' then return end

	if not FreeUIConfig['BfA'] then
		FreeUIConfig = {}
		FreeUIConfig['BfA'] = true
	end

	initSettings(characterSettings, FreeUIConfig, true)
	initSettings(accountSettings, FreeUIGlobalConfig)
	
	F:SetupUIScale(true)

	self:UnregisterAllEvents()
end)


if not IsAddOnLoaded('FreeUI_Options') then return end

-- create the profile boolean
if not FreeUIOptionsGlobal then FreeUIOptionsGlobal = {} end
if FreeUIOptionsGlobal[C.MyRealm] == nil then FreeUIOptionsGlobal[C.MyRealm] = {} end
if FreeUIOptionsGlobal[C.MyRealm][C.MyName] == nil then FreeUIOptionsGlobal[C.MyRealm][C.MyName] = false end

-- create the main options table
if FreeUIOptions == nil then FreeUIOptions = {} end

-- determine which settings to use
local profile
if FreeUIOptionsGlobal[C.MyRealm][C.MyName] == true then
	if FreeUIOptionsPerChar == nil then
		FreeUIOptionsPerChar = {}
	end
	profile = FreeUIOptionsPerChar
else
	profile = FreeUIOptions
end

-- apply or remove saved settings as needed
for group, options in pairs(profile) do
	if C[group] then
		for option, value in pairs(options) do
			if C[group][option] == nil or C[group][option] == value then
				-- remove saved vars if they do not exist in lua config anymore, or are the same as the lua config
				profile[group][option] = nil
			else
				C[group][option] = value
			end
		end
	else
		profile[group] = nil
	end
end

-- add global options variable
C.options = profile