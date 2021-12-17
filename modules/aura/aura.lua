local F, C, L = unpack(select(2, ...))
local AURA = F:GetModule('Aura')
local oUF = F.Libs.oUF

function AURA:OnLogin()
    if not C.DB.Aura.Enable then
        return
    end

    AURA:HideBlizBuff()
    AURA:BuildBuffFrame()
end

function AURA:HideBlizBuff()
    if not C.DB.Aura.Enable and not C.DB.Auras.HideBlizFrame then
        return
    end

    F.HideObject(_G.BuffFrame)
    F.HideObject(_G.TemporaryEnchantFrame)
end

function AURA:BuildBuffFrame()
    if not C.DB.Aura.Enable then
        return
    end

    -- Config
    AURA.settings = {
        Buffs = {
            offset = 12,
            size = C.DB.Aura.BuffSize,
            wrapAfter = C.DB.Aura.BuffPerRow,
            maxWraps = 3,
            reverseGrow = C.DB.Aura.BuffReverse
        },
        Debuffs = {
            offset = 12,
            size = C.DB.Aura.DebuffSize,
            wrapAfter = C.DB.Aura.DebuffPerRow,
            maxWraps = 1,
            reverseGrow = C.DB.Aura.DebuffReverse
        }
    }

    -- Movers
    AURA.BuffFrame = AURA:CreateAuraHeader('HELPFUL')
    AURA.BuffFrame.mover = F.Mover(AURA.BuffFrame, L['Buff Frame'], 'BuffAnchor', {'TOPLEFT', _G.UIParent, 'TOPLEFT', C.UIGap, -C.UIGap})
    AURA.BuffFrame:ClearAllPoints()
    AURA.BuffFrame:SetPoint('TOPRIGHT', AURA.BuffFrame.mover)

    AURA.DebuffFrame = AURA:CreateAuraHeader('HARMFUL')
    AURA.DebuffFrame.mover = F.Mover(AURA.DebuffFrame, L['Debuff Frame'], 'DebuffAnchor', {'TOPLEFT', AURA.BuffFrame.mover, 'BOTTOMLEFT', 0, 30})
    AURA.DebuffFrame:ClearAllPoints()
    AURA.DebuffFrame:SetPoint('TOPRIGHT', AURA.DebuffFrame.mover)
end

local day, hour, minute = 86400, 3600, 60
function AURA:FormatAuraTime(s)
    if s >= day then
        return string.format('|cffbebfb3%d|r' .. C.InfoColor .. 'd', s / day), s % day
    elseif s >= hour then
        return string.format('|cff4fcd35%d|r' .. C.InfoColor .. 'h', F:Round(s / hour, 1)), s % hour
    elseif s >= 2 * hour then
        return string.format('|cff4fcd35%d|r' .. C.InfoColor .. 'h', s / hour), s % hour
    elseif s >= 10 * minute then
        return string.format('|cff21c8de%d|r' .. C.InfoColor .. 'm', s / minute), s % minute
    elseif s >= minute then
        return string.format('|cff21c8de%d:%.2d|r', s / minute, s % minute), s - math.floor(s)
    elseif s > 10 then
        return string.format('|cffffe700%d|r' .. C.InfoColor .. 's', s), s - math.floor(s)
    elseif s > 5 then
        return string.format('|cffffff00%.1f|r', s), s - string.format('%.1f', s)
    else
        return string.format('|cffff0000%.1f|r', s), s - string.format('%.1f', s)
    end
end

function AURA:UpdateTimer(elapsed)
    local onTooltip = _G.GameTooltip:IsOwned(self)

    if not (self.timeLeft or self.offset or onTooltip) then
        self:SetScript('OnUpdate', nil)
        return
    end

    if self.offset then
        local expiration = select(self.offset, GetWeaponEnchantInfo())
        if expiration then
            self.timeLeft = expiration / 1e3
        else
            self.timeLeft = 0
        end
    elseif self.timeLeft then
        self.timeLeft = self.timeLeft - elapsed
    end

    if self.nextUpdate > 0 then
        self.nextUpdate = self.nextUpdate - elapsed
        return
    end

    if self.timeLeft and self.timeLeft >= 0 then
        local timer, nextUpdate = AURA:FormatAuraTime(self.timeLeft)
        self.nextUpdate = nextUpdate
        self.timer:SetText(timer)
    end

    if onTooltip then
        AURA:Button_SetTooltip(self)
    end
