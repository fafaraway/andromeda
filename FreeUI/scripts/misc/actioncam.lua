local F, C, L = unpack(select(2, ...))


if IsAddOnLoaded("DynamicCam") then return end

local f = CreateFrame('Frame')

f:RegisterEvent('PLAYER_LOGIN')
UIParent:UnregisterEvent('EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED')

function SetCam(cmd)
	ConsoleExec('ActionCam ' .. cmd)
end

--[[overNames - Return nameplates over the head
underNames - Reposition nameplates under the feet
heavyHeadMove - heavy head movement
noHeadMove - disable head movement
lowHeadMove - enable head movement
headMove - enable head movement
focusOff - Target focusing only
focusOn - ACTION cam, without the target focusing
basic - Basic ActionCam
full - All action cam features on
off - Disable action cam features
default - Default ActionCam settings]]

function f:OnEvent(event, ...)
	if event == 'PLAYER_LOGIN' then
		if C.general.actionCam then
			if C.general.actionCam_full then
				SetCam('full')
			else
				SetCam('basic')
			end
		else
			SetCam('off')
		end
	end
end
f:SetScript('OnEvent', f.OnEvent)

