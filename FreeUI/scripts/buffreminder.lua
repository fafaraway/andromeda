-- Part of Tukui. Modified.

local F, C, L = unpack(select(2, ...))

if(select(2, UnitClass("player")) == "WARRIOR" or C.general.buffreminder == false) then return end

local class = select(2, UnitClass("Player"))
local buffs = C.selfbuffs[class]

if buffs and buffs[1] then
	local function OnEvent(self, event)
		if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
			for i, buff in pairs(buffs) do
				local name = GetSpellInfo(buff)
				local usable, nomana = IsUsableSpell(name)
				if (usable or nomana) then
					self.icon:SetTexture(select(3, GetSpellInfo(buff)))
					break
				end
			end
			if (not self.icon:GetTexture() and event == "PLAYER_LOGIN") then
				self:UnregisterAllEvents()
				self:RegisterEvent("LEARNED_SPELL_IN_TAB")
				return
			elseif (self.icon:GetTexture() and event == "LEARNED_SPELL_IN_TAB") then
				self:UnregisterAllEvents()
				self:RegisterEvent("UNIT_AURA")
				self:RegisterEvent("PLAYER_LOGIN")
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
				self:RegisterEvent("PLAYER_REGEN_DISABLED")
			end
		end
		if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
			for i, buff in pairs(buffs) do
				local name = GetSpellInfo(buff)
				if (name and UnitBuff("player", name)) then
					self:Hide()
					return
				end
			end
			self:Show()
		else
			self:Hide()
		end
	end
	
	local frame = CreateFrame("Frame", nil, UIParent)
	local a1, p, a2, x, y = unpack(C.unitframes.target)
	frame:SetPoint(a1, p, a2, x, y+90)
	frame:SetSize(57, 57)
	
	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetTexCoord(.08, .92, .08, .92)
	frame.icon:SetAllPoints(frame)

	F.CreateBG(frame)

	frame:Hide()
	
	frame:RegisterEvent("UNIT_AURA")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	
	frame:SetScript("OnEvent", OnEvent)
end