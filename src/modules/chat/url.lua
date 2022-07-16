local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local foundurl = false

local function convertLink(text, value)
    return '|Hurl:' .. tostring(value) .. '|h' .. C.INFO_COLOR .. text .. '|r|h'
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
        --192.168.1.1:1234
        text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)', highlightURL)
    end
    if not foundurl then
        --192.168.1.1
        text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)', highlightURL)
    end
    if not foundurl then
        --www.teamspeak.com:3333
        text = gsub(text, '(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)', highlightURL)
    end
    if not foundurl then
        --http://www.google.com
        text = gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", highlightURL)
    end
    if not foundurl then
        --www.google.com
        text = gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", highlightURL)
    end
    if not foundurl then
        --lol@lol.com
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
                C_PartyInfo.InviteUnit(unit)
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
            local accountInfo = C_BattleNet.GetAccountInfoByID(bnID)
            if not accountInfo then
                return
            end
            local gameAccountInfo = accountInfo.gameAccountInfo
            local gameID = gameAccountInfo.gameAccountID
            if gameID and _G.CanCooperateWithGameAccount(accountInfo) then
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
        _G.ChatEdit_ClearChat(_G.ChatFrame1.editBox)
    end
end

function CHAT.SetItemRefHook(link, _, button)
    if strsub(link, 1, 6) == 'player' and button == 'LeftButton' and IsModifiedClick('CHATLINK') then
        if
            not _G.StaticPopup_Visible('ADD_IGNORE')
            and not _G.StaticPopup_Visible('ADD_FRIEND')
            and not _G.StaticPopup_Visible('ADD_GUILDMEMBER')
            and not _G.StaticPopup_Visible('ADD_RAIDMEMBER')
            and not _G.StaticPopup_Visible('CHANNEL_INVITE')
            and not _G.ChatEdit_GetActiveWindow()
        then
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
                if server and server ~= C.MY_REALM then
                    name = fullname
                end

                if _G.MailFrame and _G.MailFrame:IsShown() then
                    _G.MailFrameTab_OnClick(nil, 2)
                    _G.SendMailNameEditBox:SetText(name)
                    _G.SendMailNameEditBox:HighlightText()
                else
                    local editBox = _G.ChatEdit_ChooseBoxForSend()
                    local hasText = (editBox:GetText() ~= '')
                    _G.ChatEdit_ActivateChat(editBox)
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
