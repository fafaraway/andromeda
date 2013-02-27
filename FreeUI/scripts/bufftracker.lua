local F, C, L = unpack(select(2, ...))

if not C.general.buffTracker then return end

local units = {
	player = true,
	vehicle = true,
	pet = true,
}

local function onEvent(self, event, ...)
	local data = self.data
	if event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if data.customPoint then
			self:SetPoint(unpack(data.customPoint))
		elseif data.slot == 1 then
			self:SetPoint("BOTTOMLEFT", oUF_FreeTarget, "TOPLEFT", 0, 42)
		elseif data.slot == 2 then
			self:SetPoint("BOTTOM", oUF_FreeTarget, "TOP", 0, 42)
		elseif data.slot == 3 then
			self:SetPoint("BOTTOMRIGHT", oUF_FreeTarget, "TOPRIGHT", 0, 42)
		end
	end
	local unit = ...
	if data.unitId == unit or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		self.found = false
		self:SetAlpha(1)
		for i = 1, 40 do
			local name, rank, icon, count, _, duration, expirationTime, caster, _, _, spellID = UnitAura(data.unitId, i, data.filter)
			if((data.isMine~=1 or units[caster]) and(not data.spec or GetSpecialization()==data.spec) and (spellID == data.spellId or (data.spellId2 and spellID == data.spellId2) or (data.spellId3 and spellID == data.spellId3) or (data.spellId4 and spellID == data.spellId4) or (data.spellId5 and spellID == data.spellId5))) then
				self.found = true
				self.icon:SetTexture(icon)
				self.count:SetText(count>1 and count or "")
				if duration > 0 then
					self.cooldown:Show()
					CooldownFrame_SetTimer(self.cooldown, expirationTime-duration, duration, 1)
				else
					self.cooldown:Hide()
				end
				break
			end
		end

		if not self.found then
			self:SetAlpha(0)
			self.count:SetText("")
			self.cooldown:Hide()
		end
	end
end

local function createIcon(data)
	local frame = CreateFrame("Frame", "FreeUIBuffTracker" .. data.unitId .. "_" .. data.spellId, UIParent)
	frame.data = data
	frame:SetSize(data.size or 39, data.size or 39)
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", onEvent)

	frame.icon = frame:CreateTexture("$parentIcon", "ARTWORK")
	frame.icon:SetAllPoints(frame)
	frame.icon:SetTexCoord(.08, .92, .08, .92)

	frame.count = F.CreateFS(frame, 8)
	frame.count:SetPoint("TOP", 1, -2)

	frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	frame.cooldown:SetPoint("TOPLEFT")
	frame.cooldown:SetPoint("BOTTOMRIGHT")
	frame.cooldown:SetReverse()

	F.CreateBG(frame)
end

local _, class = UnitClass("player")
if (C.buffTracker and C.buffTracker[class]) then
	for index in pairs(C.buffTracker) do
		if index ~= class then
			C.buffTracker[index] = nil
		end
	end
	for i = 1, #C.buffTracker[class], 1 do
		createIcon(C.buffTracker[class][i])
	end
end