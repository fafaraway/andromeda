local _, private = ...

-- [[ Lua Globals ]]
-- luacheck: globals select

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local F, C = _G.unpack(private.Aurora)

local function GetItemQualityColor(link)
    if link then
        local _, _, quality = _G.GetItemInfo(link)
        if quality then
            return _G.GetItemQualityColor(quality)
        else
            return 1, 1, 1
        end
    else
        return 1, 1, 1
    end
end

-- do --[[ FrameXML\MoneyFrame.lua ]]
--     local numCurrencies = 0
--     function Hook.MerchantFrame_UpdateCurrencies()
--         for i = numCurrencies + 1, _G.MAX_MERCHANT_CURRENCIES do
--             local button = _G["MerchantToken"..i]
--             if button then
--                 Skin.BackpackTokenTemplate(button)
--                 numCurrencies = numCurrencies + 1
--             end
--         end
--     end
-- end

-- do --[[ FrameXML\MerchantFrame.xml ]]
--     function Skin.MerchantItemTemplate(frame)
--         local name = frame:GetName()
--         _G[name.."SlotTexture"]:Hide()
--         _G[name.."NameFrame"]:Hide()

--         _G.MerchantMoneyBg:Hide()
--         _G.MerchantExtraCurrencyBg:SetAlpha(0)

--         local bg = _G.CreateFrame("Frame", nil, frame)
--         bg:SetPoint("TOPLEFT", frame.ItemButton.icon, "TOPRIGHT", 2, 1)
--         bg:SetPoint("BOTTOMRIGHT", 0, -4)
--         Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())

--         frame.Name:ClearAllPoints()
--         frame.Name:SetPoint("TOPLEFT", bg, 2, -1)
--         frame.Name:SetPoint("BOTTOMRIGHT", bg, 0, 14)

--         Skin.ItemButtonTemplate(frame.ItemButton)
--         Skin.SmallAlternateCurrencyFrameTemplate(_G[name.."AltCurrencyFrame"])
--     end
-- end

-- function private.FrameXML.MerchantFrame()
--     _G.hooksecurefunc("MerchantFrame_UpdateCurrencies", Hook.MerchantFrame_UpdateCurrencies)

--     Skin.ButtonFrameTemplate(_G.MerchantFrame)
--     F.CreateBD(_G.MerchantFrame)
--     F.CreateSD(_G.MerchantFrame)
--     _G.BuybackBG:SetPoint("TOPLEFT")
--     _G.BuybackBG:SetPoint("BOTTOMRIGHT")

--     -- BlizzWTF: This should use the title text included in the template
--     _G.MerchantNameText:SetAllPoints(_G.MerchantFrame.TitleText)

--     _G.MerchantFrameBottomLeftBorder:SetAlpha(0)
--     _G.MerchantFrameBottomRightBorder:SetAlpha(0)

--     for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
--         Skin.MerchantItemTemplate(_G["MerchantItem"..i])
--     end

--     _G.MerchantRepairAllButton:SetPushedTexture("")
--     _G.MerchantRepairAllIcon:SetTexture([[Interface\Icons\Trade_BlackSmithing]])
--     Base.CropIcon(_G.MerchantRepairAllIcon, _G.MerchantRepairAllButton)

--     local repairItem = _G.MerchantRepairItemButton:GetRegions()
--     _G.MerchantRepairItemButton:SetPushedTexture("")
--     repairItem:SetTexture([[Interface\Icons\INV_Hammer_20]])
--     Base.CropIcon(repairItem, _G.MerchantRepairItemButton)

--     _G.MerchantGuildBankRepairButton:SetPushedTexture("")
--     _G.MerchantGuildBankRepairButtonIcon:SetTexture([[Interface\Icons\Trade_BlackSmithing]])
--     _G.MerchantGuildBankRepairButtonIcon:SetVertexColor(0.9, 0.8, 0)
--     Base.CropIcon(_G.MerchantGuildBankRepairButtonIcon, _G.MerchantGuildBankRepairButton)

--     do
--         local name = _G.MerchantBuyBackItem:GetName()
--         _G[name.."SlotTexture"]:Hide()
--         _G[name.."NameFrame"]:Hide()

--         local bg = _G.CreateFrame("Frame", nil, _G.MerchantBuyBackItem)
--         bg:SetPoint("TOPLEFT", _G.MerchantBuyBackItem.ItemButton.icon, "TOPRIGHT", 2, 1)
--         bg:SetPoint("BOTTOMRIGHT", 0, -1)
--         Base.SetBackdrop(bg, Aurora.frameColor:GetRGBA())

