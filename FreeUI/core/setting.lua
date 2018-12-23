local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("setting")
local pairs, tonumber, wipe = pairs, tonumber, table.wipe
local min, max, format = math.min, math.max, string.format

-- CVars
local function ForceDefaultSettings()
	SetCVar("ActionButtonUseKeyDown", 1)
	SetCVar("autoLootDefault", 1)
	SetCVar("alwaysCompareItems", 0)
	SetCVar("autoSelfCast", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("showTutorials", 0)
	SetCVar("alwaysShowActionBars", 0)
	SetCVar("lockActionBars", 1)
	SetCVar("overrideArchive", 0)
	SetCVar("WorldTextScale", 1.5)
end

-- UI scale
local function SetupUIScale()
	local scale = C.appearance.uiScale
	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	if C.appearance.uiScaleAuto then
		scale = 768 / pysHeight
		scale = tonumber(floor(scale*100 + .5)/100)
	end

	_G.SetCVar("useUiScale", 1)
	_G.SetCVar("uiScale", scale)
	_G.UIParent:SetScale(scale)

	--local cvarScale, parentScale = _G.GetCVar("uiscale"), _G.UIParent:GetScale()
	--print(cvarScale)
	--print(parentScale)
	--print(scale)
end

function module:OnLogin()
	ForceDefaultSettings()

	F.HideOption(Advanced_UseUIScale)
	F.HideOption(Advanced_UIScaleSlider)
	SetupUIScale()
end

