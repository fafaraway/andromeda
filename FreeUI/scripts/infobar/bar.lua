local F, C = unpack(select(2, ...))
local module = F:RegisterModule("infobar")
if not C.infoBar.enable then return end

local barAlpha, buttonAlpha

if C.infoBar.buttons_mouseover then
	barAlpha = 0.25
	buttonAlpha = 0
else
	barAlpha = 0.5
	buttonAlpha = 1
end

-- [[ Bar ]]

local bar = CreateFrame("Frame", "FreeUIMenubar", UIParent)
bar:SetFrameStrata("BACKGROUND")

RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")


bar:SetPoint("TOPLEFT", -1, 1)
bar:SetPoint("TOPRIGHT", 1, 1)


bar:SetHeight(C.infoBar.height)
F.CreateBD(bar, barAlpha)

bar.buttons = {}

local function onEvent(event)
	if event == "PLAYER_REGEN_DISABLED" then
		bar:SetBackdropBorderColor(1, 0, 0)
	else
		bar:SetBackdropBorderColor(0, 0, 0)
	end
end

F:RegisterEvent("PLAYER_REGEN_DISABLED", onEvent)
F:RegisterEvent("PLAYER_REGEN_ENABLED", onEvent)


-- [[ Buttons ]]

if not C.infoBar.enableButtons then return end

local POSITION_LEFT, POSITION_MIDDLE, POSITION_RIGHT = 1, 2, 3

local function fadeIn(self, elapsed)
	if barAlpha < .5 then
		barAlpha = barAlpha + elapsed
		buttonAlpha = buttonAlpha + (elapsed * 4)
	else
		barAlpha = .5
		buttonAlpha = 1
		self:SetScript("OnUpdate", nil)
	end

	self:SetBackdropColor(0, 0, 0, barAlpha)

	for _, button in pairs(bar.buttons) do
		button:SetAlpha(buttonAlpha)
	end
end

local function fadeOut(self, elapsed)
	if barAlpha > .25 then
		barAlpha = barAlpha - elapsed
		buttonAlpha = buttonAlpha - (elapsed * 4)
	else
		barAlpha = .25
		buttonAlpha = 0
		self:SetScript("OnUpdate", nil)
	end

	self:SetBackdropColor(0, 0, 0, barAlpha)

	for _, button in pairs(bar.buttons) do
		button:SetAlpha(buttonAlpha)
	end
end

local function showBar()
	bar:SetScript("OnUpdate", fadeIn)
	bar:SetFrameStrata("HIGH")
end
bar.showBar = showBar

local function hideBar()
	bar:SetScript("OnUpdate", fadeOut)
	bar:SetFrameStrata("BACKGROUND")
end
bar.hideBar = hideBar

if C.infoBar.buttons_mouseover then
	bar:SetScript("OnEnter", showBar)
	bar:SetScript("OnLeave", hideBar)
end

local function buttonOnEnterNoFade(self)
	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeaveNoFade(self)
	self:SetBackdropColor(0, 0, 0, .1)
end

local function buttonOnEnter(self)
	if C.infoBar.buttons_mouseover then
		showBar()
	end

	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeave(self)
	if C.infoBar.buttons_mouseover then
		hideBar()
	end

	self:SetBackdropColor(0, 0, 0, .1)
end

local function reanchorButtons()
	local leftOffset, rightOffset = 0, 0

	for i = 1, #bar.buttons do
		local bu = bar.buttons[i]

		if bu:IsShown() then
			if bu.position == POSITION_LEFT then
				bu:SetPoint("LEFT", bar, "LEFT", leftOffset, 0)
				leftOffset = leftOffset + 129
			elseif bu.position == POSITION_RIGHT then
				bu:SetPoint("RIGHT", bar, "RIGHT", rightOffset, 0)
				rightOffset = rightOffset - 129
			else
				bu:SetPoint("CENTER", bar)
			end
		end
	end
end

local function showButton(button)
	button:Show()
	reanchorButtons()
end

local function hideButton(button)
	button:Hide()
	reanchorButtons()
end

