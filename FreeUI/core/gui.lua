local F, C = unpack(select(2, ...))


local defaultSettings = {
	BfA = false,
	classic = false,
	
	installComplete = false,

	uiAnchor = {},
	uiTempAnchor = {},

	

	mapReveal = false,
	quickQuest = false,

	clickCast = {},
	
	inventory = {
		autoSellJunk = false,
		autoRepair = false,
		favouriteItems = {},
	},
	actionbar = {
		bindType = 1,
	},

	unitframe = {
		layout = 'DPS',
	},
	


}

local accountSettings = {

	totalGold = {},
	keystoneInfo = {},

	customJunkList = {},
}

local function InitialSettings(source, target, fullClean)
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

	InitialSettings(defaultSettings, FreeUIConfig, true)
	InitialSettings(accountSettings, FreeUIGlobalConfig)
	
	F:SetupUIScale(true)

	self:UnregisterAllEvents()
end)



if not IsAddOnLoaded("FreeUI_Options") then return end

local realm = GetRealmName()
local name = UnitName("player")

-- create the profile boolean
if not FreeUIOptionsGlobal then FreeUIOptionsGlobal = {} end
if FreeUIOptionsGlobal[realm] == nil then FreeUIOptionsGlobal[realm] = {} end
if FreeUIOptionsGlobal[realm][name] == nil then FreeUIOptionsGlobal[realm][name] = false end

-- create the main options table
if FreeUIOptions == nil then FreeUIOptions = {} end

-- determine which settings to use
local profile
if FreeUIOptionsGlobal[realm][name] == true then
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