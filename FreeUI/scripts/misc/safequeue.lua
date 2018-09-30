
-- SafeQueue by Jordon

local SafeQueue = CreateFrame("Frame")
local queueTime
local queue = 0
local remaining = 0
SafeQueueDB = SafeQueueDB or { announce = "self" }

PVPReadyDialog.leaveButton:Hide()
PVPReadyDialog.leaveButton.Show = function() end -- Prevent other mods from showing the button
PVPReadyDialog.enterButton:ClearAllPoints()
PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)
PVPReadyDialog.label:SetPoint("TOP", 0, -22)

local function Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SafeQueue|r: " .. msg)
end

local function PrintTime()
	local announce = SafeQueueDB.announce
	if announce == "off" then return end
	local secs, str, mins = floor(GetTime() - queueTime), "Queue popped "
	if secs < 1 then
		str = str .. "instantly!"
	else
		str = str .. "after "
		if secs >= 60 then
			mins = floor(secs/60)
			str = str .. mins .. "m "
			secs = secs%60
		end
		if secs%60 ~= 0 then
			str = str .. secs .. "s"
		end
	end
	if announce == "self" or not IsInGroup() then
		Print(str)
	else
		local group = IsInRaid() and "RAID" or "PARTY"
		SendChatMessage(str, group)
	end
end

SafeQueue:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
SafeQueue:SetScript("OnEvent", function()
	local queued
	for i=1, GetMaxBattlefieldID() do
		local status = GetBattlefieldStatus(i)
		if status == "queued" then
			queued = true
			if not queueTime then queueTime = GetTime() end
		elseif status == "confirm" then
			if queueTime then
				PrintTime()
				queueTime = nil
				remaining = 0
				queue = i
			end					
		end
		break
	end
	if not queued and queueTime then queueTime = nil end
end)

SafeQueue:SetScript("OnUpdate", function(self)
	if PVPReadyDialog_Showing(queue) then
		local secs = GetBattlefieldPortExpiration(queue)
		if secs and secs > 0 and remaining ~= secs then
			remaining = secs
			local color = secs > 20 and "f20ff20" or secs > 10 and "fffff00" or "fff0000"
			PVPReadyDialog.label:SetText("Expires in |cf"..color.. SecondsToTime(secs) .. "|r")
		end
	end
end)

SlashCmdList.SafeQueue = function(msg)
	msg = msg or ""
	local cmd, arg = string.split(" ", msg, 2)
	cmd = string.lower(cmd or "")
	arg = string.lower(arg or "")
	if cmd == "announce" then
		if arg == "off" or arg == "self" or arg == "group" then
			SafeQueueDB.announce = arg
			Print("Announce set to " .. arg)
		else
			Print("Announce set to " .. SafeQueueDB.announce)
			Print("Announce types are \"off\", \"self\", and \"group\"")
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SafeQueue v2.6|r")
		Print("/sq announce : " .. SafeQueueDB.announce)
	end
end
SLASH_SafeQueue1 = "/safequeue"
SLASH_SafeQueue2 = "/sq"
