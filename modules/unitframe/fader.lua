local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

function UNITFRAME:CreateFader(self)
    if not C.DB.Unitframe.Fader then
        return
    end

    if not self.Fader then
        self.Fader = {}
    end

    self.Fader.maxAlhpa = C.DB.Unitframe.MaxAlpha
    self.Fader.minAlpha = C.DB.Unitframe.MinAlpha
    self.Fader.outDuration = C.DB.Unitframe.OutDuration
    self.Fader.inDuration = C.DB.Unitframe.InDuration
    self.Fader.hover = C.DB.Unitframe.MouseOver
    self.Fader.arena = C.DB.Unitframe.InPvP
    self.Fader.instance = C.DB.Unitframe.InInstance
    self.Fader.combat = C.DB.Unitframe.InCombat
    self.Fader.target = C.DB.Unitframe.Targeting
    self.Fader.casting = C.DB.Unitframe.Casting
    self.Fader.injured = C.DB.Unitframe.Injured
    self.Fader.mana = C.DB.Unitframe.ManaNotFull
    self.Fader.power = C.DB.Unitframe.HavePower
end
