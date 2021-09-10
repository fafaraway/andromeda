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
    if C.IsNewPatch then
        hooksecurefunc(
            _G.ItemUpgradeFrame,
            'Update',
            function(self)
                if self.upgradeInfo then
                    self.UpgradeItemButton:SetPushedTexture(nil)
                end
            end
        )

        local bg = F.CreateBDFrame(_G.ItemUpgradeFrame, .25)
        bg:SetPoint('TOPLEFT', 20, -25)
        bg:SetPoint('BOTTOMRIGHT', -20, 375)

        local itemButton = _G.ItemUpgradeFrame.UpgradeItemButton
        itemButton.ButtonFrame:Hide()
        itemButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
        itemButton.bg = F.ReskinIcon(itemButton.icon)
        F.ReskinIconBorder(itemButton.IconBorder)

        F.ReskinDropDown(_G.ItemUpgradeFrame.ItemInfo.Dropdown)
        F.Reskin(_G.ItemUpgradeFrame.UpgradeButton)
        _G.ItemUpgradeFramePlayerCurrenciesBorder:Hide()

        F.CreateBDFrame(_G.ItemUpgradeFrameLeftItemPreviewFrame, .25)
        _G.ItemUpgradeFrameLeftItemPreviewFrame.NineSlice:SetAlpha(0)
        F.CreateBDFrame(_G.ItemUpgradeFrameRightItemPreviewFrame, .25)
        _G.ItemUpgradeFrameRightItemPreviewFrame.NineSlice:SetAlpha(0)

        hooksecurefunc(_G.ItemUpgradeFrame.UpgradeCostFrame, 'GetIconFrame', reskinCurrencyIcon)
        hooksecurefunc(_G.ItemUpgradeFrame.PlayerCurrencies, 'GetIconFrame', reskinCurrencyIcon)
    else
        local itemButton = _G.ItemUpgradeFrame.ItemButton
        itemButton.bg = F.CreateBDFrame(itemButton, .25)
        itemButton.Frame:SetTexture('')
        itemButton:SetPushedTexture('')
        local hl = itemButton:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, .25)

        hooksecurefunc(
            'ItemUpgradeFrame_Update',
            function()
                local icon, _, quality = GetItemUpgradeItemInfo()
                if icon then
                    itemButton.IconTexture:SetTexCoord(unpack(C.TexCoord))
                    local color = C.QualityColors[quality or 1]
                    itemButton.bg:SetBackdropBorderColor(color.r, color.g, color.b)
                else
                    itemButton.IconTexture:SetTexture('')
                    itemButton.bg:SetBackdropBorderColor(0, 0, 0)
                end
            end
        )

        local textFrame = _G.ItemUpgradeFrame.TextFrame
        F.StripTextures(textFrame)
        local bg = F.CreateBDFrame(textFrame, .25)
        bg:SetPoint('TOPLEFT', itemButton.IconTexture, 'TOPRIGHT', 3, C.mult)
        bg:SetPoint('BOTTOMRIGHT', -6, 2)

        F.StripTextures(_G.ItemUpgradeFrame.ButtonFrame)
        F.StripTextures(_G.ItemUpgradeFrameMoneyFrame)
        F.ReskinIcon(_G.ItemUpgradeFrameMoneyFrame.Currency.icon)
        F.Reskin(_G.ItemUpgradeFrameUpgradeButton)
        F.ReskinDropDown(_G.ItemUpgradeFrame.UpgradeLevelDropDown.DropDownMenu)
        _G.ItemUpgradeFrame.StatsScrollBar:SetAlpha(0)
    end
end
