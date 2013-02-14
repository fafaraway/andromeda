local _, class = UnitClass("Player")
if class ~= "HUNTER" and class ~= "MAGE" and class ~= "WARLOCK" and class ~= "ROGUE" then return end

local f = CreateFrame("Frame")
f:RegisterEvent("ROLE_POLL_BEGIN")
f:SetScript("OnEvent", function()
	UnitSetRole("player", "DAMAGER")
	StaticPopupSpecial_Hide(RolePollPopup)
end)