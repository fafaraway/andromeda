local f = CreateFrame("Frame")
f:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
f:RegisterEvent("CONFIRM_LOOT_ROLL")
f:SetScript("OnEvent", function(self, event, id, rollType)
	for i=1,STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..i]
		if frame.which == "CONFIRM_LOOT_ROLL" and frame.data == id and frame.data2 == rollType and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
	end
end)

local g = CreateFrame("Frame")
g:RegisterEvent("LOOT_BIND_CONFIRM")
g:SetScript("OnEvent", function(self, event, id)
	if GetNumGroupMembers() == 0 then
		local elapsed = 0
		self:SetScript("OnUpdate", function(self, elap)
			elapsed = elapsed + elap
			if elapsed < 0.2 then
				StaticPopup_Hide("LOOT_BIND")
				return
			end
			elapsed = 0
			ConfirmLootSlot(id)
			self:SetScript("OnUpdate", nil)
		end)
	end
end)