end

function AURA:UpdateAuras(button, index)
    local unit, filter = button.header:GetAttribute('unit'), button.filter
    local name, texture, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)
    if not name then
        return
    end

    if duration > 0 and expirationTime then
        local timeLeft = expirationTime - GetTime()
        if not button.timeLeft then
            button.nextUpdate = -1
            button.timeLeft = timeLeft
            button:SetScript('OnUpdate', AURA.UpdateTimer)
        else
            button.timeLeft = timeLeft
        end
        button.nextUpdate = -1
        AURA.UpdateTimer(button, 0)
    else
        button.timeLeft = nil
        button.timer:SetText('')
    end

    if count and count > 1 then
        button.count:SetText(count)
    else
        button.count:SetText('')
    end

    if filter == 'HARMFUL' then
        local color = oUF.colors.debuff[debuffType or 'none']
        button:SetBackdropBorderColor(color[1], color[2], color[3])
        if button.__shadow then
            button.__shadow:SetBackdropBorderColor(color[1], color[2], color[3], .25)
        end
    else
        button:SetBackdropBorderColor(0, 0, 0)
        if button.__shadow then
            button.__shadow:SetBackdropBorderColor(0, 0, 0, .25)
        end
    end

    button.spellID = spellID
    button.icon:SetTexture(texture)
    button.offset = nil
end

function AURA:UpdateTempEnchant(button, index)
    local quality = GetInventoryItemQuality('player', index)
    button.icon:SetTexture(GetInventoryItemTexture('player', index))

    local offset = 2
    local weapon = button:GetName():sub(-1)
    if string.match(weapon, '2') then
        offset = 6
    end

    if quality then
        button:SetBackdropBorderColor(GetItemQualityColor(quality))
    end

    local expirationTime = select(offset, GetWeaponEnchantInfo())
    if expirationTime then
        button.offset = offset
        button:SetScript('OnUpdate', AURA.UpdateTimer)
        button.nextUpdate = -1
        AURA.UpdateTimer(button, 0)
    else
        button.offset = nil
        button.timeLeft = nil
        button.timer:SetText('')
    end
end

function AURA:OnAttributeChanged(attribute, value)
    if attribute == 'index' then
        AURA:UpdateAuras(self, value)
    elseif attribute == 'target-slot' then
        AURA:UpdateTempEnchant(self, value)
    end
end

function AURA:UpdateOptions()
    AURA.settings.Buffs.size = C.DB.Aura.BuffSize
    AURA.settings.Buffs.wrapAfter = C.DB.Aura.BuffPerRow
    AURA.settings.Buffs.reverseGrow = C.DB.Aura.BuffReverse
    AURA.settings.Debuffs.size = C.DB.Aura.DebuffSize
    AURA.settings.Debuffs.wrapAfter = C.DB.Aura.DebuffPerRow
    AURA.settings.Debuffs.reverseGrow = C.DB.Aura.DebuffReverse
end