--         _G.MerchantBuyBackItem.Name:ClearAllPoints()
--         _G.MerchantBuyBackItem.Name:SetPoint("TOPLEFT", bg, 2, -1)
--         _G.MerchantBuyBackItem.Name:SetPoint("BOTTOMRIGHT", bg, 0, 14)

--         Skin.ItemButtonTemplate(_G.MerchantBuyBackItem.ItemButton)
--         _G[name.."MoneyFrame"]:SetPoint("BOTTOMLEFT", bg, 1, 1)
--     end

--     _G.MerchantExtraCurrencyInset:SetAlpha(0)
--     Skin.ThinGoldEdgeTemplate(_G.MerchantExtraCurrencyBg, true)
--     _G.MerchantMoneyInset:Hide()
--     Skin.ThinGoldEdgeTemplate(_G.MerchantMoneyBg, true)

--     for i, delta in _G.next, {"PrevPageButton", "NextPageButton"} do
--         local button = _G["Merchant"..delta]
--         button:ClearAllPoints()

--         local label, bg = button:GetRegions()
--         bg:Hide()
--         if i == 1 then
--             Skin.NavButtonPrevious(button)
--             button:SetPoint("BOTTOMLEFT", 16, 82)
--             label:SetPoint("LEFT", button, "RIGHT", 3, 0)
--         else
--             Skin.NavButtonNext(button)
--             button:SetPoint("BOTTOMRIGHT", -16, 82)
--             label:SetPoint("RIGHT", button, "LEFT", -3, 0)
--         end
--     end

--     Skin.CharacterFrameTabButtonTemplate(_G.MerchantFrameTab1)
--     _G.MerchantFrameTab1:ClearAllPoints()
--     _G.MerchantFrameTab1:SetPoint("TOPLEFT", _G.MerchantFrame, "BOTTOMLEFT", 20, -1)
--     Skin.CharacterFrameTabButtonTemplate(_G.MerchantFrameTab2)
--     _G.MerchantFrameTab2:SetPoint("TOPLEFT", _G.MerchantFrameTab1, "TOPRIGHT", 1, 0)

--     Skin.UIDropDownMenuTemplate(_G.MerchantFrame.lootFilter)
-- end




