local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	LevelUpDisplaySide:HookScript("OnShow", function(self)
		for i = 1, #self.unlockList do
			local f = _G["LevelUpDisplaySideUnlockFrame"..i]

			if not f.restyled then
				f.icon:SetTexCoord(unpack(C.TexCoord))
				F.CreateBG(f.icon)
			end
		end
	end)
end)