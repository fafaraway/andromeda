local _G = _G
local unpack = unpack
local select = select
local format = format
local strupper = strupper
local CreateFrame = CreateFrame
local IsPlayerSpell = IsPlayerSpell
local GetTime = GetTime
local IsInInstance = IsInInstance
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local UnitExists = UnitExists
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local UnitInVehicle = UnitInVehicle

local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')
local NAMEPLATE = F:GetModule('Nameplate')
local LBG = F.Libs.LBG

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
    [324631] = 8 -- 血肉铸造，盟约
}

if C.MyClass == 'PRIEST' then
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

local ticks = {}
local function UpdateCastBarTicks(bar, numTicks)
    if numTicks and numTicks > 0 then
        local delta = bar:GetWidth() / numTicks
        for i = 1, numTicks do
            if not ticks[i] then
                ticks[i] = bar:CreateTexture(nil, 'OVERLAY')
                ticks[i]:SetTexture(C.Assets.bd_tex)
                ticks[i]:SetVertexColor(0, 0, 0, .85)
                ticks[i]:SetWidth(C.Mult)
                ticks[i]:SetHeight(bar:GetHeight())
            end
            ticks[i]:ClearAllPoints()
            ticks[i]:SetPoint('CENTER', bar, 'LEFT', delta * i, 0)
            ticks[i]:Show()
        end
    else
        for _, tick in pairs(ticks) do
            tick:Hide()
        end
    end
end

function UNITFRAME:OnCastbarUpdate(elapsed)
    if self.casting or self.channeling then
        local decimal = self.Decimal
        local duration = self.casting and (self.duration + elapsed) or (self.duration - elapsed)

        if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
            self.casting = nil
            self.channeling = nil
            return
        end

        if self.__owner.unit == 'player' then
            if self.delay ~= 0 then
                self.Time:SetFormattedText(decimal .. ' | |cffff0000' .. decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
            else
                self.Time:SetFormattedText(decimal .. ' | ' .. decimal, duration, self.max)
                if self.Lag and self.SafeZone and self.SafeZone.timeDiff and self.SafeZone.timeDiff ~= 0 then
                    self.Lag:SetFormattedText('%d ms', self.SafeZone.timeDiff * 1000)
                end
            end
        else
            if duration > 1e4 then
                self.Time:SetText('∞ | ∞')
            else
                self.Time:SetFormattedText(decimal .. ' | ' .. decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
            end
        end

        self.duration = duration
        self:SetValue(duration)
        self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
    elseif self.holdTime > 0 then
        self.holdTime = self.holdTime - elapsed
    else
        self.Spark:Hide()

        local alpha = self:GetAlpha() - .02
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
    element.SafeZone.sendTime = GetTime()
    element.SafeZone.castSent = true
end

local function UpdateNameTimeVisibility(self, unit)
    if not unit then
        return
    end

    if self.Text then
        self.Text:SetShown(C.DB.Nameplate.CastbarSpellName)
    end

    if self.Time then
        self.Time:SetShown(C.DB.Nameplate.CastbarSpellTime)
    end
end

local function UpdateSpellTarget(self, unit)
    if not C.DB.Nameplate.SpellTarget then
        return
    end

    if not (IsInInstance() and IsInGroup() and GetNumGroupMembers() > 1) then
        return
    end

    if not self.SpellTarget or not unit then
        return
    end

    local unitTarget = unit .. 'target'
    if UnitExists(unitTarget) then
        local nameString
        if UnitIsUnit(unitTarget, 'player') then
            nameString = format('|cffff0000%s|r', '>' .. strupper(_G.YOU) .. '<')
        else
            nameString = '<' .. F:RGBToHex(F:UnitColor(unitTarget)) .. UnitName(unitTarget) .. '|r>'
        end
        self.SpellTarget:SetText(nameString)
    end
end

local function ResetSpellTarget(self)
    if self.SpellTarget then
        self.SpellTarget:SetText('')
    end
end

function UNITFRAME:PostCastStart(unit)
    local style = self.__owner.unitStyle
    local compact = C.DB.Unitframe.CompactCastbar
    local npCompact = C.DB.Nameplate.CastbarCompact
    local normalColor = C.DB.Unitframe.CastingColor
    local uninterruptibleColor = C.DB.Unitframe.UninterruptibleColor
    local color = self.notInterruptible and uninterruptibleColor or normalColor
    local textColor = self.notInterruptible and {1, 0, 0} or {1, 1, 1}

    -- F:Debug(self.name)
    -- F:Debug(self.spellID)

    self:SetAlpha(1)
    self.Spark:Show()
    self.Text:SetTextColor(unpack(textColor))

    if unit == 'vehicle' or UnitInVehicle('player') then
        if self.SafeZone then
            self.SafeZone:Hide()
        end
        if self.Lag then
            self.Lag:Hide()
        end
    elseif unit == 'player' then
        local safeZone = self.SafeZone
        if safeZone then
            safeZone.timeDiff = 0
            if safeZone.castSent then
                safeZone.timeDiff = GetTime() - safeZone.sendTime
                safeZone.timeDiff = safeZone.timeDiff > self.max and self.max or safeZone.timeDiff
                safeZone:SetWidth(self:GetWidth() * (safeZone.timeDiff + .001) / self.max)
                safeZone:Show()
                safeZone.castSent = nil
            end
        end

        local numTicks = 0
        if self.channeling then
            numTicks = channelingTicks[self.spellID] or 0
        end
        UpdateCastBarTicks(self, numTicks)
    end

    if (style == 'nameplate' and npCompact) or (style ~= 'nameplate' and compact) then
        self:SetStatusBarColor(color.r, color.g, color.b, .6)
        self.Backdrop:SetBackdropColor(0, 0, 0, .2)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 0)
        self.Border:SetBackdropBorderColor(color.r, color.g, color.b, .6)
    else
        self:SetStatusBarColor(color.r, color.g, color.b, 1)
        self.Backdrop:SetBackdropColor(0, 0, 0, .6)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 1)
        self.Border:SetBackdropBorderColor(color.r, color.g, color.b, .35)
    end

    if style == 'nameplate' then
        UpdateNameTimeVisibility(self, unit)
        -- Major spells
        if C.DB.Nameplate.MajorSpellsGlow and NAMEPLATE.MajorSpellsList[self.spellID] then
            LBG.ShowOverlayGlow(self.glowFrame)
        else
            LBG.HideOverlayGlow(self.glowFrame)
        end

        -- Spell target
        UpdateSpellTarget(self, unit)
    end
