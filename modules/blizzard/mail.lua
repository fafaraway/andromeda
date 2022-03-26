local F, C, L = unpack(select(2, ...))
local M = F:RegisterModule('EnhancedMailBox')

local mailIndex, timeToWait, totalCash, inboxItems = 0, .15, 0, {}
local isGoldCollecting

function M:GetMoneyString(money, full)
    if money >= 1e6 and not full then
        return string.format(' %.0f%s', money / 1e4, _G.GOLD_AMOUNT_SYMBOL)
    else
        if money > 0 then
            local moneyString = ''
            local gold = math.floor(money / 1e4)
            if gold > 0 then
                moneyString = ' ' .. gold .. _G.GOLD_AMOUNT_SYMBOL
            end
            local silver = math.floor((money - (gold * 1e4)) / 100)
            if silver > 0 then
                moneyString = moneyString .. ' ' .. silver .. _G.SILVER_AMOUNT_SYMBOL
            end
            local copper = math.fmod(money, 100)
            if copper > 0 then
                moneyString = moneyString .. ' ' .. copper .. _G.COPPER_AMOUNT_SYMBOL
            end
            return moneyString
        else
            return ' 0' .. _G.COPPER_AMOUNT_SYMBOL
        end
    end
end

function M:MailBox_DelectClick()
    local selectedID = self.id + (_G.InboxFrame.pageNum - 1) * 7
    if InboxItemCanDelete(selectedID) then
        DeleteInboxItem(selectedID)
    else
        _G.UIErrorsFrame:AddMessage(C.RedColor .. _G.ERR_MAIL_DELETE_ITEM_ERROR)
    end
end

function M:MailItem_AddDelete(i)
    local bu = CreateFrame('Button', nil, self)
    bu:SetPoint('BOTTOMRIGHT', self:GetParent(), 'BOTTOMRIGHT', -10, 5)
    bu:SetSize(16, 16)
    --F.PixelIcon(bu, 136813, true)
    local icon = bu:CreateTexture(nil, 'ARTWORK')
    icon:SetInside()

    icon:SetTexture('Interface\\RAIDFRAME\\ReadyCheck-NotReady')

    bu.id = i
    bu:SetScript('OnClick', M.MailBox_DelectClick)
    F.AddTooltip(bu, 'ANCHOR_RIGHT', _G.DELETE, 'BLUE')
end

function M:InboxItem_OnEnter()
    if not self.index then
        return
    end -- may receive fake mails from Narcissus
    table.wipe(inboxItems)

    local itemAttached = select(8, GetInboxHeaderInfo(self.index))
    if itemAttached then
        for attachID = 1, 12 do
            local _, itemID, _, itemCount = GetInboxItem(self.index, attachID)
            if itemCount and itemCount > 0 then
                inboxItems[itemID] = (inboxItems[itemID] or 0) + itemCount
            end
        end

        if itemAttached > 1 then
            _G.GameTooltip:AddLine(L['Attach List'])
            for itemID, count in pairs(inboxItems) do
                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(itemID)
                if itemName then
                    local r, g, b = GetItemQualityColor(itemQuality)
                    _G.GameTooltip:AddDoubleLine(' |T' .. itemTexture .. ':12:12:0:0:50:50:4:46:4:46|t ' .. itemName, count, r, g, b)
                end
            end
            _G.GameTooltip:Show()
        end
    end
end

local contactList = {}
local contactListByRealm = {}

function M:ContactButton_OnClick()
    local text = self.name:GetText() or ''
    _G.SendMailNameEditBox:SetText(text)
    _G.SendMailNameEditBox:SetCursorPosition(0)
end

function M:ContactButton_Delete()
    _G.FREE_ADB['ContactList'][self.__owner.name:GetText()] = nil
    M:ContactList_Refresh()
end

function M:ContactButton_Create(parent, index)
    local button = CreateFrame('Button', nil, parent)
    button:SetSize(150, 20)
    button:SetPoint('TOPLEFT', 2, -2 - (index - 1) * 20)
    button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
    button.HL:SetAllPoints()
    button.HL:SetColorTexture(1, 1, 1, .25)

    button.name = F.CreateFS(button, C.Assets.Fonts.Bold, 12, nil, 'Name', nil, true, 'LEFT', 0, 0)
    button.name:SetPoint('RIGHT', button, 'LEFT', 155, 0)
    button.name:SetJustifyH('LEFT')

    button:RegisterForClicks('AnyUp')
    button:SetScript('OnClick', M.ContactButton_OnClick)

    button.delete = CreateFrame('Button', nil, button, 'BackdropTemplate')
    button.delete:SetSize(16, 16)
    button.delete.icon = button.delete:CreateTexture(nil, 'ARTWORK')
    button.delete.icon:SetInside()
    button.delete.icon:SetTexture('Interface\\RAIDFRAME\\ReadyCheck-NotReady')
    --button.delete = F.CreateButton(button, 16, 16, false, 'Interface\\RAIDFRAME\\ReadyCheck-NotReady')
    button.delete:SetPoint('LEFT', button, 'RIGHT', 2, 0)
    button.delete.__owner = button
    button.delete:SetScript('OnClick', M.ContactButton_Delete)

    return button
