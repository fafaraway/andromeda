local F = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

function THEME:ReskinExtVendor()
    if not IsAddOnLoaded('ExtVendor') then
        return
    end

    if not _G.FREE_ADB.ReskinAddons then
        return
    end

    -- MerchantFrame
    F.Reskin(_G.MerchantFrameFilterButton)
    F.ReskinInput(_G.MerchantFrameSearchBox)

    _G.MerchantFrameSellJunkButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
    _G.MerchantFrameSellJunkButton:SetPushedTexture('')
    F.ReskinIcon(_G.MerchantFrameSellJunkButtonIcon)

    for i = 13, 20 do
        local item = _G['MerchantItem' .. i]
        local name = item.Name
        local button = item.ItemButton
        local icon = button.icon
        local moneyFrame = _G['MerchantItem' .. i .. 'MoneyFrame']

        F.StripTextures(item)
        F.CreateBDFrame(item, .25)

        F.StripTextures(button)
        button.IconBorder:SetAlpha(0)
        button:ClearAllPoints()
        button:SetPoint('LEFT', item, 4, 0)

        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, .25)
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

    -- ExtVendor_QVConfigFrame
    F.SetBD(_G.ExtVendor_QVConfigFrame)
    _G.ExtVendor_QVConfigFrameDarkenBG:SetAlpha(0)
    F.ReskinClose(_G.ExtVendor_QVConfigFrameCloseButton)
    F.Reskin(_G.ExtVendor_QVConfigFrame_OptionContainer_SaveButton)

    local checks = {
        'EnableButton',
        'SuboptimalArmor',
        'AlreadyKnown',
        'UnusableEquip',
        'WhiteGear',
        'OutdatedGear',
        'OutdatedFood',
    }
    for _, check in pairs(checks) do
        F.ReskinCheck(_G['ExtVendor_QVConfigFrame_OptionContainer_' .. check])
    end

    local buttons = {
        'RemoveFromBlacklistButton',
        'ResetBlacklistButton',
        'RemoveFromGlobalWhitelistButton',
        'ClearGlobalWhitelistButton',
        'RemoveFromLocalWhitelistButton',
        'ClearLocalWhitelistButton',
        'ItemDropBlacklistButton',
        'ItemDropGlobalWhitelistButton',
        'ItemDropLocalWhitelistButton',
    }
    for _, button in pairs(buttons) do
        F.Reskin(_G['ExtVendor_QVConfigFrame_' .. button])
    end

    local frames = {'Blacklist', 'GlobalWhitelist', 'LocalWhitelist'}
    for _, frame in pairs(frames) do
        local frame1 = _G['ExtVendor_QVConfigFrame_' .. frame]
        local frame2 = _G['ExtVendor_QVConfigFrame_' .. frame .. 'ItemList']
        F.StripTextures(frame1)
        local bg = F.CreateBDFrame(frame1, 0)
        bg:SetOutside(frame2)

        local scrollBar = _G['ExtVendor_QVConfigFrame_' .. frame .. 'ItemListScrollBar']
        F.ReskinScroll(scrollBar)
        scrollBar.trackBG:SetAlpha(0)
    end

    F.StripTextures(_G.ExtVendor_SellJunkPopup)
    F.SetBD(_G.ExtVendor_SellJunkPopup)
    _G.ExtVendor_SellJunkPopupBG2:SetAlpha(0)
    F.Reskin(_G.ExtVendor_SellJunkPopupYesButton)
    F.Reskin(_G.ExtVendor_SellJunkPopupNoButton)
    F.Reskin(_G.ExtVendor_SellJunkPopupDebugButton)
    F.StripTextures(_G.ExtVendor_SellJunkPopup_JunkList)
    F.CreateBDFrame(_G.ExtVendor_SellJunkPopup_JunkList, .25)
    F.ReskinScroll(_G.ExtVendor_SellJunkPopup_JunkListItemListScrollBar)
    _G.ExtVendor_SellJunkPopup_JunkListItemListScrollBar.trackBG:SetAlpha(0)
end
