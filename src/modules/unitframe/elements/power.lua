local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local function updatePowerColorByIndex(power, index)
    power.colorPower = (index == 2)
    power.colorClass = (index ~= 2)
    power.colorReaction = (index ~= 2)

    if power.SetColorTapping then
        power:SetColorTapping(index ~= 2)
    else
        power.colorTapping = (index ~= 2)
    end

    if power.SetColorDisconnected then
        power:SetColorDisconnected(index ~= 2)
    else
        power.colorDisconnected = (index ~= 2)
    end
end

function UNITFRAME:UpdatePowerBarColor(self, force)
    local power = self.Power
    local style = self.unitStyle

    if style == 'raid' then
        updatePowerColorByIndex(power, C.DB.Unitframe.RaidHealthColorStyle)
    else
        updatePowerColorByIndex(power, C.DB.Unitframe.HealthColorStyle)

        if style == 'player' then
            power.colorPower = (C.DB.Unitframe.HealthColorStyle == 4 or C.DB.Unitframe.HealthColorStyle == 5)
            power.colorClass = (C.DB.Unitframe.HealthColorStyle == 1 or C.DB.Unitframe.HealthColorStyle == 3)
        end
    end

    if force then
        power:ForceUpdate()
    end
end

local function postUpdatePower(power, unit, _, _, max)
    if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        power:SetValue(0)
    end
end

local function checkSpell(spellId)
    local _, noPower = IsUsableSpell(spellId)
    if noPower then
        return false
    else
        return true
    end
end

local function updatePowerColorBySpell(power, unit)
    if unit ~= 'player' or UnitHasVehicleUI('player') then
        return
    end

    if not C.IS_DEVELOPER then
        return
    end

    local spec = GetSpecialization() or 0
    local isBlood = C.MY_CLASS == 'DEATHKNIGHT' and spec == 1
    local isFrost = C.MY_CLASS == 'DEATHKNIGHT' and spec == 2
    local isHavoc = C.MY_CLASS == 'DEMONHUNTER' and spec == 1
    local isVengeance = C.MY_CLASS == 'DEMONHUNTER' and spec == 2
    local r, g, b = power:GetStatusBarColor()

    if isBlood then -- Blood Death Knight
        if checkSpell(49998) then -- Death Strike
            power:SetStatusBarColor(r, g, b)
        else
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        end
    elseif isFrost then -- Frost Death Knight
        if checkSpell(49143) then -- Frost Strike
            power:SetStatusBarColor(r, g, b)
        else
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        end
    elseif isVengeance then -- Vengeance Demon Hunter
        if checkSpell(212084) then -- Fel Devastation
            power:SetStatusBarColor(r, g, b)
        elseif checkSpell(228477) then -- Soul Cleave
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        else
            power:SetStatusBarColor(0.3, 0.3, 0.3)
        end
    elseif isHavoc then -- Havoc Demon Hunter
        if checkSpell(162794) then -- Chaos Strike
            power:SetStatusBarColor(r, g, b)
        elseif checkSpell(198013) then -- Eye Beam
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        else
            power:SetStatusBarColor(0.3, 0.3, 0.3)
        end
    end
end

local frequentUpdateCheck = {
    ['player'] = true,
    ['target'] = true,
    ['focus'] = true,
}

function UNITFRAME:CreatePowerBar(self)
    local powerHeight
    -- stylua: ignore start
    powerHeight = UNITFRAME:GetHeightVal(
        self,
        C.DB.Unitframe.PlayerPowerHeight,
        C.DB.Unitframe.PetPowerHeight,
        C.DB.Unitframe.TargetPowerHeight,
        C.DB.Unitframe.TargetTargetPowerHeight,
        C.DB.Unitframe.FocusPowerHeight,
        C.DB.Unitframe.FocusTargetPowerHeight,
        C.DB.Unitframe.PartyPowerHeight,
        C.DB.Unitframe.RaidPowerHeight,
        C.DB.Unitframe.BossPowerHeight,
        C.DB.Unitframe.ArenaPowerHeight
    )
    -- stylua: ignore end

    local power = CreateFrame('StatusBar', nil, self)
    power:SetPoint('LEFT')
    power:SetPoint('RIGHT')
    power:SetPoint('BOTTOM')
    power:SetHeight(powerHeight)
    power:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)

    if C.DB.Unitframe.Smooth then
        F:SmoothBar(power)
    end

    local line = power:CreateTexture(nil, 'OVERLAY')
    line:SetHeight(C.MULT)
    line:SetPoint('TOPLEFT', 0, C.MULT)
    line:SetPoint('TOPRIGHT', 0, C.MULT)
    line:SetTexture(C.Assets.Textures.Backdrop)
    line:SetVertexColor(0, 0, 0)

    local bg = power:CreateTexture(nil, 'BACKGROUND')
    bg:SetAllPoints()
    bg:SetTexture(C.Assets.Textures.Backdrop)
    bg.multiplier = 0.25
    power.bg = bg

    self.Power = power
    self.Power.bg = bg

    power.frequentUpdates = frequentUpdateCheck[self.unitStyle]
    power.PostUpdate = postUpdatePower
    power.PostUpdateColor = updatePowerColorBySpell

    UNITFRAME:UpdatePowerBarColor(self)

    F:RegisterEvent('PLAYER_TALENT_UPDATE', updatePowerColorBySpell)
end
