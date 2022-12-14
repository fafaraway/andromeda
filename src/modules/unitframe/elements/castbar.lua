local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local LBG = F.Libs.LibButtonGlow

local function createBarMover(bar, text, value, anchor)
    local mover = F.Mover(bar, text, value, anchor, bar:GetHeight() + bar:GetWidth() + 3, bar:GetHeight() + 3)
    bar:ClearAllPoints()
    bar:SetPoint('CENTER', mover)
    bar.mover = mover
end

local channelingTicks = {
    [740] = 4, -- 宁静
    [755] = 5, -- 生命通道
    [5143] = 4, -- 奥术飞弹
    [12051] = 6, -- 唤醒
    [15407] = 6, -- 精神鞭笞
    [47757] = 3, -- 苦修
    [47758] = 3, -- 苦修
    [48045] = 6, -- 精神灼烧
    [64843] = 4, -- 神圣赞美诗
    [120360] = 15, -- 弹幕射击
    [198013] = 10, -- 眼棱
    [198590] = 5, -- 吸取灵魂
    [205021] = 5, -- 冰霜射线
    [205065] = 6, -- 虚空洪流
    [206931] = 3, -- 饮血者
    [212084] = 10, -- 邪能毁灭
    [234153] = 5, -- 吸取生命
    [257044] = 7, -- 急速射击
    [291944] = 6, -- 再生，赞达拉巨魔
    [314791] = 4, -- 变易幻能
    [324631] = 8, -- 血肉铸造，盟约
    [356995] = 3, -- 裂解，龙希尔
}

if C.MY_CLASS == 'PRIEST' then
    local function updateTicks()
        local numTicks = 3
        if IsPlayerSpell(193134) then
            numTicks = 4
        end
        channelingTicks[47757] = numTicks
        channelingTicks[47758] = numTicks
    end
    F:RegisterEvent('PLAYER_LOGIN', updateTicks)
    F:RegisterEvent('PLAYER_TALENT_UPDATE', updateTicks)
end

function UNITFRAME:OnCastbarUpdate(elapsed)
    if self.casting or self.channeling or self.empowering then
        local isCasting = self.casting or self.empowering
        local decimal = self.Decimal

        local duration = isCasting and (self.duration + elapsed) or (self.duration - elapsed)
        if (isCasting and duration >= self.max) or (self.channeling and duration <= 0) then
            self.casting = nil
            self.channeling = nil
            self.empowering = nil
            return
        end

        if self.Time then
            if self.__owner.unit == 'player' then
                self.Time:SetFormattedText(decimal, self.max - duration)
            else
                if duration > 1e4 then
                    self.Time:SetText('∞')
                else
                    self.Time:SetFormattedText(decimal, self.max - duration)
                end
            end
        end

        self.duration = duration
        self:SetValue(duration)
        self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)

        if self.stageString then
            self.stageString:SetText('')

            if self.empowering then
                for i = 1, self.numStages, 1 do
                    if duration > self.castTicks[i].duration then
                        self.stageString:SetText(i)
                    end
                end
            end
        end
    elseif self.holdTime > 0 then
        self.holdTime = self.holdTime - elapsed
    else
        self.Spark:Hide()

        local alpha = self:GetAlpha() - 0.02
        if alpha > 0 then
            self:SetAlpha(alpha)
        else
            self.fadeOut = nil
            self:Hide()
        end
    end
end

function UNITFRAME:OnCastSent()
    local element = self.Castbar

    if not element.SafeZone then
        return
    end

    element.__sendTime = GetTime()
end

local function ResetSpellTarget(self)
    if self.spellTarget then
        self.spellTarget:SetText('')
    end
end

function UNITFRAME:CreateAndUpdateStagePip(bar, ticks, numStages, unit)
    for i = 1, #ticks do
        ticks[i]:Hide()
        ticks[i].duration = 0
    end

    if numStages == 0 then
        return
    end

    local width, height = bar:GetSize()
    local sumDuration = 0
    local stageMaxValue = bar.max * 1000
    for i = 1, numStages, 1 do
        local duration = GetUnitEmpowerStageDuration(unit, i - 1)
        if duration > -1 then
            sumDuration = sumDuration + duration
            local portion = sumDuration / stageMaxValue
            if not ticks[i] then
                ticks[i] = bar:CreateTexture(nil, 'OVERLAY')
                ticks[i]:SetTexture(C.Assets.Textures.StatusbarNormal)
                ticks[i]:SetVertexColor(0, 0, 0)
                ticks[i]:SetWidth(C.MULT)
                ticks[i]:SetHeight(height)
            end
            ticks[i].duration = sumDuration / 1000
            ticks[i]:ClearAllPoints()
            ticks[i]:SetPoint('LEFT', bar, width * portion, 0)
            ticks[i]:Show()
        end
    end
