local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('CHAT')


local lastSoundTimer = 0
function CHAT:WhisperAlert()
	if not FreeDB.chat.whisper_sound then return end

	local f = CreateFrame('Frame')
	f:RegisterEvent('CHAT_MSG_WHISPER')
	f:RegisterEvent('CHAT_MSG_BN_WHISPER')
	f:HookScript('OnEvent', function(self, event, msg, ...)
		local currentTime = GetServerTime()
		if currentTime and currentTime - lastSoundTimer > FreeDB.chat.sound_timer then
			lastSoundTimer = currentTime
			if event == 'CHAT_MSG_WHISPER' then
				PlaySoundFile(C.Assets.Sounds.whisper, 'Master')
			elseif event == 'CHAT_MSG_BN_WHISPER' then
				PlaySoundFile(C.Assets.Sounds.whisperBN, 'Master')
			end
		end
	end)
end

function CHAT:WhisperSticky()
	if FreeDB.chat.whisper_sticky then
		ChatTypeInfo['WHISPER'].sticky = 1
		ChatTypeInfo['BN_WHISPER'].sticky = 1
	else
		ChatTypeInfo['WHISPER'].sticky = 0
		ChatTypeInfo['BN_WHISPER'].sticky = 0
	end
end
