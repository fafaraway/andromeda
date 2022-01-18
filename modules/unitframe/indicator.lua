local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:UpdateRaidTargetIndicator()
    local style = self.unitStyle
    local raidTarget = self.RaidTargetIndicator
    local isNameOnly = self.isNameOnly
    --local size = self:GetHeight()
    local scale = C.DB.Unitframe.RaidTargetIndicatorScale
    local alpha = C.DB.Unitframe.RaidTargetIndicatorAlpha
    local npScale = C.DB.Nameplate.RaidTargetIndicatorScale
    local npAlpha = C.DB.Nameplate.RaidTargetIndicatorAlpha

    --if style == 'nameplate' then
        raidTarget:SetAlpha(npAlpha)
        raidTarget:SetSize(C.DB.Nameplate.Height, C.DB.Nameplate.Height)
        raidTarget:SetScale(npScale)
    --else
        -- raidTarget:SetAlpha(alpha)
        -- raidTarget:SetSize(size, size)
        -- raidTarget:SetScale(scale)
    --end
end

function UNITFRAME:CreateRaidTargetIndicator(self)
    local icon = self.Health:CreateTexture(nil, 'OVERLAY')
    icon:SetPoint('CENTER')

    icon:SetTexture(C.Assets.Textures.RaidTargetIcons)

    self.RaidTargetIndicator = icon

    UNITFRAME.UpdateRaidTargetIndicator(self)
end



function UNITFRAME:UpdateNameplateRaidTargetIndicator()

    local icon = self.RaidTargetIndicator

    local size = C.DB.Nameplate.Height
    local scale = C.DB.Nameplate.RaidTargetIndicatorScale
    local alpha = C.DB.Nameplate.RaidTargetIndicatorAlpha

        icon:SetPoint('CENTER')
        icon:SetAlpha(alpha)

        icon:SetScale(scale)

end

function UNITFRAME:CreateNameplateRaidTargetIndicator(self)
    local size = C.DB.Nameplate.Height
    local icon = self.Health:CreateTexture(nil, 'OVERLAY')
    icon:SetTexture(C.Assets.Textures.RaidTargetIcons)
    icon:SetSize(size, size)

    self.RaidTargetIndicator = icon

    UNITFRAME.UpdateNameplateRaidTargetIndicator(self)
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
