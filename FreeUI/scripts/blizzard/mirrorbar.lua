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
			statusbar:SetStatusBarTexture(C.media.texture)

			local text = _G["MirrorTimer"..i.."Text"]
			text:ClearAllPoints()
			text:SetPoint("CENTER", statusbar)
			
			if C.appearance.usePixelFont and (C.client == 'zhCN' or C.client == 'zhTW') then
				text:SetFont(unpack(C.pixelFontCN))
			elseif C.client == 'zhCN' or C.client == 'zhTW' then
				text:SetFont(unpack(C.standardFont))
			else
				F.SetFS(text)
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
