local F, C, L = unpack(FreeUI)

if DBM then 
	hooksecurefunc(DBT, "CreateBar", function(self) 
		for bar in self:GetBarIterator() do if not bar.styled then
			local frame = bar.frame 
			local tbar = getglobal(frame:GetName().."Bar") 
			local texture = getglobal(frame:GetName().."BarTexture") 
			local icon1 = getglobal(frame:GetName().."BarIcon1") 
			local icon2 = getglobal(frame:GetName().."BarIcon2") 
			local name = getglobal(frame:GetName().."BarName") 
			local timer = getglobal(frame:GetName().."BarTimer") 
			tbar:SetHeight(16) 
			local bg = CreateFrame("Frame", nil, tbar)
			bg:SetPoint("TOPRIGHT", tbar, 1, 1)
			bg:SetPoint("BOTTOMLEFT", tbar, -1, -1)
	 		bg:SetBackdrop({
				bgFile = "", 
				edgeFile = C.media.backdrop,
				edgeSize = 1,
			})
			bg:SetBackdropBorderColor(0, 0, 0)
--[[ Left icon start
			local ibg = CreateFrame("Frame", icon1)
			ibg:SetPoint("TOPRIGHT", icon1, 1, 1)
			ibg:SetPoint("BOTTOMLEFT", icon1, -1, -1)
			ibg:SetBackdrop({
				bgFile = "", 
				edgeFile = C.media.backdrop,
				edgeSize = 1,
			})
			ibg:SetBackdropBorderColor(0, 0, 0)
			ibg:SetParent(tbar)
Left icon end ]]

--[[ Right icon start
			local ibg = CreateFrame("Frame", icon2)
			ibg:SetPoint("TOPRIGHT", icon2, 1, 1)
			ibg:SetPoint("BOTTOMLEFT", icon2, -1, -1)
			ibg:SetBackdrop({
				bgFile = "", 
				edgeFile = C.media.backdrop,
				edgeSize = 1,
			})
			ibg:SetBackdropBorderColor(0, 0, 0)
			ibg:SetParent(tbar)
Right icon end ]]
			texture:SetTexture(C.media.texture) 
			texture.SetTexture = F.dummy 
			icon1:SetTexCoord(.1,.9,.1,.9) 
			icon1:ClearAllPoints()
			icon1:SetPoint("LEFT", tbar, "LEFT", -23, 0)
			icon2:SetTexCoord(.1,.9,.1,.9) 
			name:SetPoint("CENTER") 
			name:SetPoint("LEFT", 4, 0) 
			name:SetFont(C.media.font, 8, "OUTLINEMONOCHROME") 
			name:SetShadowColor(0, 0, 0, 0)
			name.SetFont = F.dummy 
			timer:SetPoint("CENTER") 
			timer:SetPoint("RIGHT", -4, 0) 
			timer:SetFont(C.media.font, 8, "OUTLINEMONOCHROME") 
			timer:SetShadowColor(0, 0, 0, 0)
			timer.SetFont = F.dummy

			bar.styled = true
		end end
	end)
end  