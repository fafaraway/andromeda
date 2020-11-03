local F, C = unpack(select(2, ...))

local function replaceIconString(self, text)
	if not text then text = self:GetText() end
	if not text or text == "" then return end

	local newText, count = gsub(text, "|T([^:]-):[%d+:]+|t", "|T%1:14:14:0:0:64:64:5:59:5:59|t")
	if count > 0 then self:SetFormattedText("%s", newText) end
end

C.Themes["Blizzard_AnimaDiversionUI"] = function()
	local frame = AnimaDiversionFrame

	F.StripTextures(frame)
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	frame.AnimaDiversionCurrencyFrame.Background:SetAlpha(0)

	local currencyFrame = frame.AnimaDiversionCurrencyFrame.CurrencyFrame
	if C.isNewPatch then
		replaceIconString(currencyFrame.Quantity)
		hooksecurefunc(currencyFrame.Quantity, "SetText", replaceIconString)
	else
		F.ReskinIcon(currencyFrame.CurrencyIcon)
	end

	if not C.isNewPatch then
		local infoFrame = frame.SelectPinInfoFrame
		F.StripTextures(infoFrame)
		local bg = F.SetBD(infoFrame)
		bg.__shadow:SetFrameLevel(infoFrame:GetFrameLevel()-1)
		F.Reskin(infoFrame.SelectButton)
		F.ReskinClose(infoFrame.CloseButton)

		hooksecurefunc(infoFrame, "SetupCosts", function(self)
			for currency in self.currencyPool:EnumerateActive() do
				if not currency.bg then
					currency.bg = F.ReskinIcon(currency.CurrencyIcon)
				end
			end
		end)
	end

	F.Reskin(frame.ReinforceInfoFrame.AnimaNodeReinforceButton)
end
