local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Tooltip')

local LibRS
local DCLoaded
local debug = false

local ZT_Prefix = 'ZenTracker'
local DC_Prefix = 'DCOribos'
local OmniCD_Prefix = 'OmniCD'
local MRT_Prefix = 'EXRTADD'

local memberCovenants = {}

local covenantList = {
    [1] = 'kyrian',
    [2] = 'venthyr',
    [3] = 'nightfae',
    [4] = 'necrolord',
}

local covenantColor = {
    [1] = _G.COVENANT_COLORS.Kyrian,
    [2] = _G.COVENANT_COLORS.Venthyr,
    [3] = _G.COVENANT_COLORS.NightFae,
    [4] = _G.COVENANT_COLORS.Necrolord,
}

local addonPrefixes = {
    [ZT_Prefix] = true,
    [DC_Prefix] = true,
    [OmniCD_Prefix] = true,
    [MRT_Prefix] = true,
}

function M:GetCovenantIcon(covenantID)
    local covenant = covenantList[covenantID]
    if covenant then
        return string.format('|A:sanctumupgrades-' .. covenantList[covenantID] .. '-32x32:16:16|a ')
    end

    return ''
end

local covenantIDToName = {}
function M:GetCovenantName(covenantID)
    if not covenantIDToName[covenantID] then
        local covenantData = C_Covenants.GetCovenantData(covenantID)

        covenantIDToName[covenantID] = covenantData and covenantData.name
    end
    local color = covenantColor[covenantID]
    return color:WrapTextInColorCode(covenantIDToName[covenantID])
end

function M:GetCovenantID(unit)
    local guid = UnitGUID(unit)
    if not guid then
        return
    end

    local covenantID = memberCovenants[guid]
    if not covenantID then
        local playerInfo = LibRS and LibRS.playerInfoManager.GetPlayerInfo(GetUnitName(unit, true))
        return playerInfo and playerInfo.covenantId
    end

    return covenantID
end

local function msgChannel()
    return IsPartyLFG() and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or 'PARTY'
end

local cache = {}
function M:UpdateRosterInfo()
    if not IsInGroup() then
        return
    end

    for i = 1, GetNumGroupMembers() do
        local name = GetRaidRosterInfo(i)
        if name and name ~= C.NAME and not cache[name] then
            if not DCLoaded then
                C_ChatInfo.SendAddonMessage(DC_Prefix, string.format('ASK:%s', name), msgChannel())
            end
            C_ChatInfo.SendAddonMessage(MRT_Prefix, string.format('inspect\tREQ\tS\t%s', name), msgChannel())

            cache[name] = true
        end
    end

    if LibRS then
        LibRS.RequestAllPlayersInfo()
    end
end

function M:HandleAddonMessage(...)
    local prefix, msg, _, sender = ...
    sender = Ambiguate(sender, 'none')
    if sender == C.NAME then
        return
    end

    if prefix == ZT_Prefix then
        local version, type, guid, _, _, _, _, covenantID = string.split(':', msg)
        version = tonumber(version)
        if (version and version > 3) and (type and type == 'H') and guid then
            covenantID = tonumber(covenantID)
            if covenantID and (not memberCovenants[guid] or memberCovenants[guid] ~= covenantID) then
                memberCovenants[guid] = covenantID

                if debug then
                    F:Debug('%s Covenant: %s (by ZenTracker)', sender, covenantList[covenantID] or 'None')
                end
            end
        end
    elseif prefix == OmniCD_Prefix then
        local header, guid, body = string.match(msg, '(.-),(.-),(.+)')
        if (header and guid and body) and (header == 'INF' or header == 'REQ' or header == 'UPD') then
            local covenantID = select(15, string.split(',', body))
            covenantID = tonumber(covenantID)
            if covenantID and (not memberCovenants[guid] or memberCovenants[guid] ~= covenantID) then
                memberCovenants[guid] = covenantID

                if debug then
                    F:Debug('%s Covenant: %s (by OmniCD)', sender, covenantList[covenantID] or 'None')
                end
            end
        end
    elseif prefix == DC_Prefix then
        local playerName, covenantID = string.split(':', msg)
        if playerName == 'ASK' then
            return
        end

        local guid = UnitGUID(sender)
        covenantID = tonumber(covenantID)
        if covenantID and guid and (not memberCovenants[guid] or memberCovenants[guid] ~= covenantID) then
            memberCovenants[guid] = covenantID

            if debug then
                F:Debug('%s Covenant: %s (by Details_Covenants)', sender, covenantList[covenantID] or 'None')
            end
        end
    elseif prefix == MRT_Prefix then
        local modPrefix, subPrefix, soulbinds = string.split('\t', msg)
        if
            (modPrefix and modPrefix == 'inspect')
            and (subPrefix and subPrefix == 'R')
            and (soulbinds and string.sub(soulbinds, 1, 1) == 'S')
        then
            local guid = UnitGUID(sender)
            local covenantID = select(2, string.split(':', soulbinds))
            covenantID = tonumber(covenantID)
            if covenantID and guid and (not memberCovenants[guid] or memberCovenants[guid] ~= covenantID) then
                memberCovenants[guid] = covenantID

                if debug then
                    F:Debug('%s Covenant: %s (by MRT)', sender, covenantList[covenantID] or 'None')
                end
            end
        end
    end
end

function M:AddCovenantInfo()
    if not C.DB.Tooltip.Covenant then
        return
    end
    if C.DB.Tooltip.PlayerInfoByAlt and not IsAltKeyDown() then
        return
    end

    if not IsInGroup() then
        return
    end

    local _, unit = _G.GameTooltip:GetUnit()
    if not unit or not UnitExists(unit) then
        return
    end

    local covenantID
    if UnitIsUnit(unit, 'player') then
        covenantID = C_Covenants.GetActiveCovenantID()
    else
        covenantID = M:GetCovenantID(unit)
    end

    if covenantID and covenantID ~= 0 then
        _G.GameTooltip:AddLine(
            string.format(
                '%s %s %s',
                C.WHITE_COLOR .. L['Covenant'] .. ':|r',
                M:GetCovenantName(covenantID),
                M:GetCovenantIcon(covenantID)
            )
        )
    end
end

function M:CovenantInfo()
    LibRS = _G.LibStub and _G.LibStub('LibOpenRaid-1.0', true)
    DCLoaded = IsAddOnLoaded('Details_Covenants')

    for prefix in pairs(addonPrefixes) do
        C_ChatInfo.RegisterAddonMessagePrefix(prefix)
    end

    M:UpdateRosterInfo()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', M.UpdateRosterInfo)
    F:RegisterEvent('CHAT_MSG_ADDON', M.HandleAddonMessage)
end
