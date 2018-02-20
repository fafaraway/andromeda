local F, C, L = unpack(select(2, ...))

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if IsAddOnLoaded("ls_Toasts") then

		local LST = unpack(ls_Toasts)

		LST:RegisterSkin("FreeUI", {
			name = "FreeUI",
			border = {
				color = {0, 0, 0},
				offset = 0,
				size = 1,
				texture = {1, 1, 1, 1},
			},
			title = {
				flags = "OUTLINE",
				shadow = false,
			},
			text = {
				flags = "OUTLINE",
				shadow = false,
			},
			bonus = {
				hidden = false,
			},
			dragon = {
				hidden = false,
			},
			icon = {
				tex_coords = {5 / 64, 59 / 64, 5 / 64, 59 / 64},
			},
			icon_border = {
				color = {0, 0, 0},
				offset = 0,
				size = 1,
				texture = {1, 1, 1, 1},
			},
			icon_highlight = {
				hidden = false,
			},
			icon_text_1 = {
				flags = "OUTLINE",
				shadow = false,
			},
			icon_text_2 = {
				flags = "OUTLINE",
				shadow = false,
			},
			skull = {
				hidden = false,
			},
		})
		LST:SetSkin("FreeUI")
	end

end)