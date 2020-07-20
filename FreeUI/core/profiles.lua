local F, C = unpack(select(2, ...))

-- This file allows you to override any config in configs.lua, or append to it.

local playerName = UnitName('player')
local playerClass = select(2, UnitClass('player'))
local playerRealm = GetRealmName()
local oUF = F.oUF


--C.General.isDeveloper = true

if not C.General.isDeveloper then return end

C.Actionbar.bar1_visibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'

-- Override fonts
C.Assets.Fonts.Normal = 'Fonts\\FreeUI\\sarasa_newjune_semibold.ttf'
C.Assets.Fonts.Header = 'Fonts\\FreeUI\\header.ttf'
C.Assets.Fonts.Chat   = 'Fonts\\FreeUI\\sarasa_texgyreadventor_bold.ttf'
C.Assets.Fonts.Number = 'Fonts\\FreeUI\\sarasa_tccc.ttf'

STANDARD_TEXT_FONT = 'Fonts\\FreeUI\\sarasa_newjune_semibold.ttf'
UNIT_NAME_FONT     = 'Fonts\\FreeUI\\header.ttf'
DAMAGE_TEXT_FONT   = 'Fonts\\FreeUI\\damage.ttf'

--[[ -- Override class color
RAID_CLASS_COLORS['SHAMAN']['colorStr'] = 'ff4447bc'
RAID_CLASS_COLORS['SHAMAN']['b'] = 0.74
RAID_CLASS_COLORS['SHAMAN']['g'] = 0.28
RAID_CLASS_COLORS['SHAMAN']['r'] = 0.27

RAID_CLASS_COLORS['WARRIOR']['colorStr'] = 'ffa18e81'
RAID_CLASS_COLORS['WARRIOR']['b'] = 0.51
RAID_CLASS_COLORS['WARRIOR']['g'] = 0.56
RAID_CLASS_COLORS['WARRIOR']['r'] = 0.63

RAID_CLASS_COLORS['PALADIN']['colorStr'] = 'ffff5775'
RAID_CLASS_COLORS['PALADIN']['b'] = 0.46
RAID_CLASS_COLORS['PALADIN']['g'] = 0.34
RAID_CLASS_COLORS['PALADIN']['r'] = 1

RAID_CLASS_COLORS['MAGE']['colorStr'] = 'ff61a4df'
RAID_CLASS_COLORS['MAGE']['b'] = 0.87
RAID_CLASS_COLORS['MAGE']['g'] = 0.64
RAID_CLASS_COLORS['MAGE']['r'] = 0.38

RAID_CLASS_COLORS['PRIEST']['colorStr'] = 'ffd9d9d9'
RAID_CLASS_COLORS['PRIEST']['b'] = 0.85
RAID_CLASS_COLORS['PRIEST']['g'] = 0.85
RAID_CLASS_COLORS['PRIEST']['r'] = 0.85

RAID_CLASS_COLORS['WARLOCK']['colorStr'] = 'ffa07fd7'
RAID_CLASS_COLORS['WARLOCK']['b'] = 0.84
RAID_CLASS_COLORS['WARLOCK']['g'] = 0.51
RAID_CLASS_COLORS['WARLOCK']['r'] = 0.63

RAID_CLASS_COLORS['HUNTER']['colorStr'] = 'ff219c34'
RAID_CLASS_COLORS['HUNTER']['b'] = 0.21
RAID_CLASS_COLORS['HUNTER']['g'] = 0.61
RAID_CLASS_COLORS['HUNTER']['r'] = 0.13

RAID_CLASS_COLORS['DRUID']['colorStr'] = 'ffdf692f'
RAID_CLASS_COLORS['DRUID']['b'] = 0.18
RAID_CLASS_COLORS['DRUID']['g'] = 0.41
RAID_CLASS_COLORS['DRUID']['r'] = 0.87

RAID_CLASS_COLORS['ROGUE']['colorStr'] = 'ffffd33e'
RAID_CLASS_COLORS['ROGUE']['b'] = 0.24
RAID_CLASS_COLORS['ROGUE']['g'] = 0.83
RAID_CLASS_COLORS['ROGUE']['r'] = 1

RAID_CLASS_COLORS['DEATHKNIGHT']['colorStr'] = 'ffb73034'
RAID_CLASS_COLORS['DEATHKNIGHT']['b'] = 0.21
RAID_CLASS_COLORS['DEATHKNIGHT']['g'] = 0.19
RAID_CLASS_COLORS['DEATHKNIGHT']['r'] = 0.71

RAID_CLASS_COLORS['DEMONHUNTER']['colorStr'] = 'ffa528db'
RAID_CLASS_COLORS['DEMONHUNTER']['b'] = 0.86
RAID_CLASS_COLORS['DEMONHUNTER']['g'] = 0.16
RAID_CLASS_COLORS['DEMONHUNTER']['r'] = 0.65

RAID_CLASS_COLORS['MONK']['colorStr'] = 'ff44cb92'
RAID_CLASS_COLORS['MONK']['b'] = 0.58
RAID_CLASS_COLORS['MONK']['g'] = 0.8
RAID_CLASS_COLORS['MONK']['r'] = 0.27

oUF.colors.class.ROGUE = {RAID_CLASS_COLORS['ROGUE']['r'], RAID_CLASS_COLORS['ROGUE']['g'], RAID_CLASS_COLORS['ROGUE']['b']}
oUF.colors.class.DRUID = {RAID_CLASS_COLORS['DRUID']['r'], RAID_CLASS_COLORS['DRUID']['g'], RAID_CLASS_COLORS['DRUID']['b']}
oUF.colors.class.HUNTER = {RAID_CLASS_COLORS['HUNTER']['r'], RAID_CLASS_COLORS['HUNTER']['g'], RAID_CLASS_COLORS['HUNTER']['b']}
oUF.colors.class.MAGE = {RAID_CLASS_COLORS['MAGE']['r'], RAID_CLASS_COLORS['MAGE']['g'], RAID_CLASS_COLORS['MAGE']['b']}
oUF.colors.class.PALADIN = {RAID_CLASS_COLORS['PALADIN']['r'], RAID_CLASS_COLORS['PALADIN']['g'], RAID_CLASS_COLORS['PALADIN']['b']}
oUF.colors.class.PRIEST = {RAID_CLASS_COLORS['PRIEST']['r'], RAID_CLASS_COLORS['PRIEST']['g'], RAID_CLASS_COLORS['PRIEST']['b']}
oUF.colors.class.SHAMAN = {RAID_CLASS_COLORS['SHAMAN']['r'], RAID_CLASS_COLORS['SHAMAN']['g'], RAID_CLASS_COLORS['SHAMAN']['b']}
oUF.colors.class.WARLOCK = {RAID_CLASS_COLORS['WARLOCK']['r'], RAID_CLASS_COLORS['WARLOCK']['g'], RAID_CLASS_COLORS['WARLOCK']['b']}
oUF.colors.class.WARRIOR = {RAID_CLASS_COLORS['WARRIOR']['r'], RAID_CLASS_COLORS['WARRIOR']['g'], RAID_CLASS_COLORS['WARRIOR']['b']}
oUF.colors.class.DEATHKNIGHT = {RAID_CLASS_COLORS['DEATHKNIGHT']['r'], RAID_CLASS_COLORS['DEATHKNIGHT']['g'], RAID_CLASS_COLORS['DEATHKNIGHT']['b']}
oUF.colors.class.DEMONHUNTER = {RAID_CLASS_COLORS['DEMONHUNTER']['r'], RAID_CLASS_COLORS['DEMONHUNTER']['g'], RAID_CLASS_COLORS['DEMONHUNTER']['b']}
oUF.colors.class.MONK = {RAID_CLASS_COLORS['MONK']['r'], RAID_CLASS_COLORS['MONK']['g'], RAID_CLASS_COLORS['MONK']['b']}
 ]]

-- disbale talent alert
function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
	return false
end

F:RegisterEvent("PLAYER_ENTERING_WORLD", function()
	--[[ F.Print('C.ScreenWidth '..C.ScreenWidth)
	F.Print('C.ScreenHeight '..C.ScreenHeight)
	F.Print('C.Mult '..C.Mult)
	F.Print('uiScale '..C.General.uiScale)
	F.Print('UIParentScale '..UIParent:GetScale()) ]]
end)

