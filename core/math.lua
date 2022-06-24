local F, C = unpack(select(2, ...))

-- Numberize
local numCap = { CHINESE = { '兆', '亿', '万' } }
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
function F:RgbToHex(r, g, b, header, ending)
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
function F:HexToRgb(hex)
    local a, r, g, b = strmatch(hex, '^|?c?(%x%x)(%x%x)(%x%x)(%x?%x?)|?r?$')
    if not a then
        return 0, 0, 0, 0
    end
    if b == '' then
        r, g, b, a = a, r, g, 'ff'
    end

    return tonumber(r, 16), tonumber(g, 16), tonumber(b, 16), tonumber(a, 16)
end

-- quick convert function: (nil or table to populate, 'ff0000', '00ff00', '0000ff', ...)
-- to get (1,0,0, 0,1,0, 0,0,1, ...)
function F:HexsToRgbs(rgb, ...)
    if not rgb then
        rgb = {}
    end
    for i = 1, select('#', ...) do
        local x, r, g, b = #rgb, F:HexToRgb(select(i, ...))
        rgb[x + 1], rgb[x + 2], rgb[x + 3] = r / 255, g / 255, b / 255
    end

    return unpack(rgb)
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
function F:TextGradient(text, ...)
    local msg, len, idx = '', string.utf8len(text), 0

    for i = 1, len do
        local x = string.utf8sub(text, i, i)
        if strmatch(x, '%s') then
            msg = msg .. x
            idx = idx + 1
        else
            local num = select('#', ...) / 3
            local segment, relperc = math.modf((idx / len) * num)
            local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

            if not r2 then
                msg = msg .. F:RgbToHex(r1, g1, b1, nil, x .. '|r')
            else
                msg = msg .. F:RgbToHex(
                    r1 + (r2 - r1) * relperc,
                    g1 + (g2 - g1) * relperc,
                    b1 + (b2 - b1) * relperc,
                    nil,
                    x .. '|r'
                )
                idx = idx + 1
            end
        end
    end

    return msg
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

    local frameALeft, frameARight, frameABottom, frameATop =
        frameA:GetLeft(), frameA:GetRight(), frameA:GetBottom(), frameA:GetTop()
    local frameBLeft, frameBRight, frameBBottom, frameBTop =
        frameB:GetLeft(), frameB:GetRight(), frameB:GetBottom(), frameB:GetTop()
    if not (frameALeft and frameARight and frameABottom and frameATop) then
        return
    end
    if not (frameBLeft and frameBRight and frameBBottom and frameBTop) then
        return
    end

    return ((frameALeft * sA) < (frameBRight * sB))
        and ((frameBLeft * sB) < (frameARight * sA))
        and ((frameABottom * sA) < (frameBTop * sB))
        and ((frameBBottom * sB) < (frameATop * sA))
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
        return string.format('|cffbebfb3%d|r', s / day + 0.5), s % day -- grey
    elseif s >= hour then
        return string.format('|cff4fcd35%d|r', s / hour + 0.5), s % hour -- white
    elseif s >= minute then
        return string.format('|cff21c8de%d|r', s / minute + 0.5), s % minute -- blue
    elseif s > 3 then
        return string.format('|cffffe700%d|r', s + 0.5), s - math.floor(s) -- yellow
    else
        return string.format('|cfffd3612%.1f|r', s), s - string.format('%.1f', s) -- red
    end
end

function F:FormatTimeRaw(s)
    if s >= day then
        return string.format('%dd', s / day + 0.5)
    elseif s >= hour then
        return string.format('%dh', s / hour + 0.5)
    elseif s >= minute then
        return string.format('%dm', s / minute + 0.5)
    else
        return string.format('%d', s + 0.5)
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

-- Timer
F.WaitTable = {}
F.WaitFrame = CreateFrame('Frame', C.ADDON_TITLE .. 'WaitFrame', _G.UIParent)
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
        table.insert(F.WaitTable, { delay, func, { ... } })
        F.WaitFrame:Show()
    end

    return true
end
