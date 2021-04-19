local F, C = unpack(select(2, ...))
local CHAT = F.CHAT

local _G = _G
local tostring = tostring
local pairs = pairs
local ipairs = ipairs
local strsub = string.sub
local strlower = string.lower
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsPartyLFG = IsPartyLFG
local IsInGuild = IsInGuild
local IsAltKeyDown = IsAltKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsModifierKeyDown = IsModifierKeyDown
local ChatEdit_UpdateHeader = ChatEdit_UpdateHeader
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatEdit_ClearChat = ChatEdit_ClearChat
local ChatTypeInfo = ChatTypeInfo
local GetChatWindowInfo = GetChatWindowInfo
local GetChannelName = GetChannelName
local GetChannelList = GetChannelList
local GetInstanceInfo = GetInstanceInfo
local GetRealmName = GetRealmName
local GetCVar = GetCVar
local SetCVar = SetCVar
local Ambiguate = Ambiguate
local GetTime = GetTime
local GetNumGuildMembers = GetNumGuildMembers
local GetGuildRosterInfo = GetGuildRosterInfo
local IsGuildMember = IsGuildMember
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local CanCooperateWithGameAccount = CanCooperateWithGameAccount
local BNInviteFriend = BNInviteFriend
local BNFeaturesEnabledAndConnected = BNFeaturesEnabledAndConnected
local PlaySoundFile = PlaySoundFile
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local C_PartyInfo_InviteUnit = C_PartyInfo.InviteUnit
local GeneralDockManager = GeneralDockManager
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local GuildInvite = GuildInvite
local hooksecurefunc = hooksecurefunc
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local ConsoleExec = ConsoleExec

local isScaling = false
function CHAT:UpdateChatSize()
    if not C.DB.chat.lock_position then
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
    _G.ChatFrame1:SetPoint('BOTTOMLEFT', _G.UIParent, 'BOTTOMLEFT', C.UIGap, C.UIGap)
    _G.ChatFrame1:SetSize(C.DB.chat.window_width, C.DB.chat.window_height)

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
    local selected = GeneralDockManager.selected:GetID() == tab:GetID()
    if event == 'CHAT_MSG_WHISPER' then
        tab.whisperIndex = 1
        CHAT.UpdateTabColors(tab, selected)
    elseif event == 'CHAT_MSG_BN_WHISPER' then
        tab.whisperIndex = 2
        CHAT.UpdateTabColors(tab, selected)
    end
end

function CHAT:RestyleChatFrame()
    if not self or self.styled then
        return
    end

    local name = self:GetName()
    local maxLines = 1024

    if C.DB.chat.fade_out then
        self:SetFading(true)
        self:SetTimeVisible(C.DB.chat.fading_visible)
        self:SetFadeDuration(C.DB.chat.fading_duration)
    end

    local font = C.IsDeveloper and 'Fonts\\FreeUI\\chat.ttf' or C.Assets.Fonts.Bold
    local outline = _G.FREE_ADB.FontOutline
    local fontSize = select(2, self:GetFont())
    F:SetFS(self, font, fontSize, outline, nil, nil, outline or 'THICK')

    self:SetClampedToScreen(false)
    self:SetMaxResize(C.ScreenWidth, C.ScreenHeight)
    self:SetMinResize(100, 50)
    if self:GetMaxLines() < maxLines then
        self:SetMaxLines(maxLines)
    end

    local eb = _G[name .. 'EditBox']
    eb:SetAltArrowKeyMode(false)
    eb:ClearAllPoints()
    eb:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 4, 26)
    eb:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -17, 50)

    eb.bd = F.SetBD(eb)

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
    tab.Text:SetFont(C.Assets.Fonts.Bold, 12, C.DB.chat.outline and 'OUTLINE')
    tab.Text:SetShadowColor(0, 0, 0, C.DB.chat.outline and 0 or 1)
    tab.Text:SetShadowOffset(2, -2)
    F.StripTextures(tab, 7)
    hooksecurefunc(tab, 'SetAlpha', CHAT.TabSetAlpha)

    F.StripTextures(self)

    F.HideObject(self.buttonFrame)
    F.HideObject(self.ScrollBar)
    F.HideObject(self.ScrollToBottomButton)

    F.HideObject(_G.ChatFrameMenuButton)
    F.HideObject(_G.QuickJoinToastButton)

    if C.DB.chat.voice_button then
        _G.ChatFrameChannelButton:ClearAllPoints()
        _G.ChatFrameChannelButton:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPLEFT', -6, -26)
        _G.ChatFrameChannelButton:SetParent(_G.UIParent)
    else
        F.HideObject(_G.ChatFrameChannelButton)
        F.HideObject(_G.ChatFrameToggleVoiceDeafenButton)
        F.HideObject(_G.ChatFrameToggleVoiceMuteButton)
    end

    _G.BNToastFrame:SetClampedToScreen(true)
    _G.BNToastFrame:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

    _G.VoiceChatPromptActivateChannel:SetClampedToScreen(true)
    _G.VoiceChatPromptActivateChannel:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

    _G.VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
    _G.VoiceChatChannelActivatedNotification:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

    _G.ChatAlertFrame:SetClampedToScreen(true)
    _G.ChatAlertFrame:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

    self.oldAlpha = self.oldAlpha or 0 -- fix blizz error, need reviewed

    self.styled = true
