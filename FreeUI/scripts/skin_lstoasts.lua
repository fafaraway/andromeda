local F, C, L = unpack(select(2, ...))

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if IsAddOnLoaded("ls_Toasts") then

		local LST = unpack(ls_Toasts)
		LST:RegisterSkin("FreeUI.Fluffy", function(toast)

			toast.Border:SetAlpha(0)
			toast.TextBG:SetAlpha(.5)
			toast.BG:SetAlpha(.7)

			if not toast.skinned then
				local bg = toast:CreateTexture(nil, 'BACKGROUND', nil, -1)
				bg:SetPoint('TOPLEFT', toast, 1, -1)
				bg:SetPoint('BOTTOMRIGHT', toast, -1, 1)
				bg:SetColorTexture(0, 0, 0, .7)

				-- local tr = toast:CreateTexture(nil, 'BACKGROUND', nil, -2)
				-- tr:SetPoint('TOPLEFT', toast, 1, -1)
				-- tr:SetPoint('BOTTOMRIGHT', toast, -1, 1)
				-- tr:SetColorTexture(0, 0, 0, 1)

				F.CreateSD(toast)

				toast.skinned = true
			end

			toast.Icon:SetTexCoord(.08, .92, .08, .92)

			-- toast.Title:SetFont([[]], 11)

			if toast.IconBorder then
				local r, g, b = toast.IconBorder:GetVertexColor()
				if r > 0.99 and g > 0.99 and b > 0.99 then
					toast.IconBorder:SetVertexColor(0.1, 0.1, 0.1, 1)
				end
				toast.IconBorder:SetTexture([[Interface\AddOns\FreeUI\media\border.tga]])
				toast.IconBorder:SetTexCoord(0, 1, 0, 1)
			end
		end)
		LST:SetSkin("FreeUI.Fluffy")
	end
end)