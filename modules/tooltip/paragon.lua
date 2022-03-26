local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local PET = _G.PET
local MOUNT = _G.MOUNT
local TOY = _G.TOY
local ITEM_COSMETIC = _G.ITEM_COSMETIC
local BINDING_HEADER_OTHER = _G.BINDING_HEADER_OTHER

-- if GetLocale() == 'zhCN' then
--     _G.MOUNT = _G.MOUNTS
-- end

local PARAGON_DATA = {
    -- Legion
    [48976] = { -- Argussian Reach
        factionID = 2170,
        cache = 152922,
    },
    [46777] = { -- Armies of Legionfall
        factionID = 2045,
        cache = 152108,
        rewards = {
            { -- Orphaned Felbat
                type = PET,
                itemID = 147841,
            },
        },
    },
    [48977] = { -- Army of the Light
        factionID = 2165,
        cache = 152923,
        rewards = {
            { -- Avenging Felcrushed
                type = MOUNT,
                itemID = 153044,
                mountID = 985,
            },
            { -- Blessed Felcrushed
                type = MOUNT,
                itemID = 153043,
                mountID = 984,
            },
            { -- Glorious Felcrushed
                type = MOUNT,
                itemID = 153042,
                mountID = 983,
            },
            { -- Holy Lightsphere
                type = TOY,
                itemID = 153182,
            },
        },
    },
    [46745] = { -- Court of Farondis
        factionID = 1900,
        cache = 152102,
        rewards = {
            { -- Cloudwing Hippogryph
                type = MOUNT,
                itemID = 147806,
                mountID = 943,
            },
        },
    },
    [46747] = { -- Dreamweavers
        factionID = 1883,
        cache = 152103,
        rewards = {
            { -- Wild Dreamrunner
                type = MOUNT,
                itemID = 147804,
                mountID = 942,
            },
        },
    },
    [46743] = { -- Highmountain Tribes
        factionID = 1828,
        cache = 152104,
        rewards = {
            { -- Highmountain Elderhorn
                type = MOUNT,
                itemID = 147807,
                mountID = 941,
            },
        },
    },
    [46748] = { -- The Nightfallen
        factionID = 1859,
        cache = 152105,
        rewards = {
            { -- Leywoven Flying Carpet
                type = MOUNT,
                itemID = 143764,
                mountID = 905,
            },
        },
    },
    [46749] = { -- The Wardens
        factionID = 1894,
        cache = 152107,
        rewards = {
            { -- Sira's Extra Cloak
                type = TOY,
                itemID = 147843,
            },
        },
    },
    [46746] = { -- Valarjar
        factionID = 1948,
        cache = 152106,
        rewards = {
            { -- Valarjar Stormwing
                type = MOUNT,
                itemID = 147805,
                mountID = 944,
            },
        },
    },

    -- Battle for Azeroth
    -- Neutral
    [54453] = { -- Champions of Azeroth
        factionID = 2164,
        cache = 166298,
        rewards = {
            { -- Azerite Firework Launcher
                type = TOY,
                itemID = 166877,
            },
        },
    },
    [58096] = { -- Rajani
        factionID = 2415,
        cache = 174483,
        rewards = {
            { -- Jade Defender
                type = PET,
                itemID = 174479,
            },
        },
    },
    [55348] = { -- Rustbolt Resistance
        factionID = 2391,
        cache = 170061,
        rewards = {
            { -- Blueprint: Microbot XD
                type = BINDING_HEADER_OTHER,
                itemID = 169171,
                questID = 55079,
            },
            { -- Blueprint: Holographic Digitalization Relay
                type = BINDING_HEADER_OTHER,
                itemID = 168906,
                questID = 56086,
            },
            { -- Blueprint: Rustbolt Resistance Insignia
                type = BINDING_HEADER_OTHER,
                itemID = 168494,
                questID = 55073,
            },
        },
    },
    [54451] = { -- Tortollan Seekers
        factionID = 2163,
        cache = 166245,
        rewards = {
            { -- Bowl of Glowing Pufferfish
                type = TOY,
                itemID = 166704,
            },
        },
    },
    [58097] = { -- Uldum Accord
        factionID = 2417,
        cache = 174484,
        rewards = {
            { -- Cursed Dune Watcher
                type = PET,
                itemID = 174481,
            },
        },
    },

    -- Horde
    [54460] = { -- Talanji's Expedition
        factionID = 2156,
        cache = 166282,
        rewards = {
            { -- For da Blood God!
                type = TOY,
                itemID = 166308,
            },
            { -- Pair of Tiny Bat Wings
                type = PET,
                itemID = 166716,
            },
        },
    },
    [54455] = { -- The Honorbound
        factionID = 2157,
        cache = 166299,
        rewards = {
            { -- Rallying War Banner
                type = TOY,
                itemID = 166879,
            },
        },
    },
    [53982] = { -- The Unshackled
        factionID = 2373,
        cache = 169940,
        rewards = {
            { -- Royal Snapdragon
                type = MOUNT,
                itemID = 169198,
                mountID = 1237,
            },
            { -- Flopping Fish
                type = TOY,
                itemID = 170203,
            },
            { -- Memento of the Deeps
                type = TOY,
                itemID = 170469,
            },
        },
    },
    [54461] = { -- Voldunai
        factionID = 2158,
        cache = 166290,
        rewards = {
            { -- Goldtusk Inn Breakfast Buffet
                type = TOY,
                itemID = 166703,
            },
            { -- Meerah's Jukebox
                type = TOY,
                itemID = 166880,
            },
        },
    },
    [54462] = { -- Zandalari Empire
        factionID = 2103,
        cache = 166292,
        rewards = {
            { -- Warbeast Kraal Dinner Bell
                type = TOY,
                itemID = 166701,
            },
        },
    },

    -- Alliance
    [54456] = { -- Order of Embers
        factionID = 2161,
        cache = 166297,
        rewards = {
            { -- Bewitching Tea Set
                type = TOY,
                itemID = 166808,
            },
            { -- Cobalt Raven Hatchling
                type = PET,
                itemID = 166718,
            },
        },
    },
    [54458] = { -- Proudmoore Admiralty
        factionID = 2160,
        cache = 166295,
        rewards = {
            { -- Proudmoore Music Box
                type = TOY,
                itemID = 166702,
            },
            { -- Albatross Feather
                type = PET,
                itemID = 166714,
            },
        },
    },
    [54457] = { -- Storm's Wake
        factionID = 2162,
        cache = 166294,
        rewards = {
            { -- Violet Abyssal Eel
                type = PET,
                itemID = 166719,
            },
        },
    },
    [54454] = { -- The 7th Legion
        factionID = 2159,
        cache = 166300,
        rewards = {
            { -- Rallying War Banner
                type = TOY,
                itemID = 166879,
            },
        },
    },
    [55976] = { -- Waveblade Ankoan
        factionID = 2400,
        cache = 169939,
        rewards = {
            { -- Royal Snapdragon
                type = MOUNT,
                itemID = 169198,
                mountID = 1237,
            },
            { -- Flopping Fish
                type = TOY,
                itemID = 170203,
            },
            { -- Memento of the Deeps
                type = TOY,
                itemID = 170469,
            },
        },
    },

    -- Shadowlands
    [61100] = { -- Court of Harvesters
        factionID = 2413,
        cache = 180648,
        rewards = {
            { -- Stonewing Dredwing Pup
                type = PET,
                itemID = 180601,
            },
        },
    },
    [64012] = { -- Death's Advance
        factionID = 2470,
        cache = 186650,
        rewards = {
            { -- Beryl Shardhide
                type = MOUNT,
                itemID = 186644,
                mountID = 1455,
            },
            { -- Fierce Razorwing
                type = MOUNT,
                itemID = 186649,
                mountID = 1508,
            },
            { -- Mosscoated Hopper
                type = PET,
                itemID = 186541,
            },
        },
    },
    [64266] = { -- The Archivist's Codex
        factionID = 2472,
        cache = 187028,
        rewards = {
            { -- Tamed Mauler
                type = MOUNT,
                itemID = 186641,
                mountID = 1454,
            },
            { -- Gnashtooth
                type = PET,
                itemID = 186538,
            },
        },
    },
    [61097] = { -- The Ascended
        factionID = 2407,
        cache = 180647,
        rewards = {
            { -- Malfunctioning Goliath Gauntlet
                type = TOY,
                itemID = 184396,
            },
            { -- Mark of Purity
                type = TOY,
                itemID = 184435,
            },
            { -- Larion Cub
                type = PET,
                itemID = 184399,
            },
        },
    },
    [64867] = { -- The Enlightened
        factionID = 2478,
        cache = 187780,
        rewards = {
            { -- Sphere of Enlightened Cogitation
                type = TOY,
                itemID = 190177,
            },
            { -- Walking Staff of the Enlightened Journey
                type = ITEM_COSMETIC,
                itemID = 190939,
            },
            { -- Schematic: Russet Bufonoid
                type = BINDING_HEADER_OTHER,
                itemID = 189471,
                questID = 65394,
            },
            { -- Enlightened Portal Research
                type = BINDING_HEADER_OTHER,
                itemID = 190234,
                questID = 65617,
            },
            { -- Ray Soul
                type = BINDING_HEADER_OTHER,
                covenant = '|A:sanctumupgrades-nightfae-32x32:14:14:0:-1|a',
                itemID = 189973,
                questID = 65506,
            },
        },
    },
    [61095] = { -- The Undying Army
        factionID = 2410,
        cache = 180646,
        rewards = {
            { -- Reins of the Colossal Slaughterclaw
                type = MOUNT,
                itemID = 182081,
                mountID = 1350,
            },
            { -- Infested Arachnid Casing
                type = TOY,
                itemID = 184495,
            },
            { -- Micromancer's Mystical Cowl
                type = PET,
                itemID = 181269,
            },
        },
    },
    [61098] = { -- The Wild Hunt
        factionID = 2465,
        cache = 180649,
        rewards = {
            { -- Amber Ardenmoth
                type = MOUNT,
                itemID = 183800,
                mountID = 1428,
            },
            { -- Hungry Burrower
                type = PET,
                itemID = 180635,
            },
            { -- Mammoth Soul
                type = BINDING_HEADER_OTHER,
                covenant = '|A:sanctumupgrades-nightfae-32x32:14:14:0:-1|a',
                itemID = 185054,
                questID = 63610,
            },
            { -- Porcupine Soul
                type = BINDING_HEADER_OTHER,
                covenant = '|A:sanctumupgrades-nightfae-32x32:14:14:0:-1|a',
                itemID = 187870,
                questID = 64989,
            },
        },
    },
    [64267] = { -- Ve'nari
        factionID = 2432,
        cache = 187029,
        rewards = {
            { -- Soulbound Gloomcharger's Reins
                type = MOUNT,
                itemID = 186657,
                mountID = 1501,
            },
            { -- Rook
                type = PET,
                itemID = 186552,
            },
        },
    },
}

