local F, C, L = unpack(FreeUI)

local testmode = false

local frame = PetBattleFrame

if testmode then frame:Show() end

frame.TopArtLeft:Hide()
frame.TopArtRight:Hide()
frame.TopVersus:Hide()

local tooltips = {PetBattlePrimaryAbilityTooltip, PetBattlePrimaryUnitTooltip}
for _, f in pairs(tooltips) do
	f:DisableDrawLayer("BACKGROUND")
	local bg = CreateFrame("Frame", nil, f)
	bg:SetAllPoints()
	bg:SetFrameLevel(0)
	F.CreateBD(bg)
end

frame.TopVersusText:SetPoint("TOP", frame, "TOP", 0, -42)

local units = {frame.ActiveAlly, frame.ActiveEnemy}

for index, unit in pairs(units) do
	local width = 300

	unit.Border:Hide()
	unit.HealthBarBG:Hide()
	unit.HealthBarFrame:Hide()
	unit.LevelUnderlay:Hide()
	unit.SpeedUnderlay:SetAlpha(0)
	
	unit.ActualHealthBar:SetTexture(C.media.texture)
	unit.ActualHealthBar:SetWidth(300)
	
	unit.Border:SetTexture(C.media.checked)
	unit.Border:SetTexCoord(0, 1, 0, 1)
	unit.Border:SetAllPoints(unit.Icon)
	unit.Border2:SetTexture(C.media.checked)
	unit.Border2:SetVertexColor(.89, .88, .06)
	unit.Border2:SetTexCoord(0, 1, 0, 1)
	unit.Border2:SetAllPoints(unit.Icon)
	
	if testmode then
		unit.Name:SetText("Lol pets")
		unit.HealthText:SetText("140/200")
		unit.Level:SetText("5")
	end
	
	unit.Level:SetFont(C.media.font2, 16)
	unit.Level:SetTextColor(1, 1, 1)
	unit.HealthText:SetPoint("CENTER", unit.ActualHealthBar, "CENTER")
	
	local bg = CreateFrame("Frame", nil, unit)
	bg:SetPoint("TOPLEFT", unit.ActualHealthBar, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", unit.ActualHealthBar, 1, -1)
	bg:SetFrameLevel(unit:GetFrameLevel()-1)
	F.CreateBD(bg)
	
	unit.PetType:ClearAllPoints()
	
	if index == 1 then
		unit.ActualHealthBar:SetGradient("VERTICAL", .26, 1, .22, .13, .5, .11)
		unit.PetType:SetPoint("LEFT", unit.ActualHealthBar, "RIGHT", 10, 0)
	else
		unit.ActualHealthBar:SetGradient("VERTICAL", 1, .12, .24, .5, .06, .12)
		unit.PetType:SetPoint("RIGHT", unit.ActualHealthBar, "LEFT", -10, 0)
	end
	
	F.CreateBG(unit.Icon)
end

local extraUnits = {
	frame.Ally2,
	frame.Ally3,
	frame.Enemy2,
	frame.Enemy3
}

for index, unit in pairs(extraUnits) do
	if testmode then unit:Show() end
	
	unit.HealthBarBG:Hide()
	unit.BorderAlive:SetAlpha(0)
	unit.BorderDead:SetAlpha(0)
	
	unit.HealthDivider:SetHeight(1)
	unit.HealthDivider:SetTexture(0, 0, 0)
	
	unit.bg = CreateFrame("Frame", nil, unit)
	unit.bg:SetPoint("TOPLEFT", -1, 1)
	unit.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	unit.bg:SetFrameLevel(unit:GetFrameLevel()-1)
	F.CreateBD(unit)

	if index < 3 then
		unit.ActualHealthBar:SetGradient("VERTICAL", .26, 1, .22, .13, .5, .11)
	else
		unit.ActualHealthBar:SetGradient("VERTICAL", 1, .12, .24, .5, .06, .12)
	end
end

hooksecurefunc("PetBattleUnitFrame_UpdateHealthInstant", function(self)
	if self.BorderAlive then
		if self.BorderAlive:IsShown() then
			self.bg:SetBackdropBorderColor(.26, 1, .22)
		else
			self.bg:SetBackdropBorderColor(1, .12, .24)
		end
	end
end)

hooksecurefunc("PetBattleUnitFrame_UpdateDisplay", function(self)
	local petOwner = self.petOwner
	
	if (not petOwner) or self.petIndex > C_PetBattles.GetNumPets(petOwner) then return end
	
	if self.Icon then
		if petOwner == LE_BATTLE_PET_ALLY then
			self.Icon:SetTexCoord(.92, .08, .08, .92)
		else
			self.Icon:SetTexCoord(.08, .92, .08, .92)
		end
	end
end)

--[[hooksecurefunc("PetBattleFrame_UpdateSpeedIndicators", function(self)
	local enemyActive = C_PetBattles.GetActivePet(LE_BATTLE_PET_ENEMY)
	local enemySpeed = C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, enemyActive)

	local allyActive = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
	local allySpeed = C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, allyActive)
end)]]

-- [[ Action bar ]]

local bar = CreateFrame("Frame", "FreeUIPetBattleActionBar", UIParent)
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
bar:SetSize((NUM_BATTLE_PET_ABILITIES * 27) + (3 * 27), 26)
bar:RegisterEvent("PET_BATTLE_OPENING_START")
bar:RegisterEvent("PET_BATTLE_CLOSE")
bar:Hide()

