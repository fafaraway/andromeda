local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')

function NAMEPLATE:UpdateSelectedChange()
    local element = self.SelectedIndicator
    local unit = self.unit

    if C.DB.Nameplate.ColoredTarget then
        NAMEPLATE.UpdateThreatColor(self, _, unit)
    end

    if not element then
        return
    end

    if UnitIsUnit(unit, 'target') and not UnitIsUnit(unit, 'player') then
        element:Show()
        if element.aggroR:IsShown() and not element.animGroupR:IsPlaying() then
            element.animGroupR:Play()
        end
        if element.aggroL:IsShown() and not element.animGroupL:IsPlaying() then
            element.animGroupL:Play()
        end
    else
        element:Hide()
        if element.animGroupR:IsPlaying() then
            element.animGroupR:Stop()
        end
        if element.animGroupL:IsPlaying() then
            element.animGroupL:Stop()
        end
    end
end

function NAMEPLATE:UpdateSelectedIndicatorColor(self, r, g, b)
    if self.SelectedIndicator then
        self.SelectedIndicator.aggroL:SetVertexColor(r, g, b)
        self.SelectedIndicator.aggroR:SetVertexColor(r, g, b)
    end
end

function NAMEPLATE:UpdateSelectedIndicatorVisibility()
    local element = self.SelectedIndicator
    local isNameOnly = self.plateType == 'NameOnly'

    if not element then
        return
    end

    if C.DB.Nameplate.SelectedIndicator then
        if isNameOnly then
            element.nameGlow:Show()
            element.Glow:Hide()
            element.aggroL:Hide()
            element.aggroR:Hide()
        else
            element.nameGlow:Hide()
            element.Glow:Show()
            element.aggroL:Show()
            element.aggroR:Show()

            element.animR.points[1]:SetOffset(4, 0)
            element.animL.points[1]:SetOffset(-4, 0)
        end
        element:Show()
    else
        element:Hide()
    end
end

function NAMEPLATE:CreateSelectedIndicator(self)
    if not C.DB.Nameplate.SelectedIndicator then
        return
    end

    local color = C.DB.Nameplate.SelectedIndicatorColor
    local r, g, b = color.r, color.g, color.b

    local frame = CreateFrame('Frame', nil, self)
    frame:SetFrameStrata('BACKGROUND')
    frame:SetAllPoints()
    frame:Hide()

    frame.Glow = frame:CreateTexture(nil, 'BACKGROUND')
    frame.Glow:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT')
    frame.Glow:SetPoint('TOPRIGHT', frame, 'BOTTOMRIGHT')
    frame.Glow:SetHeight(12)
    frame.Glow:SetTexture(C.Assets.Texture.Glow)
    frame.Glow:SetRotation(rad(180))
    frame.Glow:SetVertexColor(r, g, b)

    frame.aggroL = frame:CreateTexture(nil, 'BACKGROUND', nil, -5)
    frame.aggroL:SetSize(C.DB.Nameplate.Height * 8, C.DB.Nameplate.Height * 4)
    frame.aggroL:SetPoint('CENTER', frame, 'LEFT', -10, 0)
    frame.aggroL:SetTexture(C.Assets.Texture.Target)

    local animGroupL = frame.aggroL:CreateAnimationGroup()
    animGroupL:SetLooping('NONE')
    local animL = animGroupL:CreateAnimation('Path')
    animL:SetSmoothing('IN_OUT')
    animL:SetDuration(0.5)
    animL.points = {}
    animL.points[1] = animL:CreateControlPoint()
    animL.points[1]:SetOrder(1)
    frame.animL = animL
    frame.animGroupL = animGroupL

    frame.aggroR = frame:CreateTexture(nil, 'BACKGROUND', nil, -5)
    frame.aggroR:SetSize(C.DB.Nameplate.Height * 8, C.DB.Nameplate.Height * 4)
    frame.aggroR:SetPoint('CENTER', frame, 'RIGHT', 10, 0)
    frame.aggroR:SetTexture(C.Assets.Texture.Target)
    frame.aggroR:SetRotation(rad(180))

    local animGroupR = frame.aggroR:CreateAnimationGroup()
    animGroupR:SetLooping('NONE')
    local animR = animGroupR:CreateAnimation('Path')
    animR:SetDuration(0.5)
    animR.points = {}
    animR.points[1] = animR:CreateControlPoint()
    animR.points[1]:SetOrder(1)
    frame.animR = animR
    frame.animGroupR = animGroupR

    frame.nameGlow = frame:CreateTexture(nil, 'BACKGROUND', nil, -5)
    frame.nameGlow:SetSize(150, 80)
    frame.nameGlow:SetTexture('Interface\\GLUES\\Models\\UI_Draenei\\GenericGlow64')
    frame.nameGlow:SetVertexColor(0, 0.6, 1)
    frame.nameGlow:SetBlendMode('ADD')
    frame.nameGlow:SetPoint('CENTER', 0, 14)

    self.SelectedIndicator = frame
    self:RegisterEvent('PLAYER_TARGET_CHANGED', NAMEPLATE.UpdateSelectedChange, true)

    NAMEPLATE.UpdateSelectedIndicatorVisibility(self)
end
