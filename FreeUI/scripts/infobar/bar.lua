local F, C = unpack(select(2, ...))

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


bar:SetHeight(14)
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


-- [[ Report ]]

local function Talent()
	local Spec = GetSpecialization()
	local SpecName = Spec and select(2, GetSpecializationInfo(Spec)) or "无"
	return SpecName
end

local function HealText()
	local HP = UnitHealthMax("player")
	if HP > 1e4 then
		return format('%.2f万',HP/1e4)
	else
		return HP
	end
end

local function BaseInfo()
	local BaseStat = ""
	BaseStat = BaseStat..("%s"):format(Talent())
	BaseStat = BaseStat..("%s "):format(UnitClass("player"))
	BaseStat = BaseStat..("最高装等:%.1f 当前:%.1f "):format(GetAverageItemLevel())
	BaseStat = BaseStat..("血量:%s "):format(HealText())
	return BaseStat
end

local function DpsInfo()
	local DpsStat={"", "", ""}
	local specAttr={
		WARRIOR={1,1,1},
		DEATHKNIGHT={1,1,1},
		DEMONHUNTER={2,2},
		ROGUE={2,2,2},
		HUNTER={2,2,2},
		MAGE={3,3,3},
		WARLOCK={3,3,3},
		PRIEST={3,3,3},
		SHAMAN={3,2,3},
		MONK={2,3,2},
		DRUID={3,2,2,3},
		PALADIN={3,1,1}
	}
	local specId = GetSpecialization()
	local classCN,classEnName = UnitClass("player")
	local classSpecArr = specAttr[classEnName]
	DpsStat[1] = ("力量:%s "):format(UnitStat("player", 1))
	DpsStat[2] = ("敏捷:%s "):format(UnitStat("player", 2))
	DpsStat[3] = ("智力:%s "):format(UnitStat("player", 4))
	return DpsStat[classSpecArr[specId]]
end

local function TankInfo()
	local TankStat = ""
	TankStat = TankStat..("耐力:%s "):format(UnitStat("player", 3))
	TankStat = TankStat..("护甲:%s "):format(UnitArmor("player"))
	TankStat = TankStat..("闪避:%.2f%% "):format(GetDodgeChance())
	TankStat = TankStat..("招架:%.2f%% "):format(GetParryChance())
	TankStat = TankStat..("格挡:%.2f%% "):format(GetBlockChance())
	return TankStat
end

local function HealInfo()
	local HealStat = ""
	HealStat = HealStat..("法力回复:%d "):format(GetManaRegen()*5)
	return HealStat
end

local function MoreInfo()
	local MoreStat = ""
	MoreStat = MoreStat..("爆击:%.2f%% "):format(GetCritChance())
	MoreStat = MoreStat..("急速:%.2f%% "):format(GetMeleeHaste())
	MoreStat = MoreStat..("精通:%.2f%% "):format(GetMasteryEffect())
	return MoreStat
end

local function Versatility_DONE()
	local Versatility_DONE = ""
	Versatility_DONE = Versatility_DONE..("全能:%.2f%% "):format(GetCombatRatingBonus(29))
	return Versatility_DONE
end

local function Versatility_TAKEN()
	local Versatility_TAKEN = ""
	Versatility_TAKEN = Versatility_TAKEN..("全能:%.2f%% "):format(GetCombatRatingBonus(29))
	return Versatility_TAKEN
end

local function StatReport()
	if UnitLevel("player") < 10 then
		return BaseInfo()
	 end
	 local StatInfo = ""
	 local Role = GetSpecializationRole(GetSpecialization())
	 if Role == "HEALER" then
			StatInfo = StatInfo..BaseInfo()..DpsInfo()..HealInfo()..MoreInfo()..Versatility_DONE()
	 elseif Role == "TANK" then
			StatInfo = StatInfo..BaseInfo()..DpsInfo()..TankInfo()..MoreInfo()..Versatility_TAKEN()
	 else
			StatInfo = StatInfo..BaseInfo()..DpsInfo()..MoreInfo()..Versatility_DONE()
	 end
	 return StatInfo
end

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

addButton("Toggle DBM", POSITION_LEFT, function(self, button)
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
end)

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

--local garrisonButton = addButton(GARRISON_LANDING_PAGE_TITLE, POSITION_RIGHT, GarrisonLandingPage_Toggle)
--if C.client == "zhCN" or C.client == "zhTW" then
--	garrisonButton.Text:SetFont(unpack(menubarFont))
--end
local garrisonButton = addButton("Garrison Report", POSITION_RIGHT, GarrisonLandingPage_Toggle)
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