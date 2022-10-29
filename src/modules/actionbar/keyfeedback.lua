local F, C, L = unpack(select(2, ...))
-- local ACTIONBAR = F:GetModule('ActionBar')

local keyFeedback = CreateFrame('Frame', C.ADDON_TITLE .. 'KeyFeedback', _G.UIParent)
keyFeedback:SetScript('OnEvent', function(self, event, ...)
    return self[event](self, event, ...)
end)

keyFeedback:RegisterEvent('PLAYER_LOGIN')

local settings = {
    point = 'CENTER',
    x = 0,
    y = 0,
    enableCastLine = true,
    enableCooldown = true,
    enablePushEffect = true,
    enableCast = true,
    enableCastFlash = true,
    lineIconSize = 28,
    mirrorSize = 32,
    lineDirection = 'LEFT',
    forceUseActionHook = false,
}

function keyFeedback:PLAYER_LOGIN()
    if not C.DB.Actionbar.KeyFeedback then
        return
    end

    self.db = settings

    if self.db.forceUseActionHook then
        self.mirror = self:CreateFeedbackButton(true)
        self:HookUseAction()
    else
        self.mirror = self:CreateFeedbackButton()
        self:HookDefaultBindings()
    end

    local GetActionSpellID = function(action)
        local actionType, id = GetActionInfo(action)
        if actionType == 'spell' then
            return id
        elseif actionType == 'macro' then
            return GetMacroSpell(id)
        end
    end

    self.mirror.UpdateAction = function(self, fullUpdate)
        local action = self.action
        if not action then
            return
        end

        local tex = GetActionTexture(action)
        if not tex then
            return
        end
        self.icon:SetTexture(tex)
        self.icon:SetTexCoord(unpack(C.TEX_COORD))

        if fullUpdate then
            self:UpdateCooldownOrCast()
        end
    end

    self.mirror.UpdateCooldownOrCast = function(self)
        local action = self.action
        if not action then
            return
        end

        local cooldownStartTime, cooldownDuration, enable, modRate = GetActionCooldown(action)

        local cooldownFrame = self.cooldown
        local castDuration = self.castDuration or 0

        if keyFeedback.db.enableCast and self.castSpellID and self.castSpellID == GetActionSpellID(action) and castDuration > cooldownDuration then
            cooldownFrame:SetDrawEdge(true)
            cooldownFrame:SetReverse(self.castInverted)
            CooldownFrame_Set(cooldownFrame, self.castStartTime, castDuration, true, true, 1)
        elseif keyFeedback.db.enableCooldown then
            cooldownFrame:SetDrawEdge(false)
            cooldownFrame:SetReverse(false)
            CooldownFrame_Set(cooldownFrame, cooldownStartTime, cooldownDuration, enable, false, modRate)
        else
            cooldownFrame:Hide()
        end
    end

    self:SetSize(30, 30)

    local mover = F.Mover(self, L['SpellFeedback'], 'SpellFeedback', { 'CENTER', _G.UIParent, 0, -300 }, settings.mirrorSize, settings.mirrorSize)
    self:ClearAllPoints()
    self:SetPoint('CENTER', mover)

    self:RefreshSettings()
end

function keyFeedback.UNIT_SPELLCAST_START(self, _, unit, _, spellID)
    local _, _, _, startTime, endTime, _, castID, _ = UnitCastingInfo(unit)
    if not startTime then
        return
    end -- With heavy lags it's nil sometimes
    local mirror = self.mirror
    mirror.castInverted = false
    mirror.castID = castID
    mirror.castSpellID = spellID
    mirror.castStartTime = startTime / 1000
    mirror.castDuration = (endTime - startTime) / 1000
    mirror:BumpFadeOut(mirror.castDuration)
    mirror:UpdateCooldownOrCast()
    -- self:UpdateCastingInfo(name,texture,startTime,endTime)
end

keyFeedback.UNIT_SPELLCAST_DELAYED = keyFeedback.UNIT_SPELLCAST_START