end

local function GenerateDataByRealm(realm)
    if contactListByRealm[realm] then
        for name, color in pairs(contactListByRealm[realm]) do
            local r, g, b = string.split(':', color)
            table.insert(contactList, {name = name .. '-' .. realm, r = r, g = g, b = b})
        end
    end
end

function M:ContactList_Refresh()
    table.wipe(contactList)
    table.wipe(contactListByRealm)

    for fullname, color in pairs(_G.FREE_ADB['ContactList']) do
        local name, realm = string.split('-', fullname)
        if not contactListByRealm[realm] then
            contactListByRealm[realm] = {}
        end
        contactListByRealm[realm][name] = color
    end

    GenerateDataByRealm(C.MyRealm)

    for realm in pairs(contactListByRealm) do
        if realm ~= C.MyRealm then
            GenerateDataByRealm(realm)
        end
    end

    M:ContactList_Update()
end

function M:ContactButton_Update(button)
    local index = button.index
    local info = contactList[index]

    button.name:SetText(info.name)
    button.name:SetTextColor(info.r, info.g, info.b)
end

function M:ContactList_Update()
    local scrollFrame = _G.FreeUIMailBoxScrollFrame
    local usedHeight = 0
    local buttons = scrollFrame.buttons
    local height = scrollFrame.buttonHeight
    local numFriendButtons = #contactList
    local offset = _G.HybridScrollFrame_GetOffset(scrollFrame)

    for i = 1, #buttons do
        local button = buttons[i]
        local index = offset + i
        if index <= numFriendButtons then
            button.index = index
            M:ContactButton_Update(button)
            usedHeight = usedHeight + height
            button:Show()
        else
            button.index = nil
            button:Hide()
        end
    end

    _G.HybridScrollFrame_Update(scrollFrame, numFriendButtons * height, usedHeight)
end

function M:ContactList_OnMouseWheel(delta)
    local scrollBar = self.scrollBar
    local step = delta * self.buttonHeight
    if IsShiftKeyDown() then
        step = step * 18
    end
    scrollBar:SetValue(scrollBar:GetValue() - step)
    M:ContactList_Update()
end

function M:MailBox_ContactList()
    local bu = CreateFrame('Button', nil, _G.SendMailFrame)
    bu:SetSize(20, 20)
    bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
    bu.Icon:SetAllPoints()
    bu.Icon:SetTexture(C.Assets.Textures.Gear)
    bu.Icon:SetVertexColor(.6, .6, .6)
    bu:SetHighlightTexture(C.Assets.Textures.Gear)
    bu:SetPoint('LEFT', _G.SendMailNameEditBox, 'RIGHT', 20, 0)

    local list = CreateFrame('Frame', nil, bu)
    list:SetSize(200, 422)
    list:SetPoint('TOPLEFT', _G.MailFrame, 'TOPRIGHT', 3, -C.Mult)
    list:SetFrameStrata('Tooltip')
    F.SetBD(list)
    F.CreateFS(list, C.Assets.Fonts.Regular, 12, nil, L['Contact List'], 'YELLOW', true, 'TOP', 0, -5)

    bu:SetScript(
        'OnClick',
        function()
            F:TogglePanel(list)
        end
    )

    local editbox = F.CreateEditBox(list, 120, 20)
    editbox:SetPoint('TOPLEFT', 4, -25)
    editbox.title = L['Add Contacts']
    F.AddTooltip(
        editbox,
        'ANCHOR_BOTTOMRIGHT',
        L["Modify the contact list you need, the input format is 'UnitName-RealmName'.|nYou only need to enter name if unit is in the same realm with you.|nYou can customize text color for classify."],
        'BLUE',
        true
    )
    local swatch = F.CreateColorSwatch(list, '')
    swatch:SetSize(18, 18)
    swatch:SetPoint('LEFT', editbox, 'RIGHT', 5, 0)
    local add = F.CreateButton(list, 42, 20, _G.ADD, 12)
    add:SetPoint('LEFT', swatch, 'RIGHT', 5, 0)
    add:SetScript(
        'OnClick',
        function()
            local text = editbox:GetText()
            if text == '' or tonumber(text) then
                return
            end -- incorrect input
            if not string.find(text, '-') then
                text = text .. '-' .. C.MyRealm
            end -- complete player realm name
            if _G.FREE_ADB['ContactList'][text] then
                return
            end -- unit exists

            local r, g, b = swatch.tex:GetColor()
            _G.FREE_ADB['ContactList'][text] = r .. ':' .. g .. ':' .. b
            M:ContactList_Refresh()
            editbox:SetText('')
        end
    )

    local scrollFrame = CreateFrame('ScrollFrame', 'FreeUIMailBoxScrollFrame', list, 'HybridScrollFrameTemplate')
    scrollFrame:SetSize(175, 368)
    scrollFrame:SetPoint('BOTTOMLEFT', 4, 4)
    F.CreateBDFrame(scrollFrame, .25)
    list.scrollFrame = scrollFrame

    local scrollBar = CreateFrame('Slider', '$parentScrollBar', scrollFrame, 'HybridScrollBarTemplate')
    scrollBar.doNotHide = true
    F.ReskinScroll(scrollBar)
    scrollFrame.scrollBar = scrollBar

    local scrollChild = scrollFrame.scrollChild
    local numButtons = 19 + 1
    local buttonHeight = 22
    local buttons = {}
    for i = 1, numButtons do
        buttons[i] = M:ContactButton_Create(scrollChild, i)
    end

    scrollFrame.buttons = buttons
    scrollFrame.buttonHeight = buttonHeight
    scrollFrame.update = M.ContactList_Update
    scrollFrame:SetScript('OnMouseWheel', M.ContactList_OnMouseWheel)
    scrollChild:SetSize(scrollFrame:GetWidth(), numButtons * buttonHeight)
    scrollFrame:SetVerticalScroll(0)
    scrollFrame:UpdateScrollChildRect()
    scrollBar:SetMinMaxValues(0, numButtons * buttonHeight)
    scrollBar:SetValue(0)

    M:ContactList_Refresh()
