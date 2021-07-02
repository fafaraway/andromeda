local _G = _G
local unpack = unpack
local select = select
local hooksecurefunc = hooksecurefunc
local GetItemUpgradeItemInfo = GetItemUpgradeItemInfo

local F, C = unpack(select(2, ...))

C.Themes['Blizzard_ItemUpgradeUI'] = function()
    local ItemUpgradeFrame = _G.ItemUpgradeFrame
    F.ReskinPortraitFrame(ItemUpgradeFrame)

    local itemButton = ItemUpgradeFrame.ItemButton
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

    local textFrame = ItemUpgradeFrame.TextFrame
    F.StripTextures(textFrame)
    local bg = F.CreateBDFrame(textFrame, .25)
    bg:SetPoint('TOPLEFT', itemButton.IconTexture, 'TOPRIGHT', 3, C.Mult)
    bg:SetPoint('BOTTOMRIGHT', -6, 2)

    F.StripTextures(ItemUpgradeFrame.ButtonFrame)
    F.StripTextures(_G.ItemUpgradeFrameMoneyFrame)
    F.ReskinIcon(_G.ItemUpgradeFrameMoneyFrame.Currency.icon)
    F.Reskin(_G.ItemUpgradeFrameUpgradeButton)

    F.ReskinDropDown(ItemUpgradeFrame.UpgradeLevelDropDown.DropDownMenu)
end
