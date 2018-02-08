local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)
local Hook, Skin = private.Aurora.Hook, private.Aurora.Skin

function private.FrameXML.MailFrame()
    F.ReskinPortraitFrame(_G.MailFrame, true)
    F.CreateBD(_G.MailFrame)
    F.CreateSD(_G.MailFrame)
    select(18, _G.MailFrame:GetRegions()):Hide()

    --[[ InboxFrame ]]--
    local InboxFrame = _G.InboxFrame
    InboxFrame:SetAllPoints()
    _G.InboxFrameBg:Hide()
    _G.InboxTitleText:ClearAllPoints()
    _G.InboxTitleText:SetPoint("TOP", 0, -4)

    for index = 1, _G.INBOXITEMS_TO_DISPLAY do
        local name = "MailItem"..index
        local item = _G[name]
        local button = item.Button

        for i = 1, 3 do
            select(i, item:GetRegions()):Hide()
        end

        local bg = CreateFrame("Frame", nil, item)
        bg:SetFrameLevel(button:GetFrameLevel() - 1)
        bg:SetPoint("TOPLEFT", 1, -1)
        bg:SetSize(41, 41)
        F.CreateBD(bg, 0.2)

        button:SetPoint("TOPLEFT", 2, -2)
        button:SetSize(39, 39)
        button:SetCheckedTexture(C.media.checked)
        _G[name.."ButtonSlot"]:Hide()
        _G[name.."ButtonIcon"]:SetTexCoord(.08, .92, .08, .92)
        _G[name.."ButtonIcon"]:SetPoint("BOTTOMRIGHT")
        button._auroraIconBorder = bg
    end
    hooksecurefunc("InboxFrame_Update", function()
        local numItems = _G.GetInboxNumItems()
        local index = ((_G.InboxFrame.pageNum - 1) * _G.INBOXITEMS_TO_DISPLAY) + 1
        for i = 1, _G.INBOXITEMS_TO_DISPLAY do
            local name = "MailItem"..i
            local item = _G[name]
            if index <= numItems then
                local _, _, _, _, _, _, _, _, wasRead, _, _, _, _, firstItemQuantity, firstItemID = _G.GetInboxHeaderInfo(index)

                if not firstItemQuantity then
                    item.Button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
                end

                if wasRead then
                    Hook.SetItemButtonQuality(item.Button, _G.GRAY_FONT_COLOR, firstItemID)
                end
            else
                item.Button._auroraIconBorder:SetBackdropBorderColor(0, 0, 0)
            end
            index = index + 1
        end
    end)

    _G.InboxPrevPageButton:ClearAllPoints()
    _G.InboxPrevPageButton:SetPoint("BOTTOMLEFT", 14, 10)
    F.ReskinArrow(_G.InboxPrevPageButton, "Left")

    _G.InboxNextPageButton:ClearAllPoints()
    _G.InboxNextPageButton:SetPoint("BOTTOMRIGHT", -17, 10)
    F.ReskinArrow(_G.InboxNextPageButton, "Right")

    _G.OpenAllMail:ClearAllPoints()
    _G.OpenAllMail:SetPoint("BOTTOM", 0, 14)
    F.Reskin(_G.OpenAllMail)

    --[[ SendMailFrame ]]--
    local SendMailFrame = _G.SendMailFrame
    SendMailFrame:SetAllPoints()
    _G.SendMailTitleText:ClearAllPoints()
    _G.SendMailTitleText:SetPoint("TOP", 0, -4)
    for i = 4, 7 do
        select(i, SendMailFrame:GetRegions()):Hide()
    end

    local SendMailScrollFrame = _G.SendMailScrollFrame
    F.CreateBDFrame(SendMailScrollFrame, 0.2, 0, 0, 2, -4)
    SendMailScrollFrame:SetPoint("TOPLEFT", 17, -83)
    SendMailScrollFrame:SetWidth(304)

    SendMailScrollFrame.ScrollBar:ClearAllPoints()
    SendMailScrollFrame.ScrollBar:SetPoint("TOPRIGHT", SendMailScrollFrame, -1, -18)
    SendMailScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", SendMailScrollFrame, -1, 18)
    F.ReskinScroll(SendMailScrollFrame.ScrollBar)
    select(4, SendMailScrollFrame:GetRegions()):Hide()
    _G.SendMailBodyEditBox:SetPoint("TOPLEFT", 2, -2)
    _G.SendMailBodyEditBox:SetWidth(278)

    _G.SendStationeryBackgroundLeft:Hide()
    _G.SendStationeryBackgroundRight:Hide()
    _G.SendScrollBarBackgroundTop:Hide()
    _G.MailTextFontNormal:SetTextColor(1, 1, 1)
    _G.MailTextFontNormal:SetShadowOffset(1, -1)
    _G.MailTextFontNormal:SetShadowColor(0, 0, 0)

    F.ReskinInput(_G.SendMailNameEditBox, 20)
    _G.SendMailCostMoneyFrame:SetPoint("TOPRIGHT", -15, -36)
    --_G.SendMailCostMoneyFrame:GetRegions():SetPoint("RIGHT", _G.SendMailCostMoneyFrame, "LEFT", 9, 2)
    F.ReskinInput(_G.SendMailSubjectEditBox)
    _G.SendMailSubjectEditBox:SetPoint("TOPLEFT", _G.SendMailNameEditBox, "BOTTOMLEFT", 0, -5)

    for i = 1, _G.ATTACHMENTS_MAX_SEND do
        local button = SendMailFrame.SendMailAttachments[i]
        button:GetRegions():Hide()

        local bg = CreateFrame("Frame", nil, button)
        bg:SetFrameLevel(button:GetFrameLevel() - 1)
        bg:SetPoint("TOPLEFT", -1, 1)
        bg:SetPoint("BOTTOMRIGHT", 1, -1)
        F.CreateBD(bg, .25)
        button._auroraIconBorder = bg
    end
    hooksecurefunc("SendMailFrame_Update", function()
        for i = 1, _G.ATTACHMENTS_MAX_SEND do
            local button = SendMailFrame.SendMailAttachments[i]
            if i == 1 then
                button:SetPoint("TOPLEFT", SendMailScrollFrame, "BOTTOMLEFT", -5, -20)
            else
                if (i % _G.ATTACHMENTS_PER_ROW_SEND) == 1 then
                    button:SetPoint("TOPLEFT", SendMailFrame.SendMailAttachments[i - _G.ATTACHMENTS_PER_ROW_SEND], "BOTTOMLEFT", 23, -9)
                else
                    button:SetPoint("TOPLEFT", SendMailFrame.SendMailAttachments[i - 1], "TOPRIGHT", 9, 0)
                end
            end

            local icon = button:GetNormalTexture()
            if icon then
                icon:SetTexCoord(.08, .92, .08, .92)
            end
        end
    end)

    _G.SendMailMoneyButton:SetPoint("BOTTOMLEFT", 5, 38)
    _G.SendMailMoneyButton:SetSize(31, 31)
    _G.SendMailMoneyText:SetPoint("TOPLEFT", _G.SendMailMoneyButton)
    F.ReskinMoneyInput(_G.SendMailMoney)
    _G.SendMailMoney:ClearAllPoints()
    _G.SendMailMoney:SetPoint("BOTTOMLEFT", _G.SendMailMoneyButton, 5, 0)
    F.ReskinRadio(_G.SendMailSendMoneyButton)
    F.ReskinRadio(_G.SendMailCODButton)

    Skin.InsetFrameTemplate(_G.SendMailMoneyInset)
    Skin.ThinGoldEdgeTemplate(_G.SendMailMoneyBg)
    _G.SendMailMoneyBg:SetPoint("TOPRIGHT", _G.SendMailFrame, "BOTTOMLEFT", 166, 26)
    _G.SendMailMoneyBg:SetPoint("BOTTOMLEFT", 7, 7)
    _G.SendMailMoneyFrame:SetPoint("BOTTOMLEFT", 175, 9)
    _G.SendMailMoneyBg:Hide()

    F.Reskin(_G.SendMailCancelButton)
    _G.SendMailCancelButton:SetPoint("BOTTOMRIGHT", -5, 5)
    F.Reskin(_G.SendMailMailButton)
    _G.SendMailMailButton:SetPoint("RIGHT", _G.SendMailCancelButton, "LEFT", -1, 0)
    _G.SendMailFrameLockSendMail:SetPoint("TOPLEFT", "SendMailAttachment1", -12, 12)
    _G.SendMailFrameLockSendMail:SetPoint("BOTTOMRIGHT", "SendMailCancelButton", 5, -5)

    F.ReskinTab(_G.MailFrameTab1)
    F.ReskinTab(_G.MailFrameTab2)

    --[[ OpenMailFrame ]]--
    local OpenMailFrame = _G.OpenMailFrame
    OpenMailFrame:SetPoint("TOPLEFT", InboxFrame, "TOPRIGHT", 5, 0)
    F.ReskinPortraitFrame(OpenMailFrame, true)
    _G.OpenMailFrameIcon:Hide()
    _G.OpenMailTitleText:ClearAllPoints()
    _G.OpenMailTitleText:SetPoint("TOP", 0, -4)
    _G.OpenMailHorizontalBarLeft:Hide()
    select(25, OpenMailFrame:GetRegions()):Hide() -- HorizontalBarRight

    F.Reskin(_G.OpenMailReportSpamButton)

    local OpenMailScrollFrame = _G.OpenMailScrollFrame
    OpenMailScrollFrame:SetPoint("TOPLEFT", 17, -83)
    OpenMailScrollFrame:SetWidth(304)
    F.ReskinScroll(_G.OpenMailScrollFrameScrollBar)

    OpenMailScrollFrame.ScrollBar:ClearAllPoints()
    OpenMailScrollFrame.ScrollBar:SetPoint("TOPRIGHT", OpenMailScrollFrame, -1, -18)
    OpenMailScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", OpenMailScrollFrame, -1, 18)
    F.ReskinScroll(OpenMailScrollFrame.ScrollBar)
    _G.OpenScrollBarBackgroundTop:Hide()
    select(2, OpenMailScrollFrame:GetRegions()):Hide()
    _G.OpenStationeryBackgroundLeft:Hide()
    _G.OpenStationeryBackgroundRight:Hide()

    _G.InvoiceTextFontNormal:SetTextColor(1, 1, 1)
    _G.InvoiceTextFontSmall:SetTextColor(1, 1, 1)
    _G.OpenMailArithmeticLine:SetColorTexture(0.8, 0.8, 0.8)
    _G.OpenMailArithmeticLine:SetSize(256, 1)
    _G.OpenMailInvoiceAmountReceived:SetPoint("TOPRIGHT", _G.OpenMailArithmeticLine, "BOTTOMRIGHT", -14, -5)

    _G.OpenMailLetterButton._auroraIconBorder = F.ReskinIcon(_G.OpenMailLetterButton.icon)
    _G.OpenMailLetterButton:SetNormalTexture("")
    _G.OpenMailLetterButton:SetPushedTexture("")
    for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
        local button = OpenMailFrame.OpenMailAttachments[i]
        button._auroraIconBorder = F.ReskinIcon(button.icon)
        button:SetNormalTexture("")
        button:SetPushedTexture("")
    end
    _G.OpenMailMoneyButton._auroraIconBorder = F.ReskinIcon(_G.OpenMailMoneyButton.icon)
    _G.OpenMailMoneyButton:SetNormalTexture("")
    _G.OpenMailMoneyButton:SetPushedTexture("")

    F.Reskin(_G.OpenMailCancelButton)
    _G.OpenMailCancelButton:SetPoint("BOTTOMRIGHT", -5, 5)
    F.Reskin(_G.OpenMailDeleteButton)
    _G.OpenMailDeleteButton:SetPoint("RIGHT", _G.OpenMailCancelButton, "LEFT", -1, 0)
    F.Reskin(_G.OpenMailReplyButton)
    _G.OpenMailReplyButton:SetPoint("RIGHT", _G.OpenMailDeleteButton, "LEFT", -1, 0)

    hooksecurefunc("OpenMail_Update", function()
        if ( not InboxFrame.openMailID ) then
            return
        end

        local _, _, _, isInvoice = _G.GetInboxText(InboxFrame.openMailID)
        if isInvoice then
            local invoiceType, _, playerName = _G.GetInboxInvoiceInfo(InboxFrame.openMailID)
            if playerName then
                if invoiceType == "buyer" then
                    _G.OpenMailArithmeticLine:SetPoint("TOP", "OpenMailInvoicePurchaser", "BOTTOMLEFT", 125, -5)
                elseif invoiceType == "seller" then
                    _G.OpenMailArithmeticLine:SetPoint("TOP", "OpenMailInvoiceHouseCut", "BOTTOMRIGHT", -114, -22)
                elseif invoiceType == "seller_temp_invoice" then
                    _G.OpenMailArithmeticLine:SetPoint("TOP", "OpenMailInvoicePurchaser", "BOTTOMLEFT", 125, -5)
                end
            end
        end
    end)
end
