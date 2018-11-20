local F, C, L = unpack(select(2, ...))
local module = F:GetModule('reminder')

function module:Sapped()
	if not C.reminder.sapped then return end

	local frame = CreateFrame('Frame')
	local _, playerName
	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	frame:RegisterEvent('PLAYER_LOGIN')
	frame:SetScript('OnEvent',function(_, event, ...)
		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local _, event, _, _, sourceName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
			if spellID == 6770 and destName == playerName and (event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH') then
				SendChatMessage('{rt8} '..(GetSpellLink(6770) or 'Sapped')..' {rt8}','SAY')
				if sourceName then DEFAULT_CHAT_FRAME:AddMessage((GetSpellLink(6770) or 'Sapped')..' -- '..sourceName) end
			end
		elseif event == 'PLAYER_ENTERING_WORLD' then
			local _, instanceType, _, _, _, _, _, instanceMapID = GetInstanceInfo()
			if instanceType == 'scenario' or instanceType == 'party' or instanceType == 'raid' then
				if frame:IsEventRegistered('ZONE_CHANGED') then
					frame:UnregisterEvent('ZONE_CHANGED')
					frame:UnregisterEvent('ZONE_CHANGED_INDOORS')
					frame:UnregisterEvent('ZONE_CHANGED_NEW_AREA')
				end
				if frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
				if frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:UnregisterEvent('PLAYER_REGEN_DISABLED') end
				if frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:UnregisterEvent('PLAYER_REGEN_ENABLED') end
			elseif instanceType == 'arena' or instanceType == 'pvp' then
				if frame:IsEventRegistered('ZONE_CHANGED') then
					frame:UnregisterEvent('ZONE_CHANGED')
					frame:UnregisterEvent('ZONE_CHANGED_INDOORS')
					frame:UnregisterEvent('ZONE_CHANGED_NEW_AREA')
				end
				if not frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:RegisterEvent('PLAYER_REGEN_DISABLED') end
				if not frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:RegisterEvent('PLAYER_REGEN_ENABLED') end
				if not InCombatLockdown() and not frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
			else
				if not frame:IsEventRegistered('ZONE_CHANGED') then
					frame:RegisterEvent('ZONE_CHANGED')
					frame:RegisterEvent('ZONE_CHANGED_INDOORS')
					frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
				end
				if IsResting() then
					if frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
					if frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:UnregisterEvent('PLAYER_REGEN_DISABLED') end
					if frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:UnregisterEvent('PLAYER_REGEN_ENABLED') end
				else
					if not frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:RegisterEvent('PLAYER_REGEN_DISABLED') end
					if not frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:RegisterEvent('PLAYER_REGEN_ENABLED') end
					if not InCombatLockdown() and not frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
				end
			end
		elseif event == 'PLAYER_LOGIN' then
			playerName = GetUnitName('player')
			frame:UnregisterEvent('PLAYER_LOGIN')
		elseif event == 'PLAYER_REGEN_DISABLED' then
			frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		elseif event == 'PLAYER_REGEN_ENABLED' then
			frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		else
			C_Timer.After(5, function()
				if IsResting() then
					if frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
					if frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:UnregisterEvent('PLAYER_REGEN_DISABLED') end
					if frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:UnregisterEvent('PLAYER_REGEN_ENABLED') end
				else
					if not frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:RegisterEvent('PLAYER_REGEN_DISABLED') end
					if not frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:RegisterEvent('PLAYER_REGEN_ENABLED') end
					if not InCombatLockdown() and not frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
				end
			end)
		end
	end)
end