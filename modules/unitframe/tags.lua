local F, C, L = unpack(select(2, ...))
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

    return string.format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, F:Numb(cur))
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
        return string.format('|cff%02x%02x%02x%d%%|r', r, g, b, math.floor(cur / max * 100 + 0.5))
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

    return F:Numb(cur) .. ' / ' .. C.MyColor .. math.floor(perc * 100 + .5) .. '%'
end
tagEvents['free:stagger'] = 'UNIT_MAXHEALTH UNIT_AURA'

tags['free:title'] = function(unit)
    if UnitIsPlayer(unit) then
        return
    end

    F.ScanTip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
    F.ScanTip:SetUnit(unit)

    local title = _G[string.format('FreeUI_ScanTooltipTextLeft%d', GetCVarBool('colorblindmode') and 3 or 2)]:GetText()
    if title and not string.find(title, '^' .. _G.LEVEL) then
        return title
    end
end
tagEvents['free:title'] = 'UNIT_NAME_UPDATE'

tags['free:color'] = function(unit)
    local class = select(2, UnitClass(unit))
    local reaction = UnitReaction(unit, "player")
    local isOffline = not UnitIsConnected(unit)
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
    if UnitIsDeadOrGhost(unit) then
        return '|cffd84343' .. L['Dead']
    end
end
tagEvents['free:dead'] = 'UNIT_HEALTH'

tags['free:offline'] = function(unit)
    if not UnitIsConnected(unit) then
        return '|cffcccccc' .. L['Off']
    end
end
tagEvents['free:offline'] = 'UNIT_HEALTH UNIT_CONNECTION'

tags['free:name'] = function(unit)
    local shorten = C.DB.Unitframe.ShortenName
    local str = UnitName(unit)
    local newStr = (string.len(str) > 12) and string.gsub(str, "%s?(.[\128-\191]*)%S+%s", "%1. ") or str

    if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
        return '<' .. _G.YOU .. '>'
    else
        return shorten and F.ShortenString(newStr, 12, true) or str
    end
end
tagEvents['free:name'] = 'UNIT_NAME_UPDATE'

tags['free:npname'] = function(unit)
    local shorten = C.DB.Unitframe.ShortenName
    local str = UnitName(unit)
    local newStr = (string.len(str) > 12) and string.gsub(str, "%s?(.[\128-\191]*)%S+%s", "%1. ") or str

    return shorten and F.ShortenString(newStr, 12, true) or str
end
tagEvents['free:npname'] = 'UNIT_NAME_UPDATE'

tags['free:groupname'] = function(unit)
    local isRaid = (unit:match('raid%d?$'))
    local shorten = C.DB.Unitframe.ShortenName
    local str = UnitName(unit)

    return shorten and F.ShortenString(str, isRaid and 2 or 4) or str
end
tagEvents['free:groupname'] = 'UNIT_NAME_UPDATE'

tags["free:grouprole"] = function(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "TANK" then
		return "|cffffe934#|r"
	elseif role == "HEALER" then
		return "|cff2aff3d+|r"
	elseif role == "DAMAGER" then
		return "|cffff0052*|r"
	end
end
tagEvents["free:grouprole"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

tags["free:groupleader"] = function(unit)
    local isLeader = (UnitInParty(unit) or UnitInRaid(unit)) and UnitIsGroupLeader(unit)
	return isLeader and "|cffffffff!|r"
end
tagEvents["free:groupleader"] = "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"

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
    local cur = UnitPower(unit, _G.ALTERNATE_POWER_INDEX)
    local max = UnitPowerMax(unit, _G.ALTERNATE_POWER_INDEX)
    if max > 0 and not UnitIsDeadOrGhost(unit) then
        return ('%s%%'):format(math.floor(cur / max * 100 + .5))
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

function UNITFRAME:CreateGroupLeaderTag(self)
    local font = C.Assets.Fonts.Pixel
    local groupLeader = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    groupLeader:SetPoint('TOPLEFT', 2, -2)

    self:Tag(groupLeader, '[free:groupleader]')
    self.GroupLeader = groupLeader
end

function UNITFRAME:CreateGroupRoleTag(self)
    local font = C.Assets.Fonts.Pixel
    local groupRole = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    groupRole:SetPoint('BOTTOM', 1, 1)

    self:Tag(groupRole, '[free:grouprole]')
    self.GroupRole = groupRole
end

function UNITFRAME:CreateGroupNameTag(self)
    local outline = _G.FREE_ADB.FontOutline
    local showName = C.DB.Unitframe.GroupShowName
    local groupName = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    if showName then
        self:Tag(groupName, '[free:color][free:groupname]')
    else
        self:Tag(groupName, '[free:color][free:offline][free:dead]')
    end
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

