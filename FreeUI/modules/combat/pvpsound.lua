local F, C, L = unpack(select(2, ...))
local COMBAT = F:GetModule('COMBAT')


local FILTER_MY_PETS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_OBJECT, COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_TYPE_PET)
local FILTER_ENEMY_PLAYERS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER)
local FILTER_ENEMY_NPC = bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)
local playerName, playerGUID = UnitName('player'), UnitGUID('player')
local lastKill, killCount, streakCount = nil, 0, 0
local deathsTable, killsTable = {}, {}
local debugMode = false

local soundsTable = {
	['firstblood'] = C.AssetsPath..'sounds\\killingblows\\kill\\firstblood.ogg',
	['killingspree'] = C.AssetsPath..'sounds\\killingblows\\kill\\killingspree.ogg',
	['rampage'] = C.AssetsPath..'sounds\\killingblows\\kill\\rampage.ogg',
	['dominating'] = C.AssetsPath..'sounds\\killingblows\\kill\\dominating.ogg',
	['unstoppable'] = C.AssetsPath..'sounds\\killingblows\\kill\\unstoppable.ogg',
	['godlike'] = C.AssetsPath..'sounds\\killingblows\\kill\\godlike.ogg',
	['wickedsick'] = C.AssetsPath..'sounds\\killingblows\\kill\\wickedsick.ogg',

	['doublekill'] = C.AssetsPath..'sounds\\killingblows\\multikill\\doublekill.ogg',
	['multikill'] = C.AssetsPath..'sounds\\killingblows\\multikill\\multikill.ogg',
	['megakill'] = C.AssetsPath..'sounds\\killingblows\\multikill\\megakill.ogg',
	['ultrakill'] = C.AssetsPath..'sounds\\killingblows\\multikill\\ultrakill.ogg',
	['monsterkill'] = C.AssetsPath..'sounds\\killingblows\\multikill\\monsterkill.ogg',
	['ludicrouskill'] = C.AssetsPath..'sounds\\killingblows\\multikill\\ludicrouskill.ogg',
	['holyshit'] = C.AssetsPath..'sounds\\killingblows\\multikill\\holyshit.ogg',

	['denied'] = C.AssetsPath..'sounds\\killingblows\\revenge\\denied.ogg',
	['retribution'] = C.AssetsPath..'sounds\\killingblows\\revenge\\retribution.ogg',
}

local function playSound(file)
	PlaySoundFile(file, 'Master')
end

local function printMessage(str)
	if not debugMode then return end

	F.Print(str)
end

local function OnEvent(self, event)
	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local timestamp, type, _,  sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, _, swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo()

		local toEnemy, fromEnemy, fromMyPets

		if destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) then
			toEnemy = CombatLog_Object_IsA(destFlags, debugMode and FILTER_ENEMY_NPC or FILTER_ENEMY_PLAYERS)
		end

		if sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) then
			fromMyPets = CombatLog_Object_IsA(sourceFlags, FILTER_MY_PETS)
			fromEnemy = CombatLog_Object_IsA(sourceFlags, FILTER_ENEMY_PLAYERS)
		end

		if (type == 'PARTY_KILL' and sourceGUID == playerGUID and toEnemy)
		or (type == 'SWING_DAMAGE' and destGUID ~= playerGUID and fromMyPets and toEnemy and swingOverkill >= 0)
		or ((type == 'RANGE_DAMAGE' or type == 'SPELL_DAMAGE' or type == 'SPELL_PERIODIC_DAMAGE') and destGUID ~= playerGUID and fromMyPets and toEnemy and spellOverkill >= 0) then

			if (killsTable[destName] and (timestamp - killsTable[destName]) < 5) then
				return
			else
				killsTable[destName] = timestamp
			end

			if lastKill and (timestamp - lastKill < 17) then
				streakCount = streakCount + 1
			else
				streakCount = 1
				killCount = killCount + 1
			end

			if streakCount == 2 then
				playSound(soundsTable.doublekill)
				printMessage('Double Kill')
			elseif streakCount == 3 then
				playSound(soundsTable.multikill)
				printMessage('Multi Kill')
			elseif streakCount == 4 then
				playSound(soundsTable.megakill)
				printMessage('Mega Kill')
			elseif streakCount == 5 then
				playSound(soundsTable.ultrakill)
				printMessage('Ultra Kill')
			elseif streakCount == 6 then
				playSound(soundsTable.monsterkill)
				printMessage('Monster Kill')
			elseif streakCount == 7 then
				playSound(soundsTable.ludicrouskill)
				printMessage('Ludicrous Kill')
			elseif streakCount >= 8 then
				playSound(soundsTable.holyshit)
				printMessage('Holy Shit')

			elseif streakCount <= 1 then
				if (deathsTable[destName] and (timestamp - deathsTable[destName]) < 90) then
					deathsTable[destName] = nil
					playSound(soundsTable.retribution)
					printMessage('Retribution')
				elseif killCount == 1 then
					playSound(soundsTable.firstblood)
					printMessage('First Blood')
				elseif killCount == 2 then
					playSound(soundsTable.killingspree)
					printMessage('Killing Spree')
				elseif killCount == 3 then
					playSound(soundsTable.rampage)
					printMessage('Rampage')
				elseif killCount == 4 then
					playSound(soundsTable.dominating)
					printMessage('Dominating')
				elseif killCount == 5 then
					playSound(soundsTable.unstoppable)
					printMessage('Unstoppable')
				elseif killCount == 6 then
					playSound(soundsTable.godlike)
					printMessage('GodLike')
				elseif killCount >= 7 then
					playSound(soundsTable.wickedsick)
					printMessage('Wicked Sick')
				end
			end

			lastKill = timestamp

		elseif (type == 'SWING_DAMAGE' and fromEnemy and destGUID == playerGUID and swingOverkill >= 0)
		or ((type == 'RANGE_DAMAGE' or type == 'SPELL_DAMAGE' or type == 'SPELL_PERIODIC_DAMAGE') and fromEnemy and destGUID == playerGUID and spellOverkill>= 0) then
			if sourceName ~= nil and sourceName ~= playerName then

				if (deathsTable[sourceName] and (timestamp - deathsTable[sourceName]) < 5) then
					return
				else
					deathsTable[sourceName] = timestamp
				end

				if killsTable[sourceName] and (timestamp - killsTable[sourceName]) < 90 then
					killsTable[sourceName] = nil
					playSound(soundsTable.denied)
					printMessage('Denied')
				end
			end
		end

	elseif event == 'ZONE_CHANGED_NEW_AREA' or event == 'PLAYER_DEAD' then
		lastKill = nil
		killCount = 0
		streakCount = 0
	end
end

function COMBAT:PvPSound()
	if not C.DB.combat.pvp_sound then return end

	local f = CreateFrame('Frame')
	f:SetScript('OnEvent', OnEvent)
	f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	f:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	f:RegisterEvent('PLAYER_DEAD')
end
