local F, C = unpack(select(2, ...))

if not C.isDeveloper then return end

do -- Prevents spells from being automatically added to your action bar
	IconIntroTracker.RegisterEvent = function() end
	IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

	-- local f = CreateFrame('frame')
	-- f:SetScript('OnEvent', function(self, event, spellID, slotIndex, slotPos)
	-- 	if not InCombatLockdown() then
	-- 		ClearCursor()
	-- 		PickupAction(slotIndex)
	-- 		ClearCursor()
	-- 	end
	-- end)
	-- f:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')
end
