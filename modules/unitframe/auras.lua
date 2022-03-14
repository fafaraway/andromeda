local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function Aura_OnEnter(self)
    if not self:IsVisible() then
        return
    end

    _G.GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
    self:UpdateTooltip()
end

local function Aura_OnLeave()
    _G.GameTooltip:Hide()
end

local function UpdateAuraTooltip(aura)
    _G.GameTooltip:SetUnitAura(aura:GetParent().__owner.unit, aura:GetID(), aura.filter)
end

function UNITFRAME:MODIFIER_STATE_CHANGED(key, state)
    if key ~= 'RALT' then
        return
    end

    for _, object in next, oUF.objects do
        local unit = object.realUnit or object.unit
        if unit == 'target' then
            local auras = object.Auras
            if state == 1 then -- modifier key pressed
                auras.CustomFilter = UNITFRAME.ModifierCustomFilter
            else
                auras.CustomFilter = UNITFRAME.AuraFilter
            end
            auras:ForceUpdate()
            break
        end
    end
end

function UNITFRAME:PLAYER_REGEN_DISABLED()
    F:UnregisterEvent('MODIFIER_STATE_CHANGED', UNITFRAME.MODIFIER_STATE_CHANGED)
end

function UNITFRAME:PLAYER_REGEN_ENABLED()
    F:RegisterEvent('MODIFIER_STATE_CHANGED', UNITFRAME.MODIFIER_STATE_CHANGED)
end

function UNITFRAME:PLAYER_ENTERING_WORLD()
    F:RegisterEvent('PLAYER_REGEN_DISABLED', UNITFRAME.MODIFIER_STATE_CHANGED)
    F:RegisterEvent('PLAYER_REGEN_ENABLED', UNITFRAME.MODIFIER_STATE_CHANGED)

    if InCombatLockdown() then
        UNITFRAME:PLAYER_REGEN_DISABLED()
    else
        UNITFRAME:PLAYER_REGEN_ENABLED()
    end
end

function UNITFRAME.PostCreateIcon(element, button)
    local style = element.__owner.unitStyle
    local isGroup = style == 'party' or style == 'raid'
    local font = C.Assets.Fonts.Roadway
    local fontSize = element.size * .4
    if fontSize < 12 then
        fontSize = 12
    end

    button.bg = F.CreateBDFrame(button, .25)
    button.glow = F.CreateSD(button.bg)

    element.disableCooldown = true
    button:SetFrameLevel(element:GetFrameLevel() + 4)

    button.overlay:SetTexture(nil)
    button.stealable:SetTexture(nil)
    button.cd:SetReverse(true)
    button.icon:SetDrawLayer('ARTWORK')
    button.icon:SetTexCoord(unpack(C.TexCoord))

    button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
    button.HL:SetColorTexture(1, 1, 1, .25)
    button.HL:SetAllPoints()

    button.count = F.CreateFS(button, font, fontSize, true, nil, nil, true)
    button.count:ClearAllPoints()
    button.count:SetPoint(isGroup and 'TOP' or 'TOPRIGHT', button, isGroup and 0 or 2, 4)

    button.timer = F.CreateFS(button, font, fontSize, true, nil, nil, true)
    button.timer:ClearAllPoints()
    button.timer:SetPoint(isGroup and 'BOTTOM' or 'BOTTOMLEFT', button, isGroup and 0 or 2, -4)

    button.UpdateTooltip = UpdateAuraTooltip
    button:SetScript('OnEnter', Aura_OnEnter)
    button:SetScript('OnLeave', Aura_OnLeave)
    button:SetScript('OnClick', function(self, button)
        if not InCombatLockdown() and button == 'RightButton' then
            CancelUnitBuff('player', self:GetID(), self.filter)
        end
    end)
end

local replaceEncryptedIcons = {
    [368078] = 348567, -- 移速
    [368079] = 348567, -- 移速
    [368103] = 648208, -- 急速
    [368243] = 237538 -- CD
}

