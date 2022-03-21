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
            button:SetNormalTexture('')
            button:SetPushedTexture('')
            button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
            button.icon:SetTexCoord(unpack(C.TexCoord))
            button.bg = F.CreateBDFrame(button, .3)
            button.bg:SetBackdropColor(.3, .3, .3, .3)
            button.searchOverlay:SetOutside()
            F.ReskinIconBorder(button.IconBorder)
        end
    end

    for i = 1, 8 do
        local tab = _G['GuildBankTab' .. i]
        local button = tab.Button
        local icon = button.IconTexture

        F.StripTextures(tab)
        button:SetNormalTexture('')
        button:SetPushedTexture('')
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
        button:SetCheckedTexture(C.Assets.Textures.Button.Checked)
        F.CreateBDFrame(button)
        icon:SetTexCoord(unpack(C.TexCoord))

        local a1, p, a2, x, y = button:GetPoint()
        button:SetPoint(a1, p, a2, x + C.Mult, y)
    end

    local NUM_GUILDBANK_ICONS_PER_ROW = 10
    local NUM_GUILDBANK_ICON_ROWS = 9

    _G.GuildBankPopupFrame.BorderBox:Hide()
    _G.GuildBankPopupFrame.BG:Hide()
    F.SetBD(_G.GuildBankPopupFrame)
    _G.GuildBankPopupEditBox:DisableDrawLayer('BACKGROUND')
    F.ReskinInput(_G.GuildBankPopupEditBox)
    _G.GuildBankPopupFrame:SetHeight(525)
    F.Reskin(_G.GuildBankPopupFrame.OkayButton)
    F.Reskin(_G.GuildBankPopupFrame.CancelButton)
    F.ReskinScroll(_G.GuildBankPopupFrame.ScrollFrame.ScrollBar)

    _G.GuildBankPopupFrame:HookScript(
        'OnShow',
        function()
            for i = 1, NUM_GUILDBANK_ICONS_PER_ROW * NUM_GUILDBANK_ICON_ROWS do
                local button = _G['GuildBankPopupButton' .. i]
                if not button.styled then
                    button:SetCheckedTexture(C.Assets.Textures.Button.Checked)
                    select(2, button:GetRegions()):Hide()
                    F.ReskinIcon(button.Icon)
                    local hl = button:GetHighlightTexture()
                    hl:SetColorTexture(1, 1, 1, .25)
                    hl:SetAllPoints(button.Icon)

                    button.styled = true
                end
            end
        end
    )
end
