local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local chatFrame = _G.SELECTED_DOCK_FRAME
local editBox = chatFrame.editBox
local buttonList = {}

local buttonInfo = {
    {
        1,
        1,
        1,
        _G.SAY .. '/' .. _G.YELL,
        function(_, btn)
            if btn == 'RightButton' then
                _G.ChatFrame_OpenChat('/y ', chatFrame)
            else
                _G.ChatFrame_OpenChat('/s ', chatFrame)
            end
        end
    },
    {
        1,
        .5,
        1,
        _G.WHISPER,
        function(_, btn)
            if btn == 'RightButton' then
                _G.ChatFrame_ReplyTell(chatFrame)
                if not editBox:IsVisible() or editBox:GetAttribute('chatType') ~= 'WHISPER' then
                    _G.ChatFrame_OpenChat('/w ', chatFrame)
                end
            else
                if UnitExists('target') and UnitName('target') and UnitIsPlayer('target') and GetDefaultLanguage('player') == GetDefaultLanguage('target') then
                    local name = GetUnitName('target', true)
                    _G.ChatFrame_OpenChat('/w ' .. name .. ' ', chatFrame)
                else
                    _G.ChatFrame_OpenChat('/w ', chatFrame)
                end
            end
        end
    },
    {
        .65,
        .65,
        1,
        _G.PARTY,
        function()
            _G.ChatFrame_OpenChat('/p ', chatFrame)
        end
    },
    {
        1,
        .5,
        0,
        _G.INSTANCE .. '/' .. _G.RAID,
        function()
            if IsPartyLFG() then
                _G.ChatFrame_OpenChat('/i ', chatFrame)
            else
                _G.ChatFrame_OpenChat('/raid ', chatFrame)
            end
        end
    },
    {
        .25,
        1,
        .25,
        _G.GUILD .. '/' .. _G.OFFICER,
        function(_, btn)
            if btn == 'RightButton' and C_GuildInfo.IsGuildOfficer() then
                _G.ChatFrame_OpenChat('/o ', chatFrame)
            else
                _G.ChatFrame_OpenChat('/g ', chatFrame)
            end
        end
    }
}

local chatSwitchInfo = {
    text = L["Press Tab key to switch available channels, it's a bit silly to click on bars all the time."],
    buttonStyle = _G.HelpTip.ButtonStyle.GotIt,
    targetPoint = _G.HelpTip.Point.TopEdgeCenter,
    offsetY = 50,
    onAcknowledgeCallback = F.HelpInfoAcknowledge,
    callbackArg = 'ChatSwitch'
}

local function SwitchTip()
    if not _G.FREE_ADB['HelpTips']['ChatSwitch'] then
        _G.HelpTip:Show(_G.ChatFrame1, chatSwitchInfo)
    end
end

local function CreateButton(r, g, b, text, func)
    local bu = CreateFrame('Button', nil, CHAT.ChannelBar, 'SecureActionButtonTemplate, BackdropTemplate')
    bu:SetSize(30, 3)
    F.PixelIcon(bu, C.Assets.Statusbar.Normal, true)
    F.CreateSD(bu)
    bu.Icon:SetVertexColor(r, g, b)
    bu:SetHitRectInsets(0, 0, -8, -8)
    bu:RegisterForClicks('AnyUp')
    if text then
        F.AddTooltip(bu, 'ANCHOR_TOP', F:RgbToHex(r, g, b) .. text)
    end
    if func then
        bu:SetScript('OnClick', func)
        bu:HookScript('OnClick', SwitchTip)
    end

    table.insert(buttonList, bu)
    return bu
end

local function EnableCombatLogging()
    LoggingCombat(true)
    F:Print(L['CombatLogging is now |cff20ff20ON|r.'])
end

local function DisableCombatLoggin()
    LoggingCombat(false)
    F:Print(L['CombatLogging is now |cffff2020OFF|r.'])
end

local function LoggingButton_OnClick()
    local icon = CHAT.ChannelBar.LoggingButton.Icon

    if LoggingCombat() then
        DisableCombatLoggin()
        icon:SetVertexColor(1, 1, 0)
    else
        EnableCombatLogging()
        icon:SetVertexColor(0, 1, 0)
    end