function keyFeedback.UNIT_SPELLCAST_CHANNEL_START(self, _, unit, _, spellID)
    local _, _, _, startTime, endTime, _, castID, _ = UnitChannelInfo(unit)
    local mirror = self.mirror
    mirror.castInverted = true
    mirror.castID = castID
    mirror.castSpellID = spellID
    mirror.castStartTime = startTime / 1000
    mirror.castDuration = (endTime - startTime) / 1000
    mirror:BumpFadeOut(mirror.castDuration)
    mirror:UpdateCooldownOrCast()
    -- self:UpdateCastingInfo(name,texture,startTime,endTime)
end

keyFeedback.UNIT_SPELLCAST_CHANNEL_UPDATE = keyFeedback.UNIT_SPELLCAST_CHANNEL_START

function keyFeedback.UNIT_SPELLCAST_STOP(self, _, _, _, _)
    local mirror = self.mirror
    mirror.castSpellID = nil
    mirror.castDuration = nil
    mirror:UpdateCooldownOrCast()
end

function keyFeedback.UNIT_SPELLCAST_FAILED(self, event, unit, castID)
    if self.mirror.castID == castID then
        keyFeedback.UNIT_SPELLCAST_STOP(self, event, unit, nil)
    end
end

keyFeedback.UNIT_SPELLCAST_INTERRUPTED = keyFeedback.UNIT_SPELLCAST_STOP
keyFeedback.UNIT_SPELLCAST_CHANNEL_STOP = keyFeedback.UNIT_SPELLCAST_STOP

function keyFeedback:SPELL_UPDATE_COOLDOWN()
    self.mirror:UpdateAction(true)
end

local MirrorActionButtonDown = function(action)
    if not HasAction(action) then
        return
    end
    if C_PetBattles.IsInBattle() then
        return
    end

    local mirror = keyFeedback.mirror

    if mirror.action ~= action then
        mirror.action = action
        mirror:UpdateAction(true)
    else
        mirror:UpdateAction()
    end

    mirror:Show()
    mirror._elapsed = 0
    mirror:SetAlpha(1)
    mirror:BumpFadeOut()
    mirror.pushed = true
    if mirror:GetButtonState() == 'NORMAL' then
        if mirror.pushedCircle then
            if mirror.pushedCircle.grow:IsPlaying() then
                mirror.pushedCircle.grow:Stop()
            end
            mirror.pushedCircle:Show()
            mirror.pushedCircle.grow:Play()
        end
        mirror:SetButtonState('PUSHED')
    end
end

local MirrorActionButtonUp = function()
    local mirror = keyFeedback.mirror

    if mirror:GetButtonState() == 'PUSHED' then
        mirror:SetButtonState('NORMAL')
    end
end

function keyFeedback:HookDefaultBindings()
    local GetActionButtonForID = _G.GetActionButtonForID
    hooksecurefunc('ActionButtonDown', function(id)
        local button = GetActionButtonForID(id)
        if button then
            return MirrorActionButtonDown(button.action)
        end
    end)
    hooksecurefunc('ActionButtonUp', MirrorActionButtonUp)
    hooksecurefunc('MultiActionButtonDown', function(bar, id)
        local button = _G[bar .. 'Button' .. id]
        return MirrorActionButtonDown(button.action)
    end)
    hooksecurefunc('MultiActionButtonUp', MirrorActionButtonUp)
end

function keyFeedback:HookUseAction()
    hooksecurefunc('UseAction', function(action)
        return MirrorActionButtonDown(action)
    end)
end

function keyFeedback:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellID)
    if IsPlayerSpell(spellID) then
        if spellID == 75 then
            return
        end -- Autoshot

        if self.db.enableCastLine then
            local frame = self.iconPool:Acquire()
            local texture = select(3, GetSpellInfo(spellID))
            frame.icon:SetTexture(texture)
            frame.icon:SetTexCoord(unpack(C.TEX_COORD))
            frame:Show()
            frame.ag:Play()
        end

        if self.db.enableCastFlash then
            self.mirror.glow:Show()
            self.mirror.glow.blink:Play()
        end
    end
