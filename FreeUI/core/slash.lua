local F, C, L = unpack(select(2, ...))

SlashCmdList.FRAMENAME = function() print(GetMouseFocus():GetName()) end
SLASH_FRAMENAME1 = "/gn"

SlashCmdList.GETPARENT = function() print(GetMouseFocus():GetParent():GetName()) end
SLASH_GETPARENT1 = "/gp"

SlashCmdList.DISABLE_ADDON = function(s) DisableAddOn(s) end
SLASH_DISABLE_ADDON1 = "/dis"

SlashCmdList.ENABLE_ADDON = function(s) EnableAddOn(s) end
SLASH_ENABLE_ADDON1 = "/en"

SlashCmdList.RELOADUI = ReloadUI
SLASH_RELOADUI1 = "/rl"

SlashCmdList.RCSLASH = DoReadyCheck
SLASH_RCSLASH1 = "/rc"

SlashCmdList.ROLECHECK = InitiateRolePoll
SLASH_ROLECHECK1 = "/rolecheck"
SLASH_ROLECHECK2 = "/rolepoll"

SlashCmdList.TICKET = ToggleHelpFrame
SLASH_TICKET1 = "/gm"

SlashCmdList.VOLUME = function(value)
	local numValue = tonumber(value)
	if numValue and 0 <= numValue and numValue <= 1 then
		SetCVar("Sound_MasterVolume", numValue)
	end
end
SLASH_VOLUME1 = "/vol"

SlashCmdList.FREEUI = function(cmd)
	local cmd, args = strsplit(" ", cmd:lower(), 2)
	if C.unitframes.enable then
		if cmd == "dps" then
			FreeUIConfig.layout = 1
			ReloadUI()
		elseif(cmd == "heal" or cmd == "healer") then
			FreeUIConfig.layout = 2
			ReloadUI()
		end
	end

	if cmd == "install" then
		if IsAddOnLoaded("FreeUI_Install") then
			FreeUI_InstallFrame:Show()
		else
			EnableAddOn("FreeUI_Install")
			LoadAddOn("FreeUI_Install")
		end
	elseif cmd == "reset" then
		FreeUIGlobalConfig = {}
		FreeUIConfig = {}
		ReloadUI()
	else
		if not BankFrame:IsShown() and FreeUIOptionsPanel then
			FreeUIOptionsPanel:Show()
		end
		
	end
end
SLASH_FREEUI1 = "/freeui"

SlashCmdList.GPOINT = function(f)
	if f ~= "" then
		f = _G[f]
	else
		f = GetMouseFocus()
	end

	if f ~= nil then
		local a1, p, a2, x, y = f:GetPoint()
		print("|cffFFD100"..a1.."|r "..p:GetName().."|cffFFD100 "..a2.."|r "..x.." "..y)
	end
end

SLASH_GPOINT1 = "/gpoint"

SlashCmdList.FPS = function(value)
	local numValue = tonumber(value)
	if numValue and 0 <= numValue then
		SetCVar("maxFPS", numValue)
	end
end
SLASH_FPS1 = "/fps"