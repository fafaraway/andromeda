local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local sbColor = { 0.1, 0.1, 0.1, 1 }
local bgColor = { 0.6, 0.6, 0.6, 1 }

-- 头像框体颜色风格
-- 1: 统一黑色
-- 2: 玩家单位根据职业染色，非玩家单位根据 reaction 染色
-- 3: 根据生命值百分比渐变染色
-- 4: 透明风格，损失血量染色同 2
-- 5: 透明风格，职业色渐变，损失血量染色同 3
local function updateHealthColorByIndex(health, index)
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
        --local color = C.DB.Unitframe.HealthColor
        health:SetStatusBarColor(sbColor[1], sbColor[2], sbColor[3], sbColor[4])

        health.bg:SetVertexColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])

    elseif index == 4 or index == 5 then
        health:SetStatusBarColor(0.1, 0.1, 0.1, 0.45)
    end
end

function UNITFRAME:UpdateHealthBarColor(self, force)
    local style = self.unitStyle
    local health = self.Health

    if style == 'raid' then
        updateHealthColorByIndex(health, C.DB.Unitframe.RaidHealthColorStyle)
    else
        updateHealthColorByIndex(health, C.DB.Unitframe.HealthColorStyle)
    end

    if force then
        health:ForceUpdate()
    end
end

local endColor = CreateColor(0, 0, 0, 0.25)
function UNITFRAME.PostUpdateHealth(element, unit, cur, max)
    local self = element.__owner
    local style = self.unitStyle
    local useClassColor, useGradient, useGradientClass

    if style == 'raid' then
        useClassColor = C.DB.Unitframe.RaidHealthColorStyle == 4

        useGradient = C.DB.Unitframe.RaidHealthColorStyle == 5
        useGradientClass = C.DB.Unitframe.RaidHealthColorStyle == 5
    else
        useClassColor = C.DB.Unitframe.HealthColorStyle == 4

        useGradient = C.DB.Unitframe.HealthColorStyle == 5
        useGradientClass = C.DB.Unitframe.HealthColorStyle == 5
    end

    if useGradient then
        element.bg:SetVertexColor(self:ColorGradient(cur or 1, max or 1, 1, 0, 0, 1, 0.7, 0, 0.7, 1, 0))
    end

    local color
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = self.colors.class[class]
    elseif UnitReaction(unit, 'player') then
        color = self.colors.reaction[UnitReaction(unit, 'player')]
    end
    if color then
        if useGradientClass then
            element:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(color[1], color[2], color[3], 0.65), endColor)
        end

        if useClassColor then
            element.bg:SetVertexColor(color[1], color[2], color[3], 1)
        end
    end
end

function UNITFRAME:CreateHealthBar(self)
    local style = self.unitStyle
    local smooth = C.DB.Unitframe.Smooth
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
    health:SetPoint('LEFT')
    health:SetPoint('RIGHT')
    health:SetPoint('TOP')
    health:SetFrameStrata('LOW')
    health:SetStatusBarTexture(UNITFRAME.StatusBarTex)
    health:SetStatusBarColor(sbColor[1], sbColor[2], sbColor[3], sbColor[4])
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

    local bg = health:CreateTexture(nil, 'BACKGROUND')
    bg:SetTexture(UNITFRAME.StatusBarTex)
    bg:SetPoint('TOPLEFT', health:GetStatusBarTexture(), 'TOPRIGHT')
    bg:SetPoint('BOTTOMRIGHT', health)
    bg:SetVertexColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
    bg.multiplier = 0.25

    self.Health = health
    self.Health.bg = bg

    self.Health.PostUpdate = UNITFRAME.PostUpdateHealth

    UNITFRAME:UpdateHealthBarColor(self)
end

-- set health update frequency
function UNITFRAME:UpdateRaidHealthMethod()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'raid' then
            frame:SetHealthUpdateMethod(C.DB.Unitframe.FrequentHealth)
            frame:SetHealthUpdateSpeed(C.DB.Unitframe.HealthFrequency)
            frame.Health:ForceUpdate()
        end
    end
end
