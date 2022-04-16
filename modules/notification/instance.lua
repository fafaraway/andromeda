local F, _, L = unpack(select(2, ...))
local N = F:GetModule('Notification')

local feasts = {
    [308458] = true, -- Surprisingly Palatable Feast
    [308462] = true, -- Feast of Gluttonous Hedonism
    [359336] = true, -- Prepare Kettle of Stone Soup
}

local bots = {
    [22700] = true, -- Field Repair Bot 74A
    [44389] = true, -- Field Repair Bot 110G
    [54711] = true, -- Scrapbot
    [67826] = true, -- Jeeves
    [126459] = true, -- Blingtron 4000
    [161414] = true, -- Blingtron 5000
    [298926] = true, -- Blingtron 7000
    [199109] = true, -- Auto-Hammer
}

local portals = {
    -- Alliance
    [10059] = true, -- Stormwind
    [11416] = true, -- Ironforge
    [11419] = true, -- Darnassus
    [32266] = true, -- Exodar
    [49360] = true, -- Theramore
    [33691] = true, -- Shattrath
    [88345] = true, -- Tol Barad
    [132620] = true, -- Vale of Eternal Blossoms
    [176246] = true, -- Stormshield
    [281400] = true, -- Boralus
    -- Horde
    [11417] = true, -- Orgrimmar
    [11420] = true, -- Thunder Bluff
    [11418] = true, -- Undercity
    [32267] = true, -- Silvermoon
    [49361] = true, -- Stonard
    [35717] = true, -- Shattrath
    [88346] = true, -- Tol Barad
    [132626] = true, -- Vale of Eternal Blossoms
    [176244] = true, -- Warspear
    [281402] = true, -- Dazar'alor
    -- Neutral
    [53142] = true, -- Dalaran
    [120146] = true, -- Ancient Dalaran
    [224871] = true, -- Dalaran, Broken Isles
    [344597] = true, -- Oribos
}

local icons = {
    food = 'Interface\\ICONS\\INV_Misc_Food_15',
    portal = 'Interface\\ICONS\\Spell_Arcane_PortalStormWind',
    cauldron = 'Interface\\ICONS\\INV_Misc_Cauldron_Arcane',
    codex = 'Interface\\ICONS\\INV_7XP_Inscription_TalentTome01',
    soulwell = 'Interface\\ICONS\\Spell_Shadow_Shadesofdarkness',
    mailbox = 'Interface\\ICONS\\INV_Letter_20',
    bot = 'Interface\\ICONS\\Ability_Repair',
}

function N:IsInMyGroup(flag)
    local inParty = IsInGroup() and _G.bit.band(flag, _G.COMBATLOG_OBJECT_AFFILIATION_PARTY) ~= 0
    local inRaid = IsInRaid() and _G.bit.band(flag, _G.COMBATLOG_OBJECT_AFFILIATION_RAID) ~= 0

    return inRaid or inParty
end

function N:Instance_OnEvent()
    if InCombatLockdown() then
        return
    end

    if not (IsInInstance() and IsInGroup() and GetNumGroupMembers() > 1) then
        return true
    end

    local _, eventType, _, _, srcName, srcFlags, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()

    if not eventType or not spellID or not srcName then
        return
    end

    if srcName then
        srcName = srcName:gsub('%-[^|]+', '')
    end

    if not N:IsInMyGroup(srcFlags) then
        return
    end

    if eventType == 'SPELL_CAST_SUCCESS' then
        if feasts[spellID] then
            F:CreateNotification(L['Food'], string.format(L['%s: %s'], srcName, GetSpellLink(spellID)), nil, icons.food)
        elseif spellID == 43987 then -- Mage Refreshment Table
            F:CreateNotification(L['Food'], string.format(L['%s: %s'], srcName, GetSpellLink(spellID)), nil, icons.food)
        elseif spellID == 307157 then -- Eternal Cauldron
            F:CreateNotification(
                L['Cauldron'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.cauldron
            )
        end
    elseif eventType == 'SPELL_SUMMON' then
        if bots[spellID] then
            F:CreateNotification(
                L['Repair'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.bot
            )
        elseif spellID == 324029 then -- Codex of the Still Mind
            F:CreateNotification(
                L['Codex'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.codex
            )
        elseif spellID == 261602 then -- Katy's Stampwhistle
            F:CreateNotification(
                L['Mailbox'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.mailbox
            )
        end
    elseif eventType == 'SPELL_CREATE' then
        if spellID == 29893 then -- Soulwell
            F:CreateNotification(
                L['Soulwell'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.soulwell
            )
        elseif spellID == 54710 then -- MOLL-E
            F:CreateNotification(
                L['Mailbox'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.mailbox
            )
        elseif portals[spellID] then -- Mage Portals
            F:CreateNotification(
                L['Portal'],
                string.format(L['%s: %s'], srcName, GetSpellLink(spellID)),
                nil,
                icons.portal
            )
        end
    end
end

function N:InstanceNotify()
    F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', N.Instance_OnEvent)
end
