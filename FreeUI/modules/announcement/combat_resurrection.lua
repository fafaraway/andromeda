local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


local spellList = {
	[61999] = true, -- 盟友復生
	[20484] = true, -- 復生
	[20707] = true, -- 靈魂石
	[265116] = true, -- 不穩定的時間轉移器（工程學）
	[345130] = true -- Disposable Spectrophasic Reanimator（工程學）
}

local function FormatMessage(message, sourceName, destName, spellId)
	destName = destName:gsub("%-[^|]+", "")
	sourceName = sourceName:gsub("%-[^|]+", "")
	message = gsub(message, "%%player%%", sourceName)
	message = gsub(message, "%%target%%", destName)
	message = gsub(message, "%%spell%%", GetSpellLink(spellId))
	return message
end


function ANNOUNCEMENT:CombatResurrection(sourceGUID, sourceName, destName, spellId)
	if not C.DB.announcement.combat_resurrection then return end

	if not sourceName or not destName then
		return
	end

	if spellList[spellId] then
		if destName == nil then
			ANNOUNCEMENT:SendMessage(
				FormatMessage(L['ANNOUNCEMENT_COMBAT_RESURRECTION_SELF'], sourceName, destName, spellId),
				ANNOUNCEMENT:GetChannel()
			)
		else
			ANNOUNCEMENT:SendMessage(
				FormatMessage(L['ANNOUNCEMENT_COMBAT_RESURRECTION_TARGET'], sourceName, destName, spellId),
				ANNOUNCEMENT:GetChannel()
			)
		end
	end
end