_G.tinsert(C.themes["Aurora"], function()
    _G.MerchantMoneyInset:DisableDrawLayer("BORDER")
    _G.MerchantExtraCurrencyInset:DisableDrawLayer("BORDER")
    _G.BuybackBG:SetAlpha(0)
    _G.MerchantMoneyBg:Hide()
    _G.MerchantMoneyInsetBg:Hide()
    _G.MerchantFrameBottomLeftBorder:SetAlpha(0)
    _G.MerchantFrameBottomRightBorder:SetAlpha(0)
    _G.MerchantExtraCurrencyBg:SetAlpha(0)
    _G.MerchantExtraCurrencyInsetBg:Hide()
    _G.MerchantPrevPageButton:GetRegions():Hide()
    _G.MerchantNextPageButton:GetRegions():Hide()
    select(2, _G.MerchantPrevPageButton:GetRegions()):Hide()
    select(2, _G.MerchantNextPageButton:GetRegions()):Hide()

    F.ReskinPortraitFrame(_G.MerchantFrame, true)
    F.CreateBD(_G.MerchantFrame)
    F.CreateSD(_G.MerchantFrame)
    F.ReskinDropDown(_G.MerchantFrameLootFilter)
    F.ReskinArrow(_G.MerchantPrevPageButton, "Left")
    F.ReskinArrow(_G.MerchantNextPageButton, "Right")

    _G.MerchantFrameTab1:ClearAllPoints()
    _G.MerchantFrameTab1:SetPoint("CENTER", _G.MerchantFrame, "BOTTOMLEFT", 50, -14)
    _G.MerchantFrameTab2:SetPoint("LEFT", _G.MerchantFrameTab1, "RIGHT", -15, 0)

    for i = 1, 2 do
        F.ReskinTab(_G["MerchantFrameTab"..i])
    end

    _G.MerchantNameText:SetDrawLayer("ARTWORK")

    for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
        local button = _G["MerchantItem"..i]
        local bu = _G["MerchantItem"..i.."ItemButton"]
        local mo = _G["MerchantItem"..i.."MoneyFrame"]
        local ic = bu.icon

        bu:SetHighlightTexture("")
        bu.IconBorder:SetAlpha(0)

        _G["MerchantItem"..i.."SlotTexture"]:Hide()
        _G["MerchantItem"..i.."NameFrame"]:Hide()
        _G["MerchantItem"..i.."Name"]:SetHeight(20)

        local a1, p, a2= bu:GetPoint()
        bu:SetPoint(a1, p, a2, -2, -2)
        bu:SetNormalTexture("")
        bu:SetPushedTexture("")
        bu:SetSize(40, 40)

        local a3, p2, a4, x, y = mo:GetPoint()
        mo:SetPoint(a3, p2, a4, x, y+2)

        F.CreateBD(bu, 0)

        button.bd = _G.CreateFrame("Frame", nil, button)
        button.bd:SetPoint("TOPLEFT", 39, 0)
        button.bd:SetPoint("BOTTOMRIGHT")
        button.bd:SetFrameLevel(0)
        F.CreateBD(button.bd, .25)

        ic:SetTexCoord(.08, .92, .08, .92)
        ic:ClearAllPoints()
        ic:SetPoint("TOPLEFT", 1, -1)
        ic:SetPoint("BOTTOMRIGHT", -1, 1)

        for j = 1, 3 do
            F.CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
            _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(.08, .92, .08, .92)
        end
    end

    hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
        local numMerchantItems = _G.GetMerchantNumItems()
        for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
            local index = ((_G.MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i
            if index <= numMerchantItems then
                local _, _, price, _, _, _, extendedCost = _G.GetMerchantItemInfo(index)
                if extendedCost and (price <= 0) then
                    _G["MerchantItem"..i.."AltCurrencyFrame"]:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
                end

                local bu = _G["MerchantItem"..i.."ItemButton"]
                local name = _G["MerchantItem"..i.."Name"]
                name:SetTextColor(GetItemQualityColor(bu.link))
            end
        end

        _G.MerchantBuyBackItemName:SetTextColor(GetItemQualityColor(_G.GetBuybackItemLink(_G.GetNumBuybackItems())))
    end)

    hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
        for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
            local name = _G["MerchantItem"..i.."Name"]
            name:SetTextColor(GetItemQualityColor(_G.GetBuybackItemLink(i)))
        end
    end)

    _G.MerchantBuyBackItemSlotTexture:SetAlpha(0)
    _G.MerchantBuyBackItemNameFrame:Hide()
    _G.MerchantBuyBackItemItemButton:SetNormalTexture("")
    _G.MerchantBuyBackItemItemButton:SetPushedTexture("")
    MerchantBuyBackItemItemButton.IconBorder:SetAlpha(0)

    F.CreateBD(_G.MerchantBuyBackItemItemButton, 0)
    F.CreateBD(_G.MerchantBuyBackItem, .25)

    _G.MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
    _G.MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
    _G.MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
    _G.MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

    _G.MerchantBuyBackItemName:SetHeight(25)
    _G.MerchantBuyBackItemName:ClearAllPoints()
    _G.MerchantBuyBackItemName:SetPoint("LEFT", _G.MerchantBuyBackItemSlotTexture, "RIGHT", -5, 8)

    _G.MerchantGuildBankRepairButton:SetPushedTexture("")
    F.CreateBG(_G.MerchantGuildBankRepairButton)
    _G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

    _G.MerchantRepairAllButton:SetPushedTexture("")
    F.CreateBG(_G.MerchantRepairAllButton)
    _G.MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

    _G.MerchantRepairItemButton:SetPushedTexture("")
    F.CreateBG(_G.MerchantRepairItemButton)
    local icon = _G.MerchantRepairItemButton:GetRegions()
    icon:SetTexture("Interface\\Icons\\INV_Hammer_20")
    icon:SetTexCoord(.08, .92, .08, .92)

    hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
        for i = 1, _G.MAX_MERCHANT_CURRENCIES do
            local bu = _G["MerchantToken"..i]
            if bu and not bu.reskinned then
                local ic = _G["MerchantToken"..i.."Icon"]
                local co = _G["MerchantToken"..i.."Count"]

                ic:SetTexCoord(.08, .92, .08, .92)
                ic:SetDrawLayer("OVERLAY")
                ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
                co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)

                F.CreateBG(ic)
                bu.reskinned = true
            end
        end
    end)
end)