local function addButton(text, position, clickFunc)
	local bu = CreateFrame("Button", nil, bar)
	bu:SetPoint("TOP", bar, "TOP")
	bu:SetPoint("BOTTOM", bar, "BOTTOM")
	bu:SetWidth(130)
	F.CreateBD(bu, .1)

	if C.infoBar.buttons_mouseover then
		bu:SetAlpha(0)
	end

	local buText = F.CreateFS(bu, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
	buText:SetPoint("CENTER")
	buText:SetText(text)
	bu.Text = buText

	bu:SetScript("OnMouseUp", clickFunc)
	bu:SetScript("OnEnter", buttonOnEnter)
	bu:SetScript("OnLeave", buttonOnLeave)

	bu.position = position

	tinsert(bar.buttons, bu)

	reanchorButtons()

	return bu
end

bar.addButton = addButton


FreeUIStatsButton = addButton("", POSITION_MIDDLE, function()
	TimeManagerClockButton_OnClick(TimeManagerClockButton)
end)

FreeUIStatsButton:SetWidth(200)

addButton("Micro menu", POSITION_LEFT, function(self, button)
	if button == "RightButton" then
		local openbags
		for i = 1, NUM_CONTAINER_FRAMES do
				local containerFrame = _G["ContainerFrame"..i]
				if containerFrame:IsShown() then
					openbags = true
				end
		end
		if not openbags then
			OpenAllBags()
		else
			CloseAllBags()
		end
	else
		if DropDownList1:IsShown() then
			ToggleFrame(DropDownList1)
		else
			F.MicroMenu()
		end
	end
end)

addButton("Chat menu", POSITION_LEFT, function(self, button)
	if button == "RightButton" then
		local editBox = ChatEdit_ChooseBoxForSend()
		local chatFrame = editBox.chatFrame
		ChatFrame_OpenChat(StatReport(), chatFrame)
	 else
		ChatMenu:ClearAllPoints()

		ChatMenu:SetPoint("TOPLEFT", UIParent, 30, -30)

		ToggleFrame(ChatMenu)
	end
end)

--[[addButton("Toggle DBM", POSITION_LEFT, function(self, button)
	if IsAddOnLoaded("DBM-Core") then
		if button == "RightButton" then
			DBM:Disable()
			RaidNotice_AddMessage(RaidBossEmoteFrame, "FreeUI: |cffffffffDBM disabled.|r", ChatTypeInfo["RAID_WARNING"])
		else
			DBM:Enable()
			RaidNotice_AddMessage(RaidBossEmoteFrame, "FreeUI: |cffffffffDBM enabled.|r", ChatTypeInfo["RAID_WARNING"])
		end
	else
		EnableAddOn("DBM-Core")
		EnableAddOn("DBM-StatusBarTimers")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM enabled. Type|r /rl |cfffffffffor the changes to apply.|r", C.r, C.g, C.b)
	end
end)]]

addButton("Toggle Skada", POSITION_LEFT, function(self, button)
	if IsAddOnLoaded("Skada") then
		if button == "MiddleButton" then
			Skada:Reset()
		elseif button == "RightButton" then
			Skada:SetActive(false)
		else
			Skada:SetActive(true)
		end
	else
		EnableAddOn("Skada")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffSkada enabled. Type|r /rl |cfffffffffor the changes to apply.|r", C.r, C.g, C.b)
	end
end)

local specButton = addButton("Specialization", POSITION_RIGHT, function(self, button)
	local currentSpec = GetSpecialization()
	local numSpec = GetNumSpecializations()
	if not (currentSpec and numSpec) then return end

	if button == "LeftButton" then
		if (UnitLevel("player") > 10) then
			local index = currentSpec + 1
			if index > numSpec then
				index = 1
			end
			SetSpecialization(index)
		end
	elseif button =="RightButton" then
		local index = {}
		for i = 1, numSpec do
			index[i] = GetSpecializationInfo(i)
		end

		local currentId = GetLootSpecialization()
		if currentId == 0 then
			currentId = GetSpecializationInfo(currentSpec)
		end

		if currentId == index[1] then
			SetLootSpecialization(index[2])
		elseif currentId == index[2] then
			SetLootSpecialization(index[3] or index[1])
		elseif currentId == index[3] then
			SetLootSpecialization(index[4] or index[1])
		elseif currentId == index[4] then
			SetLootSpecialization(index[1])
		end
	else
		if not PlayerTalentFrame then
			LoadAddOn("Blizzard_TalentUI")
		end
		if not PlayerTalentFrame:IsShown() then
			ShowUIPanel(PlayerTalentFrame)
		else
			HideUIPanel(PlayerTalentFrame)
		end
	end
end)

specButton:RegisterEvent("PLAYER_LOGIN")
specButton:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
specButton:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
specButton:SetScript("OnEvent", function(self)
	local currentSpec = GetSpecialization()
	local lootSpecID = GetLootSpecialization()

	if currentSpec then
		local _, name = GetSpecializationInfo(currentSpec)
		local _, lootname = GetSpecializationInfoByID(lootSpecID)
		local role = GetSpecializationRole(currentSpec)
		local lootrole = GetSpecializationRoleByID(lootSpecID)
		if name then
			if not lootname or name == lootname then
				self.Text:SetText(format("S: %s", name))
			else
				self.Text:SetText(format("S: %s  L: %s", name, lootname))
			end

			if C.appearance.usePixelFont then
				self.Text:SetFont(unpack(C.font.pixel))
			elseif C.client == "zhCN" or C.client == "zhTW" then
				self.Text:SetFont(C.font.normal, 11)
			end

			showButton(self)
		end
	else
		hideButton(self)
	end
end)


local garrisonButton = addButton(GARRISON_LANDING_PAGE_TITLE, POSITION_RIGHT, GarrisonLandingPage_Toggle)
garrisonButton:Hide()

GarrisonLandingPageMinimapButton:SetSize(1, 1)
GarrisonLandingPageMinimapButton:SetAlpha(0)
GarrisonLandingPageMinimapButton:EnableMouse(false)
GarrisonLandingPageMinimapButton:HookScript("OnEvent", function(self, event)
	if event == "GARRISON_SHOW_LANDING_PAGE" and not garrisonButton:IsShown() then
		showButton(garrisonButton)
	elseif event == "GARRISON_HIDE_LANDING_PAGE" then
		hideButton(garrisonButton)
	end
end)
if C.appearance.usePixelFont then
	garrisonButton.Text:SetFont(unpack(C.font.pixel))
elseif C.client == "zhCN" or C.client == "zhTW" then
	garrisonButton.Text:SetFont(C.font.normal, 11)
end


-- money
local keys = {}

local addonLoaded
addonLoaded = function(_, addon)
	if addon ~= "FreeUI" then return end

	if FreeUIGlobalConfig[C.myRealm] == nil then FreeUIGlobalConfig[C.myRealm] = {} end

	if FreeUIGlobalConfig[C.myRealm].gold == nil then FreeUIGlobalConfig[C.myRealm].gold = {} end

	if FreeUIGlobalConfig[C.myRealm].class == nil then FreeUIGlobalConfig[C.myRealm].class = {} end
	FreeUIGlobalConfig[C.myRealm].class[C.myName] = select(2, UnitClass("player"))

	if FreeUIGlobalConfig[C.myRealm].faction == nil then FreeUIGlobalConfig[C.myRealm].faction = {} end
	FreeUIGlobalConfig[C.myRealm].faction[C.myName] = UnitFactionGroup("player")

	F:UnregisterEvent("ADDON_LOADED", addonLoaded)
	addonLoaded = nil
end
F:RegisterEvent("ADDON_LOADED", addonLoaded)

local function updateMoney()
	FreeUIGlobalConfig[C.myRealm].gold[C.myName] = GetMoney()
end

F:RegisterEvent("PLAYER_MONEY", updateMoney)
F:RegisterEvent("PLAYER_ENTERING_WORLD", updateMoney)

local FreeUIMoneyButton = addButton("", POSITION_RIGHT, function(self, button) end)

FreeUIMoneyButton:HookScript("OnEnter", function()
	GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -33)

	local total, totalAlliance, totalHorde, totalNeutral = 0, 0, 0, 0
	local goldList = FreeUIGlobalConfig[C.myRealm].gold
	local factionList = FreeUIGlobalConfig[C.myRealm].faction
	local allianceList, hordeList, neutralList = {}, {}, {}
	local headerAdded = false

	for k, v in pairs(goldList) do
		if factionList[k] == "Alliance" then
			totalAlliance = totalAlliance + v
			allianceList[k] = v
		elseif factionList[k] == "Horde" then
			totalHorde = totalHorde + v
			hordeList[k]= v
		else
			totalNeutral = totalNeutral + v
			neutralList[k] = v
		end

		total = total + v
	end

	GameTooltip:AddDoubleLine(C.myRealm, GetMoneyString(total), C.r, C.g, C.b, 1, 1, 1)

	for n in pairs(allianceList) do
		table.insert(keys, n)
	end
	table.sort(keys)

	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[C.myRealm].class[k]
		local v = allianceList[k]
		if v and v >= 10000 then
			if not headerAdded then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(strupper(FACTION_ALLIANCE), GetMoneyString(totalAlliance), 0, 0.68, 0.94, 1, 1, 1)
				headerAdded = true
			end
			GameTooltip:AddDoubleLine(k, GetMoneyString(v), C.classColors[class].r, C.classColors[class].g, C.classColors[class].b, 1, 1, 1)
		end
	end

	headerAdded = false
	table.wipe(keys)

	for n in pairs(hordeList) do
		table.insert(keys, n)
	end
	table.sort(keys)

	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[C.myRealm].class[k]
		local v = hordeList[k]
		if v and v >= 10000 then
			if not headerAdded then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(strupper(FACTION_HORDE), GetMoneyString(totalHorde), 1, 0, 0, 1, 1, 1)
				headerAdded = true
			end
			GameTooltip:AddDoubleLine(k, GetMoneyString(v), C.classColors[class].r, C.classColors[class].g, C.classColors[class].b, 1, 1, 1)
		end
	end

	headerAdded = false
	table.wipe(keys)

	for n in pairs(neutralList) do
		table.insert(keys, n)
	end
	table.sort(keys)

	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[C.myRealm].class[k]
		local v = neutralList[k]
		if v and v >= 10000 then
			if not headerAdded then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(strupper(FACTION_OTHER), GetMoneyString(totalNeutral), .9, .9, .9, 1, 1, 1)
				headerAdded = true
			end
			GameTooltip:AddDoubleLine(k, GetMoneyString(v), C.classColors[class].r, C.classColors[class].g, C.classColors[class].b, 1, 1, 1)
		end
	end

	GameTooltip:Show()
end)

