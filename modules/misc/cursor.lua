local _G = _G
local select = select
local unpack = unpack
local Lerp = Lerp
local sqrt = sqrt
local GetScaledCursorPosition = GetScaledCursorPosition
local C_Timer_NewTicker = C_Timer.NewTicker

local F, C = unpack(select(2, ...))
local MISC = F.MISC

local pollingRate, numLines = 0.05, 15
local lines = {}
for i = 1, numLines do
    local line = _G.UIParent:CreateLine()
    line:SetThickness(Lerp(5, 1, (i - 1) / numLines))
    line:SetColorTexture(1, 1, 1)

    local startA, endA = Lerp(1, 0, (i - 1) / numLines), Lerp(1, 0, i / numLines)
    line:SetGradientAlpha('HORIZONTAL', 1, 1, 1, startA, 1, 1, 1, endA)

    lines[i] = {line = line, x = 0, y = 0}
end

local function GetLength(startX, startY, endX, endY)
    local dx, dy = endX - startX, endY - startY

    if dx < 0 then
        dx, dy = -dx, -dy
    end

    return sqrt((dx * dx) + (dy * dy))
end

local function UpdateTrail()
    local startX, startY = GetScaledCursorPosition()

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

function MISC:CursorTrail()
    if not C.DB.General.CursorTrail then
        return
    end

    C_Timer_NewTicker(pollingRate, UpdateTrail)
end

MISC:RegisterMisc('CursorTrail', MISC.CursorTrail)
