local F, C, L = unpack(select(2, ...))
if not C.misc.DOTA then return end


-- dota-like killing sound

local mapList = {
	[30] = true, 	--Alterac Valley
	[529] = true, 	--Arathi Basin
	[1105] = true, 	--Deepwind Gorge
	[566] = true, 	--Eye of the Storm
	[968] = true, 	--Eye of the Storm (Rated)
	[628] = true, 	--Isle of Conquest
	[727] = true, 	--Silvershard Mines
	[607] = true, 	--Strand of the Ancients
	[998] = true, 	--Temple of Kotmogu
	[761] = true, 	--The Battle for Gilneas
	[726] = true, 	--Twin Peaks
	[489] = true, 	--Warsong Gulch
	[1803] = true,

	[562] = true, 	--Blade's Edge Arena
	[617] = true, 	--Dalaran Arena
	[559] = true, 	--Nagrand Arena
	[572] = true, 	--Ruins of Lordaeron
	[618] = true, 	--The Ring of Valor
	[1134] = true, 	--The Tiger's Peak
	[980] = true, 	--Tol'Viron Arena
}

local soundpath = "interface\\addons\\FreeUI\\assets\\dota\\"
local forthealliance = "Interface\\Addons\\FreeUI\\assets\\sound\\forthealliance.mp3"
local forthehorde = "Interface\\Addons\\FreeUI\\assets\\sound\\forthehorde.mp3"

local firstblood = soundpath.."firstblood.ogg"
local killingspree = soundpath.."killingspree.ogg"
local dominating = soundpath.."dominating.ogg"
local megakill = soundpath.."megakill.ogg"
local unstoppable = soundpath.."unstoppable.ogg"
local wickedsick = soundpath.."wickedsick.ogg"
local monsterkill = soundpath.."monsterkill.ogg"
local godlike = soundpath.."godlike.ogg"
local holyshit = soundpath.."holyshit.ogg"

local doublekill = soundpath.."doublekill.ogg"
local triplekill = soundpath.."triplekill.ogg"
local ultrakill = soundpath.."ultrakill.ogg"
local rampage = soundpath.."rampage.ogg"


local DOTA_timer_reset = false;
local DOTA_reset_time = 1800;
local DOTA_mkill_time = 20;
local DOTA_kills = 0;
local enemyname = nil;
local total = 0

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame:RegisterEvent("PLAYER_DEAD");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

function frame:OnUpdate(elps)
	total = total + elps
	if total >= 2 then
		PlaySoundFile(DOTA_file_m,"Master");
		total = 0
		frame:SetScript('OnUpdate', nil)
	end
end

