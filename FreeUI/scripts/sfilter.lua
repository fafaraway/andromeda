-- sFilter by Shantalya, modified.

local F, C, L = unpack(select(2, ...))

local MyUnits = {
	player = true,
	vehicle = true,
	pet = true,
}

local function sFilter_CreateFrame(data)
	local spellName, _, spellIcon = GetSpellInfo(data.spellId)
	local frame = CreateFrame("Frame", "sFilter_" .. data.unitId .. "_" .. data.spellId, UIParent)
	frame:SetWidth(data.size)
	frame:SetHeight(data.size)
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			if data.slot == 1 then
				self:SetPoint("BOTTOMLEFT", oUF_FreeTarget, "TOPLEFT", 0, 42)
			elseif data.slot == 2 then
				self:SetPoint("BOTTOM", oUF_FreeTarget, "TOP", 0, 42)
			elseif data.slot == 3 then
				self:SetPoint("BOTTOMRIGHT", oUF_FreeTarget, "TOPRIGHT", 0, 42)
			end
		end
		local unit = ...
		if(data.unitId==unit or event=="PLAYER_TARGET_CHANGED" or event=="PLAYER_ENTERING_WORLD") then
			self.found = false
			self:SetAlpha(1)
			for i=1, 40 do
				local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(data.unitId, i, data.filter)
				if((data.isMine~=1 or MyUnits[caster]) and(not data.spec or GetPrimaryTalentTree()==data.spec) and (name==GetSpellInfo(data.spellId) or (data.spellId2 and name==GetSpellInfo(data.spellId2)) or (data.spellId3 and name==GetSpellInfo(data.spellId3)) or (data.spellId4 and name==GetSpellInfo(data.spellId4)) or (data.spellId5 and name==GetSpellInfo(data.spellId5)))) then
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

			if(not self.found) then
				self:SetAlpha(0)
				self.icon:SetTexture(spellIcon)
				self.count:SetText("")
				self.cooldown:Hide()
			end
		end

	end)

	frame.icon = frame:CreateTexture("$parentIcon", "ARTWORK")
	frame.icon:SetAllPoints(frame)
	frame.icon:SetTexture(spellIcon)
	frame.icon:SetTexCoord(.08, .92, .08, .92)

	frame.count = F.CreateFS(frame, 8)
	frame.count:SetPoint("TOP")

	frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	frame.cooldown:SetPoint("TOPLEFT")
	frame.cooldown:SetPoint("BOTTOMRIGHT")
	frame.cooldown:SetReverse()

	F.CreateBG(frame)
end

local _, class = UnitClass("player")
if (C.sfilter and C.sfilter[class]) then
	for index in pairs(C.sfilter) do
		if index ~= class then
			C.sfilter[index] = nil
		end
	end
	for i = 1, #C.sfilter[class], 1 do
		sFilter_CreateFrame(C.sfilter[class][i])
	end
end