end

function UNITFRAME:PostCastUpdate(unit)
    UpdateNameTimeVisibility(self, unit)
    UpdateSpellTarget(self, unit)
end

function UNITFRAME:PostUpdateInterruptible()
    local style = self.__owner.unitStyle
    local npCompact = C.DB.Nameplate.CastbarCompact
    local compact = C.DB.Unitframe.CompactCastbar
    local normalColor = C.DB.Unitframe.CastingColor
    local uninterruptibleColor = C.DB.Unitframe.UninterruptibleColor
    local color = self.notInterruptible and uninterruptibleColor or normalColor
    local textColor = self.notInterruptible and {1, 0, 0} or {1, 1, 1}

    if (style == 'nameplate' and npCompact) or (style ~= 'nameplate' and compact) then
        self:SetStatusBarColor(color.r, color.g, color.b, .6)
        self.Backdrop:SetBackdropColor(0, 0, 0, .2)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 0)
        self.Border:SetBackdropBorderColor(color.r, color.g, color.b, .6)
    else
        self:SetStatusBarColor(color.r, color.g, color.b, 1)
        self.Backdrop:SetBackdropColor(0, 0, 0, .6)
        self.Backdrop:SetBackdropBorderColor(0, 0, 0, 1)
        self.Border:SetBackdropBorderColor(color.r, color.g, color.b, .35)
    end

    self.Text:SetTextColor(unpack(textColor))
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

local function CreateCastBarMover(bar, text, value, anchor)
    local mover = F.Mover(bar, text, value, anchor, bar:GetHeight() + bar:GetWidth() + 3, bar:GetHeight() + 3)
    bar:ClearAllPoints()
    bar:SetPoint('CENTER', mover)
    bar.mover = mover
end

local cbPosition = {
    player = {'CENTER', _G.UIParent, 'CENTER', 0, -280},
    target = {'LEFT', _G.UIParent, 'CENTER', 113, -152},
    focus = {'CENTER', _G.UIParent, 'CENTER', 0, 120}
}

