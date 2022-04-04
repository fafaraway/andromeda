local F, C = unpack(select(2, ...))

-- Numberize
local numCap = {CHINESE = {'兆', '亿', '万'}}
function F:Numb(n)
    if _G.FREE_ADB.NumberFormat == 1 then
        if n >= 1e12 then
            return ('%.2ft'):format(n / 1e12)
        elseif n >= 1e9 then
            return ('%.2fb'):format(n / 1e9)
        elseif n >= 1e6 then
            return ('%.2fm'):format(n / 1e6)
        elseif n >= 1e3 then
            return ('%.2fk'):format(n / 1e3)
        else
            return ('%.0f'):format(n)
        end
    elseif _G.FREE_ADB.NumberFormat == 2 then
        if n >= 1e12 then
            return string.format('%.2f' .. numCap['CHINESE'][1], n / 1e12)
        elseif n >= 1e8 then
            return string.format('%.2f' .. numCap['CHINESE'][2], n / 1e8)
        elseif n >= 1e4 then
            return string.format('%.2f' .. numCap['CHINESE'][3], n / 1e4)
        else
            return string.format('%.0f', n)
        end
    else
        return string.format('%.0f', n)
    end
end

-- RGB to Hex
function F:RGBToHex(r, g, b, header, ending)
    if r then
        if type(r) == 'table' then
            if r.r then
                r, g, b = r.r, r.g, r.b
            else
                r, g, b = unpack(r)
            end
        end
        return string.format('%s%02x%02x%02x%s', header or '|cff', r * 255, g * 255, b * 255, ending or '')
    end
end

-- Hex to RGB
function F:HexToRGB(rgb)
    if string.len(rgb) == 6 then
        local r, g, b
        r, g, b = tonumber('0x' .. string.sub(rgb, 0, 2)), tonumber('0x' .. string.sub(rgb, 3, 4)), tonumber('0x' .. string.sub(rgb, 5, 6))
        if not r then
            r = 0
        else
            r = r / 255
        end
        if not g then
            g = 0
        else
            g = g / 255
        end
        if not b then
            b = 0
        else
            b = b / 255
        end
        return r, g, b
    else
        return
    end
end

-- http://www.wowwiki.com/ColorGradient
function F:ColorGradient(perc, ...)
    if perc >= 1 then
        return select(select('#', ...) - 2, ...)
    elseif perc <= 0 then
        return ...
    end

    local num = select('#', ...) / 3
    local segment, relperc = math.modf(perc * (num - 1))
    local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

    return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
end

-- Text Gradient
local function GetColorCode(r, g, b)
    r = math.floor(r * 255 + 0.5)
    local rH = string.format('%x', r)
    if #rH < 2 then
        rH = '0' .. rH
    end

    g = math.floor(g * 255 + 0.5)
    local gH = string.format('%x', g)
    if #gH < 2 then
        gH = '0' .. gH
    end

    b = math.floor(b * 255 + 0.5)
    local bH = string.format('%x', b)
    if #bH < 2 then
        bH = '0' .. bH
    end

    return '|cff' .. rH .. gH .. bH
end

function F:TextGradient(text, r, g, b, lR, lG, lB, lightPosition)
    local length = #text
    local newChar
    local newText = ''
    local lightPower
    local cR, cG, cB
    for i = 1, length do
        if (length == 1) then
            lightPower = 0
        else
            local fullLight = (i - 1) / (length - 1)
            local delta = math.abs(lightPosition - fullLight)
            lightPower = math.max(0, 1.00 - delta / 0.50)
        end
        cR = r + (lR - r) * lightPower
        cG = g + (lG - g) * lightPower
        cB = b + (lB - b) * lightPower
        newChar = GetColorCode(cR, cG, cB) .. string.sub(text, i, i)
        newText = newText .. newChar
    end
    return newText
end

-- Return rounded number
function F:Round(num, idp)
    if type(num) ~= 'number' then
        return num, idp
    end

    if idp and idp > 0 then
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end

    return math.floor(num + 0.5)
end

-- Truncate a number off to n places
function F:Truncate(v, decimals)
    return v - (v % (0.1 ^ (decimals or 0)))
end

-- From http://wow.gamepedia.com/UI_coordinates
function F:FramesOverlap(frameA, frameB)
    if not frameA or not frameB then
        return
    end

    local sA, sB = frameA:GetEffectiveScale(), frameB:GetEffectiveScale()
    if not sA or not sB then
        return
    end

    local frameALeft, frameARight, frameABottom, frameATop = frameA:GetLeft(), frameA:GetRight(), frameA:GetBottom(), frameA:GetTop()
    local frameBLeft, frameBRight, frameBBottom, frameBTop = frameB:GetLeft(), frameB:GetRight(), frameB:GetBottom(), frameB:GetTop()
    if not (frameALeft and frameARight and frameABottom and frameATop) then
        return
    end
    if not (frameBLeft and frameBRight and frameBBottom and frameBTop) then
        return
    end

    return ((frameALeft * sA) < (frameBRight * sB)) and ((frameBLeft * sB) < (frameARight * sA)) and ((frameABottom * sA) < (frameBTop * sB)) and ((frameBBottom * sB) < (frameATop * sA))
