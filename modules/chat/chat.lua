local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local isScaling = false
function CHAT:UpdateChatSize()
    if not C.DB.Chat.LockPosition then
        return
    end
    if isScaling then
        return
    end
    isScaling = true

    if _G.ChatFrame1:IsMovable() then
        _G.ChatFrame1:SetUserPlaced(true)
    end

    if _G.ChatFrame1.FontStringContainer then
        _G.ChatFrame1.FontStringContainer:SetOutside(_G.ChatFrame1)
    end

    _G.ChatFrame1:ClearAllPoints()
    _G.ChatFrame1:SetPoint('BOTTOMLEFT', _G.UIParent, 'BOTTOMLEFT', C.UI_GAP, C.UI_GAP)
    _G.ChatFrame1:SetSize(C.DB.Chat.Width, C.DB.Chat.Height)

    isScaling = false
end

function CHAT:TabSetAlpha(alpha)
    if self.glow:IsShown() and alpha ~= 1 then
        self:SetAlpha(1)
    end
end

function CHAT:UpdateTabColors(selected)
    if selected then
        self.Text:SetTextColor(1, .8, 0)
        self.whisperIndex = 0
    else
        self.Text:SetTextColor(.5, .5, .5)
    end

    if self.whisperIndex == 1 then
        self.glow:SetVertexColor(1, .5, 1)
    elseif self.whisperIndex == 2 then
        self.glow:SetVertexColor(0, 1, .96)
    else
        self.glow:SetVertexColor(1, .8, 0)
    end
end

function CHAT:UpdateTabEventColors(event)
    local tab = _G[self:GetName() .. 'Tab']
    local selected = _G.GeneralDockManager.selected:GetID() == tab:GetID()
    if event == 'CHAT_MSG_WHISPER' then
        tab.whisperIndex = 1
        CHAT.UpdateTabColors(tab, selected)
    elseif event == 'CHAT_MSG_BN_WHISPER' then
        tab.whisperIndex = 2
        CHAT.UpdateTabColors(tab, selected)
    end
end

local chatEditboxes = {}
local function UpdateEditBoxAnchor(eb)
    local parent = eb.__owner
    eb:ClearAllPoints()
    if C.DB.Chat.BottomEditBox then
        eb:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 4, -10)
        eb:SetPoint('BOTTOMRIGHT', parent, 'BOTTOMRIGHT', -15, -34)
    else
        eb:SetPoint('BOTTOMLEFT', parent, 'TOPLEFT', 4, 26)
        eb:SetPoint('TOPRIGHT', parent, 'TOPRIGHT', -15, 50)
    end
end

function CHAT:ToggleEditBoxAnchor()
    for _, eb in pairs(chatEditboxes) do
        UpdateEditBoxAnchor(eb)
    end
end

local function UpdateTextFading(self)
    self:SetFading(C.DB.Chat.TextFading)
    self:SetTimeVisible(C.DB.Chat.TimeVisible)
    self:SetFadeDuration(C.DB.Chat.FadeDuration)
end

function CHAT:UpdateTextFading()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        UpdateTextFading(_G['ChatFrame' .. i])
    end
end