local function PetIsCollected(itemID)
    local name, _, _, _, _, _, _, _, _, _, _, _, speciesID = C_PetJournal.GetPetInfoByItemID(itemID)
    if name and speciesID then
        local numCollected = C_PetJournal.GetNumCollectedInfo(speciesID)
        return numCollected and numCollected > 0
    end

    return false
end

local lineStr = '|T%s:14|t |T%d:0:0:0:0:64:64:5:59:5:59|t %s |cffffffff(%s)|r'
local readyTex = 'Interface\\RAIDFRAME\\ReadyCheck-Ready'
local notReadyTex = 'Interface\\RAIDFRAME\\ReadyCheck-NotReady'

function TOOLTIP:AddParagonRewards()
    if not self.factionID then
        return
    end

    local _, _, rewardQuestID = C_Reputation.GetFactionParagonInfo(self.factionID)
    local rewards = rewardQuestID and PARAGON_DATA[rewardQuestID] and PARAGON_DATA[rewardQuestID].rewards
    if not rewards then
        return
    end

    for _, data in ipairs(rewards) do
        local collected
        local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(data.itemID)
        if data.type == MOUNT then
            collected = select(11, C_MountJournal.GetMountInfoByID(data.mountID))
        elseif data.type == PET then
            collected = PetIsCollected(data.itemID)
        elseif data.type == TOY then
            collected = PlayerHasToy(data.itemID)
        elseif data.type == ITEM_COSMETIC then
            collected = C_TransmogCollection.PlayerHasTransmogByItemInfo(data.itemID)
        elseif data.type == BINDING_HEADER_OTHER then
            collected = C_QuestLog.IsQuestFlaggedCompleted(data.questID)
        end

        local color = _G.ITEM_QUALITY_COLORS[quality]
        if name then
            _G.GameTooltip:AddLine(string.format(lineStr, collected and readyTex or notReadyTex, icon, name, data.covenant or data.type), color.r, color.g, color.b)
        else
            _G.GameTooltip:AddLine(_G.ERR_TRAVEL_PASS_NO_INFO, 1, 0, 0)
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:Show()
end

function TOOLTIP:ParagonRewards()
    if not C.DB.Tooltip.ParagonRewards then
        return
    end

    hooksecurefunc('ReputationParagonFrame_SetupParagonTooltip', TOOLTIP.AddParagonRewards)
end

