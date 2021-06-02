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
local GetChannelName = GetChannelName
local LeaveChannelByName = LeaveChannelByName
local JoinPermanentChannel = JoinPermanentChannel
local ChatFrame_AddChannel = ChatFrame_AddChannel
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

local channelName = C.IsChinses and '大脚世界频道' or 'BigfootWorldChannel'
local function UpdateChannelInfo()
    local id = GetChannelName(channelName)
    if not id or id == 0 then
        CHAT.CopyButton.inChannel = false
        CHAT.CopyButton.Icon:SetVertexColor(.6, .6, .6)
    else
        CHAT.CopyButton.inChannel = true
        CHAT.CopyButton.Icon:SetVertexColor(1, 1, 1)
    end
end

local function IsInChannel(event)
    F:Delay(.2, UpdateChannelInfo)

    if event == 'PLAYER_ENTERING_WORLD' then
        F:UnregisterEvent(event, IsInChannel)
    end
end

function CHAT:ChatCopy_OnClick(btn)
    --[[ if C.IsCNPortal and not C.DB.Chat.ChannelBar and btn == 'MiddleButton' then
        if CHAT.CopyButton.inChannel then
            LeaveChannelByName(channelName)

            F:Print(format(C.RedColor .. L['Leave'] .. '|r %s', channelName))
            CHAT.CopyButton.inChannel = false

        else
            JoinPermanentChannel(channelName, nil, 1)
            ChatFrame_AddChannel(_G.ChatFrame1, channelName)

            F:Print(format(C.GreenColor .. L['Join'] .. '|r %s', channelName))
            CHAT.CopyButton.inChannel = true
        end
    end ]]

    if btn == 'LeftButton' then
        if CHAT.isHidden then
            F:UIFrameFadeOut(_G.ChatFrame1, .3, _G.ChatFrame1:GetAlpha(), 1)
            _G.GeneralDockManager:Show()
            if CHAT.ChannelBar then
                CHAT.ChannelBar:Show()
            end

            CHAT.isHidden = false
        else
            F:UIFrameFadeIn(_G.ChatFrame1, .3, _G.ChatFrame1:GetAlpha(), 0)
            _G.GeneralDockManager:Hide()
            if CHAT.ChannelBar then
                CHAT.ChannelBar:Hide()
            end

            CHAT.isHidden = true
        end
    elseif btn == 'RightButton' then
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
    else
        local SR = F:GetModule('StatsReport')
        SR:SendStatsInfo()
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

    F:RegisterEvent('PLAYER_ENTERING_WORLD', IsInChannel)
    F:RegisterEvent('CHANNEL_UI_UPDATE', IsInChannel)
    hooksecurefunc('ChatConfigChannelSettings_UpdateCheckboxes', IsInChannel) -- toggle in chatconfig

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

        if CHAT.isHidden then
            _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Show chat frame'] .. ' ', 1, 1, 1, .9, .8, .6)
        else
            _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Hide chat frame'] .. ' ', 1, 1, 1, .9, .8, .6)
        end

        _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right .. L['Copy chat content'] .. ' ', 1, 1, 1, .9, .8, .6)

        if C.IsCNPortal and not C.DB.Chat.ChannelBar then
            if CHAT.CopyButton.inChannel then
                _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_middle .. L['Leave world channel'] .. ' ', 1, 1, 1, .9, .8, .6)
            else
                _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_middle .. L['Join world channel'] .. ' ', 1, 1, 1, .9, .8, .6)
            end
        end

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

local foundurl = false

local function convertLink(text, value)
    return '|Hurl:' .. tostring(value) .. '|h' .. C.InfoColor .. text .. '|r|h'
end

local function highlightURL(_, url)
    foundurl = true
    return ' ' .. convertLink('[' .. url .. ']', url) .. ' '
end

function CHAT:SearchForURL(text, ...)
    foundurl = false

    if strfind(text, '%pTInterface%p+') or strfind(text, '%pTINTERFACE%p+') then
        foundurl = true
    end

    if not foundurl then
        -- 192.168.1.1:1234
        text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)', highlightURL)
    end
    if not foundurl then
        -- 192.168.1.1
        text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)', highlightURL)
    end
    if not foundurl then
        -- www.teamspeak.com:3333
        text = gsub(text, '(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)', highlightURL)
    end
    if not foundurl then
        -- http://www.google.com
        text = gsub(text, '(%s?)(%a+://[%w_/%.%?%%=~&-\'%-]+)(%s?)', highlightURL)
    end
    if not foundurl then
        -- www.google.com
        text = gsub(text, '(%s?)(www%.[%w_/%.%?%%=~&-\'%-]+)(%s?)', highlightURL)
    end
    if not foundurl then
        -- lol@lol.com
        text = gsub(text, '(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)', highlightURL)
    end

    self.am(self, text, ...)
