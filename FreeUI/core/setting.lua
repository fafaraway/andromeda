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
	versionCheck = true,
	totalGold = {},
}

local function InitialSettings(source, target)
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

	for i in pairs(target) do
		if source[i] == nil then target[i] = nil end
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "FreeUI" then return end
	if not FreeUIConfig["BfA"] then
		FreeUIConfig = {}
		FreeUIConfig["BfA"] = true
	end

	InitialSettings(defaultSettings, FreeUIConfig)
	InitialSettings(accountSettings, FreeUIGlobalConfig)

	self:UnregisterAllEvents()
end)


-- Addon Info
DEFAULT_CHAT_FRAME:AddMessage(C.Title..' - '..C.MyColor..C.Version)
DEFAULT_CHAT_FRAME:AddMessage(C.InfoColor..L["VERSION_INFO"])



-- CVars
function F:ForceDefaultSettings()
	SetCVar("autoLootDefault", 1)
	SetCVar("lootUnderMouse", 1)

	SetCVar("alwaysCompareItems", 0)

	SetCVar("autoSelfCast", 1)

	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowSelf", 0)
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateMotion", 1)
	SetCVar("nameplateShowFriendlyNPCs", 0)

	SetCVar("alwaysShowActionBars", 0)
	SetCVar("lockActionBars", 1)
	SetCVar("ActionButtonUseKeyDown", 1)
	SetActionBarToggles(1, 1, 1, 1)
	SHOW_MULTI_ACTIONBAR_4 = 1
	SHOW_MULTI_ACTIONBAR_3 = 1
	SHOW_MULTI_ACTIONBAR_2 = 1
	SHOW_MULTI_ACTIONBAR_1 = 1
	MultiActionBar_Update()
	
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatHealing", 1)
	SetCVar("floatingCombatTextCombatDamageDirectionalScale", 1)
	SetCVar("floatingCombatTextFloatMode", 1)
	SetCVar("WorldTextScale", 1.5)

	SetCVar("screenshotQuality", 10)
	SetCVar("showTutorials", 0)
	SetCVar("overrideArchive", 0)
	
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)

end



-- UI scale
function F:SetupUIScale()
	if FreeUIConfig["installComplete"] ~= true then return end

	local scale
	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	local fixedHeight = 768 / pysHeight

	if C.general.uiScaleAuto then
		scale = tonumber(floor(fixedHeight*100 + .5)/100)
		F.HideOption(Advanced_UseUIScale)
		F.HideOption(Advanced_UIScaleSlider)
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", scale)
		UIParent:SetScale(scale)
	else
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", C.general.uiScale)
		UIParent:SetScale(C.general.uiScale)
	end
end

-- Chat setting
function F:ForceChatSettings()
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 50)
	ChatFrame1:SetWidth(380)
	ChatFrame1:SetHeight(200)
    ChatFrame1:SetUserPlaced(true)
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		ChatFrame_RemoveMessageGroup(cf, "CHANNEL")
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, true)
end