local function SetupChatFrame(self)
    if not self or self.styled then
        return
    end

    local name = self:GetName()
    local maxLines = 1024

    local font = C.Assets.Font.Bold
    local outline = _G.FREE_ADB.FontOutline
    local fontSize = select(2, self:GetFont())
    F:SetFS(self, font, fontSize, outline, nil, nil, outline or 'THICK')

    self:SetClampedToScreen(false)
    self:SetMaxResize(C.SCREEN_WIDTH, C.SCREEN_HEIGHT)
    self:SetMinResize(100, 50)
    if self:GetMaxLines() < maxLines then
        self:SetMaxLines(maxLines)
    end

    local eb = _G[name .. 'EditBox']
    eb:SetAltArrowKeyMode(false)
    eb:SetClampedToScreen(true)
    eb.__owner = self
    UpdateEditBoxAnchor(eb)
    eb.bd = F.SetBD(eb)
    table.insert(chatEditboxes, eb)

    for i = 3, 8 do
        select(i, eb:GetRegions()):SetAlpha(0)
    end

    local lang = _G[name .. 'EditBoxLanguage']
    lang:GetRegions():SetAlpha(0)
    lang:SetPoint('TOPLEFT', eb, 'TOPRIGHT', 5, 0)
    lang:SetPoint('BOTTOMRIGHT', eb, 'BOTTOMRIGHT', 29, 0)
    lang.bd = F.SetBD(lang)

    local tab = _G[name .. 'Tab']
    tab:SetAlpha(1)
    tab.Text:SetFont(C.Assets.Font.Bold, 12, C.DB.Chat.FontOutline and 'OUTLINE')
    tab.Text:SetShadowColor(0, 0, 0, C.DB.Chat.FontOutline and 0 or 1)
    tab.Text:SetShadowOffset(2, -2)
    F.StripTextures(tab, 7)
    hooksecurefunc(tab, 'SetAlpha', CHAT.TabSetAlpha)

    F.StripTextures(self)

    if _G.CHAT_OPTIONS then
        _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS = true
    end -- only flash whisper
    SetCVar('chatStyle', 'classic')
    SetCVar('whisperMode', 'inline') -- blizz reset this on NPE
    F.HideOption(_G.InterfaceOptionsSocialPanelChatStyle)
    _G.CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

    for i = 1, 15 do
        _G.CHAT_FONT_HEIGHTS[i] = i + 9
    end

    F.HideObject(self.buttonFrame)
    F.HideObject(self.ScrollBar)
    F.HideObject(self.ScrollToBottomButton)

    F.HideObject(_G.ChatFrameMenuButton)
    F.HideObject(_G.QuickJoinToastButton)

    if C.DB.Chat.VoiceButton then
        _G.ChatFrameChannelButton:ClearAllPoints()
        _G.ChatFrameChannelButton:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPLEFT', -6, -26)
        _G.ChatFrameChannelButton:SetParent(_G.UIParent)
        CHAT.VoiceButton = _G.ChatFrameChannelButton
    else
        F.HideObject(_G.ChatFrameChannelButton)
        F.HideObject(_G.ChatFrameToggleVoiceDeafenButton)
        F.HideObject(_G.ChatFrameToggleVoiceMuteButton)
    end

    self.oldAlpha = self.oldAlpha or 0 -- fix blizz error, need reviewed

    self.styled = true
end

function CHAT:SetupToastFrame()
    _G.BNToastFrame:SetClampedToScreen(true)
    _G.BNToastFrame:SetClampRectInsets(-C.UI_GAP, C.UI_GAP, C.UI_GAP, -C.UI_GAP)

    _G.VoiceChatPromptActivateChannel:SetClampedToScreen(true)
    _G.VoiceChatPromptActivateChannel:SetClampRectInsets(-C.UI_GAP, C.UI_GAP, C.UI_GAP, -C.UI_GAP)

    _G.VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
    _G.VoiceChatChannelActivatedNotification:SetClampRectInsets(-C.UI_GAP, C.UI_GAP, C.UI_GAP, -C.UI_GAP)

    _G.ChatAlertFrame:SetClampedToScreen(true)
    _G.ChatAlertFrame:SetClampRectInsets(-C.UI_GAP, C.UI_GAP, C.UI_GAP, -C.UI_GAP)
end

function CHAT:SetupChatFrame()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        SetupChatFrame(_G['ChatFrame' .. i])
    end
end

local function SetupTemporaryWindow()
    for _, chatFrameName in ipairs(_G.CHAT_FRAMES) do
        local frame = _G[chatFrameName]
        if frame.isTemporary then
            CHAT.SetupChatFrame(frame)
        end
    end
end

function CHAT:SetupTemporaryWindow()
    hooksecurefunc('FCF_OpenTemporaryWindow', SetupTemporaryWindow)
