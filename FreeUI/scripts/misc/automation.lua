local F, C, L = unpack(select(2, ...))
local module = F:GetModule("misc")





-- auto repair / sell

local IDs = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do
	IDs[slot] = GetInventorySlotInfo(slot.."Slot")
end

local cost
local last = 0
local function onUpdate(self, elapsed)
	last = last + elapsed
	if last >= 1 then
		self:SetScript("OnUpdate", nil)
		last = 0
		local gearRepaired = true
		for slot, id in pairs(IDs) do
			local dur, maxdur = GetInventoryItemDurability(id)
			if dur and maxdur and dur < maxdur then
				gearRepaired = false
				break
			end
		end
		if gearRepaired then
			print(format("Repair: %.1fg (Guild)", cost * 0.0001))
		else
			print("Your guild cannot afford your repairs.")
			RepairAllItems()
			print(format("Repair: %.1fg", cost * 0.0001))
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function(self, event)
	if CanMerchantRepair() and C.misc.autoRepair then
		cost = GetRepairAllCost()
		local money = GetMoney()

		if cost > 0 then
			if C.misc.autoRepair_guild and CanGuildBankRepair() then
				local guildWithdrawMoney = GetGuildBankWithdrawMoney()

				if guildWithdrawMoney > cost then
					-- GetGuildBankMoney() doesn't work properly, so we just try to repair and see if it worked
					RepairAllItems(1)
					self:SetScript("OnUpdate", onUpdate)
				else
					if money >= cost then
						if cost / 9 > guildWithdrawMoney then
							-- it probably isn't worth using guild repair at all
							RepairAllItems()
							print(format("Repair: %.1fg", cost * 0.0001))
						else
							-- it might still be possible to repair a few items with guild repair
							F.Notification("Repairs", "Guild repair failed. Repair manually, or click to use own money.", RepairAllItems, "Interface\\Icons\\INV_Hammer_20")
						end
					else
						F.Notification("Repairs", "You have insufficient funds to repair your equipment.", nil, "Interface\\Icons\\INV_Hammer_20")
					end
				end
			elseif money >= cost then
				RepairAllItems()
				print(format("Repair: %.1fg", cost * 0.0001))
			else
				F.Notification("Repairs", "You have insufficient funds to repair your equipment.", nil, "Interface\\Icons\\INV_Hammer_20")
			end
		end
	end

	if C.misc.autoSell then
		for bag = 0, 4 do
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link and select(3, GetItemInfo(link)) == 0 and not GetContainerItemEquipmentSetInfo(bag, slot) then
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end)




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

if C.misc.autoAccept then F.RegisterEvent("PARTY_INVITE_REQUEST", onInvite) end



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
local r, g, b = unpack(C.class)
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
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffff"..msg, r, g, b)
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
