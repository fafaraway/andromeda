local F, C, L = unpack(select(2, ...))

if(select(2, UnitClass("player")) ~= "ROGUE" or UnitLevel("player") < 20 or C.classmod.rogue == false) then return end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:SetScript("OnEvent", function()
	local main, _, _, off, _, _, thrown = GetWeaponEnchantInfo()
	if not UnitInVehicle("player") and(not main or not off or(not thrown and C.classmod.rogue_checkthrown == true)) then
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffReapply poisons.|r", unpack(C.class))
	end
end)