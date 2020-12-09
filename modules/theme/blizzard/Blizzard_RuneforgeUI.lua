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

local function replaceIconString(self, text)
	if not text then text = self:GetText() end
	if not text or text == "" then return end

	local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
	if count > 0 then self:SetFormattedText("%s", newText) end
end

C.Themes["Blizzard_RuneforgeUI"] = function()
	local frame = RuneforgeFrame

	hooksecurefunc(frame, "RefreshCurrencyDisplay", function(self)
		for currencyFrame in self.CurrencyDisplay.currencyFramePool:EnumerateActive() do
			if not currencyFrame.hooked then
				replaceIconString(currencyFrame.Text)
				hooksecurefunc(currencyFrame.Text, "SetText", replaceIconString)
				currencyFrame.hooked = true
			end
		end
	end)

	F.ReskinClose(frame.CloseButton, nil, -70, -70)

	local createFrame = frame.CreateFrame
	F.Reskin(createFrame.CraftItemButton)
	replaceIconString(createFrame.Cost.Text)
	hooksecurefunc(createFrame.Cost.Text, "SetText", replaceIconString)

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
