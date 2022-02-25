local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local oUF = F.Libs.oUF

function UNITFRAME.UpdateRaidTargetIndicator(frame)
    local style = frame.unitStyle
    local isRaid = style == 'raid'
    local partyHeight = C.DB.Unitframe.PartyHealthHeight + C.DB.Unitframe.PartyPowerHeight
    local raidHeight = C.DB.Unitframe.RaidHealthHeight + C.DB.Unitframe.RaidPowerHeight
    local icon = frame.RaidTargetIndicator
    local size = isRaid and raidHeight or partyHeight
    local scale = C.DB.Unitframe.RaidTargetIndicatorScale
    local alpha = C.DB.Unitframe.RaidTargetIndicatorAlpha
    local enable = C.DB.Unitframe.RaidTargetIndicator

    icon:SetPoint('CENTER')
    icon:SetAlpha(alpha)
    icon:SetSize(size, size)
    icon:SetScale(scale)
    icon:SetShown(enable)
end

function UNITFRAME:CreateRaidTargetIndicator(self)
    local icon = self.Health:CreateTexture(nil, 'OVERLAY')
    icon:SetTexture(C.Assets.Textures.RaidTargetIcons)

    self.RaidTargetIndicator = icon

    UNITFRAME.UpdateRaidTargetIndicator(self)
end

function NAMEPLATE.UpdateRaidTargetIndicator(frame)
    local icon = frame.RaidTargetIndicator
    local size = C.DB.Nameplate.Height
    local scale = C.DB.Nameplate.RaidTargetIndicatorScale
    local alpha = C.DB.Nameplate.RaidTargetIndicatorAlpha
    local enable = C.DB.Nameplate.RaidTargetIndicator

    icon:SetPoint('CENTER')
    icon:SetAlpha(alpha)
    icon:SetSize(size, size)
    icon:SetScale(scale)
    icon:SetShown(enable)
end

function NAMEPLATE:CreateRaidTargetIndicator(self)
    local icon = self.Health:CreateTexture(nil, 'OVERLAY')
    icon:SetTexture(C.Assets.Textures.RaidTargetIcons)

    self.RaidTargetIndicator = icon

    NAMEPLATE.UpdateRaidTargetIndicator(self)
end

function UNITFRAME:CreateReadyCheckIndicator(self)
    local readyCheckIndicator = self:CreateTexture(nil, 'OVERLAY')
    readyCheckIndicator:SetPoint('CENTER')
    readyCheckIndicator:SetSize(self:GetHeight() * .8, self:GetHeight() * .8)

    self.ReadyCheckIndicator = readyCheckIndicator
end

function UNITFRAME:CreatePhaseIndicator(self)
    local phase = CreateFrame('Frame', nil, self)
    phase:SetSize(16, 16)
    phase:SetPoint('CENTER', self)
    phase:SetFrameLevel(5)
    phase:EnableMouse(true)
    local icon = phase:CreateTexture(nil, 'OVERLAY')
    icon:SetAllPoints()
    phase.Icon = icon

    self.PhaseIndicator = phase
end

function UNITFRAME:CreateSummonIndicator(self)
    local summonIndicator = self:CreateTexture(nil, 'OVERLAY')
    summonIndicator:SetSize(self:GetHeight(), self:GetHeight())
    summonIndicator:SetPoint('CENTER')

    self.SummonIndicator = summonIndicator
end

function UNITFRAME:CreateResurrectIndicator(self)
    local resurrectIndicator = self:CreateTexture(nil, 'OVERLAY')
    resurrectIndicator:SetSize(self:GetHeight() * .8, self:GetHeight() * .8)
    resurrectIndicator:SetPoint('CENTER')

    self.ResurrectIndicator = resurrectIndicator
end

function UNITFRAME:UpdateGroupIndicators()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'party' or frame.unitStyle == 'raid' then
            UNITFRAME.UpdateRaidTargetIndicator(frame)
        end
    end
end

function NAMEPLATE:UpdateIndicators()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'nameplate' then
            NAMEPLATE.UpdateRaidTargetIndicator(frame)
        end
    end
end
