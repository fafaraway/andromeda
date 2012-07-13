local F, C, L = unpack(select(2, ...))

local name = UnitName("player")
local realm = GetRealmName()

local updateCurrency = function()
	FreeUIGlobalConfig[realm].currency[name] = select(2, GetCurrencyInfo(396)).." "..select(4, GetCurrencyInfo(396))
end

local addonLoaded
addonLoaded = function(_, _, addon)
	if addon ~= "FreeUI" then return end
	
	if FreeUIConfig.layout == nil then FreeUIConfig.layout = 1 end

	if FreeUIGlobalConfig[realm] == nil then FreeUIGlobalConfig[realm] = {} end
	if FreeUIGlobalConfig[realm].gold == nil then FreeUIGlobalConfig[realm].gold = {} end

	if FreeUIGlobalConfig[realm].currency == nil then FreeUIGlobalConfig[realm].currency = {} end

	if FreeUIGlobalConfig[realm].class == nil then FreeUIGlobalConfig[realm].class = {} end
	FreeUIGlobalConfig[realm].class[name] = select(2, UnitClass("player"))
	
	updateCurrency()
	F.RegisterEvent("CURRENCY_DISPLAY_UPDATE", updateCurrency)
	F.UnregisterEvent("ADDON_LOADED", addonLoaded)
	addonLoaded = nil
end

F.RegisterEvent("ADDON_LOADED", addonLoaded)

local function updateMoney()
	FreeUIGlobalConfig[realm].gold[name] = GetMoney()
end

F.RegisterEvent("PLAYER_MONEY", updateMoney)
F.RegisterEvent("PLAYER_ENTERING_WORLD", updateMoney)

SetCVar("consolidateBuffs", 0)
SetCVar("enableCombatText", 0)