local F, C = unpack(select(2, ...))

tinsert(C.themes["FreeUI"], function()
	_G.LossOfControlFrame.RedLineTop:SetTexture(nil)
	_G.LossOfControlFrame.RedLineBottom:SetTexture(nil)
	_G.LossOfControlFrame.blackBg:SetTexture(nil)

	local styled
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
		if not styled then
			self.Icon:SetTexCoord(unpack(C.TexCoord))
			local bg = F.CreateBDFrame(self.Icon)
			F.CreateSD(bg)

			styled = true
		end
	end)
end)