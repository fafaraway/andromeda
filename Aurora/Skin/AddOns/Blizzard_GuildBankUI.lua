local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_GuildBankUI()
    local GuildBankFrame = _G.GuildBankFrame
    GuildBankFrame:DisableDrawLayer("BACKGROUND")
    GuildBankFrame:DisableDrawLayer("BORDER")

    GuildBankFrame.TopLeftCorner:Hide()
    GuildBankFrame.TopRightCorner:Hide()
    GuildBankFrame.TopBorder:Hide()
    _G.GuildBankTabTitleBackground:SetTexture("")
    _G.GuildBankTabTitleBackgroundLeft:SetTexture("")
    _G.GuildBankTabTitleBackgroundRight:SetTexture("")
    _G.GuildBankTabLimitBackground:SetTexture("")
    _G.GuildBankTabLimitBackgroundLeft:SetTexture("")
    _G.GuildBankTabLimitBackgroundRight:SetTexture("")
    _G.GuildBankEmblemFrame:Hide()
    _G.GuildBankMoneyFrameBackgroundLeft:Hide()
    _G.GuildBankMoneyFrameBackgroundMiddle:Hide()
    _G.GuildBankMoneyFrameBackgroundRight:Hide()
    for i = 1, 2 do
        select(i, _G.GuildBankTransactionsScrollFrame:GetRegions()):Hide()
        select(i, _G.GuildBankInfoScrollFrame:GetRegions()):Hide()
    end

    F.SetBD(GuildBankFrame)
    F.Reskin(_G.GuildBankFrameWithdrawButton)
    F.Reskin(_G.GuildBankFrameDepositButton)
    F.Reskin(_G.GuildBankFramePurchaseButton)
    F.Reskin(_G.GuildBankInfoSaveButton)
    F.ReskinClose(GuildBankFrame.CloseButton)
    F.ReskinScroll(_G.GuildBankTransactionsScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildBankInfoScrollFrameScrollBar)
    F.ReskinInput(_G.GuildItemSearchBox)

    for i = 1, 4 do
        local tab = _G["GuildBankFrameTab"..i]
        F.ReskinTab(tab)

        if i ~= 1 then
            tab:SetPoint("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
        end
    end


    _G.GuildBankFrameWithdrawButton:SetPoint("RIGHT", _G.GuildBankFrameDepositButton, "LEFT", -1, 0)

    for i = 1, _G.NUM_GUILDBANK_COLUMNS do
        _G["GuildBankColumn"..i]:GetRegions():Hide()
        for j = 1, _G.NUM_SLOTS_PER_GUILDBANK_GROUP do
            local bu = _G["GuildBankColumn"..i.."Button"..j]
            local border = bu.IconBorder
            local searchOverlay = bu.searchOverlay

            bu:SetNormalTexture("")
            bu:SetPushedTexture("")

            bu.icon:SetTexCoord(.08, .92, .08, .92)

            border:SetTexture(C.media.backdrop)
            border:SetPoint("TOPLEFT", -1, 1)
            border:SetPoint("BOTTOMRIGHT", 1, -1)
            border:SetDrawLayer("BACKGROUND")

            searchOverlay:SetPoint("TOPLEFT", -1, 1)
            searchOverlay:SetPoint("BOTTOMRIGHT", 1, -1)
        end
    end

    for i = 1, 8 do
        local tb = _G["GuildBankTab"..i]
        local bu = _G["GuildBankTab"..i.."Button"]
        local ic = _G["GuildBankTab"..i.."ButtonIconTexture"]
        local nt = _G["GuildBankTab"..i.."ButtonNormalTexture"]

        bu:SetPushedTexture("")
        tb:GetRegions():Hide()
        nt:SetAlpha(0)

        bu:SetCheckedTexture(C.media.checked)
        F.CreateBG(bu)

        local a1, p, a2, x, y = bu:GetPoint()
        bu:SetPoint(a1, p, a2, x + 1, y)

        ic:SetTexCoord(.08, .92, .08, .92)
    end

    local GuildBankPopupFrame = _G.GuildBankPopupFrame
    GuildBankPopupFrame:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 3, -30)
    GuildBankPopupFrame:SetHeight(520)
    F.CreateBD(GuildBankPopupFrame)
    GuildBankPopupFrame.BG:Hide()
    for i = 1, 8 do
        select(i, GuildBankPopupFrame.BorderBox:GetRegions()):Hide()
    end

    _G.GuildBankPopupNameLeft:Hide()
    _G.GuildBankPopupNameMiddle:Hide()
    _G.GuildBankPopupNameRight:Hide()
    F.CreateBD(_G.GuildBankPopupEditBox, .25)
    F.Reskin(_G.GuildBankPopupCancelButton)
    F.Reskin(_G.GuildBankPopupOkayButton)

    _G.GuildBankPopupScrollFrameTop:Hide()
    _G.GuildBankPopupScrollFrameMiddle:Hide()
    _G.GuildBankPopupScrollFrameBottom:Hide()
    F.ReskinScroll(_G.GuildBankPopupScrollFrameScrollBar)
    _G.GuildBankPopupScrollFrame:SetHeight(400)
end
