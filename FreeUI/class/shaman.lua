local F, C, L = unpack(select(2, ...))

if(select(2, UnitClass("player")) ~= "SHAMAN" or C.classmod.shaman == false) then return end

for i = 1, 4 do
	local bu = _G["MultiCastSlotButton"..i]

	select(2, bu:GetRegions()):Hide()

	bu:ClearAllPoints()

	if i ~= 1 then
		bu:SetPoint("LEFT", _G["MultiCastSlotButton"..i-1], "RIGHT", 1, 0)
	end

	F.CreateBD(bu, 0)
end

MultiCastSlotButton1:SetPoint("LEFT", MultiCastSummonSpellButton, "RIGHT", 1, 0)

MultiCastSummonSpellButtonNormalTexture:SetVertexColor(0, 0, 0, 0)
MultiCastSummonSpellButton:SetPushedTexture("")
MultiCastSummonSpellButton:SetCheckedTexture("")
MultiCastSummonSpellButtonIcon:SetTexCoord(.08, .92, .08, .92)
MultiCastSummonSpellButtonHighlight:SetAlpha(0)
F.CreateBD(MultiCastSummonSpellButton, 0)

MultiCastRecallSpellButton:ClearAllPoints()
MultiCastRecallSpellButton:SetPoint("LEFT", MultiCastSlotButton4, "RIGHT", 1, 0)
MultiCastRecallSpellButtonNormalTexture:SetVertexColor(0, 0, 0, 0)
MultiCastRecallSpellButton:SetPushedTexture("")
MultiCastRecallSpellButton:SetCheckedTexture("")
MultiCastRecallSpellButtonIcon:SetTexCoord(.08, .92, .08, .92)
MultiCastRecallSpellButtonHighlight:SetAlpha(0)
F.CreateBD(MultiCastRecallSpellButton, 0)

for i = 1, 12 do
	local bu = _G["MultiCastActionButton"..i]

	bu:SetPushedTexture("")
	select(14, bu:GetRegions()):Hide()
	bu:SetNormalTexture("")
	bu.SetNormalTexture = F.dummy
	_G["MultiCastActionButton"..i.."Icon"]:SetTexCoord(.08, .92, .08, .92)

	F.CreateBD(bu, 0)
end

if MultiCastActionBarFrame then
	MultiCastActionBarFrame:SetScript("OnUpdate", nil)
	MultiCastActionBarFrame:SetScript("OnShow", nil)
	MultiCastActionBarFrame:SetScript("OnHide", nil)
	MultiCastActionBarFrame:SetParent(FreeUI_StanceBar)
	MultiCastActionBarFrame:ClearAllPoints()
	MultiCastActionBarFrame:SetPoint("BOTTOMLEFT", FreeUI_StanceBar, "BOTTOMLEFT", 0, -4)
 
	hooksecurefunc("MultiCastActionButton_Update", function(actionbutton)
		if not InCombatLockdown() then actionbutton:SetAllPoints(actionbutton.slotButton) end
	end)
 
	MultiCastActionBarFrame.SetParent = F.dummy
	MultiCastActionBarFrame.SetPoint = F.dummy
	MultiCastRecallSpellButton.SetPoint = F.dummy
end

local spellName = GetSpellInfo(53817)
local name, count

local glow = CreateFrame("Frame", nil, UIParent)
glow:SetBackdrop({
	edgeFile = C.media.glow,
	edgeSize = 5,
})
glow:SetBackdropBorderColor(.2, .6, .9)
glow:SetAlpha(0)

glow:RegisterEvent("PLAYER_ENTERING_WORLD")
glow:RegisterEvent("UNIT_AURA")
glow:SetScript("OnEvent", function(self, event, unit)
	if event == "PLAYER_ENTERING_WORLD" then
		glow:SetPoint("TOPLEFT", oUF_FreePlayer, -6, 6)
		glow:SetPoint("BOTTOMRIGHT", oUF_FreePlayer, 6, -6)
		glow.text = F.CreateFS(oUF_FreePlayer, 24)
		glow.text:SetPoint("LEFT", oUF_FreePlayer, "RIGHT", 10, 0)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		return
	end

	if unit ~= "player" then return end

	name, _, _, count = UnitAura("player", spellName)
	if not name then
		glow:SetScript("OnUpdate", nil)
		glow:SetAlpha(0)
		glow.text:SetText("")
		return
	end

	glow.text:SetText(count)

	if count == 5 then
		glow:SetAlpha(1)
		F.CreatePulse(glow)
		glow.text:SetFont(C.media.font, 40, "OUTLINEMONOCHROME")
		glow.text:SetTextColor(.2, .6, .9)
	else
		glow:SetScript("OnUpdate", nil)
		glow:SetAlpha(0)
		glow.text:SetFont(C.media.font, 24, "OUTLINEMONOCHROME")
		glow.text:SetTextColor(1, 1, 1)
	end
end)