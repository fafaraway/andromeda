local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT

local function checkGroupStatus()
	if IsInInstance() and IsInGroup() and GetNumGroupMembers() > 1 and not IsInRaid() then
		return true
	end

	return false
end

function ANNOUNCEMENT:IsGroupMember(name)
	if name then
		if UnitInParty(name) then
			return 1
		elseif UnitInRaid(name) then
			return 2
		elseif name == C.MyName then
			return 3
		end
	end

	return false
end

function ANNOUNCEMENT:GetChannel()
	if IsPartyLFG() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		return 'INSTANCE_CHAT'
	elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
		return 'RAID'
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		return 'PARTY'
	elseif C.DB.Announcement.Solo then
		return 'SELF'
	end

	return 'NONE'
end

function ANNOUNCEMENT:SendMessage(text, channel, raidWarning, whisperTarget)
	if channel == 'NONE' then
		return
	end

	if channel == 'SELF' then
		F.Print(text)
		return
	end

	if channel == 'WHISPER' then
		if whisperTarget then
			SendChatMessage(text, channel, nil, whisperTarget)
		end
		return
	end

	if channel == 'RAID' and raidWarning and IsInRaid(LE_PARTY_CATEGORY_HOME) then
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') or IsEveryoneAssistant() then
			channel = 'RAID_WARNING'
		end
	end

	SendChatMessage(text, channel)
end

function ANNOUNCEMENT:OnEvent()
	local timestamp, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, _, _, extraSpellId2 = CombatLogGetCurrentEventInfo()

	if event == 'SPELL_CAST_SUCCESS' then
		ANNOUNCEMENT:Utility(event, sourceName, spellId)
		ANNOUNCEMENT:BattleRez(sourceGUID, sourceName, destName, spellId)
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

function ANNOUNCEMENT:OnLogin()
	if not C.DB.Announcement.Enable then
		return
	end

	F:RegisterEvent('PLAYER_ENTERING_WORLD', checkGroupStatus)
	F:RegisterEvent('ZONE_CHANGED_NEW_AREA', checkGroupStatus)
	F:RegisterEvent('GROUP_JOINED', checkGroupStatus)
	F:RegisterEvent('GROUP_LEFT', checkGroupStatus)
	F:RegisterEvent('GROUP_ROSTER_UPDATE', checkGroupStatus)

	F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.OnEvent)

	ANNOUNCEMENT:InstanceReset()
	ANNOUNCEMENT:QuestNotification()
end
