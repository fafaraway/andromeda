local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FreeUIConfigs['theme']['reskin_blizz'] then return end

	LevelUpDisplaySide:HookScript("OnShow", function(self)
		for i = 1, #self.unlockList do
			local f = _G["LevelUpDisplaySideUnlockFrame"..i]

			if not f.bg then
				f.bg = F.ReskinIcon(f.icon)
			end
		end
	end)
end)
