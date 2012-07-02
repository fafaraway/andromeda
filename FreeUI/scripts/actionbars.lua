-- rActionBarStyler by Roth, modified.

local F, C, L = unpack(select(2, ...))

--[[ MainMenuBar ]]

local bar1 = CreateFrame("Frame", "FreeUI_MainMenuBar", UIParent, "SecureHandlerStateTemplate")
bar1:SetWidth(323)
bar1:SetHeight(26)

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
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
bar1:RegisterEvent("PLAYER_ENTERING_WORLD")
bar1:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
bar1:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
bar1:RegisterEvent("BAG_UPDATE")
bar1:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
bar1:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button, buttons
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])
  
		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
      
		RegisterStateDriver(self, "page", GetBar())
	elseif event == "PLAYER_ENTERING_WORLD" then
		local button
		for i = 1, 12 do
			button = _G["ActionButton"..i]
			button:ClearAllPoints()
			button:SetParent(self)
			button:SetSize(26, 26)
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", bar1, "BOTTOMLEFT", 0, 0)
			else
				local previous = _G["ActionButton"..i-1]
   				button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
			end
		end
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		-- attempt to fix blocked glyph change after switching spec.
		LoadAddOn("Blizzard_GlyphUI")
	else
		MainMenuBar_OnEvent(self, event, ...)
	end
end)

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

--[[ Hide frames ]]

MainMenuBar:SetScale(0.00001)
MainMenuBar:EnableMouse(false)
OverrideActionBar:SetScale(0.00001)
OverrideActionBar:EnableMouse(false)

SlidingActionBarTexture0:SetAlpha(0)
SlidingActionBarTexture1:SetAlpha(0)
StanceBarLeft:SetAlpha(0)
StanceBarMiddle:SetAlpha(0)
StanceBarRight:SetAlpha(0)

local FramesToHide = {
	MainMenuBar, 
	MainMenuBarArtFrame, 
	BonusActionBarFrame, 
	OverrideActionBar,
	PossessBarFrame,
}

local noShow = function(self)
	self:Hide()
end

for _, f in pairs(FramesToHide) do
	if f:GetObjectType() == "Frame" then
		f:UnregisterAllEvents()
	end
	if f ~= MainMenuBar then --patch 4.0.6 fix found by tukz
		hooksecurefunc(f, "Show", noShow)
		f:Hide()
	end
	f:SetAlpha(0)
end

hooksecurefunc("TalentFrame_LoadUI", function()
	PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
end)

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

--[[ Stance and Totem bar ]]

if C.actionbars.stancebar == true or (select(2, UnitClass("player")) == "SHAMAN" and C.classmod.shaman == true) then
	local numshift = NUM_STANCE_SLOTS

	local shiftbar = CreateFrame("Frame", "FreeUI_StanceBar", UIParent, "SecureHandlerStateTemplate")
	shiftbar:SetWidth(NUM_STANCE_SLOTS * 27 - 1)
	shiftbar:SetHeight(26)
	shiftbar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 50, 4)
     
	StanceBarFrame:SetParent(shiftbar)
	StanceBarFrame:EnableMouse(false)

	for i = 1, numshift do
		local button = _G["StanceButton"..i]
		button:SetSize(26, 26)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", shiftbar, 0, 0)
		else
			local previous = _G["StanceButton"..i-1]      
			button:SetPoint("LEFT", previous, "RIGHT", 3, 0)
		end
	end

	StanceButton1:SetPoint("BOTTOMLEFT", shiftbar, 0, 0)
	StanceButton1.SetPoint = F.dummy
end

--[[ Vehicle exit button ]]

local vbar = CreateFrame("Frame", "FreeUI_VehicleExit", UIParent, "SecureHandlerStateTemplate")
local a1, p, a2, x, y = unpack(C.unitframes.player)
vbar:SetSize(C.unitframes.player_height + 2, C.unitframes.player_height + 2)
vbar:SetPoint(a1, p, a2, x-(C.unitframes.player_width + C.unitframes.player_height + 7) / 2, y - 1) -- 125

local veb = CreateFrame("BUTTON", "FreeUI_ExitVehicle", vbar, "SecureActionButtonTemplate");
veb:SetAllPoints(vbar)

local text = F.CreateFS(veb, 8)
text:SetText("x")
text:SetPoint("CENTER", 1, 1)

veb:RegisterForClicks("AnyUp")
veb:SetScript("OnClick", function(self)
	if IsAltKeyDown() then
		VehicleExit()
	else
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffClick and hold down the|r alt |cffffffffkey to exit vehicle.|r", unpack(C.class))
	end
end)
veb:RegisterEvent("UNIT_ENTERING_VEHICLE")
veb:RegisterEvent("UNIT_ENTERED_VEHICLE")
veb:RegisterEvent("UNIT_EXITING_VEHICLE")
veb:RegisterEvent("UNIT_EXITED_VEHICLE")
veb:SetScript("OnEvent", function(self,event,...)
	local arg1 = ...;
	if(((event=="UNIT_ENTERING_VEHICLE") or (event=="UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
		veb:SetAlpha(1)
	elseif(((event=="UNIT_EXITING_VEHICLE") or (event=="UNIT_EXITED_VEHICLE")) and arg1 == "player") then
		veb:SetAlpha(0)
end
end)  
veb:SetAlpha(0)

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