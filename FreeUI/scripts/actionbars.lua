-- rActionBarStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

--[[ MainMenuBar ]]

local bar1 = CreateFrame("Frame", "FreeUI_MainMenuBar", UIParent, "SecureHandlerStateTemplate")
bar1:SetWidth(323)
bar1:SetHeight(26)

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["ActionButton"..i]
	button:ClearAllPoints()
	button:SetParent(bar1)
	button:SetSize(26, 26)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar1, "BOTTOMLEFT", 0, 0)
	else
		local previous = _G["ActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
end

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["MONK"] = "[bonusbar:1] 7;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 10;",
	["WARLOCK"] = "[form:2] 7;",
	["DEFAULT"] = "[bonusbar:5] 11; [bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local class = select(2, UnitClass("player"))
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

bar1:RegisterEvent("PLAYER_LOGIN")
bar1:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		for id = 1, NUM_ACTIONBAR_BUTTONS do
			local name = "ActionButton"..id
			self:SetFrameRef(name, _G[name])
		end

		self:Execute(([[
			buttons = table.new()
			for id = 1, %s do
				buttons[id] = self:GetFrameRef("ActionButton"..id)
			end
		]]):format(NUM_ACTIONBAR_BUTTONS))
  
		self:SetAttribute("_onstate-page", ([[ 
			if not newstate then return end
			newstate = tonumber(newstate)
			for id = 1, %s do
				buttons[id]:SetAttribute("actionpage", newstate)
			end
		]]):format(NUM_ACTIONBAR_BUTTONS))

		RegisterStateDriver(self, "page", GetBar())
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

RegisterStateDriver(bar1, "visibility", "[vehicleui] hide;show")

--[[ Bottom Left bar ]]

local bar2 = CreateFrame("Frame", "FreeUI_MultiBarBottomLeft", UIParent, "SecureHandlerStateTemplate")
bar2:SetWidth(323)
bar2:SetHeight(26)

MultiBarBottomLeft:SetParent(bar2)

for i=1, 12 do
	local button = _G["MultiBarBottomLeftButton"..i]
	button:ClearAllPoints()
	button:SetSize(26, 26)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar2, "BOTTOMLEFT", 0, 0)
	else
		local previous = _G["MultiBarBottomLeftButton"..i-1]  
		button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
end

RegisterStateDriver(bar2, "visibility", "[vehicleui] hide;show")

--[[ Bottom Right bar ]]

local bar3 = CreateFrame("Frame", "FreeUI_MultiBarBottomRight", UIParent, "SecureHandlerStateTemplate")
bar3:SetWidth(323)
bar3:SetHeight(26)

MultiBarBottomRight:SetParent(bar3)

for i=1, 12 do
	local button = _G["MultiBarBottomRightButton"..i]
	button:ClearAllPoints()
	button:SetSize(26, 26)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar3, "BOTTOMLEFT", 0, 0)
	else
		local previous = _G["MultiBarBottomRightButton"..i-1]  
		button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
end

RegisterStateDriver(bar3, "visibility", "[vehicleui] hide;show")

bar2:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
bar1:SetPoint("BOTTOM", bar2, "TOP", 0, 1)
bar3:SetPoint("BOTTOM", bar1, "TOP", 0, 1)

--[[ Right bar 1 ]]

local bar4 = CreateFrame("Frame", "FreeUI_MultiBarRight", UIParent, "SecureHandlerStateTemplate")
bar4:SetHeight(323)
bar4:SetWidth(26)
bar4:SetPoint("RIGHT", -50, 0)

MultiBarRight:SetParent(bar4)

for i=1, 12 do
	local button = _G["MultiBarRightButton"..i]
	button:ClearAllPoints()
	button:SetSize(26, 26)
	if i == 1 then
		button:SetPoint("TOPLEFT", bar4, 0,0)
	else
		local previous = _G["MultiBarRightButton"..i-1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -1)
	end
end

RegisterStateDriver(bar4, "visibility", "[vehicleui] hide;show")

--[[ Right bar 2 ]]

