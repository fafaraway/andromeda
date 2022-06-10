local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local playerString = '|Hplayer:%s|h%s|h'
local function formatPlayer(info, name)
    return playerString:format(info, name:gsub('%-[^|]+', ''))
end

local waypointStringFar = '|Hworldmap:%d:%d:%d|h[%s: %.2f, %.2f]|h'
local waypointStringNear = '|Hworldmap:%d:%d:%d|h[%.2f, %.2f]|h'
local function formatWaypoint(mapID, x, y)
    local playerMapID = C_Map.GetBestMapForUnit('player')
    if tonumber(mapID) ~= playerMapID then
        local mapInfo = C_Map.GetMapInfo(mapID)
        return waypointStringFar:format(mapID, x, y, mapInfo.name, x / 100, y / 100)
    else
        return waypointStringNear:format(mapID, x, y, x / 100, y / 100)
    end
end

function CHAT:UpdateChannelNames(text, ...)
    if string.find(text, _G.INTERFACE_ACTION_BLOCKED) and not C.IS_DEVELOPER then
        return
    end

    -- Different whisper color
    local r, g, b = ...
    if strfind(text, L['Tell'] .. ' |H[BN]*player.+%]') then
        r, g, b = r * 0.7, g * 0.7, b * 0.7
    end

    -- Dev logo
    local unitName = string.match(text, '|Hplayer:([^|:]+)')
    if unitName and C.DevsList[unitName] then
        text = string.gsub(text, '(|Hplayer.+)', '|T' .. C.Assets.Texture.LogoChat .. ':12:12|t %1')
    end

    -- Remove realm and bracket
    text = gsub(text, '|Hplayer:(.-)|h%[(.-)%]|h', formatPlayer)

    -- Format waypoint
    text = string.gsub(text, '|Hworldmap:(.-):(.-):(.-)|h%[(.-)%]|h', formatWaypoint)

    -- Shorten channel name
    if C.DB.Chat.ShortenChannelName then
        text = string.gsub(text, '|h%[(%d+)%. 大脚世界频道%]|h', '|h%[%1%. 世界%]|h')
        text = string.gsub(text, '|h%[(%d+)%. 大腳世界頻道%]|h', '|h%[%1%. 世界%]|h')
        -- text = string.gsub(text, '|h：', '|h ')
        -- text = string.gsub(text, '|h:', '|h ')
        text = string.gsub(text, '|h：', '|h:')

        return self.oldAddMsg(self, string.gsub(text, '|h%[(%d+)%..-%]|h', '|h[%1]|h'), r, g, b)
    end
end

function CHAT:ShortenChannelNames()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        if i ~= 2 then
            local chatFrame = _G['ChatFrame' .. i]
            chatFrame.oldAddMsg = chatFrame.AddMessage
            chatFrame.AddMessage = CHAT.UpdateChannelNames
        end
    end

    -- online/offline info
    _G.ERR_FRIEND_ONLINE_SS = string.gsub(_G.ERR_FRIEND_ONLINE_SS, '%]%|h', ']|h|cff00c957')
    _G.ERR_FRIEND_OFFLINE_S = string.gsub(_G.ERR_FRIEND_OFFLINE_S, '%%s', '%%s|cffff7f50')

    -- whisper
    _G.CHAT_WHISPER_INFORM_GET = L['Tell'] .. ' %s '
    _G.CHAT_WHISPER_GET = L['From'] .. ' %s '
    _G.CHAT_BN_WHISPER_INFORM_GET = L['Tell'] .. ' %s '
    _G.CHAT_BN_WHISPER_GET = L['From'] .. ' %s '

    -- say / yell
    _G.CHAT_SAY_GET = '%s '
    _G.CHAT_YELL_GET = '%s '

    if C.DB.Chat.ShortenChannelName then
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

        -- flags
        _G.CHAT_FLAG_AFK = '[AFK] '
        _G.CHAT_FLAG_DND = '[DND] '
        _G.CHAT_FLAG_GM = '[GM] '
    end
end
