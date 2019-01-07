local F, C, L = unpack(select(2, ...))
local module = F:GetModule('reminder')

function module:Interrupt()
	if not C.reminder.interrupt then return end

	local interruptSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\Shutupfool.ogg'
	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		local inInstance, instanceType = IsInInstance()
		if ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
			if (event == 'SPELL_INTERRUPT') then
				if inInstance and IsInGroup() then
					SendChatMessage(L['interrupted']..destName..' '..GetSpellLink(spellID), say)
				end
				if C.reminder.interruptSoundAlert then
					PlaySoundFile(interruptSound, 'Master')
				end
			end
		end
	end)
end