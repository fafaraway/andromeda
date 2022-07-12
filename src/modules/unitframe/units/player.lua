local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function ConfigurePlayerStyle(self)
    self.unitStyle = 'player'
    self:SetWidth(C.DB.Unitframe.PlayerWidth)
    self:SetHeight(C.DB.Unitframe.PlayerHealthHeight + C.DB.Unitframe.PlayerPowerHeight + C.MULT)

    UNITFRAME:CreateBackdrop(self)
    UNITFRAME:CreateHealthBar(self)
    UNITFRAME:CreateHealPrediction(self)
    UNITFRAME:CreatePowerBar(self)
    UNITFRAME:CreateAlternativePowerBar(self)
    UNITFRAME:CreateAltPowerTag(self)
    UNITFRAME:CreatePortrait(self)
    UNITFRAME:CreateCastBar(self)
    UNITFRAME:CreateGCDTicker(self)
    UNITFRAME:CreateClassPower(self)
    UNITFRAME:CreatePlayerTags(self)
    UNITFRAME:CreateAuras(self)
    UNITFRAME:UpdatePlayerAuraPosition(self)
end

function UNITFRAME:SpawnPlayer()
    oUF:RegisterStyle('Player', ConfigurePlayerStyle)
    oUF:SetActiveStyle('Player')

    local player = oUF:Spawn('player', 'oUF_Player')
    F.Mover(player, L['PlayerFrame'], 'PlayerFrame', UNITFRAME.Positions.player, player:GetWidth(), player:GetHeight())
end
