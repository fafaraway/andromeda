local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UNITFRAME')
local oUF = F.oUF


local LibRangeCheck = F.Libs.RangeCheck
local updateFrequency = 0.25
local _FRAMES = {}
local OnRangeFrame

local FriendSpells = {}
local HarmSpells = {}

FriendSpells['DEATHKNIGHT'] = {
	61999, 	-- Raise Ally (40 yards)
}
HarmSpells['DEATHKNIGHT'] = {
	49576, 	-- Death Grip
	47541, 	-- Death Coil (Unholy) (40 yards)
}

FriendSpells['DEMONHUNTER'] = {
}
HarmSpells['DEMONHUNTER'] = {
	183752, -- Consume Magic (20 yards)
	185123, -- Throw Glaive (Havoc) (30 yards)
	204021, -- Fiery Brand (Vengeance) (30 yards)
}

FriendSpells['DRUID'] = {
	774, -- ['Rejuvenation'], -- 40
	2782, -- ['Remove Corruption'], -- 40
}
HarmSpells['DRUID'] = {
	8921,	-- Moonfire (40 yards, all specs, lvl 3)
}

FriendSpells['HUNTER'] = {
	982, 	-- Mend Pet (45 yards)
}
HarmSpells['HUNTER'] = {
	75, 	-- Auto Shot (40 yards)
}

FriendSpells['MAGE'] = {
	130, 	-- Slow Fall (40 yards)
}
HarmSpells['MAGE'] = {
	118, 	-- Polymorph (30 yards)
	116, 	-- Frostbolt (Frost) (40 yards)
	44425, 	-- Arcane Barrage (Arcane) (40 yards)
	133, 	-- Fireball (Fire) (40 yards)
}

FriendSpells['MONK'] = {
	116670, -- Vivify (40 yards)
	115178, -- Resuscitate (40 yards)
}
HarmSpells['MONK'] = {
	115546, -- Provoke (30 yards)
	117952, -- Crackling Jade Lightning (40 yards)
}

FriendSpells['PALADIN'] = {
	19750, 	-- Flash of Light (40 yards)
	7328, 	-- Redemption (40 yards)
}
HarmSpells['PALADIN'] = {
	62124, 	-- Hand of Reckoning (30 yards)
	183218, -- Hand of Hindrance (30 yards)
	20271, 	-- Judgement (30 yards) Retribution, (does not work for retribution below lvl 78)
	275779, -- Judgement (30 yards) Tank
	275773, -- Judgement (30 yards) Heal
	20473, 	-- Holy Shock (40 yards)
}

FriendSpells['PRIEST'] = {
	2061,	-- Flash Heal (40 yards)
	17,		-- Power Word: Shield (40 yards)
	2006,	-- Resurrection (40 yards)
}
HarmSpells['PRIEST'] = {
	585,	-- Smite (40 yards)
	589,	-- Shadow Word: Pain (40 yards)
}

FriendSpells['ROGUE'] = {
	57934, 	-- Tricks of the Trade (100 yards)
}
HarmSpells['ROGUE'] = {
	185565, -- Poisoned Knife (Assassination) (30 yards)
	185763, -- Pistol Shot (Outlaw) (20 yards)
	114014, -- Shuriken Toss (Sublety) (30 yards)
	1725, 	-- Distract (30 yards)
}

FriendSpells['SHAMAN'] = {
	8004, 	-- Healing Surge (Resto/Elemental) (40 yards)
	188070, -- Healing Surge (Enhancement) (40 yards)
	2008, 	-- Ancestral Spirit (40 yards)
}
HarmSpells['SHAMAN'] = {
	188196, -- Lightning Bolt (Elemental) (40 yards)
	187837, -- Lightning Bolt (Enhancement) (40 yards)
	403, 	-- Lightning Bolt (Resto) (40 yards)
}

FriendSpells['WARRIOR'] = {}
HarmSpells['WARRIOR'] = {
	355, 	-- Taunt (30 yards)
}

