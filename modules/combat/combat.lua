local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local COMBAT = F:RegisterModule('Combat')

function COMBAT:OnLogin()
    if not C.DB.Combat.Enable then
        return
    end

    COMBAT:CombatAlert()
    COMBAT:SpellSound()
    COMBAT:FloatingCombatText()
    COMBAT:PvPSound()
    COMBAT:SmartTab()
    COMBAT:EasyFocus()
    COMBAT:EasyMark()
end
