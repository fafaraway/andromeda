local _G = _G
local unpack = unpack
local select = select
local pairs = pairs
local format = format
local gsub = gsub
local strfind = strfind
local BNGetFriendInfoByID = BNGetFriendInfoByID
local BNGetGameAccountInfo = BNGetGameAccountInfo
local ChatFrame_AddMessageEventFilter = ChatFrame_AddMessageEventFilter

local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local function GetColor(className, isLocal)
    if isLocal then
        local found
        for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_FEMALE) do
            if v == className then
                className = k
                found = true
                break
            end
        end
        if not found then
            for k, v in pairs(_G.LOCALIZED_CLASS_NAMES_MALE) do
                if v == className then
                    className = k
                    break
                end
            end
        end
    end
    local tbl = C.ClassColors[className]
    local color = ('%02x%02x%02x'):format(tbl.r * 255, tbl.g * 255, tbl.b * 255)
    return color
end

-- #FIXME
local function FormatBNPlayerName(misc, id, moreMisc, fakeName, tag, colon)
    local gameAccount = select(6, BNGetFriendInfoByID(id))
    if gameAccount then
        local _, charName, _, _, _, _, _, englishClass = BNGetGameAccountInfo(gameAccount)
        if englishClass and englishClass ~= '' then
            fakeName = '|cFF' .. GetColor(englishClass, true) .. fakeName .. '|r'
        end
    end
    return misc .. id .. moreMisc .. fakeName .. tag .. (colon == ':' and ':' or colon)
end

local function FormatPlayerName(info, name)
    return format('|Hplayer:%s|h%s|h', info, gsub(name, '%-[^|]+', ''))
end

local function RemoveRealmName(self, event, msg, author, ...)
    local realm = gsub(C.MyRealm, ' ', '')
    if msg:find('-' .. realm) then
        return false, gsub(msg, '%-' .. realm, ''), author, ...
    end
end

function CHAT:UpdateChannelNames(text, ...)
    -- Make whisper color different
    local r, g, b = ...
    if strfind(text, L['Tell'] .. ' |H[BN]*player.+%]') then
        r, g, b = r * .7, g * .7, b * .7
    end

    if C.DB.Chat.ShortenChannelName then
        -- Shorten world channel name
        --[[ text = gsub(text, '|h%[(%d+)%. 大脚世界频道%]|h', '|h%[世界%]|h')
        text = gsub(text, '|h%[(%d+)%. 大腳世界頻道%]|h', '|h%[世界%]|h')
        text = gsub(text, '|h%[(%d+)%. BigfootWorldChannel%]|h', '|h%[WC%]|h') ]]

        -- Shorten other channel name
        text = gsub(text, '|h%[(%d+)%. .-%]|h', '|h%1.|h')
    end

    -- Remove brackets from player name
    text = gsub(text, '|Hplayer:(.-)|h%[(.-)%]|h', FormatPlayerName)
    -- text = gsub(text, '(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)', FormatBNPlayerName)

    -- Remove brackets from item and spell links
    -- text = gsub(text, '|r|h:(.+)|cff(.+)|H(.+)|h%[(.+)%]|h|r', '|r|h:%1%4')

    return self.oldAddMsg(self, text, r, g, b)
end

function CHAT:Abbreviation()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        if i ~= 2 then
            local chatFrame = _G['ChatFrame' .. i]
            chatFrame.oldAddMsg = chatFrame.AddMessage
            chatFrame.AddMessage = CHAT.UpdateChannelNames
        end
    end

    ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', RemoveRealmName)

    -- online/offline info
    _G.ERR_FRIEND_ONLINE_SS = gsub(_G.ERR_FRIEND_ONLINE_SS, '%]%|h', ']|h|cff00c957')
    _G.ERR_FRIEND_OFFLINE_S = gsub(_G.ERR_FRIEND_OFFLINE_S, '%%s', '%%s|cffff7f50')

    -- whisper
    _G.CHAT_WHISPER_INFORM_GET = L['Tell'] .. ' %s '
    _G.CHAT_WHISPER_GET = L['From'] .. ' %s '
    _G.CHAT_BN_WHISPER_INFORM_GET = L['Tell'] .. ' %s '
    _G.CHAT_BN_WHISPER_GET = L['From'] .. ' %s '

    -- say / yell
    _G.CHAT_SAY_GET = '%s '
    _G.CHAT_YELL_GET = '%s '

    -- guild
    _G.CHAT_GUILD_GET = '|Hchannel:GUILD|h[G]|h %s '
    _G.CHAT_OFFICER_GET = '|Hchannel:OFFICER|h[O]|h %s '

    -- raid
    _G.CHAT_RAID_GET = '|Hchannel:RAID|h[R]|h %s '
    _G.CHAT_RAID_WARNING_GET = '[RW] %s '
    _G.CHAT_RAID_LEADER_GET = '|Hchannel:RAID|h[RL]|h %s '

    -- party
    _G.CHAT_PARTY_GET = '|Hchannel:PARTY|h[P]|h %s '
    _G.CHAT_PARTY_LEADER_GET = '|Hchannel:PARTY|h[PL]|h %s '
    _G.CHAT_PARTY_GUIDE_GET = '|Hchannel:PARTY|h[PG]|h %s '

    -- instance
    _G.CHAT_INSTANCE_CHAT_GET = '|Hchannel:INSTANCE|h[I]|h %s '
    _G.CHAT_INSTANCE_CHAT_LEADER_GET = '|Hchannel:INSTANCE|h[IL]|h %s '

    _G.CHAT_CHANNEL_GET = '%s: '

    -- flags
    _G.CHAT_FLAG_AFK = '|cff808080[AFK]|r '
    _G.CHAT_FLAG_DND = '|cff808080[DND]|r '
    _G.CHAT_FLAG_GM = '|cffff0000[GM]|r '
end
