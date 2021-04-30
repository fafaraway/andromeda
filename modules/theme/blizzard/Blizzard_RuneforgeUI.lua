local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local function updateSelectedTexture(texture, shown)
	local button = texture.__owner
	if shown then
		button.bg:SetBackdropBorderColor(1, .8, 0)
	else
		button.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function replaceCurrencyDisplay(self)
	if not self.currencyID then return end
	local text = GetCurrencyString(self.currencyID, self.amount, self.colorCode, self.abbreviate)
	local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
	if count > 0 then self:SetText(newText) end
end

local function SetCurrenciesHook(self)
	if self.currencyFramePool then
		for frame in self.currencyFramePool:EnumerateActive() do
			if not frame.hooked then
				replaceCurrencyDisplay(frame)
				hooksecurefunc(frame, "SetCurrencyFromID", replaceCurrencyDisplay)

				frame.hooked = true
			end
		end
	end
end

C.Themes["Blizzard_RuneforgeUI"] = function()
	local frame = RuneforgeFrame

	F.ReskinClose(frame.CloseButton, nil, -70, -70)

	local createFrame = frame.CreateFrame
	F.Reskin(createFrame.CraftItemButton)

	if not C.IsNewPatch then
		F.ReplaceIconString(createFrame.Cost.Text)
		hooksecurefunc(createFrame.Cost.Text, "SetText", F.ReplaceIconString)
	else
		hooksecurefunc(frame.CurrencyDisplay, "SetCurrencies", SetCurrenciesHook)
		hooksecurefunc(createFrame.Cost.Currencies, "SetCurrencies", SetCurrenciesHook)
	end

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
