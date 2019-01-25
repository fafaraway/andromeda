local F, C, L = unpack(select(2, ...))


if IsAddOnLoaded("DynamicCam") then return end

local f = CreateFrame('Frame')

f:RegisterEvent('PLAYER_LOGIN')
UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')

function SetCam(cmd)
	ConsoleExec('ActionCam ' .. cmd)
end

function f:OnEvent(event, ...)
	if event == 'PLAYER_LOGIN' and C.automation.autoActionCam then
		SetCam('basic')
	else
		SetCam('off')
	end
end
f:SetScript('OnEvent', f.OnEvent)