end

function UNITFRAME:PostCastStart(unit)
    local style = self.__owner.unitStyle
    local compact = not C.DB.Unitframe.SeparateCastbar
    local npCompact = not C.DB.Nameplate.SeparateCastbar
    local normalColor = C.DB.Unitframe.CastingColor
    local uninterruptibleColor = C.DB.Unitframe.UninterruptibleColor
    local color = self.notInterruptible and uninterruptibleColor or normalColor

    self:SetAlpha(1)
    self.Spark:Show()

    local safeZone = self.SafeZone
    if unit == 'vehicle' or UnitInVehicle('player') then
        if safeZone then
            safeZone:Hide()
        end
    elseif unit == 'player' then
        if safeZone then
            local sendTime = self.__sendTime
            local timeDiff = sendTime and min((GetTime() - sendTime), self.max)
            if timeDiff and timeDiff ~= 0 then
                safeZone:SetWidth(self:GetWidth() * timeDiff / self.max)
                safeZone:Show()
            else
                safeZone:Hide()
            end
            self.__sendTime = nil
        end

        local numTicks = 0
        if self.channeling then
            numTicks = channelingTicks[self.spellID] or 0
        end
        F:CreateAndUpdateBarTicks(self, self.castTicks, numTicks)

        if not self.channeling then
            UNITFRAME:CreateAndUpdateStagePip(self, self.castTicks, self.numStages or 0, unit)
        end
    end

    if (style == 'nameplate' and npCompact) or (style ~= 'nameplate' and compact) then
        self:SetStatusBarColor(color.r, color.g, color.b, 0.6)
        self.Backdrop:SetBackdropColor(0, 0, 0, 0.2)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 0)
        self.Border:SetBackdropBorderColor(color.r, color.g, color.b, 0.6)
    else
        self:SetStatusBarColor(color.r, color.g, color.b, 1)
        self.Backdrop:SetBackdropColor(0, 0, 0, 0.45)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 1)
        self.Border:SetBackdropBorderColor(0, 0, 0, 0.35)
    end

    if style == 'nameplate' then
        -- Major spells glow
        if C.DB.Nameplate.MajorSpellsGlow and NAMEPLATE.MajorSpellsList[self.spellID] then
            LBG.ShowOverlayGlow(self.glowFrame)
        else
            LBG.HideOverlayGlow(self.glowFrame)
        end
    end
end

function UNITFRAME:PostUpdateInterruptible()
    local style = self.__owner.unitStyle
    local npCompact = not C.DB.Nameplate.SeparateCastbar
    local compact = not C.DB.Unitframe.SeparateCastbar
    local normalColor = C.DB.Unitframe.CastingColor
    local uninterruptibleColor = C.DB.Unitframe.UninterruptibleColor
    local color = self.notInterruptible and uninterruptibleColor or normalColor

    if (style == 'nameplate' and npCompact) or (style ~= 'nameplate' and compact) then
        self:SetStatusBarColor(color.r, color.g, color.b, 0.6)
        self.Backdrop:SetBackdropColor(0, 0, 0, 0.2)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 0)
        self.Border:SetBackdropBorderColor(color.r, color.g, color.b, 0.6)
    else
        self:SetStatusBarColor(color.r, color.g, color.b, 1)
        self.Backdrop:SetBackdropColor(0, 0, 0, 0.45)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 1)
        self.Border:SetBackdropBorderColor(0, 0, 0, 0.35)
    end
end

function UNITFRAME:PostCastStop()
    local color = C.DB.Unitframe.CompleteColor

    if not self.fadeOut then
        self:SetStatusBarColor(color.r, color.g, color.b)
        self.fadeOut = true
    end

    self:Show()

    ResetSpellTarget(self)
end

