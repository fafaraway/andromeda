local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local format = format
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local ChatFrame_OpenChat = ChatFrame_OpenChat
local ChatFrame_ReplyTell = ChatFrame_ReplyTell
local ChatFrame_AddChannel = ChatFrame_AddChannel
local GetChannelName = GetChannelName
local UnitExists = UnitExists
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName
local GetUnitName = GetUnitName
local GetDefaultLanguage = GetDefaultLanguage
local IsPartyLFG = IsPartyLFG
local C_GuildInfo_CanEditOfficerNote = C_GuildInfo.CanEditOfficerNote
local LeaveChannelByName = LeaveChannelByName
local JoinPermanentChannel = JoinPermanentChannel


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
                ChatFrame_OpenChat('/y ', chatFrame)
            else
                ChatFrame_OpenChat('/s ', chatFrame)
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
                ChatFrame_ReplyTell(chatFrame)
                if not editBox:IsVisible() or editBox:GetAttribute('chatType') ~= 'WHISPER' then
                    ChatFrame_OpenChat('/w ', chatFrame)
                end
            else
                if UnitExists('target') and UnitName('target') and UnitIsPlayer('target') and GetDefaultLanguage('player') == GetDefaultLanguage('target') then
                    local name = GetUnitName('target', true)
                    ChatFrame_OpenChat('/w ' .. name .. ' ', chatFrame)
                else
                    ChatFrame_OpenChat('/w ', chatFrame)
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
            ChatFrame_OpenChat('/p ', chatFrame)
        end
    },
    {
        1,
        .5,
        0,
        _G.INSTANCE .. '/' .. _G.RAID,
        function()
            if IsPartyLFG() then
                ChatFrame_OpenChat('/i ', chatFrame)
            else
                ChatFrame_OpenChat('/raid ', chatFrame)
            end
        end
    },
    {
        .25,
        1,
        .25,
        _G.GUILD .. '/' .. _G.OFFICER,
        function(_, btn)
            if btn == 'RightButton' and C_GuildInfo_CanEditOfficerNote() then
                ChatFrame_OpenChat('/o ', chatFrame)
            else
                ChatFrame_OpenChat('/g ', chatFrame)
            end
        end
    }
}

local function AddButton(r, g, b, text, func)
    local bu = CreateFrame('Button', nil, CHAT.ChannelBar, 'SecureActionButtonTemplate, BackdropTemplate')
    bu:SetSize(30, 3)
    F.PixelIcon(bu, C.Assets.norm_tex, true)
    F.CreateSD(bu)
    bu.Icon:SetVertexColor(r, g, b)
    bu:SetHitRectInsets(0, 0, -8, -8)
    bu:RegisterForClicks('AnyUp')
    if text then
        F.AddTooltip(bu, 'ANCHOR_TOP', F:RGBToHex(r, g, b) .. text)
    end
    if func then
        bu:SetScript('OnClick', func)
    end

    tinsert(buttonList, bu)
    return bu
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

    local channelBar = CreateFrame('Frame', 'FreeUI_ChannelBar', _G.UIParent)
    channelBar:SetSize(_G.ChatFrame1:GetWidth(), 5)
    channelBar:SetPoint('TOPLEFT', _G.ChatFrame1, 'BOTTOMLEFT', 0, -6)
    channelBar:SetAlpha(.2)
    CHAT.ChannelBar = channelBar

    for _, info in pairs(buttonInfo) do
        AddButton(unpack(info))
    end

    -- ROLL
    local roll = AddButton(.8, 1, .6, _G.LOOT_ROLL)
    roll:SetAttribute('type', 'macro')
    roll:SetAttribute('macrotext', '/roll')

    -- COMBATLOG
    local combat = AddButton(1, 1, 0, _G.BINDING_NAME_TOGGLECOMBATLOG)
    combat:SetAttribute('type', 'macro')
    combat:SetAttribute('macrotext', '/combatlog')

    -- WORLD CHANNEL
    if C.IsCNPortal then
        local channelName, channelID = C.IsChinses and '大脚世界频道' or 'BigfootWorldChannel'
        local wc = AddButton(0, .8, 1, L['World channel'])

        local function updateChannelInfo()
            local id = GetChannelName(channelName)
            if not id or id == 0 then
                wc.inChannel = false
                channelID = nil
                wc.Icon:SetVertexColor(1, .1, .1)
            else
                wc.inChannel = true
                channelID = id
                wc.Icon:SetVertexColor(0, .8, 1)
            end
        end

        local function isInChannel(event)
            F:Delay(.2, updateChannelInfo)

            if event == 'PLAYER_ENTERING_WORLD' then
                F:UnregisterEvent(event, isInChannel)
            end
        end
        F:RegisterEvent('PLAYER_ENTERING_WORLD', isInChannel)
        F:RegisterEvent('CHANNEL_UI_UPDATE', isInChannel)
        hooksecurefunc('ChatConfigChannelSettings_UpdateCheckboxes', isInChannel) -- toggle in chatconfig

        wc:SetScript(
            'OnClick',
            function(_, btn)
                if wc.inChannel then
                    if btn == 'RightButton' then
                        LeaveChannelByName(channelName)

                        F:Print(format(C.RedColor .. L['Leave'] .. '|r %s', channelName))
                        wc.inChannel = false
                    elseif channelID then
                        ChatFrame_OpenChat('/' .. channelID, chatFrame)
                    end
                else
                    JoinPermanentChannel(channelName, nil, 1)
                    ChatFrame_AddChannel(_G.ChatFrame1, channelName)

                    F:Print(format(C.GreenColor .. L['Join'] .. '|r %s', channelName))
                    wc.inChannel = true
                end
            end
        )
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