-- Tutorial
--[[local tutor
local function YesTutor()
	if tutor then tutor:Show() return end
	tutor = CreateFrame("Frame", nil, UIParent)
	tutor:SetPoint("CENTER")
	tutor:SetSize(400*C.Mult, 250*C.Mult)
	tutor:SetFrameStrata("HIGH")
	tutor:SetScale(1)
	F.CreateMF(tutor)
	F.CreateBD(tutor)
	F.CreateSD(tutor)
	local ll = CreateFrame("Frame", nil, tutor)
	ll:SetPoint("TOP", -40, -32)
	F.CreateGF(ll, 80, 1, "Horizontal", .7, .7, .7, 0, .7)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, tutor)
	lr:SetPoint("TOP", 40, -32)
	F.CreateGF(lr, 80, 1, "Horizontal", .7, .7, .7, .7, 0)
	lr:SetFrameStrata("HIGH")

	local title = F.CreateFSAlt(tutor, 16, "", 'yellow', true, "TOP", 0, -10)
	local body = F.CreateFSAlt(tutor, 12, "", true, true, "TOPLEFT", 20, -50)
	body:SetPoint("BOTTOMRIGHT", -20, 50)
	body:SetJustifyV("TOP")
	body:SetJustifyH("LEFT")
	body:SetWordWrap(true)
	local foot = F.CreateFSAlt(tutor, 12, "", true, true, "BOTTOM", 0, 10)

	local pass = F.CreateButton(tutor, 60*C.Mult, 24*C.Mult, L["SKIP"], true)
	pass:SetPoint("BOTTOMLEFT", 10, 10)
	F.Reskin(pass)
	local apply = F.CreateButton(tutor, 60*C.Mult, 24*C.Mult, L["APPLY"], true)
	apply:SetPoint("BOTTOMRIGHT", -10, 10)
	F.Reskin(apply)

	local titles = {L["DEFAULT_SETTINGS"], L["UI_SCALE"], L["CHATFRAME"], L["SKINS"], L["COMPLETED"]}
	local function RefreshText(page)
		title:SetText(titles[page])
		body:SetText(L["TUTORIAL_PAGE_"..page])
		foot:SetText(page.."/5")
	end
	RefreshText(1)

	local currentPage = 1
	pass:SetScript("OnClick", function()
		if currentPage > 3 then pass:Hide() end
		currentPage = currentPage + 1
		RefreshText(currentPage)
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	end)
	apply:SetScript("OnClick", function()
		pass:Show()
		if currentPage == 1 then
			ForceDefaultSettings()
			ForceRaidFrame()
			UIErrorsFrame:AddMessage(C.InfoColor..L["DEFAULT_SETTINGS_CHECK"])
		elseif currentPage == 2 then
			FreeUIGlobalConfig["LockUIScale"] = true
			SetupUIScale()
			FreeUIGlobalConfig["LockUIScale"] = false
			UIErrorsFrame:AddMessage(C.InfoColor..L["UI_SCALE_CHECK"])
		elseif currentPage == 3 then
			ForceChatSettings()
			UIErrorsFrame:AddMessage(C.InfoColor..L["CHAT_SETTINGS_CHECK"])
		elseif currentPage == 4 then
			FreeUIGlobalConfig["DBMRequest"] = true
			FreeUIGlobalConfig["SkadaRequest"] = true
			FreeUIGlobalConfig["BWRequest"] = true
			--ForceAddonSkins()
			UIErrorsFrame:AddMessage(C.InfoColor..L["TUTORIAL_COMPLETE"])
			pass:Hide()
		elseif currentPage == 5 then
			tutor:Hide()
			StaticPopup_Show("RELOAD_FREEUI")
			currentPage = 0
		end

		currentPage = currentPage + 1
		RefreshText(currentPage)
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	end)
end

local welcome
function F:HelloWorld()
	if welcome then welcome:Show() return end
	welcome = CreateFrame("Frame", "HelloWorld", UIParent)
	welcome:SetPoint("CENTER")
	welcome:SetSize(400*C.Mult, 440*C.Mult)
	welcome:SetScale(1)
	welcome:SetFrameStrata("HIGH")
	F.CreateMF(welcome)
	F.CreateBD(welcome)
	F.CreateSD(welcome)


	F.CreateFSAlt(welcome, 16, C.Title, true, true, "TOP", 0, -14)
	F.CreateFSAlt(welcome, 'pixel', C.Version, 'grey', false, "TOP", 0, -40)

	local ll = CreateFrame("Frame", nil, welcome)
	ll:SetPoint("TOP", -50, -35)
	F.CreateGF(ll, 100, 1, "Horizontal", .7, .7, .7, 0, .7)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, welcome)
	lr:SetPoint("TOP", 50, -35)
	F.CreateGF(lr, 100, 1, "Horizontal", .7, .7, .7, .7, 0)
	lr:SetFrameStrata("HIGH")
	F.CreateFSAlt(welcome, 12, L["HELP_INFO_1"], true, true, "TOPLEFT", 20, -80)
	F.CreateFSAlt(welcome, 12, L["HELP_INFO_2"], true, true, "TOPLEFT", 20, -100)

	

	local c1, c2 = "|cffff2735", "|cff3a9d36"
	local lines = {
		c1.." /freeui  "..c2..L["HELP_INFO_3"],
		c1.." /freeui install  "..c2..L["HELP_INFO_4"],
		c1.." /freeui reset  "..c2..L["HELP_INFO_5"],
		c1.." /freeui dps  "..c2..L["HELP_INFO_6"],
		c1.." /freeui healer  "..c2..L["HELP_INFO_7"],
		c1.." /freeui hb  "..c2..L["HELP_INFO_8"],
		c1.." /freeui cl  "..c2..L["HELP_INFO_9"],
	}
	for index, line in pairs(lines) do
		F.CreateFSAlt(welcome, 12, line, true, true, "TOPLEFT", 30, -120 - index*20)
	end

	F.CreateFSAlt(welcome, 12, L["HELP_INFO_10"], true, true, "TOPLEFT", 20, -310)
	F.CreateFSAlt(welcome, 12, L["HELP_INFO_11"], true, true, "TOPLEFT", 20, -330)

	local close = CreateFrame("Button", nil, welcome)
	close:SetPoint("TOPRIGHT", -10, -10)
	close:SetSize(17*C.Mult, 17*C.Mult)
	close:SetScript("OnClick", function() welcome:Hide() end)
	F.ReskinClose(close)

	local goTutor = F.CreateButton(welcome, 100*C.Mult, 24*C.Mult, L["TUTORIAL"])
	goTutor:SetPoint("BOTTOM", 0, 10)
	goTutor:SetScript("OnClick", function() welcome:Hide() YesTutor() end)
	F.Reskin(goTutor)
end]]




--function module:OnLogin()
--	if not FreeUIConfig["Install"] then FreeUIConfig["Install"] = {} end
--	if FreeUIConfig["Install"]["Complete"] == true then
--		F.HideOption(Advanced_UseUIScale)
--		F.HideOption(Advanced_UIScaleSlider)
--		self:SetupUIScale()
--	end
--end

--local f = CreateFrame("Frame")
--f:RegisterEvent("ADDON_LOADED")
--f:RegisterEvent("PLAYER_LOGIN")
--f:SetScript("OnEvent", function(self, event, addon)
--	if not FreeUIConfig["Install"] then FreeUIConfig["Install"] = {} end
--	if FreeUIConfig["Install"]["Complete"] == true then
--		F.HideOption(Advanced_UseUIScale)
--		F.HideOption(Advanced_UIScaleSlider)
--		F:SetupUIScale()
--	end
--end)



local f = CreateFrame("Frame")

f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, addon)
	F:SetupUIScale()

	--print('cvarScale - '.._G.GetCVar("uiscale"))
	--print('parentScale - '.._G.UIParent:GetScale())
end)