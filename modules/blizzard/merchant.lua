local F, C = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local OLD_MERCHANT_ITEMS_PER_PAGE = 10

function BLIZZARD:UpdateMerchantItemPos()
    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        local button = _G['MerchantItem' .. i]
        button:Show()
        button:ClearAllPoints()

        if (i % OLD_MERCHANT_ITEMS_PER_PAGE) == 1 then
            if i == 1 then
                button:SetPoint('TOPLEFT', _G.MerchantFrame, 'TOPLEFT', 24, -70)
            else
                button:SetPoint(
                    'TOPLEFT',
                    _G['MerchantItem' .. (i - (OLD_MERCHANT_ITEMS_PER_PAGE - 1))],
                    'TOPRIGHT',
                    12,
                    0
                )
            end
        else
            if (i % 2) == 1 then
                button:SetPoint('TOPLEFT', _G['MerchantItem' .. (i - 2)], 'BOTTOMLEFT', 0, -16)
            else
                button:SetPoint('TOPLEFT', _G['MerchantItem' .. (i - 1)], 'TOPRIGHT', 12, 0)
            end
        end
    end
end

function BLIZZARD:UpdateBuybackItemPos()
    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        local button = _G['MerchantItem' .. i]
        button:ClearAllPoints()

        if i > _G.BUYBACK_ITEMS_PER_PAGE then
            button:Hide()
        else
            if i == 1 then
                button:SetPoint('TOPLEFT', _G.MerchantFrame, 'TOPLEFT', 64, -105)
            else
                if (i % 3) == 1 then
                    button:SetPoint('TOPLEFT', _G['MerchantItem' .. (i - 3)], 'BOTTOMLEFT', 0, -30)
                else
                    button:SetPoint('TOPLEFT', _G['MerchantItem' .. (i - 1)], 'TOPRIGHT', 50, 0)
                end
            end
        end
    end
end

function BLIZZARD:RestyleElemennts()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    for i = 13, _G.MERCHANT_ITEMS_PER_PAGE do
        local item = _G['MerchantItem' .. i]
        local name = item.Name
        local button = item.ItemButton
        local icon = button.icon
        local moneyFrame = _G['MerchantItem' .. i .. 'MoneyFrame']

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

        for j = 1, 3 do
            local currency = _G['MerchantItem' .. i .. 'AltCurrencyFrameItem' .. j]
            local texture = _G['MerchantItem' .. i .. 'AltCurrencyFrameItem' .. j .. 'Texture']
            currency:SetPoint('BOTTOMLEFT', button, 'BOTTOMRIGHT', 3, 0)
            F.ReskinIcon(texture)
        end
    end
end

function BLIZZARD:EnhancedMerchant()
    if IsAddOnLoaded('ExtVendor') then
        return
    end
    if not C.DB.General.EnhancedMerchant then
        return
    end

    _G.MERCHANT_ITEMS_PER_PAGE = 20
    _G.MerchantFrame:SetWidth(690)

    for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
        if not _G['MerchantItem' .. i] then
            CreateFrame('Frame', 'MerchantItem' .. i, _G.MerchantFrame, 'MerchantItemTemplate')
        end
    end

    _G.MerchantBuyBackItem:ClearAllPoints()
    _G.MerchantBuyBackItem:SetPoint('TOPLEFT', _G.MerchantItem10, 'BOTTOMLEFT', -14, -20)
    _G.MerchantPrevPageButton:ClearAllPoints()
    _G.MerchantPrevPageButton:SetPoint('CENTER', _G.MerchantFrame, 'BOTTOM', 30, 55)
    _G.MerchantPageText:ClearAllPoints()
    _G.MerchantPageText:SetPoint('BOTTOM', _G.MerchantFrame, 'BOTTOM', 160, 50)
    _G.MerchantNextPageButton:ClearAllPoints()
    _G.MerchantNextPageButton:SetPoint('CENTER', _G.MerchantFrame, 'BOTTOM', 290, 55)

    hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
        BLIZZARD:UpdateMerchantItemPos()
    end)

    hooksecurefunc('MerchantFrame_UpdateBuybackInfo', function()
        BLIZZARD:UpdateBuybackItemPos()
    end)

    BLIZZARD:RestyleElemennts()
end
