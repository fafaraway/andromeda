local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local function CheckChannel()
    return IsPartyLFG() and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or 'PARTY'
end

local lastVCTime, isVCInit = 0
function NOTIFICATION:VersionCheck_Compare(new, old)
    local new1, new2 = string.split('.', new)
    new1, new2 = tonumber(new1), tonumber(new2)

    local old1, old2 = string.split('.', old)
    old1, old2 = tonumber(old1), tonumber(old2)

    if not old1 then
        return
    end

    if new1 > old1 or (new1 == old1 and new2 > old2) then
        return 'IsNew'
    elseif new1 < old1 or (new1 == old1 and new2 < old2) then
        return 'IsOld'
    end
end

function NOTIFICATION:VersionCheck_Create(text)
    if not _G.ANDROMEDA_ADB.VersionCheck then
        return
    end

    F:CreateNotification(C.ADDON_NAME, text, nil, 'Interface\\ICONS\\ability_warlock_soulswap')
    F:Print(text)
end

function NOTIFICATION:VersionCheck_Init()
    if not isVCInit then
        local status = NOTIFICATION:VersionCheck_Compare(_G.ANDROMEDA_ADB.DetectVersion, C.ADDON_VERSION)
        if status == 'IsNew' then
            local ver = string.gsub(_G.ANDROMEDA_ADB.DetectVersion, '(%d+)$', '0')
            NOTIFICATION:VersionCheck_Create(
                string.format('%s has been out of date, the latest release is |cffff0000%s|r.', C.ADDON_NAME, ver)
            )
        elseif status == 'IsOld' then
            _G.ANDROMEDA_ADB.DetectVersion = C.ADDON_VERSION
        end

        isVCInit = true
    end
end

function NOTIFICATION:VersionCheck_Send(channel)
    if GetTime() - lastVCTime >= 10 then
        C_ChatInfo.SendAddonMessage('AndromedaUIVersionCheck', _G.ANDROMEDA_ADB.DetectVersion, channel)
        lastVCTime = GetTime()
    end
end

function NOTIFICATION:VersionCheck_Update(...)
    local prefix, msg, distType, author = ...
    if prefix ~= 'AndromedaUIVersionCheck' then
        return
    end
    if Ambiguate(author, 'none') == C.MY_NAME then
        return
    end

    local status = NOTIFICATION:VersionCheck_Compare(msg, _G.ANDROMEDA_ADB.DetectVersion)
    if status == 'IsNew' then
        _G.ANDROMEDA_ADB.DetectVersion = msg
    elseif status == 'IsOld' then
        NOTIFICATION:VersionCheck_Send(distType)
    end

    NOTIFICATION:VersionCheck_Init()
end

function NOTIFICATION:VersionCheck_UpdateGroup()
    if not IsInGroup() then
        return
    end
    NOTIFICATION:VersionCheck_Send(CheckChannel())
end

function NOTIFICATION:VersionCheck()
    NOTIFICATION:VersionCheck_Init()
    C_ChatInfo.RegisterAddonMessagePrefix('AndromedaUIVersionCheck')
    F:RegisterEvent('CHAT_MSG_ADDON', NOTIFICATION.VersionCheck_Update)

    if IsInGuild() then
        C_ChatInfo.SendAddonMessage('AndromedaUIVersionCheck', C.ADDON_VERSION, 'GUILD')
        lastVCTime = GetTime()
    end

    NOTIFICATION:VersionCheck_UpdateGroup()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', NOTIFICATION.VersionCheck_UpdateGroup)
end
