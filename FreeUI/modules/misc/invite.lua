local F, C, L = unpack(select(2, ...))
local MISC = F:GetModule('MISC')


local strlower = string.lower
local GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant = GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant
local CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected = CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local C_FriendList_IsFriend = C_FriendList.IsFriend
local InviteToGroup = C_PartyInfo.InviteUnit



local function CheckFriend(GUID)
	if C_BattleNet_GetAccountInfoByID(GUID) or C_FriendList_IsFriend(GUID) or IsGuildMember(GUID) then
		return true
	end
end

local function SkipInvitePopup()
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
end

function MISC:AutoAcceptInvite()
	if not C.DB.misc.accept_invite then return end
	if QueueStatusMinimapButton:IsShown() or GetNumGroupMembers() > 0 then return end

	F:RegisterEvent('PARTY_INVITE_REQUEST', function(name, _, _, _, _, _, _, GUID)
		if CheckFriend(GUID) then
			AcceptGroup()
			SkipInvitePopup()

			F.Print(format(L['MISC_ACCEPT_INVITE'], name))
		end
	end)
end

function MISC:AutoDeclineInvite()
	if not C.DB.misc.block_stranger_invite then return end

	F:RegisterEvent('PARTY_INVITE_REQUEST', function(name, _, _, _, _, _, _, GUID)
		DeclineGroup()
		SkipInvitePopup()

		F.Print(format(L['MISC_DECLINE_INVITE'], name))
	end)
end


local whisperList = {}
function MISC:UpdateWhisperList()
	F.SplitList(whisperList, C.DB.misc.invite_keyword, true)
end

function MISC:IsUnitInGuild(unitName)
	if not unitName then return end
	for i = 1, GetNumGuildMembers() do
		local name = GetGuildRosterInfo(i)
		if name and Ambiguate(name, 'none') == Ambiguate(unitName, 'none') then
			return true
		end
	end

	return false
end

function MISC.OnChatWhisper(event, ...)
	local msg, author, _, _, _, _, _, _, _, _, _, guid, presenceID = ...
	for word in pairs(whisperList) do
		if (not IsInGroup() or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and strlower(msg) == strlower(word) then
			if event == 'CHAT_MSG_BN_WHISPER' then
				local accountInfo = C_BattleNet_GetAccountInfoByID(presenceID)
				if accountInfo then
					local gameAccountInfo = accountInfo.gameAccountInfo
					local gameID = gameAccountInfo.gameAccountID
					if gameID then
						local charName = gameAccountInfo.characterName
						local realmName = gameAccountInfo.realmName
						if CanCooperateWithGameAccount(accountInfo) and (not C.DB.misc.invite_only_guild or MISC:IsUnitInGuild(charName..'-'..realmName)) then
							BNInviteFriend(gameID)
						end
					end
				end
			else
				if not C.DB.misc.invite_only_guild or IsGuildMember(guid) then
					InviteToGroup(author)
				end
			end
		end
	end
end

function MISC:WhisperInvite()
	if not C.DB.misc.invite_whisper then return end

	self:UpdateWhisperList()
	F:RegisterEvent('CHAT_MSG_WHISPER', MISC.OnChatWhisper)
	F:RegisterEvent('CHAT_MSG_BN_WHISPER', MISC.OnChatWhisper)
end








-- auto invite by whisper
local f = CreateFrame('Frame', UIParent)
f:RegisterEvent('CHAT_MSG_WHISPER')
f:RegisterEvent('CHAT_MSG_BN_WHISPER')

-- EVENT 返回值 1密語 2角色id 12guid 13戰網好友的角色id
f:SetScript('OnEvent',function(self, event, msg, name, _, _, _, _, _, _, _, _, _, _, presenceID)
	for _, word in pairs(FREE_ADB.group_invite_keywords) do
		if (not IsInGroup() or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and strlower(msg) == strlower(word) then
			if event == 'CHAT_MSG_BN_WHISPER' then
				local accountInfo = C_BattleNet_GetAccountInfoByID(presenceID)

				if accountInfo then
					local gameAccountInfo = accountInfo.gameAccountInfo
					local gameID = gameAccountInfo.gameAccountID

					if gameID then
						local charName = gameAccountInfo.characterName
						local realmName = gameAccountInfo.realmName

						if CanCooperateWithGameAccount(accountInfo) then
							BNInviteFriend(gameID)
						end
					end
				end
			else
				InviteToGroup(name)
			end
		end
	end

	for _, Gword in pairs(FREE_ADB.guild_invite_keywords) do
		if (not IsInGroup() or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and strlower(msg) == strlower(Gword) then
			if event == 'CHAT_MSG_BN_WHISPER' then
				local accountInfo = C_BattleNet_GetAccountInfoByID(presenceID)

				if accountInfo then
					local gameAccountInfo = accountInfo.gameAccountInfo
					local gameID = gameAccountInfo.gameAccountID

					if gameID then
						local charName = gameAccountInfo.characterName
						local realmName = gameAccountInfo.realmName

						if CanCooperateWithGameAccount(accountInfo) then
							local dialog = StaticPopup_Show('FREEUI_GUILD_INVITE', name)

							if (dialog) then
								dialog.data = charName..'-'..realmName
							end
						end
					end
				end
			else
				local dialog = StaticPopup_Show('FREEUI_GUILD_INVITE', name)

				if (dialog) then
					dialog.data = name
				end
			end
		end
	end
end)
