local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')


local playedHp, playedMp
local lowHealth, lowMana = C.notification.lowHealth, C.notification.lowMana
local lowHealthSoundFile = C.AssetsPath..'sound\\lowhealth.ogg'
local lowManaSoundFile = C.AssetsPath..'sound\\lowmana.ogg'


function NOTIFICATION:Emergency()
	if not C.notification.emergency then return end

	local f = CreateFrame('Frame')
	f:SetScript('OnEvent', function(self, event, unit, pType)
		if unit ~= 'player' then return end

		if event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH' then
			if (UnitHealth('player') / UnitHealthMax('player')) < lowHealth then
				if not playedHp then
					playedHp = true
					PlaySoundFile(lowHealthSoundFile)
				end
			else
				playedHp = false
			end
		elseif (event == 'UNIT_POWER_UPDATE' or event == 'UNIT_MAXPOWER') and pType == 'MANA' then
			if (UnitPower('player') / UnitPowerMax('player')) < lowMana then
				if not playedMp then
					playedMp = true
					PlaySoundFile(lowManaSoundFile)
				end
			else
				playedMp = false
			end
		end
	end)

	f:RegisterEvent('UNIT_HEALTH')
	f:RegisterEvent('UNIT_POWER_UPDATE')
	f:RegisterEvent('UNIT_MAXHEALTH')
	f:RegisterEvent('UNIT_MAXPOWER')
end