end

function CHAT:UpdateEditBoxBorderColor()
    hooksecurefunc('ChatEdit_UpdateHeader', function()
        local editBox = _G.ChatEdit_ChooseBoxForSend()
        local mType = editBox:GetAttribute('chatType')
        if mType == 'CHANNEL' then
            local id = GetChannelName(editBox:GetAttribute('channelTarget'))
            if id == 0 then
                editBox.bd:SetBackdropBorderColor(0, 0, 0)
            else
                editBox.bd:SetBackdropBorderColor(_G.ChatTypeInfo[mType .. id].r, _G.ChatTypeInfo[mType .. id].g, _G.ChatTypeInfo[mType .. id].b)
            end
        elseif mType == 'SAY' then
            editBox.bd:SetBackdropBorderColor(0, 0, 0)
        else
            editBox.bd:SetBackdropBorderColor(_G.ChatTypeInfo[mType].r, _G.ChatTypeInfo[mType].g, _G.ChatTypeInfo[mType].b)
        end
    end)
end

function CHAT:ResizeChatFrame()
    _G.ChatFrame1Tab:HookScript('OnMouseDown', function(_, btn)
        if btn == 'LeftButton' then
            if select(8, GetChatWindowInfo(1)) then
                _G.ChatFrame1:StartSizing('TOP')
            end
        end
    end)
    _G.ChatFrame1Tab:SetScript('OnMouseUp', function(_, btn)
        if btn == 'LeftButton' then
            _G.ChatFrame1:StopMovingOrSizing()
            _G.FCF_SavePositionAndDimensions(_G.ChatFrame1)
        end
    end)
end

function CHAT:UpdateChatFrame()
    hooksecurefunc('FCF_SavePositionAndDimensions', CHAT.UpdateChatSize)
    F:RegisterEvent('UI_SCALE_CHANGED', CHAT.UpdateChatSize)
    CHAT:UpdateChatSize()
    CHAT:UpdateTextFading()
end

-- Swith channels by Tab
local cycles = {
    {
        chatType = 'SAY',
        IsActive = function()
            return true
        end
    },
    {
        chatType = 'PARTY',
        IsActive = function()
            return IsInGroup()
        end
    },
    {
        chatType = 'RAID',
        IsActive = function()
            return IsInRaid()
        end
    },
    {
        chatType = 'INSTANCE_CHAT',
        IsActive = function()
            return IsPartyLFG()
        end
    },
    {
        chatType = 'GUILD',
        IsActive = function()
            return IsInGuild()
        end
    },
    {
        chatType = 'OFFICER',
        IsActive = function()
            return C_GuildInfo.IsGuildOfficer()
        end
    },
    {
        chatType = 'CHANNEL',
        IsActive = function(_, editbox)
            if CHAT.InWorldChannel and CHAT.WorldChannelID then
                editbox:SetAttribute('channelTarget', CHAT.WorldChannelID)
                return true
            end
        end
    },
    {
        chatType = 'SAY',
        IsActive = function()
            return true
        end
    }
}

function CHAT:SwitchToChannel(chatType)
    self:SetAttribute('chatType', chatType)
    _G.ChatEdit_UpdateHeader(self)
end

function CHAT:UpdateTabChannelSwitch()
    if string.sub(self:GetText(), 1, 1) == '/' then
        return
    end

    local isShiftKeyDown = IsShiftKeyDown()
    local currentType = self:GetAttribute('chatType')
    if isShiftKeyDown and (currentType == 'WHISPER' or currentType == 'BN_WHISPER') then
        CHAT.SwitchToChannel(self, 'SAY')
        return
    end

    local numCycles = #cycles
    for i = 1, numCycles do
        local cycle = cycles[i]
        if currentType == cycle.chatType then
            local from, to, step = i + 1, numCycles, 1
            if isShiftKeyDown then
                from, to, step = i - 1, 1, -1
            end
            for j = from, to, step do
                local nextCycle = cycles[j]
                if nextCycle:IsActive(self) then
                    CHAT.SwitchToChannel(self, nextCycle.chatType)
                    return
                end
            end
        end
    end
