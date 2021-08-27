local _G = _G
local format = format
local select = select
local floor = floor
local unpack = unpack
local select = select
local strfind = strfind
local UnitName = UnitName
local UnitLevel = UnitLevel
local UnitClass = UnitClass
local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPVP = UnitIsPVP
local UnitIsPlayer = UnitIsPlayer
local UnitIsTapDenied = UnitIsTapDenied
local UnitReaction = UnitReaction
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitPower = UnitPower
local UnitPowerMax = UnitPowerMax
local UnitStagger = UnitStagger
local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitClassification = UnitClassification
local UnitSelectionColor = UnitSelectionColor
local IsResting = IsResting
local GetCVarBool = GetCVarBool
local ALTERNATE_POWER_INDEX = Enum.PowerType.Alternate

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

local colors = F.Libs.oUF.colors
local tags = F.Libs.oUF.Tags.Methods
local tagEvents = F.Libs.oUF.Tags.Events

tags['free:health'] = function(unit)
    if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        return
    end

    local cur = UnitHealth(unit)
    local r, g, b = unpack(colors.reaction[UnitReaction(unit, 'player') or 5])

    return format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, F:Numb(cur))
end
tagEvents['free:health'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'

tags['free:healthpercentage'] = function(unit)
    if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
        return
    end

    local cur, max = UnitHealth(unit), UnitHealthMax(unit)
    local r, g, b = F:ColorGradient(cur / max, unpack(colors.smooth))
    r, g, b = r * 255, g * 255, b * 255

    if cur ~= max then
        return format('|cff%02x%02x%02x%d%%|r', r, g, b, floor(cur / max * 100 + 0.5))
    end
end
tagEvents['free:healthpercentage'] = 'UNIT_CONNECTION UNIT_HEALTH UNIT_MAXHEALTH'

tags['free:power'] = function(unit)
    local cur, max = UnitPower(unit), UnitPowerMax(unit)
    if (cur == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then
        return
    end

    return F:Numb(cur)
end
tagEvents['free:power'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'

tags['free:stagger'] = function(unit)
    if unit ~= 'player' then
        return
    end

    local cur = UnitStagger(unit) or 0
    local perc = cur / UnitHealthMax(unit)

    if cur == 0 then
        return
    end

    return F:Numb(cur) .. ' / ' .. C.MyColor .. floor(perc * 100 + .5) .. '%'
end
tagEvents['free:stagger'] = 'UNIT_MAXHEALTH UNIT_AURA'

tags['free:title'] = function(unit)
    if UnitIsPlayer(unit) then
        return
    end

    F.ScanTip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
    F.ScanTip:SetUnit(unit)

    local title = _G[format('FreeUI_ScanTooltipTextLeft%d', GetCVarBool('colorblindmode') and 3 or 2)]:GetText()
    if title and not strfind(title, '^' .. _G.LEVEL) then
        return title
    end
end
tagEvents['free:title'] = 'UNIT_NAME_UPDATE'

tags['free:color'] = function(unit)
    local class = select(2, UnitClass(unit))
    local reaction = UnitReaction(unit, "player")
    local isOffline = not UnitIsConnected(unit)
    local isDead = UnitIsDead(unit)
    local isGhost = UnitIsGhost(unit)
    local isTapped = UnitIsTapDenied(unit)

    if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
        return F:RGBToHex(1, 0, 0)
    elseif isTapped or isOffline then
        return F:RGBToHex(colors.tapped)
    elseif UnitIsPlayer(unit) then
        return F:RGBToHex(colors.class[class])
    elseif reaction then
        return F:RGBToHex(colors.reaction[reaction])
    else
        return F:RGBToHex(1, 1, 1)
    end
end
tagEvents['free:color'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED'

tags['free:dead'] = function(unit)
    if UnitIsDead(unit) then
        return '|cffd84343' .. 'Dead'
    elseif UnitIsGhost(unit) then
        return '|cffbd69be' .. 'Ghost'
    end
end
tagEvents['free:dead'] = 'UNIT_HEALTH'

tags['free:offline'] = function(unit)
    if not UnitIsConnected(unit) then
        return '|cffcccccc' .. 'Off'
    end
end
tagEvents['free:offline'] = 'UNIT_HEALTH UNIT_CONNECTION'

tags['free:name'] = function(unit)
    local useAbbr = C.DB.Unitframe.AbbreviatedName
    local str = UnitName(unit)
    local abbrName = F:AbbreviateString(str)

    if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
        return '<' .. _G.YOU .. '>'
    else
        return useAbbr and abbrName or str
    end
end
tagEvents['free:name'] = 'UNIT_NAME_UPDATE'

tags['free:npname'] = function(unit)
    local useAbbr = C.DB.Unitframe.AbbreviatedName
    local str = UnitName(unit)
    local abbrName = F:AbbreviateString(str)

    if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
        return C.RedColor .. '<' .. _G.YOU .. '>'
    else
        return F:ShortenString(useAbbr and abbrName or str, C.IsChinses and 6 or 8, true)
    end
end
tagEvents['free:npname'] = 'UNIT_NAME_UPDATE'

tags['free:groupname'] = function(unit)
    local isRaid = (unit:match('raid%d?$'))
    local showGroupName = C.DB.Unitframe.GroupShowName
    local shortenName = C.DB.Unitframe.ShortenName
    local nameStr = UnitName(unit)
    local shortenStr = F:ShortenString(nameStr, isRaid and 2 or 4)
    local isOffline = not UnitIsConnected(unit)
    local isDead = UnitIsDead(unit)
    local isGhost = UnitIsGhost(unit)

    if showGroupName then
        return shortenName and shortenStr or nameStr
    elseif isOffline then
        return 'off'
    elseif isDead or isGhost then
        return 'dead'
    end
end
tagEvents['free:groupname'] = 'UNIT_HEALTH UNIT_MAXHEALTH GROUP_ROSTER_UPDATE UNIT_CONNECTION'

tags['free:resting'] = function(unit)
    if (unit == 'player' and IsResting()) then
        return '|cff2C8D51Zzz|r'
    end
end
tagEvents['free:resting'] = 'PLAYER_UPDATE_RESTING'

tags['free:classification'] = function(unit)
    local class, level = UnitClassification(unit), UnitLevel(unit)
    if (class == 'worldboss' or level == -1) then
        return '|cff9D2933' .. _G.BOSS .. '|r'
    elseif (class == 'rare') then
        return '|cffFF99FF' .. _G.RARE .. '|r'
    elseif (class == 'rareelite') then
        return '|cffFF0099' .. _G.RAREELITE .. '|r'
    elseif (class == 'elite') then
        return '|cffCC3300' .. _G.ELITE .. '|r'
    else
        return ''
    end
end
tagEvents['free:classification'] = 'UNIT_CLASSIFICATION_CHANGED'

tags['free:pvp'] = function(unit)
    if UnitIsPVP(unit) then
        return '|cffCC3300P|r'
    end
end
tagEvents['free:pvp'] = 'UNIT_FACTION'

tags['free:altpower'] = function(unit)
    local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
    if max > 0 and not UnitIsDeadOrGhost(unit) then
        return ('%s%%'):format(floor(cur / max * 100 + .5))
    end
end
tagEvents['free:altpower'] = 'UNIT_POWER_UPDATE'

tags['free:tarname'] = function(unit)
    local tarUnit = unit .. 'target'
    if UnitExists(tarUnit) then
        local tarClass = select(2, UnitClass(tarUnit))
        return '<' .. F:RGBToHex(colors.class[tarClass]) .. UnitName(tarUnit) .. '|r>'
    end
end
tagEvents['free:tarname'] = 'UNIT_NAME_UPDATE UNIT_THREAT_SITUATION_UPDATE UNIT_HEALTH'

local font = C.Assets.Fonts.Condensed

function UNITFRAME:CreateGroupNameText(self)
    local outline = _G.FREE_ADB.FontOutline
    local groupName = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    self:Tag(groupName, '[free:color][free:groupname]')
    self.GroupName = groupName
end

function UNITFRAME:CreateNameText(self)
    local style = self.unitStyle
    local isNP = style == 'nameplate'
    local outline = _G.FREE_ADB.FontOutline
    local boldFont = C.Assets.Fonts.Bold

    local name = F.CreateFS(self.Health, isNP and boldFont or font, 11, outline, nil, nil, outline or 'THICK')

    if style == 'target' then
        name:SetJustifyH('RIGHT')
        name:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
    elseif style == 'arena' or style == 'boss' then
        name:SetJustifyH('LEFT')
        name:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
    elseif style == 'nameplate' then
        name:SetJustifyH('CENTER')
        name:SetPoint('BOTTOM', self, 'TOP', 0, -3)
    else
        name:SetJustifyH('CENTER')
        name:SetPoint('BOTTOM', self, 'TOP', 0, 3)
    end

    if style == 'nameplate' then
        self:Tag(name, '[free:npname]')
    elseif style == 'arena' then
        self:Tag(name, '[free:color][free:name] [arenaspec]')
    else
        self:Tag(name, '[free:color][free:name]')
    end

    self.Name = name
end

function UNITFRAME:CreateHealthValueText(self)
    local style = self.unitStyle
    local outline = _G.FREE_ADB.FontOutline

    local healthValue = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')
    healthValue:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

    if style == 'player' or style == 'playerplate' then
        self:Tag(healthValue, '[free:health] [free:pvp]')
    elseif style == 'target' then
        self:Tag(healthValue, '[free:dead][free:offline][free:health] [free:healthpercentage]')
    elseif style == 'boss' then
        healthValue:ClearAllPoints()
        healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
        healthValue:SetJustifyH('RIGHT')
        self:Tag(healthValue, '[free:dead][free:health] [free:healthpercentage]')
    elseif style == 'arena' then
        healthValue:ClearAllPoints()
        healthValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
        healthValue:SetJustifyH('RIGHT')
        self:Tag(healthValue, '[free:dead][free:offline][free:health]')
    end

    self.HealthValue = healthValue
end

function UNITFRAME:CreatePowerValueText(self)
    local style = self.unitStyle
    local outline = _G.FREE_ADB.FontOutline

    local powerValue = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')
    powerValue:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

    if style == 'target' then
        powerValue:ClearAllPoints()
        powerValue:SetPoint('BOTTOMLEFT', self.HealthValue, 'BOTTOMRIGHT', 4, 0)
    elseif style == 'boss' then
        powerValue:ClearAllPoints()
        powerValue:SetPoint('BOTTOMRIGHT', self.HealthValue, 'BOTTOMLEFT', -4, 0)
    end

    self:Tag(powerValue, '[powercolor][free:power]')
    powerValue.frequentUpdates = true

    self.PowerValue = powerValue
end

function UNITFRAME:CreateAlternativePowerValueText(self)
    local style = self.unitStyle
    local outline = _G.FREE_ADB.FontOutline

    local altPowerValue = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    if style == 'boss' then
        altPowerValue:SetPoint('LEFT', self, 'RIGHT', 2, 0)
    else
        altPowerValue:SetPoint('BOTTOM', self.Health, 'TOP', 0, 3)
    end

    self:Tag(altPowerValue, '[free:altpower]')

    self.AlternativePowerValue = altPowerValue
end


local function Player_OnEnter(self)
    self.LeftText:Show()
    self.RightText:Show()
    self:UpdateTags()
end

local function Player_OnLeave(self)
    self.LeftText:Hide()
    self.RightText:Hide()
end


function UNITFRAME:CreatePlayerTags(self)
    local outline = _G.FREE_ADB.FontOutline

    local leftText = F.CreateFS(self, font, 11, outline, nil, nil, outline or 'THICK')
    leftText:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

    self:Tag(leftText, '[free:health] [free:healthpercentage] [free:dead] [free:resting]')

    local rightText = F.CreateFS(self, font, 11, outline, nil, nil, outline or 'THICK')
    rightText:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

    self:Tag(rightText, '[powercolor][free:power]')

    self.LeftText = leftText
    self.RightText = rightText

    if C.DB.Unitframe.HidePlayerTags then
        self.LeftText:Hide()
        self.RightText:Hide()
        self:HookScript('OnEnter', Player_OnEnter)
        self:HookScript('OnLeave', Player_OnLeave)
    end
end

