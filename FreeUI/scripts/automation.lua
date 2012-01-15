local F, C, L = unpack(select(2, ...))

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", function()
	if(CanMerchantRepair() and C.general.autorepair == true) then
		local cost = GetRepairAllCost()
		if(cost>0 and CanGuildBankRepair() and C.general.autorepair_guild == true) then
			if GetGuildBankWithdrawMoney() > cost then
				RepairAllItems(1)
				print(format("Repair: %.1fg (Guild)", cost * 0.0001))
			else
				print("Your repair costs are too high for your guild.")
			end
		elseif(cost>0 and GetMoney()>cost) then
			RepairAllItems()
			print(format("Repair: %.1fg", cost * 0.0001))
		elseif(GetMoney()<cost) then
			print("You are not repaired! (insufficient funds)")
		end
	end

	if C.general.autosell == true then
		for bag = 0, 4 do
			for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link and (select(3, GetItemInfo(link))==0) then
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end)

if C.general.auto_accept == true then
	if UnitFactionGroup("player") == "Horde" then playerFaction = 0 else playerFaction = 1 end
	local playerRealm = GetRealmName()

	local IsFriend = function(name)
		for i = 1, GetNumFriends() do if(GetFriendInfo(i)==name) then return true end end
		if IsInGuild() then for i = 1, GetNumGuildMembers() do if(GetGuildRosterInfo(i)==name) then return true end end end
		for i = 1, select(2, BNGetNumFriends()) do
			local presenceID, _, _, toonName, _, client = BNGetFriendInfo(i)
			local _, _, _, realmName, faction = BNGetToonInfo(presenceID)
			if client == "WoW" and realmName == playerRealm and toonName == name then
				return true
			end
		end
	end

	local g = CreateFrame("Frame")
	g:RegisterEvent("PARTY_INVITE_REQUEST")
	g:SetScript("OnEvent", function(event, name)
		if MiniMapLFGFrame:IsShown() then return end
		if IsFriend(name) then
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if(frame:IsVisible() and frame.which=="PARTY_INVITE") then
					frame.inviteAccepted = 1
					return StaticPopup_Hide("PARTY_INVITE")
				end
			end
		end
	end)
end

if C.general.auto_loot_switch == true then
	local h = CreateFrame("Frame")
	h:RegisterEvent("PLAYER_ENTERING_WORLD")
	h:SetScript("OnEvent", function()
		if select(2, GetInstanceInfo()) == "raid" then
			SetCVar("showLootSpam", 0)
		else
			SetCVar("showLootSpam", 1)
		end
	end)
end