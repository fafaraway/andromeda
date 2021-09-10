local F, C = unpack(select(2, ...))

C.Themes['Blizzard_GuildBankUI'] = function()
    if C.IsNewPatch then
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
            button:SetCheckedTexture(C.Assets.button_checked)
            F.CreateBDFrame(button)
            icon:SetTexCoord(unpack(C.TexCoord))

            local a1, p, a2, x, y = button:GetPoint()
            button:SetPoint(a1, p, a2, x + C.mult, y)
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
                        button:SetCheckedTexture(C.Assets.button_checked)
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

        return
    end

    _G.GuildBankFrame:DisableDrawLayer('BACKGROUND')
    _G.GuildBankFrame:DisableDrawLayer('BORDER')

    _G.GuildBankFrame.TopLeftCorner:Hide()
    _G.GuildBankFrame.TopRightCorner:Hide()
    _G.GuildBankFrame.TopBorder:Hide()
    _G.GuildBankTabTitleBackground:SetTexture('')
    _G.GuildBankTabTitleBackgroundLeft:SetTexture('')
    _G.GuildBankTabTitleBackgroundRight:SetTexture('')
    _G.GuildBankTabLimitBackground:SetTexture('')
    _G.GuildBankTabLimitBackgroundLeft:SetTexture('')
    _G.GuildBankTabLimitBackgroundRight:SetTexture('')
    _G.GuildBankEmblemFrame:Hide()
    _G.GuildBankMoneyFrameBackgroundLeft:Hide()
    _G.GuildBankMoneyFrameBackgroundMiddle:Hide()
    _G.GuildBankMoneyFrameBackgroundRight:Hide()
    _G.GuildBankPopupNameLeft:Hide()
    _G.GuildBankPopupNameMiddle:Hide()
    _G.GuildBankPopupNameRight:Hide()

    F.SetBD(_G.GuildBankFrame)
    F.Reskin(_G.GuildBankFrameWithdrawButton)
    F.Reskin(_G.GuildBankFrameDepositButton)
    F.Reskin(_G.GuildBankFramePurchaseButton)
    F.Reskin(_G.GuildBankPopupOkayButton)
    F.Reskin(_G.GuildBankPopupCancelButton)
    F.Reskin(_G.GuildBankInfoSaveButton)
    F.ReskinClose(_G.GuildBankFrame.CloseButton)
    F.ReskinScroll(_G.GuildBankTransactionsScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildBankInfoScrollFrameScrollBar)
    F.ReskinScroll(_G.GuildBankPopupScrollFrameScrollBar)
    F.ReskinInput(_G.GuildItemSearchBox)

    for i = 1, 4 do
        local tab = _G['GuildBankFrameTab' .. i]
        F.ReskinTab(tab)

        if i ~= 1 then
            tab:SetPoint('LEFT', _G['GuildBankFrameTab' .. i - 1], 'RIGHT', -15, 0)
        end
    end

    F.StripTextures(_G.GuildBankPopupFrame.BorderBox)
    _G.GuildBankPopupFrame.BG:Hide()
    F.SetBD(_G.GuildBankPopupFrame)
    F.CreateBDFrame(_G.GuildBankPopupEditBox, .25)
    _G.GuildBankPopupFrame:SetPoint('TOPLEFT', _G.GuildBankFrame, 'TOPRIGHT', 2, -30)
    _G.GuildBankPopupFrame:SetHeight(525)

    _G.GuildBankFrameWithdrawButton:SetPoint('RIGHT', _G.GuildBankFrameDepositButton, 'LEFT', -1, 0)

    for i = 1, _G.NUM_GUILDBANK_COLUMNS do
        _G['GuildBankColumn' .. i]:GetRegions():Hide()
        for j = 1, _G.NUM_SLOTS_PER_GUILDBANK_GROUP do
            local button = _G['GuildBankColumn' .. i .. 'Button' .. j]
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
        local button = _G['GuildBankTab' .. i .. 'Button']
        local icon = _G['GuildBankTab' .. i .. 'ButtonIconTexture']

        F.StripTextures(tab)
        button:SetNormalTexture('')
        button:SetPushedTexture('')
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
        button:SetCheckedTexture(C.Assets.button_checked)
        F.CreateBDFrame(button)
        icon:SetTexCoord(unpack(C.TexCoord))

        local a1, p, a2, x, y = button:GetPoint()
        button:SetPoint(a1, p, a2, x + C.Mult, y)
    end

    _G.GuildBankPopupFrame:HookScript(
        'OnShow',
        function()
            for i = 1, _G.NUM_GUILDBANK_ICONS_PER_ROW * _G.NUM_GUILDBANK_ICON_ROWS do
                local button = _G['GuildBankPopupButton' .. i]
                local icon = _G['GuildBankPopupButton' .. i .. 'Icon']
                if not button.styled then
                    button:SetCheckedTexture(C.Assets.button_checked)
                    select(2, button:GetRegions()):Hide()
                    F.ReskinIcon(icon)
                    local hl = button:GetHighlightTexture()
                    hl:SetColorTexture(1, 1, 1, .25)
                    hl:SetAllPoints(icon)

                    button.styled = true
                end
            end
        end
    )
end
