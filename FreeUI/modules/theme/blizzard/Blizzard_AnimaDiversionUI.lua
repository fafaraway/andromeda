local F, C = unpack(select(2, ...))

C.Themes["Blizzard_AnimaDiversionUI"] = function()
	local frame = AnimaDiversionFrame

	F.StripTextures(frame)
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	frame.AnimaDiversionCurrencyFrame.Background:SetAlpha(0)
	F.ReskinIcon(frame.AnimaDiversionCurrencyFrame.CurrencyFrame.CurrencyIcon)

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

	F.Reskin(frame.ReinforceInfoFrame.AnimaNodeReinforceButton)
end
