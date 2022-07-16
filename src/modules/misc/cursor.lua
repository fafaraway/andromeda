local F, C = unpack(select(2, ...))
local CT = F:RegisterModule('CursorTrail')

local pollingRate, numLines = 0.05, 15
local lines = {}
for i = 1, numLines do
    local line = _G.UIParent:CreateLine()
    line:SetThickness(_G.Lerp(5, 1, (i - 1) / numLines))
    line:SetColorTexture(1, 1, 1)

    local startA, endA = _G.Lerp(1, 0, (i - 1) / numLines), _G.Lerp(1, 0, i / numLines)
    line:SetGradientAlpha('HORIZONTAL', 1, 1, 1, startA, 1, 1, 1, endA)

    lines[i] = { line = line, x = 0, y = 0 }
end

local function GetLength(startX, startY, endX, endY)
    local dx, dy = endX - startX, endY - startY

    if dx < 0 then
        dx, dy = -dx, -dy
    end

    return sqrt((dx * dx) + (dy * dy))
end

local function UpdateTrail()
    local startX, startY = _G.GetScaledCursorPosition()

    for i = 1, numLines do
        local info = lines[i]

        local endX, endY = info.x, info.y
        if GetLength(startX, startY, endX, endY) < 0.1 then
            info.line:Hide()
        else
            info.line:Show()
            info.line:SetStartPoint('BOTTOMLEFT', _G.UIParent, startX, startY)
            info.line:SetEndPoint('BOTTOMLEFT', _G.UIParent, endX, endY)
        end

        info.x, info.y = startX, startY
        startX, startY = endX, endY
    end
end

local function AddTrail()
    C_Timer.NewTicker(pollingRate, UpdateTrail)
end

local x = 0
local y = 0
local speed = 0

local function UpdateGlow(self, elapsed)
    local dX = x
    local dY = y
    x, y = GetCursorPosition()
    dX = x - dX
    dY = y - dY
    local weight = 2048 ^ -elapsed
    speed = min(weight * speed + (1 - weight) * sqrt(dX * dX + dY * dY) / elapsed, 1024)
    local size = speed / 6 - 16
    if size > 0 then
        local scale = _G.UIParent:GetEffectiveScale()
        self.texture:SetHeight(size)
        self.texture:SetWidth(size)
        self.texture:SetPoint('CENTER', _G.UIParent, 'BOTTOMLEFT', (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
        self.texture:Show()
    else
        self.texture:Hide()
    end
end

local function AddGlow()
    local frame = CreateFrame('Frame', nil, _G.UIParent)
    frame:SetFrameStrata('TOOLTIP')

    local texture = frame:CreateTexture()
    texture:SetTexture([[Interface\Cooldown\star4]])
    texture:SetBlendMode('ADD')
    texture:SetAlpha(0.5)
    frame.texture = texture

    frame:SetScript('OnUpdate', UpdateGlow)
end

function CT:OnLogin()
    if not C.DB.General.CursorTrail then
        return
    end

    AddTrail()
    AddGlow()
end
