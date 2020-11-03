local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


local function FormatMessage(message, destName, extraSpellId)
	destName = destName:gsub('%-[^|]+', '')
	message = gsub(message, '%%target%%', destName)
	message = gsub(message, '%%spell%%', GetSpellLink(extraSpellId))
	return message
end

function ANNOUNCEMENT:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId)
	if not C.DB.announcement.interrupt then return end

	if not (IsInInstance() and IsInGroup()) then
		return
	end

	if not (spellId and extraSpellId) then
		return
	end

	if not (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')) then return end

	ANNOUNCEMENT:SendMessage(FormatMessage(L['ANNOUNCEMENT_INTERRUPT'], destName, extraSpellId))
end

function ANNOUNCEMENT:Dispel(sourceGUID, sourceName, destName, spellId, extraSpellId)
	if not C.DB.announcement.dispel then return end

	if not (IsInInstance() and IsInGroup()) then
		return
	end

	if not (spellId and extraSpellId) then
		return
	end

	if not (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')) then return end

	ANNOUNCEMENT:SendMessage(FormatMessage(L['ANNOUNCEMENT_DISPEL'], destName, extraSpellId))
end

function ANNOUNCEMENT:Stolen(sourceGUID, sourceName, destName, spellId, extraSpellId)
	if not C.DB.announcement.dispel then return end

	if not (IsInInstance() and IsInGroup()) then
		return
	end

	if not (spellId and extraSpellId) then
		return
	end

	if not (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet')) then return end

	ANNOUNCEMENT:SendMessage(FormatMessage(L['ANNOUNCEMENT_STOLEN'], destName, extraSpellId))
end
