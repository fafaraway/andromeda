local F, C, L = unpack(select(2, ...))

local name = UnitName("player")
local realm = GetRealmName()

local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function()
	if FreeUIConfig.layout == nil then FreeUIConfig.layout = 1 end

	if FreeUIConfig.layout == 2 then
		aThreatMeter:UnregisterAllEvents()
		aThreatMeter:Hide()
	end

	if FreeUIGlobalConfig[realm] == nil then FreeUIGlobalConfig[realm] = {} end
	if FreeUIGlobalConfig[realm].gold == nil then FreeUIGlobalConfig[realm].gold = {} end

	if FreeUIGlobalConfig[realm].currency == nil then FreeUIGlobalConfig[realm].currency = {} end

	if FreeUIGlobalConfig[realm].class == nil then FreeUIGlobalConfig[realm].class = {} end
	FreeUIGlobalConfig[realm].class[name] = select(2, UnitClass("player"))
end)

local gold = CreateFrame("Frame")
gold:RegisterEvent("PLAYER_MONEY")
gold:RegisterEvent("PLAYER_ENTERING_WORLD")
gold:SetScript("OnEvent", function()
	FreeUIGlobalConfig[realm].gold[name] = GetMoney()
end)

local currency = CreateFrame("Frame")
currency:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
currency:RegisterEvent("PLAYER_ENTERING_WORLD")
currency:SetScript("OnEvent", function()
	FreeUIGlobalConfig[realm].currency[name] = select(2, GetCurrencyInfo(396)).." "..select(4, GetCurrencyInfo(396))
end)

SetCVar("consolidateBuffs", 0)
SetCVar("buffDurations", 1)