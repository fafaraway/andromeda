local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

UNITFRAME.UnitFrames = {
    ['player'] = true,
    ['target'] = true,
    ['focus'] = true,
    ['pet'] = true,
    ['targettarget'] = true,
    ['focustarget'] = true,
    ['boss'] = true,
    ['arena'] = true,
}

UNITFRAME.GroupFrames = {
    ['party'] = true,
    ['raid'] = true,
}

local function SetHealthColor(health, index)
    health.colorClass = (index == 2)
    health.colorReaction = (index == 2)

    if health.SetColorTapping then
        health:SetColorTapping(index == 2)
    else
        health.colorTapping = (index == 2)
    end

    if health.SetColorDisconnected then
        health:SetColorDisconnected(index == 2)
    else
        health.colorDisconnected = (index == 2)
    end

    health.colorSmooth = (index == 3)

    if index == 1 then
        local color = C.DB.Unitframe.HealthColor
        health:SetStatusBarColor(color.r, color.g, color.b)
        if health.bg then
            health.bg:SetVertexColor(0.35, 0.35, 0.35)
        end
    end
end

function UNITFRAME:UpdateHealthBarColor(self, force)
    local style = self.unitStyle
    local isRaid = (style == 'raid')
    local health = self.Health

    if isRaid then
        SetHealthColor(health, C.DB.Unitframe.RaidColorStyle)
    else
        SetHealthColor(health, C.DB.Unitframe.ColorStyle)
    end

    if force then
        health:ForceUpdate()
    end
end

local function PreUpdateHealth(self, unit)
    if not unit or self.unit ~= unit then
        return
    end

    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    local isOffline = not UnitIsConnected(unit)
    local isDead = UnitIsDead(unit)
    local isGhost = UnitIsGhost(unit)

    self:SetMinMaxValues(0, max)

    if isOffline then
        self:SetValue(0)
    elseif isGhost or isDead then
        self:SetValue(max)
    else
        if max == cur then
            self:SetValue(0)
        else
            self:SetValue(max - cur)
        end
    end
end

local function PostUpdateHealth(self, unit, cur, max)
    local isOffline = not UnitIsConnected(unit)
    local isDead = UnitIsDead(unit)
    local isGhost = UnitIsGhost(unit)

    if isOffline then
        self:SetValue(0)
    elseif isGhost or isDead then
        self:SetValue(max)
    else
        if max == cur then
            self:SetValue(0)
        else
            self:SetValue(max - cur)
        end
    end
end

local function PostUpdateColor(self, unit)
    local parent = self.__owner
    local inverted = C.DB.Unitframe.InvertedColorMode
    local isOffline = not UnitIsConnected(unit)

    if inverted then
        local color = C.DB.Unitframe.InvertedHealthColor
        local alpha = C.DB.Unitframe.InvertedHealthAlpha

        if isOffline then
            local r, g, b = unpack(oUF.colors.disconnected)
            parent.backdrop:SetBackdropColor(r, g, b, alpha)
        else
            parent.backdrop:SetBackdropColor(color.r, color.g, color.b, alpha)
            --parent.backdrop:SetBackdropColor(0, 0, 0, 0.4)
        end
    end
end

