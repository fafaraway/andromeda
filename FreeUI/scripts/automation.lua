local F, C, L = unpack(select(2, ...))

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
	if CanMerchantRepair() and C.automation.autoRepair then
		cost = GetRepairAllCost()
		local money = GetMoney()

		if cost > 0 and CanGuildBankRepair() and C.automation.autoRepair_guild then
			local guildWithdrawMoney = GetGuildBankWithdrawMoney()

			if guildWithdrawMoney > cost then
				self:SetScript("OnUpdate", onUpdate) -- to work around bug when there's not enough money in guild bank
				RepairAllItems(1)
			elseif money > cost then -- if we can't withdraw enough from guild...
				if cost / 9 > guildWithdrawMoney then -- can't even repair 1 item with guild money (average)
					RepairAllItems()
					print(format("Repair: %.1fg", cost * 0.0001))
				else
					F.Notification("Repairs", "Guild repair failed. Repair manually or click to continue.", RepairAllItems())
				end
			end
		elseif cost > 0 and money > cost then
			RepairAllItems()
			print(format("Repair: %.1fg", cost * 0.0001))
		elseif money < cost then
			F.Notification("Repairs", "You have insufficient funds to repair your equipment.")
		end
	end

	if C.automation.autoSell then
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

local playerRealm = C.myRealm

local IsFriend = function(name)
	for i = 1, GetNumFriends() do
		if GetFriendInfo(i) == name then return true end
	end

	if IsInGuild() then
		for i = 1, GetNumGuildMembers() do
			if GetGuildRosterInfo(i) == name then return true end
		end
	end


	for i = 1, select(2, BNGetNumFriends()) do
		local presenceID, _, _, _, toonName, _, client = BNGetFriendInfo(i)
		if client == "WoW" then
			local _, _, _, realmName = BNGetToonInfo(presenceID)

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

if C.automation.autoAccept then F.RegisterEvent("PARTY_INVITE_REQUEST", onInvite) end

F.AddOptionsCallback("automation", "autoAccept", function()
	if C.automation.autoAccept then
		F.RegisterEvent("PARTY_INVITE_REQUEST", onInvite)
	else
		F.UnregisterEvent("PARTY_INVITE_REQUEST", onInvite)
	end
end)

if C.general.helmcloakbuttons then
	local helm = CreateFrame("CheckButton", "FreeUI_HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
	helm:SetSize(22, 22)
	helm:SetPoint("LEFT", CharacterHeadSlot, "RIGHT", 5, 0)
	helm:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
	helm:SetScript("OnEvent", function() helm:SetChecked(ShowingHelm()) end)
	helm:RegisterEvent("UNIT_MODEL_CHANGED")
	helm:SetToplevel(true)

	local cloak = CreateFrame("CheckButton", "FreeUI_CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
	cloak:SetSize(22, 22)
	cloak:SetPoint("LEFT", CharacterBackSlot, "RIGHT", 5, 0)
	cloak:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
	cloak:SetScript("OnEvent", function() cloak:SetChecked(ShowingCloak()) end)
	cloak:RegisterEvent("UNIT_MODEL_CHANGED")
	cloak:SetToplevel(true)

	helm:SetChecked(ShowingHelm())
	cloak:SetChecked(ShowingCloak())
	helm:SetFrameLevel(31)
	cloak:SetFrameLevel(31)
end

if C.general.undressButton then
	local undress = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate")
	undress:SetSize(80, 22)
	undress:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", -1, 0)
	undress:SetText("Undress")
	undress:SetScript("OnClick", function()
		DressUpModel:Undress()
	end)

	local sideUndress = CreateFrame("Button", "SideDressUpModelUndressButton", SideDressUpModel, "UIPanelButtonTemplate")
	sideUndress:SetSize(80, 22)
	sideUndress:SetPoint("TOP", SideDressUpModelResetButton, "BOTTOM", 0, -5)
	sideUndress:SetText("Undress")
	sideUndress:SetScript("OnClick", function()
		SideDressUpModel:Undress()
	end)

	F.Reskin(undress)
	F.Reskin(sideUndress)
end

if C.automation.questRewardHighlight then
	local f = CreateFrame("Frame")
	local highlightFunc

	local last = 0
	local startIndex = 1

	local maxPrice = 0
	local maxPriceIndex = 0

	local function onUpdate(self, elapsed)
		-- print("test")
		last = last + elapsed
		if last >= .05 then
			self:SetScript("OnUpdate", nil)
			last = 0

			if QuestInfoItem1:IsVisible() then -- protection in case frame is closed early
				highlightFunc()
			end
		end
	end

	highlightFunc = function()
		local numChoices = GetNumQuestChoices()
		if numChoices < 2 then return end

		for i = startIndex, numChoices do
			local link = GetQuestItemLink("choice", i)
			if link then
				local _, _, _, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(link)

				if vendorPrice > maxPrice then
					maxPrice = vendorPrice
					maxPriceIndex = i
				end
			else
				-- print("scanning")
				startIndex = i
				f:SetScript("OnUpdate", onUpdate)
				return
			end
		end

		if maxPriceIndex > 0 then
			local infoItem = _G["QuestInfoItem"..maxPriceIndex]

			QuestInfoItemHighlight:ClearAllPoints()
			QuestInfoItemHighlight:SetPoint("TOP", infoItem)
			QuestInfoItemHighlight:Show()

			infoItem:SetBackdropColor(0.89, 0.88, 0.06, .2)
		end

		startIndex = 1
		maxPrice = 0
		maxPriceIndex = 0
	end

	f:RegisterEvent("QUEST_COMPLETE")
	f:SetScript("OnEvent", highlightFunc)
end