end

function M:MailBox_CollectGold()
    if mailIndex > 0 then
        if not C_Mail.IsCommandPending() then
            if C_Mail.HasInboxMoney(mailIndex) then
                TakeInboxMoney(mailIndex)
            end
            mailIndex = mailIndex - 1
        end
        F:Delay(timeToWait, M.MailBox_CollectGold)
    else
        isGoldCollecting = false
        M:UpdateOpeningText()
    end
end

function M:MailBox_CollectAllGold()
    if isGoldCollecting then
        return
    end
    if totalCash == 0 then
        return
    end

    isGoldCollecting = true
    mailIndex = GetInboxNumItems()
    M:UpdateOpeningText(true)
    M:MailBox_CollectGold()
end

function M:TotalCash_OnEnter()
    local numItems = GetInboxNumItems()
    if numItems == 0 then
        return
    end

    for i = 1, numItems do
        totalCash = totalCash + select(5, GetInboxHeaderInfo(i))
    end

    if totalCash > 0 then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:AddLine(M:GetMoneyString(totalCash, true), 1, 1, 1)
        _G.GameTooltip:Show()
    end
end

function M:TotalCash_OnLeave()
    F:HideTooltip()
    totalCash = 0
end

function M:UpdateOpeningText(opening)
    if opening then
        M.GoldButton:SetText(_G.OPEN_ALL_MAIL_BUTTON_OPENING)
    else
        M.GoldButton:SetText(_G.GUILDCONTROL_OPTION16)
    end
end

function M:MailBox_CreatButton(parent, width, height, text, anchor)
    local button = CreateFrame('Button', nil, parent, 'UIPanelButtonTemplate')
    button:SetSize(width, height)
    button:SetPoint(unpack(anchor))
    button:SetText(text)
    if _G.FREE_ADB.ReskinBlizz then
        F.Reskin(button)
    end

    return button
end

function M:CollectGoldButton()
    _G.OpenAllMail:ClearAllPoints()
    _G.OpenAllMail:SetPoint('BOTTOMRIGHT', _G.MailFrame, 'BOTTOM', -2, 16)
    _G.OpenAllMail:SetSize(80, 20)

    local button = M:MailBox_CreatButton(_G.InboxFrame, 80, 20, '', {'BOTTOMLEFT', _G.MailFrame, 'BOTTOM', 2, 16})
    button:HookScript('OnClick', M.MailBox_CollectAllGold)
    button:HookScript('OnEnter', M.TotalCash_OnEnter)
    button:HookScript('OnLeave', M.TotalCash_OnLeave)

    M.GoldButton = button
    M:UpdateOpeningText()
end

function M:MailBox_CollectAttachment()
    for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
        local attachmentButton = _G.OpenMailFrame.OpenMailAttachments[i]
        if attachmentButton:IsShown() then
            TakeInboxItem(_G.InboxFrame.openMailID, i)
            F:Delay(timeToWait, M.MailBox_CollectAttachment)
            return
        end
    end
end

