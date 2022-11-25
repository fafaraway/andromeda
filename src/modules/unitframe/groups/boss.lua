local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigureBossStyle(self)
    self.unitStyle = 'boss'
    self:SetWidth(C.DB.Unitframe.BossWidth)
    self:SetHeight(C.DB.Unitframe.BossHealthHeight + C.DB.Unitframe.BossPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealthTag(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateAlternativePowerBar(self)
    UNITFRAME:CreateAltPowerTag(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateNameTag(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:CreateRangeCheck(self)
    UNITFRAME:CreateRaidTargetIndicator(self)
    UNITFRAME:CreateTargetBorder(self)
end

local boss = {}
UNITFRAME.BossFrame = boss
function UNITFRAME:SpawnBoss()
    oUF:RegisterStyle('Boss', ConfigureBossStyle)
    oUF:SetActiveStyle('Boss')

    for i = 1, 8 do -- MAX_BOSS_FRAMES, 8 in 9.2?
        boss[i] = oUF:Spawn('boss' .. i, 'oUF_Boss' .. i)
        local moverWidth, moverHeight = boss[i]:GetWidth(), boss[i]:GetHeight()
        local title = i > 5 and 'Boss' .. i or L['Boss Frame'] .. i

        if i == 1 then
            boss[i].mover = F.Mover(boss[i], title, 'Boss1', UNITFRAME.Positions.boss, moverWidth, moverHeight)
        elseif i == 6 then
            boss[i].mover = F.Mover(
                boss[i],
                title,
                'Boss' .. i,
                { 'BOTTOMLEFT', boss[1].mover, 'BOTTOMRIGHT', 50, 0 },
                moverWidth,
                moverHeight
            )
        else
            boss[i].mover = F.Mover(
                boss[i],
                title,
                'Boss' .. i,
                { 'BOTTOMLEFT', boss[i - 1], 'TOPLEFT', 0, 60 },
                moverWidth,
                moverHeight
            )
        end
    end
end
