local F, C = unpack(select(2, ...))
local oUF = F.oUF


local UpdateRate = 0.1

local UpdateFrame
local Objects = {}
local ObjectRanges = {}

-- Array of possible spell IDs in order of priority, and the name of the highest known priority spell

local HelpName
local HarmName


-- Optional lists of low level baseline skills with greater than 28 yard range.
-- First known spell in the appropriate class list gets used.
-- Note: Spells probably shouldn't have minimum ranges!

local HelpIDs = ({
	DEATHKNIGHT = {
		61999, 	-- Raise Ally (40 yards)
	},
	DEMONHUNTER = {},
	DRUID = {
		8936,	-- Regrowth (40 yards, all specs, lvl 5)
		50769,	-- Revive (40 yards, all specs, lvl 14)
	},
	HUNTER = {
		982, 	-- Mend Pet (45 yards)
	},
	MAGE = {
		130, 	-- Slow Fall (40 yards)
	},
	MONK = {
		116670, -- Vivify (40 yards)
		115178, -- Resuscitate (40 yards)
	},
	PALADIN = {
		19750, 	-- Flash of Light (40 yards)
		7328, 	-- Redemption (40 yards)
	},
	PRIEST = {
		2061,	-- Flash Heal (40 yards)
		17,		-- Power Word: Shield (40 yards)
		2006,	-- Resurrection (40 yards)
	},
	ROGUE = {
		57934, 	-- Tricks of the Trade (100 yards)
	},
	SHAMAN = {
		8004, 	-- Healing Surge (Resto/Elemental) (40 yards)
		188070, -- Healing Surge (Enhancement) (40 yards)
		2008, 	-- Ancestral Spirit (40 yards)
	},
	WARLOCK = {
		20707, 	-- Soulstone (40 yards)
		755, 	-- Health Funnel (45 yards)
	},
	WARRIOR = {},
})[C.MyClass]

local HarmIDs = ({
	DEATHKNIGHT = {
		49576, 	-- Death Grip
		47541, 	-- Death Coil (Unholy) (40 yards)
	},
	DEMONHUNTER = {
		183752, -- Consume Magic (20 yards)
		185123, -- Throw Glaive (Havoc) (30 yards)
        204021, -- Fiery Brand (Vengeance) (30 yards)
	},
	DRUID = {
		8921,	-- Moonfire (40 yards, all specs, lvl 3)
	},
	HUNTER = {
		75, 	-- Auto Shot (40 yards)
	},
	MAGE = {
		118, 	-- Polymorph (30 yards)
		116, 	-- Frostbolt (Frost) (40 yards)
        44425, 	-- Arcane Barrage (Arcane) (40 yards)
		133, 	-- Fireball (Fire) (40 yards)
	},
	MONK = {
		115546, -- Provoke (30 yards)
		117952, -- Crackling Jade Lightning (40 yards)
	},
	PALADIN = {
		62124, 	-- Hand of Reckoning (30 yards)
        183218, -- Hand of Hindrance (30 yards)
        20271, 	-- Judgement (30 yards) Retribution, (does not work for retribution below lvl 78)
        275779, -- Judgement (30 yards) Tank
		275773, -- Judgement (30 yards) Heal
		20473, 	-- Holy Shock (40 yards)
	},
	PRIEST = {
		585,	-- Smite (40 yards)
		589,	-- Shadow Word: Pain (40 yards)
	},
	ROGUE = {
		185565, -- Poisoned Knife (Assassination) (30 yards)
        185763, -- Pistol Shot (Outlaw) (20 yards)
        114014, -- Shuriken Toss (Sublety) (30 yards)
		1725, 	-- Distract (30 yards)
	},
	SHAMAN = {
		188196, -- Lightning Bolt (Elemental) (40 yards)
        187837, -- Lightning Bolt (Enhancement) (40 yards)
		403, 	-- Lightning Bolt (Resto) (40 yards)
	},
	WARLOCK = {
		5782, 	-- Fear (30 yards)
		234153, -- Drain Life (40 yards)
        198590, -- Drain Soul (40 yards)
        232670, -- Shadow Bolt (40 yards, lvl 1 spell)
		686, 	-- Shadow Bolt (Demonology) (40 yards, lvl 1 spell)
	},
	WARRIOR = {
		355, 	-- Taunt (30 yards)
	},
})[C.MyClass]

