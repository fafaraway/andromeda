local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local GetRuneCooldown = GetRuneCooldown

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local function SetLastBarColor(element, max, powerType)
    if not element or not max then
        return
    end

    local color = element.__owner.colors.power.max[powerType]

    if element[max] and color then
        local r, g, b = color[1], color[2], color[3]
        local lastBar = element[max]
        lastBar:SetStatusBarColor(r, g, b)
    end
end

local function PostUpdateClassPower(element, _, max, diff, powerType)
    local gap = 3
    local maxWidth = C.DB.Unitframe.PlayerWidth

    if diff then
        for i = 1, max do
            element[i]:SetWidth((maxWidth - (max - 1) * gap) / max)
        end
    end

    SetLastBarColor(element, max, powerType)
end

function UNITFRAME:OnUpdateRunes(elapsed)
    local duration = self.duration + elapsed
    self.duration = duration
    self:SetValue(duration)

    if self.timer then
        local remain = self.runeDuration - duration
        if remain > 0 then
            self.timer:SetText(F:FormatTime(remain))
        else
            self.timer:SetText(nil)
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
                if rune.timer then
                    rune.timer:SetText(nil)
                end
            elseif start then
                rune:SetAlpha(.3)
                rune.runeDuration = duration
                rune:SetScript('OnUpdate', UNITFRAME.OnUpdateRunes)
            end
        end
    end
end

function UNITFRAME:CreateClassPowerBar(self)
    if not C.DB.Unitframe.ClassPowerBar then
        return
    end

    local gap = 3
    local barWidth = C.DB.Unitframe.PlayerWidth
    local barHeight = C.DB.Unitframe.ClassPowerBarHeight

    local bars = {}
    for i = 1, 6 do
        bars[i] = CreateFrame('StatusBar', nil, self.ClassPowerBarHolder)
        bars[i]:SetHeight(barHeight)
        bars[i]:SetWidth((barWidth - 5 * gap) / 6)
        bars[i]:SetStatusBarTexture(C.Assets.statusbar_tex)
        bars[i]:SetFrameLevel(self:GetFrameLevel() + 5)

        F.SetBD(bars[i])

        if i == 1 then
            bars[i]:SetPoint('BOTTOMLEFT')
        else
            bars[i]:SetPoint('LEFT', bars[i - 1], 'RIGHT', gap, 0)
        end

        if C.MyClass == 'DEATHKNIGHT' and C.DB.Unitframe.RunesTimer then
            bars[i].timer = F.CreateFS(bars[i], C.Assets.Fonts.Regular, 11, nil, '')
        end
    end

    if C.MyClass == 'DEATHKNIGHT' then
        bars.colorSpec = true
        bars.sortOrder = 'asc'
        bars.PostUpdate = PostUpdateRunes
        self.Runes = bars
    else
        bars.PostUpdate = PostUpdateClassPower
        self.ClassPower = bars
    end
end
