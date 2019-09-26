local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')


local soundFile_Normal = C.AssetsPath..'sound\\whisper_normal.ogg'
local soundFile_BN = C.AssetsPath..'sound\\whisper_bn.ogg'
local lastSoundTimer = 0

function CHAT:WhisperAlert()
	if not C.chat.whisperAlert then return end

	local f = CreateFrame('Frame')
	f:RegisterEvent('CHAT_MSG_WHISPER')
	f:RegisterEvent('CHAT_MSG_BN_WHISPER')
	f:HookScript('OnEvent', function(self, event, msg, ...)
		local currentTime = GetServerTime()
		if currentTime and currentTime - lastSoundTimer > C.chat.lastAlertTimer then
			lastSoundTimer = currentTime
			if event == 'CHAT_MSG_WHISPER' then
				PlaySoundFile(soundFile_Normal, 'Master')
			elseif event == 'CHAT_MSG_BN_WHISPER' then
				PlaySoundFile(soundFile_BN, 'Master')
			end
		end
	end)
end

function CHAT:WhisperTarget()
	hooksecurefunc('ChatEdit_OnSpacePressed', function(self)
		if(string.sub(self:GetText(), 1, 3) == '/tt' and (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target'))) then
			self:SetText(SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
			ChatEdit_ParseText(self, 0)
		end
	end)

	SLASH_WHISPERTARGET1 = '/tt'
	SlashCmdList.WHISPERTARGET = function(str)
		if(UnitCanCooperate('player', 'target')) then
			SendChatMessage(str, 'WHISPER', GetDefaultLanguage('player'), GetUnitName('target', true):gsub(' ', ''))
		end
	end
end

function CHAT:WhisperSticky()
	if C.chat.whisperSticky then
		ChatTypeInfo['WHISPER'].sticky = 1
		ChatTypeInfo['BN_WHISPER'].sticky = 1
	else
		ChatTypeInfo['WHISPER'].sticky = 0
		ChatTypeInfo['BN_WHISPER'].sticky = 0
	end
end