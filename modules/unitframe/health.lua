local _G = _G
local unpack = unpack
local select = select
local floor = floor
local CreateFrame = CreateFrame
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsTapDenied = UnitIsTapDenied

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local function OverrideHealth(self, event, unit)
    if not C.DB.Unitframe.Transparent then
        return
    end
    if (not unit or self.unit ~= unit) then
        return
    end

    local health = self.Health
    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    local isOffline = not UnitIsConnected(unit)
    local isDead = UnitIsDead(unit)
    local isGhost = UnitIsGhost(unit)

    health:SetMinMaxValues(0, max)

    if isDead or isGhost or isOffline then
        self:SetValue(0)
    else
        if max == cur then
            health:SetValue(0)
        else
            health:SetValue(max - cur)
        end
    end
end

local function PostUpdateHealth(self, unit, cur, max)
    local parent = self:GetParent()
    local style = self.__owner.unitStyle
    local perhp = floor(UnitHealth('player') / max * 100 + .5)

    if style == 'player' and parent.EmergencyIndicator then
        if perhp < 35 then
            parent.EmergencyIndicator:Show()
        else
            parent.EmergencyIndicator:Hide()
        end
    end

    local isOffline = not UnitIsConnected(unit)
    local isDead = UnitIsDead(unit)
    local isGhost = UnitIsGhost(unit)
    local isTapped = UnitIsTapDenied(unit)

    if not C.DB.Unitframe.Transparent then
        return
    end

    if isDead or isGhost or isOffline then
        self:SetValue(0)
    else
        if max == cur then
            self:SetValue(0)
        else
            self:SetValue(max - cur)
        end
    end

    if isDead or isGhost then
        parent.Bg:SetBackdropColor(0, 0, 0, .8)
    elseif isOffline or isTapped then
        parent.Bg:SetBackdropColor(.5, .5, .5, .6)
    else
        parent.Bg:SetBackdropColor(.1, .1, .1, .6)
    end
end

function UNITFRAME:CreateHealthBar(self)
    local style = self.unitStyle
    local transMode = C.DB.Unitframe.Transparent
    local groupColorStyle = C.DB.Unitframe.GroupColorStyle
    local colorStyle = C.DB.Unitframe.ColorStyle
    local isParty = (style == 'party')
    local isRaid = (style == 'raid')
    local isBoss = (style == 'boss')
    local isArena = (style == 'arena')
    local isBaseUnits = F:MultiCheck(style, 'player', 'pet', 'target', 'targettarget', 'focus', 'focustarget')

    local health = CreateFrame('StatusBar', nil, self)
    health:SetFrameStrata('LOW')
    health:SetStatusBarTexture(C.Assets.statusbar_tex)
    health:SetReverseFill(C.DB.Unitframe.Transparent)
    health:SetStatusBarColor(.1, .1, .1, 1)
    health:SetPoint('TOP')
    health:SetPoint('LEFT')
    health:SetPoint('RIGHT')
    health:SetPoint('BOTTOM', 0, C.Mult + C.DB.Unitframe.PowerBarHeight)
    health:SetHeight(self:GetHeight() - C.DB.Unitframe.PowerBarHeight - C.Mult)
    F:SmoothBar(health)

    if not transMode then
        local bg = health:CreateTexture(nil, 'BACKGROUND')
        bg:SetAllPoints(health)
        bg:SetTexture(C.Assets.bd_tex)
        bg:SetVertexColor(.6, .6, .6)
        bg.multiplier = .1
        health.bg = bg
    end

    health.colorTapping = true
    health.colorDisconnected = true

    if ((isParty or isRaid or isBoss) and groupColorStyle == 2) or (isBaseUnits and colorStyle == 2) or isArena then
        health.colorClass = true
        health.colorReaction = true
    elseif ((isParty or isRaid or isBoss) and groupColorStyle == 3) or (isBaseUnits and colorStyle == 3) then
        health.colorSmooth = true
    else
        health.colorHealth = true
    end

    self.Health = health
    self.Health.frequentUpdates = true
    self.Health.PreUpdate = OverrideHealth
    self.Health.PostUpdate = PostUpdateHealth
end

-- Prediction
function UNITFRAME:CreateHealthPrediction(self)
    local trans = C.DB.Unitframe.Transparent
    -- local colors = C.ClassColors[C.MyClass] or C.ClassColors['PRIEST']

    local myBar = CreateFrame('StatusBar', nil, self.Health)
    myBar:SetPoint('TOP')
    myBar:SetPoint('BOTTOM')
    myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), trans and 'LEFT' or 'RIGHT')
    myBar:SetStatusBarTexture(C.Assets.statusbar_tex)
    --myBar:GetStatusBarTexture():SetBlendMode('BLEND')
    myBar:SetStatusBarColor(.35, .24, .16, .6)
    -- myBar:SetStatusBarColor(colors.r / 2, colors.g / 2, colors.b / 2, .85)
    myBar:SetWidth(self:GetWidth())

    local otherBar = CreateFrame('StatusBar', nil, self.Health)
    otherBar:SetPoint('TOP')
    otherBar:SetPoint('BOTTOM')
    otherBar:SetPoint('LEFT', myBar:GetStatusBarTexture(), trans and 'LEFT' or 'RIGHT')
    otherBar:SetStatusBarTexture(C.Assets.statusbar_tex)
    --otherBar:GetStatusBarTexture():SetBlendMode('BLEND')
    otherBar:SetStatusBarColor(.11, .35, .25, .6)
    -- otherBar:SetStatusBarColor(colors.r / 2, colors.g / 2, colors.b / 2, .85)
    otherBar:SetWidth(self:GetWidth())

    local absorbBar = CreateFrame('StatusBar', nil, self.Health)
    absorbBar:SetPoint('TOP')
    absorbBar:SetPoint('BOTTOM')
    absorbBar:SetPoint('LEFT', otherBar:GetStatusBarTexture(), trans and 'LEFT' or 'RIGHT')
    absorbBar:SetStatusBarTexture(C.Assets.stripe_tex)
    absorbBar:GetStatusBarTexture():SetBlendMode('BLEND')
    absorbBar:SetStatusBarColor(.8, .8, .8, .8)
    absorbBar:SetWidth(self:GetWidth())

    local overAbsorb = self.Health:CreateTexture(nil, 'OVERLAY')
    overAbsorb:SetPoint('TOP', self.Health, 'TOPRIGHT', -1, 4)
    overAbsorb:SetPoint('BOTTOM', self.Health, 'BOTTOMRIGHT', -1, -4)
    overAbsorb:SetWidth(12)
    overAbsorb:SetTexture(C.AssetsPath .. 'textures\\spark_tex')
    overAbsorb:SetBlendMode('ADD')

    self.HealthPrediction = {
        myBar = myBar,
        otherBar = otherBar,
        absorbBar = absorbBar,
        overAbsorb = overAbsorb,
        maxOverflow = 1,
        frequentUpdates = true,
    }
end
