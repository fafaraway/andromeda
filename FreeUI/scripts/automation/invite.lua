local F, C, L = unpack(select(2, ...))


if C.automation.autoAcceptInvite then
	local CheckFriend = function(name)
		for i = 1, GetNumFriends() do
			if GetFriendInfo(i) == name then
				return true
			end
		end
		for i = 1, select(2, BNGetNumFriends()) do
			local presenceID, _, _, _, _, toonID, client, isOnline = BNGetFriendInfo(i)
			if client == BNET_CLIENT_WOW and isOnline then
				local _, toonName, _, realmName = BNGetGameAccountInfo(toonID or presenceID)
				if name == toonName or name == toonName..'-'..realmName then
					return true
				end
			end
		end
		if IsInGuild() then
			for i = 1, GetNumGuildMembers() do
				if Ambiguate(GetGuildRosterInfo(i), 'none') == name then
					return true
				end
			end
		end
	end

	local ai = CreateFrame('Frame')
	ai:RegisterEvent('PARTY_INVITE_REQUEST')
	ai:SetScript('OnEvent', function(self, event, name)
		if QueueStatusMinimapButton:IsShown() or GetNumGroupMembers() > 0 then return end
		if CheckFriend(name) then
			RaidNotice_AddMessage(RaidWarningFrame, L['InviteInfo']..': '..name, {r = 0.41, g = 0.8, b = 0.94}, 3)
			print(format('|cffffff00'..L['InviteInfo']..': '..name..'.|r'))
			AcceptGroup()
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local frame = _G['StaticPopup'..i]
				if frame:IsVisible() and frame.which == 'PARTY_INVITE' then
					frame.inviteAccepted = 1
					StaticPopup_Hide('PARTY_INVITE')
					return
				elseif frame:IsVisible() and frame.which == 'PARTY_INVITE_XREALM' then
					frame.inviteAccepted = 1
					StaticPopup_Hide('PARTY_INVITE_XREALM')
					return
				end
			end
		else
			SendWho(name)
		end
	end)
end


local autoinvite = CreateFrame('Frame')
autoinvite:RegisterEvent('CHAT_MSG_WHISPER')
autoinvite:RegisterEvent('CHAT_MSG_BN_WHISPER')
autoinvite:SetScript('OnEvent', function(self, event, arg1, arg2, ...)
	if ((not UnitExists('party1') or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and arg1:lower():match(C.automation.autoInvite_keyword)) and SavedOptionsPerChar.AutoInvite == true and not QueueStatusMinimapButton:IsShown() then
		if event == 'CHAT_MSG_WHISPER' then
			InviteUnit(arg2)
		elseif event == 'CHAT_MSG_BN_WHISPER' then
			local bnetIDAccount = select(11, ...)
			local bnetIDGameAccount = select(6, BNGetFriendInfoByID(bnetIDAccount))
			BNInviteFriend(bnetIDGameAccount)
		end
	end
end)

SlashCmdList.AUTOINVITE = function(msg)
	if msg == 'off' then
		C.automation.autoInvite = false
		print('|cffffff00'..L['InviteDisable']..'.|r')
	elseif msg == '' then
		C.automation.autoInvite = true
		print('|cffffff00'..L['InviteEnable']..': '..C.automation.autoInvite_keyword..'.|r')
		C.automation.autoInvite_keyword = C.automation.autoInvite_keyword
	else
		C.automation.autoInvite = true
		print('|cffffff00'..L['InviteEnable']..': '..msg..'.|r')
		C.automation.autoInvite_keyword = msg
	end
end
SLASH_AUTOINVITE1 = '/ainv'