function UNITFRAME:PostCastFailed()
    local color = C.DB.Unitframe.FailColor

    self:SetStatusBarColor(color.r, color.g, color.b)
    self:SetValue(self.max)
    self.fadeOut = true
    self:Show()

    ResetSpellTarget(self)
end

function UNITFRAME:CreateCastBar(self)
    if not C.DB.Unitframe.Castbar then
        return
    end

    local style = self.unitStyle
    local isPlayer = style == 'player'
    local compact = not C.DB.Unitframe.SeparateCastbar
    local playerWidth = C.DB.Unitframe.PlayerCastbarWidth
    local playerHeight = C.DB.Unitframe.PlayerCastbarHeight
    local targetWidth = C.DB.Unitframe.TargetCastbarWidth
    local targetHeight = C.DB.Unitframe.TargetCastbarHeight
    local focusWidth = C.DB.Unitframe.FocusCastbarWidth
    local focusHeight = C.DB.Unitframe.FocusCastbarHeight
    local outline = _G.ANDROMEDA_ADB.FontOutline
    local font = C.Assets.Fonts.Condensed
    local iconAmp = 4

    local castbar = CreateFrame('StatusBar', 'oUF_Castbar' .. style, self)
    castbar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    castbar.Backdrop = F.CreateBDFrame(castbar, 0.45)
    castbar.Border = F.CreateSD(castbar.Backdrop, 0.35, 6, 6, true)
    self.Castbar = castbar

    castbar.castTicks = {}

    local spark = castbar:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.Textures.Spark)
    spark:SetBlendMode('ADD')
    spark:SetAlpha(0.7)
    -- spark:SetSize(12, castbar:GetHeight() * 2)
    castbar.Spark = spark

    local icon = castbar:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TEX_COORD))
    F.SetBD(icon, 0.25)
    icon.__bg:SetBackdropBorderColor(0, 0, 0)
    castbar.Icon = icon

    local text = F.CreateFS(castbar, font, 11, outline, '', nil, outline or 'THICK')
    text:SetPoint('CENTER')
    castbar.Text = text

    local time = F.CreateFS(castbar, font, 11, outline, '', nil, outline or 'THICK')
    time:SetPoint('RIGHT')
    castbar.Time = time
    castbar.Decimal = '%.1f'

    if isPlayer then
        local safeZone = castbar:CreateTexture(nil, 'OVERLAY')
        safeZone:SetTexture(C.Assets.Textures.StatusbarNormal)
        safeZone:SetVertexColor(0.87, 0.25, 0.42, 0.25)
        safeZone:SetPoint('TOPRIGHT')
        safeZone:SetPoint('BOTTOMRIGHT')
        castbar.SafeZone = safeZone

        self:RegisterEvent('GLOBAL_MOUSE_UP', UNITFRAME.OnCastSent, true) -- Fix quests with WorldFrame interaction
        self:RegisterEvent('GLOBAL_MOUSE_DOWN', UNITFRAME.OnCastSent, true)
        self:RegisterEvent('CURRENT_SPELL_CAST_CHANGED', UNITFRAME.OnCastSent, true)
    end

    local stage = F.CreateFS(castbar, C.Assets.Fonts.Regular, 22, '')
    stage:ClearAllPoints()
    stage:SetPoint('TOPLEFT', castbar.Icon, -2, 2)
    castbar.stageString = stage

    if compact then
        castbar:SetStatusBarColor(0, 0, 0, 0)
        castbar:SetAllPoints(self)
        castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)

        icon:SetSize(self:GetHeight() + 6, self:GetHeight() + 6)
        icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)

        spark:SetSize(20, self:GetHeight() + 10)

        text:Hide()
        time:Hide()
    else
        if style == 'player' then
            castbar:SetSize(playerWidth, playerHeight)
            createBarMover(castbar, L['PlayerCastbar'], 'PlayerCastbar', { 'TOP', self, 'BOTTOM', 0, -20 })

            icon:SetSize(playerHeight + iconAmp, playerHeight + iconAmp)
            icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)

            spark:SetSize(20, playerHeight + 10)
        elseif style == 'target' then
            castbar:SetSize(targetWidth, targetHeight)
            createBarMover(castbar, L['TargetCastbar'], 'TargetCastbar', { 'TOP', self, 'BOTTOM', 0, -4 })

            icon:SetSize(targetHeight + iconAmp, targetHeight + iconAmp)
            icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)

            spark:SetSize(20, targetHeight + 10)
        elseif style == 'focus' then
            castbar:SetSize(focusWidth, focusHeight)
            createBarMover(castbar, L['FocusCastbar'], 'FocusCastbar', { 'CENTER', _G.UIParent, 'CENTER', 0, 120 })

            icon:SetSize(focusHeight + iconAmp, focusHeight + iconAmp)
            icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)

            spark:SetSize(20, focusHeight + 10)
        end

        text:Show()
        time:Show()
    end

    castbar.OnUpdate = UNITFRAME.OnCastbarUpdate
    castbar.PostCastStart = UNITFRAME.PostCastStart
    castbar.PostCastStop = UNITFRAME.PostCastStop
    castbar.PostCastFail = UNITFRAME.PostCastFailed
    castbar.PostCastInterruptible = UNITFRAME.PostUpdateInterruptible

    castbar.UpdatePips = nop
