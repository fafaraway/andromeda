local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local oUF = F.Libs.oUF

do
    function UNITFRAME.ModifierFilterAura()
        return true
    end

    function UNITFRAME:MODIFIER_STATE_CHANGED(key, state)
        if key ~= 'RALT' then
            return
        end

        for _, object in next, oUF.objects do
            local unit = object.realUnit or object.unit
            if unit == 'target' then
                local auras = object.Auras
                if state == 1 then
                    auras.FilterAura = UNITFRAME.ModifierFilterAura
                else
                    auras.FilterAura = UNITFRAME.FilterAura
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

    function UNITFRAME:UpdateAuraFilter()
        F:RegisterEvent('PLAYER_REGEN_DISABLED', UNITFRAME.MODIFIER_STATE_CHANGED)
        F:RegisterEvent('PLAYER_REGEN_ENABLED', UNITFRAME.MODIFIER_STATE_CHANGED)

        if InCombatLockdown() then
            UNITFRAME:PLAYER_REGEN_DISABLED()
        else
            UNITFRAME:PLAYER_REGEN_ENABLED()
        end
    end
end

do
    local x1, x2, y1, y2 = unpack(C.TEX_COORD)
    function UNITFRAME:UpdateIconTexCoord(width, height)
        local ratio = height / width
        local mult = (1 - ratio) / 2

        self.Icon:SetTexCoord(x1, x2, y1 + mult, y2 - mult)
    end

    function UNITFRAME.PostCreateButton(element, button)
        button.bg = F.CreateBDFrame(button, 0.25)
        button.glow = F.CreateSD(button.bg)

        button:SetFrameLevel(element:GetFrameLevel() + 4)

        button.Overlay:SetTexture(nil)
        button.Stealable:SetTexture(nil)
        button.Cooldown:SetReverse(true)
        button.Icon:SetDrawLayer('ARTWORK')

        local style = element.__owner.unitStyle
        local isGroup = style == 'party' or style == 'raid'
        local isNP = style == 'nameplate'

        if isGroup then
            button.Icon:SetTexCoord(unpack(C.TEX_COORD))
        elseif isNP then
            button.Icon:SetTexCoord(0.1, 0.9, 0.26, 0.74) -- precise texcoord for rectangular icons
        else
            button.Icon:SetTexCoord(0.1, 0.9, 0.22, 0.78) -- precise texcoord for rectangular icons
        end

        -- hooksecurefunc(button, "SetSize", UNITFRAME.UpdateIconTexCoord)

        button.HL = button:CreateTexture(nil, 'HIGHLIGHT')
        button.HL:SetColorTexture(1, 1, 1, 0.25)
        button.HL:SetAllPoints()

        local font = C.Assets.Fonts.HalfHeight
        local fontSize = max((element.width or element.size) * 0.4, 12)
        button.Count = F.CreateFS(button, font, fontSize, true, nil, nil, true)
        button.Count:ClearAllPoints()
        button.Count:SetPoint('RIGHT', button, 'TOPRIGHT')
        button.timer = F.CreateFS(button, font, fontSize, true, nil, nil, true)
        button.timer:ClearAllPoints()
        button.timer:SetPoint('LEFT', button, 'BOTTOMLEFT')
    end

    local filteredUnits = {
        ['target'] = true,
        ['nameplate'] = true,
        ['boss'] = true,
        ['arena'] = true,
    }

    UNITFRAME.ReplacedSpellIcons = {
        [368078] = 348567, -- 移速
        [368079] = 348567, -- 移速
        [368103] = 648208, -- 急速
        [368243] = 237538, -- CD
        [373785] = 236293, -- S4，大魔王伪装
    }

    local dispellType = {
        ['Magic'] = true,
        [''] = true,
    }

    function UNITFRAME.PostUpdateButton(element, button, unit, data)
        local duration = data.duration
        local expiration = data.expirationTime
        local debuffType = data.dispelName
        local isStealable = data.isStealable

        if duration then
            button.bg:Show()

            if button.glow then
                button.glow:Show()
            end
        end

        local style = element.__owner.unitStyle
        local isGroup = style == 'party' or style == 'raid'
        local isNP = style == 'nameplate'
        button:SetSize(element.size, (isGroup and element.size) or (isNP and element.size * 0.6) or element.size * 0.7)

        --[[ local squareness = .6
        element.icon_height = element.size * squareness
        element.icon_ratio = (1 - (element.icon_height / element.size)) / 2.5
        element.tex_coord = {.1,.9,.1+element.icon_ratio,.9-element.icon_ratio}
        print('element.icon_height', element.icon_height)
        print('element.icon_ratio', element.icon_ratio) ]]

        if element.desaturateDebuff and button.isHarmful and filteredUnits[style] and not data.isPlayerAura then
            button.Icon:SetDesaturated(true)
        else
            button.Icon:SetDesaturated(false)
        end

        if element.alwaysShowStealable and dispellType[debuffType] and not UnitIsPlayer(unit) and not button.isHarmful then
            button.Stealable:Show()
        end

        if isStealable then
            button.bg:SetBackdropBorderColor(1, 1, 1)

            if button.glow then
                button.glow:SetBackdropBorderColor(1, 1, 1, 0.25)
            end
        elseif element.showDebuffType and button.isHarmful then
            local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
            button.bg:SetBackdropBorderColor(color[1], color[2], color[3])

            if button.glow then
                button.glow:SetBackdropBorderColor(color[1], color[2], color[3], 0.25)
            end
        else
            button.bg:SetBackdropBorderColor(0, 0, 0)

            if button.glow then
                button.glow:SetBackdropBorderColor(0, 0, 0, 0.25)
            end
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

        local newTexture = UNITFRAME.ReplacedSpellIcons[button.spellID]
        if newTexture then
            button.Icon:SetTexture(newTexture)
        end

        if element.bolsterInstanceID and element.bolsterInstanceID == button.auraInstanceID then
            button.Count:SetText(element.bolsterStacks)
        end
    end

    function UNITFRAME.AurasPostUpdateInfo(element, _, _, debuffsChanged)
        element.bolsterStacks = 0
        element.bolsterInstanceID = nil
        element.hasTheDot = nil

        for auraInstanceID, data in next, element.allBuffs do
            if data.spellId == 209859 then
                if not element.bolsterInstanceID then
                    element.bolsterInstanceID = auraInstanceID
                    element.activeBuffs[auraInstanceID] = true
                end

                element.bolsterStacks = element.bolsterStacks + 1

                if element.bolsterStacks > 1 then
                    element.activeBuffs[auraInstanceID] = nil
                end
            end
        end

        if element.bolsterStacks > 0 then
            for i = 1, element.visibleButtons do
                local button = element[i]
                if element.bolsterInstanceID and element.bolsterInstanceID == button.auraInstanceID then
                    button.Count:SetText(element.bolsterStacks)
                    break
                end
            end
        end

        if debuffsChanged then
            element.hasTheDot = nil

            if C.DB['Nameplate']['ColorByDot'] then
                for _, data in next, element.allDebuffs do
                    if data.isPlayerAura and C.DB['Nameplate']['DotSpellsList'][data.spellId] then
                        element.hasTheDot = true
                        break
                    end
                end
            end
        end
    end

    function UNITFRAME.FilterAura(element, unit, data)
        local style = element.__owner.unitStyle
        local name = data.name
        local debuffType = data.dispelName
        local isStealable = data.isStealable
        local spellID = data.spellId
        local nameplateShowAll = data.nameplateShowAll

        if style == 'nameplate' or style == 'boss' or style == 'arena' then
            if element.__owner.plateType == 'NameOnly' then
                return NAMEPLATE.NameplateAuraWhiteList[spellID]
            elseif NAMEPLATE.NameplateAuraBlackList[spellID] then
                return false
            elseif (element.showStealableBuffs and isStealable or element.alwaysShowStealable and dispellType[debuffType]) and not UnitIsPlayer(unit) and not data.isHarmful then
                return true
            elseif NAMEPLATE.NameplateAuraWhiteList[spellID] then
                return true
            else
                local auraFilter = C.DB.Nameplate.AuraFilterMode
                return (auraFilter == 3 and nameplateShowAll) or (auraFilter ~= 1 and data.isPlayerAura)
            end
        elseif style == 'player' then
            return true
        elseif style == 'pet' then
            return true
        elseif style == 'target' then
            return isStealable or not data.isHarmful or (element.onlyShowPlayer and data.isPlayerAura) or (not element.onlyShowPlayer and name)
        else
            return (element.onlyShowPlayer and data.isPlayerAura) or (not element.onlyShowPlayer and name)
        end
    end

    function UNITFRAME.PostUpdateGapButton(_, _, button)
        if button and button:IsShown() then
            button:Hide()
        end
    end

    local function calcIconSize(width, num, size)
        return (width - (num - 1) * size) / num
    end

    function UNITFRAME:UpdateAuraContainer(parent, element, maxAuras)
        local width = parent:GetWidth()
        local iconsPerRow = element.iconsPerRow
        local maxLines = iconsPerRow and F:Round(maxAuras / iconsPerRow) or 2

        element.size = iconsPerRow and calcIconSize(width, iconsPerRow, element.spacing) or element.size
        element:SetWidth(width)
        element:SetHeight((element.size + element.spacing) * maxLines)

        local fontSize = max((element.width or element.size) * 0.4, 12)
        for i = 1, #element do
            local button = element[i]
            if button then
                if button.timer then
                    F.SetFontSize(button.timer, fontSize)
                end
                if button.Count then
                    F.SetFontSize(button.Count, fontSize)
                end
            end
        end
    end

    function UNITFRAME:ConfigureAuras(element)
        local value = element.__value

        element.iconsPerRow = C.DB['Unitframe'][value .. 'AuraPerRow']

        element.showDebuffType = C.DB.Unitframe.DebuffTypeColor
        element.desaturateDebuff = C.DB.Unitframe.DesaturateIcon
        element.onlyShowPlayer = C.DB.Unitframe.OnlyShowPlayer
        element.showStealableBuffs = C.DB.Unitframe.StealableBuffs
    end

    local function refreshAuras(frame)
        if not (frame and frame.Auras) then
            return
        end
        local element = frame.Auras
        if not element then
            return
        end

        UNITFRAME:ConfigureAuras(element)
        UNITFRAME:UpdateAuraContainer(frame, element, element.numBuffs + element.numDebuffs)

        -- if element.iconsPerRow > 0 then
        --     if not frame:IsElementEnabled('Auras') then
        --         frame:EnableElement('Auras')
        --     end
        -- else
        --     if frame:IsElementEnabled('Auras') then
        --         frame:DisableElement('Auras')
        --     end
        -- end

        element:ForceUpdate()
    end

    function UNITFRAME:RefreshAuras()
        refreshAuras(_G.oUF_Player)
        refreshAuras(_G.oUF_Pet)
        refreshAuras(_G.oUF_Target)
        refreshAuras(_G.oUF_TargetTarget)
        refreshAuras(_G.oUF_Focus)
        refreshAuras(_G.oUF_FocusTarget)

        for i = 1, 5 do
            refreshAuras(_G['oUF_Boss' .. i])
            refreshAuras(_G['oUF_Arena' .. i])
        end
    end

    function UNITFRAME:UpdateAuras()
        for _, frame in pairs(oUF.objects) do
            if C.DB.Unitframe.ShowAuras then
                if not frame:IsElementEnabled('Auras') then
                    frame:EnableElement('Auras')
                    refreshAuras(frame)
                end
            else
                if frame:IsElementEnabled('Auras') then
                    frame:DisableElement('Auras')
                end
            end
        end
    end

    function UNITFRAME:ToggleAllAuras()
        local enable = C.DB.Unitframe.ShowAuras
        UNITFRAME:ToggleAuras(_G.oUF_Player)
        UNITFRAME:ToggleAuras(_G.oUF_Pet)
        UNITFRAME:ToggleAuras(_G.oUF_Target)
        UNITFRAME:ToggleAuras(_G.oUF_TargetTarget)
        UNITFRAME:ToggleAuras(_G.oUF_Focus)
        UNITFRAME:ToggleAuras(_G.oUF_FocusTarget)
    end

    local function UpdatePlayerAuraPosition(self)
        local specIndex = GetSpecialization()

        if (C.MY_CLASS == 'ROGUE' or C.MY_CLASS == 'PALADIN' or C.MY_CLASS == 'WARLOCK' or (C.MY_CLASS == 'DRUID' and specIndex == 2) or (C.MY_CLASS == 'MONK' and specIndex == 3) or (C.MY_CLASS == 'MAGE' and specIndex == 1)) and C.DB.Unitframe.ClassPower then
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint('TOP', self.ClassPowerBar, 'BOTTOM', 0, -5)
        else
            self.Auras:ClearAllPoints()
            self.Auras:SetPoint('TOP', self.Power, 'BOTTOM', 0, -5)
        end

        self:UnregisterEvent('PLAYER_ENTERING_WORLD', UpdatePlayerAuraPosition, true)
    end

    function UNITFRAME:UpdatePlayerAuraPosition(self)
        self:RegisterEvent('PLAYER_ENTERING_WORLD', UpdatePlayerAuraPosition, true)
        self:RegisterEvent('PLAYER_TALENT_UPDATE', UpdatePlayerAuraPosition, true)
    end

    function UNITFRAME:CreateAuras(self)
        local style = self.unitStyle
        local bu = CreateFrame('Frame', nil, self)
        bu.gap = true
        bu.spacing = 5
        bu.numBuffs = 32
        bu.numDebuffs = 40
        bu.disableCooldown = true
        bu.tooltipAnchor = 'ANCHOR_TOPRIGHT'

        if style == 'player' then
            bu.initialAnchor = 'TOPLEFT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -5)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'Player'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'pet' then
            bu.initialAnchor = 'TOPLEFT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'Pet'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'target' then
            bu.initialAnchor = 'BOTTOMLEFT'
            bu:SetPoint('BOTTOM', self, 'TOP', 0, 24)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'UP'
            bu.__value = 'Target'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'targettarget' then
            bu.initialAnchor = 'TOPLEFT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'TargetTarget'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'focus' then
            bu.initialAnchor = 'TOPLEFT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'Focus'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'focustarget' then
            bu.initialAnchor = 'TOPRIGHT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
            bu['growth-x'] = 'LEFT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'FocusTarget'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'boss' then
            bu.initialAnchor = 'TOPLEFT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'Boss'
            UNITFRAME:ConfigureAuras(bu)
        elseif style == 'arena' then
            bu.initialAnchor = 'TOPLEFT'
            bu:SetPoint('TOP', self.Power, 'BOTTOM', 0, -4)
            bu['growth-x'] = 'RIGHT'
            bu['growth-y'] = 'DOWN'
            bu.__value = 'Arena'
            UNITFRAME:ConfigureAuras(bu)
        end

        UNITFRAME:UpdateAuraContainer(self, bu, bu.numTotal or bu.numBuffs + bu.numDebuffs)

        bu.FilterAura = UNITFRAME.FilterAura
        bu.PostCreateButton = UNITFRAME.PostCreateButton
        bu.PostUpdateButton = UNITFRAME.PostUpdateButton
        bu.PostUpdateGapButton = UNITFRAME.PostUpdateGapButton

        self.Auras = bu

        F:RegisterEvent('PLAYER_ENTERING_WORLD', UNITFRAME.UpdateAuraFilter)
    end

    function NAMEPLATE:CreateAuras(self)
        local bu = CreateFrame('Frame', nil, self)
        bu.gap = true
        bu.spacing = 5
        bu.numTotal = 32
        bu.initialAnchor = 'BOTTOMLEFT'
        bu:SetPoint('BOTTOM', self, 'TOP', 0, 16)
        bu['growth-x'] = 'RIGHT'
        bu['growth-y'] = 'UP'
        bu.iconsPerRow = C.DB.Nameplate.AuraPerRow
        bu.disableCooldown = true
        bu.tooltipAnchor = 'ANCHOR_BOTTOMLEFT'

        UNITFRAME:UpdateAuraContainer(self, bu, bu.numTotal)

        bu.onlyShowPlayer = C.DB.Nameplate.OnlyShowPlayer
        bu.desaturateDebuff = C.DB.Nameplate.DesaturateIcon
        bu.showDebuffType = C.DB.Nameplate.DebuffTypeColor
        bu.showStealableBuffs = C.DB.Nameplate.DispellMode == 1
        bu.alwaysShowStealable = C.DB.Nameplate.DispellMode == 2
        bu.disableMouse = true
        bu.disableCooldown = true

        bu.FilterAura = UNITFRAME.FilterAura
        bu.PostCreateButton = UNITFRAME.PostCreateButton
        bu.PostUpdateButton = UNITFRAME.PostUpdateButton
        bu.PostUpdateGapButton = UNITFRAME.PostUpdateGapButton
        bu.PostUpdateInfo = UNITFRAME.AurasPostUpdateInfo

        self.Auras = bu
    end
