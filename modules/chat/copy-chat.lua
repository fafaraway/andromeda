local _G = _G
local unpack = unpack
local select = select
local gsub = gsub
local format = format
local tconcat = table.concat
local strfind = strfind
local strmatch = strmatch
local strsub = strsub
local strsplit = strsplit
local strlen = strlen
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local ScrollFrameTemplate_OnMouseWheel = ScrollFrameTemplate_OnMouseWheel
local IsAltKeyDown = IsAltKeyDown
local IsModifierKeyDown = IsModifierKeyDown
local IsControlKeyDown = IsControlKeyDown
local InviteToGroup = InviteToGroup
local GuildInvite = GuildInvite
local BNInviteFriend = BNInviteFriend
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local CanCooperateWithGameAccount = CanCooperateWithGameAccount
local ChatEdit_ClearChat = ChatEdit_ClearChat
local IsModifiedClick = IsModifiedClick
local StaticPopup_Visible = StaticPopup_Visible
local ChatEdit_GetActiveWindow = ChatEdit_GetActiveWindow
local MailFrameTab_OnClick = MailFrameTab_OnClick
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatEdit_ActivateChat = ChatEdit_ActivateChat

local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local lines, frame, editBox = {}

local function CanChangeMessage(arg1, id)
    if id and arg1 == '' then
        return id
    end
end

local function IsMessageProtected(msg)
    return msg and (msg ~= gsub(msg, '(:?|?)|K(.-)|k', CanChangeMessage))
end

local function ColorReplace(msg, r, g, b)
    local hexRGB = F:RGBToHex(r, g, b)
    local hexReplace = format('|r%s', hexRGB)
    msg = gsub(msg, '|r', hexReplace)
    msg = format('%s%s|r', hexRGB, msg)

    return msg
end

function CHAT:GetChatLines()
    local index = 1
    for i = 1, self:GetNumMessages() do
        local msg, r, g, b = self:GetMessageInfo(i)
        if msg and not IsMessageProtected(msg) then
            r, g, b = r or 1, g or 1, b or 1
            msg = ColorReplace(msg, r, g, b)
            lines[index] = tostring(msg)
            index = index + 1
        end
    end

    return index - 1
end

function CHAT:ChatCopy_OnClick(btn)
    if not frame:IsShown() then
        local chatframe = _G.SELECTED_DOCK_FRAME
        local _, fontSize = chatframe:GetFont()
        FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
        frame:Show()

        local lineCt = CHAT.GetChatLines(chatframe)
        local text = tconcat(lines, ' \n', 1, lineCt)
        FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
        editBox:SetText(text)
    else
        frame:Hide()
    end

    self:GetScript('OnEnter')(self)
end

function CHAT:ChatCopy_Create()
    frame = CreateFrame('Frame', 'FreeUI_ChatCopy', _G.UIParent)
    frame:SetPoint('CENTER')
    frame:SetSize(700, 400)
    frame:Hide()
    frame:SetFrameStrata('DIALOG')
    F.CreateMF(frame)
    F.SetBD(frame)
    frame.close = CreateFrame('Button', nil, frame, 'UIPanelCloseButton')
    frame.close:SetPoint('TOPRIGHT', frame)

    local scrollArea = CreateFrame('ScrollFrame', 'ChatCopyScrollFrame', frame, 'UIPanelScrollFrameTemplate', 'BackdropTemplate')
    scrollArea:SetPoint('TOPLEFT', 10, -30)
    scrollArea:SetPoint('BOTTOMRIGHT', -28, 10)

    editBox = CreateFrame('EditBox', nil, frame)
    editBox:SetMultiLine(true)
    editBox:SetMaxLetters(99999)
    editBox:EnableMouse(true)
    editBox:SetAutoFocus(false)
    editBox:SetFont(C.Assets.Fonts.Regular, 12)
    editBox:SetWidth(scrollArea:GetWidth())
    editBox:SetHeight(scrollArea:GetHeight())
    editBox:SetScript('OnEscapePressed', function()
        frame:Hide()
    end)
    editBox:SetScript('OnTextChanged', function(_, userInput)
        if userInput then
            return
        end
        local _, max = scrollArea.ScrollBar:GetMinMaxValues()
        for i = 1, max do
            ScrollFrameTemplate_OnMouseWheel(scrollArea, -1)
        end
    end)

    scrollArea:SetScrollChild(editBox)
    scrollArea:HookScript('OnVerticalScroll', function(self, offset)
        editBox:SetHitRectInsets(0, 0, offset, (editBox:GetHeight() - offset - self:GetHeight()))
    end)

    local copy = CreateFrame('Button', nil, _G.UIParent)
    copy:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPLEFT', -6, 0)
    copy:SetSize(20, 20)
    F.Reskin(copy)
    CHAT.CopyButton = copy

    copy.Icon = copy:CreateTexture(nil, 'ARTWORK')
    copy.Icon:SetPoint('TOPLEFT', 2, -2)
    copy.Icon:SetPoint('BOTTOMRIGHT', -2, 2)
    copy.Icon:SetTexture('Interface\\Buttons\\UI-GuildButton-PublicNote-Up')
    copy:RegisterForClicks('AnyUp')
    copy:SetScript('OnClick', self.ChatCopy_OnClick)

    copy:HookScript('OnEnter', function(self)
        _G.GameTooltip:SetOwner(copy, 'ANCHOR_TOPRIGHT')
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddDoubleLine(' ', C.LineString)
        _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Copy chat content'] .. ' ', 1, 1, 1, .9, .8, .6)
        _G.GameTooltip:Show()
    end)

    copy:HookScript('OnLeave', function(self)
        _G.GameTooltip:Hide()
    end)

    F.ReskinClose(frame.close)
    F.ReskinScroll(_G.ChatCopyScrollFrameScrollBar)
end

function CHAT:ChatCopy()
    if not C.DB.Chat.CopyButton then
        return
    end

    self:ChatCopy_Create()
end





