local F, C = unpack(select(2, ...))


if not C.isDeveloper then return end


local function SetCam(cmd)
	ConsoleExec('ActionCam ' .. cmd)
end


local function RemoveTutorials(self, event)
	SetCVar('showTutorials', 0)
	SetCVar('showNPETutorials', 0)
	SetCVar('hideAdventureJournalAlerts', 1)

	-- help plates
	for i = 1, NUM_LE_FRAME_TUTORIALS do
		C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
	end

	for i = 1, NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
		C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
	end
end


-- Remove new talent alert
function MainMenuMicroButton_AreAlertsEnabled()
	return false
end


F:RegisterEvent('PLAYER_ENTERING_WORLD', function()
	-- Action camera
	UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')
	SetCam('basic')

	F:RegisterEvent('VARIABLES_LOADED', RemoveTutorials)
end)
