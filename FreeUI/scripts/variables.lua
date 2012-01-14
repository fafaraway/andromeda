local F, C, L = unpack(select(2, ...))

local name = UnitName("player")
local realm = GetRealmName()

local f = CreateFrame("Frame")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function()
	if FreeUIConfig.layout == 2 then
		aThreatMeter:UnregisterAllEvents()
		aThreatMeter:Hide()
	end

	if FreeUIGlobalConfig.gold == nil then FreeUIGlobalConfig.gold = {} end
	if FreeUIGlobalConfig.gold[realm] == nil then FreeUIGlobalConfig.gold[realm] = {} end

	if FreeUIGlobalConfig.class == nil then FreeUIGlobalConfig.class = {} end
	if FreeUIGlobalConfig.class[realm] == nil then FreeUIGlobalConfig.class[realm] = {} end
	FreeUIGlobalConfig.class[realm][name] = select(2, UnitClass("player"))
end)

local gold = CreateFrame("Frame")
gold:RegisterEvent("PLAYER_MONEY")
gold:RegisterEvent("PLAYER_ENTERING_WORLD")
gold:SetScript("OnEvent", function(self, event)
	FreeUIGlobalConfig.gold[realm][name] = GetMoney()
end)

SetCVar("consolidateBuffs", 0)
SetCVar("buffDurations", 1)