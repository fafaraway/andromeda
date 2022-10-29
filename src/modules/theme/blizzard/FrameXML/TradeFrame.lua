local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    _G.TradePlayerEnchantInset:Hide()
    _G.TradePlayerItemsInset:Hide()
    _G.TradeRecipientEnchantInset:Hide()
    _G.TradeRecipientItemsInset:Hide()
    _G.TradePlayerInputMoneyInset:Hide()
    _G.TradeRecipientMoneyInset:Hide()
    _G.TradeRecipientBG:Hide()
    _G.TradeRecipientMoneyBg:Hide()
    _G.TradeRecipientBotLeftCorner:Hide()
    _G.TradeRecipientLeftBorder:Hide()
    select(4, _G.TradePlayerItem7:GetRegions()):Hide()
    select(4, _G.TradeRecipientItem7:GetRegions()):Hide()

    F.ReskinPortraitFrame(_G.TradeFrame)
    _G.TradeFrame.RecipientOverlay:Hide()
    F.Reskin(_G.TradeFrameTradeButton)
    F.Reskin(_G.TradeFrameCancelButton)
    F.ReskinInput(_G.TradePlayerInputMoneyFrameGold)
    F.ReskinInput(_G.TradePlayerInputMoneyFrameSilver)
    F.ReskinInput(_G.TradePlayerInputMoneyFrameCopper)

    _G.TradePlayerInputMoneyFrameSilver:SetPoint('LEFT', _G.TradePlayerInputMoneyFrameGold, 'RIGHT', 1, 0)
    _G.TradePlayerInputMoneyFrameCopper:SetPoint('LEFT', _G.TradePlayerInputMoneyFrameSilver, 'RIGHT', 1, 0)

    local function reskinButton(bu)
        bu:SetNormalTexture(0)
        bu:SetPushedTexture(0)
        local hl = bu:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, 0.25)
        hl:SetInside()
        bu.icon:SetTexCoord(unpack(C.TEX_COORD))
        bu.icon:SetInside()
        bu.IconOverlay:SetInside()
        bu.IconOverlay2:SetInside()
        bu.bg = F.CreateBDFrame(bu.icon, 0.25)
        F.ReskinIconBorder(bu.IconBorder)
    end

    for i = 1, _G.MAX_TRADE_ITEMS do
        _G['TradePlayerItem' .. i .. 'SlotTexture']:Hide()
        _G['TradePlayerItem' .. i .. 'NameFrame']:Hide()
        _G['TradeRecipientItem' .. i .. 'SlotTexture']:Hide()
        _G['TradeRecipientItem' .. i .. 'NameFrame']:Hide()

        reskinButton(_G['TradePlayerItem' .. i .. 'ItemButton'])
        reskinButton(_G['TradeRecipientItem' .. i .. 'ItemButton'])
    end

    local tradeHighlights = {
        _G.TradeHighlightPlayer,
        _G.TradeHighlightPlayerEnchant,
        _G.TradeHighlightRecipient,
        _G.TradeHighlightRecipientEnchant,
    }
    for _, highlight in pairs(tradeHighlights) do
        F.StripTextures(highlight)
        highlight:SetFrameStrata('HIGH')
        local bg = F.CreateBDFrame(highlight, 0.25)
        bg:SetBackdropColor(0, 1, 0, 0.15)
    end
end)
