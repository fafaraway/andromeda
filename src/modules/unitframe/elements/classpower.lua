local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local function PostUpdateClassPower(element, cur, max, diff, powerType, chargedPowerPoints)
    local gap = 3

    if not cur or cur == 0 then
        for i = 1, 7 do
            element[i].bg:Hide()
        end

        element.prevColor = nil
    else
        for i = 1, max do
            element[i].bg:Show()
        end

        element.thisColor = cur == max and 1 or 2
        if not element.prevColor or element.prevColor ~= element.thisColor then
            local r, g, b = 1, 0, 0
            if element.thisColor == 2 then
                local color = element.__owner.colors.power[powerType]
                r, g, b = color[1], color[2], color[3]
            end
            for i = 1, #element do
                element[i]:SetStatusBarColor(r, g, b)
            end
            element.prevColor = element.thisColor
        end
    end

    if diff then
        for i = 1, max do
            element[i]:SetWidth((element.__owner.ClassPowerBar:GetWidth() - (max - 1) * gap) / max)
        end
        for i = max + 1, 7 do
            element[i].bg:Hide()
        end
    end

    for i = 1, 7 do
        local bar = element[i]
        if not bar.chargeStar then
            break
        end

        bar.chargeStar:SetShown(chargedPowerPoints and tContains(chargedPowerPoints, i))
    end
end

function UNITFRAME:OnUpdateRunes(elapsed)
    local duration = self.duration + elapsed
    self.duration = duration
    self:SetValue(duration)
    self.timer:SetText('')
    if C.DB.Unitframe.RunesTimer then
        local remain = self.runeDuration - duration
        if remain > 0 then
            self.timer:SetText(F:FormatTime(remain))
        end
    end
end

local function PostUpdateRunes(element, runemap)
    for index, runeID in next, runemap do
        local rune = element[index]
        local start, duration, runeReady = GetRuneCooldown(runeID)
        if rune:IsShown() then
            if runeReady then
                rune:SetAlpha(1)
                rune:SetScript('OnUpdate', nil)
                rune.timer:SetText('')
            elseif start then
                rune:SetAlpha(0.45)
                rune.runeDuration = duration
                rune:SetScript('OnUpdate', UNITFRAME.OnUpdateRunes)
            end
        end
    end
end

function UNITFRAME:CreateClassPower(self)
    local gap = 3
    local barWidth = C.DB.Unitframe.PlayerWidth
    local barHeight = C.DB.Unitframe.ClassPowerHeight

    local isDK = C.MY_CLASS == 'DEATHKNIGHT'
    local holder = CreateFrame('Frame', '$parentClassPowerBar', self)
    holder:SetSize(barWidth, barHeight)
    holder:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)

    if not isDK then
        holder.bg = F.SetBD(holder)
        holder.bg:SetFrameLevel(5)
        holder.bg:SetBackdropBorderColor(1, 0.8, 0)
        holder.bg:Hide()
    end

    local bars = {}
    for i = 1, 7 do
        bars[i] = CreateFrame('StatusBar', C.ADDON_TITLE .. 'ClassPower' .. i, holder)
        bars[i]:SetHeight(barHeight)
        bars[i]:SetWidth((barWidth - 6 * gap) / 7)
        bars[i]:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
        bars[i]:SetFrameLevel(self:GetFrameLevel() + 5)
        bars[i].__bg = F.SetBD(bars[i], 0)
        bars[i].__bg:SetBackdropBorderColor(0, 0, 0, 1)

        if i == 1 then
            bars[i]:SetPoint('BOTTOMLEFT')
        else
            bars[i]:SetPoint('LEFT', bars[i - 1], 'RIGHT', gap, 0)
        end

        bars[i].bg = bars[i]:CreateTexture(nil, 'BACKGROUND')
        bars[i].bg:SetAllPoints(bars[i])
        bars[i].bg:SetTexture(C.Assets.Textures.StatusbarFlat)
        bars[i].bg.multiplier = 0.25

        if isDK then
            bars[i].timer = F.CreateFS(bars[i], C.Assets.Fonts.Regular, 11, nil, '')
        end
    end

    if isDK then
        bars.colorSpec = true
        bars.sortOrder = 'asc'
        bars.PostUpdate = PostUpdateRunes
        bars.__max = 6
        self.Runes = bars
    else
        bars.PostUpdate = PostUpdateClassPower
        self.ClassPower = bars
    end

    self.ClassPowerBar = holder
end

function UNITFRAME:UpdateClassPower()
    for _, frame in pairs(oUF.objects) do
        if C.DB.Unitframe.ClassPower then
            if not frame:IsElementEnabled('ClassPower') then
                frame:EnableElement('ClassPower')
                if frame.ClassPower then
                    frame.ClassPower:ForceUpdate()
                end
            end
            if not frame:IsElementEnabled('Runes') then
                frame:EnableElement('Runes')
                if frame.Runes then
                    frame.Runes:ForceUpdate()
                end
            end
        else
            if frame:IsElementEnabled('ClassPower') then
                frame:DisableElement('ClassPower')
            end
            if frame:IsElementEnabled('Runes') then
                frame:DisableElement('Runes')
            end
        end
    end
end
