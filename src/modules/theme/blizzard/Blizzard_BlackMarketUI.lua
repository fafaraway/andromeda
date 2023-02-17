local F, C = unpack(select(2, ...))

C.Themes['Blizzard_BlackMarketUI'] = function()
    local r, g, b = C.r, C.g, C.b
    local BlackMarketFrame = _G.BlackMarketFrame

    F.StripTextures(BlackMarketFrame)
    BlackMarketFrame.MoneyFrameBorder:SetAlpha(0)
    F.StripTextures(BlackMarketFrame.HotDeal)
    F.CreateBDFrame(BlackMarketFrame.HotDeal.Item)
    BlackMarketFrame.HotDeal.Item.IconTexture:SetTexCoord(unpack(C.TEX_COORD))

    local headers = {
        'ColumnName',
        'ColumnLevel',
        'ColumnType',
        'ColumnDuration',
        'ColumnHighBidder',
        'ColumnCurrentBid',
    }
    for _, v in pairs(headers) do
        local header = BlackMarketFrame[v]
        F.StripTextures(header)
        local bg = F.CreateBDFrame(header, 0.25)
        bg:SetPoint('TOPLEFT', 2, 0)
        bg:SetPoint('BOTTOMRIGHT', -1, 0)
    end

    F.SetBD(BlackMarketFrame)
    F.CreateBDFrame(BlackMarketFrame.HotDeal, 0.25)
    F.Reskin(BlackMarketFrame.BidButton)
    F.ReskinClose(BlackMarketFrame.CloseButton)
    F.ReskinEditBox(_G.BlackMarketBidPriceGold)
    F.ReskinTrimScroll(BlackMarketFrame.ScrollBar)

    hooksecurefunc(BlackMarketFrame.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local bu = select(i, self.ScrollTarget:GetChildren())
            bu.Item.IconTexture:SetTexCoord(unpack(C.TEX_COORD))
            if not bu.reskinned then
                F.StripTextures(bu)

                bu.Item:SetNormalTexture(0)
                bu.Item:SetPushedTexture(0)
                bu.Item:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                F.CreateBDFrame(bu.Item)
                bu.Item.IconBorder:SetAlpha(0)

                local bg = F.CreateBDFrame(bu, 0.25)
                bg:SetPoint('TOPLEFT', bu.Item, 'TOPRIGHT', 3, C.MULT)
                bg:SetPoint('BOTTOMRIGHT', 0, 4)

                bu:SetHighlightTexture(C.Assets.Textures.Backdrop)
                local hl = bu:GetHighlightTexture()
                hl:SetVertexColor(r, g, b, 0.2)
                hl.SetAlpha = nop
                hl:ClearAllPoints()
                hl:SetAllPoints(bg)

                bu.Selection:ClearAllPoints()
                bu.Selection:SetAllPoints(bg)
                bu.Selection:SetTexture(C.Assets.Textures.Backdrop)
                bu.Selection:SetVertexColor(r, g, b, 0.1)

                bu.reskinned = true
            end

            if bu:IsShown() and bu.itemLink then
                local _, _, quality = GetItemInfo(bu.itemLink)
                local r, g, b = GetItemQualityColor(quality or 1)

                bu.Name:SetTextColor(r, g, b)
            end
        end
    end)

    hooksecurefunc('BlackMarketFrame_UpdateHotItem', function(self)
        local hotDeal = self.HotDeal
        if hotDeal:IsShown() and hotDeal.itemLink then
            local _, _, quality = GetItemInfo(hotDeal.itemLink)
            local r, g, b = GetItemQualityColor(quality or 1)

            hotDeal.Name:SetTextColor(r, g, b)
        end

        hotDeal.Item.IconBorder:Hide()
    end)
end
