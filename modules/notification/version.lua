local _G = _G
local select = select
local unpack = unpack
local format = format
local strsplit = strsplit
local gsub = gsub
local Ambiguate = Ambiguate
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local GetTime = GetTime
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix

local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F.NOTIFICATION

local lastVCTime, isVCInit = 0

local function msgChannel()
    return IsPartyLFG() and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or 'PARTY'
end

function NOTIFICATION:VersionCheck_Compare(new, old)
    local new1, new2 = strsplit('.', new)
    new1, new2 = tonumber(new1), tonumber(new2)

    local old1, old2 = strsplit('.', old)
    old1, old2 = tonumber(old1), tonumber(old2)

    if new1 > old1 or (new1 == old1 and new2 > old2) then
        return 'IsNew'
    elseif new1 < old1 or (new1 == old1 and new2 < old2) then
        return 'IsOld'
    end
end

function NOTIFICATION:VersionCheck_Create(text)
    F:CreateNotification(L['NOTIFICATION_VERSION'], C.BlueColor .. L['NOTIFICATION_VERSION_OUTDATE'], nil, 'Interface\\ICONS\\ability_warlock_soulswap')
    F:Print(format(L['NOTIFICATION_VERSION_OUTDATE'], text))
end

function NOTIFICATION:VersionCheck_Init()
    if not isVCInit then
        local status = NOTIFICATION:VersionCheck_Compare(_G.FREE_ADB.DetectVersion, C.AddonVersion)
        if status == 'IsNew' then
            local release = gsub(_G.FREE_ADB.DetectVersion, '(%d+)$', '0')
            NOTIFICATION:VersionCheck_Create(release)
        elseif status == 'IsOld' then
            _G.FREE_ADB.DetectVersion = C.AddonVersion
        end

        isVCInit = true
    end
end

function NOTIFICATION:VersionCheck_Send(channel)
    if GetTime() - lastVCTime >= 10 then
        C_ChatInfo_SendAddonMessage('FreeUIVersionCheck', _G.FREE_ADB.DetectVersion, channel)
        lastVCTime = GetTime()
    end
end

function NOTIFICATION:VersionCheck_Update(...)
    local prefix, msg, distType, author = ...
    if prefix ~= 'FreeUIVersionCheck' then
        return
    end
    if Ambiguate(author, 'none') == C.MyName then
        return
    end

    local status = NOTIFICATION:VersionCheck_Compare(msg, _G.FREE_ADB.DetectVersion)
    if status == 'IsNew' then
        _G.FREE_ADB.DetectVersion = msg
    elseif status == 'IsOld' then
        NOTIFICATION:VersionCheck_Send(distType)
    end

    NOTIFICATION:VersionCheck_Init()
end

function NOTIFICATION:VersionCheck_UpdateGroup()
    if not IsInGroup() then
        return
    end
    NOTIFICATION:VersionCheck_Send(msgChannel())
end

function NOTIFICATION:VersionCheck()
    if not C.DB.notification.version_check then
        return
    end
    if C.isDeveloper then
        return
    end

    NOTIFICATION:VersionCheck_Init()
    C_ChatInfo_RegisterAddonMessagePrefix('FreeUIVersionCheck')
    F:RegisterEvent('CHAT_MSG_ADDON', NOTIFICATION.VersionCheck_Update)

    if IsInGuild() then
        C_ChatInfo_SendAddonMessage('FreeUIVersionCheck', C.AddonVersion, 'GUILD')
        lastVCTime = GetTime()
    end
    NOTIFICATION:VersionCheck_UpdateGroup()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', NOTIFICATION.VersionCheck_UpdateGroup)
end
