local F, C, L = unpack(select(2, ...))
local TOOLTIP, cfg = F:GetModule('Tooltip'), C.Tooltip


local wipe, tinsert, tconcat = table.wipe, table.insert, table.concat
local IsInGroup, IsInRaid, GetNumGroupMembers = IsInGroup, IsInRaid, GetNumGroupMembers
local UnitExists, UnitIsUnit, UnitIsDeadOrGhost, UnitName = UnitExists, UnitIsUnit, UnitIsDeadOrGhost, UnitName

local targetTable = {}

function TOOLTIP:ScanTargets()
	if not cfg.target_by then return end
	if not IsInGroup() then return end

	local _, unit = self:GetUnit()
	if not UnitExists(unit) then return end

	wipe(targetTable)

	for i = 1, GetNumGroupMembers() do
		local member = (IsInRaid() and 'raid'..i or 'party'..i)
		if UnitIsUnit(unit, member..'target') and not UnitIsUnit('player', member) and not UnitIsDeadOrGhost(member) then
			local color = F.HexRGB(F.UnitColor(member))
			local name = color..UnitName(member)..'|r'
			tinsert(targetTable, name)
		end
	end

	if #targetTable > 0 then
		GameTooltip:AddLine(L['TOOLTIP_TARGETED']..C.InfoColor..'('..#targetTable..')|r '..tconcat(targetTable, ', '), nil, nil, nil, 1)
	end
end

function TOOLTIP:TargetedInfo()
	if not cfg.target_by then return end
	
	GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.ScanTargets)
end