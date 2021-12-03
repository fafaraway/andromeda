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
    [4] = 'necrolord'
}

local covenantColor = {
    [1] = _G.COVENANT_COLORS.Kyrian,
    [2] = _G.COVENANT_COLORS.Venthyr,
    [3] = _G.COVENANT_COLORS.NightFae,
    [4] = _G.COVENANT_COLORS.Necrolord
}

local covenantSpells = {
    -- Kyrian
    [323436] = 1, -- Purify Soul
    [324739] = 1, -- (General)  Summon Steward
    [312202] = 1, -- (Death Knight) Shackle the Unworthy
    [306830] = 1, -- (Demon Hunter) Elysian Decree
    [326434] = 1, -- (Druid)   Kindred Spirits
    [338142] = 1, -- Lone Empowerment (Druid)
    [338035] = 1, -- Lone Meditation (Druid)
    [338018] = 1, -- Lone Protection (Druid)
    [327022] = 1, -- Kindred Empowerment (Druid)
    [327037] = 1, -- Kindred Protection (Druid)
    [327071] = 1, -- Kindred Focus (Druid)
    [308491] = 1, -- (Hunter)   Resonating Arrow
    [307443] = 1, -- (Mage)   Radiant Spark
    [310454] = 1, -- (Monk)   Weapons of Order
    [304971] = 1, -- (Paladin)  Divine Toll
    [325013] = 1, -- (Priest)   Boon of the Ascended
    [323547] = 1, -- (Rogue)   Echoing Reprimand
    [324386] = 1, -- (Shaman)   Vesper Totem
    [312321] = 1, -- (Warlock)  Scouring Tithe
    [307865] = 1, -- (Warrior)  Spear of Bastion
    -- Venthyr
    [300728] = 2, -- (General)  Door of Shadows
    [311648] = 2, -- (Death Knight) Swarming Mist
    [317009] = 2, -- (Demon Hunter) Sinful Brand
    [323546] = 2, -- (Druid)   Ravenous Frenzy
    [324149] = 2, -- (Hunter)   Flayed Shot
    [314793] = 2, -- (Mage)   Mirrors of Torment
    [326860] = 2, -- (Monk)   Fallen Order
    [316958] = 2, -- (Paladin)  Ashen Hollow
    [323673] = 2, -- (Priest)   Mindgames
    [323654] = 2, -- (Rogue)   Flagellation
    [320674] = 2, -- (Shaman)   Chain Harvest
    [321792] = 2, -- (Warlock)  Impending Catastrophe
    [317349] = 2, -- (Warrior)  Condemn
    [317483] = 2, -- Condemn (Warrior)
    [317488] = 2, -- Condemn (Warrior)
    -- Night Fae
    [319217] = 3, -- Podtender
    [310143] = 3, -- (General)  Soulshape
    [324701] = 3, -- (General)  Flicker
    [324128] = 3, -- (Death Knight) Death's Due
    [323639] = 3, -- (Demon Hunter) The Hunt
    [323764] = 3, -- (Druid)   Convoke the Spirits
    [328231] = 3, -- (Hunter)   Wild Spirits
    [314791] = 3, -- (Mage)   Shifting Power
    [327104] = 3, -- (Monk)   Faeline Stomp
    [328278] = 3, -- (Paladin)  Blessing of the Seasons
    [328282] = 3, -- (Paladin)  Blessing of Spring
    [328620] = 3, -- (Paladin)  Blessing of Summer
    [328622] = 3, -- (Paladin)  Blessing of Autumn
    [328281] = 3, -- (Paladin)  Blessing of Winter
    [327661] = 3, -- (Priest)   Fae Guardians
    [328305] = 3, -- (Rogue)   Sepsis
    [328923] = 3, -- (Shaman)   Fae Transfusion
    [325640] = 3, -- (Warlock)  Soul Rot
    [325886] = 3, -- (Warrior)  Ancient Aftershock
    -- Necrolord
    [324631] = 4, -- (General)  Fleshcraft
    [315443] = 4, -- (Death Knight) Abomination Limb
    [329554] = 4, -- (Demon Hunter) Fodder to the Flame
    [325727] = 4, -- (Druid)   Adaptive Swarm
    [325028] = 4, -- (Hunter)   Death Chakram
    [324220] = 4, -- (Mage)   Deathborne
    [325216] = 4, -- (Monk)   Bonedust Brew
    [328204] = 4, -- (Paladin)  Vanquisher's Hammer
    [324724] = 4, -- (Priest)   Unholy Aura
    [328547] = 4, -- (Rogue)   Serrated Bone Spike
    [326059] = 4, -- (Shaman)   Primordial Wave
    [325289] = 4, -- (Warlock)  Decimating Bolt
    [324143] = 4 -- (Warrior)  Conqueror's Banner
}

local addonPrefixes = {
    [ZT_Prefix] = true,
    [DC_Prefix] = true,
    [OmniCD_Prefix] = true,
    [MRT_Prefix] = true
}

function M:GetCovenantIcon(covenantID)
    local covenant = covenantList[covenantID]
    if covenant then
        return string.format('|A:sanctumupgrades-' .. covenantList[covenantID] .. '-32x32:16:16|a')
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
        if name and name ~= C.MyName and not cache[name] then
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
    if sender == C.MyName then
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
                    F:Debug('%s 盟约：%s (by ZenTracker)', sender, covenantList[covenantID] or 'None')
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
                    F:Debug('%s 盟约：%s (by OmniCD)', sender, covenantList[covenantID] or 'None')
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
            F:Debug('%s 盟约：%s (by Details_Covenants)', sender, covenantList[covenantID] or 'None')
        end
    elseif prefix == MRT_Prefix then
        local modPrefix, subPrefix, soulbinds = string.split('\t', msg)
        if (modPrefix and modPrefix == 'inspect') and (subPrefix and subPrefix == 'R') and (soulbinds and string.sub(soulbinds, 1, 1) == 'S') then
            local guid = UnitGUID(sender)
            local covenantID = select(2, string.split(':', soulbinds))
            covenantID = tonumber(covenantID)
            if covenantID and guid and (not memberCovenants[guid] or memberCovenants[guid] ~= covenantID) then
                memberCovenants[guid] = covenantID
                F:Debug('%s 盟约：%s (by MRT)', sender, covenantList[covenantID] or 'None')
            end
        end
    end
end

function M:HandleSpellCast(unit, _, spellID)
    local covenantID = covenantSpells[spellID]
    if covenantID then
        local guid = UnitGUID(unit)
        if guid and (not memberCovenants[guid] or memberCovenants[guid] ~= covenantID) then
            memberCovenants[guid] = covenantID

            F:Debug('%s 盟约：%s (by %s)', GetUnitName(unit, true), covenantList[covenantID], GetSpellLink(spellID))
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
        _G.GameTooltip:AddLine(string.format('%s %s %s', C.WhiteColor .. L['Covenant'] .. ':|r', M:GetCovenantName(covenantID), M:GetCovenantIcon(covenantID)))
    end
end

function M:Covenant()
    LibRS = _G.LibStub and _G.LibStub('LibOpenRaid-1.0', true)
    DCLoaded = IsAddOnLoaded('Details_Covenants')

    for prefix in pairs(addonPrefixes) do
        C_ChatInfo.RegisterAddonMessagePrefix(prefix)
    end

    M:UpdateRosterInfo()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', M.UpdateRosterInfo)
    F:RegisterEvent('CHAT_MSG_ADDON', M.HandleAddonMessage)
    -- F:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', M.HandleSpellCast)
end
