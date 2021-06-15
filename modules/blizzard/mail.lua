local _G = _G
local unpack = unpack
local select = select
local format = format
local floor = floor
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetInboxNumItems = GetInboxNumItems
local GetInboxHeaderInfo = GetInboxHeaderInfo
local AutoLootMailItem = AutoLootMailItem
local TakeInboxMoney = TakeInboxMoney

local F, C, L = unpack(select(2, ...))
local EM = F:RegisterModule('EnhancedMail')

local text
local processing = false

local function OnEvent()
    if (not _G.MailFrame:IsShown()) then
        return
    end

    local num = GetInboxNumItems()

    local cash = 0
    local items = 0
    for i = 1, num do
        local _, _, _, _, money, COD, _, item = GetInboxHeaderInfo(i)
        if (item and COD < 1) then
            items = items + item
        end
        cash = cash + money
    end
    text:SetText(C.InfoColor .. format('%d ' .. _G.WORLD_QUEST_REWARD_FILTERS_GOLD .. ' %d ' .. _G.ITEMS, floor(cash * 0.0001), items))

    if (processing) then
        if (num == 0) then
            processing = false
            return
        end

        for i = num, 1, -1 do
            local _, _, _, _, money, COD, _, itemCount, _, _, _, _, isGM = GetInboxHeaderInfo(i)
            if not isGM then
                if (itemCount and COD < 1) then
                    AutoLootMailItem(i)
                    return
                end
                if (money > 0) then
                    TakeInboxMoney(i)
                    return
                end
            end
        end
    end
end

local function OnClick()
    if (not processing) then
        processing = true
        OnEvent()
    end
end

local function OnHide()
    processing = false
end

function EM:CollectButton()
    if not C.DB.General.EnhancedMailButton then
        return
    end

    _G.OpenAllMail:Hide()
    _G.OpenAllMail:UnregisterAllEvents()

    local b = CreateFrame('Button', 'FreeUI_MailButton', _G.InboxFrame, 'UIPanelButtonTemplate')
    b:SetPoint('BOTTOM', _G.InboxFrame, 'BOTTOM', -20, 102)
    b:SetWidth(128)
    b:SetHeight(25)
    F.Reskin(b)

    text = F.CreateFS(b, C.Assets.Fonts.Regular, 11, nil, nil, nil, true)

    b:RegisterEvent('MAIL_INBOX_UPDATE')
    b:SetScript('OnEvent', OnEvent)
    b:SetScript('OnClick', OnClick)
    b:SetScript('OnHide', OnHide)
end

function EM:SaveRecipient()
    local mailSaver = CreateFrame('CheckButton', nil, _G.SendMailFrame, 'OptionsCheckButtonTemplate')
    mailSaver:SetHitRectInsets(0, 0, 0, 0)
    mailSaver:SetPoint('RIGHT', _G.MailFrame.CloseButton, 'LEFT', -3, 0)
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
                C.DB.General.RecipientName = _G.SendMailNameEditBox:GetText()
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
                self:SetText(C.DB.General.RecipientName)
                resetPending = nil
            end
        end
    )

    _G.SendMailFrame:HookScript(
        'OnShow',
        function()
            if C.DB.General.SaveRecipient then
                _G.SendMailNameEditBox:SetText(C.DB.General.RecipientName)
            end
        end
    )
end

function EM:OnLogin()
    EM:CollectButton()
    EM:SaveRecipient()
end
