local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Remind')

local CombatResSpells = {
	[61999] = true,	-- 盟友復生
	[20484] = true,	-- 復生
	[20707] = true,	-- 靈魂石
}


function module:Resurrect()
	if not C.remind.resurrect then return end

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self, event)	
		local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
		local _, _, difficultyID = GetInstanceInfo()
		
		if event ~= 'SPELL_CAST_SUCCESS' then return end
		
		if destName then destName = destName:gsub('%-[^|]+', '') end
		if sourceName then sourceName = sourceName:gsub('%-[^|]+', '') else return end
		
		if difficultyID ~= 0 then
			if CombatResSpells[spellID] then
				if destName == nil then
					SendChatMessage(format(L['ResNoTarget'], sourceName, GetSpellLink(spellID)), say)
				else
					SendChatMessage(format(L['ResTarget'], sourceName, GetSpellLink(spellID), destName), say)
				end
			end
		end

	end)
end