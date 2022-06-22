local F, C, L = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')
local oUF = F.Libs.oUF

local colors = oUF.colors
local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events

local function ColorHealthPerc(unit)
    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    local r, g, b = F:ColorGradient(cur / max, unpack(colors.smooth))
    r, g, b = r * 255, g * 255, b * 255

    if cur ~= max then
        local perc = string.format('|cff%02x%02x%02x%d%%|r', r, g, b, math.floor(cur / max * 100 + 0.5))
        return perc
    end
end

local function GetHealthValAndPerc(unit, cur, perc)
    if perc and perc < 100 then
        return F:Numb(cur) .. ' | ' .. ColorHealthPerc(unit)
    else
        return F:Numb(cur)
    end
end

local function GetHealthCurAndMax(cur, max)
    if cur == max then
        return F:Numb(max)
    else
        return F:Numb(cur) .. ' | ' .. F:Numb(max)
    end
end

local events = {
    nphp = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION',
    npname = 'UNIT_NAME_UPDATE',
    npnamefull = 'UNIT_NAME_UPDATE',
    npclassify = 'UNIT_CLASSIFICATION_CHANGED',
    nplevel = 'UNIT_LEVEL PLAYER_LEVEL_UP',
}

local _tags = {
    -- nameplate health
    nphp = function(unit)
        local cur, max = UnitHealth(unit), UnitHealthMax(unit)
        local perc = max == 0 and 0 or F:Round(cur / max * 100, 1)
        local healthTagType = C.DB.Nameplate.HealthTagType

        -- 1 cur and perc 2 cur and max 3 cur 4 perc 5 loss 6 loss and perc
        if healthTagType == 1 then
            return GetHealthValAndPerc(unit, cur, perc)
        elseif healthTagType == 2 then
            return GetHealthCurAndMax(cur, max)
        elseif healthTagType == 3 then
            return F:Numb(cur)
        elseif healthTagType == 4 then
            return perc < 100 and ColorHealthPerc(unit)
        elseif healthTagType == 5 then
            local loss = max - cur
            return loss ~= 0 and F:Numb(loss)
        elseif healthTagType == 6 then
            local loss = max - cur
            return loss ~= 0 and F:Round(loss / max * 100, 1)
        elseif healthTagType == 7 then
            return ''
        end
    end,

    -- nameplate name
    npname = function(unit)
        local shorten = C.DB.Nameplate.ShortenName
        local abbr = C.DB.Nameplate.AbbrName
        local nameLength = C.DB.Nameplate.NameLength
        local str = UnitName(unit)

        if abbr then
            str = F.AbbrNameString(str) or str
        end

        if shorten then
            str = F.ShortenString(str, nameLength, true)
            return str
        else
            return str
        end
    end,

    -- nameplate name full (name only mode)
    npnamefull = function(unit)
        local str = UnitName(unit)
        return str
    end,

    -- nameplate classify
    npclassify = function(unit)
        local texStr = '|T%s:16:16:0:0:64:64:4:60:4:60|t '
        local class, level = UnitClassification(unit), UnitLevel(unit)

        if class == 'worldboss' or level == -1 then
            return string.format(texStr, C.Assets.Texture.Boss)
        elseif (class == 'rare') or (class == 'rareelite') then
            return string.format(texStr, C.Assets.Texture.Rare)
        elseif class == 'elite' then
            return string.format(texStr, C.Assets.Texture.Elite)
        end
    end,

    -- nameplate level
    nplevel = function(unit)
        local level = UnitLevel(unit)
        -- if level and level ~= UnitLevel('player') then
        if level then
            if level > 0 then
                level = F:RgbToHex(GetCreatureDifficultyColor(level)) .. level .. '|r '
                -- else
                --     level = '|cffff0000??|r '
            end
        else
            level = ''
        end

        return level
    end,

    npnone = nop,
}

for tag, func in next, _tags do
    tagMethods['free:' .. tag] = func
    tagEvents['free:' .. tag] = events[tag]
end

function NAMEPLATE.ConfigureNameTag(frame)
    local nameOnly = frame.plateType == 'NameOnly'
    local name = frame.NameTag
    local outline = _G.FREE_ADB.FontOutline

    name:SetShown(not frame.widgetsOnly)
    name:ClearAllPoints()

    if nameOnly then
        F:SetFS(name, C.Assets.Font.Header, 16, outline, nil, nil, outline or 'THICK')

        name:SetParent(frame)
        name:SetPoint('CENTER', frame, 'TOP', 0, 8)
        name:SetJustifyH('CENTER')

        frame:Tag(name, '[free:color][free:npnamefull]')
    else
        F:SetFS(name, C.Assets.Font.Bold, 11, outline, nil, nil, outline or 'THICK')

        name:SetParent(frame.Health)
        name:SetPoint('LEFT', frame, 'TOPLEFT')
        name:SetJustifyH('LEFT')

        -- 1 name 2 level name 3 class level name 4 class name 5 none
        local nameTagType = C.DB.Nameplate.NameTagType
        if nameTagType == 1 then
            frame:Tag(name, '[free:npname]')
        elseif nameTagType == 2 then
            frame:Tag(name, '[free:nplevel][free:npname]')
        elseif nameTagType == 3 then
            frame:Tag(name, '[free:npclassify][free:nplevel][free:npname]')
        elseif nameTagType == 4 then
            frame:Tag(name, '[free:npclassify][free:npname]')
        elseif nameTagType == 5 then
            frame:Tag(name, '[free:npnone]')
        end
    end

    name:UpdateTag()
end

function NAMEPLATE:CreateNameTag(self)
    local outline = _G.FREE_ADB.FontOutline
    local font = C.Assets.Font.Bold

    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    self.NameTag = text

    NAMEPLATE.ConfigureNameTag(self)
end

function NAMEPLATE.ConfigureHealthTag(frame)
    local text = frame.HealthTag

    text:ClearAllPoints()
    text:SetPoint('RIGHT', frame, 'TOPRIGHT')
    text:SetJustifyH('RIGHT')

    frame:Tag(text, '[free:nphp]')

    text:UpdateTag()
end

function NAMEPLATE:CreateHealthTag(self)
    local font = C.Assets.Font.Condensed
    local outline = _G.FREE_ADB.FontOutline

    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    self.HealthTag = text

    NAMEPLATE.ConfigureHealthTag(self)
end

function NAMEPLATE:UpdateTags()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'nameplate' then
            NAMEPLATE.ConfigureNameTag(frame)
            NAMEPLATE.ConfigureHealthTag(frame)
        end
    end
end