local bar5 = CreateFrame("Frame", "FreeUI_MultiBarLeft", UIParent, "SecureHandlerStateTemplate")
bar5:SetHeight(323)
bar5:SetWidth(26)
bar5:SetPoint("RIGHT", -77, 0)

MultiBarLeft:SetParent(bar5)
  
for i=1, 12 do
	local button = _G["MultiBarLeftButton"..i]
	button:ClearAllPoints()
	button:SetSize(26, 26)
	if i == 1 then
		button:SetPoint("TOPLEFT", bar5, 0,0)
	else
		local previous = _G["MultiBarLeftButton"..i-1]
		button:SetPoint("TOP", previous, "BOTTOM", 0, -1)
	end
end

RegisterStateDriver(bar5, "visibility", "[vehicleui] hide;show")

-- [[ Override bar ]]

local numOverride = 7

local override = CreateFrame("Frame", "FreeUI_OverrideBar", UIParent, "SecureHandlerStateTemplate")
override:SetWidth((27 * numOverride) - 1)
override:SetHeight(26)
override:SetPoint("BOTTOM", bar2, "TOP", 0, 1)

OverrideActionBar:SetParent(override)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)

for i = 1, numOverride do
	local bu = _G["OverrideActionBarButton"..i]
	if not bu then
		bu = OverrideActionBar.LeaveButton
	end
	bu:ClearAllPoints()
	bu:SetSize(26, 26)
	if i == 1 then
		bu:SetPoint("BOTTOMLEFT", override, "BOTTOMLEFT")
	else
		local previous = _G["OverrideActionBarButton"..i-1]
		bu:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end	
end

RegisterStateDriver(frame, "visibility", "[vehicleui] show;hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[vehicleui] show;hide")

-- [[ Hide stuff ]]

local hider = CreateFrame("Frame")
hider:Hide()
MainMenuBar:SetParent(hider)
PossessBarFrame:SetParent(hider)
OverrideActionBarExpBar:SetParent(hider)
OverrideActionBarHealthBar:SetParent(hider)
OverrideActionBarPowerBar:SetParent(hider)
OverrideActionBarPitchFrame:SetParent(hider)

StanceBarLeft:SetAlpha(0)
StanceBarMiddle:SetAlpha(0)
StanceBarRight:SetAlpha(0)

local textureList = {
	"_BG",
	"EndCapL",
	"EndCapR",
	"_Boader",
	"Divider1",
	"Divider2",
	"Divider3",
	"ExitBG",
	"MicroBGL",
	"MicroBGR",
	"_MicroBGMid",
	"ButtonBGL",
	"ButtonBGR",
	"_ButtonBGMid",
}

for _, tex in pairs(textureList) do
	OverrideActionBar[tex]:SetAlpha(0)
end

--[[ Pet bar ]]

local numpet = NUM_PET_ACTION_SLOTS

local petbar = CreateFrame("Frame", "FreeUI_PetBar", UIParent, "SecureHandlerStateTemplate")
petbar:SetWidth(400)
petbar:SetHeight(54)
petbar:SetPoint("BOTTOMRIGHT", 42, 15)

PetActionBarFrame:SetParent(petbar)
PetActionBarFrame:SetHeight(0.001)

