local _G = getfenv(0)
local unpack = _G.unpack
local select = _G.select

local _, C = unpack(select(2, ...))

C.FeastsList = {
    [308458] = true, -- Surprisingly Palatable Feast
    [308462] = true -- Feast of Gluttonous Hedonism
}

C.CauldronList = {
    [307157] = true -- Eternal Cauldron
}

C.BotsList = {
    [22700] = true, -- Field Repair Bot 74A
    [44389] = true, -- Field Repair Bot 110G
    [54711] = true, -- Scrapbot
    [67826] = true, -- Jeeves
    [126459] = true, -- Blingtron 4000
    [161414] = true, -- Blingtron 5000
    [298926] = true, -- Blingtron 7000
    [199109] = true -- Auto-Hammer
}

C.CodexList = {
    [324029] = true -- Codex of the Still Mind
}

C.ToysList = {
    [61031] = true, -- Toy Train Set
    [49844] = true -- Direbrew's Remote
}

C.PortalsList = {
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
    [344597] = true -- Oribos
}

C.BattleRezList = {
    [61999] = true, -- Raise Ally
    [20484] = true, -- Rebirth
    [20707] = true, -- Soulstone
    [345130] = true -- Disposable Spectrophasic Reanimator
}

C.AnnounceableSpellsList = {
    -- Paladin
    [1044] = true, -- Blessing of Freedom
    [204018] = true, -- Blessing of Spellwarding
    [6940] = true, -- Blessing of Sacrifice
    [1022] = true, -- Blessing of Protection
    [498] = true, -- Divine Protection
    [31850] = true, -- Ardent Defender
    [86659] = true, -- Guardian of Ancient Kings
    [212641] = true, -- Guardian of Ancient Kings (Glyph)
    [642] = true, -- Divine Shield
    [31884] = true, -- Avenging Wrath
    [633] = true, -- Lay On Hands
    [31821] = true, -- Aura Mastery

    -- Warrior
    [97462] = true, -- Rallying Cry

    -- Demon Hunter
    [196718] = true, -- Darkness

    -- Death Knight
    [51052] = true, -- Anti-Magic Zone
    [15286] = true, -- Vampiric Embrace

    -- Priest
    [246287] = true, -- Evangelism
    [265202] = true, -- Holy Word: Salvation
    [200183] = true, -- Apotheosis
    [62618] = true, -- Power Word: Barrier
    [64843] = true, -- Divine Hymn
    [64901] = true, -- Symbol of Hope
    [47536] = true, -- Rapture
    [109964] = true, -- Spirit Shell
    [33206] = true, -- Pain Suppression
    [47788] = true, -- Guardian Spirit

    -- Shaman
    [207399] = true, -- Ancestral Protection Totem
    [108280] = true, -- Healing Tide Totem
    [98008] = true, -- Spirit Link Totem
    [114052] = true, -- Ascendance
    [16191] = true, -- Mana Tide Totem
    [108281] = true, -- Ancestral Guidance
    [198838] = true, -- Earthen Wall Totem

    -- Druid
    [740] = true, -- Tranquility
    [33891] = true, -- Incarnation: Tree of Life
    [197721] = true, -- Flourish
    [205636] = true, -- Force of Nature

    -- Monk
    [115310] = true, -- Revival
    [325197] = true, -- Invoke Chi-Ji, the Red Crane
    [116849] = true, -- Life Cocoon
    [322118] = true, -- Invoke Yu'lon, the Jade Serpent

    -- Covenants
    [316958] = true, -- Ashen Hallow
}
