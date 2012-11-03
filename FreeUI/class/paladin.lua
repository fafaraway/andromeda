local F, C = unpack(select(2, ...))

if select(2, UnitClass("player")) ~= "PALADIN" or not C.classmod.paladinRF then return end

local name, _, icon = GetSpellInfo(25780)

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetSize(57, 57)

frame.icon = frame:CreateTexture(nil, "ARTWORK")
frame.icon:SetTexture(icon)
frame.icon:SetTexCoord(.08, .92, .08, .92)
frame.icon:SetAllPoints(frame)

F.CreateBG(frame)

frame:Hide()

local function checkFury(_, unit)
	if not UnitBuff("player", name) and UnitAffectingCombat("player") then
		frame:Show()
	else
		frame:Hide()
	end
end

local registered = false

local function checkTalents()
	if GetSpecialization() == 2 then
		if not registered then
			F.RegisterEvent("PLAYER_REGEN_ENABLED", checkFury)
			F.RegisterEvent("PLAYER_REGEN_DISABLED", checkFury)
			F.RegisterEvent("UNIT_AURA", checkFury)
			registered = true
		end
	elseif registered then
		F.UnregisterEvent("PLAYER_REGEN_ENABLED", checkFury)
		F.UnregisterEvent("PLAYER_REGEN_DISABLED", checkFury)
		F.UnregisterEvent("UNIT_AURA", checkFury)
		registered = false
	end
end

F.RegisterEvent("PLAYER_ENTERING_WORLD", checkTalents)
F.RegisterEvent("PLAYER_TALENT_UPDATE", checkTalents)

local mover = CreateFrame("Frame")
mover:RegisterEvent("PlAYER_LOGIN")
mover:SetScript("OnEvent", function()
	frame:SetPoint("BOTTOM", oUF_FreeTarget, "TOP", 0, 42)
	mover = nil
end)