FriendSpells['WARLOCK'] = {
	5697, -- ['Unending Breath'], -- 30
	20707, 	-- Soulstone (40 yards)
	755, 	-- Health Funnel (45 yards)
}
HarmSpells['WARLOCK'] = {
	5782, 	-- Fear (30 yards)
	234153, -- Drain Life (40 yards)
	198590, -- Drain Soul (40 yards)
	232670, -- Shadow Bolt (40 yards, lvl 1 spell)
	686, 	-- Shadow Bolt (Demonology) (40 yards, lvl 1 spell)
}


local function IsUnitInRange(unit)
	if not unit then return end
	local canAttack = UnitCanAttack('player', unit)
	local canHelp = UnitCanAssist('player', unit)
	local isFriend = UnitIsFriend('player', unit)
	local isVisible = UnitIsVisible(unit)
	local rangeSpells, minRange, maxRange
	local connected = UnitIsConnected(unit)
	if not connected then return true end

	if isVisible then
		if canAttack then
			rangeSpells = HarmSpells[C.MyClass]
		elseif canHelp then
			rangeSpells = FriendSpells[C.MyClass]
		end
		if canHelp or canAttack then
			for i = 1,#rangeSpells do
				if IsSpellKnown(rangeSpells[i]) then
					if IsSpellInRange(GetSpellInfo(rangeSpells[i]),unit) == 1 then
						return true
					end
				end
			end
		end
		if canAttack then
			minRange, maxRange = LibRangeCheck:GetRange(unit,true)
			if not maxRange then maxRange = minRange end
			if maxRange < 30 then
				return true
			end
		end
		if canHelp then
			minRange, maxRange = LibRangeCheck:GetRange(unit,true)
			if not maxRange then maxRange = minRange end
			if maxRange < 40 then
				return true
			end
		end
		if not canHelp and not canAttack and isFriend then return true end -- We can't reliably get range on units we cannot interact with so don't fade the frame out.
	end

	return false
end

local function Update(self, isInRange, event)
	local element = self.RangeCheck
	local unit = self.unit

	local insideAlpha = element.insideAlpha or 1
	local outsideAlpha = element.outsideAlpha or 0.55

	if(element.PreUpdate) then
		element:PreUpdate()
	end

	if element.enabled == true then
		if isInRange then
			--self:SetAlpha(insideAlpha)
			F:UIFrameFadeIn(self, .3, self:GetAlpha(), insideAlpha)
		else
			--self:SetAlpha(outsideAlpha)
			F:UIFrameFadeIn(self, .3, self:GetAlpha(), outsideAlpha)
		end
		if(element.PostUpdate) then
			return element:PostUpdate(self, unit)
		end
	else
		self:SetAlpha(1)
		self:DisableElement('RangeCheck')
	end
end

local function Path(self, ...)
	return (self.RangeCheck.Override or Update) (self, IsUnitInRange(self.unit), ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate')
end

-- Internal updating method
local timer = 0
local function OnRangeUpdate(_, elapsed)
	timer = timer + elapsed

	if(timer >= updateFrequency) then
		for _, object in next, _FRAMES do
			if(object:IsShown()) then
				Path(object, 'OnUpdate')
			end
		end

		timer = 0
	end
end

local function Enable(self)
	local element = self.RangeCheck
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate
		element.insideAlpha = element.insideAlpha or 1
		element.outsideAlpha = element.outsideAlpha or 0.55

		if(not OnRangeFrame) then
			OnRangeFrame = CreateFrame('Frame')
			OnRangeFrame:SetScript('OnUpdate', OnRangeUpdate)
		end

		table.insert(_FRAMES, self)
		OnRangeFrame:Show()

		return true
	end
end

local function Disable(self)
	local element = self.RangeCheck
	if(element) then
		for index, frame in next, _FRAMES do
			if(frame == self) then
				table.remove(_FRAMES, index)
				break
			end
		end
		self:SetAlpha(element.insideAlpha)

		if(#_FRAMES == 0) then
			OnRangeFrame:Hide()
		end
	end
end

oUF:AddElement('RangeCheck', Path, Enable, Disable)
