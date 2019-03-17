local F, C, L = unpack(select(2, ...))

local pairs, tonumber, wipe = pairs, tonumber, table.wipe
local min, max, format = math.min, math.max, string.format



local defaultSettings = {
	BfA = false,
	mover = {},
	tempAnchor = {},
	clickCast = {},
	installComplete = false,
}

local accountSettings = {
	totalGold = {},
	keystoneInfo = {},
}

local function InitialSettings(source, target)
	for i, j in pairs(source) do
		if type(j) == 'table' then
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

	for i in pairs(target) do
		if source[i] == nil then target[i] = nil end
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

	InitialSettings(defaultSettings, FreeUIConfig)
	InitialSettings(accountSettings, FreeUIGlobalConfig)

	self:UnregisterAllEvents()
end)


-- Addon Info
DEFAULT_CHAT_FRAME:AddMessage(C.Title..' - '..C.MyColor..C.Version)
DEFAULT_CHAT_FRAME:AddMessage(C.InfoColor..L['VERSION_INFO'])



-- CVars
function F:ForceDefaultSettings()
	SetCVar('autoLootDefault', 1)
	SetCVar('lootUnderMouse', 1)

	SetCVar('alwaysCompareItems', 0)

	SetCVar('autoSelfCast', 1)

	SetCVar('nameplateShowEnemies', 1)
	SetCVar('nameplateShowSelf', 0)
	SetCVar('nameplateShowAll', 1)
	SetCVar('nameplateMotion', 1)
	SetCVar('nameplateShowFriendlyNPCs', 0)
	SetCVar('nameplateOtherTopInset', 0.08)
	SetCVar('nameplateSelectedScale', 1)
	SetCVar('nameplateLargerScale', 1)

	SetCVar('alwaysShowActionBars', 1)
	SetCVar('lockActionBars', 1)
	SetCVar('ActionButtonUseKeyDown', 1)
	SetActionBarToggles(1, 1, 1, 1)
	SHOW_MULTI_ACTIONBAR_4 = 1
	SHOW_MULTI_ACTIONBAR_3 = 1
	SHOW_MULTI_ACTIONBAR_2 = 1
	SHOW_MULTI_ACTIONBAR_1 = 1
	MultiActionBar_Update()
	
	SetCVar('floatingCombatTextCombatDamage', 1)
	SetCVar('floatingCombatTextCombatHealing', 1)
	SetCVar('floatingCombatTextCombatDamageDirectionalScale', 1)
	SetCVar('floatingCombatTextFloatMode', 1)
	SetCVar('WorldTextScale', 1.5)

	SetCVar('cameraDistanceMaxZoomFactor', 2.6)

	SetCVar('screenshotQuality', 10)
	SetCVar('showTutorials', 0)
	SetCVar('profanityFilter', 0)
	SetCVar('breakUpLargeNumbers', 1)
	SetCVar('overrideArchive', 0)
	SetCVar('cameraYawMoveSpeed', 120)
	SetCVar('rawMouseEnable', 1)
end



-- UI scale
function F:SetupUIScale()
	if FreeUIConfig['installComplete'] ~= true then return end

	local scale
	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	local fixedHeight = 768 / pysHeight

	if C.general.uiScaleAuto then
		scale = tonumber(floor(fixedHeight*100 + .5)/100)
		F.HideOption(Advanced_UseUIScale)
		F.HideOption(Advanced_UIScaleSlider)
		SetCVar('useUiScale', 1)
		SetCVar('uiScale', scale)
		UIParent:SetScale(scale)
	else
		SetCVar('useUiScale', 1)
		SetCVar('uiScale', C.general.uiScale)
		UIParent:SetScale(C.general.uiScale)
	end
end

-- Chat setting
function F:ForceChatSettings()
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 50, 50)
	ChatFrame1:SetWidth(380)
	ChatFrame1:SetHeight(200)
    ChatFrame1:SetUserPlaced(true)
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G['ChatFrame'..i]
		ChatFrame_RemoveMessageGroup(cf, 'CHANNEL')
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, true)
end




local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function(self, event, addon)
	F:SetupUIScale()

	--print('cvarScale - '.._G.GetCVar('uiscale'))
	--print('parentScale - '.._G.UIParent:GetScale())
end)