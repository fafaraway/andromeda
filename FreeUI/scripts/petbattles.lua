local F, C, L = unpack(FreeUI)

local testmode = false

local frame = PetBattleFrame
local bf = frame.BottomFrame

if testmode then frame:Show() end

frame.TopArtLeft:Hide()
frame.TopArtRight:Hide()
frame.TopVersus:Hide()

local tooltips = {PetBattlePrimaryAbilityTooltip, PetBattlePrimaryUnitTooltip, FloatingBattlePetTooltip, BattlePetTooltip}
for _, f in pairs(tooltips) do
	f:DisableDrawLayer("BACKGROUND")
	local bg = CreateFrame("Frame", nil, f)
	bg:SetAllPoints()
	bg:SetFrameLevel(0)
	F.CreateBD(bg)
end

PetBattlePrimaryUnitTooltip.Delimiter:SetTexture(0, 0, 0)
PetBattlePrimaryUnitTooltip.Delimiter:SetHeight(1)
PetBattlePrimaryAbilityTooltip.Delimiter1:SetHeight(1)
PetBattlePrimaryAbilityTooltip.Delimiter1:SetTexture(0, 0, 0)
PetBattlePrimaryAbilityTooltip.Delimiter2:SetHeight(1)
PetBattlePrimaryAbilityTooltip.Delimiter2:SetTexture(0, 0, 0)
FloatingBattlePetTooltip.Delimiter:SetTexture(0, 0, 0)
FloatingBattlePetTooltip.Delimiter:SetHeight(1)
F.ReskinClose(FloatingBattlePetTooltip.CloseButton)

frame.TopVersusText:SetPoint("TOP", frame, "TOP", 0, -46)

frame.WeatherFrame.Icon:Hide()
frame.WeatherFrame.Name:Hide()
frame.WeatherFrame.DurationShadow:Hide()
frame.WeatherFrame.Label:Hide()
frame.WeatherFrame.Duration:SetPoint("CENTER", frame.WeatherFrame, 0, 8)
frame.WeatherFrame:ClearAllPoints()
frame.WeatherFrame:SetPoint("TOP", UIParent, 0, -15)

local units = {frame.ActiveAlly, frame.ActiveEnemy}

for index, unit in pairs(units) do
	unit.healthBarWidth = 300

	unit.Border:Hide()
	unit.HealthBarBG:Hide()
	unit.HealthBarFrame:Hide()
	unit.LevelUnderlay:Hide()
	unit.SpeedUnderlay:SetAlpha(0)
	unit.PetType:Hide()

	unit.ActualHealthBar:SetTexture(C.media.texture)

	unit.Border:SetTexture(C.media.checked)
	unit.Border:SetTexCoord(0, 1, 0, 1)
	unit.Border:SetAllPoints(unit.Icon)
	unit.Border2:SetTexture(C.media.checked)
	unit.Border2:SetVertexColor(.89, .88, .06)
	unit.Border2:SetTexCoord(0, 1, 0, 1)
	unit.Border2:SetAllPoints(unit.Icon)

	unit.Level:SetFont(C.media.font2, 16)
	unit.Level:SetTextColor(1, 1, 1)

	local bg = CreateFrame("Frame", nil, unit)
	bg:SetWidth(unit.healthBarWidth)
	bg:SetFrameLevel(unit:GetFrameLevel()-1)
	F.CreateBD(bg)

	unit.HealthText:SetPoint("CENTER", bg, "CENTER")

	unit.PetTypeString = unit:CreateFontString(nil, "ARTWORK")
	unit.PetTypeString:SetFontObject(GameFontNormalLarge)

	if testmode then
		unit.Name:SetText("Lol pets")
		unit.HealthText:SetText("140/200")
		unit.Level:SetText("5")
		unit.PetTypeString:SetText("Martian")
	end

	unit.Name:ClearAllPoints()
	unit.ActualHealthBar:ClearAllPoints()

	if index == 1 then
		bg:SetPoint("TOPLEFT", unit.ActualHealthBar, "TOPLEFT", -1, 1)
		bg:SetPoint("BOTTOMLEFT", unit.ActualHealthBar, "BOTTOMLEFT", -1, -1)
		--unit.ActualHealthBar:SetGradient("VERTICAL", .26, 1, .22, .13, .5, .11)
		unit.ActualHealthBar:SetPoint("BOTTOMLEFT", unit.Icon, "BOTTOMRIGHT", 10, 0)
		unit.ActualHealthBar:SetVertexColor(.26, 1, .22)
		unit.Name:SetPoint("BOTTOMLEFT", bg, "TOPLEFT", 0, 4)
		unit.PetTypeString:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, 4)
		unit.PetTypeString:SetJustifyH("RIGHT")
	else
		bg:SetPoint("TOPRIGHT", unit.ActualHealthBar, "TOPRIGHT", 1, 1)
		bg:SetPoint("BOTTOMRIGHT", unit.ActualHealthBar, "BOTTOMRIGHT", 1, -1)
		--unit.ActualHealthBar:SetGradient("VERTICAL", 1, .12, .24, .5, .06, .12)
		unit.ActualHealthBar:SetPoint("BOTTOMRIGHT", unit.Icon, "BOTTOMLEFT", -10, 0)
		unit.ActualHealthBar:SetVertexColor(1, .12, .24)
		unit.Name:SetPoint("BOTTOMRIGHT", bg, "TOPRIGHT", 0, 4)
		unit.PetTypeString:SetPoint("BOTTOMLEFT", bg, "TOPLEFT", 0, 4)
		unit.PetTypeString:SetJustifyH("LEFT")
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

	unit.healthBarWidth = 36

	unit:SetSize(36, 36)

	unit.HealthBarBG:SetAlpha(0)
	unit.BorderAlive:SetAlpha(0)
	unit.BorderDead:SetAlpha(0)
	unit.HealthDivider:SetAlpha(0)

	unit.ActualHealthBar:ClearAllPoints()
	unit.ActualHealthBar:SetPoint("BOTTOM", 0, -1)

	unit.bg = CreateFrame("Frame", nil, unit)
	unit.bg:SetPoint("TOPLEFT", -1, 1)
	unit.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	unit.bg:SetFrameLevel(unit:GetFrameLevel()-1)
	F.CreateBD(unit.bg)

	if index < 3 then
		unit.ActualHealthBar:SetGradient("VERTICAL", .26, 1, .22, .13, .5, .11)
	else
		unit.ActualHealthBar:SetGradient("VERTICAL", 1, .12, .24, .5, .06, .12)
	end
