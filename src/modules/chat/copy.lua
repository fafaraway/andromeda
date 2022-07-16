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

local function replaceMessage(msg, r, g, b)
    local hexRGB = F:RgbToHex(r, g, b)
    msg = gsub(msg, '|T(.-):.-|t', '%1') -- accept texture path or id
    return format('%s%s|r', hexRGB, msg)
end

function CHAT:GetChatLines()
    local index = 1
    for i = 1, self:GetNumMessages() do
        local msg, r, g, b = self:GetMessageInfo(i)
        if msg and not IsMessageProtected(msg) then
            r, g, b = r or 1, g or 1, b or 1
            msg = replaceMessage(msg, r, g, b)
            lines[index] = tostring(msg)
            index = index + 1
        end
    end

    return index - 1
end

function CHAT:ChatCopy_OnClick()
    if not frame:IsShown() then
        local chatframe = _G.SELECTED_DOCK_FRAME
        local _, fontSize = chatframe:GetFont()
        FCF_SetChatWindowFontSize(chatframe, chatframe, 0.01)
        frame:Show()

        local lineCt = CHAT.GetChatLines(chatframe)
        local text = table.concat(lines, '\n', 1, lineCt)
        FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
        editBox:SetText(text)
    else
        frame:Hide()
    end

    self:GetScript('OnEnter')(self)
end

function CHAT:ChatCopy_Create()
    frame = CreateFrame('Frame', C.ADDON_TITLE .. 'ChatCopy', _G.UIParent)
    frame:SetPoint('CENTER')
    frame:SetSize(700, 400)
    frame:Hide()
    frame:SetFrameStrata('DIALOG')
    F.CreateMF(frame)
    F.SetBD(frame)
    frame.close = CreateFrame('Button', nil, frame, 'UIPanelCloseButton')
    frame.close:SetPoint('TOPRIGHT', frame)

    local scrollArea = CreateFrame(
        'ScrollFrame',
        'ChatCopyScrollFrame',
        frame,
        'UIPanelScrollFrameTemplate',
        'BackdropTemplate'
    )
    scrollArea:SetPoint('TOPLEFT', 10, -30)
    scrollArea:SetPoint('BOTTOMRIGHT', -28, 10)

    editBox = CreateFrame('EditBox', nil, frame)
    editBox:SetMultiLine(true)
    editBox:SetMaxLetters(99999)
    editBox:EnableMouse(true)
    editBox:SetAutoFocus(false)
    local outline = _G.ANDROMEDA_ADB.FontOutline
    editBox:SetFont(C.Assets.Font.Regular, 12, outline, '', nil, outline or 'THICK')
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
            _G.ScrollFrameTemplate_OnMouseWheel(scrollArea, -1)
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
        _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
        _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Copy chat content'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
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
