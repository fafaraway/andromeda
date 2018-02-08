local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_VoidStorageUI()
    F.SetBD(_G.VoidStorageFrame, 20, 0, 0, 20)
    F.CreateBD(_G.VoidStoragePurchaseFrame)

    _G.VoidStorageBorderFrame:DisableDrawLayer("BORDER")
    _G.VoidStorageBorderFrame:DisableDrawLayer("BACKGROUND")
    _G.VoidStorageBorderFrame:DisableDrawLayer("OVERLAY")
    _G.VoidStorageDepositFrame:DisableDrawLayer("BACKGROUND")
    _G.VoidStorageDepositFrame:DisableDrawLayer("BORDER")
    _G.VoidStorageWithdrawFrame:DisableDrawLayer("BACKGROUND")
    _G.VoidStorageWithdrawFrame:DisableDrawLayer("BORDER")
    _G.VoidStorageCostFrame:DisableDrawLayer("BACKGROUND")
    _G.VoidStorageCostFrame:DisableDrawLayer("BORDER")
    _G.VoidStorageStorageFrame:DisableDrawLayer("BACKGROUND")
    _G.VoidStorageStorageFrame:DisableDrawLayer("BORDER")
    _G.VoidStorageFrameMarbleBg:Hide()
    select(2, _G.VoidStorageFrame:GetRegions()):Hide()
    _G.VoidStorageFrameLines:Hide()
    _G.VoidStorageStorageFrameLine1:Hide()
    _G.VoidStorageStorageFrameLine2:Hide()
    _G.VoidStorageStorageFrameLine3:Hide()
    _G.VoidStorageStorageFrameLine4:Hide()
    select(12, _G.VoidStorageDepositFrame:GetRegions()):Hide()
    select(12, _G.VoidStorageWithdrawFrame:GetRegions()):Hide()
    for i = 1, 10 do
        select(i, _G.VoidStoragePurchaseFrame:GetRegions()):Hide()
    end

    for _, voidButton in pairs({"VoidStorageDepositButton", "VoidStorageWithdrawButton"}) do
        for i = 1, 9 do
            local bu = _G[voidButton..i]
            local border = bu.IconBorder

            bu:SetPushedTexture("")
            _G[voidButton..i.."Bg"]:Hide()

            bu.icon:SetTexCoord(.08, .92, .08, .92)

            border:SetTexture(C.media.backdrop)
            border:SetPoint("TOPLEFT", -1, 1)
            border:SetPoint("BOTTOMRIGHT", 1, -1)
            border:SetDrawLayer("BACKGROUND")

            F.CreateBDFrame(bu, .25)
        end
    end

    for i = 1, 80 do
        local bu = _G["VoidStorageStorageButton"..i]
        local border = bu.IconBorder
        local searchOverlay = bu.searchOverlay

        bu:SetPushedTexture("")

        border:SetTexture(C.media.backdrop)
        border:SetPoint("TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", 1, -1)
        border:SetDrawLayer("BACKGROUND")

        searchOverlay:SetPoint("TOPLEFT", -1, 1)
        searchOverlay:SetPoint("BOTTOMRIGHT", 1, -1)

        _G["VoidStorageStorageButton"..i.."Bg"]:Hide()
        _G["VoidStorageStorageButton"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
    end

    for i = 1, 2 do
        local tab = _G.VoidStorageFrame["Page"..i]

        tab:GetRegions():Hide()
        tab:SetCheckedTexture(C.media.checked)

        F.CreateBG(tab)

        tab:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
    end

    _G.VoidStorageFrame.Page1:ClearAllPoints()
    _G.VoidStorageFrame.Page1:SetPoint("LEFT", _G.VoidStorageFrame, "TOPRIGHT", 2, -60)

    F.Reskin(_G.VoidStoragePurchaseButton)
    F.Reskin(_G.VoidStorageHelpBoxButton)
    F.Reskin(_G.VoidStorageTransferButton)
    F.ReskinClose(_G.VoidStorageBorderFrame:GetChildren(), nil)
    F.ReskinInput(_G.VoidItemSearchBox)
end