end

function CHAT:UpdateEditBoxBorderColor()
    hooksecurefunc('ChatEdit_UpdateHeader', function()
        local editBox = ChatEdit_ChooseBoxForSend()
        local mType = editBox:GetAttribute('chatType')
        if mType == 'CHANNEL' then
            local id = GetChannelName(editBox:GetAttribute('channelTarget'))
            if id == 0 then
                editBox.bd:SetBackdropBorderColor(0, 0, 0)
            else
                editBox.bd:SetBackdropBorderColor(ChatTypeInfo[mType .. id].r, ChatTypeInfo[mType .. id].g,
                    ChatTypeInfo[mType .. id].b)
            end
        elseif mType == 'SAY' then
            editBox.bd:SetBackdropBorderColor(0, 0, 0)
        else
            editBox.bd:SetBackdropBorderColor(ChatTypeInfo[mType].r, ChatTypeInfo[mType].g, ChatTypeInfo[mType].b)
        end
    end)
end

local cycles = {
    {
        chatType = 'SAY',
        use = function()
            return 1
        end,
    },
    {
        chatType = 'PARTY',
        use = function()
            return IsInGroup()
        end,
    },
    {
        chatType = 'RAID',
        use = function()
            return IsInRaid()
        end,
    },
    {
        chatType = 'INSTANCE_CHAT',
        use = function()
            return IsPartyLFG()
        end,
    },
    {
        chatType = 'GUILD',
        use = function()
            return IsInGuild()
        end,
    },
    {
        chatType = 'CHANNEL',
        use = function(_, editbox)
            if GetCVar('portal') ~= 'CN' then
                return false
            end
            local channels, inWorldChannel, number = {GetChannelList()}
            for i = 1, #channels do
                if channels[i] == '大脚世界频道' then
                    inWorldChannel = true
                    number = channels[i - 1]
                    break
                end
            end
            if inWorldChannel then
                editbox:SetAttribute('channelTarget', number)
                return true
            else
                return false
            end
        end,
    },
    {
        chatType = 'SAY',
        use = function()
            return 1
        end,
    },
}

function CHAT:UpdateTabChannelSwitch()
    if not C.DB.chat.tab_cycle then
        return
    end
    if strsub(tostring(self:GetText()), 1, 1) == '/' then
        return
    end
    local currChatType = self:GetAttribute('chatType')
    for i, curr in ipairs(cycles) do
        if curr.chatType == currChatType then
            local h, r, step = i + 1, #cycles, 1
            if IsShiftKeyDown() then
                h, r, step = i - 1, 1, -1
            end
            for j = h, r, step do
                if cycles[j]:use(self, currChatType) then
                    self:SetAttribute('chatType', cycles[j].chatType)
                    ChatEdit_UpdateHeader(self)
                    return
                end
            end
        end
    end
end

function CHAT:QuickMouseScroll(dir)
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
hooksecurefunc('FloatingChatFrame_OnMouseScroll', CHAT.QuickMouseScroll)

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
            FCF_SavePositionAndDimensions(_G.ChatFrame1)
        end
    end)
end

local function UpdateChatBubble()
    local name, instType = GetInstanceInfo()
    if name and
        (instType == 'raid' or instType == 'party' or instType == 'scenario' or instType == 'pvp' or instType == 'arena') then
        SetCVar('chatBubbles', 1)
    else
        SetCVar('chatBubbles', 0)
    end
end

function CHAT:AutoToggleChatBubble()
    if C.DB.chat.smart_bubble then
        F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateChatBubble)
    else
        F:UnregisterEvent('PLAYER_ENTERING_WORLD', UpdateChatBubble)
    end
end

