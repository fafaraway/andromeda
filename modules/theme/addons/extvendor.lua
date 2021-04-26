local _G = _G
local unpack = unpack
local select = select
local IsAddOnLoaded = IsAddOnLoaded


local F, C = unpack(select(2, ...))
local THEME = F.THEME

function THEME:ReskinExtVendor()
    if not IsAddOnLoaded('ExtVendor') then
        return
    end

    if not _G.FREE_ADB.ReskinExtVendor then
        return
    end

    -- MerchantFrame
    F.Reskin(MerchantFrameFilterButton)
    F.ReskinInput(MerchantFrameSearchBox)

    MerchantFrameSellJunkButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
    MerchantFrameSellJunkButton:SetPushedTexture('')
    F.ReskinIcon(MerchantFrameSellJunkButtonIcon)

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

        name:SetFontObject(Number12Font)
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
    F.SetBD(ExtVendor_QVConfigFrame)
    ExtVendor_QVConfigFrameDarkenBG:SetAlpha(0)
    F.ReskinClose(ExtVendor_QVConfigFrameCloseButton)
    F.Reskin(ExtVendor_QVConfigFrame_OptionContainer_SaveButton)

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

    F.StripTextures(ExtVendor_SellJunkPopup)
    F.SetBD(ExtVendor_SellJunkPopup)
    ExtVendor_SellJunkPopupBG2:SetAlpha(0)
    F.Reskin(ExtVendor_SellJunkPopupYesButton)
    F.Reskin(ExtVendor_SellJunkPopupNoButton)
    F.Reskin(ExtVendor_SellJunkPopupDebugButton)
    F.StripTextures(ExtVendor_SellJunkPopup_JunkList)
    F.CreateBDFrame(ExtVendor_SellJunkPopup_JunkList, .25)
    F.ReskinScroll(ExtVendor_SellJunkPopup_JunkListItemListScrollBar)
    ExtVendor_SellJunkPopup_JunkListItemListScrollBar.trackBG:SetAlpha(0)
end
