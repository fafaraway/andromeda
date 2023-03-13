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

    F.ReskinPortraitFrame(_G.MailFrame)
    F.ReskinPortraitFrame(_G.OpenMailFrame)
    F.ReskinButton(_G.SendMailMailButton)
    F.ReskinButton(_G.SendMailCancelButton)
    F.ReskinButton(_G.OpenMailReplyButton)
    F.ReskinButton(_G.OpenMailDeleteButton)
    F.ReskinButton(_G.OpenMailCancelButton)
    F.ReskinButton(_G.OpenMailReportSpamButton)
    F.ReskinButton(_G.OpenAllMail)
    F.ReskinEditbox(_G.SendMailNameEditBox, 20, 85)
    F.ReskinEditbox(_G.SendMailSubjectEditBox, nil, 200)
    F.ReskinEditbox(_G.SendMailMoneyGold)
    F.ReskinEditbox(_G.SendMailMoneySilver)
    F.ReskinEditbox(_G.SendMailMoneyCopper)
    if C.IS_NEW_PATCH_10_1 then
        F.ReskinTrimScroll(_G.SendMailScrollFrame.ScrollBar)
        F.ReskinTrimScroll(_G.OpenMailScrollFrame.ScrollBar)
    else
        F.ReskinScroll(_G.SendMailScrollFrameScrollBar)
        F.ReskinScroll(_G.OpenMailScrollFrameScrollBar)
    end
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

    _G.MailFrameTab2:ClearAllPoints()
    _G.MailFrameTab2:SetPoint('TOPLEFT', _G.MailFrameTab1, 'TOPRIGHT', -15, 0)

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
