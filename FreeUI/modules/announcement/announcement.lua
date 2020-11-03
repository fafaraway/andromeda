local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


function ANNOUNCEMENT:GetChannel()
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		return 'INSTANCE_CHAT'
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return 'RAID'
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return 'PARTY'
	end

	return 'NONE'
end

function ANNOUNCEMENT:SendMessage(text, channel)
	if channel == 'NONE' then
		return
	end

	SendChatMessage(text, channel)
end

function ANNOUNCEMENT:OnEvent()
	local timestamp, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, _, _, extraSpellId2 = CombatLogGetCurrentEventInfo()

	if event == 'SPELL_CAST_SUCCESS' then
		ANNOUNCEMENT:Utility(event, sourceName, spellId)
		ANNOUNCEMENT:CombatResurrection(sourceGUID, sourceName, destName, spellId)
	elseif event == 'SPELL_SUMMON' then
		ANNOUNCEMENT:Utility(event, sourceName, spellId)
	elseif event == 'SPELL_CREATE' then
		ANNOUNCEMENT:Utility(event, sourceName, spellId)
	elseif event == 'SPELL_INTERRUPT' then
		ANNOUNCEMENT:Interrupt(sourceGUID, sourceName, destName, spellId, extraSpellId2)
	elseif event == 'SPELL_DISPEL' then
		ANNOUNCEMENT:Dispel(sourceGUID, sourceName, destName, spellId, extraSpellId2)
	elseif event == 'SPELL_STOLEN' then
		ANNOUNCEMENT:Stolen(sourceGUID, sourceName, destName, spellId, extraSpellId2)
	end
end

function ANNOUNCEMENT:UpdateCombatAnnounce()
	if C.DB.announcement.enable then
		F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.OnEvent)
	else
		F:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.OnEvent)
	end
end


function ANNOUNCEMENT:OnLogin()
	if not C.DB.announcement.enable then return end

	F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.OnEvent)

	ANNOUNCEMENT:InstanceReset()
	ANNOUNCEMENT:UpdateQuestAnnounce()
end