end

-- Quick scroll
local chatScrollTip = {
    text = L['Scroll multi-lines by holding Ctrl key, and scroll to top or bottom by holding Shift key.'],
    buttonStyle = _G.HelpTip.ButtonStyle.GotIt,
    targetPoint = _G.HelpTip.Point.RightEdgeCenter,
    onAcknowledgeCallback = F.HelpInfoAcknowledge,
    callbackArg = 'ChatScroll'
}
function CHAT:OnMouseScroll(dir)
    if not _G.FREE_ADB.HelpTips.ChatScroll then
        _G.HelpTip:Show(_G.ChatFrame1, chatScrollTip)
    end

    if dir > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        elseif IsControlKeyDown() then
            self:ScrollUp()
            self:ScrollUp()
        end
    else
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        elseif IsControlKeyDown() then
            self:ScrollDown()
            self:ScrollDown()
        end
    end
end
hooksecurefunc('FloatingChatFrame_OnMouseScroll', CHAT.OnMouseScroll)

-- Smart bubble
local function UpdateChatBubble()
    local name, instType = GetInstanceInfo()
    if name and (instType == 'raid' or instType == 'party' or instType == 'scenario' or instType == 'pvp' or instType == 'arena') then
        SetCVar('chatBubbles', 1)
    else
        SetCVar('chatBubbles', 0)
    end
end

function CHAT:AutoToggleChatBubble()
    if not C.DB.Chat.SmartChatBubble then
        return
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateChatBubble)
end

-- Auto invite by whisper
local whisperList = {}
function CHAT:UpdateWhisperList()
    F:SplitList(whisperList, C.DB.Chat.InviteKeyword, true)
end

function CHAT:IsUnitInGuild(unitName)
    if not unitName then
        return
    end
    for i = 1, GetNumGuildMembers() do
        local name = GetGuildRosterInfo(i)
        if name and Ambiguate(name, 'none') == Ambiguate(unitName, 'none') then
            return true
        end
    end

    return false
end