function UNITFRAME:CreateCastBar(self)
    if not C.DB.Unitframe.Castbar then
        return
    end

    local style = self.unitStyle
    local compact = C.DB.Unitframe.CompactCastbar
    local npCompact = C.DB.Nameplate.CastbarCompact
    local playerWidth = C.DB.Unitframe.PlayerCastbarWidth
    local playerHeight = C.DB.Unitframe.PlayerCastbarHeight
    local targetWidth = C.DB.Unitframe.TargetCastbarWidth
    local targetHeight = C.DB.Unitframe.TargetCastbarHeight
    local focusWidth = C.DB.Unitframe.FocusCastbarWidth
    local focusHeight = C.DB.Unitframe.FocusCastbarHeight
    local outline = _G.FREE_ADB.FontOutline
    local font = C.Assets.Fonts.Condensed
    local color = C.DB.Unitframe.CastingColor
    local spellName = C.DB.Nameplate.CastbarSpellName
    local spellTime = C.DB.Nameplate.CastbarSpellTime

    local castbar = CreateFrame('StatusBar', 'oUF_Castbar' .. style, self)
    castbar:SetStatusBarTexture(C.Assets.statusbar_tex)
    castbar.Backdrop = F.CreateBDFrame(castbar)
    castbar.Border = F.CreateSD(castbar.Backdrop, .35, 6, 6, true)
    self.Castbar = castbar

    local spark = castbar:CreateTexture(nil, 'OVERLAY')
    spark:SetTexture(C.Assets.spark_tex)
    spark:SetBlendMode('ADD')
    spark:SetAlpha(.7)
    spark:SetSize(12, castbar:GetHeight() * 2)
    castbar.Spark = spark

    local text = F.CreateFS(castbar, font, 11, outline, '', nil, outline or 'THICK')
    text:SetPoint('TOP', castbar, 'BOTTOM', 0, -3)
    text:SetTextColor(1, 1, 1)
    text:SetShown(false)
    castbar.Text = text

    local time = F.CreateFS(castbar, font, 11, outline, '', nil, outline or 'THICK')
    time:SetPoint('CENTER', castbar)
    time:SetShown(false)
    castbar.Time = time
    castbar.Decimal = '%.1f'

    local icon = castbar:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TexCoord))
    F.SetBD(icon)
    icon.__bg:SetBackdropBorderColor(0, 0, 0)
    castbar.Icon = icon

    if style == 'nameplate' then
        text:SetShown(spellName)
        time:SetShown(spellTime)

        if npCompact then
            castbar:SetStatusBarColor(0, 0, 0, 0)
            castbar:SetAllPoints(self)
            castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
            castbar:SetStatusBarColor(color.r, color.g, color.b, .6)
            castbar.Backdrop:SetBackdropColor(0, 0, 0, 0)
            castbar.Border:SetBackdropBorderColor(color.r, color.g, color.b, .45)

            icon:SetSize(self:GetHeight() + 10, self:GetHeight() + 10)
            icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
        else
            castbar:SetSize(self:GetWidth(), 4)
            castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -2)
            castbar:SetStatusBarColor(color.r, color.g, color.b)

            icon:SetSize(castbar:GetHeight() + self:GetHeight() + 2, castbar:GetHeight() + self:GetHeight() + 2)
            icon:ClearAllPoints()
            icon:SetPoint('TOPRIGHT', self, 'TOPLEFT', -2, 0)
        end

        -- Major spells glow
        castbar.glowFrame = F.CreateGlowFrame(castbar, icon:GetHeight())
        castbar.glowFrame:SetPoint('CENTER', castbar.Icon)

        local spellTarget = F.CreateFS(castbar, font, 12, outline, '', nil, outline or 'THICK')
        spellTarget:ClearAllPoints()
        spellTarget:SetJustifyH('CENTER')
        spellTarget:SetPoint('TOP', self, 'BOTTOM', 0, -3)

        if spellName then
            spellTarget:SetPoint('LEFT', text, 'RIGHT', 3, 0)
        else
            spellTarget:SetPoint('TOP', self, 'BOTTOM', 0, -3)
        end

        castbar.SpellTarget = spellTarget

    else
        text:SetShown(C.DB.Unitframe.SpellName)
        time:SetShown(C.DB.Unitframe.SpellTime)

        if compact then
            castbar:SetStatusBarColor(0, 0, 0, 0)
            castbar:SetAllPoints(self)
            castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
            castbar:SetStatusBarColor(color.r, color.g, color.b, .6)
            castbar.Backdrop:SetBackdropColor(0, 0, 0, 0)
            castbar.Border:SetBackdropBorderColor(color.r, color.g, color.b, .45)

            icon:SetSize(self:GetHeight() + 6, self:GetHeight() + 6)
            icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
        else
            if style == 'player' then
                castbar:SetSize(playerWidth, playerHeight)
                CreateCastBarMover(castbar, L['Player Castbar'], 'PlayerCastbar', cbPosition.player)

                icon:SetSize(castbar:GetHeight() + 8, castbar:GetHeight() + 8)
                icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
            elseif style == 'target' then
                castbar:SetSize(targetWidth, targetHeight)
                CreateCastBarMover(castbar, L['Target Castbar'], 'TargetCastbar', cbPosition.target)

                icon:SetSize(castbar:GetHeight() + 8, castbar:GetHeight() + 8)
                icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
            elseif style == 'focus' then
                castbar:SetSize(focusWidth, focusHeight)
                CreateCastBarMover(castbar, L['Focus Castbar'], 'FocusCastbar', cbPosition.focus)

                icon:SetSize(castbar:GetHeight() + 8, castbar:GetHeight() + 8)
                icon:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
            end

            castbar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end

    if style == 'player' then
        local safeZone = castbar:CreateTexture(nil, 'OVERLAY')
        safeZone:SetTexture(C.Assets.statusbar_tex)
        safeZone:SetVertexColor(.87, .25, .42)
        safeZone:SetPoint('TOPRIGHT')
        safeZone:SetPoint('BOTTOMRIGHT')
        castbar.SafeZone = safeZone
    end

    castbar.OnUpdate = UNITFRAME.OnCastbarUpdate
    castbar.PostCastStart = UNITFRAME.PostCastStart
    castbar.PostCastUpdate = UNITFRAME.PostCastUpdate
    castbar.PostCastStop = UNITFRAME.PostCastStop
    castbar.PostCastFail = UNITFRAME.PostCastFailed
    castbar.PostCastInterruptible = UNITFRAME.PostUpdateInterruptible
end