end

function NAMEPLATE:CreateCastBar(self)
    if not C.DB.Nameplate.Castbar then
        return
    end

    local style = self.unitStyle
    local outline = _G.ANDROMEDA_ADB.FontOutline
    local font = C.Assets.Fonts.Condensed
    local color = C.DB.Unitframe.CastingColor
    local compact = not C.DB.Nameplate.SeparateCastbar
    local cbHeight = C.DB.Nameplate.CastbarHeight
    local npHeight = C.DB.Nameplate.Height
    local npWidth = C.DB.Nameplate.Width
    local iconAmp = 4

    local castbar = CreateFrame('StatusBar', 'oUF_Castbar' .. style, self)
    castbar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    castbar.Backdrop = F.CreateBDFrame(castbar, 0.45)
    castbar.Border = F.CreateSD(castbar.Backdrop, 0.35, 6, 6, true)
    self.Castbar = castbar

    local spark = castbar:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.Textures.Spark)
    spark:SetBlendMode('ADD')
    spark:SetAlpha(0.7)
    spark:SetSize(12, castbar:GetHeight() * 2)
    castbar.Spark = spark

    local text = F.CreateFS(castbar, font, 11, outline, '', nil, outline or 'THICK')
    text:SetPoint('CENTER', castbar, 'BOTTOM')
    text:SetShown(not compact)
    castbar.Text = text

    -- local time = F.CreateFS(castbar, font, 11, outline, '', nil, outline or 'THICK')
    -- time:SetPoint('RIGHT')
    -- time:SetShown(not compact)
    -- castbar.Time = time
    -- castbar.Decimal = '%.1f'

    local icon = castbar:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TEX_COORD))
    F.SetBD(icon, 0.25)
    icon.__bg:SetBackdropBorderColor(0, 0, 0)
    castbar.Icon = icon

    local shield = castbar:CreateTexture(nil, 'OVERLAY')
    shield:SetTexture(C.Assets.Textures.CastingShield)
    shield:SetSize(cbHeight + 4, cbHeight + 4)
    shield:SetPoint('CENTER', castbar, 'BOTTOMLEFT')
    castbar.Shield = shield

    if compact then
        castbar:SetStatusBarColor(0, 0, 0, 0)
        castbar:SetAllPoints(self)
        castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)

        icon:ClearAllPoints()
        icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
        icon:SetSize(npHeight + iconAmp, npHeight + iconAmp)
    else
        castbar:SetSize(npWidth, cbHeight)
        castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
        castbar:SetStatusBarColor(color.r, color.g, color.b)

        icon:ClearAllPoints()
        icon:SetPoint('TOPRIGHT', self, 'TOPLEFT', -2, 0)
        icon:SetSize(cbHeight + npHeight + 2, cbHeight + npHeight + 2)
    end

    -- Major spells glow
    castbar.glowFrame = F.CreateGlowFrame(castbar, icon:GetHeight())
    castbar.glowFrame:SetPoint('CENTER', castbar.Icon)

    castbar.SpellTarget = C.DB.Nameplate.TargetName
    castbar.OnUpdate = UNITFRAME.OnCastbarUpdate
    castbar.PostCastStart = UNITFRAME.PostCastStart
    castbar.PostCastStop = UNITFRAME.PostCastStop
    castbar.PostCastFail = UNITFRAME.PostCastFailed
    castbar.PostCastInterruptible = UNITFRAME.PostUpdateInterruptible
end
