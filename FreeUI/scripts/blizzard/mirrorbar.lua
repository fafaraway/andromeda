local F, C, L = unpack(select(2, ...))

-- Mirror bar
local function MBSkin(timer, value, maxvalue, scale, paused, label)
	local previous
	for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
		local frame = _G["MirrorTimer"..i]
		if not frame.isSkinned then
			F.StripTextures(frame, true)
			frame:SetSize(200, 16)

			local bg = F.CreateBDFrame(frame)
			F.CreateSD(bg)

			local statusbar = _G["MirrorTimer"..i.."StatusBar"]
			statusbar:SetAllPoints()
			statusbar:SetStatusBarTexture(C.media.sbTex)

			local text = _G["MirrorTimer"..i.."Text"]
			text:ClearAllPoints()
			text:SetPoint("CENTER", statusbar)
			
			if C.GameClient == 'zhCN' or C.GameClient == 'zhTW' then
				text:SetFont(C.font.normal, 12)
				text:SetShadowColor(0,0,0,1)
				text:SetShadowOffset(2, -2)
			else
				F.SetFS(text)
				text:SetShadowColor(0,0,0,1)
				text:SetShadowOffset(1, -1)
			end

			if previous then
				frame:SetPoint("TOP", previous, "BOTTOM", 0, -5)
			end
			previous = frame
			
			frame.isSkinned = true
		end
	end
end

hooksecurefunc("MirrorTimer_Show", MBSkin)
