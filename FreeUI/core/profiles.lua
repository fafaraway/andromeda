local F, C = unpack(select(2, ...))


if not C.isDeveloper then return end


local function SetCam(cmd)
	ConsoleExec('ActionCam ' .. cmd)
end


F:RegisterEvent('PLAYER_ENTERING_WORLD', function()
	-- Action camera
	UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')
	SetCam('basic')
end)
