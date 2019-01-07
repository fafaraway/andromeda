local F, C, L = unpack(select(2, ...))

if C.automation.autoActionCam then
	local f = CreateFrame('Frame')

	f:RegisterEvent('PLAYER_LOGIN')
	UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')

	function SetCam(cmd)
		ConsoleExec('ActionCam ' .. cmd)
	end

	function f:OnEvent(event, ...)
		if event == 'PLAYER_LOGIN' then
			SetCam('basic')
		end
	end
	f:SetScript('OnEvent', f.OnEvent)
end