end




-- Debuffs on party/raid frames

do
    function UNITFRAME:AuraButton_OnEnter()
        if not self.index then
            return
        end

        _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')
        _G.GameTooltip:ClearLines()
        _G.GameTooltip:SetUnitAura(self.unit, self.index, self.filter)
        _G.GameTooltip:Show()
    end

    UNITFRAME.RaidDebuffsBlackList = {}
    function UNITFRAME:UpdateRaidDebuffsBlackList()
        wipe(UNITFRAME.RaidDebuffsBlackList)

        for spellID in pairs(C.RaidDebuffsBlackList) do
            local name = GetSpellInfo(spellID)
            if name then
                if _G.ANDROMEDA_ADB['RaidDebuffsBlackList'][spellID] == nil then
                    UNITFRAME.RaidDebuffsBlackList[spellID] = true
                end
            end
        end

        for spellID, value in pairs(_G.ANDROMEDA_ADB['RaidDebuffsBlackList']) do
            if value then
                UNITFRAME.RaidDebuffsBlackList[spellID] = true
            end
        end
    end

    function UNITFRAME:CreateDebuffsIndicator(self)
        local debuffFrame = CreateFrame('Frame', nil, self)
        debuffFrame:SetSize(1, 1)
        debuffFrame:SetPoint('BOTTOMRIGHT', -2, 2)

        debuffFrame.buttons = {}
        local prevDebuff
        for i = 1, 3 do
            local button = CreateFrame('Frame', nil, debuffFrame)
            F.PixelIcon(button)
            button:SetScript('OnEnter', UNITFRAME.AuraButton_OnEnter)
            button:SetScript('OnLeave', F.HideTooltip)
            button:Hide()

            local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
            cd:SetAllPoints()
            cd:SetReverse(true)
            button.cd = cd

            local parentFrame = CreateFrame('Frame', nil, button)
            parentFrame:SetAllPoints()
            parentFrame:SetFrameLevel(button:GetFrameLevel() + 6)

            button.count = F.CreateFS(parentFrame, C.Assets.Fonts.Small, 11, true, nil, nil, true)
            button.count:ClearAllPoints()
            button.count:SetPoint('RIGHT', parentFrame, 'TOPRIGHT')

            button.cd = CreateFrame('Cooldown', nil, button, 'CooldownFrameTemplate')
            button.cd:SetAllPoints()
            button.cd:SetReverse(true)
            button.cd:SetHideCountdownNumbers(true)

            if not prevDebuff then
                button:SetPoint('BOTTOMLEFT', self.Health)
            else
                button:SetPoint('LEFT', prevDebuff, 'RIGHT')
            end
            prevDebuff = button
            debuffFrame.buttons[i] = button
        end

        self.DebuffsIndicator = debuffFrame

        UNITFRAME.DebuffsIndicator_UpdateOptions(self)
    end

    function UNITFRAME:DebuffsIndicator_UpdateButton(debuffIndex, aura)
        local button = self.DebuffsIndicator.buttons[debuffIndex]
        if not button then
            return
        end

        button.unit, button.index, button.filter = aura.unit, aura.index, aura.filter
        if button.cd then
            if aura.duration and aura.duration > 0 then
                button.cd:SetCooldown(aura.expiration - aura.duration, aura.duration)
                button.cd:Show()
            else
                button.cd:Hide()
            end
        end

        if button.bg then
            if aura.isDebuff then
                local color = oUF.colors.debuff[aura.debuffType] or oUF.colors.debuff.none
                button.bg:SetBackdropBorderColor(color[1], color[2], color[3])
            else
                button.bg:SetBackdropBorderColor(0, 0, 0)
            end
        end

        if button.Icon then
            button.Icon:SetTexture(aura.texture)
        end
        if button.count then
            button.count:SetText(aura.count > 1 and aura.count or '')
        end

        button:Show()
    end

    function UNITFRAME:DebuffsIndicator_HideButtons(from, to)
        for i = from, to do
            local button = self.DebuffsIndicator.buttons[i]
            if button then
                button:Hide()
            end
        end
    end

    function UNITFRAME.DebuffsIndicator_Filter(raidAuras, aura)
        local spellID = aura.spellID
        if UNITFRAME.RaidDebuffsBlackList[spellID] then
            return false
        elseif aura.isBossAura or SpellIsPriorityAura(spellID) then
            return true
        else
            local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, raidAuras.isInCombat and 'RAID_INCOMBAT' or 'RAID_OUTOFCOMBAT')
            if hasCustom then
                return showForMySpec or (alwaysShowMine and aura.isPlayerAura)
            else
                return true
            end
        end
    end

    function UNITFRAME:DebuffsIndicator_UpdateOptions()
        local debuffs = self.DebuffsIndicator
        if not debuffs then
            return
        end

        debuffs.enable = C.DB.Unitframe.ShowRaidDebuff
        local size = C.DB.Unitframe.RaidDebuffSize
        local scale = C.DB.Unitframe.RaidDebuffScale
        local disableMouse = C.DB.Unitframe.RaidDebuffClickThru

        for i = 1, 3 do
            local button = debuffs.buttons[i]
            if button then
                button:SetSize(size, size)
                button:SetScale(scale)
                button:EnableMouse(not disableMouse)
            end
        end
    end
