local F, C = unpack(select(2, ...))


--[[local stateFont = {
		C.font.normal,
		12,
		"OUTLINE"
	}

-- Capture Bar
local function CaptureUpdate()
	if not NUM_EXTENDED_UI_FRAMES then return end
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local barname = "WorldStateCaptureBar"..i
		local bar = _G[barname]

		if bar and bar:IsVisible() then
			bar:ClearAllPoints()
			if i == 1 then
				bar:SetPoint(unpack(C.position.capture_bar))
			else
				bar:SetPoint("TOPLEFT", _G["WorldStateCaptureBar"..i-1], "BOTTOMLEFT", 0, -7)
			end
			if not bar.skinned then
				local left = bar.LeftBar
				local right = bar.RightBar
				local middle = bar.MiddleBar
				select(4, bar:GetRegions()):Hide()
				bar.LeftLine:SetAlpha(0)
				bar.RightLine:SetAlpha(0)
				bar.LeftIconHighlight:SetAlpha(0)
				bar.RightIconHighlight:SetAlpha(0)

				left:SetTexture(C.media.texture)
				right:SetTexture(C.media.texture)
				middle:SetTexture(C.media.texture)

				left:SetVertexColor(0.2, 0.6, 1)
				right:SetVertexColor(0.9, 0.2, 0.2)
				middle:SetVertexColor(0.8, 0.8, 0.8)

				bar:CreateBackdrop("Default")
				bar.backdrop:SetPoint("TOPLEFT", left, -2, 2)
				bar.backdrop:SetPoint("BOTTOMRIGHT", right, 2, -2)

				bar.skinned = true
			end
		end
	end
end
hooksecurefunc("UIParent_ManageFramePositions", CaptureUpdate)]]


_G.UIWidgetTopCenterContainerFrame:ClearAllPoints()
_G.UIWidgetTopCenterContainerFrame:SetPoint("TOP", UIParent, "TOP", 0, -30)
_G.UIWidgetTopCenterContainerFrame.ignoreFramePositionManager = true



--[[local function restyleStateFrames()
	for i = 1, 20 do
		local f = _G["AlwaysUpFrame"..i]
		if f and not f.styled then
			local _, g = f:GetRegions()

			if C.client == "zhCN" or C.client == "zhTW" then
				g:SetFont(unpack(stateFont))
			else
				F.SetFS(g)
				g:SetShadowOffset(0, 0)
			end
			g:SetTextColor(C.appearance.fontColorFontRGB.r, C.appearance.fontColorFontRGB.g, C.appearance.fontColorFontRGB.b)

			f.styled = true
		end
	end
end

restyleStateFrames()]]
--hooksecurefunc("WorldStateAlwaysUpFrame_Update", restyleStateFrames)
