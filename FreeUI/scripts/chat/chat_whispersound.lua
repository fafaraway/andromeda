local F, C, L = unpack(select(2, ...))

local WhisperSounds = CreateFrame("Frame")
local WhisperSoundsFile = "Interface\\AddOns\\FreeUI\\assets\\sound\\whisper.ogg"
local WhisperSoundseventHandlers = {}
local chatSoundTimer = 0

local function WhisperSoundsChatMessageSoundsWhispers()
	local currentTime = GetServerTime()
	if currentTime and currentTime - chatSoundTimer > 10 then
		chatSoundTimer = currentTime
		PlaySoundFile(WhisperSoundsFile, "Master")
	end
end

local function WhisperSounds_eventHandler(self,event,...)
	return WhisperSoundseventHandlers[event](...)
end

function WhisperSoundseventHandlers.CHAT_MSG_BN_WHISPER()
	WhisperSoundsChatMessageSoundsWhispers()
end

function WhisperSoundseventHandlers.CHAT_MSG_WHISPER()
	WhisperSoundsChatMessageSoundsWhispers()
end

WhisperSounds:RegisterEvent("CHAT_MSG_BN_WHISPER")
WhisperSounds:RegisterEvent("CHAT_MSG_WHISPER")
WhisperSounds:SetScript("OnEvent", WhisperSounds_eventHandler)
