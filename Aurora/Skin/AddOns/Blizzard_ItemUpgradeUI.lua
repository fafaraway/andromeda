local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_ItemUpgradeUI()
    local ItemUpgradeFrame = _G.ItemUpgradeFrame
    local ItemButton = ItemUpgradeFrame.ItemButton

    ItemUpgradeFrame:DisableDrawLayer("BACKGROUND")
    ItemUpgradeFrame:DisableDrawLayer("BORDER")
    _G.ItemUpgradeFrameMoneyFrameLeft:Hide()
    _G.ItemUpgradeFrameMoneyFrameMiddle:Hide()
    _G.ItemUpgradeFrameMoneyFrameRight:Hide()
    ItemUpgradeFrame.ButtonFrame:GetRegions():Hide()
    ItemUpgradeFrame.ButtonFrame.ButtonBorder:Hide()
    ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:Hide()
    ItemButton.Frame:Hide()
    ItemButton.Grabber:Hide()
    ItemButton.TextFrame:Hide()
    ItemButton.TextGrabber:Hide()

    F.CreateBD(ItemButton, .25)
    ItemButton:SetHighlightTexture("")
    ItemButton:SetPushedTexture("")
    ItemButton.IconTexture:SetPoint("TOPLEFT", 1, -1)
    ItemButton.IconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

    local btnBG = _G.CreateFrame("Frame", nil, ItemButton)
    btnBG:SetSize(341, 50)
    btnBG:SetPoint("LEFT", ItemButton, "RIGHT", -1, 0)
    btnBG:SetFrameLevel(ItemButton:GetFrameLevel()-1)
    F.CreateBD(btnBG, .25)

    ItemButton:HookScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, .56, .85)
    end)
    ItemButton:HookScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0, 0, 0)
    end)

    ItemButton.Cost.Icon:SetTexCoord(.08, .92, .08, .92)
    ItemButton.Cost.Icon.bg = F.CreateBG(ItemButton.Cost.Icon)

    _G.hooksecurefunc("ItemUpgradeFrame_Update", function()
        if _G.GetItemUpgradeItemInfo() then
            ItemButton.IconTexture:SetTexCoord(.08, .92, .08, .92)
            ItemButton.Cost.Icon.bg:Show()
        else
            ItemButton.IconTexture:SetTexture("")
            ItemButton.Cost.Icon.bg:Hide()
        end
    end)

    local currency = _G.ItemUpgradeFrameMoneyFrame.Currency
    currency.icon:SetPoint("LEFT", currency.count, "RIGHT", 1, 0)
    currency.icon:SetTexCoord(.08, .92, .08, .92)
    F.CreateBG(currency.icon)

    local frameBG = _G.CreateFrame("Frame", nil, ItemUpgradeFrame)
    frameBG:SetAllPoints(ItemUpgradeFrame)
    frameBG:SetFrameLevel(ItemUpgradeFrame:GetFrameLevel()-1)
    F.CreateBD(frameBG)

    F.ReskinPortraitFrame(ItemUpgradeFrame)
    F.CreateBD(ItemUpgradeFrame)
    F.CreateSD(ItemUpgradeFrame)
    F.Reskin(_G.ItemUpgradeFrameUpgradeButton)
end
