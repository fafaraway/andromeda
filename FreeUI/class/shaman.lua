local F, C, L = unpack(select(2, ...))

if(select(2, UnitClass("player")) ~= "SHAMAN" or C.classmod.shaman == false) then return end

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