local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local texL, texR, texT, texB = unpack(C.TEX_COORD)

    _G.SendMailMoneyInset:DisableDrawLayer('BORDER')
    _G.InboxFrame:GetRegions():Hide()
    _G.SendMailMoneyBg:Hide()
    _G.SendMailMoneyInset:Hide()
    _G.OpenMailFrameIcon:Hide()
    _G.OpenMailHorizontalBarLeft:Hide()
    F.StripTextures(_G.SendMailFrame)
    _G.OpenStationeryBackgroundLeft:Hide()
    _G.OpenStationeryBackgroundRight:Hide()
    _G.SendStationeryBackgroundLeft:Hide()
    _G.SendStationeryBackgroundRight:Hide()
    _G.InboxPrevPageButton:GetRegions():Hide()
    _G.InboxNextPageButton:GetRegions():Hide()
    if not C.IS_NEW_PATCH then
        _G.InboxTitleText:SetPoint('CENTER', _G.MailFrame, 0, 195)
    end

    F.ReskinPortraitFrame(_G.MailFrame)
    F.ReskinPortraitFrame(_G.OpenMailFrame)
    F.Reskin(_G.SendMailMailButton)
    F.Reskin(_G.SendMailCancelButton)
    F.Reskin(_G.OpenMailReplyButton)
    F.Reskin(_G.OpenMailDeleteButton)
    F.Reskin(_G.OpenMailCancelButton)
    F.Reskin(_G.OpenMailReportSpamButton)
    F.Reskin(_G.OpenAllMail)
    F.ReskinInput(_G.SendMailNameEditBox, 20, 85)
    F.ReskinInput(_G.SendMailSubjectEditBox, nil, 200)
    F.ReskinInput(_G.SendMailMoneyGold)
    F.ReskinInput(_G.SendMailMoneySilver)
    F.ReskinInput(_G.SendMailMoneyCopper)
    F.ReskinScroll(_G.SendMailScrollFrameScrollBar)
    F.ReskinScroll(_G.OpenMailScrollFrameScrollBar)
    F.ReskinRadio(_G.SendMailSendMoneyButton)
    F.ReskinRadio(_G.SendMailCODButton)
    F.ReskinArrow(_G.InboxPrevPageButton, 'left')
    F.ReskinArrow(_G.InboxNextPageButton, 'right')

    F.CreateBDFrame(_G.OpenMailScrollFrame, 0.25)
    local bg = F.CreateBDFrame(_G.SendMailScrollFrame, 0.25)
    bg:SetPoint('TOPLEFT', 6, 0)

    _G.SendMailMailButton:SetPoint('RIGHT', _G.SendMailCancelButton, 'LEFT', -1, 0)
    _G.OpenMailDeleteButton:SetPoint('RIGHT', _G.OpenMailCancelButton, 'LEFT', -1, 0)
    _G.OpenMailReplyButton:SetPoint('RIGHT', _G.OpenMailDeleteButton, 'LEFT', -1, 0)

    _G.SendMailMoneySilver:SetPoint('LEFT', _G.SendMailMoneyGold, 'RIGHT', 1, 0)
    _G.SendMailMoneyCopper:SetPoint('LEFT', _G.SendMailMoneySilver, 'RIGHT', 1, 0)

    _G.SendMailSubjectEditBox:SetPoint('TOPLEFT', _G.SendMailNameEditBox, 'BOTTOMLEFT', 0, -1)

    for i = 1, 2 do
        F.ReskinTab(_G['MailFrameTab' .. i])
    end

    for _, button in pairs({ _G.OpenMailLetterButton, _G.OpenMailMoneyButton }) do
        F.StripTextures(button)
        button.icon:SetTexCoord(texL, texR, texT, texB)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        F.CreateBDFrame(button)
    end

    for i = 1, _G.INBOXITEMS_TO_DISPLAY do
        local item = _G['MailItem' .. i]
        local button = _G['MailItem' .. i .. 'Button']
        F.StripTextures(item)
        F.StripTextures(button)
        button:SetCheckedTexture(C.Assets.Textures.ButtonChecked)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        button.Icon:SetTexCoord(texL, texR, texT, texB)
        button.IconBorder:SetAlpha(0)
        F.CreateBDFrame(button)
    end

    for i = 1, _G.ATTACHMENTS_MAX_SEND do
        local button = _G['SendMailAttachment' .. i]
        F.StripTextures(button)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        button.bg = F.CreateBDFrame(button, 0.25)
        F.ReskinIconBorder(button.IconBorder)
    end

    hooksecurefunc('SendMailFrame_Update', function()
        for i = 1, _G.ATTACHMENTS_MAX_SEND do
            local button = _G.SendMailFrame.SendMailAttachments[i]
            if HasSendMailItem(i) then
                button:GetNormalTexture():SetTexCoord(texL, texR, texT, texB)
            end
        end
    end)

    for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
        local button = _G['OpenMailAttachmentButton' .. i]
        F.StripTextures(button)
        button:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
        button.icon:SetTexCoord(texL, texR, texT, texB)
        button.bg = F.CreateBDFrame(button, 0.25)
        F.ReskinIconBorder(button.IconBorder)
    end

    _G.MailFont_Large:SetTextColor(1, 1, 1)
    _G.MailFont_Large:SetShadowColor(0, 0, 0)
    _G.MailFont_Large:SetShadowOffset(1, -1)
    _G.MailTextFontNormal:SetTextColor(1, 1, 1)
    _G.MailTextFontNormal:SetShadowOffset(1, -1)
    _G.MailTextFontNormal:SetShadowColor(0, 0, 0)
    _G.InvoiceTextFontNormal:SetTextColor(1, 1, 1)
    _G.InvoiceTextFontSmall:SetTextColor(1, 1, 1)
end)
