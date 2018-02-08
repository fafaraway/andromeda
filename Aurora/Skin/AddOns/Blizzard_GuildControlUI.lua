local _, private = ...

-- [[ Lua Globals ]]
local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_GuildControlUI()
    local r, g, b = C.r, C.g, C.b

    F.CreateBD(_G.GuildControlUI)

    for i = 1, 9 do
        select(i, _G.GuildControlUI:GetRegions()):Hide()
    end

    for i = 1, 8 do
        select(i, _G.GuildControlUIRankBankFrameInset:GetRegions()):Hide()
    end

    _G.GuildControlUIRankSettingsFrameChatBg:SetAlpha(0)
    _G.GuildControlUIRankSettingsFrameRosterBg:SetAlpha(0)
    _G.GuildControlUIRankSettingsFrameInfoBg:SetAlpha(0)
    _G.GuildControlUIRankSettingsFrameBankBg:SetAlpha(0)
    _G.GuildControlUITopBg:Hide()
    _G.GuildControlUIHbar:Hide()
    _G.GuildControlUIRankBankFrameInsetScrollFrameTop:SetAlpha(0)
    _G.GuildControlUIRankBankFrameInsetScrollFrameBottom:SetAlpha(0)

    do
        local function updateGuildRanks()
            for i = 1, _G.GuildControlGetNumRanks() do
                local rank = _G["GuildControlUIRankOrderFrameRank"..i]
                if not rank.styled then
                    rank.upButton.icon:Hide()
                    rank.downButton.icon:Hide()
                    rank.deleteButton.icon:Hide()

                    F.ReskinArrow(rank.upButton, "Up")
                    F.ReskinArrow(rank.downButton, "Down")
                    F.ReskinClose(rank.deleteButton)

                    F.ReskinInput(rank.nameBox, 20)

                    rank.styled = true
                end
            end
        end

        local f = _G.CreateFrame("Frame")
        f:RegisterEvent("GUILD_RANKS_UPDATE")
        f:SetScript("OnEvent", updateGuildRanks)
        hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)
    end

    hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
        for i = 1, _G.GetNumGuildBankTabs() + 1 do
            local tab = "GuildControlBankTab"..i
            local bu = _G[tab]
            if bu and not bu.styled then
                local ownedTab = bu.owned

                _G[tab.."Bg"]:Hide()

                ownedTab.tabIcon:SetTexCoord(.08, .92, .08, .92)
                F.CreateBG(ownedTab.tabIcon)

                F.CreateBD(bu, .25)
                F.Reskin(bu.buy.button)
                F.ReskinInput(ownedTab.editBox)

                for _, ch in pairs({ownedTab.viewCB, ownedTab.depositCB, ownedTab.infoCB}) do
                    -- can't get a backdrop frame to appear behind the checked texture for some reason
                    ch:SetNormalTexture("")
                    ch:SetPushedTexture("")
                    ch:SetHighlightTexture(C.media.backdrop)

                    local hl = ch:GetHighlightTexture()
                    hl:SetPoint("TOPLEFT", 5, -5)
                    hl:SetPoint("BOTTOMRIGHT", -5, 5)
                    hl:SetVertexColor(r, g, b, .2)

                    local check = ch:GetCheckedTexture()
                    check:SetDesaturated(true)
                    check:SetVertexColor(r, g, b)

                    local tex = F.CreateGradient(ch)
                    tex:SetPoint("TOPLEFT", 5, -5)
                    tex:SetPoint("BOTTOMRIGHT", -5, 5)

                    local left = ch:CreateTexture(nil, "BACKGROUND")
                    left:SetWidth(1)
                    left:SetColorTexture(0, 0, 0)
                    left:SetPoint("TOPLEFT", tex, -1, 1)
                    left:SetPoint("BOTTOMLEFT", tex, -1, -1)

                    local right = ch:CreateTexture(nil, "BACKGROUND")
                    right:SetWidth(1)
                    right:SetColorTexture(0, 0, 0)
                    right:SetPoint("TOPRIGHT", tex, 1, 1)
                    right:SetPoint("BOTTOMRIGHT", tex, 1, -1)

                    local top = ch:CreateTexture(nil, "BACKGROUND")
                    top:SetHeight(1)
                    top:SetColorTexture(0, 0, 0)
                    top:SetPoint("TOPLEFT", tex, -1, 1)
                    top:SetPoint("TOPRIGHT", tex, 1, 1)

                    local bottom = ch:CreateTexture(nil, "BACKGROUND")
                    bottom:SetHeight(1)
                    bottom:SetColorTexture(0, 0, 0)
                    bottom:SetPoint("BOTTOMLEFT", tex, -1, -1)
                    bottom:SetPoint("BOTTOMRIGHT", tex, 1, -1)
                end

                bu.styled = true
            end
        end
    end)

    for i = 1, 20 do
        if i ~= 14 then
            F.ReskinCheck(_G["GuildControlUIRankSettingsFrameCheckbox"..i])
        end
    end

    F.Reskin(_G.GuildControlUIRankOrderFrameNewButton)
    F.ReskinClose(_G.GuildControlUICloseButton)
    F.ReskinScroll(_G.GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
    F.ReskinDropDown(_G.GuildControlUINavigationDropDown)
    F.ReskinDropDown(_G.GuildControlUIRankSettingsFrameRankDropDown)
    F.ReskinDropDown(_G.GuildControlUIRankBankFrameRankDropDown)
    F.ReskinInput(_G.GuildControlUIRankSettingsFrameGoldBox, 20)
end
