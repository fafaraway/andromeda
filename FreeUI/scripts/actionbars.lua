-- rActionBarStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

if not C.actionbars.enable then return end

--[[ MainMenuBar ]]

local bar1 = CreateFrame("Frame", "FreeUI_MainMenuBar", UIParent, "SecureHandlerStateTemplate")
bar1:SetWidth(323)
bar1:SetHeight(26)

MainMenuBarArtFrame:SetParent(bar1)
MainMenuBarArtFrame:EnableMouse(false)

MainMenuBar.slideOut.IsPlaying = function() return true end

for i = 1, NUM_ACTIONBAR_BUTTONS do
	local button = _G["ActionButton"..i]
	button:ClearAllPoints()
	button:SetSize(26, 26)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", bar1, "BOTTOMLEFT", 0, 0)
	else
		local previous = _G["ActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
end

RegisterStateDriver(bar1, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

--[[ Bottom Left bar ]]

local bar2 = CreateFrame("Frame", "FreeUI_MultiBarBottomLeft", UIParent, "SecureHandlerStateTemplate")
bar2:SetWidth(323)
bar2:SetHeight(26)

MultiBarBottomLeft:SetParent(bar2)
MultiBarBottomLeft:EnableMouse(false)

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

RegisterStateDriver(bar2, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

--[[ Bottom Right bar ]]

local bar3 = CreateFrame("Frame", "FreeUI_MultiBarBottomRight", UIParent, "SecureHandlerStateTemplate")
bar3:SetWidth(323)
bar3:SetHeight(26)

MultiBarBottomRight:SetParent(bar3)
MultiBarBottomRight:EnableMouse(false)

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

RegisterStateDriver(bar3, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

bar2:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
bar1:SetPoint("BOTTOM", bar2, "TOP", 0, 1)
bar3:SetPoint("BOTTOM", bar1, "TOP", 0, 1)

--[[ Right bar 1 ]]

local bar4 = CreateFrame("Frame", "FreeUI_MultiBarRight", UIParent, "SecureHandlerStateTemplate")
bar4:SetHeight(323)
bar4:SetWidth(26)
bar4:SetPoint("RIGHT", -50, 0)

MultiBarRight:SetParent(bar4)
MultiBarRight:EnableMouse(false)

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

RegisterStateDriver(bar4, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

--[[ Right bar 2 ]]

local bar5 = CreateFrame("Frame", "FreeUI_MultiBarLeft", UIParent, "SecureHandlerStateTemplate")
bar5:SetHeight(323)
bar5:SetWidth(26)
bar5:SetPoint("RIGHT", -77, 0)

MultiBarLeft:SetParent(bar5)
MultiBarLeft:EnableMouse(false)

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

RegisterStateDriver(bar5, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

-- [[ Override bar ]]

local numOverride = 7

local override = CreateFrame("Frame", "FreeUI_OverrideBar", UIParent, "SecureHandlerStateTemplate")
override:SetWidth(323)
override:SetHeight(26)
override:SetPoint("BOTTOM", bar2, "TOP", 0, 1)

OverrideActionBar:SetParent(override)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)

local leaveButtonPlaced = false

for i = 1, numOverride do
	local bu = _G["OverrideActionBarButton"..i]
	if not bu and not leaveButtonPlaced then
		bu = OverrideActionBar.LeaveButton
		leaveButtonPlaced = true
	end
	if not bu then
		break
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

RegisterStateDriver(override, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

-- [[ Hide stuff ]]

local hider = CreateFrame("Frame")
hider:Hide()

local hideFrames = {MainMenuBar, MainMenuBarPageNumber, ActionBarDownButton, ActionBarUpButton, OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame, CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, PVPMicroButton, LFDMicroButton, CompanionsMicroButton, EJMicroButton, MainMenuMicroButton, HelpMicroButton, MainMenuBarBackpackButton}
for _, frame in pairs(hideFrames) do
	frame:SetParent(hider)
end

StanceBarLeft:SetTexture("")
StanceBarMiddle:SetTexture("")
StanceBarRight:SetTexture("")
SlidingActionBarTexture0:SetTexture("")
SlidingActionBarTexture1:SetTexture("")
PossessBackground1:SetTexture("")
PossessBackground2:SetTexture("")
MainMenuBarTexture0:SetTexture("")
MainMenuBarTexture1:SetTexture("")
MainMenuBarTexture2:SetTexture("")
MainMenuBarTexture3:SetTexture("")
MainMenuBarLeftEndCap:SetTexture("")
MainMenuBarRightEndCap:SetTexture("")

local textureList = {"_BG","EndCapL","EndCapR","_Border","Divider1","Divider2","Divider3","ExitBG","MicroBGL","MicroBGR","_MicroBGMid","ButtonBGL","ButtonBGR","_ButtonBGMid"}

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

RegisterStateDriver(petbar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; [@pet,exists,nomounted] show; hide")

--[[ Stance/possess bar]]

local stancebar = CreateFrame("Frame", "FreeUI_StanceBar", UIParent, "SecureHandlerStateTemplate")
stancebar:SetWidth(NUM_STANCE_SLOTS * 27 - 1)
stancebar:SetHeight(26)
stancebar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 4)

StanceBarFrame:SetParent(stancebar)
StanceBarFrame:EnableMouse(false)

for i = 1, NUM_STANCE_SLOTS do
	local button = _G["StanceButton"..i]
	button:SetSize(26, 26)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", stancebar, 0, 0)
	else
		local previous = _G["StanceButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
end

PossessBarFrame:SetParent(stancebar)
PossessBarFrame:EnableMouse(false)

for i = 1, NUM_POSSESS_SLOTS do
	local button = _G["PossessButton"..i]
	button:SetSize(26, 26)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", stancebar, 0, 0)
	else
		local previous = _G["PossessButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
	end
end

RegisterStateDriver(stancebar, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

--[[ Right bars on mouseover ]]

if C.actionbars.rightbars_mouseover == true then
	bar4:EnableMouse(true)
	bar5:EnableMouse(true)

	local function showButtons()
		for i = 1, 12 do
			_G["MultiBarLeftButton"..i]:SetAlpha(1)
			_G["MultiBarRightButton"..i]:SetAlpha(1)
		end
	end

	local function hideButtons()
		for i = 1, 12 do
			_G["MultiBarLeftButton"..i]:SetAlpha(0)
			_G["MultiBarRightButton"..i]:SetAlpha(0)
		end
	end

	for i = 1, 12 do
		local ab1 = _G["MultiBarLeftButton"..i]
		local ab2 = _G["MultiBarRightButton"..i]

		ab1:SetAlpha(0)
		ab1:HookScript("OnEnter", showButtons)
		ab1:HookScript("OnLeave", hideButtons)
		ab2:SetAlpha(0)
		ab2:HookScript("OnEnter", showButtons)
		ab2:HookScript("OnLeave", hideButtons)
	end

	bar4:HookScript("OnEnter", showButtons)
	bar4:HookScript("OnLeave", hideButtons)
	bar5:HookScript("OnEnter", showButtons)
	bar5:HookScript("OnLeave", hideButtons)

	local function showButtonsFlyout()
		local frame = SpellFlyout:GetParent():GetParent():GetParent()
		if frame and (frame == FreeUI_MultiBarLeft or frame == FreeUI_MultiBarRight) then
			showButtons()
		end
	end

	local function hideButtonsFlyout()
		local frame = SpellFlyout:GetParent():GetParent():GetParent()
		if frame and (frame == FreeUI_MultiBarLeft or frame == FreeUI_MultiBarRight) then
			hideButtons()
		end
	end

	SpellFlyout:HookScript("OnShow", function(self)
		local frame = self:GetParent():GetParent():GetParent()
		if frame and (frame == FreeUI_MultiBarLeft or frame == FreeUI_MultiBarRight) then
			for i = 1, 10 do
				local bu = _G["SpellFlyoutButton"..i]
				if bu and not bu.isHooked then
					bu:HookScript("OnEnter", showButtonsFlyout)
					bu:HookScript("OnLeave", hideButtonsFlyout)
					bu.isHooked = true
				end
			end
		end
	end)

	SpellFlyout:HookScript("OnEnter", showButtonsFlyout)
	SpellFlyout:HookScript("OnLeave", hideButtonsFlyout)
end

--[[ Extra bar ]]

local barextra = CreateFrame("Frame", "FreeUI_ExtraActionBar", UIParent, "SecureHandlerStateTemplate")
barextra:SetSize(39, 39)
barextra:SetPoint("BOTTOM", bar3, "TOP", 0, 1)

ExtraActionBarFrame:SetParent(barextra)
ExtraActionBarFrame:EnableMouse(false)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager = true

ExtraActionButton1:SetSize(39, 39)

RegisterStateDriver(barextra, "visibility", "[extrabar] show; hide")

-- [[ Leave vehicle ]]

local leave = CreateFrame("Frame", "FreeUI_LeaveVehicle", UIParent, "SecureHandlerStateTemplate")
leave:SetSize(26, 26)
leave:SetPoint("LEFT", bar1, "RIGHT", 1, 0)

local leavebu = CreateFrame("Button", nil, leave, "SecureHandlerClickTemplate, SecureHandlerStateTemplate")
leavebu:SetAllPoints()
leavebu:RegisterForClicks("AnyUp")
leavebu:SetScript("OnClick", VehicleExit)

F.CreateBD(leavebu)

local text = F.CreateFS(leavebu, 8)
text:SetText("x")
text:SetPoint("CENTER", 1, 1)

RegisterStateDriver(leavebu, "visibility", "[petbattle][vehicleui][overridebar] hide; [@vehicle,exists][possessbar] show; hide")
RegisterStateDriver(leave, "visibility", "[petbattle][vehicleui][overridebar][possessbar,@vehicle,exists] hide; show")

-- [[ Bags ]]

if not C.bags.enable then
	for i = 0, 3 do
		_G["CharacterBag"..i.."Slot"]:SetParent(FreeUIHider)
	end
end