end

local function UpdateChannelInfo()
    local channelName = '大脚世界频道'
    local icon = CHAT.ChannelBar.WorldChannelButton.Icon

    local id = GetChannelName(channelName)
    if not id or id == 0 then
        CHAT.InWorldChannel = false
        CHAT.WorldChannelID = nil
        icon:SetVertexColor(1, .1, .1)
    else
        CHAT.InWorldChannel = true
        CHAT.WorldChannelID = id
        icon:SetVertexColor(0, .8, 1)
    end
end

local function CheckChannelStatus()
    F:Delay(.2, UpdateChannelInfo)
end

local function WorldChannelButton_OnClick(self, btn)
    local channelName = '大脚世界频道'
    if CHAT.InWorldChannel then
        if btn == 'RightButton' then
            LeaveChannelByName(channelName)
            F:Print('|cffd82026' .. _G.QUIT .. '|r ' .. C.INFO_COLOR .. L['World Channel'])
            CHAT.InWorldChannel = false
        elseif CHAT.WorldChannelID then
            _G.ChatFrame_OpenChat('/' .. CHAT.WorldChannelID, chatFrame)
        end
    else
        JoinPermanentChannel(channelName, nil, 1)
        _G.ChatFrame_AddChannel(_G.ChatFrame1, channelName)
        F:Print('|cff27ba24' .. _G.JOIN .. '|r ' .. C.INFO_COLOR .. L['World Channel'])
        CHAT.InWorldChannel = true
    end
end

function CHAT:Bar_OnEnter()
    F:UIFrameFadeIn(CHAT.ChannelBar, .3, CHAT.ChannelBar:GetAlpha(), 1)
end

function CHAT:Bar_OnLeave()
    F:UIFrameFadeOut(CHAT.ChannelBar, .3, CHAT.ChannelBar:GetAlpha(), .2)
end

function CHAT:CreateChannelBar()
    if not C.DB.Chat.ChannelBar then
        return
    end

    local channelBar = CreateFrame('Frame', 'FreeUI_ChannelBar', _G.ChatFrame1)
    channelBar:SetSize(_G.ChatFrame1:GetWidth(), 5)
    channelBar:SetPoint('TOPLEFT', _G.ChatFrame1, 'BOTTOMLEFT', 0, -6)
    channelBar:SetAlpha(.2)
    CHAT.ChannelBar = channelBar

    for _, info in pairs(buttonInfo) do
        CreateButton(unpack(info))
    end

    -- ROLL
    local rollButton = CreateButton(.8, 1, .6, _G.LOOT_ROLL)
    rollButton:SetAttribute('type', 'macro')
    rollButton:SetAttribute('macrotext', '/roll')
    channelBar.RollButton = rollButton

    -- COMBATLOG
    local clButton = CreateButton(1, 1, 0, _G.BINDING_NAME_TOGGLECOMBATLOG)
    channelBar.LoggingButton = clButton
    clButton:SetScript('OnClick', LoggingButton_OnClick)

    -- WORLD CHANNEL
    if GetCVar('portal') == 'CN' then
        local wcButton = CreateButton(0, .8, 1, L['World Channel'])
        channelBar.WorldChannelButton = wcButton

        CheckChannelStatus()
        F:RegisterEvent('CHANNEL_UI_UPDATE', CheckChannelStatus)
        hooksecurefunc('ChatConfigChannelSettings_UpdateCheckboxes', CheckChannelStatus) -- toggle in chatconfig

        wcButton:SetScript('OnClick', WorldChannelButton_OnClick)
    end

    -- Order Postions
    for i = 1, #buttonList do
        if i == 1 then
            buttonList[i]:SetPoint('LEFT')
        else
            buttonList[i]:SetPoint('LEFT', buttonList[i - 1], 'RIGHT', 5, 0)
        end

        local buttonWidth = (_G.ChatFrame1:GetWidth() - (#buttonList - 1) * 5) / 8
        buttonList[i]:SetWidth(buttonWidth)

        buttonList[i]:HookScript('OnEnter', CHAT.Bar_OnEnter)
        buttonList[i]:HookScript('OnLeave', CHAT.Bar_OnLeave)
    end
end
