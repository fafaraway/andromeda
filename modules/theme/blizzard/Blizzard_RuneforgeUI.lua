local F, C = unpack(select(2, ...))
local TOOLTIP = F.TOOLTIP

local function updateSelectedTexture(texture, shown)
	local button = texture.__owner
	if shown then
		button.bg:SetBackdropBorderColor(1, .8, 0)
	else
		button.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

C.Themes["Blizzard_RuneforgeUI"] = function()
	local frame = RuneforgeFrame

	F.ReskinClose(frame.CloseButton, nil, -70, -70)
	F.Reskin(frame.CreateFrame.CraftItemButton)

	local powerFrame = frame.CraftingFrame.PowerFrame
	F.StripTextures(powerFrame)
	F.SetBD(powerFrame, 1)

	hooksecurefunc(powerFrame.PowerList, "RefreshListDisplay", function(self)
		if not self.elements then return end

		for i = 1, self:GetNumElementFrames() do
			local button = self.elements[i]
			if button and not button.bg then
				button.Border:SetAlpha(0)
				button.CircleMask:Hide()
				button.bg = F.ReskinIcon(button.Icon)
				button.SelectedTexture:SetTexture("")
				button.SelectedTexture.__owner = button
				hooksecurefunc(button.SelectedTexture, "SetShown", updateSelectedTexture)
			end
		end
	end)

	local pageControl = powerFrame.PageControl
	F.ReskinArrow(pageControl.BackwardButton, "left")
	F.ReskinArrow(pageControl.ForwardButton, "right")

	TOOLTIP.ReskinTooltip(frame.ResultTooltip)
end
