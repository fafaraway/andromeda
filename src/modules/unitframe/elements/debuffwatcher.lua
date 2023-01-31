local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local LBG = F.Libs.LibButtonGlow

local invalidPrio = -1
local instName

local function checkInstance()
    instName = IsInInstance() and GetInstanceInfo()
end

local DispellColor = {
    ['Magic'] = { 0.2, 0.6, 1 },
    ['Curse'] = { 0.6, 0, 1 },
    ['Disease'] = { 0.6, 0.4, 0 },
    ['Poison'] = { 0, 0.6, 0 },
    ['none'] = { 0, 0, 0 },
}

local DispellPriority = {
    ['Magic'] = 4,
    ['Curse'] = 3,
    ['Disease'] = 2,
    ['Poison'] = 1,
}

local DispellFilter
do
    local dispellClasses = {
        ['DRUID'] = {
            ['Magic'] = false,
            ['Curse'] = true,
            ['Poison'] = true,
        },
        ['MONK'] = {
            ['Magic'] = true,
            ['Poison'] = true,
            ['Disease'] = true,
        },
        ['PALADIN'] = {
            ['Magic'] = false,
            ['Poison'] = true,
            ['Disease'] = true,
        },
        ['PRIEST'] = {
            ['Magic'] = true,
            ['Disease'] = true,
        },
        ['SHAMAN'] = {
            ['Magic'] = false,
            ['Curse'] = true,
        },
        ['MAGE'] = {
            ['Curse'] = true,
        },
        ['EVOKER'] = {
            ['Magic'] = false,
            ['Poison'] = true,
        },
    }

    DispellFilter = dispellClasses[C.MY_CLASS] or {}
end

local function checkSpecs()
    if C.MY_CLASS == 'DRUID' then
        DispellFilter.Magic = GetSpecialization() == 4
    elseif C.MY_CLASS == 'MONK' then
        DispellFilter.Magic = GetSpecialization() == 2
    elseif C.MY_CLASS == 'PALADIN' then
        DispellFilter.Magic = GetSpecialization() == 1
    elseif C.MY_CLASS == 'SHAMAN' then
        DispellFilter.Magic = GetSpecialization() == 3
    elseif C.MY_CLASS == 'EVOKER' then
        DispellFilter.Magic = GetSpecialization() == 2
    end
end

UNITFRAME.RaidDebuffsList = {}

function UNITFRAME:UpdateRaidDebuffsList()
    wipe(UNITFRAME.RaidDebuffsList)

    for instName, value in pairs(C.RaidDebuffsList) do
        for spell, priority in pairs(value) do
            if not (_G.ANDROMEDA_ADB['RaidDebuffsList'][instName] and _G.ANDROMEDA_ADB['RaidDebuffsList'][instName][spell]) then
                if not UNITFRAME.RaidDebuffsList[instName] then
                    UNITFRAME.RaidDebuffsList[instName] = {}
                end
                UNITFRAME.RaidDebuffsList[instName][spell] = priority
            end
        end
    end

    for instName, value in pairs(_G.ANDROMEDA_ADB['RaidDebuffsList']) do
        for spell, priority in pairs(value) do
            if priority > 0 then
                if not UNITFRAME.RaidDebuffsList[instName] then
                    UNITFRAME.RaidDebuffsList[instName] = {}
                end
                UNITFRAME.RaidDebuffsList[instName][spell] = priority
            end
        end
    end
end

function UNITFRAME:UpdateRaidInfo()
    checkInstance()
    F:RegisterEvent('PLAYER_ENTERING_WORLD', checkInstance)
    checkSpecs()
    F:RegisterEvent('PLAYER_TALENT_UPDATE', checkSpecs)
    UNITFRAME:UpdateRaidDebuffsList()
end

function UNITFRAME:AuraButton_OnEnter()
    if not self.index then
        return
    end
    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:SetUnitAura(self.unit, self.index, self.filter)
    _G.GameTooltip:Show()
end

