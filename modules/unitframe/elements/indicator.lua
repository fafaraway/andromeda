local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local oUF = F.Libs.oUF

function UNITFRAME.ConfigureTargetIndicator(frame)
    local icon = frame.RaidTargetIndicator
    local enable = C.DB.Unitframe.RaidTargetIndicator

    icon:SetPoint('CENTER', frame, 'TOP')
    icon:SetAlpha(1)
    icon:SetSize(16, 16)
    icon:SetScale(1)
    icon:SetShown(enable)
end

function UNITFRAME:CreateRaidTargetIndicator(self)
    local icon = self:CreateTexture(nil, 'OVERLAY')
    icon:SetTexture(C.Assets.Texture.RaidTargetingIcon)

    self.RaidTargetIndicator = icon

    UNITFRAME.ConfigureTargetIndicator(self)
end

function UNITFRAME:UpdateRaidTargetIndicator()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'party' or frame.unitStyle == 'raid' then
            if C.DB.Unitframe.RaidTargetIndicator then
                if not frame:IsElementEnabled('RaidTargetIndicator') then
                    frame:EnableElement('RaidTargetIndicator')
                    if frame.RaidTargetIndicator then
                        frame.RaidTargetIndicator:ForceUpdate()
                    end
                end
            else
                if frame:IsElementEnabled('RaidTargetIndicator') then
                    frame:DisableElement('RaidTargetIndicator')
                end
            end
        end
    end
end

local classify = {
    elite = { 'VignetteKill' },
    rare = { 'VignetteKill', true },
    rareelite = { 'VignetteKill', true },
    worldboss = { 'VignetteKillElite' },
}

function NAMEPLATE:CreateClassifyIndicator(self)
    if not C.DB.Nameplate.ClassifyIndicator then
        return
    end

    local height = C.DB.Nameplate.Height
    local icon = self:CreateTexture(nil, 'BACKGROUND')
    icon:SetPoint('RIGHT', self, 'LEFT')
    icon:SetSize(height + 10, height + 10)
    icon:SetAtlas('')
    icon:Hide()

    self.ClassifyIndicator = icon
end

function NAMEPLATE:UpdateUnitClassify(unit)
    local isBoss = UnitLevel(unit) == -1
    local class = UnitClassification(unit)
    local isNameOnly = self.plateType == 'NameOnly'

    if self.ClassifyIndicator then
        if isNameOnly then
            self.ClassifyIndicator:SetAtlas('')
            self.ClassifyIndicator:Hide()
        elseif isBoss then
            self.ClassifyIndicator:SetAtlas('VignetteKillElite')
            self.ClassifyIndicator:Show()
        elseif class and classify[class] then
            local atlas, desature = unpack(classify[class])
            self.ClassifyIndicator:SetAtlas(atlas)
            self.ClassifyIndicator:SetDesaturated(desature)
            self.ClassifyIndicator:Show()
        else
            self.ClassifyIndicator:SetAtlas('')
            self.ClassifyIndicator:Hide()
        end
    end
end

function UNITFRAME:CreateReadyCheckIndicator(self)
    local readyCheckIndicator = self:CreateTexture(nil, 'OVERLAY')
    readyCheckIndicator:SetPoint('CENTER')
    readyCheckIndicator:SetSize(self:GetHeight() * 0.8, self:GetHeight() * 0.8)

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
    resurrectIndicator:SetSize(self:GetHeight() * 0.8, self:GetHeight() * 0.8)
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