function UNITFRAME.PostUpdateIcon(element, unit, button, index, _, duration, expiration, debuffType)
    if duration then
        button.bg:Show()

        if button.glow then
            button.glow:Show()
        end
    end

    local style = element.__owner.unitStyle
    local isParty = style == 'party'
    local isRaid = style == 'raid'
    local desaturate = C.DB.Unitframe.DesaturateIcon
    local purgeableHighlight = C.DB.Unitframe.PurgeableHighlight
    local debuffTypeColor = C.DB.Unitframe.DebuffTypeColor
    local _, _, _, _, _, _, _, canStealOrPurge = UnitAura(unit, index, button.filter)

    button:SetSize(element.size, (isParty or isRaid) and element.size or element.size * .75)

    if desaturate and button.isDebuff and F:MultiCheck(style, 'target', 'boss', 'arena', 'nameplate') and not button.isPlayer then
        button.icon:SetDesaturated(true)
    else
        button.icon:SetDesaturated(false)
    end

    if element.disableCooldown then
        if duration and duration > 0 then
            button.expiration = expiration
            button:SetScript('OnUpdate', F.CooldownOnUpdate)
            button.timer:Show()
        else
            button:SetScript('OnUpdate', nil)
            button.timer:Hide()
        end
    end

    if purgeableHighlight and canStealOrPurge and element.showStealableBuffs then
        button.bg:SetBackdropBorderColor(1, 1, 1)

        if button.glow then
            button.glow:SetBackdropBorderColor(1, 1, 1, .25)
        end
    elseif debuffTypeColor and button.isDebuff and element.showDebuffType then
        local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none

        button.bg:SetBackdropBorderColor(color[1], color[2], color[3])

        if button.glow then
            button.glow:SetBackdropBorderColor(color[1], color[2], color[3], .25)
        end
    else
        button.bg:SetBackdropBorderColor(0, 0, 0)

        if button.glow then
            button.glow:SetBackdropBorderColor(0, 0, 0, .25)
        end
    end

    local fontSize = element.size * .4
    if fontSize < 12 then
        fontSize = 12
    end

    button.count:SetFont(C.Assets.Fonts.Square, fontSize, 'OUTLINE')
    button.timer:SetFont(C.Assets.Fonts.Square, fontSize, 'OUTLINE')

    local newTexture = replaceEncryptedIcons[button.spellID]
    if newTexture then
        button.icon:SetTexture(newTexture)
    end
end

local function BolsterPreUpdate(element)
    element.bolster = 0
    element.bolsterIndex = nil
end

local function BolsterPostUpdate(element)
    local button = element.bolsterIndex
    if button then
        button.count:SetText(element.bolster)
    end
end

function UNITFRAME.AuraFilter(element, unit, button, name, _, _, _, _, _, caster, isStealable, _, spellID, _, isBossAura, _, nameplateShowAll)
    local style = element.__owner.unitStyle
    local isMine = F:MultiCheck(caster, 'player', 'pet', 'vehicle')
    local showToT = C.DB.Unitframe.TargetTargetAuras
    local showFocus = C.DB.Unitframe.FocusAuras
    local showToF = C.DB.Unitframe.FocusTargetAuras
    local showPet = C.DB.Unitframe.PetAuras

    if name and spellID == 209859 then
        element.bolster = element.bolster + 1
        if not element.bolsterIndex then
            element.bolsterIndex = button
            return true
        end
    elseif style == 'party' then
        if C.PartyImportantAurasList[spellID] then
            return true
        else
            return false
        end
    elseif style == 'nameplate' or style == 'boss' or style == 'arena' then
        if element.__owner.plateType == 'NameOnly' then
            return _G.FREE_ADB['NPAuraFilter'][1][spellID] or C.AuraWhiteList[spellID]
        elseif _G.FREE_ADB['NPAuraFilter'][2][spellID] or C.AuraBlackList[spellID] then
            return false
        elseif element.showStealableBuffs and isStealable and not UnitIsPlayer(unit) then
            return true
        elseif _G.FREE_ADB['NPAuraFilter'][1][spellID] or C.AuraWhiteList[spellID] then
            return true
        else
            local auraFilter = C.DB.Nameplate.AuraFilterMode
            return (auraFilter == 3 and nameplateShowAll) or (auraFilter ~= 1 and isMine)
        end
    elseif style == 'target' then
        return not button.isDebuff or (element.onlyShowPlayer and button.isPlayer) or (not element.onlyShowPlayer and name)
    elseif (showPet and style == 'pet') or (showToT and style == 'targettarget') or (showFocus and style == 'focus') or (showToF and style == 'focustarget') then
        return button.isDebuff or isStealable or isBossAura or SpellIsPriorityAura(spellID)
    else
        return (element.onlyShowPlayer and button.isPlayer) or (not element.onlyShowPlayer and name)
    end