end

function F:GetScreenQuadrant(frame)
    local x, y = frame:GetCenter()
    local screenWidth = GetScreenWidth()
    local screenHeight = GetScreenHeight()

    if not (x and y) then
        return 'UNKNOWN', frame:GetName()
    end

    local point
    if (x > (screenWidth / 3) and x < (screenWidth / 3) * 2) and y > (screenHeight / 3) * 2 then
        point = 'TOP'
    elseif x < (screenWidth / 3) and y > (screenHeight / 3) * 2 then
        point = 'TOPLEFT'
    elseif x > (screenWidth / 3) * 2 and y > (screenHeight / 3) * 2 then
        point = 'TOPRIGHT'
    elseif (x > (screenWidth / 3) and x < (screenWidth / 3) * 2) and y < (screenHeight / 3) then
        point = 'BOTTOM'
    elseif x < (screenWidth / 3) and y < (screenHeight / 3) then
        point = 'BOTTOMLEFT'
    elseif x > (screenWidth / 3) * 2 and y < (screenHeight / 3) then
        point = 'BOTTOMRIGHT'
    elseif x < (screenWidth / 3) and (y > (screenHeight / 3) and y < (screenHeight / 3) * 2) then
        point = 'LEFT'
    elseif x > (screenWidth / 3) * 2 and y < (screenHeight / 3) * 2 and y > (screenHeight / 3) then
        point = 'RIGHT'
    else
        point = 'CENTER'
    end

    return point
end

-- Cooldown calculation
local day, hour, minute = 86400, 3600, 60
function F:FormatTime(s)
    if s >= day then
        return string.format('|cffbebfb3%d|r', s / day + .5), s % day -- grey
    elseif s >= hour then
        return string.format('|cff4fcd35%d|r', s / hour + .5), s % hour -- white
    elseif s >= minute then
        return string.format('|cff21c8de%d|r', s / minute + .5), s % minute -- blue
    elseif s > 3 then
        return string.format('|cffffe700%d|r', s + .5), s - math.floor(s) -- yellow
    else
        return string.format('|cfffd3612%.1f|r', s), s - string.format('%.1f', s)
    end
end

function F:FormatTimeRaw(s)
    if s >= day then
        return string.format('%dd', s / day + .5)
    elseif s >= hour then
        return string.format('%dh', s / hour + .5)
    elseif s >= minute then
        return string.format('%dm', s / minute + .5)
    else
        return string.format('%d', s + .5)
    end
end

function F:CooldownOnUpdate(elapsed, raw)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 0.1 then
        local timeLeft = self.expiration - GetTime()
        if timeLeft > 0 then
            local text
            if raw then
                text = F:FormatTimeRaw(timeLeft)
            else
                text = F:FormatTime(timeLeft)
            end
            self.timer:SetText(text)
        else
            self:SetScript('OnUpdate', nil)
            self.timer:SetText(nil)
        end
        self.elapsed = 0
    end
end

-- Table
function F:CopyTable(source, target)
    for key, value in pairs(source) do
        if type(value) == 'table' then
            if not target[key] then
                target[key] = {}
            end
            for k in pairs(value) do
                target[key][k] = value[k]
            end
        else
            target[key] = value
        end
    end
end

function F:SplitList(list, variable, cleanup)
    if cleanup then
        table.wipe(list)
    end

    for word in variable:gmatch('%S+') do
        word = tonumber(word) or word -- use number if exists, needs review
        list[word] = true
    end
end

-- Timer
F.WaitTable = {}
F.WaitFrame = CreateFrame('Frame', 'FreeUIWaitFrame', _G.UIParent)
F.WaitFrame:SetScript('OnUpdate', F.WaitFunc)

function F:WaitFunc(elapse)
    local i = 1
    while i <= #F.WaitTable do
        local data = F.WaitTable[i]
        if data[1] > elapse then
            data[1], i = data[1] - elapse, i + 1
        else
            table.remove(F.WaitTable, i)
            data[2](unpack(data[3]))

            if #F.WaitTable == 0 then
                F.WaitFrame:Hide()
            end
        end
    end
end

function F:Delay(delay, func, ...)
    if type(delay) ~= 'number' or type(func) ~= 'function' then
        return false
    end

    if delay < 0.01 then
        delay = 0.01
    end

    if select('#', ...) <= 0 then
        C_Timer.After(delay, func)
    else
        table.insert(F.WaitTable, {delay, func, {...}})
        F.WaitFrame:Show()
    end

    return true
end
