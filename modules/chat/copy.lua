local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local lines, frame, editBox = {}

local function CanChangeMessage(arg1, id)
    if id and arg1 == '' then
        return id
    end
end

local function IsMessageProtected(msg)
    return msg and (msg ~= string.gsub(msg, '(:?|?)|K(.-)|k', CanChangeMessage))
end

local function replaceMessage(msg, r, g, b)
    local hexRGB = F:RGBToHex(r, g, b)
    msg = string.gsub(msg, '(|TInterface(.*)|t)', '')
    return string.format('%s%s|r', hexRGB, msg)
end

local function EnableCombatLogging()
    LoggingCombat(true)
    F:Print(L['CombatLogging is now |cff20ff20ON|r.'])
end

local function DisableCombatLogging()
    LoggingCombat(false)
    F:Print(L['CombatLogging is now |cffff2020OFF|r.'])
end

local function UpdateCopyButtonColor(self)
    if LoggingCombat() then
        self.icon:SetVertexColor(1, 1, 0)
    else
        self.icon:SetVertexColor(0, 1, 0)
    end
end

local function CreateCopyFrame()
    frame = CreateFrame('Frame', 'FreeUI_ChatCopy', _G.UIParent)
    frame:SetPoint('CENTER')
    frame:SetSize(700, 400)
    frame:Hide()
    frame:SetFrameStrata('DIALOG')
    F.CreateMF(frame)
    F.SetBD(frame)
    frame.close = CreateFrame('Button', nil, frame, 'UIPanelCloseButton')
    frame.close:SetPoint('TOPRIGHT', frame)
    F.ReskinClose(frame.close)

    local scrollArea = CreateFrame('ScrollFrame', 'ChatCopyScrollFrame', frame, 'UIPanelScrollFrameTemplate', 'BackdropTemplate')
    scrollArea:SetPoint('TOPLEFT', 10, -30)
    scrollArea:SetPoint('BOTTOMRIGHT', -28, 10)
    F.ReskinScroll(_G.ChatCopyScrollFrameScrollBar)

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
            _G.ScrollFrameTemplate_OnMouseWheel(scrollArea, -1)
        end
    end)

    scrollArea:SetScrollChild(editBox)
    scrollArea:HookScript('OnVerticalScroll', function(self, offset)
        editBox:SetHitRectInsets(0, 0, offset, (editBox:GetHeight() - offset - self:GetHeight()))
    end)
end

local function CopyButton_OnClick(self)
    if not frame:IsShown() then
        local chatframe = _G.SELECTED_DOCK_FRAME
        local _, fontSize = chatframe:GetFont()
        _G.FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
        frame:Show()

        local lineCt = CHAT.GetChatLines(chatframe)
        local text = table.concat(lines, ' \n', 1, lineCt)
        _G.FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
        editBox:SetText(text)
    else
        frame:Hide()
    end

    self:GetScript('OnEnter')(self)
end

local function CreateCopyButton()
    local button = CreateFrame('Button', nil, _G.UIParent)
    button:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPLEFT', -6, 0)
    button:SetSize(20, 20)
    F.Reskin(button)

    button.icon = button:CreateTexture(nil, 'ARTWORK')
    button.icon:SetPoint('TOPLEFT', 2, -2)
    button.icon:SetPoint('BOTTOMRIGHT', -2, 2)
    button.icon:SetTexture('Interface\\Buttons\\UI-GuildButton-PublicNote-Up')
    button:RegisterForClicks('AnyUp')
    button:SetScript('OnClick', CopyButton_OnClick)

    button:HookScript('OnEnter', function(self)
        _G.GameTooltip:SetOwner(button, 'ANCHOR_TOPRIGHT')
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddDoubleLine(' ', C.LineString)
        _G.GameTooltip:AddDoubleLine(' ', C.Assets.Textures.MouseLeftBtn .. L['Copy chat content'] .. ' ', 1, 1, 1, .9, .8, .6)
        _G.GameTooltip:Show()
    end)

    button:HookScript('OnLeave', function(self)
        _G.GameTooltip:Hide()
    end)
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
        _G.FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
        frame:Show()

        local lineCt = CHAT.GetChatLines(chatframe)
        local text = table.concat(lines, '\n', 1, lineCt)
        _G.FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
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
        _G.GameTooltip:AddDoubleLine(' ', C.LineString)
        _G.GameTooltip:AddDoubleLine(' ', C.Assets.Textures.MouseLeftBtn .. L['Copy chat content'] .. ' ', 1, 1, 1, .9, .8, .6)
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
