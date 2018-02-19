local F, C, L = unpack(select(2, ...))

-- Mirror bar
local function MBSkin(timer, value, maxvalue, scale, paused, label)
	for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
		local frame = _G["MirrorTimer"..i]
		if not frame.isSkinned then
			local statusbar = _G[frame:GetName().."StatusBar"]
			local border = _G[frame:GetName().."Border"]
			local text = _G[frame:GetName().."Text"]
			
			statusbar:ClearAllPoints()
			statusbar:SetPoint("TOPLEFT", frame, 2, -2)
			statusbar:SetPoint("BOTTOMRIGHT", frame, -2, 8)
			statusbar:SetStatusBarTexture(C.media.backdrop)
			statusbar:SetHeight(16)
			statusbar:SetWidth(200)
			
			local region = frame:GetRegions()
			if region:GetObjectType() == "Texture" then
				region:SetAlpha(0)
			end
		
			statusbar.backdrop = F.CreateBDFrame(statusbar, .65)
			statusbar.backdrop:SetPoint("BOTTOMRIGHT", statusbar, 1, -2)
			F.CreateSD(statusbar.backdrop)
			
			text:ClearAllPoints()
			text:SetFont(C.font.normal, 12, "OUTLINE")
			text:SetPoint("CENTER", statusbar)
			
			border:SetTexture(nil)
			
			frame.isSkinned = true
		end
	end
end

hooksecurefunc("MirrorTimer_Show", MBSkin)