end

function UNITFRAME.ModifierCustomFilter()
    return true
end

function UNITFRAME.PostUpdateGapIcon(_, _, icon)
    icon:Hide()
end

local function GetIconSize(width, num, size)
    return (width - (num - 1) * size) / num
end

function UNITFRAME:UpdateAuraContainer(parent, element, maxAuras)
    local width = parent:GetWidth()
    local iconsPerRow = element.iconsPerRow
    local maxLines = iconsPerRow and F:Round(maxAuras / iconsPerRow) or 2
    element.size = iconsPerRow and GetIconSize(width, iconsPerRow, element.spacing) or element.size
    element:SetWidth(width)
    element:SetHeight((element.size + element.spacing) * maxLines)
end

function UNITFRAME:CreateAuras(self)
    local style = self.unitStyle
    local bu = CreateFrame('Frame', nil, self)
    bu.gap = true
    bu.spacing = 4
    bu.numTotal = 32

    if style == 'party' then
        bu.initialAnchor = 'LEFT'
        bu:SetPoint('LEFT', self, 'RIGHT', 4, 0)
        bu.size = self:GetHeight() * .7
        bu.numTotal = 4
        bu.disableMouse = false
        bu.disableCooldown = true
    elseif style == 'target' then
        bu.initialAnchor = 'BOTTOMLEFT'
        bu:SetPoint('BOTTOM', self, 'TOP', 0, 24)
        bu['growth-y'] = 'UP'
        bu.iconsPerRow = C.DB.Unitframe.TargetAurasPerRow
    elseif style == 'pet' or style == 'targettarget' or style == 'focus' or style == 'boss' or style == 'arena' then
        bu.initialAnchor = 'TOPLEFT'
        bu:SetPoint('TOP', self, 'BOTTOM', 0, -6)
        bu['growth-y'] = 'DOWN'

        if style == 'pet' then
            bu.iconsPerRow = C.DB.Unitframe.PetAurasPerRow
        elseif style == 'targettarget' then
            bu.iconsPerRow = C.DB.Unitframe.TargetTargetAurasPerRow
        elseif style == 'focus' then
            bu.iconsPerRow = C.DB.Unitframe.FocusAurasPerRow
        elseif style == 'boss' then
            bu.iconsPerRow = C.DB.Unitframe.BossAurasPerRow
        elseif style == 'arena' then
            bu.iconsPerRow = C.DB.Unitframe.ArenaAurasPerRow
        end
    elseif style == 'focustarget' then
        bu.initialAnchor = 'TOPRIGHT'
        bu:SetPoint('TOP', self, 'BOTTOM', 0, -6)
        bu['growth-x'] = 'LEFT'
        bu['growth-y'] = 'DOWN'
        bu.iconsPerRow = C.DB.Unitframe.FocusTargetAurasPerRow
    elseif style == 'nameplate' then
        bu.initialAnchor = 'BOTTOMLEFT'
        bu:SetPoint('BOTTOM', self, 'TOP', 0, 12)
        bu['growth-y'] = 'UP'
        bu.iconsPerRow = 4
        -- bu.size = C.DB.Nameplate.AuraSize
        -- bu.numTotal = C.DB.Nameplate.AuraNumTotal

        bu.disableMouse = true
    end

    UNITFRAME:UpdateAuraContainer(self, bu, bu.numTotal or bu.numBuffs + bu.numDebuffs)

    bu.onlyShowPlayer = C.DB.Unitframe.OnlyShowPlayer
    bu.showDebuffType = true
    bu.showStealableBuffs = true
    bu.CustomFilter = UNITFRAME.AuraFilter
    bu.PostCreateIcon = UNITFRAME.PostCreateIcon
    bu.PostUpdateIcon = UNITFRAME.PostUpdateIcon
    bu.PostUpdateGapIcon = UNITFRAME.PostUpdateGapIcon
    bu.PreUpdate = BolsterPreUpdate
    bu.PostUpdate = BolsterPostUpdate

    self.Auras = bu

    F:RegisterEvent('PLAYER_ENTERING_WORLD', UNITFRAME.PLAYER_ENTERING_WORLD)
