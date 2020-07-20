local F, C, L = unpack(select(2, ...))
local COMBAT, cfg = F:GetModule('Combat'), C.Combat


local assets = 'Interface\\AddOns\\FreeUI\\assets\\'
local playerName, playerGUID = UnitName('player'), UnitGUID('player')
local toEnemy, fromEnemy, fromMyPets
local lastKill, killCount, streakCount = nil, 0, 0
local deathsList, killsList = {}, {}
local debug = false

local soundsList = {
	['firstblood'] = assets..'sounds\\killingblows\\kill\\firstblood.ogg',
	['killingspree'] = assets..'sounds\\killingblows\\kill\\killingspree.ogg',
	['rampage'] = assets..'sounds\\killingblows\\kill\\rampage.ogg',
	['dominating'] = assets..'sounds\\killingblows\\kill\\dominating.ogg',
	['unstoppable'] = assets..'sounds\\killingblows\\kill\\unstoppable.ogg',
	['godlike'] = assets..'sounds\\killingblows\\kill\\godlike.ogg',
	['wickedsick'] = assets..'sounds\\killingblows\\kill\\wickedsick.ogg',

	['doublekill'] = assets..'sounds\\killingblows\\multikill\\doublekill.ogg',
	['multikill'] = assets..'sounds\\killingblows\\multikill\\multikill.ogg',
	['megakill'] = assets..'sounds\\killingblows\\multikill\\megakill.ogg',
	['ultrakill'] = assets..'sounds\\killingblows\\multikill\\ultrakill.ogg',
	['monsterkill'] = assets..'sounds\\killingblows\\multikill\\monsterkill.ogg',
	['ludicrouskill'] = assets..'sounds\\killingblows\\multikill\\ludicrouskill.ogg',
	['holyshit'] = assets..'sounds\\killingblows\\multikill\\holyshit.ogg',

	['denied'] = assets..'sounds\\killingblows\\revenge\\denied.ogg',
	['retribution'] = assets..'sounds\\killingblows\\revenge\\retribution.ogg',
}

local function playSound(file)
	PlaySoundFile(file, 'Master')
	-- PlaySoundFile(file, 'SFX')
end

local function printMessage(str)
	if not debug then return end

	F.Print(str)
end

local function OnEvent(self, event)
	if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
		local timestamp, type, _,  sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, _, swingOverkill, _, _, spellOverkill = CombatLogGetCurrentEventInfo()

		local FILTER_MY_PETS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MINE, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_OBJECT, COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_TYPE_PET)
		local FILTER_ENEMY_PLAYERS = bit.bor(COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER) --COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC
		local FILTER_ENEMY_NPC = bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)

		if destName and not CombatLog_Object_IsA(destFlags, COMBATLOG_OBJECT_NONE) then
			toEnemy = CombatLog_Object_IsA(destFlags, debug and FILTER_ENEMY_NPC or FILTER_ENEMY_PLAYERS)
		end

		if sourceName and not CombatLog_Object_IsA(sourceFlags, COMBATLOG_OBJECT_NONE) then
			fromMyPets = CombatLog_Object_IsA(sourceFlags, FILTER_MY_PETS)
			fromEnemy = CombatLog_Object_IsA(sourceFlags, FILTER_ENEMY_PLAYERS)
		end

		if (type == 'PARTY_KILL' and sourceGUID == playerGUID and toEnemy)
		or (type == 'SWING_DAMAGE' and destGUID ~= playerGUID and fromMyPets and toEnemy and swingOverkill >= 0)
		or ((type == 'RANGE_DAMAGE' or type == 'SPELL_DAMAGE' or type == 'SPELL_PERIODIC_DAMAGE') and destGUID ~= playerGUID and fromMyPets and toEnemy and spellOverkill >= 0) then

			if lastKill and (timestamp - lastKill < 17) then
				streakCount = streakCount + 1
			else
				streakCount = 1
				killCount = killCount + 1
			end

			if streakCount == 2 then
				playSound(soundsList.doublekill)
				printMessage('Double Kill')
			elseif streakCount == 3 then
				playSound(soundsList.multikill)
				printMessage('Multi Kill')
			elseif streakCount == 4 then
				playSound(soundsList.megakill)
				printMessage('Mega Kill')
			elseif streakCount == 5 then
				playSound(soundsList.ultrakill)
				printMessage('Ultra Kill')
			elseif streakCount == 6 then
				playSound(soundsList.monsterkill)
				printMessage('Monster Kill')
			elseif streakCount == 7 then
				playSound(soundsList.ludicrouskill)
				printMessage('Ludicrous Kill')
			elseif streakCount >= 8 then
				playSound(soundsList.holyshit)
				printMessage('Holy Shit')

			elseif streakCount <= 1 then
				killsList[destName] = timestamp
				if (deathsList[destName] and (timestamp - deathsList[destName]) < 90) then
					deathsList[destName] = nil
					playSound(soundsList.retribution)
					printMessage('Retribution')
				elseif killCount == 1 then
					playSound(soundsList.firstblood)
					printMessage('First Blood')
				elseif killCount == 2 then
					playSound(soundsList.killingspree)
					printMessage('Killing Spree')
				elseif killCount == 3 then
					playSound(soundsList.rampage)
					printMessage('Rampage')
				elseif killCount == 4 then
					playSound(soundsList.dominating)
					printMessage('Dominating')
				elseif killCount == 5 then
					playSound(soundsList.unstoppable)
					printMessage('Unstoppable')
				elseif killCount == 6 then
					playSound(soundsList.godlike)
					printMessage('GodLike')
				elseif killCount >= 7 then
					playSound(soundsList.wickedsick)
					printMessage('Whicked Sick')
				end
			end

			lastKill = timestamp

		elseif (type == 'SWING_DAMAGE' and fromEnemy and destGUID == playerGUID and swingOverkill >= 0)
		or ((type == 'RANGE_DAMAGE' or type == 'SPELL_DAMAGE' or type == 'SPELL_PERIODIC_DAMAGE') and fromEnemy and destGUID == playerGUID and spellOverkill>= 0) then
			if sourceName ~= nil and sourceName ~= playerName then
				deathsList[sourceName] = timestamp
				if killsList[sourceName] and (timestamp - killsList[sourceName]) < 90 then
					killsList[sourceName] = nil
					playSound(soundsList.denied)
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
	if not cfg.pvp_sound then return end

	local f = CreateFrame('Frame')
	f:SetScript('OnEvent', OnEvent)
	f:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	f:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	f:RegisterEvent('PLAYER_DEAD')
end

COMBAT:RegisterCombat("PvPSound", COMBAT.PvPSound)