end

function keyFeedback:RefreshSettings()
    local db = self.db
    self.mirror:SetSize(db.mirrorSize, db.mirrorSize)

    self:RegisterUnitEvent('UNIT_SPELLCAST_SUCCEEDED', 'player')
    if db.enableCastLine then
        if not self.iconPool then
            self.iconPool = self:CreateLastSpellIconLine(self.mirror)
        end

        local pool = self.iconPool
        pool:ReleaseAll()
        for _, f in pool:EnumerateInactive() do
            -- f:SetHeight(db.lineIconSize)
            -- f:SetWidth(db.lineIconSize)
            pool:resetterFunc(f)
        end
    end

    if db.enableCooldown then
        self:RegisterEvent('SPELL_UPDATE_COOLDOWN')
    else
        self:UnregisterEvent('SPELL_UPDATE_COOLDOWN')
    end

    if db.enableCast then
        self:RegisterUnitEvent('UNIT_SPELLCAST_START', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_DELAYED', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_STOP', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_FAILED', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', 'player')
        self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_STOP', 'player')
    else
        self:UnregisterEvent('UNIT_SPELLCAST_START')
        self:UnregisterEvent('UNIT_SPELLCAST_DELAYED')
        self:UnregisterEvent('UNIT_SPELLCAST_STOP')
        self:UnregisterEvent('UNIT_SPELLCAST_FAILED')
        self:UnregisterEvent('UNIT_SPELLCAST_INTERRUPTED')
        self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_START')
        self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_UPDATE')
        self:UnregisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
    end
end

local function MakeCompatibleAnimation(anim)
    if anim:GetObjectType() == 'Scale' and anim.SetScaleFrom then
        return anim
    else
        anim.SetScaleFrom = anim.SetFromScale
        anim.SetScaleTo = anim.SetToScale
    end
end

