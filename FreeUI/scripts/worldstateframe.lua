local F, C = unpack(select(2, ...))

local locale = GetLocale()
local stateFont = {
		C.font.normal,
		12,
		"OUTLINE"
	}

local function restyleStateFrames()
	for i = 1, NUM_ALWAYS_UP_UI_FRAMES do
		local f = _G["AlwaysUpFrame"..i]
		if f and not f.styled then
			local _, g = f:GetRegions()

			if locale == "zhCN" or locale == "zhTW" then
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

restyleStateFrames()
hooksecurefunc("WorldStateAlwaysUpFrame_Update", restyleStateFrames)
