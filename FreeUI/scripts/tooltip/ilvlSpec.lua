local F, C = unpack(select(2, ...))
if not C.tooltip.enable then return end
if not C.tooltip.ilvlSpec then return end
local module = F:GetModule("Tooltip")

--[[
	Cloudy Unit Info
	Copyright (c) 2016, Cloudyfa
	All rights reserved.
]]


--- Variables ---
local currentUNIT, currentGUID
local GearDB, SpecDB, ItemDB = {}, {}, {}

local prefixColor = '|cffffeeaa'
local detailColor = '|cffffffff'
local lvlPattern = gsub(ITEM_LEVEL, '%%d', '(%%d+)')
local furySpec = GetSpecializationNameForSpecID(72)


--- Create Frame ---
local f = CreateFrame('Frame', 'CloudyUnitInfo')
f:RegisterEvent('UNIT_INVENTORY_CHANGED')


--- Set Unit Info ---
local function SetUnitInfo(gear, spec)
	if (not gear) then return end

	local _, unit = GameTooltip:GetUnit()
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end
	if UnitLevel(unit) < 10 then
		spec = STAT_AVERAGE_ITEM_LEVEL
	elseif (not spec) then
		spec = CONTINUED
	end

	local infoLine
	for i = 2, GameTooltip:NumLines() do
		local line = _G['GameTooltipTextLeft' .. i]
		local text = line and line:GetText() or ''

		if (text == CONTINUED) or strfind(text, spec .. ': ', 1, true) then
			infoLine = line
			break
		end
	end

	local infoString = CONTINUED
	if (spec ~= CONTINUED) then
		infoString = prefixColor .. spec .. ': ' .. detailColor .. gear
	end

	if infoLine then
		infoLine:SetText(infoString)
	else
		GameTooltip:AddLine(infoString)
	end
	GameTooltip:Show()
end

local itemLevelString = _G["ITEM_LEVEL"]:gsub("%%d", "(%%d+)")
function module:GetItemLevel(link, quality)
	if ItemDB[link] and quality ~= 6 then return ItemDB[link] end

	local tip = _G["FreeUIScanTooltip"] or CreateFrame("GameTooltip", "FreeUIScanTooltip", nil, "GameTooltipTemplate")
	tip:SetOwner(UIParent, "ANCHOR_NONE")
 	tip:SetHyperlink(link)

	for i = 2, 5 do
		local text = _G[tip:GetName().."TextLeft"..i]:GetText() or ""
		local level = string.match(text, itemLevelString)
		if level then
			ItemDB[link] = tonumber(level)
			break
		end
	end
	return ItemDB[link]
end


--- BOA Items ---
local BOAItems = {
	[133585] = 1, [133595] = 1, [133596] = 1,
	[133597] = 1, [133598] = 1,
}


--- BOA Item Level ---
local function BOALevel(level, id)
	if (level > 97) then
		if BOAItems[id] then
			level = 815 - (110 - level) * 10
		else
			level = 605 - (100 - level) * 5
		end
	elseif (level > 90) then
		level = 590 - (97 - level) * 10
	elseif (level > 85) then
		level = 463 - (90 - level) * 19.5
	elseif (level > 80) then
		level = 333 - (85 - level) * 13.5
	elseif (level > 67) then
		level = 187 - (80 - level) * 4
	elseif (level > 57) then
		level = 105 - (67 - level) * 2.8
	elseif (level > 10) then
		level = level + 5
	else
		level = 10
	end

	return floor(level + 0.5)
end


--- PVP Item Detect ---
local function IsPVPItem(link)
	local itemStats = GetItemStats(link)

	for stat in pairs(itemStats) do
		if (stat == 'ITEM_MOD_RESILIENCE_RATING_SHORT') or (stat == 'ITEM_MOD_PVP_POWER_SHORT') then
			return true
		end
	end

	return false
end


--- Scan Item Level ---
local function scanItemLevel(link, forced)
	if (not forced) and ItemDB[link] then return ItemDB[link] end

	local scanTip = _G['CUnitScan'] or CreateFrame('GameTooltip', 'CUnitScan', nil, 'GameTooltipTemplate')
	scanTip:SetOwner(UIParent, 'ANCHOR_NONE')
 	scanTip:SetHyperlink(link)

	for i = 2, scanTip:NumLines() do
		local textLine = _G['CUnitScanTextLeft' .. i]
		if textLine and textLine:GetText() then
			local level = strmatch(textLine:GetText(), lvlPattern)
			if level then
				ItemDB[link] = tonumber(level)
				return ItemDB[link]
			end
		end
	end
end


