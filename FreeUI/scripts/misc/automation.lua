local F, C, L = unpack(select(2, ...))
local module = F:GetModule("misc")





-- Auto repair
local isShown, isBankEmpty

local function autoRepair(override)
	if isShown and not override then return end
	isShown = true
	isBankEmpty = false

	local repairAllCost, canRepair = GetRepairAllCost()
	local myMoney = GetMoney()

	if canRepair and repairAllCost > 0 then
		if (not override) and IsInGuild() and CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairAllCost then
			RepairAllItems(true)
		else
			if myMoney > repairAllCost then
				RepairAllItems()
				print(format(C.infoColor.."%s:|r %s", L["repairCost"], GetMoneyString(repairAllCost)))
				return
			else
				print(C.infoColor..L["repairError"])
				return
			end
		end

		C_Timer.After(.5, function()
			if isBankEmpty then
				autoRepair(true)
			else
				print(format(C.infoColor.."%s:|r %s", L["guildRepair"], GetMoneyString(repairAllCost)))
			end
		end)
	end
end

local function checkBankFund(_, msgType)
	if msgType == LE_GAME_ERR_GUILD_NOT_ENOUGH_MONEY then
		isBankEmpty = true
	end
end

local function merchantClose()
	isShown = false
	F:UnregisterEvent("UI_ERROR_MESSAGE", checkBankFund)
	F:UnregisterEvent("MERCHANT_CLOSED", merchantClose)
end

local function merchantShow()
	if IsShiftKeyDown() or not CanMerchantRepair() then return end
	autoRepair()
	F:RegisterEvent("UI_ERROR_MESSAGE", checkBankFund)
	F:RegisterEvent("MERCHANT_CLOSED", merchantClose)
end
F:RegisterEvent("MERCHANT_SHOW", merchantShow)




-- auto accept invites from friends and guildies

local playerRealm = C.myRealm

local IsFriend = function(name)
	for i = 1, GetNumFriends() do
		if GetFriendInfo(i) == name then return true end
	end

	if IsInGuild() then
		for i = 1, GetNumGuildMembers() do
			if Ambiguate(GetGuildRosterInfo(i), "guild") == name then return true end
		end
	end


	for i = 1, select(2, BNGetNumFriends()) do
		local presenceID, _, _, _, toonName, _, client = BNGetFriendInfo(i)
		if client == "WoW" then
			local _, _, _, realmName = BNGetGameAccountInfo(presenceID)

			if realmName == playerRealm and toonName == name then
				return true
			elseif name:find("-") then
				local invName, invRealm = strsplit("-", name)
				if realmName == invRealm and toonName == invName then
					return true
				end
			end
		end
	end
end

local function onInvite(event, name)
	if QueueStatusMinimapButton:IsShown() then return end
	if IsFriend(name) then
		AcceptGroup()
		for i = 1, 4 do
			local frame = _G["StaticPopup"..i]
			if frame:IsVisible() and frame.which == "PARTY_INVITE" or frame.which == "PARTY_INVITE_XREALM" then
				frame.inviteAccepted = 1
				return StaticPopup_Hide(frame.which)
			end
		end
	end
end

if C.misc.autoAccept then F:RegisterEvent("PARTY_INVITE_REQUEST", onInvite) end



-- Auto screenshot when achieved
do
	local waitTable = {}
	local function TakeScreen(delay, func, ...)
		wipe(waitTable)
		local waitFrame = _G["TakeScreenWaitFrame"] or CreateFrame("Frame", "TakeScreenWaitFrame", UIParent)
		waitFrame:SetScript("OnUpdate", function(_, elapse)
			local count = #waitTable
			local i = 1
			while (i <= count) do
				local waitRecord = tremove(waitTable, i)
				local d = tremove(waitRecord, 1)
				local f = tremove(waitRecord, 1)
				local p = tremove(waitRecord, 1)
				if (d > elapse) then
					tinsert(waitTable, i, {d-elapse, f, p})
					i = i + 1
				else
					count = count - 1
					f(unpack(p))
				end
			end
		end)

		tinsert(waitTable, {delay, func, {...}})
	end

	local function autoScreenShot(event)
		if not C.misc.autoScreenShot then
			F:UnregisterEvent(event, autoScreenShot)
		else
			TakeScreen(1, Screenshot)
		end
	end

	F:RegisterEvent("ACHIEVEMENT_EARNED", autoScreenShot)
end



-- auto set role
local useSpec = C.misc.autoSetRole_useSpec
local verbose = C.misc.autoSetRole_verbose

local _, class = UnitClass("Player")
local isPureClass
if class == "HUNTER" or class == "MAGE" or class == "ROGUE" or class == "WARLOCK" then
	isPureClass = true
end

local lastMsgTime = 0
local function Print(msg)
	if time() - lastMsgTime > 10 then
		lastMsgTime = time()
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffff"..msg, C.r, C.g, C.b)
	end
end

local function setRoleForSpec(self)
	local spec = GetSpecialization()
	if spec then
		UnitSetRole("player", select(6, GetSpecializationInfo(spec)))
		if verbose then
			Print("Role check: Setting role based on current spec.")
		end
	else
		RolePollPopup_Show(self)
		if verbose then
			Print("Role check: You have no spec, cannot set automatically.")
		end
	end
end

local function autoSetRole(self, event)
	if event ~= "ROLE_POLL_BEGIN" or InCombatLockdown() then return end

	if isPureClass then
		UnitSetRole("player", "DAMAGER")
		if verbose then
			Print("Role check: Setting role to dps.")
		end
	else
		if UnitGroupRolesAssigned("player") == "NONE" then
			if useSpec then
				setRoleForSpec(self)
			else
				if not self:IsShown() then
					RolePollPopup_Show(self)
				end
			end
		else
			if useSpec then
				setRoleForSpec(self)
			else
				if verbose then
					Print("Role check: Role already set, doing nothing.")
				end
			end
		end
	end
end

if C.misc.autoSetRole then
	RolePollPopup:SetScript("OnEvent", autoSetRole)
end