frame:SetScript("OnEvent", function(self, event, arg1)
	local player = UnitGUID("player")
	local pname = UnitName("player")
	local arg1, eventType, hideCaster, srcGUID, srcName, sourceFlags, sourceRaidFlags, destGUID, dstName, dstFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
	local CombatLog_Object_IsA = CombatLog_Object_IsA
	local COMBATLOG_OBJECT_NONE = COMBATLOG_OBJECT_NONE	
	local DOTA_COMBATLOG_FILTER_ENEMY_PLAYERS = bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER);
	local DOTA_COMBATLOG_FILTER_ENEMY_NPC = bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC);

	local DOTA_timer_reset_control;

	if (event=="COMBAT_LOG_EVENT_UNFILTERED") then

		if (eventType=="SPELL_DAMAGE" or eventType=="RANGE_DAMAGE" or eventType=="SPELL_PERIODIC_DAMAGE" or eventType=="SPELL_BUILDING_DAMAGE") then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName;
				elseif(dstName == pname and srcName == pname) then
					DEFAULT_CHAT_FRAME:AddMessage(pname.." "..killyourself,1,1,0);
					DOTA_timer_reset_control = true;

					enemyname = nil;
				end
			end

		elseif eventType=="SWING_DAMAGE" then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName;
				elseif(dstName == pname and srcName == pname) then
					DEFAULT_CHAT_FRAME:AddMessage(pname.." "..killyourself,1,1,0);
					DOTA_timer_reset_control = true;
					enemyname = nil;
				end
			end
		elseif eventType=="ENVIRONMENTAL_DAMAGE" then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13,overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName;

				elseif(dstName == pname and srcName == pname) then
					DEFAULT_CHAT_FRAME:AddMessage(pname.." "..killyourself,1,1,0);
					DOTA_timer_reset_control = true;

					enemyname = nil;
				end
			end
	 	end
	end
  
	if event == "PLAYER_DEAD" then
		if DOTA_timer_reset_control == true then
			DOTA_timer_reset = DOTA_timer_reset;
		else
			DOTA_timer_reset = true;
			DOTA_timer_reset_control = false;
		end

	end
	
	if event == "ZONE_CHANGED_NEW_AREA" then 
		local instID = select(8, GetInstanceInfo())
		local faction = UnitFactionGroup("player")

		if mapList[instID] then
			-- just for fun :)
			if faction == "Alliance" then
				PlaySoundFile(forthealliance, "Master");
			elseif faction == "Horde" then
				PlaySoundFile(forthehorde, "Master");
			end
		end

		DOTA_timer_reset = true;
	end

	local toEnemy
	local toEnemyPlayer
	local toEnemyNPC
	if (dstName and not CombatLog_Object_IsA(dstFlags, COMBATLOG_OBJECT_NONE) ) then
		toEnemyPlayer = CombatLog_Object_IsA(dstFlags, DOTA_COMBATLOG_FILTER_ENEMY_PLAYERS)
		toEnemyNPC = CombatLog_Object_IsA(dstFlags, DOTA_COMBATLOG_FILTER_ENEMY_NPC)
	end

	toEnemy = toEnemyPlayer;

	if (eventType == "PARTY_KILL" and srcGUID == player and toEnemy ) then
		if (not DOTA_lastkill or (GetTime() - DOTA_lastkill > DOTA_reset_time ) or DOTA_timer_reset) then

			DOTA_file = firstblood;
			DOTA_kills = 1;
			DOTA_mkills = 1;
			DOTA_timer_reset = false;

		elseif (GetTime() - DOTA_lastkill <= DOTA_reset_time ) then
			DOTA_kills = DOTA_kills + 1;
			
			if (GetTime() - DOTA_lastkill <= DOTA_mkill_time) then
				DOTA_firstmkill = DOTA_lastkill;
				
				if (DOTA_kills == 2) then
					DOTA_file = ""

				elseif (DOTA_kills == 3) then
					DOTA_file = killingspree

				elseif (DOTA_kills == 4) then
					DOTA_file = dominating

				elseif (DOTA_kills == 5) then
					DOTA_file = megakill

				elseif (DOTA_kills == 6) then
					DOTA_file = unstoppable

				elseif (DOTA_kills == 7) then
					DOTA_file = wickedsick

				elseif (DOTA_kills == 8) then
					DOTA_file = monsterkill

				elseif (DOTA_kills == 9) then
					DOTA_file = godlike

				elseif (DOTA_kills > 9) then
					DOTA_file = holyshit

				else
					DOTA_file = ""

				end


				if (GetTime() - DOTA_firstmkill <= DOTA_mkill_time) then
					DOTA_mkills = DOTA_mkills + 1;
					if (DOTA_mkills == 2) then
						DOTA_file_m = doublekill;

					elseif (DOTA_mkills == 3) then
						DOTA_file_m = triplekill;

					elseif (DOTA_mkills == 4) then
						DOTA_file_m = ultrakill;

					elseif (DOTA_mkills == 5) then
						DOTA_file_m = rampage;

					elseif (DOTA_mkills > 5) then
						DOTA_file_m = rampage;

					else
						DOTA_file_m = "";

					end
				end

			else
				DOTA_mkills = 1
				if (DOTA_kills == 2) then
						DOTA_file = ""

				elseif (DOTA_kills == 3) then
					DOTA_file = killingspree

				elseif (DOTA_kills == 4) then
					DOTA_file = dominating

				elseif (DOTA_kills == 5) then
					DOTA_file = megakill

				elseif (DOTA_kills == 6) then
					DOTA_file = unstoppable

				elseif (DOTA_kills == 7) then
					DOTA_file = wickedsick

				elseif (DOTA_kills == 8) then
					DOTA_file = monsterkill

				elseif (DOTA_kills == 9) then
					DOTA_file = godlike

				elseif (DOTA_kills > 9) then
					DOTA_file = holyshit

				else
					DOTA_file = ""

				end

			end
		end

		DOTA_lastkill = GetTime();
		if DOTA_kills >=2 and DOTA_mkills >=2 then
			PlaySoundFile(DOTA_file, "Master");--

			frame:SetScript('OnUpdate', frame.OnUpdate);
		elseif DOTA_kills ~= nil and DOTA_mkills == 1 then

			PlaySoundFile(DOTA_file, "Master");
		elseif DOTA_kills == 2 and DOTA_mkills ~= nil then

			PlaySoundFile(DOTA_file, "Master");
		end

	else
		return;
	end
end)





