local F, C, L = unpack(select(2, ...))
local module = F:GetModule("infobar")
if not C.infoBar.enable then return end

local keys = {}

local addonLoaded
addonLoaded = function(_, addon)
	if addon ~= "FreeUI" then return end

	if FreeUIGlobalConfig[C.PlayerRealm] == nil then FreeUIGlobalConfig[C.PlayerRealm] = {} end

	if FreeUIGlobalConfig[C.PlayerRealm].gold == nil then FreeUIGlobalConfig[C.PlayerRealm].gold = {} end

	if FreeUIGlobalConfig[C.PlayerRealm].class == nil then FreeUIGlobalConfig[C.PlayerRealm].class = {} end
	FreeUIGlobalConfig[C.PlayerRealm].class[C.PlayerName] = select(2, UnitClass("player"))

	if FreeUIGlobalConfig[C.PlayerRealm].faction == nil then FreeUIGlobalConfig[C.PlayerRealm].faction = {} end
	FreeUIGlobalConfig[C.PlayerRealm].faction[C.PlayerName] = UnitFactionGroup("player")

	F:UnregisterEvent("ADDON_LOADED", addonLoaded)
	addonLoaded = nil
end
F:RegisterEvent("ADDON_LOADED", addonLoaded)

local function updateMoney()
	FreeUIGlobalConfig[C.PlayerRealm].gold[C.PlayerName] = GetMoney()
end

F:RegisterEvent("PLAYER_MONEY", updateMoney)
F:RegisterEvent("PLAYER_ENTERING_WORLD", updateMoney)

local function moneyFormat(money)
	--return format("|cffc1b37c"..BreakUpLargeNumbers(math.floor((money / 10000))).."|r")
	local goldString, silverString, copperString
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
	local copper = mod(money, COPPER_PER_SILVER)
	goldString = format("|cffdbd368"..gold.."|r", 0, 0)
	silverString = format("|cffd9d6d3"..silver.."|r", 0, 0)
	copperString = format("|cffc19377"..copper.."|r", 0, 0)

	local moneyString = ""
	local separator = ""
	if ( gold > 0 ) then
		moneyString = goldString
		separator = " "
	end
	if ( silver > 0 ) then
		moneyString = moneyString..separator..silverString
		separator = " "
	end
	if ( copper > 0 or moneyString == "" ) then
		moneyString = moneyString..separator..copperString
	end
 
	return moneyString
end

local FreeUIMoneyButton = module.FreeUIMoneyButton

FreeUIMoneyButton = module:addButton("", module.POSITION_RIGHT, function(self, button)
	if button == "LeftButton" then
		local openbags
		for i = 1, NUM_CONTAINER_FRAMES do
				local containerFrame = _G["ContainerFrame"..i]
				if containerFrame:IsShown() then
					openbags = true
				end
		end
		if not openbags then
			OpenAllBags()
		else
			CloseAllBags()
		end
	end
end)

FreeUIMoneyButton:HookScript("OnEnter", function()
	GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -33)

	local total, totalAlliance, totalHorde, totalNeutral = 0, 0, 0, 0
	local goldList = FreeUIGlobalConfig[C.PlayerRealm].gold
	local factionList = FreeUIGlobalConfig[C.PlayerRealm].faction
	local allianceList, hordeList, neutralList = {}, {}, {}
	local headerAdded = false

	for k, v in pairs(goldList) do
		if factionList[k] == "Alliance" then
			totalAlliance = totalAlliance + v
			allianceList[k] = v
		elseif factionList[k] == "Horde" then
			totalHorde = totalHorde + v
			hordeList[k]= v
		else
			totalNeutral = totalNeutral + v
			neutralList[k] = v
		end

		total = total + v
	end

	GameTooltip:AddDoubleLine(C.PlayerRealm, GetMoneyString(total), .9, .82, .62, 1, 1, 1)

	for n in pairs(allianceList) do
		table.insert(keys, n)
	end
	table.sort(keys)

	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[C.PlayerRealm].class[k]
		local v = allianceList[k]
		if v and v >= 10000 then
			if not headerAdded then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(strupper(FACTION_ALLIANCE), GetMoneyString(totalAlliance), 0, 0.68, 0.94, 1, 1, 1)
				headerAdded = true
			end
			GameTooltip:AddDoubleLine(k, GetMoneyString(v), C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b, 1, 1, 1)
		end
	end

	headerAdded = false
	table.wipe(keys)

	for n in pairs(hordeList) do
		table.insert(keys, n)
	end
	table.sort(keys)

	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[C.PlayerRealm].class[k]
		local v = hordeList[k]
		if v and v >= 10000 then
			if not headerAdded then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(strupper(FACTION_HORDE), GetMoneyString(totalHorde), 1, 0, 0, 1, 1, 1)
				headerAdded = true
			end
			GameTooltip:AddDoubleLine(k, GetMoneyString(v), C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b, 1, 1, 1)
		end
	end

	headerAdded = false
	table.wipe(keys)

	for n in pairs(neutralList) do
		table.insert(keys, n)
	end
	table.sort(keys)

	for _, k in pairs(keys) do
		local class = FreeUIGlobalConfig[C.PlayerRealm].class[k]
		local v = neutralList[k]
		if v and v >= 10000 then
			if not headerAdded then
				GameTooltip:AddLine(" ")
				GameTooltip:AddDoubleLine(strupper(FACTION_OTHER), GetMoneyString(totalNeutral), .9, .9, .9, 1, 1, 1)
				headerAdded = true
			end
			GameTooltip:AddDoubleLine(k, GetMoneyString(v), C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b, 1, 1, 1)
		end
	end
	GameTooltip:AddDoubleLine(" ", C.LineString)
	GameTooltip:AddDoubleLine(" ", C.LeftButton..L["OpenBag"], 1,1,1, .9, .82, .62)
	GameTooltip:Show()
end)

FreeUIMoneyButton:HookScript("OnLeave", function()
	GameTooltip:Hide()
end)




local moneyHolder = CreateFrame("Frame", nil, FreeUIMoneyButton)
moneyHolder:SetFrameLevel(3)
moneyHolder:SetAllPoints(FreeUIMoneyButton)

local moneyText = moneyHolder:CreateFontString()
F.SetFS(moneyText)
moneyText:SetPoint("CENTER")

moneyHolder:RegisterEvent("PLAYER_ENTERING_WORLD")
moneyHolder:RegisterEvent("PLAYER_MONEY")
moneyHolder:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
moneyHolder:RegisterEvent("SEND_MAIL_COD_CHANGED")
moneyHolder:RegisterEvent("PLAYER_TRADE_MONEY")
moneyHolder:RegisterEvent("TRADE_MONEY_CHANGED")
moneyHolder:SetScript("OnEvent", function(self, event, ...)
	local tmpMoney = GetMoney()
	self.CurrentMoney = tmpMoney
	moneyText:SetText("MONEY: "..moneyFormat(self.CurrentMoney))
end)