function keyFeedback:CreateFeedbackButton(autoKeyup)
    local db = self.db

    local mirror = CreateFrame('Button', C.ADDON_TITLE .. 'KeyFeedbackMirror', self, 'ActionButtonTemplate')
    mirror:SetHeight(db.mirrorSize)
    mirror:SetWidth(db.mirrorSize)
    mirror.NormalTexture:ClearAllPoints()
    -- mirror.NormalTexture:SetPoint('TOPLEFT', -15, 15)
    -- mirror.NormalTexture:SetPoint('BOTTOMRIGHT', 15, -15)

    --F.StripTextures(mirror)
    local bg = F.CreateBDFrame(mirror)
    bg:SetBackdropBorderColor(0, 0, 0)
    F.CreateSD(bg)

    if mirror.SetPushedTexture then
        mirror:SetPushedTexture(0)
    end

    mirror.cooldown:SetEdgeTexture('Interface\\Cooldown\\edge')
    mirror.cooldown:SetSwipeColor(0, 0, 0)
    mirror.cooldown:SetHideCountdownNumbers(false)

    mirror:Show()
    mirror._elapsed = 0

    local glow = CreateFrame('Frame', nil, mirror)
    glow:SetPoint('TOPLEFT', -16, 16)
    glow:SetPoint('BOTTOMRIGHT', 16, -16)
    local gtex = glow:CreateTexture(nil, 'OVERLAY')
    gtex:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    gtex:SetTexCoord(0, 66 / 128, 136 / 256, 202 / 256)
    gtex:SetVertexColor(0, 1, 0)
    gtex:SetAllPoints(glow)
    mirror.glow = glow
    glow:Hide()

    local ag = glow:CreateAnimationGroup()
    glow.blink = ag

    -- local a1 = ag:CreateAnimation("Alpha")
    -- a1:SetFromAlpha(0)
    -- a1:SetToAlpha(1)
    -- a1:SetDuration(0.14)
    -- a1:SetOrder(1)

    local a2 = ag:CreateAnimation('Alpha')
    a2:SetFromAlpha(1)
    a2:SetToAlpha(0)
    a2:SetSmoothing('OUT')
    a2:SetDuration(0.3)
    a2:SetOrder(2)

    ag:SetScript('OnFinished', function(self)
        self:GetParent():Hide()
    end)

    if db.enablePushEffect then
        local pushedCircle = CreateFrame('Frame', nil, mirror)
        local size = db.mirrorSize
        pushedCircle:SetSize(size, size)
        pushedCircle:SetPoint('CENTER', 0, 0)
        local pctex = pushedCircle:CreateTexture(nil, 'OVERLAY')
        pctex:SetTexture(C.Assets.Textures.ButtonPushed)
        pctex:SetBlendMode('ADD')
        pctex:SetAllPoints(pushedCircle)
        mirror.pushedCircle = pushedCircle
        pushedCircle:Hide()

        local gag = pushedCircle:CreateAnimationGroup()
        pushedCircle.grow = gag

        local ga1 = MakeCompatibleAnimation(gag:CreateAnimation('Scale'))
        ga1:SetScaleFrom(0.1, 0.1)
        ga1:SetScaleTo(1.3, 1.3)
        ga1:SetDuration(0.3)
        ga1:SetOrder(2)

        local ga2 = gag:CreateAnimation('Alpha')
        ga2:SetFromAlpha(0.5)
        ga2:SetToAlpha(0)
        -- ga2:SetSmoothing("OUT")
        ga2:SetDuration(0.2)
        ga2:SetStartDelay(0.1)
        ga2:SetOrder(2)

        gag:SetScript('OnFinished', function(self)
            self:GetParent():Hide()
        end)
    end

    mirror.BumpFadeOut = function(self, modifier)
        modifier = modifier or 1.5
        if -modifier < self._elapsed then
            self._elapsed = -modifier
        end
    end

    if autoKeyup then
        mirror:SetScript('OnUpdate', function(self, elapsed)
            self._elapsed = self._elapsed + elapsed

            local timePassed = self._elapsed

            if timePassed >= 0.1 and self.pushed then
                mirror:SetButtonState('NORMAL')
                self.pushed = false
            end

            if timePassed >= 1 then
                local alpha = 2 - timePassed
                if alpha <= 0 then
                    alpha = 0
                    self:Hide()
                end
                self:SetAlpha(alpha)
            end
        end)
    else
        mirror:SetScript('OnUpdate', function(self, elapsed)
            self._elapsed = self._elapsed + elapsed

            local timePassed = self._elapsed
            if timePassed >= 1 then
                local alpha = 2 - timePassed
                if alpha <= 0 then
                    alpha = 0
                    self:Hide()
                end
                self:SetAlpha(alpha)
            end
        end)
    end

    mirror:EnableMouse(false)

    mirror:SetPoint('CENTER', self, 'CENTER')

    mirror:Hide()

    return mirror
end