end

function UNITFRAME.GroupBuffFilter(_, _, _, _, _, _, _, _, _, caster, _, _, spellID, canApplyAura, isBossAura)
    if isBossAura then
        return true
    else
        local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, UnitAffectingCombat('player') and 'RAID_INCOMBAT' or 'RAID_OUTOFCOMBAT')
        local isPlayerSpell = (caster == 'player' or caster == 'pet' or caster == 'vehicle')
        if hasCustom then
            return showForMySpec or (alwaysShowMine and isPlayerSpell)
        else
            return isPlayerSpell and canApplyAura and not SpellIsSelfBuff(spellID)
        end
    end
end

function UNITFRAME:CreatePartyBuffs(self)
    local bu = CreateFrame('Frame', nil, self)
    bu:SetPoint('TOPLEFT', self.Health, 'TOPLEFT', 2, -2)
    bu.initialAnchor = 'TOPLEFT'
    bu.spacing = 3
    bu.size = C.DB.Unitframe.PartyBuffSize
    bu.num = not C.DB.Unitframe.PartyBuff and 0 or 3
    bu.showStealableBuffs = true
    bu.disableMouse = true
    bu.disableCooldown = true
    bu.CustomFilter = UNITFRAME.GroupBuffFilter

    UNITFRAME:UpdateAuraContainer(self, bu, bu.num)

    bu.PostCreateIcon = UNITFRAME.PostCreateIcon
    bu.PostUpdateIcon = UNITFRAME.PostUpdateIcon

    self.Buffs = bu
end

function UNITFRAME:CreateRaidBuffs(self)
    local bu = CreateFrame('Frame', nil, self)
    bu:SetPoint('TOPLEFT', self.Health, 'TOPLEFT', 2, -2)
    bu.initialAnchor = 'TOPLEFT'
    bu.spacing = 3
    bu.size = C.DB.Unitframe.RaidBuffSize
    bu.num = not C.DB.Unitframe.RaidBuff and 0 or 3
    bu.showStealableBuffs = true
    bu.disableMouse = true
    bu.disableCooldown = true
    bu.CustomFilter = UNITFRAME.GroupBuffFilter

    UNITFRAME:UpdateAuraContainer(self, bu, bu.num)

    bu.PostCreateIcon = UNITFRAME.PostCreateIcon
    bu.PostUpdateIcon = UNITFRAME.PostUpdateIcon

    self.Buffs = bu
end

local debuffBlackList = {
    [206151] = true,
    [296847] = true,
    [338906] = true
}

function UNITFRAME.GroupDebuffFilter(element, _, _, _, _, _, _, _, _, caster, _, _, spellID, _, isBossAura)
    local parent = element.__owner
    if debuffBlackList[spellID] then
        return false
    elseif (C.DB.Unitframe.CornerIndicator and UNITFRAME.CornerSpellsList[spellID]) or parent.RaidDebuffs.spellID == spellID or parent.rawSpellID == spellID then
        return false
    elseif isBossAura or SpellIsPriorityAura(spellID) then
        return true
    else
        local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, UnitAffectingCombat('player') and 'RAID_INCOMBAT' or 'RAID_OUTOFCOMBAT')
        if hasCustom then
            return showForMySpec or (alwaysShowMine and (caster == 'player' or caster == 'pet' or caster == 'vehicle'))
        else
            return true
        end
    end
