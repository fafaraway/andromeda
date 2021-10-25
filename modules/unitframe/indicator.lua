local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:UpdateRaidTargetIndicator()
    local style = self.unitStyle
    local raidTarget = self.RaidTargetIndicator
    local nameOnlyName = self.nameOnlyName
    local title = self.npcTitle
    local isNameOnly = self.isNameOnly
    local size = self:GetHeight()
    -- local alpha = C.DB.Unitframe.RaidTargetIndicatorAlpha
    local npSize = C.DB.Nameplate.RaidTargetIndicatorSize
    local npAlpha = C.DB.Nameplate.RaidTargetIndicatorAlpha

    if style == 'nameplate' then
        if isNameOnly then
            raidTarget:SetParent(self)
            raidTarget:ClearAllPoints()
            raidTarget:SetPoint('TOP', title or nameOnlyName, 'BOTTOM')
        else
            raidTarget:SetParent(self.Health)
            raidTarget:ClearAllPoints()
            raidTarget:SetPoint('CENTER')
        end

        raidTarget:SetAlpha(npAlpha)
        raidTarget:SetSize(npSize, npSize)
    elseif style == 'party' or style == 'raid' or style == 'boss' then
        raidTarget:ClearAllPoints()
        raidTarget:SetPoint('CENTER')
        raidTarget:SetAlpha(.2)
        raidTarget:SetSize(size*.8, size*.8)
    else
        raidTarget:SetPoint('CENTER')
        raidTarget:SetAlpha(.2)
        raidTarget:SetSize(size*2, size*2)
    end
end

function UNITFRAME:CreateRaidTargetIndicator(self)
    local icon = self.Health:CreateTexture(nil, 'OVERLAY')
    icon:SetPoint('CENTER')
    icon:SetAlpha(1)
    icon:SetSize(24, 24)
    icon:SetTexture(C.Assets.target_icon)

    self.RaidTargetIndicator = icon

    UNITFRAME.UpdateRaidTargetIndicator(self)
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
