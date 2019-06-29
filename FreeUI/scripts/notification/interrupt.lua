local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Notification')

function module:Interrupt()
	if not C.notification.interrupt then return end

	local interruptSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\interrupt.ogg'
	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		local inInstance, instanceType = IsInInstance()
		if ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
			if (event == 'SPELL_INTERRUPT') then
				if inInstance and IsInGroup() then
					SendChatMessage(L['NOTIFICATION_INTERRUPTED']..destName..' '..GetSpellLink(spellID), say)
				end
				if C.notification.interruptSound then
					PlaySoundFile(interruptSound, 'Master')
				end
			end
		end
	end)
end