local IsInRange
do
	local UnitIsConnected = UnitIsConnected
	local UnitCanAssist = UnitCanAssist
	local UnitCanAttack = UnitCanAttack
	local UnitIsUnit = UnitIsUnit
	local UnitPlayerOrPetInRaid = UnitPlayerOrPetInRaid
	local UnitIsDead = UnitIsDead
	local UnitOnTaxi = UnitOnTaxi
	local UnitInRange = UnitInRange
	local IsSpellInRange = IsSpellInRange
	local CheckInteractDistance = CheckInteractDistance

	-- Uses an appropriate range check for the given unit.
	-- Actual range depends on reaction, known spells, and status of the unit.
	-- @param unit  Unit to check range for.
	-- @return True if in casting range
	function IsInRange(unit)
		if (UnitIsConnected(unit)) then
			if (UnitCanAssist('player', unit)) then
				if (HelpName and not UnitIsDead(unit)) then
					return IsSpellInRange(HelpName, unit) == 1 and true or false
				elseif (UnitOnTaxi('player')) then  -- UnitInRange always returns nil while on flightpaths
					return false
				elseif (UnitIsUnit(unit, 'player') or UnitIsUnit(unit, 'pet') or UnitPlayerOrPetInParty(unit) or UnitPlayerOrPetInRaid(unit)) then
					local inRange, checkedRange = UnitInRange(unit)
					if (checkedRange and not inRange) then
						return false
					else
						return true
					end
				end
			elseif (HarmName and not UnitIsDead(unit) and UnitCanAttack('player', unit)) then
				return IsSpellInRange(HarmName, unit) == 1 and true or false
			end

			-- Fallback when spell not found or class uses none

			return CheckInteractDistance(unit, 4) and true or false -- Follow distance (28 yd range)
		end
	end
end

-- Rechecks range for a unit frame, and fires callbacks when the unit passes in or out of range
local function UpdateRange(self)
	local InRange = IsInRange(self.unit)
	if (ObjectRanges[self] ~= InRange) then -- Range state changed
		ObjectRanges[self] = InRange

		local SpellRange = self.SpellRange
		if (SpellRange.Update) then
			SpellRange.Update(self, InRange)
		else
			--self:SetAlpha(SpellRange[InRange and 'insideAlpha' or 'outsideAlpha'])

			if InRange then
				F:UIFrameFadeIn(self, 0.3, self:GetAlpha(), insideAlpha or 1)
			else
				F:UIFrameFadeOut(self, 0.3, self:GetAlpha(), outsideAlpha or 0.3)
			end
		end
	end
end


local OnUpdate;
do
	local NextUpdate = 0

	-- Updates the range display for all visible oUF unit frames on an interval
	function OnUpdate(self, Elapsed)
		NextUpdate = NextUpdate - Elapsed
		if (NextUpdate <= 0) then
			NextUpdate = UpdateRate

			for Object in pairs(Objects) do
				if (Object:IsVisible()) then
					UpdateRange(Object)
				end
			end
		end
	end
end

local OnSpellsChanged
do
	local IsSpellKnown = IsSpellKnown
	local GetSpellInfo = GetSpellInfo

	-- @return Highest priority spell name available, or nil if none
	local function GetSpellName(IDs)
		if (IDs) then
			for _, ID in ipairs(IDs) do
				if (IsSpellKnown(ID)) then
					return GetSpellInfo(ID)
				end
			end
		end
	end

	-- Checks known spells for the highest priority spell name to use
	function OnSpellsChanged()
		HelpName, HarmName = GetSpellName(HelpIDs), GetSpellName(HarmIDs)
	end
end


-- Called by oUF when the unit frame's unit changes or otherwise needs a complete update.
-- @param Event  Reason for the update.  Can be a real event, nil, or a string defined by oUF.
local function Update (self, Event, UnitID)
	if (Event ~= 'OnTargetUpdate') then -- OnTargetUpdate is fired on a timer for *target units that don't have real events
		ObjectRanges[self] = nil -- Force update to fire
		UpdateRange(self) -- Update range immediately
	end
end

-- Forces range to be recalculated for this element's frame immediately.
local function ForceUpdate(self)
	return Update(self.__owner, 'ForceUpdate', self.__owner.unit)
end

-- Called by oUF for new unit frames to setup range checking.
-- @return True if the range element was actually enabled.
local function Enable(self, UnitID)
	local SpellRange = self.SpellRange
	if (SpellRange) then
		assert(type( SpellRange ) == 'table', 'oUF layout addon using invalid SpellRange element.')
		assert(type(SpellRange.Update) == 'function' or (tonumber(SpellRange.insideAlpha) and tonumber(SpellRange.outsideAlpha)), 'oUF layout addon omitted required SpellRange properties.')

			if (self.Range) then -- Disable default range checking
				self:DisableElement('Range')
				self.Range = nil -- Prevent range element from enabling, since enable order isn't stable
			end

			SpellRange.__owner = self
			SpellRange.ForceUpdate = ForceUpdate
			if (not UpdateFrame) then
				UpdateFrame = CreateFrame('Frame')
				UpdateFrame:SetScript('OnUpdate', OnUpdate)
				UpdateFrame:SetScript('OnEvent', OnSpellsChanged)
			end
			if (not next(Objects)) then -- First object
				UpdateFrame:Show()
				UpdateFrame:RegisterEvent('SPELLS_CHANGED')
				OnSpellsChanged() -- Recheck spells immediately
			end

			Objects[self] = true
			return true
		end
	end

	--- Called by oUF to disable range checking on a unit frame.
	local function Disable(self)
		Objects[self] = nil
		ObjectRanges[self] = nil

		if (not next(Objects))then -- Last object
			UpdateFrame:Hide()
			UpdateFrame:UnregisterEvent('SPELLS_CHANGED')
		end
	end

	oUF:AddElement('SpellRange', Update, Enable, Disable)