function UNITFRAME:CreateHealthBar(self)
    local style = self.unitStyle
    local smooth = C.DB.Unitframe.Smooth
    local inverted = C.DB.Unitframe.InvertedColorMode
    local isPlayer = style == 'player'
    local isPet = style == 'pet'
    local isTarget = style == 'target'
    local isToT = style == 'targettarget'
    local isFocus = style == 'focus'
    local isToF = style == 'focustarget'
    local isParty = style == 'party'
    local isRaid = style == 'raid'
    local isBoss = style == 'boss'
    local isArena = style == 'arena'

    local health = CreateFrame('StatusBar', nil, self)
    health:SetFrameStrata('LOW')
    health:SetReverseFill(inverted)
    health:SetStatusBarTexture(UNITFRAME.StatusBarTex)
    health:SetPoint('LEFT')
    health:SetPoint('RIGHT')
    health:SetPoint('TOP')
    F:SmoothBar(health)
    health.Smooth = smooth

    if isPlayer then
        health:SetHeight(C.DB.Unitframe.PlayerHealthHeight)
    elseif isPet then
        health:SetHeight(C.DB.Unitframe.PetHealthHeight)
    elseif isTarget then
        health:SetHeight(C.DB.Unitframe.TargetHealthHeight)
    elseif isToT then
        health:SetHeight(C.DB.Unitframe.TargetTargetHealthHeight)
    elseif isFocus then
        health:SetHeight(C.DB.Unitframe.FocusHealthHeight)
    elseif isToF then
        health:SetHeight(C.DB.Unitframe.FocusTargetHealthHeight)
    elseif isParty then
        health:SetHeight(C.DB.Unitframe.PartyHealthHeight)
    elseif isRaid then
        health:SetHeight(C.DB.Unitframe.RaidHealthHeight)
    elseif isBoss then
        health:SetHeight(C.DB.Unitframe.BossHealthHeight)
    elseif isArena then
        health:SetHeight(C.DB.Unitframe.ArenaHealthHeight)
    end

    if inverted then
        local gradient = health:CreateTexture(nil, 'BACKGROUND')
        gradient:SetPoint('TOPLEFT')
        gradient:SetPoint('BOTTOMRIGHT')
        gradient:SetTexture(C.Assets.Textures.Backdrop)
        gradient:SetGradientAlpha('VERTICAL', 0.3, 0.3, 0.3, 0.6, 0.1, 0.1, 0.1, 0.6)

        self.gradient = gradient
    else
        local bg = health:CreateTexture(nil, 'BACKGROUND')
        bg:SetAllPoints(health)
        bg:SetTexture(UNITFRAME.StatusBarTex)
        bg.multiplier = 0.25
        health.bg = bg
    end

    self.Health = health
    self.Health.PreUpdate = inverted and PreUpdateHealth
    self.Health.PostUpdate = inverted and PostUpdateHealth
    self.Health.PostUpdateColor = inverted and PostUpdateColor

    UNITFRAME:UpdateHealthBarColor(self)
end

-- Heal Prediction
local function PostUpdateHealPrediction(element, unit)
    local r, g, b = F:UnitColor(unit)

    if element.myBar then
        element.myBar:SetStatusBarColor(r / 2, g / 2, b / 2, 0.6)
    end

    if element.otherBar then
        element.otherBar:SetStatusBarColor(r / 2, g / 2, b / 2, 0.6)
    end

    if element.absorbBar then
        element.absorbBar:SetStatusBarColor(r / 2, g / 2, b / 2, 0.6)
    end
end

function UNITFRAME:CreateHealPrediction(self)
    local inverted = C.DB.Unitframe.InvertedColorMode

    local myBar = CreateFrame('StatusBar', nil, self.Health)
    myBar:SetPoint('TOP')
    myBar:SetPoint('BOTTOM')
    myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), inverted and 'LEFT' or 'RIGHT')
    myBar:SetStatusBarTexture(UNITFRAME.StatusBarTex)
    myBar:SetWidth(self:GetWidth())

    local otherBar = CreateFrame('StatusBar', nil, self.Health)
    otherBar:SetPoint('TOP')
    otherBar:SetPoint('BOTTOM')
    otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), inverted and 'LEFT' or 'RIGHT')
    otherBar:SetStatusBarTexture(UNITFRAME.StatusBarTex)
    otherBar:SetWidth(self:GetWidth())

    local absorbBar = CreateFrame('StatusBar', nil, self.Health)
    absorbBar:SetPoint('TOP')
    absorbBar:SetPoint('BOTTOM')
    absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), inverted and 'LEFT' or 'RIGHT')
    absorbBar:SetStatusBarTexture(C.Assets.Textures.StatusbarStripesThin)
    absorbBar:GetStatusBarTexture():SetBlendMode('ADD')
    -- absorbBar:GetStatusBarTexture():SetHorizTile(true)
    -- absorbBar:GetStatusBarTexture():SetVertTile(true)

    absorbBar:SetStatusBarColor(0.3, 0.3, 0.3, 0.8)
    absorbBar:SetWidth(self:GetWidth())

    local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
    overAbsorb:SetPoint('TOP', self.Health, 'TOPRIGHT', -1, 4)
    overAbsorb:SetPoint('BOTTOM', self.Health, 'BOTTOMRIGHT', -1, -4)
    overAbsorb:SetWidth(12)
    overAbsorb:SetTexture(C.Assets.Textures.Spark)
    overAbsorb:SetBlendMode('ADD')

    self.HealthPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        absorbBar = absorbBar,
        overAbsorb = overAbsorb,
        maxOverflow = 1,
        frequentUpdates = true,
    }
    self.HealthPrediction.PostUpdate = PostUpdateHealPrediction
end