end

for i = 1, NUM_BATTLE_PETS_IN_BATTLE  do
	local unit = bf.PetSelectionFrame["Pet"..i]
	local icon = unit.Icon

	unit.HealthBarBG:Hide()
	unit.Framing:Hide()
	unit.HealthDivider:Hide()

	unit.Name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 3, -3)
	unit.ActualHealthBar:SetPoint("BOTToMLEFT", icon, "BOTTOMRIGHT", 3, 0)

	icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBG(icon)

	unit.ActualHealthBar:SetTexture(C.media.backdrop)
	F.CreateBDFrame(unit.ActualHealthBar)
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

hooksecurefunc("PetBattleUnitFrame_UpdatePetType", function(self)
	if self.PetType and self.PetTypeString then
		local petType = C_PetBattles.GetPetType(self.petOwner, self.petIndex)
		self.PetTypeString:SetText(PET_TYPE_SUFFIX[petType])
	end
end)

hooksecurefunc("PetBattleAuraHolder_Update", function(self)
	if not self.petOwner or not self.petIndex then return end

	local nextFrame = 1
	for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
		local _, _, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
		if (isBuff and self.displayBuffs) or (not isBuff and self.displayDebuffs) then
			local frame = self.frames[nextFrame]

			frame.DebuffBorder:Hide()

			if not frame.reskinned then
				frame.Icon:SetTexCoord(.08, .92, .08, .92)
				frame.bg = F.CreateBG(frame.Icon)
			end

			frame.Duration:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			frame.Duration:SetShadowOffset(0, 0)
			frame.Duration:ClearAllPoints()
			frame.Duration:SetPoint("BOTTOM", frame.Icon, 1, -1)

			if turnsRemaining > 0 then
				frame.Duration:SetText(turnsRemaining)
			end

			if isBuff then
				frame.bg:SetVertexColor(0, 1, 0)
			else
				frame.bg:SetVertexColor(1, 0, 0)
			end

			nextFrame = nextFrame + 1
		end
	end
end)

-- [[ Action bar ]]


local bar = CreateFrame("Frame", "FreeUIPetBattleActionBar", UIParent, "SecureHandlerStateTemplate")
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 50)
bar:SetSize(6 * 27, 26)
RegisterStateDriver(bar, "visibility", "[petbattle] show; hide")

bf.RightEndCap:Hide()
bf.LeftEndCap:Hide()
bf.Background:Hide()
bf.Delimiter:Hide()
bf.TurnTimer.TimerBG:SetTexture("")
bf.TurnTimer.ArtFrame:SetTexture("")
bf.TurnTimer.ArtFrame2:SetTexture("")
bf.FlowFrame.LeftEndCap:Hide()
bf.FlowFrame.RightEndCap:Hide()
select(3, bf.FlowFrame:GetRegions()):Hide()
bf.MicroButtonFrame:Hide()
PetBattleFrameXPBarLeft:Hide()
PetBattleFrameXPBarRight:Hide()
PetBattleFrameXPBarMiddle:Hide()

bf.TurnTimer.SkipButton:SetParent(bar)
bf.TurnTimer.SkipButton:SetWidth(bar:GetWidth())
bf.TurnTimer.SkipButton:ClearAllPoints()
bf.TurnTimer.SkipButton:SetPoint("BOTTOM", bar, "TOP", 0, 2)
bf.TurnTimer.SkipButton.ClearAllPoints = F.dummy
bf.TurnTimer.SkipButton.SetPoint = F.dummy
F.Reskin(bf.TurnTimer.SkipButton)

