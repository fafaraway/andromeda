local F, C = unpack(select(2, ...))

if not C.isDeveloper then return end


do
	local function SetCam(cmd)
		ConsoleExec('ActionCam ' .. cmd)
	end

	F:RegisterEvent('PLAYER_ENTERING_WORLD', function()
		UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')
		SetCam('basic')
	end)
end

do -- Prevents spells from being automatically added to your action bar
	IconIntroTracker.RegisterEvent = function() end
	IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

	-- local f = CreateFrame('frame')
	-- f:SetScript('OnEvent', function(self, event, spellID, slotIndex, slotPos)
	-- 	if not InCombatLockdown() then
	-- 		ClearCursor()
	-- 		PickupAction(slotIndex)
	-- 		ClearCursor()
	-- 	end
	-- end)
	-- f:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
end


-- Hide tutorial
-- Credit ketho
-- https://github.com/ketho-wow/HideTutorial
local function OnEvent(self, event, addon)
	if event == 'ADDON_LOADED' and addon == 'HideTutorial' then
		local tocVersion = select(4, GetBuildInfo())
		if not C.DB.toc_version or C.DB.toc_version < tocVersion then
			-- only do this once per character
			C.DB.toc_version = tocVersion
		end
	elseif event == 'VARIABLES_LOADED' then
		local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', NUM_LE_FRAME_TUTORIALS)
		if C.DB.installation.complete or not lastInfoFrame then
			C_CVar.SetCVar('showTutorials', 0)
			C_CVar.SetCVar('showNPETutorials', 0)
			C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
			-- help plates
			for i = 1, NUM_LE_FRAME_TUTORIALS do
				C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
			end
			for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
				C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
			end
		end

		function MainMenuMicroButton_AreAlertsEnabled()
			return false
		end
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('VARIABLES_LOADED')
f:SetScript('OnEvent', OnEvent)
