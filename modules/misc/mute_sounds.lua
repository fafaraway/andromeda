--[[
    Mute some annoying sounds
]]

local _G = _G
local unpack = unpack
local select = select
local MuteSoundFile = MuteSoundFile

local F = unpack(select(2, ...))
local MS = F:RegisterModule('MuteSounds')

local annoyingSounds = {
    -- Train
    -- Blood Elf
    '539219',
    '539203',
    '1313588',
    '1306531',
    -- Draenei
    '539516',
    '539730',
    -- Dwarf
    '539802',
    '539881',
    -- Gnome
    '540271',
    '540275',
    -- Goblin
    '541769',
    '542017',
    -- Human
    '540535',
    '540734',
    -- Night Elf
    '540870',
    '540947',
    '1316209',
    '1304872',
    -- Orc
    '541157',
    '541239',
    -- Pandaren
    '636621',
    '630296',
    '630298',
    -- Tauren
    '542818',
    '542896',
    -- Troll
    '543085',
    '543093',
    -- Undead
    '542526',
    '542600',
    -- Worgen
    '542035',
    '542206',
    '541463',
    '541601',
    -- Dark Iron
    '1902030',
    '1902543',
    -- Highmount
    '1730534',
    '1730908',
    -- Kul Tiran
    '2531204',
    '2491898',
    -- Lightforg
    '1731282',
    '1731656',
    -- MagharOrc
    '1951457',
    '1951458',
    -- Mechagnom
    '3107651',
    '3107182',
    -- Nightborn
    '1732030',
    '1732405',
    -- Void Elf
    '1732785',
    '1733163',
    -- Vulpera
    '3106252',
    '3106717',
    -- Zandalari
    '1903049',
    '1903522',

    -- Smolderheart
    '2066602',
    '2066605',
}


function MS:OnLogin()
    for _, soundID in pairs(annoyingSounds) do
        MuteSoundFile(soundID)
    end
end
