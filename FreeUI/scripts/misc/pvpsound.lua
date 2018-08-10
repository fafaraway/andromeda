local F, C, L = unpack(select(2, ...))

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

	[562] = true, 	--Blade's Edge Arena
	[617] = true, 	--Dalaran Arena
	[559] = true, 	--Nagrand Arena
	[572] = true, 	--Ruins of Lordaeron
	[618] = true, 	--The Ring of Valor
	[1134] = true, 	--The Tiger's Peak
	[980] = true, 	--Tol'Viron Arena
}


local PS_timer_reset = false;
local PS_reset_time = 1800;
local PS_mkill_time = 12;
local PS_kills = 0;
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
		PlaySoundFile("Interface\\Addons\\FreeUI\\assets\\dota\\classical\\"..PS_file_m,"Master");
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
	local PS_COMBATLOG_FILTER_ENEMY_PLAYERS = bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER);
	local PS_COMBATLOG_FILTER_ENEMY_NPC = bit.bor (COMBATLOG_OBJECT_AFFILIATION_MASK, COMBATLOG_OBJECT_REACTION_MASK, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC);

	local PS_timer_reset_control;

	if (event=="COMBAT_LOG_EVENT_UNFILTERED") then

		if (eventType=="SPELL_DAMAGE" or eventType=="RANGE_DAMAGE" or eventType=="SPELL_PERIODIC_DAMAGE" or eventType=="SPELL_BUILDING_DAMAGE") then
			local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, overkill = CombatLogGetCurrentEventInfo()
			if overkill and overkill > 0 then
				if(dstName == pname and srcName ~= pname) then
					enemyname = srcName;
				elseif(dstName == pname and srcName == pname) then
					DEFAULT_CHAT_FRAME:AddMessage(pname.." "..killyourself,1,1,0);
					PS_timer_reset_control = true;

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
					PS_timer_reset_control = true;
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
					PS_timer_reset_control = true;

					enemyname = nil;
				end
			end
	 	end
	end
  
	if event == "PLAYER_DEAD" then
		if PS_timer_reset_control == true then
			PS_timer_reset = PS_timer_reset;
		else
			PS_timer_reset = true;
			PS_timer_reset_control = false;
		end

	end
	
	if event == "ZONE_CHANGED_NEW_AREA" then 
		local instID = select(8, GetInstanceInfo())

		if mapList[instID] then
			PlaySoundFile("Interface\\Addons\\FreeUI\\assets\\dota\\classical\\PrepareForBattle.ogg", "Master");
		end

		PS_timer_reset = true;
	end

	local toEnemy
	local toEnemyPlayer
	local toEnemyNPC
	if (dstName and not CombatLog_Object_IsA(dstFlags, COMBATLOG_OBJECT_NONE) ) then
		toEnemyPlayer = CombatLog_Object_IsA(dstFlags, PS_COMBATLOG_FILTER_ENEMY_PLAYERS)
		toEnemyNPC = CombatLog_Object_IsA(dstFlags, PS_COMBATLOG_FILTER_ENEMY_NPC)
	end

	toEnemy = toEnemyPlayer;

	if (eventType == "PARTY_KILL" and srcGUID == player and toEnemy ) then
		if (not PS_lastkill or (GetTime() - PS_lastkill > PS_reset_time ) or PS_timer_reset) then

			PS_file = "firstblood.ogg";
			PS_kills = 1;
			PS_mkills = 1;
			PS_timer_reset = false;

		elseif (GetTime() - PS_lastkill <= PS_reset_time ) then
			PS_kills = PS_kills + 1;
			
			-- multikill
			if (GetTime() - PS_lastkill <= PS_mkill_time) then
				PS_firstmkill = PS_lastkill;
				
				if (PS_kills == 2) then
					PS_file = ""

				elseif (PS_kills == 3) then
					PS_file = "killingspree.ogg"

				elseif (PS_kills == 4) then
					PS_file = "dominating.ogg"

				elseif (PS_kills == 5) then
					PS_file = "megakill.ogg"

				elseif (PS_kills == 6) then
					PS_file = "unstoppable.ogg"

				elseif (PS_kills == 7) then
					PS_file = "wickedsick.ogg"

				elseif (PS_kills == 8) then
					PS_file = "monsterkill.ogg"

				elseif (PS_kills == 9) then
					PS_file = "godlike.ogg"

				elseif (PS_kills > 9) then
					PS_file = "holyshit.ogg"

				else
					PS_file = ""

				end


				if (GetTime() - PS_firstmkill <= PS_mkill_time) then
					PS_mkills = PS_mkills + 1;
					if (PS_mkills == 2) then
						PS_file_m = "doublekill.ogg";

					elseif (PS_mkills == 3) then
						PS_file_m = "triplekill.ogg";

					elseif (PS_mkills == 4) then
						PS_file_m = "UltraKill.ogg";

					elseif (PS_mkills == 5) then
						PS_file_m = "Rampage.ogg";

					elseif (PS_mkills > 5) then
						PS_file_m = "Rampage.ogg";

					else
						PS_file_m = "";

					end
				end

			else
				PS_mkills = 1
				if (PS_kills == 2) then
						PS_file = ""

				elseif (PS_kills == 3) then
					PS_file = "killingspree.ogg"

				elseif (PS_kills == 4) then
					PS_file = "dominating.ogg"

				elseif (PS_kills == 5) then
					PS_file = "megakill.ogg"

				elseif (PS_kills == 6) then
					PS_file = "unstoppable.ogg"

				elseif (PS_kills == 7) then
					PS_file = "wickedsick.ogg"

				elseif (PS_kills == 8) then
					PS_file = "monsterkill.ogg"

				elseif (PS_kills == 9) then
					PS_file = "godlike.ogg"

				elseif (PS_kills > 9) then
					PS_file = "holyshit.ogg"

				else
					PS_file = ""

				end

			end
		end

		PS_lastkill = GetTime();
		if PS_kills >=2 and PS_mkills >=2 then
			PlaySoundFile("Interface\\Addons\\FreeUI\\assets\\dota\\classical\\"..PS_file, "Master");--
			frame:SetScript('OnUpdate', frame.OnUpdate);
		elseif PS_kills ~= nil and PS_mkills == 1 then
			PlaySoundFile("Interface\\Addons\\FreeUI\\assets\\dota\\classical\\"..PS_file, "Master");
		elseif PS_kills == 2 and PS_mkills ~= nil then
			PlaySoundFile("Interface\\Addons\\FreeUI\\assets\\dota\\classical\\"..PS_file, "Master");
		end
	else
		return;
	end
end)





