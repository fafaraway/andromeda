local F, C, L = unpack(select(2, ...))
local AUTOMATION, cfg = F:GetModule('Automation'), C.Automation


--[[ local function screenshot()
	AUTOMATION.ScreenShotFrame.delay = 1
	AUTOMATION.ScreenShotFrame:Show()
end

function AUTOMATION:Screenshot()
	if not AUTOMATION.ScreenShotFrame then
		AUTOMATION.ScreenShotFrame = CreateFrame('Frame')
		AUTOMATION.ScreenShotFrame:Hide()
		AUTOMATION.ScreenShotFrame:SetScript('OnUpdate', function(self, elapsed)
			self.delay = self.delay - elapsed
			if self.delay < 0 then
				Screenshot()
				self:Hide()
			end
		end)
	end

	if cfg.auto_screenshot then
		F:RegisterEvent('ACHIEVEMENT_EARNED', autoScreenshot)
		F:RegisterEvent('CHALLENGE_MODE_COMPLETED', autoScreenshot)
		-- F:RegisterEvent('UPDATE_BATTLEFIELD_STATUS', autoScreenshot)
	else
		AUTOMATION.ScreenShotFrame:Hide()
		F:UnregisterEvent('ACHIEVEMENT_EARNED', autoScreenshot)
		F:UnregisterEvent('CHALLENGE_MODE_COMPLETED', autoScreenshot)
		-- F:UnregisterEvent('UPDATE_BATTLEFIELD_STATUS', autoScreenshot)
	end
end ]]

