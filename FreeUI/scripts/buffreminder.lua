local F, C, L = unpack(select(2, ...))

if C.general.buffreminder == false then return end

local class = select(2, UnitClass("Player"))
local buffs = C.selfbuffs[class]

if not buffs then return end

local function OnEvent(self, event, unit)
	if unit and unit ~= "player" then return end

	if UnitAffectingCombat("player") and not UnitInVehicle("player") then
		self.hasTexture = false

		for k, v in pairs(buffs) do -- these are the buffs that caan be combined
			self.cacheTexture = nil
			self.cacheCount = nil
			for i, buffSet in pairs(v) do -- these buffs are exclusive to each other
				for _, buff in pairs(buffSet) do
					self.doubleBreak = false

					local name = GetSpellInfo(buff)
					if name and UnitBuff("player", name) then
						self.hasTexture = false
						if self.cacheCount == i then self.cacheTexture = nil end
						-- if we cast the buff, don't check other exclusive sets (cause it'll prompt us to cast that one and lose the first)
						-- if we didn't cast it, we check if there's an other buff exclusive to this one that we can cast
						if select(8, UnitAura("player", name)) == "player" then
							self.doubleBreak = true
							self.cacheTexture = nil
						end
						break
					end

					local usable, nomana = IsUsableSpell(name)
					if not self.hasTexture and (usable or nomana) then
						self.cacheTexture = select(3, GetSpellInfo(buff))
						self.cacheCount = i -- we need to empty cache if we got a buff from current set, but not if we got one from next one
						self.icon:SetTexture(self.cacheTexture)
						self.hasTexture = true
					end
				end

				if self.doubleBreak then break end
			end

			if self.cacheTexture and not self.hasTexture then -- in case we lack the first buff, and checked the second one, which is handled by an other class
				self.icon:SetTexture(self.cacheTexture)
				self.hasTexture = true
			end

			if self.hasTexture then
				self:Show()
				return
			else
				self:Hide()
			end
		end
	else
		self:Hide()
	end
end

local frame = CreateFrame("Frame", nil, UIParent)
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

-- avoid an extra comparison every time UNIT_AURA fires
local mover = CreateFrame("Frame")
mover:RegisterEvent("PlAYER_LOGIN")
mover:SetScript("OnEvent", function()
	frame:SetPoint("BOTTOM", oUF_FreeTarget, "TOP", 0, 42)
	mover = nil
end)