function AURA:UpdateHeader(header)
    local cfg = AURA.settings.Debuffs
    if header.filter == 'HELPFUL' then
        cfg = AURA.settings.Buffs
        header:SetAttribute('consolidateTo', 0)
        header:SetAttribute('weaponTemplate', string.format('FreeUIAuraTemplate%d', cfg.size))
    end

    header:SetAttribute('separateOwn', 1)
    header:SetAttribute('sortMethod', 'INDEX')
    header:SetAttribute('sortDirection', '+')
    header:SetAttribute('wrapAfter', cfg.wrapAfter)
    header:SetAttribute('maxWraps', cfg.maxWraps)
    header:SetAttribute('point', cfg.reverseGrow and 'TOPLEFT' or 'TOPRIGHT')
    header:SetAttribute('minWidth', (cfg.size + C.DB.Aura.Margin) * cfg.wrapAfter)
    header:SetAttribute('minHeight', (cfg.size + cfg.offset) * cfg.maxWraps)
    header:SetAttribute('xOffset', (cfg.reverseGrow and 1 or -1) * (cfg.size + C.DB.Aura.Margin))
    header:SetAttribute('yOffset', 0)
    header:SetAttribute('wrapXOffset', 0)
    header:SetAttribute('wrapYOffset', -(cfg.size + cfg.offset))
    header:SetAttribute('template', string.format('FreeUIAuraTemplate%d', cfg.size))

    local fontSize = math.floor(cfg.size / 30 * 10 + .5)
    local index = 1
    local child = select(index, header:GetChildren())
    while child do
        if (math.floor(child:GetWidth() * 100 + .5) / 100) ~= cfg.size then
            child:SetSize(cfg.size, cfg.size)
        end

        child.count:SetFont(C.Assets.Fonts.Roadway, fontSize, 'OUTLINE')
        child.timer:SetFont(C.Assets.Fonts.Roadway, fontSize, 'OUTLINE')

        --Blizzard bug fix, icons arent being hidden when you reduce the amount of maximum buttons
        if index > (cfg.maxWraps * cfg.wrapAfter) and child:IsShown() then
            child:Hide()
        end

        index = index + 1
        child = select(index, header:GetChildren())
    end
end

function AURA:CreateAuraHeader(filter)
    local name = 'FreeUIPlayerDebuffs'
    if filter == 'HELPFUL' then
        name = 'FreeUIPlayerBuffs'
    end

    local header = CreateFrame('Frame', name, _G.UIParent, 'SecureAuraHeaderTemplate')
    header:SetClampedToScreen(true)
    header:SetAttribute('unit', 'player')
    header:SetAttribute('filter', filter)
    header.filter = filter
    _G.RegisterStateDriver(header, 'visibility', '[petbattle] hide; show')
    _G.RegisterAttributeDriver(header, 'unit', '[vehicleui] vehicle; player')

    if filter == 'HELPFUL' then
        header:SetAttribute('consolidateDuration', -1)
        header:SetAttribute('includeWeapons', 1)
    end

    AURA:UpdateHeader(header)
    header:Show()

    return header
end

function AURA:Button_SetTooltip(button)
    if button:GetAttribute('index') then
        _G.GameTooltip:SetUnitAura(button.header:GetAttribute('unit'), button:GetID(), button.filter)
    elseif button:GetAttribute('target-slot') then
        _G.GameTooltip:SetInventoryItem('player', button:GetID())
    end
end

function AURA:Button_OnEnter()
    _G.GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', -5, -5)
    -- Update tooltip
    self.nextUpdate = -1
    self:SetScript('OnUpdate', AURA.UpdateTimer)
end

function AURA:CreateAuraIcon(button)
    button.header = button:GetParent()
    button.filter = button.header.filter

    local cfg = AURA.settings.Debuffs
    if button.filter == 'HELPFUL' then
        cfg = AURA.settings.Buffs
    end
    local fontSize = math.floor(cfg.size / 30 * 10 + .5)

    button.icon = button:CreateTexture(nil, 'BORDER')
    button.icon:SetInside()
    button.icon:SetTexCoord(unpack(C.TexCoord))

    button.count = button:CreateFontString(nil, 'ARTWORK')
    button.count:SetPoint('CENTER', button, 'TOP')
    button.count:SetFont(C.Assets.Fonts.Roadway, fontSize, 'OUTLINE')

    button.timer = button:CreateFontString(nil, 'ARTWORK')
    button.timer:SetPoint('CENTER', button, 'BOTTOM')
    button.timer:SetFont(C.Assets.Fonts.Roadway, fontSize, 'OUTLINE')

    button.highlight = button:CreateTexture(nil, 'HIGHLIGHT')
    button.highlight:SetColorTexture(1, 1, 1, .25)
    button.highlight:SetInside()

    F.CreateBD(button, .25)
    F.CreateSD(button)

    button:RegisterForClicks('RightButtonUp')
    button:SetScript('OnAttributeChanged', AURA.OnAttributeChanged)
    button:SetScript('OnEnter', AURA.Button_OnEnter)
    button:SetScript('OnLeave', F.HideTooltip)
end