bf.TurnTimer.Bar:ClearAllPoints()
bf.TurnTimer.Bar:SetPoint("LEFT")

bf.TurnTimer:SetParent(bar)
bf.TurnTimer:SetSize(bf.TurnTimer.SkipButton:GetWidth() - 2, bf.TurnTimer.SkipButton:GetHeight())
bf.TurnTimer:ClearAllPoints()
bf.TurnTimer:SetPoint("BOTTOM", bf.TurnTimer.SkipButton, "TOP", 0, 2)
bf.TurnTimer.bg = F.CreateBDFrame(bf.TurnTimer)

bf.xpBar:SetParent(bar)
bf.xpBar:SetWidth(bar:GetWidth() - 2)
bf.xpBar:ClearAllPoints()
bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer, "TOP", 0, 4)
bf.xpBar:SetStatusBarTexture(C.media.texture)
F.CreateBDFrame(bf.xpBar, 0)

for i = 7, 12 do
	select(i, bf.xpBar:GetRegions()):Hide()
end

hooksecurefunc("PetBattlePetSelectionFrame_Show", function()
	bf.PetSelectionFrame:ClearAllPoints()
	bf.PetSelectionFrame:SetPoint("BOTTOM", bf.xpBar, "TOP", 0, 8)
end)

hooksecurefunc("PetBattleFrame_UpdatePassButtonAndTimer", function()
	local pveBattle = C_PetBattles.IsPlayerNPC(LE_BATTLE_PET_ENEMY)

	bf.TurnTimer.bg:SetShown(not pveBattle)

	bf.xpBar:ClearAllPoints()

	if pveBattle then
		bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer.SkipButton, "TOP", 0, 2)
	else
		bf.xpBar:SetPoint("BOTTOM", bf.TurnTimer, "TOP", 0, 4)
	end
end)

-- [[ Buttons ]]

local r, g, b = unpack(C.class)

local function stylePetBattleButton(bu)
	if bu.reskinned then return end

	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu:SetHighlightTexture("")

	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetFrameLevel(0)
	bu.bg:SetBackdrop({
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	bu.bg:SetBackdropBorderColor(0, 0, 0)

	bu.Icon:SetTexCoord(.08, .92, .08, .92)
	bu.Icon:SetPoint("TOPLEFT", bu, 1, -1)
	bu.Icon:SetPoint("BOTTOMRIGHT", bu, -1, 1)

	bu.CooldownShadow:SetAllPoints()
	bu.CooldownFlash:SetAllPoints()

	bu.SelectedHighlight:SetTexture(r, g, b, .2)
	bu.SelectedHighlight:SetAllPoints()

	bu.HotKey:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
	bu.HotKey:SetPoint("TOP", 1, -2)

	bu.reskinned = true
end

local first = true
hooksecurefunc("PetBattleFrame_UpdateActionBarLayout", function(self)
	for i = 1, NUM_BATTLE_PET_ABILITIES do
		local bu = bf.abilityButtons[i]
		stylePetBattleButton(bu)
		bu:SetParent(bar)
		bu:SetSize(26, 26)
		bu:ClearAllPoints()
		if i == 1 then
			bu:SetPoint("BOTTOMLEFT", bar)
		else
			local previous = bf.abilityButtons[i-1]
			bu:SetPoint("LEFT", previous, "RIGHT", 1, 0)
		end
	end

	stylePetBattleButton(bf.SwitchPetButton)
	stylePetBattleButton(bf.CatchButton)
	stylePetBattleButton(bf.ForfeitButton)

	if first then
		first = false
		bf.SwitchPetButton:SetScript("OnClick", function()
			if bf.PetSelectionFrame:IsShown() then
				PetBattlePetSelectionFrame_Hide(bf.PetSelectionFrame)
			else
				PetBattlePetSelectionFrame_Show(bf.PetSelectionFrame)
			end
		end)
	end

	bf.SwitchPetButton:SetParent(bar)
	bf.SwitchPetButton:SetSize(26, 26)
	bf.SwitchPetButton:ClearAllPoints()
	bf.SwitchPetButton:SetPoint("LEFT", bf.abilityButtons[NUM_BATTLE_PET_ABILITIES], "RIGHT", 1, 0)
	bf.SwitchPetButton:SetCheckedTexture(C.media.checked)
	bf.CatchButton:SetParent(bar)
	bf.CatchButton:SetSize(26, 26)
	bf.CatchButton:ClearAllPoints()
	bf.CatchButton:SetPoint("LEFT", bf.SwitchPetButton, "RIGHT", 1, 0)
	bf.ForfeitButton:SetParent(bar)
	bf.ForfeitButton:SetSize(26, 26)
	bf.ForfeitButton:ClearAllPoints()
	bf.ForfeitButton:SetPoint("LEFT", bf.CatchButton, "RIGHT", 1, 0)
end)