function AUTOMATION:BuyStack()
	if not cfg.easy_buy_stack then return end

	local cache = {}
	local itemLink, id

	StaticPopupDialogs['BUY_STACK'] = {
		text = L['AUTOMATION_BUY_STACK'],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then return end
			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hideOnEscape = 1,
		hasItemFrame = 1,
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then return end
			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = GetItemQualityColor(quality or 1)
					StaticPopup_Show('BUY_STACK', ' ', ' ', {['texture'] = texture, ['name'] = name, ['color'] = {r, g, b, 1}, ['link'] = itemLink, ['index'] = id, ['count'] = maxStack})
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end

		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end


function AUTOMATION:AcceptInvite()
	local function CheckFriend(inviterGUID)
		if C_BattleNet.GetAccountInfoByGUID(inviterGUID) or C_FriendList.IsFriend(inviterGUID) or IsGuildMember(inviterGUID) then
			return true
		end
	end

	local f = CreateFrame("Frame")
	f:RegisterEvent("PARTY_INVITE_REQUEST")
	f:SetScript("OnEvent", function(_, _, name, _, _, _, _, _, inviterGUID)
		if QueueStatusMinimapButton:IsShown() or GetNumGroupMembers() > 0 then return end
		if CheckFriend(inviterGUID) then
			RaidNotice_AddMessage(RaidWarningFrame, L_INFO_INVITE..name, {r = 0.41, g = 0.8, b = 0.94}, 3)
			print(format("|cffffff00"..L_INFO_INVITE..name..".|r"))
			AcceptGroup()
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which == "PARTY_INVITE" then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				elseif frame:IsVisible() and frame.which == "PARTY_INVITE_XREALM" then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE_XREALM")
					return
				end
			end
		end
	end)
end

function AUTOMATION:InviteByKeyword()
	local f = CreateFrame("Frame")
	f:RegisterEvent("CHAT_MSG_WHISPER")
	f:RegisterEvent("CHAT_MSG_BN_WHISPER")
	f:SetScript("OnEvent", function(_, event, arg1, arg2, ...)
		if ((not UnitExists("party1") or UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and arg1:lower():match(C.automation.invite_keyword)) and SavedOptionsPerChar.AutoInvite == true and not QueueStatusMinimapButton:IsShown() then
			if event == "CHAT_MSG_WHISPER" then
				InviteUnit(arg2)
			elseif event == "CHAT_MSG_BN_WHISPER" then
				local bnetIDAccount = select(11, ...)
				local accountInfo = C_BattleNet.GetAccountInfoByID(bnetIDAccount)
				BNInviteFriend(accountInfo.gameAccountInfo.gameAccountID)
			end
		end
	end)

	SlashCmdList.AUTOINVITE = function(msg)
		if msg == "" then
			if SavedOptionsPerChar.AutoInvite == true then
				SavedOptionsPerChar.AutoInvite = false
				print("|cffffff00"..L_INVITE_DISABLE..".|r")
			else
				SavedOptionsPerChar.AutoInvite = true
				print("|cffffff00"..L_INVITE_ENABLE..C.automation.invite_keyword..".|r")
				C.automation.invite_keyword = C.automation.invite_keyword
			end
		else
			SavedOptionsPerChar.AutoInvite = true
			print("|cffffff00"..L_INVITE_ENABLE..msg..".|r")
			C.automation.invite_keyword = msg
		end
	end
	SLASH_AUTOINVITE1 = "/ainv"
end

function AUTOMATION:ConfirmRelease()
	-- Auto release the spirit in battlegrounds
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_DEAD")
	f:SetScript("OnEvent", function()
		local inBattlefield = false
		for i = 1, GetMaxBattlefieldID() do
			local status = GetBattlefieldStatus(i)
			if status == "active" then inBattlefield = true end
		end
		if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then return end
		local areaID = C_Map.GetBestMapForUnit("player") or 0
		if areaID == 123 or areaID == 244 or areaID == 588 or areaID == 622 or areaID == 624 or inBattlefield == true then
			RepopMe()
		end
	end)
end

function AUTOMATION:ConfirmResurrect()
	local AutoResurrect = CreateFrame("Frame")
	AutoResurrect:RegisterEvent("RESURRECT_REQUEST")
	AutoResurrect:SetScript("OnEvent", function(_, event, name)
		if event == "RESURRECT_REQUEST" then
			if not UnitAffectingCombat(name) then
				AcceptResurrect()
				StaticPopup_Hide("RESURRECT_NO_TIMER")

				C_Timer.After(2, function()
					DoEmote("thank", name)
				end)
			end
		end
	end)
end

function AUTOMATION:ConfirmSummon()
	local disable = false
	local AutoSummon = CreateFrame("Frame")
	AutoSummon:RegisterEvent("CONFIRM_SUMMON")
	AutoSummon:SetScript("OnEvent", function(_, event)
		if event == "CONFIRM_SUMMON" then
			if not UnitAffectingCombat("player") and PlayerCanTeleport() then
				StaticPopup_Show("CANCEL_SUMMON")
				C_Timer.After(10, function()
					if disable then return end
					if not UnitAffectingCombat("player") and PlayerCanTeleport() then
						C_SummonInfo.ConfirmSummon()
						StaticPopup_Hide("CONFIRM_SUMMON")
					end
				end)
			end
		end
	end)

	StaticPopupDialogs["CANCEL_SUMMON"] = {
		text = LFG_LIST_AUTO_ACCEPT.." ".. string.lower(SUMMONS);
		button1 = CANCEL,
		OnAccept = function(self)
			disable = true
		end,
		timeout = 12,
	}
end

function AUTOMATION:DeclineDuel()
	local disable = false
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("DUEL_REQUESTED")
	frame:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED")
	frame:SetScript("OnEvent", function(_, event, name)
		if disable == true then return end
		if event == "DUEL_REQUESTED" then
			CancelDuel()
			RaidNotice_AddMessage(RaidWarningFrame, L_INFO_DUEL..name, {r = 0.41, g = 0.8, b = 0.94}, 3)
			print(format("|cffffff00"..L_INFO_DUEL..name.."."))
			StaticPopup_Hide("DUEL_REQUESTED")
		elseif event == "PET_BATTLE_PVP_DUEL_REQUESTED" then
			C_PetBattles.CancelPVPDuel()
			RaidNotice_AddMessage(RaidWarningFrame, L_INFO_PET_DUEL..name, {r = 0.41, g = 0.8, b = 0.94}, 3)
			print(format("|cffffff00"..L_INFO_PET_DUEL..name.."."))
			StaticPopup_Hide("PET_BATTLE_PVP_DUEL_REQUESTED")
		end
	end)

	SlashCmdList.DISABLEDECLINE = function()
		if not disable then
			disable = true
		else
			disable = false
		end
	end
	SLASH_DISABLEDECLINE1 = "/disduel"
end

function AUTOMATION:LoggingInRaid()
	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function()
		local _, instanceType = IsInInstance()
		if instanceType == "raid" and IsInRaid(LE_PARTY_CATEGORY_HOME) then
			if not LoggingCombat() then
				LoggingCombat(1)
				print("|cffffff00"..COMBATLOGENABLED.."|r")
			end
		else
			if LoggingCombat() then
				LoggingCombat(0)
				print("|cffffff00"..COMBATLOGDISABLED.."|r")
			end
		end
	end)
end

function AUTOMATION:TakeScreenshot()
	local function OnEvent()
		C_Timer.After(1, function() Screenshot() end)
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("ACHIEVEMENT_EARNED")
	frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
	frame:SetScript("OnEvent", OnEvent)
end

function AUTOMATION:SetRole()
	local prev = 0
	local function SetRole()
		if T.level >= 10 and not InCombatLockdown() and IsInGroup() and not IsPartyLFG() then
			local spec = GetSpecialization()
			if spec then
				local role = GetSpecializationRole(spec)
				if UnitGroupRolesAssigned("player") ~= role then
					local t = GetTime()
					if t - prev > 2 then
						prev = t
						UnitSetRole("player", role)
					end
				end
			else
				UnitSetRole("player", "No Role")
			end
		end
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	frame:SetScript("OnEvent", SetRole)

	RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")
end




local AUTOMATION_LIST = {}
function AUTOMATION:RegisterAutomation(name, func)
	if not AUTOMATION_LIST[name] then
		AUTOMATION_LIST[name] = func
	end
end

function AUTOMATION:OnLogin()
	if not cfg.enable then return end
	
	for name, func in next, AUTOMATION_LIST do
		if name and type(func) == 'function' then
			func()
		end
	end


	self:BuyStack()
	self:TakeScreenshot()

end