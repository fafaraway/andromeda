local F, C, L = unpack(select(2, ...))

local module = F:GetModule('Infobar')



function module:Friends()
	if not C.infobar.friends then return end

	local friendTable, bnetTable, updateRequest = {}, {}
	local wowString, bnetString = L['INFOBAR_WOW'], L['INFOBAR_BN']
	local activeZone, inactiveZone = {r=.3, g=1, b=.3}, {r=.7, g=.7, b=.7}
	local AFKTex = '|T'..FRIENDS_TEXTURE_AFK..':14:14:0:0:16:16:1:15:1:15|t'
	local DNDTex = '|T'..FRIENDS_TEXTURE_DND..':14:14:0:0:16:16:1:15:1:15|t'

	local function buildFriendTable(num)
		wipe(friendTable)

		for i = 1, num do
			local info = C_FriendList.GetFriendInfoByIndex(i)
			if info and info.connected then
				local status = ''
				if info.afk then
					status = AFKTex
				elseif info.dnd then
					status = DNDTex
				end
				local class = C.ClassList[info.className]
				friendTable[i] = {info.name, info.level, class, info.area, info.connected, status}
			end
		end

		sort(friendTable, function(a, b)
			if a[1] and b[1] then
				return a[1] < b[1]
			end
		end)
	end

	local function buildBNetTable(num)
		wipe(bnetTable)

		for i = 1, num do
			local bnetID, accountName, battleTag, isBattleTagPresence, charName, gameID, client, isOnline, _, isAFK, isDND = BNGetFriendInfo(i)

			if isOnline then
				local _, _, _, realmName, _, _, _, class, _, zoneName, _, gameText, _, _, _, _, _, isGameAFK, isGameBusy = BNGetGameAccountInfo(gameID)

				charName = BNet_GetValidatedCharacterName(charName, battleTag, client)
				class = C.ClassList[class]
				accountName = isBattleTagPresence and battleTag or accountName

				local status, infoText = ''
				if isAFK or isGameAFK then
					status = AFKTex
				elseif isDND or isGameBusy then
					status = DNDTex
				else
					status = ''
				end
				if client == BNET_CLIENT_WOW then
					if not zoneName or zoneName == '' then
						infoText = UNKNOWN
					else
						infoText = zoneName
					end
				else
					infoText = gameText
				end

				bnetTable[i] = {bnetID, accountName, charName, gameID, client, isOnline, status, realmName, class, infoText}
			end
		end

		sort(bnetTable, function(a, b)
			if a[5] and b[5] then
				return a[5] > b[5]
			end
		end)
	end

	local FreeUIFriendsButton = module.FreeUIFriendsButton

	FreeUIFriendsButton = module:addButton('', module.POSITION_RIGHT, 120, function(self, button)
		if button == 'LeftButton' then
			ToggleFriendsFrame()
		elseif button == 'RightButton' then
			StaticPopupSpecial_Show(AddFriendFrame)
			AddFriendFrame_ShowEntry()
		end
	end)

	FreeUIFriendsButton:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
	FreeUIFriendsButton:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
	FreeUIFriendsButton:RegisterEvent('BN_FRIEND_INFO_CHANGED')
	FreeUIFriendsButton:RegisterEvent('FRIENDLIST_UPDATE')
	FreeUIFriendsButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIFriendsButton:RegisterEvent('CHAT_MSG_SYSTEM')
	FreeUIFriendsButton:SetScript('OnEvent', function(self, event, arg1)
		if event == 'CHAT_MSG_SYSTEM' then
			if not string.find(arg1, ERR_FRIEND_ONLINE_SS) and not string.find(arg1, ERR_FRIEND_OFFLINE_S) then return end
		elseif event == 'MODIFIER_STATE_CHANGED' and arg1 == 'LSHIFT' then
			self:GetScript('OnEnter')(self)
		end

		local onlineFriends = C_FriendList.GetNumOnlineFriends()
		local _, onlineBNet = BNGetNumFriends()
		self.Text:SetText(format('%s: '..C.InfoColor..'%d', 'Friends', onlineFriends + onlineBNet))
		updateRequest = false
	end)

	FreeUIFriendsButton:HookScript('OnEnter', function(self)
		local numFriends, onlineFriends = C_FriendList.GetNumFriends(), C_FriendList.GetNumOnlineFriends()
		local numBNet, onlineBNet = BNGetNumFriends()
		local totalOnline = onlineFriends + onlineBNet
		local totalFriends = numFriends + numBNet

		if not updateRequest then
			if numFriends > 0 then buildFriendTable(numFriends) end
			if numBNet > 0 then buildBNetTable(numBNet) end
			updateRequest = true
		end

		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -15)
		GameTooltip:ClearLines()
		GameTooltip:AddDoubleLine(FRIENDS_LIST, format('%s: %s/%s', GUILD_ONLINE_LABEL, totalOnline, totalFriends), .9, .8, .6, 1, 1, 1)

		if totalOnline == 0 then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(L['INFOBAR_NO_ONLINE'], 1,1,1)
		else
			if onlineFriends > 0 then
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(wowString, 0,.6,1)
				for i = 1, #friendTable do
					local name, level, class, area, connected, status = unpack(friendTable[i])
					if connected then
						local zoneColor = GetRealZoneText() == area and activeZone or inactiveZone
						local levelColor = F.HexRGB(GetQuestDifficultyColor(level))
						local classColor = C.ClassColors[class] or levelColor
						GameTooltip:AddDoubleLine(levelColor..level..'|r '..name..status, area, classColor.r, classColor.g, classColor.b, zoneColor.r, zoneColor.g, zoneColor.b)
					end
				end
			end

			if onlineBNet > 0 then
				GameTooltip:AddLine(' ')
				GameTooltip:AddLine(bnetString, 0,.6,1)
				for i = 1, #bnetTable do
					local _, accountName, charName, gameID, client, isOnline, status, realmName, class, infoText = unpack(bnetTable[i])

					if isOnline then
						local zoneColor, realmColor = inactiveZone, inactiveZone
						local name = FRIENDS_OTHER_NAME_COLOR_CODE..' ('..charName..')'

						if client == BNET_CLIENT_WOW then
							if CanCooperateWithGameAccount(gameID) then
								local color = C.ClassColors[class] or GetQuestDifficultyColor(1)
								name = F.HexRGB(color)..' '..charName
							end
							zoneColor = GetRealZoneText() == infoText and activeZone or inactiveZone
							realmColor = C.Realm == realmName and activeZone or inactiveZone
						end

						local cicon = BNet_GetClientEmbeddedTexture(client, 14, 14, 0, -1)
						GameTooltip:AddDoubleLine(cicon..name..status, accountName, 1,1,1, .6,.8,1)
						if IsShiftKeyDown() then
							GameTooltip:AddDoubleLine(infoText, realmName, zoneColor.r, zoneColor.g, zoneColor.b, realmColor.r, realmColor.g, realmColor.b)
						end
					end
				end
			end
		end
		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', L['INFOBAR_HOLD_SHIFT'], 1,1,1, .6,.8,1)
		GameTooltip:AddDoubleLine(' ', C.LeftButton..L['INFOBAR_OPEN_FRIENDS_PANEL'], 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.RightButton..L['INFOBAR_ADD_FRIEND'], 1,1,1, .9, .8, .6)
		GameTooltip:Show()

		self:RegisterEvent('MODIFIER_STATE_CHANGED')
	end)

	FreeUIFriendsButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
		self:UnregisterEvent('MODIFIER_STATE_CHANGED')
	end)
end



