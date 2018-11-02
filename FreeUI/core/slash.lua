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

SlashCmdList["INSTANCEID"] = function()
	local name, _, _, _, _, _, _, id = GetInstanceInfo()
	print(name, id)
end
SLASH_INSTANCEID1 = "/getid"

SlashCmdList["NPCID"] = function()
	local name = UnitName("target")
	local guid = UnitGUID("target")
		if name and guid then
		local npcID = F.GetNPCID(guid)
		print(name, C.infoColor..(npcID or "nil"))
	end
end
SLASH_NPCID1 = "/getnpc"

SlashCmdList["GETFONT"] = function(msg)
	local font = _G[msg]
	if not font then print(msg, "not found.") return end
	local a, b, c = font:GetFont()
	print(msg,a,b,c)
end
SLASH_GETFONT1 = "/getfont"

SlashCmdList["LEAVEPARTY"] = function()
	LeaveParty();
end
SLASH_LEAVEPARTY1 = "/lg"