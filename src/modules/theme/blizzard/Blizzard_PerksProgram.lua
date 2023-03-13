local F, C = unpack(select(2, ...))

local function reskinCustomizeButton(button)
    F.ReskinButton(button)
    button.__bg:SetInside(nil, 5, 5)
end

local function reskinRewardButton(button)
    if button.styled then
        return
    end

    local container = button.ContentsContainer
    if container then
        F.ReskinIcon(container.Icon)
        F.ReplaceIconString(container.Price)
        hooksecurefunc(container.Price, 'SetText', F.ReplaceIconString)
    end

    button.styled = true
end

C.Themes['Blizzard_PerksProgram'] = function()
    local frame = _G.PerksProgramFrame

    if not frame then
        return
    end

    local footerFrame = frame.FooterFrame
    if footerFrame then
        reskinCustomizeButton(footerFrame.LeaveButton)
        reskinCustomizeButton(footerFrame.PurchaseButton)
        reskinCustomizeButton(footerFrame.RefundButton)

        F.ReskinCheckbox(footerFrame.TogglePlayerPreview)
        F.ReskinCheckbox(footerFrame.ToggleHideArmor)

        reskinCustomizeButton(footerFrame.RotateButtonContainer.RotateLeftButton)
        reskinCustomizeButton(footerFrame.RotateButtonContainer.RotateRightButton)
    end

    local productsFrame = frame.ProductsFrame
    if productsFrame then
        reskinCustomizeButton(productsFrame.PerksProgramFilter.FilterDropDownButton)
        F.ReskinIcon(productsFrame.PerksProgramCurrencyFrame.Icon)
        F.StripTextures(productsFrame.PerksProgramProductDetailsContainerFrame)
        F.SetBD(productsFrame.PerksProgramProductDetailsContainerFrame)

        local productsContainer = productsFrame.ProductsScrollBoxContainer
        F.StripTextures(productsContainer)
        F.SetBD(productsContainer)
        F.ReskinTrimScroll(productsContainer.ScrollBar)
        F.StripTextures(productsContainer.PerksProgramHoldFrame)
        F.CreateBDFrame(productsContainer.PerksProgramHoldFrame, 0.25):SetInside(nil, 3, 3)

        hooksecurefunc(productsContainer.ScrollBox, 'Update', function(self)
            self:ForEachFrame(reskinRewardButton)
        end)
    end
end