end

function UNITFRAME:CreatePartyDebuffs(self)
    local bu = CreateFrame('Frame', nil, self)
    bu:SetPoint('BOTTOMRIGHT', self.Health, 'BOTTOMRIGHT', -2, 2)
    bu.initialAnchor = 'BOTTOMRIGHT'
    bu['growth-x'] = 'LEFT'
    bu.spacing = 3
    bu.size = C.DB.Unitframe.PartyDebuffSize
    bu.num = not C.DB.Unitframe.PartyDebuff and 0 or 3
    bu.disableMouse = true
    bu.disableCooldown = true
    bu.showDebuffType = true

    UNITFRAME:UpdateAuraContainer(self, bu, bu.num)

    bu.CustomFilter = UNITFRAME.GroupDebuffFilter
    bu.PostCreateIcon = UNITFRAME.PostCreateIcon
    bu.PostUpdateIcon = UNITFRAME.PostUpdateIcon

    self.Debuffs = bu
end

function UNITFRAME:CreateRaidDebuffs(self)
    local bu = CreateFrame('Frame', nil, self)
    bu:SetPoint('BOTTOMRIGHT', self.Health, 'BOTTOMRIGHT', -2, 2)
    bu.initialAnchor = 'BOTTOMRIGHT'
    bu['growth-x'] = 'LEFT'
    bu.spacing = 3
    bu.size =  C.DB.Unitframe.RaidDebuffSize
    bu.num = not C.DB.Unitframe.RaidDebuff and 0 or 3
    bu.disableMouse = true
    bu.disableCooldown = true
    bu.showDebuffType = true

    UNITFRAME:UpdateAuraContainer(self, bu, bu.num)

    bu.CustomFilter = UNITFRAME.GroupDebuffFilter
    bu.PostCreateIcon = UNITFRAME.PostCreateIcon
    bu.PostUpdateIcon = UNITFRAME.PostUpdateIcon

    self.Debuffs = bu
end

function UNITFRAME:UpdateGroupAuras()
    for _, frame in pairs(oUF.objects) do

        local buffs = frame.Buffs
        local debuffs = frame.Debuffs

        if frame.unitStyle == 'party' then
            if debuffs then
                debuffs.num = not C.DB.Unitframe.PartyDebuff and 0 or 3
                debuffs.size = C.DB.Unitframe.PartyDebuffSize
                UNITFRAME:UpdateAuraContainer(frame, debuffs, debuffs.num)
                debuffs:ForceUpdate()
            end

            if buffs then
                buffs.num = not C.DB.Unitframe.PartyBuff and 0 or 3
                buffs.size = C.DB.Unitframe.PartyBuffSize
                UNITFRAME:UpdateAuraContainer(frame, buffs, buffs.num)
                buffs:ForceUpdate()
            end
        elseif frame.unitStyle == 'raid' then
            if debuffs then
                debuffs.num = not C.DB.Unitframe.RaidDebuff and 0 or 3
                debuffs.size = C.DB.Unitframe.RaidDebuffSize
                UNITFRAME:UpdateAuraContainer(frame, debuffs, debuffs.num)
                debuffs:ForceUpdate()
            end

            if buffs then
                buffs.num = not C.DB.Unitframe.RaidBuff and 0 or 3
                buffs.size = C.DB.Unitframe.RaidBuffSize
                UNITFRAME:UpdateAuraContainer(frame, buffs, buffs.num)
                buffs:ForceUpdate()
            end
        end
    end
end

local function RefreshAurasElements(self)
    local buffs = self.Buffs
    if buffs then
        buffs:ForceUpdate()
    end

    local debuffs = self.Debuffs
    if debuffs then
        debuffs:ForceUpdate()
    end
end

function UNITFRAME:RefreshAurasByCombat(self)
    self:RegisterEvent('PLAYER_REGEN_ENABLED', RefreshAurasElements, true)
    self:RegisterEvent('PLAYER_REGEN_DISABLED', RefreshAurasElements, true)
end
