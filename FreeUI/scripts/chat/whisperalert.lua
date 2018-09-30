local F, C = unpack(select(2, ...))
if not C.chat.whisperAlert then return end

local ws = CreateFrame("Frame")
local wsFile = "Interface\\AddOns\\FreeUI\\assets\\sound\\whisper.ogg"
ws:RegisterEvent("CHAT_MSG_WHISPER")
ws:RegisterEvent("CHAT_MSG_BN_WHISPER")
ws:HookScript("OnEvent", function(self, event, msg, ...)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		PlaySoundFile(wsFile, "Master")
	end
end)