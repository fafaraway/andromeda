local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function PostUpdatePower(power, unit, _, _, max)
    if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        power:SetValue(0)
    end
end

local function IsSpellAvailable(spellId)
    local _, noPower = IsUsableSpell(spellId)
    if noPower then
        return false
    else
        return true
    end
end

local function UpdatePowerColor(power, unit)
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
        if IsSpellAvailable(49998) then -- Death Strike
            power:SetStatusBarColor(r, g, b)
        else
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        end
    elseif isFrost then -- Frost Death Knight
        if IsSpellAvailable(49143) then -- Frost Strike
            power:SetStatusBarColor(r, g, b)
        else
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        end
    elseif isVengeance then -- Vengeance Demon Hunter
        if IsSpellAvailable(212084) then -- Fel Devastation
            power:SetStatusBarColor(r, g, b)
        elseif IsSpellAvailable(228477) then -- Soul Cleave
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        else
            power:SetStatusBarColor(0.3, 0.3, 0.3)
        end
    elseif isHavoc then -- Havoc Demon Hunter
        if IsSpellAvailable(162794) then -- Chaos Strike
            power:SetStatusBarColor(r, g, b)
        elseif IsSpellAvailable(198013) then -- Eye Beam
            power:SetStatusBarColor(r * 0.5, g * 0.5, b * 0.5)
        else
            power:SetStatusBarColor(0.3, 0.3, 0.3)
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
    power:SetPoint('BOTTOM')
    power:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
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
    line:SetHeight(C.MULT)
    line:SetPoint('TOPLEFT', 0, C.MULT)
    line:SetPoint('TOPRIGHT', 0, C.MULT)
    line:SetTexture(C.Assets.Textures.Backdrop)
    line:SetVertexColor(0, 0, 0)

    if not inverted then
        local bg = power:CreateTexture(nil, 'BACKGROUND')
        bg:SetAllPoints()
        bg:SetTexture(C.Assets.Textures.Backdrop)
        bg.multiplier = 0.1
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
    if not self:IsVisible() then
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
        local value = parent.AltPowerTag
        local r, g, b = F:ColorGradient(cur / max, unpack(oUF.colors.smooth))

        self:SetStatusBarColor(r, g, b)
        value:SetTextColor(r, g, b)
    end

    if self:IsShown() then
        if parent.ClassPowerBar then
            parent.ClassPowerBar:ClearAllPoints()
            parent.ClassPowerBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
        end
    else
        if parent.ClassPowerBar then
            parent.ClassPowerBar:ClearAllPoints()
            parent.ClassPowerBar:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -3)
        end
    end
end

function UNITFRAME:CreateAlternativePowerBar(self)
    local smooth = C.DB.Unitframe.Smooth
    local altPower = CreateFrame('StatusBar', nil, self)
    altPower:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
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