function CHAT.OnChatWhisper(event, ...)
    local msg, author, _, _, _, _, _, _, _, _, _, guid, presenceID = ...
    for word in pairs(whisperList) do
        if (not IsInGroup() or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and string.lower(msg) == string.lower(word) then
            if event == 'CHAT_MSG_BN_WHISPER' then
                local accountInfo = C_BattleNet.GetAccountInfoByID(presenceID)
                if accountInfo then
                    local gameAccountInfo = accountInfo.gameAccountInfo
                    local gameID = gameAccountInfo.gameAccountID
                    if gameID then
                        local charName = gameAccountInfo.characterName
                        local realmName = gameAccountInfo.realmName
                        if _G.CanCooperateWithGameAccount(accountInfo) and (not C.DB.Chat.GuildOnly or CHAT:IsUnitInGuild(charName .. '-' .. realmName)) then
                            BNInviteFriend(gameID)
                        end
                    end
                end
            else
                if not C.DB.Chat.GuildOnly or IsGuildMember(guid) then
                    C_PartyInfo.InviteUnit(author)
                end
            end
        end
    end
end

function CHAT:WhisperInvite()
    if not C.DB.Chat.WhisperInvite then
        return
    end
    self:UpdateWhisperList()
    F:RegisterEvent('CHAT_MSG_WHISPER', CHAT.OnChatWhisper)
    F:RegisterEvent('CHAT_MSG_BN_WHISPER', CHAT.OnChatWhisper)
end

-- Whisper sound
CHAT.MuteCache = {}
local whisperEvents = {
    ['CHAT_MSG_WHISPER'] = true,
    ['CHAT_MSG_BN_WHISPER'] = true
}
function CHAT:PlayWhisperSound(event, _, author)
    if not C.DB.Chat.WhisperSound then
        return
    end

    if whisperEvents[event] then
        local name = Ambiguate(author, 'none')
        local currentTime = GetTime()

        if CHAT.MuteCache[name] == currentTime then
            return
        end

        if not self.soundTimer or currentTime > self.soundTimer then
            if event == 'CHAT_MSG_WHISPER' then
                PlaySoundFile(C.Assets.Sound.Whisper, 'Master')
            elseif event == 'CHAT_MSG_BN_WHISPER' then
                PlaySoundFile(C.Assets.Sound.WhisperBattleNet, 'Master')
            end
        end

        self.soundTimer = currentTime + C.DB.Chat.SoundThreshold
    end
end

-- Whisper sticky
function CHAT:WhisperSticky()
    if C.DB.Chat.WhisperSticky then
        _G.ChatTypeInfo['WHISPER'].sticky = 1
        _G.ChatTypeInfo['BN_WHISPER'].sticky = 1
    else
        _G.ChatTypeInfo['WHISPER'].sticky = 0
        _G.ChatTypeInfo['BN_WHISPER'].sticky = 0
    end
end

-- Alt+Click to Invite player
function CHAT:AltClickToInvite(link)
    if IsAltKeyDown() then
        local ChatFrameEditBox = _G.ChatEdit_ChooseBoxForSend()
        local player = link:match('^player:([^:]+)')
        local bplayer = link:match('^BNplayer:([^:]+)')
        if player then
            C_PartyInfo.InviteUnit(player)
        elseif bplayer then
            local _, value = string.match(link, '(%a+):(.+)')
            local _, bnID = string.match(value, '([^:]*):([^:]*):')
            if not bnID then
                return
            end
            local accountInfo = C_BattleNet.GetAccountInfoByID(bnID)
            if accountInfo.gameAccountInfo.clientProgram == _G.BNET_CLIENT_WOW and _G.CanCooperateWithGameAccount(accountInfo) then
                BNInviteFriend(accountInfo.gameAccountInfo.gameAccountID)
            end
        end
        _G.ChatEdit_OnEscapePressed(ChatFrameEditBox) -- Secure hook opens whisper, so closing it.
    end
end

-- (、) -> (/)
function CHAT:PauseToSlash()
    hooksecurefunc('ChatEdit_OnTextChanged', function(self, userInput)
        local text = self:GetText()
        if userInput then
            if text == '、' then
                self:SetText('/')
            end
        end
    end)
end

-- Save slash command typo
local function TypoHistory_Posthook_AddMessage(chat, text)
    if text and string.find(text, _G.HELP_TEXT_SIMPLE) then
        _G.ChatEdit_AddHistory(chat.editBox)
    end
end

function CHAT:SaveSlashCommandTypo()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        if i ~= 2 then
            hooksecurefunc(_G['ChatFrame' .. i], 'AddMessage', TypoHistory_Posthook_AddMessage)
        end
    end
end

-- Role icon
local msgEvents = {
    CHAT_MSG_SAY = 1,
    CHAT_MSG_YELL = 1,
    CHAT_MSG_WHISPER = 1,
    CHAT_MSG_WHISPER_INFORM = 1,
    CHAT_MSG_PARTY = 1,
    CHAT_MSG_PARTY_LEADER = 1,
    CHAT_MSG_INSTANCE_CHAT = 1,
    CHAT_MSG_INSTANCE_CHAT_LEADER = 1,
    CHAT_MSG_RAID = 1,
    CHAT_MSG_RAID_LEADER = 1,
    CHAT_MSG_RAID_WARNING = 1
}

local texStr = '|T%s:12:12:0:0:64:64:4:60:4:60|t'
local texList = {
    TANK = C.Assets.Texture.Tank,
    HEALER = C.Assets.Texture.Healer,
    DAMAGER = C.Assets.Texture.Damager
}

local GetColoredName_orig = _G.GetColoredName
local function getColoredName(event, arg1, arg2, ...)
    local ret = GetColoredName_orig(event, arg1, arg2, ...)

    if msgEvents[event] then
        local role = UnitGroupRolesAssigned(arg2)
        if role == 'NONE' and arg2:match(' *- *' .. GetRealmName() .. '$') then
            role = UnitGroupRolesAssigned(arg2:gsub(' *-[^-]+$', ''))
        end
        if role and role ~= 'NONE' then
            local str = string.format(texStr, texList[role])
            ret = str .. ' ' .. ret
        end
    end

    return ret
end

function CHAT:AddRoleIcon()
    if not C.DB.Chat.GroupRoleIcon then
        return
    end

    _G.GetColoredName = getColoredName
end

-- Disable pet battle tab
local old = _G.FCFManager_GetNumDedicatedFrames
function _G.FCFManager_GetNumDedicatedFrames(...)
    return select(1, ...) ~= 'PET_BATTLE_COMBAT_LOG' and old(...) or 1
end

-- Disable profanity filter
local sideEffectFixed
local function FixLanguageFilterSideEffects()
    if sideEffectFixed then
        return
    end
    sideEffectFixed = true

    F.CreateFS(_G.HelpFrame, C.Assets.Font.Bold, 14, nil, L['You need to uncheck language filter in GUI and reload UI to get access into CN BattleNet support.'], 'YELLOW', 'THICK', 'TOP', 0, 30)

    local OLD_GetFriendGameAccountInfo = C_BattleNet.GetFriendGameAccountInfo
    function _G.C_BattleNet.GetFriendGameAccountInfo(...)
        local gameAccountInfo = OLD_GetFriendGameAccountInfo(...)
        if gameAccountInfo then
            gameAccountInfo.isInCurrentRegion = true
        end
        return gameAccountInfo
    end

    local OLD_GetFriendAccountInfo = C_BattleNet.GetFriendAccountInfo
    function _G.C_BattleNet.GetFriendAccountInfo(...)
        local accountInfo = OLD_GetFriendAccountInfo(...)
        if accountInfo and accountInfo.gameAccountInfo then
            accountInfo.gameAccountInfo.isInCurrentRegion = true
        end
        return accountInfo
    end
end

function CHAT:UpdateLanguageFilter()
    if C.DB.Chat.DisableProfanityFilter then
        if GetCVar('portal') == 'CN' then
            ConsoleExec('portal TW')
            FixLanguageFilterSideEffects()
        end
        SetCVar('profanityFilter', 0)
    else
        if sideEffectFixed then
            ConsoleExec('portal CN')
        end
        SetCVar('profanityFilter', 1)
    end
end

function CHAT:OnLogin()
    if not C.DB.Chat.Enable then
        return
    end

    hooksecurefunc('FCFTab_UpdateColors', CHAT.UpdateTabColors)
    hooksecurefunc('FloatingChatFrame_OnEvent', CHAT.UpdateTabEventColors)
    hooksecurefunc('ChatFrame_MessageEventHandler', CHAT.PlayWhisperSound)
    hooksecurefunc('ChatEdit_CustomTabPressed', CHAT.UpdateTabChannelSwitch)
    hooksecurefunc('SetItemRef', CHAT.AltClickToInvite)

    CHAT:SetupChatFrame()
    CHAT:SetupToastFrame()
    CHAT:SetupTemporaryWindow()
    CHAT:ResizeChatFrame()
    CHAT:UpdateChatFrame()
    CHAT:UpdateEditBoxBorderColor()
    CHAT:ChatFilter()
    CHAT:Abbreviation()
    CHAT:ChatCopy()
    CHAT:UrlCopy()
    CHAT:WhisperSticky()
    CHAT:AutoToggleChatBubble()
    CHAT:PauseToSlash()
    CHAT:SaveSlashCommandTypo()
    CHAT:WhisperInvite()
    CHAT:CreateChannelBar()
    CHAT:AddRoleIcon()
    CHAT:UpdateLanguageFilter()
    CHAT:HideInCombat()
end
