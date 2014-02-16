local F, C, L = unpack(select(2, ...))

hooksecurefunc("UIParent_ManageFramePositions", function()
	if not NUM_EXTENDED_UI_FRAMES then return end
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local barname = "WorldStateCaptureBar"..i
		local bar = _G[barname]

		if bar and bar:IsVisible() then
			bar:ClearAllPoints()
			bar:SetPoint("TOP", UIParent, "TOP", 0, -120)
			if not bar.skinned then
				local left = _G[barname.."LeftBar"]
				local right = _G[barname.."RightBar"]
				local middle = _G[barname.."MiddleBar"]

				left:SetTexture(C.media.texture)
				right:SetTexture(C.media.texture)
				middle:SetTexture(C.media.texture)
				left:SetDrawLayer("BORDER")
				middle:SetDrawLayer("ARTWORK")
				right:SetDrawLayer("BORDER")

				left:SetGradient("VERTICAL", .1, .4, .9, .2, .6, 1)
				right:SetGradient("VERTICAL", .7, .1, .1, .9, .2, .2)
				middle:SetGradient("VERTICAL", .8, .8, .8, 1, 1, 1)

				_G[barname.."RightLine"]:SetAlpha(0)
				_G[barname.."LeftLine"]:SetAlpha(0)
				select(4, bar:GetRegions()):Hide()
				_G[barname.."LeftIconHighlight"]:SetAlpha(0)
				_G[barname.."RightIconHighlight"]:SetAlpha(0)

				bar.bg = bar:CreateTexture(nil, "BACKGROUND")
				bar.bg:SetPoint("TOPLEFT", left, -1, 1)
				bar.bg:SetPoint("BOTTOMRIGHT", right, 1, -1)
				bar.bg:SetTexture(C.media.backdrop)
				bar.bg:SetVertexColor(0, 0, 0)

				bar.bgmiddle = CreateFrame("Frame", nil, bar)
				bar.bgmiddle:SetPoint("TOPLEFT", middle, -1, 1)
				bar.bgmiddle:SetPoint("BOTTOMRIGHT", middle, 1, -1)
				F.CreateBD(bar.bgmiddle, 0)

				bar.skinned = true
			end
		end
	end
end)

local function restyleStateFrames()
	for i = 1, NUM_ALWAYS_UP_UI_FRAMES do
		local f = _G["AlwaysUpFrame"..i]
		if f and not f.styled then
			local _, g = f:GetRegions()
			g:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			g:SetShadowOffset(0, 0)
			g:SetTextColor(1, 1, 1)

			f.styled = true
		end
	end
end

restyleStateFrames()
hooksecurefunc("WorldStateAlwaysUpFrame_Update", restyleStateFrames)