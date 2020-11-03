local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local texL, texR, texT, texB = unpack(C.TexCoord)

	SendMailMoneyInset:DisableDrawLayer("BORDER")
	InboxFrame:GetRegions():Hide()
	SendMailMoneyBg:Hide()
	SendMailMoneyInset:Hide()
	OpenMailFrameIcon:Hide()
	OpenMailHorizontalBarLeft:Hide()
	F.StripTextures(SendMailFrame)
	OpenStationeryBackgroundLeft:Hide()
	OpenStationeryBackgroundRight:Hide()
	SendStationeryBackgroundLeft:Hide()
	SendStationeryBackgroundRight:Hide()
	InboxPrevPageButton:GetRegions():Hide()
	InboxNextPageButton:GetRegions():Hide()
	InboxTitleText:SetPoint("CENTER", MailFrame, 0, 195)

	F.ReskinPortraitFrame(MailFrame)
	F.ReskinPortraitFrame(OpenMailFrame)
	F.Reskin(SendMailMailButton)
	F.Reskin(SendMailCancelButton)
	F.Reskin(OpenMailReplyButton)
	F.Reskin(OpenMailDeleteButton)
	F.Reskin(OpenMailCancelButton)
	F.Reskin(OpenMailReportSpamButton)
	F.Reskin(OpenAllMail)
	F.ReskinInput(SendMailNameEditBox, 20, 85)
	F.ReskinInput(SendMailSubjectEditBox, nil, 200)
	F.ReskinInput(SendMailMoneyGold)
	F.ReskinInput(SendMailMoneySilver)
	F.ReskinInput(SendMailMoneyCopper)
	F.ReskinScroll(SendMailScrollFrameScrollBar)
	F.ReskinScroll(OpenMailScrollFrameScrollBar)
	F.ReskinRadio(SendMailSendMoneyButton)
	F.ReskinRadio(SendMailCODButton)
	F.ReskinArrow(InboxPrevPageButton, "left")
	F.ReskinArrow(InboxNextPageButton, "right")

	F.CreateBDFrame(OpenMailScrollFrame, .25)
	local bg = F.CreateBDFrame(SendMailScrollFrame, .25)
	bg:SetPoint("TOPLEFT", 6, 0)

	SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
	OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
	OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)

	SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
	SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)

	SendMailSubjectEditBox:SetPoint("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

	for i = 1, 2 do
		F.ReskinTab(_G["MailFrameTab"..i])
	end

	for _, button in pairs({OpenMailLetterButton, OpenMailMoneyButton}) do
		F.StripTextures(button)
		button.icon:SetTexCoord(texL, texR, texT, texB)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		F.CreateBDFrame(button)
	end

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local item = _G["MailItem"..i]
		local button = _G["MailItem"..i.."Button"]
		F.StripTextures(item)
		F.StripTextures(button)
		button:SetCheckedTexture(C.Assets.button_checked)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button.Icon:SetTexCoord(texL, texR, texT, texB)
		button.IconBorder:SetAlpha(0)
		F.CreateBDFrame(button)
	end

	for i = 1, ATTACHMENTS_MAX_SEND do
		local button = _G["SendMailAttachment"..i]
		F.StripTextures(button)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button.bg = F.CreateBDFrame(button, .25)
		F.ReskinIconBorder(button.IconBorder)
	end

	hooksecurefunc("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local button = SendMailFrame.SendMailAttachments[i]
			if HasSendMailItem(i) then
				button:GetNormalTexture():SetTexCoord(texL, texR, texT, texB)
			end
		end
	end)

	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local button = _G["OpenMailAttachmentButton"..i]
		F.StripTextures(button)
		button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		button.icon:SetTexCoord(texL, texR, texT, texB)
		button.bg = F.CreateBDFrame(button, .25)
		F.ReskinIconBorder(button.IconBorder)
	end

	MailFont_Large:SetTextColor(1, 1, 1)
	MailFont_Large:SetShadowColor(0, 0, 0)
	MailFont_Large:SetShadowOffset(1, -1)
	MailTextFontNormal:SetTextColor(1, 1, 1)
	MailTextFontNormal:SetShadowOffset(1, -1)
	MailTextFontNormal:SetShadowColor(0, 0, 0)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	InvoiceTextFontSmall:SetTextColor(1, 1, 1)
end)
