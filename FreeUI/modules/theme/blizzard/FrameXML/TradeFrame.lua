local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	TradePlayerEnchantInset:Hide()
	TradePlayerItemsInset:Hide()
	TradeRecipientEnchantInset:Hide()
	TradeRecipientItemsInset:Hide()
	TradePlayerInputMoneyInset:Hide()
	TradeRecipientMoneyInset:Hide()
	TradeRecipientBG:Hide()
	TradeRecipientMoneyBg:Hide()
	TradeRecipientBotLeftCorner:Hide()
	TradeRecipientLeftBorder:Hide()
	select(4, TradePlayerItem7:GetRegions()):Hide()
	select(4, TradeRecipientItem7:GetRegions()):Hide()

	F.ReskinPortraitFrame(TradeFrame)
	TradeFrame.RecipientOverlay:Hide()
	F.Reskin(TradeFrameTradeButton)
	F.Reskin(TradeFrameCancelButton)
	F.ReskinInput(TradePlayerInputMoneyFrameGold)
	F.ReskinInput(TradePlayerInputMoneyFrameSilver)
	F.ReskinInput(TradePlayerInputMoneyFrameCopper)

	TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	local function reskinButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		local hl = bu:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetInside()
		bu.icon:SetTexCoord(unpack(C.TexCoord))
		bu.icon:SetInside()
		bu.IconOverlay:SetInside()
		bu.IconOverlay2:SetInside()
		bu.bg = F.CreateBDFrame(bu.icon, .25)
		F.ReskinIconBorder(bu.IconBorder)
	end

	for i = 1, MAX_TRADE_ITEMS do
		_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
		_G["TradePlayerItem"..i.."NameFrame"]:Hide()
		_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
		_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

		reskinButton(_G["TradePlayerItem"..i.."ItemButton"])
		reskinButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end

	local tradeHighlights = {
		TradeHighlightPlayer,
		TradeHighlightPlayerEnchant,
		TradeHighlightRecipient,
		TradeHighlightRecipientEnchant,
	}
	for _, highlight in pairs(tradeHighlights) do
		F.StripTextures(highlight)
		highlight:SetFrameStrata("HIGH")
		local bg = F.CreateBDFrame(highlight, .25)
		bg:SetBackdropColor(0, 1, 0, .15)
	end
end)
