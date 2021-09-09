local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

function UNITFRAME:CreateFader(self)
    if not C.DB.Unitframe.Fader then
        return
    end

    if not self.Fader then
        self.Fader = {
            maxAlhpa = C.DB.Unitframe.MaxAlpha,
            minAlpha = C.DB.Unitframe.MinAlpha,
            outDuration = C.DB.Unitframe.OutDuration,
            inDuration = C.DB.Unitframe.InDuration,
            hover = C.DB.Unitframe.MouseOver,
            arena = C.DB.Unitframe.InPvP,
            instance = C.DB.Unitframe.InInstance,
            combat = C.DB.Unitframe.InCombat,
            target = C.DB.Unitframe.Targeting,
            casting = C.DB.Unitframe.Casting,
            injured = C.DB.Unitframe.Injured,
            mana = C.DB.Unitframe.ManaNotFull,
            power = C.DB.Unitframe.HavePower,
        }
    end
end