function UNITFRAME:CreateAurasIndicator(self)
    local auraSize = (C.DB.Unitframe.PartyHealthHeight + C.DB.Unitframe.PartyPowerHeight) * 0.65

    local auraFrame = CreateFrame('Frame', nil, self)
    auraFrame:SetSize(1, 1)
    auraFrame:SetPoint('CENTER')
    auraFrame.instAura = C.DB.Unitframe.InstanceDebuff
    auraFrame.dispellType = C.DB.Unitframe.DebuffWatcherDispellType

    auraFrame.buttons = {}
    local prevAura
    for i = 1, 2 do
        local button = CreateFrame('Frame', nil, auraFrame)
        button:SetSize(auraSize, auraSize)
        button:SetFrameLevel(self:GetFrameLevel() + 3)
        F.PixelIcon(button)
        F.CreateSD(button, 0.25, 5, 5, true)
        button.__shadow:SetFrameLevel(self:GetFrameLevel() + 2)
        button:Hide()

        button:SetScript('OnEnter', UNITFRAME.AuraButton_OnEnter)
        button:SetScript('OnLeave', F.HideTooltip)

        local parentFrame = CreateFrame('Frame', nil, button)
        parentFrame:SetAllPoints()
        parentFrame:SetFrameLevel(button:GetFrameLevel() + 8)

        local outline = _G.ANDROMEDA_ADB.FontOutline
        local font = C.Assets.Fonts.HalfHeight
        local fontSize = max(auraSize * 0.4, 12)
        button.count = F.CreateFS(parentFrame, font, fontSize, outline or nil, nil, nil, outline and 'NONE' or 'THICK')
        button.count:ClearAllPoints()
        button.count:SetPoint('RIGHT', button, 'TOPRIGHT')
        button.timer = F.CreateFS(button, font, fontSize, outline or nil, nil, nil, outline and 'NONE' or 'THICK')
        button.timer:ClearAllPoints()
        button.timer:SetPoint('LEFT', button, 'BOTTOMLEFT')
        button.glowFrame = F.CreateGlowFrame(button, auraSize)

        if not prevAura then
            button:SetPoint('CENTER')
        else
            button:SetPoint('LEFT', prevAura, 'RIGHT', 5, 0)
        end
        prevAura = button
        auraFrame.buttons[i] = button
    end

    self.AurasIndicator = auraFrame
    self.AurasIndicator.Debuffs = UNITFRAME.RaidDebuffsList

    UNITFRAME.AurasIndicator_UpdateOptions(self)
end

function UNITFRAME.SortAuraTable(a, b)
    if a and b then
        return a.priority == b.priority and a.expiration > b.expiration or a.priority > b.priority
    end
end

function UNITFRAME:AurasIndicator_UpdatePriority(numDebuffs, unit)
    local auras = self.AurasIndicator
    local dispellType = auras.dispellType
    local raidAuras = self.RaidAuras
    local isCharmed = UnitIsCharmed(unit) or UnitCanAttack('player', unit)

    for i = 1, numDebuffs do
        local aura = raidAuras.debuffList[i]
        if dispellType ~= 3 and aura.debuffType and not isCharmed then
            if dispellType == 2 then -- dispellable first
                aura.priority = DispellFilter[aura.debuffType] and (DispellPriority[aura.debuffType] + 6)
            elseif dispellType == 1 then -- by dispell type
                aura.priority = DispellPriority[aura.debuffType]
            end
            aura.priority = aura.priority or invalidPrio
        end

        if auras.instAura then
            local instPrio
            local debuffList = instName and auras.Debuffs[instName] or auras.Debuffs[0]
            if debuffList then
                instPrio = debuffList[aura.spellID]
            end

            if instPrio and (instPrio == 6 or instPrio > aura.priority) then
                aura.priority = instPrio
            end
        end
    end

    sort(raidAuras.debuffList, UNITFRAME.SortAuraTable)
end

function UNITFRAME:AurasIndicator_UpdateButton(button, aura)
    local icon, count, debuffType, duration, expiration = aura.texture, aura.count, aura.debuffType, aura.duration, aura.expiration
    button.unit, button.index, button.filter = aura.unit, aura.index, aura.filter

    if button.Icon then
        button.Icon:SetTexture(icon)
    end
    if button.count then
        button.count:SetText(count > 1 and count or '')
    end
    if button.timer then
        button.duration = duration
        if duration and duration > 0 then
            button.expiration = expiration
            button:SetScript('OnUpdate', F.CooldownOnUpdate)
            button.timer:Show()
        else
            button:SetScript('OnUpdate', nil)
            button.timer:Hide()
        end
    end
    if button.cd then
        if duration and duration > 0 then
            button.cd:SetCooldown(expiration - duration, duration)
            button.cd:Show()
        else
            button.cd:Hide()
        end
    end
    local color = DispellColor[debuffType] or DispellColor.none
    if button.__shadow then
        button.__shadow:SetBackdropBorderColor(color[1], color[2], color[3])
    end
    if button.glowFrame then
        if aura.priority == 6 then
            LBG.ShowOverlayGlow(button.glowFrame)
        else
            LBG.HideOverlayGlow(button.glowFrame)
        end
    end
    button:Show()
end

function UNITFRAME:AurasIndicator_HideButtons()
    local auras = self.AurasIndicator
    if auras then
        auras.buttons[1]:Hide()
        auras.buttons[2]:Hide()
    end
end

function UNITFRAME:AurasIndicator_UpdateOptions()
    local auras = self.AurasIndicator
    if not auras then
        return
    end

    auras.instAura = C.DB.Unitframe.InstanceDebuff
    auras.dispellType = C.DB.Unitframe.DebuffWatcherDispellType
    local scale = C.DB.Unitframe.DebuffWatcherScale
    local disableMouse = C.DB.Unitframe.DebuffWatcherClickThru

    for i = 1, 2 do
        local button = auras.buttons[i]
        if button then
            button:SetScale(scale)
            button:EnableMouse(not disableMouse)
        end
    end
end