end

-- Buffs on party/raid frames

do
    UNITFRAME.RaidBuffsWhiteList = {}
    function UNITFRAME:UpdateRaidBuffsWhiteList()
        wipe(UNITFRAME.RaidBuffsWhiteList)

        for spellID in pairs(C.RaidBuffsWhiteList) do
            local name = GetSpellInfo(spellID)
            if name then
                if _G.ANDROMEDA_ADB['RaidBuffsWhiteList'][spellID] == nil then
                    UNITFRAME.RaidBuffsWhiteList[spellID] = true
                end
            end
        end

        for spellID, value in pairs(_G.ANDROMEDA_ADB['RaidBuffsWhiteList']) do
            if value then
                UNITFRAME.RaidBuffsWhiteList[spellID] = true
            end
        end
    end

    function UNITFRAME:CreateBuffsIndicator(self)
        local buffFrame = CreateFrame('Frame', nil, self)
        buffFrame:SetSize(1, 1)
        buffFrame:SetPoint('LEFT', self, 'RIGHT', 5, 0)
        buffFrame:SetFrameLevel(5)

        buffFrame.buttons = {}
        local prevBuff
        for i = 1, 3 do
            local button = CreateFrame('Frame', nil, buffFrame)
            F.PixelIcon(button, nil, nil, true)
            button:SetScript('OnEnter', UNITFRAME.AuraButton_OnEnter)
            button:SetScript('OnLeave', F.HideTooltip)
            button:Hide()

            local parentFrame = CreateFrame('Frame', nil, button)
            parentFrame:SetAllPoints()
            parentFrame:SetFrameLevel(button:GetFrameLevel() + 3)

            button.count = F.CreateFS(parentFrame, C.Assets.Fonts.Small, 11, true, nil, nil, true)
            button.count:ClearAllPoints()
            button.count:SetPoint('RIGHT', parentFrame, 'TOPRIGHT')

            button.cd = CreateFrame('Cooldown', nil, button, 'CooldownFrameTemplate')
            button.cd:SetAllPoints()
            button.cd:SetReverse(true)
            button.cd:SetHideCountdownNumbers(true)

            if not prevBuff then
                button:SetPoint('LEFT', self, 'RIGHT', 5, 0)
            else
                button:SetPoint('LEFT', prevBuff, 'RIGHT', 3, 0)
            end
            prevBuff = button
            buffFrame.buttons[i] = button
        end

        self.BuffsIndicator = buffFrame

        UNITFRAME.BuffsIndicator_UpdateOptions(self)
    end

    function UNITFRAME:BuffsIndicator_UpdateButton(buffIndex, aura)
        local button = self.BuffsIndicator.buttons[buffIndex]
        if not button then
            return
        end

        button.unit, button.index, button.filter = aura.unit, aura.index, aura.filter
        if button.cd then
            if aura.duration and aura.duration > 0 then
                button.cd:SetCooldown(aura.expiration - aura.duration, aura.duration)
                button.cd:Show()
            else
                button.cd:Hide()
            end
        end

        if button.Icon then
            button.Icon:SetTexture(aura.texture)
        end
        if button.count then
            button.count:SetText(aura.count > 1 and aura.count or '')
        end

        button:Show()
    end

    function UNITFRAME:BuffsIndicator_HideButtons(from, to)
        for i = from, to do
            local button = self.BuffsIndicator.buttons[i]
            if button then
                button:Hide()
            end
        end
    end

    function UNITFRAME.BuffsIndicator_Filter(raidAuras, aura)
        local spellID = aura.spellID
        if aura.isBossAura then
            return true
        elseif C.DB.Unitframe.RaidBuffAuto then
            local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, raidAuras.isInCombat and 'RAID_INCOMBAT' or 'RAID_OUTOFCOMBAT')
            if hasCustom then
                return showForMySpec or (alwaysShowMine and aura.isPlayerAura)
            else
                return aura.isPlayerAura and aura.canApply and not SpellIsSelfBuff(spellID)
            end
        else
            return UNITFRAME.RaidBuffsWhiteList[spellID]
        end
    end

    function UNITFRAME:BuffsIndicator_UpdateOptions()
        local buffs = self.BuffsIndicator
        if not buffs then
            return
        end

        buffs.enable = C.DB.Unitframe.ShowRaidBuff
        local size = (C.DB.Unitframe.PartyHealthHeight + C.DB.Unitframe.PartyPowerHeight) * 0.85
        local scale = C.DB.Unitframe.RaidBuffScale
        local disableMouse = C.DB.Unitframe.BuffClickThru

        for i = 1, 3 do
            local button = buffs.buttons[i]
            if button then
                button:SetSize(size, size)
                button:SetScale(scale)
                button:EnableMouse(not disableMouse)
            end
        end
    end
end
