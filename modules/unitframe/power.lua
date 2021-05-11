local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local OUF = F.Libs.oUF

local function PostUpdatePower(power, unit, _, _, max)
    if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        power:SetValue(0)
    end
end

local function UpdatePowerColor(power, unit)
    if unit ~= 'player' or UnitHasVehicleUI('player') then
        return
    end

    local spec = GetSpecialization() or 0
    if C.MyClass == 'DEMONHUNTER' then
        if spec ~= 1 then
            return
        end

        -- EyeBeam needs 30 power, ChaosStrike needs 40 power
        -- BladeDance needs 35 power or 15 power with FirstBlood
        local eyeBeam, _ = IsUsableSpell(198013)
        local chaosStrike, _ = IsUsableSpell(162794)
        -- local bladeDance, _ = IsUsableSpell(188499)

        if chaosStrike then
            power:SetStatusBarColor(.85, .16, .23)
        elseif eyeBeam then
            power:SetStatusBarColor(.93, .74, .13)
        else
            power:SetStatusBarColor(.5, .5, .5)
        end
    elseif C.MyClass == 'WARRIOR' then
        if spec ~= 2 then
            return
        end

        local rampage, _ = IsUsableSpell(184367)

        if rampage then
            power:SetStatusBarColor(184 / 255, 92 / 255, 214 / 255)
        else
            power:SetStatusBarColor(215 / 255, 22 / 255, 55 / 255)
        end
    end
end

function UNITFRAME:AddPowerBar(self)
    local style = self.unitStyle

    local power = CreateFrame('StatusBar', nil, self)
    power:SetPoint('LEFT')
    power:SetPoint('RIGHT')
    power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
    power:SetStatusBarTexture(C.Assets.statusbar_tex)
    power:SetHeight(C.DB.Unitframe.PowerBarHeight)

    F:SmoothBar(power)
    power.frequentUpdates = true

    self.Power = power

    local line = power:CreateTexture(nil, 'OVERLAY')
    line:SetHeight(C.Mult)
    line:SetPoint('TOPLEFT', 0, C.Mult)
    line:SetPoint('TOPRIGHT', 0, C.Mult)
    line:SetTexture(C.Assets.bd_tex)
    line:SetVertexColor(0, 0, 0)

    local bg = power:CreateTexture(nil, 'BACKGROUND')
    bg:SetAllPoints()
    bg:SetTexture(C.Assets.bd_tex)
    bg:SetAlpha(.2)
    bg.multiplier = .1
    power.bg = bg

    power.colorTapping = true
    power.colorDisconnected = true

    if C.DB.Unitframe.Transparent and style ~= 'player' then
        power.colorClass = true
        power.colorReaction = true
    else
        power.colorPower = true
    end

    self.Power.PostUpdate = PostUpdatePower

    if style == 'player' or style == 'playerplate' then
        self.Power.PostUpdateColor = UpdatePowerColor
    end
end

--[[ Alternative power ]]

local function AltPowerOnEnter(self)
    if (not self:IsVisible()) then
        return
    end

    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
    self:UpdateTooltip()
end

local function AltPowerUpdateTooltip(self)
    local value = self:GetValue()
    local min, max = self:GetMinMaxValues()
    local name, tooltip = GetUnitPowerBarStringsByID(self.__barID)
    _G.GameTooltip:SetText(name or '', 1, 1, 1)
    _G.GameTooltip:AddLine(tooltip or '', nil, nil, nil, true)
    _G.GameTooltip:AddLine(format('%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
    _G.GameTooltip:Show()
end

local function PostUpdateAltPower(self, _, cur, _, max)
    local parent = self.__owner

    if cur and max then
        local value = parent.AlternativePowerValue
        local r, g, b = F:ColorGradient(cur / max, unpack(OUF.colors.smooth))

        self:SetStatusBarColor(r, g, b)
        value:SetTextColor(r, g, b)
    end

    if self:IsShown() then
        parent.ClassPowerBarHolder:ClearAllPoints()
        parent.ClassPowerBarHolder:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
    else
        parent.ClassPowerBarHolder:ClearAllPoints()
        parent.ClassPowerBarHolder:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -3)
    end
end

function UNITFRAME:AddAlternativePowerBar(self)
    local altPower = CreateFrame('StatusBar', nil, self)
    altPower:SetStatusBarTexture(C.Assets.statusbar_tex)
    altPower:SetPoint('TOP', self.Power, 'BOTTOM', 0, -2)
    altPower:Size(self:GetWidth(), C.DB.Unitframe.AlternativePowerBarHeight)
    altPower:EnableMouse(true)
    F:SmoothBar(altPower)
    altPower.bg = F.SetBD(altPower)

    altPower.UpdateTooltip = AltPowerUpdateTooltip
    altPower:SetScript('OnEnter', AltPowerOnEnter)

    self.AlternativePower = altPower
    self.AlternativePower.PostUpdate = PostUpdateAltPower
end
