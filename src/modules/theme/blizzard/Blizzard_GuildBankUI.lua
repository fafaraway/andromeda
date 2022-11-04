local F, C = unpack(select(2, ...))

C.Themes['Blizzard_GuildBankUI'] = function()
    F.StripTextures(_G.GuildBankFrame)
    F.ReskinPortraitFrame(_G.GuildBankFrame)

    _G.GuildBankFrame.Emblem:Hide()
    _G.GuildBankFrame.MoneyFrameBG:Hide()
    F.Reskin(_G.GuildBankFrame.WithdrawButton)
    F.Reskin(_G.GuildBankFrame.DepositButton)
    F.ReskinScroll(_G.GuildBankTransactionsScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildBankInfoScrollFrameScrollBar)
    F.Reskin(_G.GuildBankFrame.BuyInfo.PurchaseButton)
    F.Reskin(_G.GuildBankFrame.Info.SaveButton)
    F.ReskinInput(_G.GuildItemSearchBox)

    _G.GuildBankFrame.WithdrawButton:SetPoint('RIGHT', _G.GuildBankFrame.DepositButton, 'LEFT', -2, 0)

    for i = 1, 4 do
        local tab = _G['GuildBankFrameTab' .. i]
        F.ReskinTab(tab)

        if i ~= 1 then
            tab:SetPoint('LEFT', _G['GuildBankFrameTab' .. i - 1], 'RIGHT', -15, 0)
        end
    end

    for i = 1, 7 do
        local column = _G.GuildBankFrame.Columns[i]
        column:GetRegions():Hide()

        for j = 1, 14 do
            local button = column.Buttons[j]
            button:SetNormalTexture(0)
            button:SetPushedTexture(0)
            button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
            button.icon:SetTexCoord(unpack(C.TEX_COORD))
            button.bg = F.CreateBDFrame(button, 0.3)
            button.bg:SetBackdropColor(0.3, 0.3, 0.3, 0.3)
            button.searchOverlay:SetOutside()
            F.ReskinIconBorder(button.IconBorder)
        end
    end

    for i = 1, 8 do
        local tab = _G['GuildBankTab' .. i]
        local button = tab.Button
        local icon = button.IconTexture

        F.StripTextures(tab)
        button:SetNormalTexture(0)
        button:SetPushedTexture(0)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        button:SetCheckedTexture(C.Assets.Textures.ButtonChecked)
        F.CreateBDFrame(button)
        icon:SetTexCoord(unpack(C.TEX_COORD))

        local a1, p, a2, x, y = button:GetPoint()
        button:SetPoint(a1, p, a2, x + C.MULT, y)
    end

    F.ReskinIconSelector(_G.GuildBankPopupFrame)
end
