-- by Tukz

local F, C = unpack(select(2, ...))

if not C.unitframes.enableArena then return end

local arenaFrames = {}

for i = 1, 5 do
	arenaFrames[i] = CreateFrame("Frame", "FreeUIArenaPrep"..i, UIParent)

	local bd = CreateFrame("Frame", nil, arenaFrames[i])
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameStrata("BACKGROUND")
	F.CreateBD(bd)

	arenaFrames[i].Health = CreateFrame("StatusBar", nil, arenaFrames[i])
	arenaFrames[i].Health:SetAllPoints()
	arenaFrames[i].Health:SetStatusBarTexture(C.media.texture)
	arenaFrames[i].SpecClass = F.CreateFS(arenaFrames[i].Health)
	arenaFrames[i].SpecClass:SetPoint("CENTER")
	arenaFrames[i]:Hide()
end

local updateArena = function(event)
	if event == "PLAYER_LOGIN" then
		for i = 1, 5 do
			arenaFrames[i]:SetAllPoints(_G["oUF_FreeArena"..i])
		end
	elseif event == "ARENA_OPPONENT_UPDATE" then
		for i = 1, 5 do
			arenaFrames[i]:Hide()
		end
	else
		local numOpps = GetNumArenaOpponentSpecs()

		if numOpps > 0 then
			for i = 1, 5 do
				local f = arenaFrames[i]

				if i <= numOpps then
					local s = GetArenaOpponentSpec(i)
					local _, spec, class = nil, "UNKNOWN", "UNKNOWN"

					if s and s > 0 then
						_, spec, _, _, _, _, class = GetSpecializationInfoByID(s)
					end
					if class and spec then
						f.SpecClass:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])

						local c = C.classcolours[class]
						f.Health:SetStatusBarColor(c.r, c.g, c.b)
						f:Show()
					end
				else
					f:Hide()
				end
			end
		else
			for i = 1, 5 do
				arenaFrames[i]:Hide()
			end
		end
	end
end

F.RegisterEvent("PLAYER_LOGIN", updateArena)
F.RegisterEvent("PLAYER_ENTERING_WORLD", updateArena)
F.RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS", updateArena)
F.RegisterEvent("ARENA_OPPONENT_UPDATE", updateArena)