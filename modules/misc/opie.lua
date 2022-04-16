local F, C, L = unpack(select(2, ...))
local M = F:GetModule('Misc')

-- #TODO

local RINGS = {
    {
        name = 'Mage Teleport',
        limit = 'MAGE',

        { id = 193759, c = 'd000ff' }, -- Hall of the Guardian
        { id = 344587, c = '209fe6' }, -- Oribos
        { id = 281404, c = 'f9e222', show = '[horde]' }, -- Dazar'alor
        { id = 281403, c = '21d2d5', show = '[alliance]' }, -- Boralus
        { id = 224869, c = '83ff61' }, -- Dalaran - Broken Isles
        { id = 176242, c = '00abf0', show = '[horde]' }, -- Warspear
        { id = 176248, c = 'f03000', show = '[alliance]' }, -- Stormshield
        { id = 132627, c = 'ffc34d', show = '[horde]' }, -- Vale of Eternal Blossoms
        { id = 132621, c = 'ffc34d', show = '[alliance]' }, -- Vale of Eternal Blossoms
        { id = 88344, c = 'f03c00', show = '[horde]' }, -- Tol Barad
        { id = 88342, c = 'f03c00', show = '[alliance]' }, -- Tol Barad
        { id = 53140, c = 'a54cff' }, -- Dalaran - Northrend
        { id = 35715, c = '4dffc3', show = '[horde]' }, -- Shattrath
        { id = 35690, c = '4dffc3', show = '[alliance]' }, -- Shattrath
        { id = 49358, c = 'b0ff26', show = '[horde]' }, -- Stonard
        { id = 49359, c = 'f09d00', show = '[alliance]' }, -- Theramore
        { id = 3563, c = '77ff4d', show = '[horde]' }, -- Undercity
        { id = 3562, c = '4cddff', show = '[alliance]' }, -- Ironforge
        { id = 3567, c = 'ff8126', show = '[horde]' }, -- Orgrimmar
        { id = 3561, c = '0d54f0', show = '[alliance]' }, -- Stormwind
        { id = 3566, c = '4cddff', show = '[horde]' }, -- Thunder Bluff
        { id = 3565, c = '9d0df0', show = '[alliance]' }, -- Darnassus
        { id = 32272, c = 'f00e00', show = '[horde]' }, -- Silvermoon
        { id = 32271, c = 'f024e2', show = '[alliance]' }, -- Exodar
        { id = 120145, c = 'a54cff' }, -- Ancient Dalaran
    },
    {
        name = 'Mage Portal',
        limit = 'MAGE',

        { id = 193759, c = 'd000ff' }, -- Hall of the Guardian (just for symmetry)
        { id = 344597, c = '209fe6' }, -- Oribos
        { id = 281402, c = 'f9e222', show = '[horde]' }, -- Dazar'alor
        { id = 281400, c = '21d2d5', show = '[alliance]' }, -- Boralus
        { id = 224871, c = '83ff61' }, -- Dalaran - Broken Isles
        { id = 176244, c = '00abf0', show = '[horde]' }, -- Warspear
        { id = 176246, c = 'f03000', show = '[alliance]' }, -- Stormshield
        { id = 132626, c = 'ffc34d', show = '[horde]' }, -- Vale of Eternal Blossoms
        { id = 132620, c = 'ffc34d', show = '[alliance]' }, -- Vale of Eternal Blossoms
        { id = 88346, c = 'f03c00', show = '[horde]' }, -- Tol Barad
        { id = 88345, c = 'f03c00', show = '[alliance]' }, -- Tol Barad
        { id = 53142, c = 'a54cff' }, -- Dalaran - Northrend
        { id = 35717, c = '4dffc3', show = '[horde]' }, -- Shattrath
        { id = 33691, c = '4dffc3', show = '[alliance]' }, -- Shattrath
        { id = 49361, c = 'b0ff26', show = '[horde]' }, -- Stonard
        { id = 49360, c = 'f09d00', show = '[alliance]' }, -- Theramore
        { id = 11418, c = '77ff4d', show = '[horde]' }, -- Undercity
        { id = 11416, c = '4cddff', show = '[alliance]' }, -- Ironforge
        { id = 11417, c = 'ff8126', show = '[horde]' }, -- Orgrimmar
        { id = 10059, c = '0d54f0', show = '[alliance]' }, -- Stormwind
        { id = 11420, c = '4cddff', show = '[horde]' }, -- Thunder Bluff
        { id = 11419, c = '9d0df0', show = '[alliance]' }, -- Darnassus
        { id = 32267, c = 'f00e00', show = '[horde]' }, -- Silvermoon
        { id = 32266, c = 'f024e2', show = '[alliance]' }, -- Exodar
        { id = 120146, c = 'a54cff' }, -- Ancient Dalaran
    },
}

function M:OpieTest()
    for _, ring in next, RINGS do
        local id = ring.name:gsub(' ', '')
        _G.OneRingLib.ext.RingKeeper:SetRing(id, false) -- delete first
        _G.OneRingLib.ext.RingKeeper:SetRing(id, ring)
    end
end