FreeUIMoneyButton:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)

local function moneyFormat(money)
	--return format("|cffc1b37c"..BreakUpLargeNumbers(math.floor((money / 10000))).."|r")
	local goldString, silverString, copperString
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = mod(money, COPPER_PER_SILVER)
	goldString = format("|cffdbd368"..gold.."|r", 0, 0)
	silverString = format("|cffd9d6d3"..silver.."|r", 0, 0)
	copperString = format("|cffc19377"..copper.."|r", 0, 0)

	local moneyString = ""
	local separator = ""
	if ( gold > 0 ) then
		moneyString = goldString
		separator = " "
	end
	if ( silver > 0 ) then
		moneyString = moneyString..separator..silverString
		separator = " "
	end
	if ( copper > 0 or moneyString == "" ) then
		moneyString = moneyString..separator..copperString
	end
 
	return moneyString
end


local moneyHolder = CreateFrame("Frame", nil, FreeUIMoneyButton)
moneyHolder:SetFrameLevel(3)
moneyHolder:SetAllPoints(FreeUIMoneyButton)

local moneyText = moneyHolder:CreateFontString()
F.SetFS(moneyText)
moneyText:SetPoint("CENTER")

moneyHolder:RegisterEvent("PLAYER_ENTERING_WORLD")
moneyHolder:RegisterEvent("PLAYER_MONEY")
moneyHolder:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
moneyHolder:RegisterEvent("SEND_MAIL_COD_CHANGED")
moneyHolder:RegisterEvent("PLAYER_TRADE_MONEY")
moneyHolder:RegisterEvent("TRADE_MONEY_CHANGED")
moneyHolder:SetScript("OnEvent", function(self, event, ...)
	local tmpMoney = GetMoney()
	self.CurrentMoney = tmpMoney
	moneyText:SetText(moneyFormat(self.CurrentMoney))
end)





function module:OnLogin()
	

end