-- Autoinvite by whisper
local whisperList = {}
function CHAT:UpdateWhisperList()
    F:SplitList(whisperList, C.DB.chat.invite_keyword, true)
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
        if (not IsInGroup() or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player')) and strlower(msg) ==
            strlower(word) then
            if event == 'CHAT_MSG_BN_WHISPER' then
                local accountInfo = C_BattleNet_GetAccountInfoByID(presenceID)
                if accountInfo then
                    local gameAccountInfo = accountInfo.gameAccountInfo
                    local gameID = gameAccountInfo.gameAccountID
                    if gameID then
                        local charName = gameAccountInfo.characterName
                        local realmName = gameAccountInfo.realmName
                        if CanCooperateWithGameAccount(accountInfo) and
                            (not C.DB.chat.guild_only or CHAT:IsUnitInGuild(charName .. '-' .. realmName)) then
                            BNInviteFriend(gameID)
                        end
                    end
                end
            else
                if not C.DB.chat.guild_only or IsGuildMember(guid) then
                    C_PartyInfo_InviteUnit(author)
                end
            end
        end
    end
end

function CHAT:WhisperInvite()
    if not C.DB.chat.whisper_invite then
        return
    end
    self:UpdateWhisperList()
    F:RegisterEvent('CHAT_MSG_WHISPER', CHAT.OnChatWhisper)
    F:RegisterEvent('CHAT_MSG_BN_WHISPER', CHAT.OnChatWhisper)
end

-- Whisper sound
function CHAT:PlayWhisperSound(event)
    if not C.DB.chat.whisper_sound then
        return
    end

    local currentTime = GetTime()
    if event == 'CHAT_MSG_WHISPER' then
        if not self.soundTimer or currentTime > self.soundTimer then
            PlaySoundFile(C.Assets.Sounds.whisper, 'Master')
        end
        self.soundTimer = currentTime + C.DB.chat.sound_timer
    elseif event == 'CHAT_MSG_BN_WHISPER' then
        if not self.soundTimer or currentTime > self.soundTimer then
            PlaySoundFile(C.Assets.Sounds.whisperBN, 'Master')
        end
        self.soundTimer = currentTime + C.DB.chat.sound_timer
    end
end

-- Whisper sticky
function CHAT:WhisperSticky()
    if C.DB.chat.whisper_sticky then
        ChatTypeInfo['WHISPER'].sticky = 1
        ChatTypeInfo['BN_WHISPER'].sticky = 1
    else
        ChatTypeInfo['WHISPER'].sticky = 0
        ChatTypeInfo['BN_WHISPER'].sticky = 0
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

-- role icon
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
    CHAT_MSG_RAID_WARNING = 1,
}

local texPath = 'Interface\\AddOns\\FreeUI\\assets\\textures\\'
local roleIcons = {
    TANK = '\124T' .. texPath .. 'roles_tank.tga' .. ':12:12:0:0:64:64:5:59:5:59\124t',
    HEALER = '\124T' .. texPath .. 'roles_healer.tga' .. ':12:12:0:0:64:64:5:59:5:59\124t',
    DAMAGER = '\124T' .. texPath .. 'roles_dps.tga' .. ':12:12:0:0:64:64:5:59:5:59\124t',
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
            ret = roleIcons[role] .. ' ' .. ret
        end
    end

    return ret
end

function CHAT:OnLogin()
    if not C.DB.chat.enable then
        return
    end

    for i = 1, _G.NUM_CHAT_WINDOWS do
        self.RestyleChatFrame(_G['ChatFrame' .. i])
    end

    hooksecurefunc('FCF_OpenTemporaryWindow', function()
        for _, chatFrameName in ipairs(_G.CHAT_FRAMES) do
            local frame = _G[chatFrameName]
            if frame.isTemporary then
                self.RestyleChatFrame(frame)
            end
        end
    end)

    hooksecurefunc('FCFTab_UpdateColors', CHAT.UpdateTabColors)
    hooksecurefunc('FloatingChatFrame_OnEvent', CHAT.UpdateTabEventColors)
    hooksecurefunc('ChatFrame_ConfigEventHandler', CHAT.PlayWhisperSound)

    if C.DB.chat.RoleIcon then
        _G.GetColoredName = getColoredName
    end

    -- Font size
    for i = 1, 15 do
        _G.CHAT_FONT_HEIGHTS[i] = i + 9
    end

    -- Default
    if _G.CHAT_OPTIONS then
        _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS = true
    end -- only flash whisper
    SetCVar('chatStyle', 'classic')
    SetCVar('whisperMode', 'inline') -- blizz reset this on NPE
    F.HideOption(_G.InterfaceOptionsSocialPanelChatStyle)
    _G.CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

    -- Lock chatframe
    if C.DB.chat.lock_position then
        hooksecurefunc('FCF_SavePositionAndDimensions', self.UpdateChatSize)
        F:RegisterEvent('UI_SCALE_CHANGED', self.UpdateChatSize)
        self:UpdateChatSize()
    end

    hooksecurefunc('ChatEdit_CustomTabPressed', CHAT.UpdateTabChannelSwitch)

    CHAT:UpdateEditBoxBorderColor()
    CHAT:ResizeChatFrame()
    CHAT:ChatFilter()
    CHAT:Abbreviate()
    CHAT:ChatCopy()
    CHAT:UrlCopy()
    CHAT:WhisperSticky()
    CHAT:AutoToggleChatBubble()
    CHAT:PauseToSlash()
    CHAT:WhisperInvite()
    CHAT:CreateChannelBar()

    -- ProfanityFilter
    if not BNFeaturesEnabledAndConnected() then
        return
    end

    if C.IsCNPortal then
        ConsoleExec('portal TW')
    end
    SetCVar('profanityFilter', 0)
end