bar:SetScript("OnEvent", function(self, event)
	if event == "PET_BATTLE_OPENING_START" then
		bar:Show()
		FreeUI_MainMenuBar:SetAlpha(0)
		FreeUI_MultiBarBottomLeft:SetAlpha(0)
		FreeUI_MultiBarBottomRight:SetAlpha(0)
		oUF_FreePlayer:Hide()
		oUF_FreeTarget:Hide()
	else
		bar:Hide()
		FreeUI_MainMenuBar:SetAlpha(0)
		FreeUI_MultiBarBottomLeft:SetAlpha(0)
		FreeUI_MultiBarBottomRight:SetAlpha(0)
		oUF_FreePlayer:Show()
		oUF_FreeTarget:Show()
	end
end)

frame.BottomFrame.RightEndCap:Hide()
frame.BottomFrame.LeftEndCap:Hide()
frame.BottomFrame.Background:Hide()
frame.BottomFrame.TurnTimer.TimerBG:SetTexture("")
frame.BottomFrame.TurnTimer.ArtFrame:SetTexture("")
frame.BottomFrame.TurnTimer.ArtFrame2:SetTexture("")
frame.BottomFrame.TurnTimer.SkipButton:SetParent(bar)
frame.BottomFrame.TurnTimer.SkipButton:SetWidth(bar:GetWidth())
frame.BottomFrame.TurnTimer.SkipButton:ClearAllPoints()
frame.BottomFrame.TurnTimer.SkipButton:SetPoint("BOTTOM", bar, "TOP", 0, 2)
frame.BottomFrame.TurnTimer.SkipButton.ClearAllPoints = F.dummy
frame.BottomFrame.TurnTimer.SkipButton.SetPoint = F.dummy
frame.BottomFrame.FlowFrame.LeftEndCap:Hide()
frame.BottomFrame.FlowFrame.RightEndCap:Hide()
select(3, frame.BottomFrame.FlowFrame:GetRegions()):Hide()
frame.BottomFrame.MicroButtonFrame:Hide()
F.Reskin(frame.BottomFrame.TurnTimer.SkipButton)
frame.BottomFrame.xpBar:SetParent(bar)
frame.BottomFrame.xpBar:SetWidth(bar:GetWidth() - 4)
frame.BottomFrame.xpBar:ClearAllPoints()
frame.BottomFrame.xpBar:SetPoint("BOTTOM", frame.BottomFrame.TurnTimer.SkipButton, "TOP", 0, 4)
frame.BottomFrame.xpBar:HookScript("OnShow", function(self)
	for i = 7, 12 do
		select(i, self:GetRegions()):Hide()
	end
	self:SetStatusBarTexture(C.media.texture)
end)

F.CreateBD(frame.BottomFrame.xpBar)

PetBattleFrameXPBarLeft:Hide()
PetBattleFrameXPBarRight:Hide()
PetBattleFrameXPBarMiddle:Hide()

-- [[ Buttons ]]

local function stylePetBattleButton(bu)
	if bu.reskinned then return end
	
	bu:SetNormalTexture("")
	bu:SetPushedTexture("")

	if bu:GetFrameLevel() < 1 then bu:SetFrameLevel(1) end

	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetFrameLevel(0)

	bu.bg:SetBackdrop({
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	bu.bg:SetBackdropBorderColor(0, 0, 0)

	bu.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	
	bu.Icon:SetPoint("TOPLEFT", bu, 1, -1)
	bu.Icon:SetPoint("BOTTOMRIGHT", bu, -1, 1)
	
	bu.CooldownShadow:SetAllPoints()
	bu.CooldownFlash:SetAllPoints()
	
	bu.reskinned = true
end

local first = true
hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", function(self)
	for i = 1, NUM_BATTLE_PET_ABILITIES do
		local bu = self.BottomFrame.abilityButtons[i]
		stylePetBattleButton(PetBattleFrame.BottomFrame.abilityButtons[i])
		bu:SetParent(bar)
		bu:SetSize(26, 26)
		bu:ClearAllPoints()
		if i == 1 then
			bu:SetPoint("BOTTOMLEFT", bar)
		else
			local previous = self.BottomFrame.abilityButtons[i-1]
			bu:SetPoint("LEFT", previous, "RIGHT", 1, 0)
		end
	end

	if first then
		stylePetBattleButton(PetBattleFrame.BottomFrame.SwitchPetButton)
		stylePetBattleButton(PetBattleFrame.BottomFrame.CatchButton)
		stylePetBattleButton(PetBattleFrame.BottomFrame.ForfeitButton)

		frame.BottomFrame.SwitchPetButton:SetParent(bar)
		frame.BottomFrame.SwitchPetButton:SetSize(26, 26)
		frame.BottomFrame.SwitchPetButton:ClearAllPoints()
		frame.BottomFrame.SwitchPetButton:SetPoint("LEFT", self.BottomFrame.abilityButtons[NUM_BATTLE_PET_ABILITIES], "RIGHT", 1, 0)
		frame.BottomFrame.CatchButton:SetParent(bar)
		frame.BottomFrame.CatchButton:SetSize(26, 26)
		frame.BottomFrame.CatchButton:ClearAllPoints()
		frame.BottomFrame.CatchButton:SetPoint("LEFT", frame.BottomFrame.SwitchPetButton, "RIGHT", 1, 0)
		frame.BottomFrame.ForfeitButton:SetParent(bar)
		frame.BottomFrame.ForfeitButton:SetSize(26, 26)
		frame.BottomFrame.ForfeitButton:ClearAllPoints()
		frame.BottomFrame.ForfeitButton:SetPoint("LEFT", frame.BottomFrame.CatchButton, "RIGHT", 1, 0)
		first = false
	end
end)