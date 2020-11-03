local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('INFOBAR')

-- #TODO
local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
local clientLevelNameString = "|cffffffff%s|r (|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r%s) |cff%02x%02x%02x%s|r"
local levelNameClassString = "|cff%02x%02x%02x%d|r %s%s%s"
local worldOfWarcraftString = "World of Warcraft"
local battleNetString = "Battle.NET"
local wowString = "WoW"
local tthead, ttsubh, ttoff = {r = 0.4, g = 0.78, b = 1}, {r = 0.75, g = 0.9, b = 1}, {r = .3, g = 1, b = .3}
local activezone, inactivezone = {r = 0.3, g = 1.0, b = 0.3}, {r = 0.65, g = 0.65, b = 0.65}
local statusTable = { "|cffff0000[AFK]|r", "|cffff0000[DND]|r", "" }
local groupedTable = { "|cffaaaaaa*|r", "" }
local BNTable = {}
local BNTotalOnline = 0
local BNGetGameAccountInfo = BNGetGameAccountInfo
local GetFriendInfo = GetFriendInfo
local BNGetFriendInfo = BNGetFriendInfo

local function GetTableIndex(table, fieldIndex, value)
	for k, v in ipairs(table) do
		if v[fieldIndex] == value then
			return k
		end
	end

	return -1
end

local function RemoveTagNumber(tag)
	local symbol = string.find(tag, "#")

	if (symbol) then
		return string.sub(tag, 1, symbol - 1)
	else
		return tag
	end
end

local function inviteClick(self, arg1, arg2, checked)
	menuFrame:Hide()

	if type(arg1) ~= ("number") then
		InviteUnit(arg1)
	else
		BNInviteFriend(arg1);
	end
end

local function whisperClick(self, name, bnet)
	menuFrame:Hide()

	if bnet then
		ChatFrame_SendBNetTell(name)
	else
		SetItemRef("player:"..name, format("|Hplayer:%1$s|h[%1$s]|h",name), "LeftButton")
	end
end

local function BuildBNTable(total)
	BNTotalOnline = 0
	wipe(BNTable)

	for i = 1, total do
		local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
		if accountInfo then
			local class = accountInfo.gameAccountInfo.className

			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if class == v then
					class = k
				end
			end

			BNTable[i] = { accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, accountInfo.gameAccountInfo.characterName, accountInfo.gameAccountInfo.gameAccountID, accountInfo.gameAccountInfo.clientProgram, accountInfo.gameAccountInfo.isOnline, accountInfo.isAFK, accountInfo.isDND, accountInfo.note, accountInfo.gameAccountInfo.realmName, accountInfo.gameAccountInfo.factionName, accountInfo.gameAccountInfo.raceName, class, accountInfo.gameAccountInfo.areaName, accountInfo.gameAccountInfo.characterLevel }

			if accountInfo.gameAccountInfo.isOnline then
				BNTotalOnline = BNTotalOnline + 1
			end
		end
	end
end

local function UpdateBNTable(total)
	BNTotalOnline = 0

	for i = 1, #BNTable do
		local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
		if accountInfo then
			-- get the correct index in our table
			local index = GetTableIndex(BNTable, 1, accountInfo.bnetAccountID)
			local class = accountInfo.gameAccountInfo.className

			-- we cannot find a BN member in our table, so rebuild it
			if index == -1 then
				BuildBNTable(total)
				return
			end

			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if class == v then
					class = k
				end
			end

			-- update on-line status for all members
			BNTable[index][7] = accountInfo.gameAccountInfo.isOnline

			-- update information only for on-line members
			if accountInfo.gameAccountInfo.isOnline then
				BNTable[index][2] = accountInfo.accountName
				BNTable[index][3] = accountInfo.battleTag
				BNTable[index][4] = accountInfo.gameAccountInfo.characterName
				BNTable[index][5] = accountInfo.gameAccountInfo.gameAccountID
				BNTable[index][6] = accountInfo.gameAccountInfo.clientProgram
				BNTable[index][8] = accountInfo.isAFK
				BNTable[index][9] = accountInfo.isDND
				BNTable[index][10] = accountInfo.note
				BNTable[index][11] = accountInfo.gameAccountInfo.realmName
				BNTable[index][12] = accountInfo.gameAccountInfo.factionName
				BNTable[index][13] = accountInfo.gameAccountInfo.raceName
				BNTable[index][14] = class
				BNTable[index][15] = accountInfo.gameAccountInfo.areaName
				BNTable[index][16] = accountInfo.gameAccountInfo.characterLevel
				BNTable[index][17] = accountInfo.isBattleTagFriend

				BNTotalOnline = BNTotalOnline + 1
			end
		end
	end
end


