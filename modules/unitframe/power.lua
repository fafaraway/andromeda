local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

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
        if spec == 1 then -- Havoc
            -- ChaosStrike needs 40 power
            -- BladeDance needs 35 power or 15 power with FirstBlood
            -- EyeBeam needs 30 power

            -- If Chaos Strike can be used, the energy bar is red
            -- if Blade Dance can be used, the energy bar is yellow
            -- if the eye can be used, the energy bar is green
            -- and if nothing can be used, the energy bar is gray

            local _, eyeBeam = IsUsableSpell(198013)
            local _, bladeDance = IsUsableSpell(188499)
            local _, chaosStrike = IsUsableSpell(162794)

            if not chaosStrike then
                power:SetStatusBarColor(234 / 255, 64 / 255, 58 / 255)
            elseif not bladeDance then
                power:SetStatusBarColor(234 / 255, 218 / 255, 92 / 255)
            elseif not eyeBeam then
                power:SetStatusBarColor(77 / 255, 218 / 255, 135 / 255)
            else
                power:SetStatusBarColor(.45, .45, .45)
            end
        else -- Vengeance
            -- Fel Devastation needs 50 power
            -- Soul Cleave needs 30 power

            -- If Fel Devastation can be used, the energy bar is red
            -- if Soul Cleave can be used, the energy bar is yellow
            -- and if nothing can be used, the energy bar is gray

            local _, soulCleave = IsUsableSpell(228477)
            local _, felDevastation = IsUsableSpell(212084)

            if not felDevastation then
                power:SetStatusBarColor(234 / 255, 64 / 255, 58 / 255)
            elseif not soulCleave then
                power:SetStatusBarColor(234 / 255, 218 / 255, 92 / 255)
            else
                power:SetStatusBarColor(.45, .45, .45)
            end
        end
    end
end

function UNITFRAME:CreatePowerBar(self)
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

    local power = CreateFrame('StatusBar', nil, self)
    power:SetPoint('LEFT')
    power:SetPoint('RIGHT')
    power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -C.Mult)
    power:SetStatusBarTexture(C.Assets.Textures.Norm)
    F:SmoothBar(power)

    if isPlayer then
        power:SetHeight(C.DB.Unitframe.PlayerPowerHeight)
    elseif isPet then
        power:SetHeight(C.DB.Unitframe.PetPowerHeight)
    elseif isTarget then
        power:SetHeight(C.DB.Unitframe.TargetPowerHeight)
    elseif isToT then
        power:SetHeight(C.DB.Unitframe.TargetTargetPowerHeight)
    elseif isFocus then
        power:SetHeight(C.DB.Unitframe.FocusPowerHeight)
    elseif isToF then
        power:SetHeight(C.DB.Unitframe.FocusTargetPowerHeight)
    elseif isParty then
        power:SetHeight(C.DB.Unitframe.PartyPowerHeight)
    elseif isRaid then
        power:SetHeight(C.DB.Unitframe.RaidPowerHeight)
    elseif isBoss then
        power:SetHeight(C.DB.Unitframe.BossPowerHeight)
    elseif isArena then
        power:SetHeight(C.DB.Unitframe.ArenaPowerHeight)
    end

    local line = power:CreateTexture(nil, 'OVERLAY')
    line:SetHeight(C.Mult)
    line:SetPoint('TOPLEFT', 0, C.Mult)
    line:SetPoint('TOPRIGHT', 0, C.Mult)
    line:SetTexture(C.Assets.bd_tex)
    line:SetVertexColor(0, 0, 0)

    if not inverted then
        local bg = power:CreateTexture(nil, 'BACKGROUND')
        bg:SetAllPoints()
        bg:SetTexture(C.Assets.bd_tex)
        bg.multiplier = .1
        power.bg = bg
    end

    power.Smooth = smooth
    power.frequentUpdates = true

    power.colorTapping = true
    power.colorDisconnected = true
    power.colorPower = not inverted or style == 'player'
    power.colorClass = inverted
    power.colorReaction = inverted

    self.Power = power
    self.Power.PostUpdate = PostUpdatePower
    self.Power.PostUpdateColor = isPlayer and UpdatePowerColor

    F:RegisterEvent('PLAYER_TALENT_UPDATE', UpdatePowerColor)
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
    _G.GameTooltip:AddLine(string.format('%d (%d%%)', value, (value - min) / (max - min) * 100), 1, 1, 1)
    _G.GameTooltip:Show()
end

local function PostUpdateAltPower(self, _, cur, _, max)
    local parent = self.__owner

    if cur and max then
        local value = parent.AltPowerTag
        local r, g, b = F:ColorGradient(cur / max, unpack(oUF.colors.smooth))

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

function UNITFRAME:CreateAlternativePowerBar(self)
    local smooth = C.DB.Unitframe.Smooth
    local altPower = CreateFrame('StatusBar', nil, self)
    altPower:SetStatusBarTexture(C.Assets.Textures.Norm)
    altPower:SetPoint('TOP', self.Power, 'BOTTOM', 0, -2)
    altPower:SetSize(self:GetWidth(), C.DB.Unitframe.AltPowerHeight)
    altPower:EnableMouse(true)
    altPower.Smooth = smooth
    altPower.bg = F.SetBD(altPower)

    altPower.UpdateTooltip = AltPowerUpdateTooltip
    altPower:SetScript('OnEnter', AltPowerOnEnter)

    self.AlternativePower = altPower
    self.AlternativePower.PostUpdate = PostUpdateAltPower
end
