local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT

local spellList = {
	[61999] = true, -- Raise Ally (DK)
	[20484] = true, -- Rebirth (Druid)
	[20707] = true, -- Soulstone (Warlock)
	[265116] = true, -- Unstable Temporal Time Shifter (Engineering)
	[345130] = true -- Disposable Spectrophasic Reanimator（Engineering）
}

local function FormatMessage(message, sourceName, destName, spellId)
	destName = destName:gsub('%-[^|]+', '')
	sourceName = sourceName:gsub('%-[^|]+', '')
	message = gsub(message, '%%player%%', sourceName)
	message = gsub(message, '%%target%%', destName)
	message = gsub(message, '%%spell%%', GetSpellLink(spellId))
	return message
end

function ANNOUNCEMENT:BattleRez(sourceGUID, sourceName, destName, spellId)
	if not C.DB.Announcement.BattleRez then
		return
	end

	if not sourceName or not destName then
		return
	end

	if spellList[spellId] then
		ANNOUNCEMENT:SendMessage(FormatMessage(L.ANNOUNCEMENT.BATTLE_REZ, sourceName, destName, spellId), ANNOUNCEMENT:GetChannel())
	end
end