function INFOBAR:Friends()
	if not C.DB.infobar.friends then return end

	FreeUIFriendsButton = INFOBAR:addButton('', INFOBAR.POSITION_RIGHT, 100, function(self, button)
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.InfoColor..ERR_NOT_IN_COMBAT) return end

		if button == 'LeftButton' then
			ToggleFriendsFrame()
		elseif button == 'RightButton' then
			StaticPopupSpecial_Show(AddFriendFrame)
			AddFriendFrame_ShowEntry()
		end
	end)

	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
	FreeUIFriendsButton:RegisterEvent("FRIENDLIST_UPDATE")
	FreeUIFriendsButton:RegisterEvent("PLAYER_ENTERING_WORLD")
	FreeUIFriendsButton:RegisterEvent("IGNORELIST_UPDATE")
	FreeUIFriendsButton:RegisterEvent("MUTELIST_UPDATE")
	FreeUIFriendsButton:RegisterEvent("PLAYER_FLAGS_CHANGED")
	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_LIST_SIZE_CHANGED")
	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_INVITE_LIST_INITIALIZED")
	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_INVITE_ADDED")
	FreeUIFriendsButton:RegisterEvent("BN_FRIEND_INVITE_REMOVED")
	FreeUIFriendsButton:RegisterEvent("BN_BLOCK_LIST_UPDATED")
	FreeUIFriendsButton:RegisterEvent("BN_CONNECTED")
	FreeUIFriendsButton:RegisterEvent("BN_DISCONNECTED")
	FreeUIFriendsButton:RegisterEvent("BN_INFO_CHANGED")
	FreeUIFriendsButton:RegisterEvent("BATTLETAG_INVITE_SHOW")
	FreeUIFriendsButton:SetScript('OnEvent', function(self, event)
		if not BNConnected() then
			self.Text:SetText(format('%s: '..C.InfoColor..'%d', L['INFOBAR_FRIENDS'], NOT_APPLICABLE))
			return
		end

		local BNTotal = BNGetNumFriends()
		local Total = C_FriendList.GetNumFriends()

		if BNTotal == #BNTable then
			UpdateBNTable(BNTotal)
		else
			BuildBNTable(BNTotal)
		end

		local onlineFriends = C_FriendList.GetNumOnlineFriends()
		local _, onlineBNet = BNGetNumFriends()
		self.Text:SetText(format('%s: '..C.InfoColor..'%d', L['INFOBAR_FRIENDS'], BNTotalOnline))

	end)

	FreeUIFriendsButton:HookScript('OnEnter', function(self)
		if InCombatLockdown() then
			return
		end

		if not BNConnected() then
			GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -15) or 15)
			GameTooltip:ClearLines()
			GameTooltip:AddLine(BN_CHAT_DISCONNECTED)
			GameTooltip:Show()

			return
		end

		local totalonline = BNTotalOnline
		local zonec, classc, levelc, realmc, grouped

		if (totalonline > 0) then
			GameTooltip:SetOwner(self, (C.DB.infobar.anchor_top and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (C.DB.infobar.anchor_top and -15) or 15)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(FRIENDS_LIST, format('%s: %s/%s', GUILD_ONLINE_LABEL, totalonline, #BNTable), .9, .8, .6, 1, 1, 1)
			GameTooltip:AddLine(" ")

			if BNTotalOnline > 0 then
				local status = 0

				for i = 1, #BNTable do
					local BNName = RemoveTagNumber(BNTable[i][3])

					if BNTable[i][7] then
						if BNTable[i][6] == wowString then
							local isBattleTag = BNTable[i][17]

							if (BNTable[i][8] == true) then
								status = 1
							elseif (BNTable[i][9] == true) then
								status = 2
							else
								status = 3
							end

							classc = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[BNTable[i][14]]
							levelc = GetQuestDifficultyColor(BNTable[i][16])

							if not classc then
								classc = {r=1, g=1, b=1}
							end

							if UnitInParty(BNTable[i][4]) or UnitInRaid(BNTable[i][4]) then
								grouped = 1
							else
								grouped = 2
							end

							GameTooltip:AddDoubleLine(format(clientLevelNameString, BNName,levelc.r*255,levelc.g*255,levelc.b*255,BNTable[i][16],classc.r*255,classc.g*255,classc.b*255,BNTable[i][4],groupedTable[grouped], 255, 0, 0, statusTable[status]), "World of Warcraft")

							if IsShiftKeyDown() then
								if GetRealZoneText() == BNTable[i][15] then
									zonec = activezone
								else
									zonec = inactivezone
								end

								if GetRealmName() == BNTable[i][11] then
									realmc = activezone
								else
									realmc = inactivezone
								end

								GameTooltip:AddDoubleLine("  "..BNTable[i][15], BNTable[i][11], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
							end
						end

						if BNTable[i][6] == "BSAp" or BNTable[i][6] == "App" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Battle.net")
						end

						if BNTable[i][6] == "D3" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Diablo 3")
						end

						if BNTable[i][6] == "Hero" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Heroes of the Storm")
						end

						if BNTable[i][6] == "S1" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "StarCraft: Remastered")
						end

						if BNTable[i][6] == "S2" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "StarCraft 2")
						end

						if BNTable[i][6] == "WTCG" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Hearthstone")
						end

						if BNTable[i][6] == "Pro" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Overwatch")
						end

						if BNTable[i][6] == "DST2" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Destiny 2")
						end

						if BNTable[i][6] == "VIPR" then
							GameTooltip:AddDoubleLine("|cffeeeeee"..BNName.."|r", "Call of Duty: Black Ops 4")
						end
					end
				end
			end
		end

		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left..L['INFOBAR_OPEN_FRIENDS_PANEL'], 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right..L['INFOBAR_ADD_FRIEND'], 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	FreeUIFriendsButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end



