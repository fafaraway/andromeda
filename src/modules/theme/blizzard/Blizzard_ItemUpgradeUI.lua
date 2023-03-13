local F, C = unpack(select(2, ...))

local function reskinCurrencyIcon(self)
    for frame in self.iconPool:EnumerateActive() do
        if not frame.bg then
            frame.bg = F.ReskinIcon(frame.Icon)
            frame.bg:SetFrameLevel(2)
        end
    end
end

C.Themes['Blizzard_ItemUpgradeUI'] = function()
    local ItemUpgradeFrame = _G.ItemUpgradeFrame
    F.ReskinPortraitFrame(ItemUpgradeFrame)

    hooksecurefunc(ItemUpgradeFrame, 'Update', function(self)
        if self.upgradeInfo then
            self.UpgradeItemButton:SetPushedTexture(0)
        end
    end)

    local bg = F.CreateBDFrame(ItemUpgradeFrame, 0.25)
    bg:SetPoint('TOPLEFT', 20, -25)
    bg:SetPoint('BOTTOMRIGHT', -20, 375)

    local itemButton = _G.ItemUpgradeFrame.UpgradeItemButton
    itemButton.ButtonFrame:Hide()
    itemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    itemButton.bg = F.ReskinIcon(itemButton.icon)
    F.ReskinIconBorder(itemButton.IconBorder)

    F.ReskinDropdown(ItemUpgradeFrame.ItemInfo.Dropdown)
    F.ReskinButton(ItemUpgradeFrame.UpgradeButton)
    _G.ItemUpgradeFramePlayerCurrenciesBorder:Hide()

    F.CreateBDFrame(_G.ItemUpgradeFrameLeftItemPreviewFrame, 0.25)
    _G.ItemUpgradeFrameLeftItemPreviewFrame.NineSlice:SetAlpha(0)
    F.CreateBDFrame(_G.ItemUpgradeFrameRightItemPreviewFrame, 0.25)
    _G.ItemUpgradeFrameRightItemPreviewFrame.NineSlice:SetAlpha(0)

    hooksecurefunc(ItemUpgradeFrame.UpgradeCostFrame, 'GetIconFrame', reskinCurrencyIcon)
    hooksecurefunc(ItemUpgradeFrame.PlayerCurrencies, 'GetIconFrame', reskinCurrencyIcon)

    local TT = F:GetModule('Tooltip')
    TT.ReskinTooltip(ItemUpgradeFrame.ItemHoverPreviewFrame)
end
