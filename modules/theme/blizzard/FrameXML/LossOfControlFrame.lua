local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local styled
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
		if not styled then
			self.RedLineTop:SetTexture(nil)
			self.RedLineBottom:SetTexture(nil)
			self.blackBg:SetTexture(nil)

			F.ReskinIcon(self.Icon, true)

			styled = true
		end
	end)
end)
