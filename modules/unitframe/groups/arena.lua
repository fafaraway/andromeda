local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigureArenaStyle(self)
    self.unitStyle = 'arena'
    self:SetWidth(C.DB.Unitframe.ArenaWidth)
    self:SetHeight(C.DB.Unitframe.ArenaHealthHeight + C.DB.Unitframe.ArenaPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateNameTag(self)
    UNITFRAME:CreateHealthTag(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateSelectedBorder(self)
end

function UNITFRAME:SpawnArena()
    oUF:RegisterStyle('Arena', ConfigureArenaStyle)
    oUF:SetActiveStyle('Arena')

    local arena = {}
    for i = 1, 5 do
        arena[i] = oUF:Spawn('arena' .. i, 'oUF_Arena' .. i)
        arena[i]:SetPoint('TOPLEFT', UNITFRAME.BossFrame[i].mover)
    end
end