end

function CHAT:HyperlinkShowHook(link, _, button)
    local type, value = strmatch(link, '(%a+):(.+)')
    local hide
    if button == 'LeftButton' and IsModifierKeyDown() then
        if type == 'player' then
            local unit = strmatch(value, '([^:]+)')
            if IsAltKeyDown() then
                InviteToGroup(unit)
                hide = true
            elseif IsControlKeyDown() then
                GuildInvite(unit)
                hide = true
            end
        elseif type == 'BNplayer' then
            local _, bnID = strmatch(value, '([^:]*):([^:]*):')
            if not bnID then
                return
            end
            local accountInfo = C_BattleNet_GetAccountInfoByID(bnID)
            if not accountInfo then
                return
            end
            local gameAccountInfo = accountInfo.gameAccountInfo
            local gameID = gameAccountInfo.gameAccountID
            if gameID and CanCooperateWithGameAccount(accountInfo) then
                if IsAltKeyDown() then
                    BNInviteFriend(gameID)
                    hide = true
                elseif IsControlKeyDown() then
                    local charName = gameAccountInfo.characterName
                    local realmName = gameAccountInfo.realmName
                    GuildInvite(charName .. '-' .. realmName)
                    hide = true
                end
            end
        end
    elseif type == 'url' then
        local eb = _G.LAST_ACTIVE_CHAT_EDIT_BOX or _G[self:GetName() .. 'EditBox']
        if eb then
            eb:Show()
            eb:SetText(value)
            eb:SetFocus()
            eb:HighlightText()
        end
    end

    if hide then
        ChatEdit_ClearChat(_G.ChatFrame1.editBox)
    end
end

function CHAT.SetItemRefHook(link, _, button)
    if strsub(link, 1, 6) == 'player' and button == 'LeftButton' and IsModifiedClick('CHATLINK') then
        if not StaticPopup_Visible('ADD_IGNORE') and not StaticPopup_Visible('ADD_FRIEND') and not StaticPopup_Visible('ADD_GUILDMEMBER') and
            not StaticPopup_Visible('ADD_RAIDMEMBER') and not StaticPopup_Visible('CHANNEL_INVITE') and not ChatEdit_GetActiveWindow() then
            local namelink, fullname
            if strsub(link, 7, 8) == 'GM' then
                namelink = strsub(link, 10)
            elseif strsub(link, 7, 15) == 'Community' then
                namelink = strsub(link, 17)
            else
                namelink = strsub(link, 8)
            end
            if namelink then
                fullname = strsplit(':', namelink)
            end

            if fullname and strlen(fullname) > 0 then
                local name, server = strsplit('-', fullname)
                if server and server ~= C.MyRealm then
                    name = fullname
                end

                if _G.MailFrame and _G.MailFrame:IsShown() then
                    MailFrameTab_OnClick(nil, 2)
                    _G.SendMailNameEditBox:SetText(name)
                    _G.SendMailNameEditBox:HighlightText()
                else
                    local editBox = ChatEdit_ChooseBoxForSend()
                    local hasText = (editBox:GetText() ~= '')
                    ChatEdit_ActivateChat(editBox)
                    editBox:Insert(name)
                    if not hasText then
                        editBox:HighlightText()
                    end
                end
            end
        end
    end
end

function CHAT:UrlCopy()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        if i ~= 2 then
            local chatFrame = _G['ChatFrame' .. i]
            chatFrame.am = chatFrame.AddMessage
            chatFrame.AddMessage = self.SearchForURL
        end
    end

    local orig = _G.ItemRefTooltip.SetHyperlink
    function _G.ItemRefTooltip:SetHyperlink(link, ...)
        if link and strsub(link, 0, 3) == 'url' then
            return
        end

        return orig(self, link, ...)
    end

    hooksecurefunc('ChatFrame_OnHyperlinkShow', self.HyperlinkShowHook)
    hooksecurefunc('SetItemRef', self.SetItemRefHook)
end