local PoolIconCreationFunc = function(pool)
    local db = keyFeedback.db

    local hdr = pool.parent
    local id = pool.idCounter
    pool.idCounter = pool.idCounter + 1
    local f = CreateFrame('Button', C.ADDON_TITLE .. 'KeyFeedbackPoolIcon' .. id, hdr, 'ActionButtonTemplate')

    F.StripTextures(f)
    local bg = F.CreateBDFrame(f)
    bg:SetBackdropBorderColor(0, 0, 0)
    F.CreateSD(bg)

    f:EnableMouse(false)
    f:SetHeight(db.lineIconSize)
    f:SetWidth(db.lineIconSize)
    f:SetPoint('BOTTOM', hdr, 'BOTTOM', 0, -0)

    local t = f.icon
    f:SetAlpha(0)

    t:SetTexture('Interface\\Icons\\Spell_Shadow_SacrificialShield')
    t:SetTexCoord(unpack(C.TEX_COORD))

    local ag = f:CreateAnimationGroup()
    f.ag = ag

    local scaleOrigin = 'RIGHT'
    local translateX = -100
    local translateY = 0

    local s1 = MakeCompatibleAnimation(ag:CreateAnimation('Scale'))
    s1:SetScale(0.01, 1)
    s1:SetDuration(0)
    s1:SetOrigin(scaleOrigin, 0, 0)
    s1:SetOrder(1)

    local s2 = MakeCompatibleAnimation(ag:CreateAnimation('Scale'))
    s2:SetScale(100, 1)
    s2:SetDuration(0.5)
    s2:SetOrigin(scaleOrigin, 0, 0)
    s2:SetSmoothing('OUT')
    s2:SetOrder(2)

    local a1 = ag:CreateAnimation('Alpha')
    a1:SetFromAlpha(0)
    a1:SetToAlpha(1)
    a1:SetDuration(0.1)
    a1:SetOrder(2)

    local t1 = ag:CreateAnimation('Translation')
    t1:SetOffset(translateX, translateY)
    t1:SetDuration(1.2)
    t1:SetSmoothing('IN')
    t1:SetOrder(2)

    local a2 = ag:CreateAnimation('Alpha')
    a2:SetFromAlpha(1)
    a2:SetToAlpha(0)
    a2:SetSmoothing('OUT')
    a2:SetDuration(0.5)
    a2:SetStartDelay(0.6)
    a2:SetOrder(2)

    ag.s1 = s1
    ag.s2 = s2
    ag.t1 = t1

    ag:SetScript('OnFinished', function(self)
        local icon = self:GetParent()
        icon:Hide()
        pool:Release(icon)
    end)

    return f
end

local function PoolIconResetterFunc(pool, f)
    local db = keyFeedback.db

    f:SetHeight(db.lineIconSize)
    f:SetWidth(db.lineIconSize)

    f.ag:Stop()

    local scaleOrigin, revOrigin, translateX, translateY
    -- local sx1, sx2, sy1, sy2
    if db.lineDirection == 'RIGHT' then
        scaleOrigin = 'LEFT'
        revOrigin = 'RIGHT'
        -- sx1, sx2, sy1, sy2 = 0.01, 100, 1, 1
        translateX = 100
        translateY = 0
    elseif db.lineDirection == 'TOP' then
        scaleOrigin = 'BOTTOM'
        revOrigin = 'TOP'
        -- sx1, sx2, sy1, sy2 = 1,1, 0.01, 100
        translateX = 0
        translateY = 100
    elseif db.lineDirection == 'BOTTOM' then
        scaleOrigin = 'TOP'
        revOrigin = 'BOTTOM'
        -- sx1, sx2, sy1, sy2 = 1,1, 0.01, 100
        translateX = 0
        translateY = -100
    else
        scaleOrigin = 'RIGHT'
        revOrigin = 'LEFT'
        -- sx1, sx2, sy1, sy2 = 0.01, 100, 1, 1
        translateX = -100
        translateY = 0
    end
    local ag = f.ag
    -- ag.s1:SetScale(sx1, sy1)
    ag.s1:SetOrigin(scaleOrigin, 0, 0)

    -- ag.s1:SetScale(sx2, sy2)
    ag.s2:SetOrigin(scaleOrigin, 0, 0)
    ag.t1:SetOffset(translateX, translateY)

    f:ClearAllPoints()
    local parent = pool.parent
    f:SetPoint(scaleOrigin, parent, revOrigin, 0, 0)
end

function keyFeedback:CreateLastSpellIconLine(parent)
    local template = nil
    local resetterFunc = PoolIconResetterFunc
    local iconPool = CreateFramePool('Frame', parent, template, resetterFunc)
    iconPool.creationFunc = PoolIconCreationFunc
    iconPool.resetterFunc = PoolIconResetterFunc
    iconPool.idCounter = 1

    return iconPool
end