function M:MailBox_CollectCurrent()
    if _G.OpenMailFrame.cod then
        _G.UIErrorsFrame:AddMessage(C.InfoColor .. L["You can't auto collect Cash on Delivery"])
        return
    end

    local currentID = _G.InboxFrame.openMailID
    if C_Mail.HasInboxMoney(currentID) then
        TakeInboxMoney(currentID)
    end
    M:MailBox_CollectAttachment()
end

function M:CollectCurrentButton()
    local button = M:MailBox_CreatButton(_G.OpenMailFrame, 70, 20, L['Take All'], {'RIGHT', 'OpenMailReplyButton', 'LEFT', -6, 0})
    button:SetScript('OnClick', M.MailBox_CollectCurrent)

    _G.OpenMailCancelButton:SetSize(70, 20)
    _G.OpenMailCancelButton:ClearAllPoints()
    _G.OpenMailCancelButton:SetPoint('BOTTOMRIGHT', _G.OpenMailFrame, 'BOTTOMRIGHT', -8, 8)
    _G.OpenMailDeleteButton:SetSize(70, 20)
    _G.OpenMailDeleteButton:ClearAllPoints()
    _G.OpenMailDeleteButton:SetPoint('RIGHT', _G.OpenMailCancelButton, 'LEFT', -6, 0)
    _G.OpenMailReplyButton:SetSize(70, 20)
    _G.OpenMailReplyButton:ClearAllPoints()
    _G.OpenMailReplyButton:SetPoint('RIGHT', _G.OpenMailDeleteButton, 'LEFT', -6, 0)
end

function M:LastMailSaver()
    local mailSaver = CreateFrame('CheckButton', nil, _G.SendMailFrame, 'OptionsCheckButtonTemplate')
    mailSaver:SetHitRectInsets(0, 0, 0, 0)
    mailSaver:SetPoint('LEFT', _G.SendMailNameEditBox, 'RIGHT', 0, 0)
    mailSaver:SetSize(24, 24)
    F.ReskinCheck(mailSaver)

    mailSaver:SetChecked(C.DB.General.SaveRecipient)
    mailSaver:SetScript(
        'OnClick',
        function(self)
            C.DB.General.SaveRecipient = self:GetChecked()
        end
    )
    F.AddTooltip(mailSaver, 'ANCHOR_TOP', L['Save mail recipient'])

    local resetPending
    hooksecurefunc(
        'SendMailFrame_SendMail',
        function()
            if C.DB.General.SaveRecipient then
                C.DB.General.RecipientList = _G.SendMailNameEditBox:GetText()
                resetPending = true
            else
                resetPending = nil
            end
        end
    )

    hooksecurefunc(
        _G.SendMailNameEditBox,
        'SetText',
        function(self, text)
            if resetPending and text == '' then
                resetPending = nil
                self:SetText(C.DB.General.RecipientList)
            end
        end
    )

    _G.SendMailFrame:HookScript(
        'OnShow',
        function()
            if C.DB.General.SaveRecipient then
                _G.SendMailNameEditBox:SetText(C.DB.General.RecipientList)
            end
        end
    )
end

function M:ArrangeDefaultElements()
    _G.InboxTooMuchMail:ClearAllPoints()
    _G.InboxTooMuchMail:SetPoint('BOTTOM', _G.MailFrame, 'TOP', 0, 5)

    _G.SendMailNameEditBox:SetWidth(155)
    _G.SendMailNameEditBoxMiddle:SetWidth(146)
    _G.SendMailCostMoneyFrame:SetAlpha(0)

    _G.SendMailMailButton:HookScript(
        'OnEnter',
        function(self)
            _G.GameTooltip:SetOwner(self, 'ANCHOR_TOP')
            _G.GameTooltip:ClearLines()
            local sendPrice = GetSendMailPrice()
            local colorStr = '|cffffffff'
            if sendPrice > GetMoney() then
                colorStr = '|cffff0000'
            end
            _G.GameTooltip:AddLine(_G.SEND_MAIL_COST .. colorStr .. M:GetMoneyString(sendPrice, true))
            _G.GameTooltip:Show()
        end
    )
    _G.SendMailMailButton:HookScript('OnLeave', F.HideTooltip)
end

function M:OnLogin()
    if not C.DB.General.EnhancedMailBox then
        return
    end
    if IsAddOnLoaded('Postal') then
        return
    end

    -- Delete buttons
    for i = 1, 7 do
        local itemButton = _G['MailItem' .. i .. 'Button']
        M.MailItem_AddDelete(itemButton, i)
    end

    -- Tooltips for multi-items
    hooksecurefunc('InboxFrameItem_OnEnter', M.InboxItem_OnEnter)

    -- Custom contact list
    M:MailBox_ContactList()

    -- Elements
    M:ArrangeDefaultElements()
    M:CollectGoldButton()
    M:CollectCurrentButton()
    M:LastMailSaver()
end
