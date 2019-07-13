local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

function CHAT:WhisperSound()
	if not C.chat.whisperSound then return end

	local soundFile_Normal = C.AssetsPath..'sound\\whisper_normal.ogg'
	local soundFile_BN = C.AssetsPath..'sound\\whisper_bn.ogg'
	local lastSoundTimer = 0

	local f = CreateFrame('Frame')
	f:RegisterEvent('CHAT_MSG_WHISPER')
	f:RegisterEvent('CHAT_MSG_BN_WHISPER')
	f:HookScript('OnEvent', function(self, event, msg, ...)
		local currentTime = GetServerTime()
		if currentTime and currentTime - lastSoundTimer > 30 then
			lastSoundTimer = currentTime
			if event == 'CHAT_MSG_WHISPER' then
				PlaySoundFile(soundFile_Normal, 'Master')
			elseif event == 'CHAT_MSG_BN_WHISPER' then
				PlaySoundFile(soundFile_BN, 'Master')
			end
		end 
	end)
end