local F, C = unpack(select(2, ...))

C.Themes['Blizzard_VoidStorageUI'] = function()
    F.SetBD(_G.VoidStorageFrame, nil, 20, 0, 0, 20)
    F.CreateBDFrame(_G.VoidStoragePurchaseFrame)
    F.StripTextures(_G.VoidStorageBorderFrame)
    F.StripTextures(_G.VoidStorageDepositFrame)
    F.StripTextures(_G.VoidStorageWithdrawFrame)
    F.StripTextures(_G.VoidStorageCostFrame)
    F.StripTextures(_G.VoidStorageStorageFrame)
    _G.VoidStorageFrameMarbleBg:Hide()
    _G.VoidStorageFrameLines:Hide()
    select(2, _G.VoidStorageFrame:GetRegions()):Hide()

    local function reskinIcons(bu, quality)
        if not bu.bg then
            bu:SetPushedTexture('')
            bu:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
            bu.IconBorder:SetAlpha(0)
            bu.bg = F.CreateBDFrame(bu, 0.25)
            bu.bg:SetBackdropColor(0.3, 0.3, 0.3, 0.3)
            local bg, icon, _, search = bu:GetRegions()
            bg:Hide()
            icon:SetTexCoord(unpack(C.TEX_COORD))
            search:SetAllPoints(bu.bg)
        end

        local color = C.QualityColors[quality or 1]
        bu.bg:SetBackdropBorderColor(color.r, color.g, color.b)
    end

    local function hookItemsUpdate(doDeposit, doContents)
        local self = _G.VoidStorageFrame
        if doDeposit then
            for i = 1, 9 do
                local quality = select(3, GetVoidTransferDepositInfo(i))
                local bu = _G['VoidStorageDepositButton' .. i]
                reskinIcons(bu, quality)
            end
        end

        if doContents then
            for i = 1, 9 do
                local quality = select(3, GetVoidTransferWithdrawalInfo(i))
                local bu = _G['VoidStorageWithdrawButton' .. i]
                reskinIcons(bu, quality)
            end

            for i = 1, 80 do
                local quality = select(6, GetVoidItemInfo(self.page, i))
                local bu = _G['VoidStorageStorageButton' .. i]
                reskinIcons(bu, quality)
            end
        end
    end
    hooksecurefunc('VoidStorage_ItemsUpdate', hookItemsUpdate)

    for i = 1, 2 do
        local tab = _G.VoidStorageFrame['Page' .. i]
        tab:GetRegions():Hide()
        tab:SetCheckedTexture(C.Assets.Button.Checked)
        tab:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        tab:GetNormalTexture():SetTexCoord(unpack(C.TEX_COORD))
        F.CreateBDFrame(tab)
    end

    _G.VoidStorageFrame.Page1:ClearAllPoints()
    _G.VoidStorageFrame.Page1:SetPoint('LEFT', _G.VoidStorageFrame, 'TOPRIGHT', 2, -60)

    F.Reskin(_G.VoidStoragePurchaseButton)
    F.Reskin(_G.VoidStorageTransferButton)
    F.ReskinClose(_G.VoidStorageBorderFrame.CloseButton)
    F.ReskinInput(_G.VoidItemSearchBox)
end
