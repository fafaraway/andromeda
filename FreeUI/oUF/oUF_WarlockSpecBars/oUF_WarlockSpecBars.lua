local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

if select(2, UnitClass("player")) ~= "WARLOCK" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_WarlockSpecBars was unable to locate oUF install")

local SPELL_POWER_SOUL_SHARDS = SPELL_POWER_SOUL_SHARDS

local Colors = {
	[1] = {148/255, 130/255, 201/255, 1},
	[2] = {95/255, 222/255,  95/255, 1},
	[3] = {222/255, 95/255,  95/255, 1},
}

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end

	local wsb = self.WarlockSpecBars
	if(wsb.PreUpdate) then wsb:PreUpdate(unit) end

	local numShards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
	local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)

	for i = 1, maxShards do
		if i <= numShards then
			wsb[i]:GetStatusBarTexture():SetAlpha(1)
		else
			wsb[i]:GetStatusBarTexture():SetAlpha(.2)
		end
	end

	if(wsb.PostUpdate) then
		return wsb:PostUpdate(spec)
	end
end

local init = true

local function Visibility(self, event, unit)
	local wsb = self.WarlockSpecBars
	local spacing = select(4, wsb[4]:GetPoint())
	local w = wsb:GetWidth()
	local s = 0

	if not wsb:IsShown() then
		wsb:Show()
	end

	if init then
		for i = 1, UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS) do
			local max = select(2, wsb[i]:GetMinMaxValues())
			wsb[i]:SetValue(max)
			wsb[i]:GetStatusBarTexture():SetAlpha(1)
			wsb[i]:Show()
		end
		init = false
	end

	local maxShards = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)

	for i = 1, maxShards do
		if i ~= maxShards then
			wsb[i]:SetWidth(w / maxShards - spacing)
			s = s + (w / maxShards)
		else
			wsb[i]:SetWidth(w - s)
		end
		wsb[i]:SetStatusBarColor(unpack(Colors[SPEC_WARLOCK_AFFLICTION]))
	end

	-- force an update each time we respec
	Update(self, nil, "player")
end

local Path = function(self, ...)
	return (self.WarlockSpecBars.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit, "SOUL_SHARDS")
end

local function Enable(self)
	local wsb = self.WarlockSpecBars
	if(wsb) then
		wsb.__owner = self
		wsb.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Visibility)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Visibility)

		for i = 1, 4 do
			local Point = wsb[i]
			if not Point:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			Point:SetFrameLevel(wsb:GetFrameLevel() + 1)
			Point:GetStatusBarTexture():SetHorizTile(false)
		end

		wsb:Hide()

		return true
	end
end

local function Disable(self)
	local wsb = self.WarlockSpecBars
	if(wsb) then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Visibility)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Visibility)
	end
end

oUF:AddElement("WarlockSpecBars", Path, Enable, Disable)
