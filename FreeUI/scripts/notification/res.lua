local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Notification')

local CombatResSpells = {
	[61999] = true,	-- 盟友復生
	[20484] = true,	-- 復生
	[20707] = true,	-- 靈魂石
}


function module:Resurrect()
	if not C.notification.resurrect then return end

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self, event)	
		local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
		local inInstance, instanceType = IsInInstance()
		
		if event ~= 'SPELL_CAST_SUCCESS' then return end
		
		if destName then destName = destName:gsub('%-[^|]+', '') end
		if sourceName then sourceName = sourceName:gsub('%-[^|]+', '') else return end
		
		if inInstance and IsInGroup() then
			if CombatResSpells[spellID] then
				if destName == nil then
					SendChatMessage(format(L['NOTIFICATION_RESNOTARGET'], sourceName, GetSpellLink(spellID)), say)
				else
					SendChatMessage(format(L['NOTIFICATION_RESTARGET'], sourceName, GetSpellLink(spellID), destName), say)
				end
			end
		end

	end)
end