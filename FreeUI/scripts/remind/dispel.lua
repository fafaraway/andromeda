local F, C, L = unpack(select(2, ...))
local module = F:GetModule('Remind')

function module:Dispel()
	if not C.remind.dispel then return end

	local dispelSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\buzz.ogg'
	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		local inInstance, instanceType = IsInInstance()
		if ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
			if (event == 'SPELL_DISPEL') then
				PlaySoundFile(dispelSound, 'Master')
				if inInstance and (instanceType ~= 'pvp' and instanceType ~= 'arena') then
					SendChatMessage(L['dispeled']..destName..' '..GetSpellLink(spellID), say)
				end
			elseif (event == 'SPELL_STOLEN') then
				PlaySoundFile(dispelSound, 'Master')
				if inInstance and (instanceType ~= 'pvp' and instanceType ~= 'arena') then
					SendChatMessage(L['stolen']..destName..' '..GetSpellLink(spellID), say)
				end
			end
		end
	end)
end