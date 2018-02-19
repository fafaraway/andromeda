local F, C, L = unpack(select(2, ...))

-- hides names/chat bubbles/pet tracking icons when the UIParent frame is hidden (alt+z)

-- initialize variables
local hide_name_cvars = {
		'UnitNameOwn',
		'UnitNameNPC',
		'UnitNameNonCombatCreatureName',
		'UnitNamePlayerGuild',
		'UnitNameGuildTitle',
		'UnitNamePlayerPVPTitle',
		'UnitNameFriendlyPlayerName',
		'UnitNameFriendlyPetName',
		'UnitNameFriendlyGuardianName',
		'UnitNameFriendlyTotemName',
		'UnitNameFriendlyMinionName',
		'UnitNameEnemyPlayerName',
		'UnitNameEnemyPetName',
		'UnitNameEnemyGuardianName',
		'UnitNameEnemyTotemName',
		'UnitNameEnemyMinionName',
		'UnitNameForceHideMinus',
		'UnitNameFriendlySpecialNPCName',
		'UnitNameHostleNPC',
		'UnitNameInteractiveNPC',
		'chatBubbles',
		'chatBubblesParty'
	}
local hide_names_to_toggle = {}
local hide_pettracking = false
local f = CreateFrame("Frame", 'hideCheckFrame', UIParent)
	
-- toggles off all currently displayed names; doesn't change settings of currently hidden names
local function hide_toggle_names_off()
	-- iterate through the table, store all currently displayed names and hide them
	for k,v in pairs(hide_name_cvars) do
		-- GetCVar returns a string and not a number...
		if GetCVar(v) == '1' then
			table.insert(hide_names_to_toggle, v)
			SetCVar(v,0)
		end
	end
	
	-- checks if pet tracking is currently active and disables it
	-- iterates through all trackable things to finde battle pets
	for i=1,GetNumTrackingTypes() do
		n, _, a = GetTrackingInfo(i)
		if n == 'Track Pets' and a then
			hide_pettracking = true
			SetTracking(i, false)
			break
		elseif n == 'Track Pets' and not a then
			hide_pettracking = false
			break
		end
	end
end

-- toggles on all previously displayed names; doesn't change settings of previously hidden names
local function hide_toggle_names_on()
	-- iterate through the stored cvars and show them
	for k,v in pairs(hide_names_to_toggle) do
		SetCVar(v,1)
	end
	hide_names_to_toggle = {}
	
	-- enables pet tracking if it was enabled before
	if hide_pettracking then
		for i=1,GetNumTrackingTypes() do
			n = GetTrackingInfo(i)
			if n == 'Track Pets' then
				SetTracking(i, true)
				hide_pettracking = false
				break
			end
		end
	end
end

-- register to OnShow/OnHide handlers
f:SetScript("OnShow", hide_toggle_names_on)
f:SetScript("OnHide", hide_toggle_names_off)