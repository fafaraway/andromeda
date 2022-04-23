local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local ABBREVIATIONS = {
    OFFICER = 'O',
    GUILD = 'G',
    PARTY_LEADER = '|cffffff00!|rP',
    PARTY = 'P',
    RAID_LEADER = '|cffffff00!|rR',
    RAID = 'R',
    INSTANCE_CHAT = 'I',
}

local CLIENT_DEFAULT_COLOR = '22aaff'
local CLIENT_COLORS = {
    [_G.BNET_CLIENT_WOW] = '5cc400',
    [_G.BNET_CLIENT_D3] = 'b71709',
    [_G.BNET_CLIENT_SC2] = '00b6ff',
    [_G.BNET_CLIENT_WTCG] = 'd37000',
    [_G.BNET_CLIENT_HEROES] = '6800c4',
    [_G.BNET_CLIENT_OVERWATCH] = 'dcdcef',
}

local function getClientColorAndTag(accountID)
    local account = C_BattleNet.GetAccountInfoByID(accountID)
    local accountClient = account.gameAccountInfo.clientProgram
    return CLIENT_COLORS[accountClient] or CLIENT_DEFAULT_COLOR, account.battleTag:match('(%w+)#%d+')
end

local FORMAT_PLAYER = '|Hplayer:%s|h%s|h'
local function formatPlayer(info, name)
    return FORMAT_PLAYER:format(info, name:gsub('%-[^|]+', ''))
end

local FORMAT_BN_PLAYER = '|HBNplayer:%s|h|cff%s%s|r|h'
local function formatBNPlayer(info)
    -- replace the colors with a client color
    local color, tag = getClientColorAndTag(info:match('(%d+):'))
    return FORMAT_BN_PLAYER:format(info, color, tag)
end

local FORMAT_CHANNEL = '|Hchannel:%s|h%s|h %s'
local function formatChannel(info)
    if not C.DB.Chat.ShortenChannelName then return end

    return FORMAT_CHANNEL:format(info, ABBREVIATIONS[info] or info:gsub('channel:', ''), '')
end

local FORMAT_WAYPOINT_FAR = '|Hworldmap:%d:%d:%d|h[%s: %.2f, %.2f]|h'
local FORMAT_WAYPOINT_NEAR = '|Hworldmap:%d:%d:%d|h[%.2f, %.2f]|h'
local function formatWaypoint(mapID, x, y)
    local playerMapID = C_Map.GetBestMapForUnit('player')
    if tonumber(mapID) ~= playerMapID then
        local mapInfo = C_Map.GetMapInfo(mapID)
        return FORMAT_WAYPOINT_FAR:format(mapID, x, y, mapInfo.name, x / 100, y / 100)
    else
        return FORMAT_WAYPOINT_NEAR:format(mapID, x, y, x / 100, y / 100)
    end
end

local chatFrameHooks = {}
local function addMessage(chatFrame, msg, ...)
    -- different whisper color
    local r, g, b = ...
    if string.find(msg, L['Tell'] .. ' |H[BN]*player.+%]') then
        r, g, b = r * 0.5, g * 0.5, b * 0.5
    end

    -- remove realm and bracket
    msg = msg:gsub('|Hplayer:(.-)|h%[(.-)%]|h', formatPlayer)
    -- msg = msg:gsub('|HBNplayer:(.-)|h%[(.-)%]|h', formatBNPlayer)

    msg = msg:gsub('|Hchannel:(.-)|h%[(.-)%]|h', formatChannel)

    -- msg = msg:gsub('^%w- (|H)', '|cffa1a1a1@|r%1')
    -- msg = msg:gsub('^(.-|h) %w-:', '%1:')
    msg = msg:gsub('^%[' .. _G.RAID_WARNING .. '%]', 'RW')

    msg = msg:gsub('|Hworldmap:(.-):(.-):(.-)|h%[(.-)%]|h', formatWaypoint)

    msg = msg:gsub(_G.CHAT_FLAG_AFK, '')
    msg = msg:gsub(_G.CHAT_FLAG_DND, '')

    msg = msg:gsub('|h：', '|h ')
    msg = msg:gsub('|h:', '|h ')

    return chatFrameHooks[chatFrame](chatFrame, msg, r, g, b)
end

function CHAT:Abbreviation()
    for index = 1, _G.NUM_CHAT_WINDOWS do
        if index ~= 2 then -- ignore combat frame
            -- override the message injection
            local chatFrame = _G['ChatFrame' .. index]
            chatFrameHooks[chatFrame] = chatFrame.AddMessage
            chatFrame.AddMessage = addMessage
        end
    end

    -- whisper
    _G.CHAT_WHISPER_INFORM_GET = L['Tell'] .. ' %s '
    _G.CHAT_WHISPER_GET = L['From'] .. ' %s '
    _G.CHAT_BN_WHISPER_INFORM_GET = L['Tell'] .. ' %s '
    _G.CHAT_BN_WHISPER_GET = L['From'] .. ' %s '
    _G.CHAT_WHISPER_SEND = L['Tell'] .. ' %s '

    -- say / yell
    _G.CHAT_SAY_GET = '%s '
    _G.CHAT_YELL_GET = '%s '
end