for i = 1, numpet do
	local button = _G["PetActionButton"..i]
	local cd = _G["PetActionButton"..i.."Cooldown"]
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", petbar, 0,0)
	else
		local previous = _G["PetActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
	cd:SetAllPoints(button)
end

--[[ Stance bar ]]

if C.actionbars.stancebar == true then
	local function updateShift()
		local numForms = GetNumShapeshiftForms()
		local texture, name, isActive, isCastable
		local button, icon, cooldown
		local start, duration, enable
		for i = 1, NUM_STANCE_SLOTS do
			buttonName = "FreeUIStanceButton"..i
			button = _G[buttonName]
			icon = _G[buttonName.."Icon"]
			if i <= numForms then
				texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
				icon:SetTexture(texture)

				cooldown = _G[buttonName.."Cooldown"]
				if texture then
					cooldown:SetAlpha(1)
				else
					cooldown:SetAlpha(0)
				end

				start, duration, enable = GetShapeshiftFormCooldown(i)
				CooldownFrame_SetTimer(cooldown, start, duration, enable)

				if isActive then
					StanceBarFrame.lastSelected = button:GetID()
					button:SetChecked(1)
				else
					button:SetChecked(0)
				end

				if isCastable then
					icon:SetVertexColor(1.0, 1.0, 1.0)
				else
					icon:SetVertexColor(0.4, 0.4, 0.4)
				end
			end
		end
	end

	local shiftbar = CreateFrame("Frame", "FreeUI_StanceBar", UIParent, "SecureHandlerStateTemplate")
	shiftbar:SetWidth(NUM_STANCE_SLOTS * 27 - 1)
	shiftbar:SetHeight(26)
	shiftbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 4)
	shiftbar.buttons = {}
	shiftbar:SetAttribute("_onstate-show", [[
		if newstate == "hide" then
			self:Hide();
		else
			self:Show();
		end
	]])

	shiftbar:RegisterEvent("PLAYER_LOGIN")
	shiftbar:RegisterEvent("PLAYER_ENTERING_WORLD")
	shiftbar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
	shiftbar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
	shiftbar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
	shiftbar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	shiftbar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
	shiftbar:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_LOGIN" then
			for i = 1, NUM_STANCE_SLOTS do
				if not self.buttons[i] then
					self.buttons[i] = CreateFrame("CheckButton", format("FreeUIStanceButton%d", i), self, "StanceButtonTemplate")
					self.buttons[i]:SetID(i)
				end
				local button = self.buttons[i]
				button:ClearAllPoints()
				button:SetParent(self)
				button:SetSize(26, 26)
				button:SetFrameStrata("LOW")
				if i == 1 then
					button:SetPoint("BOTTOMLEFT", shiftbar, 0, 0)
				else
					local previous = _G["FreeUIStanceButton"..i-1]
					button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
				end
				local _, name = GetShapeshiftFormInfo(i)
				if name then
					button:Show()
				else
					button:Hide()
				end
			end
			RegisterStateDriver(self, "visibility", "[vehicleui] hide; show")
		elseif event == "UPDATE_SHAPESHIFT_FORMS" then
			if InCombatLockdown() then return end
			for i = 1, NUM_STANCE_SLOTS do
				local button = self.buttons[i]
				local _, name = GetShapeshiftFormInfo(i)
				if name then
					button:Show()
				else
					button:Hide()
				end
			end
		else
			updateShift()
		end
	end)
end

--[[ Right bars on mouseover ]]

if C.actionbars.rightbars_mouseover == true then
	bar4:EnableMouse(true)
	bar5:EnableMouse(true)

	local function mouseover(alpha)
		for i=1, 12 do
			local ab1 = _G["MultiBarLeftButton"..i]
			local ab2 = _G["MultiBarRightButton"..i]
			ab1:SetAlpha(alpha)
			ab2:SetAlpha(alpha)
		end
	end

	for i=1, 12 do
		local ab1 = _G["MultiBarLeftButton"..i]
		local ab2 = _G["MultiBarRightButton"..i]
		ab1:SetAlpha(0)
		ab1:HookScript("OnEnter", function(self) mouseover(1) end)
		ab1:HookScript("OnLeave", function(self) mouseover(0) end)
		ab2:SetAlpha(0)
		ab2:HookScript("OnEnter", function(self) mouseover(1) end)
		ab2:HookScript("OnLeave", function(self) mouseover(0) end)
	end

	bar4:HookScript("OnEnter", function(self) mouseover(1) end)
	bar4:HookScript("OnLeave", function(self) mouseover(0) end)
	bar5:HookScript("OnEnter", function(self) mouseover(1) end)
	bar5:HookScript("OnLeave", function(self) mouseover(0) end)
end

--[[ Extra bar ]]

local barextra = CreateFrame("Frame", "FreeUI_ExtraActionBar", UIParent, "SecureHandlerStateTemplate")
barextra:SetSize(39, 39)
barextra:SetPoint("BOTTOM", bar3, "TOP", 0, 1)

ExtraActionBarFrame:SetParent(barextra)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

ExtraActionButton1:SetSize(39, 39)
barextra.button = ExtraActionButton1