--- Unit Gear Info ---
local function UnitGear(unit)
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

	local ulvl = UnitLevel(unit)
	local class = select(2, UnitClass(unit))

	local boa, pvp = 0, 0
	local wlvl, wslot = 0, 0
	local ilvl, total, delay = nil, 0, nil

	for i = 1, 17 do
		if (i ~= 4) then
			local id = GetInventoryItemID(unit, i)

			if id then
				local link = GetInventoryItemLink(unit, i)

				if (not link) then
					delay = true
				else
					local _, _, quality, level, _, _, _, _, slot = GetItemInfo(link)

					if (not quality) or (not level) then
						delay = true
					else
						if (quality == 6) and (i == 16 or i == 17) then
							local relics = {select(4, strsplit(':', link))}
							for i = 1, 3 do
								local relicID = relics[i] ~= '' and relics[i]
								local relicLink = select(2, GetItemGem(link, i))
								if relicID and not relicLink then
									delay = true
									break
								end
							end
							level = scanItemLevel(link, true) or level
						elseif (quality == 7) then
							level = BOALevel(ulvl, id)
							boa = boa + 1
						else
							level = scanItemLevel(link) or level
							if IsPVPItem(link) then
								pvp = pvp + 1
							end
						end

						if (i == 16) then
							if (SpecDB[currentGUID] == furySpec) or (quality == 6) then
								wlvl = level
								wslot = slot
							end
							if (slot == 'INVTYPE_2HWEAPON') or (slot == 'INVTYPE_RANGED') or ((slot == 'INVTYPE_RANGEDRIGHT') and (class == 'HUNTER')) then
								level = level * 2
							end
						end

						if (i == 17) then
							if (SpecDB[currentGUID] == furySpec) then
								if (wslot ~= 'INVTYPE_2HWEAPON') and (slot == 'INVTYPE_2HWEAPON') then
									if (level > wlvl) then
										level = level * 2 - wlvl
									end
								elseif (wslot == 'INVTYPE_2HWEAPON') then
									if (level > wlvl) then
										if (slot == 'INVTYPE_2HWEAPON') then
											level = level * 2 - wlvl * 2
										else
											level = level - wlvl
										end
									else
										level = 0
									end
								end
							elseif (quality == 6) and wlvl then
								if level > wlvl then
									level = level * 2 - wlvl
								else
									level = wlvl
								end
							end
						end

						total = total + level
					end
				end
			end
		end
	end

	if (not delay) then
		if (unit == 'player') and (GetAverageItemLevel() > 0) then
			ilvl = select(2, GetAverageItemLevel())
		else
			ilvl = total / 16
		end
		if (ilvl > 0) then ilvl = string.format('%.1f', ilvl) end

		if (boa > 0) then ilvl = ilvl .. '  |cffe6cc80' .. boa .. ' BOA' end
		if (pvp > 0) then ilvl = ilvl .. '  |cffa335ee' .. pvp .. ' PVP' end
	end
	return ilvl
end


--- Unit Specialization ---
local function UnitSpec(unit)
	if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

	local specName
	if (unit == 'player') then
		local specIndex = GetSpecialization()
		if specIndex then
			specName = select(2, GetSpecializationInfo(specIndex))
		end
	else
		local specID = GetInspectSpecialization(unit)
		if specID and (specID > 0) then
			specName = GetSpecializationNameForSpecID(specID)
		end
	end

	return specName
end


--- Scan Current Unit ---
local function ScanUnit(unit, forced)
	local cachedGear, cachedSpec

	if UnitIsUnit(unit, 'player') then
		cachedSpec = UnitSpec('player')
		cachedGear = UnitGear('player')

		SetUnitInfo(cachedGear or CONTINUED, cachedSpec)
	else
		if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end

		cachedSpec = SpecDB[currentGUID]
		cachedGear = GearDB[currentGUID]

		if cachedGear or forced then
			SetUnitInfo(cachedGear, cachedSpec)
		end

		if not (IsShiftKeyDown() or forced) then
			if cachedGear and cachedSpec then return end
			if UnitAffectingCombat('player') then return end
		end

		if (not UnitIsVisible(unit)) then return end
		if UnitIsDeadOrGhost('player') or UnitOnTaxi('player') then return end
		if InspectFrame and InspectFrame:IsShown() then return end

		SetUnitInfo(CONTINUED, cachedSpec)

		local lastRequest = GetTime() - (f.lastUpdate or 0)
		if (lastRequest >= 1.5) then
			f.nextUpdate = 0
		else
			f.nextUpdate = 1.5 - lastRequest
		end
		f:Show()
	end
end

--- Handle Events ---
f:SetScript('OnEvent', function(self, event, ...)
	if (event == 'UNIT_INVENTORY_CHANGED') then
		local unit = ...
		if (UnitGUID(unit) == currentGUID) then
			ScanUnit(unit, true)
		end
	elseif (event == 'INSPECT_READY') then
		local guid = ...
		if (guid == currentGUID) then
			local spec = UnitSpec(currentUNIT)
			SpecDB[guid] = spec

			local gear = UnitGear(currentUNIT)
			GearDB[guid] = gear

			if (not gear) or (not spec) then
				ScanUnit(currentUNIT, true)
			else
				SetUnitInfo(gear, spec)
			end
		end
		self:UnregisterEvent('INSPECT_READY')
	end
end)

f:SetScript('OnUpdate', function(self, elapsed)
	self.nextUpdate = (self.nextUpdate or 0) - elapsed
	if (self.nextUpdate > 0) then return end

	self:Hide()
	ClearInspectPlayer()

	if currentUNIT and (UnitGUID(currentUNIT) == currentGUID) then
		self.lastUpdate = GetTime()
		self:RegisterEvent('INSPECT_READY')
		NotifyInspect(currentUNIT)
	end
end)

GameTooltip:HookScript('OnTooltipSetUnit', function(self)
	local _, unit = self:GetUnit()
	if (not unit) or (not CanInspect(unit)) then return end

	currentUNIT, currentGUID = unit, UnitGUID(unit)
	ScanUnit(unit)
end)
