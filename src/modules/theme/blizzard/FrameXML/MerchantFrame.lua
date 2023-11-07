local F, C = unpack(select(2, ...))

local function reskinMerchantItem(item)
    local name = item.Name
    local button = item.ItemButton
    local icon = button.icon
    local moneyFrame = _G[item:GetName() .. 'MoneyFrame']

    F.StripTextures(item)
    F.CreateBDFrame(item, 0.25)

    F.StripTextures(button)
    button:ClearAllPoints()
    button:SetPoint('LEFT', item, 4, 0)
    local hl = button:GetHighlightTexture()
    hl:SetColorTexture(1, 1, 1, 0.25)
    hl:SetInside()

    icon:SetInside()
    button.bg = F.ReskinIcon(icon)
    F.ReskinIconBorder(button.IconBorder)
    button.IconOverlay:SetInside()
    button.IconOverlay2:SetInside()

    name:SetFontObject(_G.Number12Font)
    name:SetPoint('LEFT', button, 'RIGHT', 2, 9)
    moneyFrame:SetPoint('BOTTOMLEFT', button, 'BOTTOMRIGHT', 3, 0)
end

local function reskinMerchantInteract(button)
    button:GetRegions():Hide()
	F.ReskinIcon(button.Icon)
    button:SetPushedTexture(0)
    button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
end

tinsert(C.BlizzThemes, function()
    F.ReskinPortraitFrame(_G.MerchantFrame)
    F.ReskinDropdown(_G.MerchantFrameLootFilter)
    F.StripTextures(_G.MerchantPrevPageButton)
    F.ReskinArrow(_G.MerchantPrevPageButton, 'left')
    F.StripTextures(_G.MerchantNextPageButton)
    F.ReskinArrow(_G.MerchantNextPageButton, 'right')
    _G.MerchantMoneyInset:Hide()
    _G.MerchantMoneyBg:Hide()
    _G.MerchantExtraCurrencyBg:SetAlpha(0)
    _G.MerchantExtraCurrencyInset:SetAlpha(0)
    _G.BuybackBG:SetAlpha(0)

    _G.MerchantFrameTab1:ClearAllPoints()
    _G.MerchantFrameTab1:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 50, -14)
	_G.MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)

    for i = 1, 2 do
        F.ReskinTab(_G['MerchantFrameTab' .. i])
    end

    for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
        local item = _G['MerchantItem' .. i]
        reskinMerchantItem(item)

        for j = 1, 3 do
            local currency = _G['MerchantItem' .. i .. 'AltCurrencyFrameItem' .. j]
            local texture = _G['MerchantItem' .. i .. 'AltCurrencyFrameItem' .. j .. 'Texture']
            currency:SetPoint('BOTTOMLEFT', item.ItemButton, 'BOTTOMRIGHT', 3, 0)
            F.ReskinIcon(texture)
        end
    end

    _G.MerchantBuyBackItem:SetHeight(44)

    reskinMerchantItem(_G.MerchantBuyBackItem)
	reskinMerchantInteract(_G.MerchantGuildBankRepairButton)
	reskinMerchantInteract(_G.MerchantRepairAllButton)
	reskinMerchantInteract(_G.MerchantRepairItemButton)
	reskinMerchantInteract(_G.MerchantSellAllJunkButton)

    local ic = _G.MerchantRepairItemButton:GetRegions()
    ic:SetTexture('Interface\\Icons\\INV_Hammer_20')
    ic:SetTexCoord(unpack(C.TEX_COORD))

    hooksecurefunc('MerchantFrame_UpdateCurrencies', function()
        for i = 1, _G.MAX_MERCHANT_CURRENCIES do
            local bu = _G['MerchantToken' .. i]
            if bu and not bu.styled then
                local icon = _G['MerchantToken' .. i .. 'Icon']
                if icon then
                    F.ReskinIcon(icon)
                end

                local count = _G['MerchantToken' .. i .. 'Count']
                if count then
                    count:SetPoint('TOPLEFT', bu, 'TOPLEFT', -2, 0) -- needs reveiw
                end

                bu.styled = true
            end
        end
    end)

    -- StackSplitFrame
    F.StripTextures(_G.StackSplitFrame)
    F.SetBD(_G.StackSplitFrame)
    F.ReskinButton(_G.StackSplitFrame.OkayButton)
    F.ReskinButton(_G.StackSplitFrame.CancelButton)
    F.ReskinArrow(_G.StackSplitFrame.LeftButton, 'left')
    F.ReskinArrow(_G.StackSplitFrame.RightButton, 'right')
end)
