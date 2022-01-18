local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local NAMEPLATE = F:GetModule('Nameplate')
local oUF = F.Libs.oUF

local colors = oUF.colors
local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
-- local tagSharedEvents = tags.SharedEvents

local events = {
    healthvalue = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE',
    healthperc = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE',
    nphp = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION',
    powervalue = 'UNIT_MAXPOWER UNIT_POWER_UPDATE UNIT_CONNECTION UNIT_DISPLAYPOWER',
    altpowerperc = 'UNIT_MAXPOWER UNIT_POWER_UPDATE',
    dead = 'UNIT_HEALTH',
    offline = 'UNIT_HEALTH UNIT_CONNECTION',
    name = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    partyname = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    raidname = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    npname = 'UNIT_NAME_UPDATE',
    tarname = 'UNIT_NAME_UPDATE UNIT_THREAT_SITUATION_UPDATE UNIT_HEALTH',
    color = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    nptitle = 'UNIT_NAME_UPDATE',
    grouprole = 'PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE',
    groupleader = 'PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE',
    resting = 'PLAYER_UPDATE_RESTING',
    pvp = 'UNIT_FACTION',
    classification = 'UNIT_CLASSIFICATION_CHANGED'
}

local function AbbrName(string, i)
    if string.len(string) > i then
        return string.gsub(string, '%s?(.[\128-\191]*)%S+%s', '%1. ')
    else
        return string
    end
end

local function GetUnitHealthPerc(unit)
    local unitHealth, unitMaxHealth = UnitHealth(unit), UnitHealthMax(unit)
    if unitMaxHealth == 0 then
        return 0, unitHealth
    else
        return F:Round(unitHealth / unitMaxHealth * 100, 1), unitHealth
    end
end

local _tags = {
    -- health value
    healthvalue = function(unit)
        if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
            return
        end

        local cur = UnitHealth(unit)
        local r, g, b = unpack(colors.reaction[UnitReaction(unit, 'player') or 5])

        return string.format('|cff%02x%02x%02x%s|r', r * 255, g * 255, b * 255, F:Numb(cur))
    end,
    -- health perc
    healthperc = function(unit)
        if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
            return
        end

        local cur, max = UnitHealth(unit), UnitHealthMax(unit)
        local r, g, b = F:ColorGradient(cur / max, unpack(colors.smooth))
        r, g, b = r * 255, g * 255, b * 255

        if cur ~= max then
            return string.format('|cff%02x%02x%02x%d%%|r', r, g, b, math.floor(cur / max * 100 + 0.5))
        end
    end,
    -- nameplate health
    nphp = function(unit)
        local per = GetUnitHealthPerc(unit)

        if per < 100 then
            return string.format('%s%%', per)
        end
    end,
    -- power value
    powervalue = function(unit)
        local cur, max = UnitPower(unit), UnitPowerMax(unit)
        if (cur == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then
            return
        end

        return F:Numb(cur)
    end,
    -- altpower perc
    altpowerperc = function(unit)
        local cur = UnitPower(unit, _G.ALTERNATE_POWER_INDEX)
        local max = UnitPowerMax(unit, _G.ALTERNATE_POWER_INDEX)

        if max > 0 and not UnitIsDeadOrGhost(unit) then
            return ('%s%%'):format(math.floor(cur / max * 100 + .5))
        end
    end,
    -- dead
    dead = function(unit)
        if UnitIsDeadOrGhost(unit) and UnitIsConnected(unit) then
            return '|cffd84343' .. _G.DEAD
        end
    end,
    -- offline
    offline = function(unit)
        if not UnitIsConnected(unit) then
            return '|cffcccccc' .. _G.PLAYER_OFFLINE
        end
    end,
    -- name
    name = function(unit)
        local shorten = C.DB.Unitframe.ShortenName
        local isTargted = (unit == 'targettarget' and UnitIsUnit('targettarget', 'player'))
        local isFocusTargeted = (unit == 'focustarget' and UnitIsUnit('focustarget', 'player'))
        local isNP = (unit:match('nameplate%d+$'))
        local isBoss = (unit:match('boss%d?$'))
        local num = GetLocale() == 'zhCN' and 8 or 10
        local numBoss = GetLocale() == 'zhCN' and 6 or 8
        local numTar = GetLocale() == 'zhCN' and 5 or 8
        local numNP = GetLocale() == 'zhCN' and 6 or 8
        local str = UnitName(unit)
        local newStr = AbbrName(str, num) or str

        if isTargted or isFocusTargeted then
            return '<' .. _G.YOU .. '>'
        elseif isNP then
            return shorten and F.ShortenString(newStr, numNP, true) or str
        elseif unit == 'targettarget' or unit == 'focus' or unit == 'focustarget' then
            return shorten and F.ShortenString(newStr, numTar, true) or str
        elseif isBoss then
            return shorten and F.ShortenString(newStr, numBoss, true) or str
        else
            return shorten and F.ShortenString(newStr, num, true) or str
        end
    end,
    -- party name
    partyname = function(unit)
        local showName = C.DB.Unitframe.GroupShowName
        local shorten = C.DB.Unitframe.ShortenName
        local str = UnitName(unit)
        local num = GetLocale() == 'zhCN' and 4 or 6

        if showName then
            return shorten and F.ShortenString(str, num) or str
        elseif not UnitIsConnected(unit) then
            return _G.PLAYER_OFFLINE
        elseif UnitIsDeadOrGhost(unit) and UnitIsConnected(unit) then
            return _G.DEAD
        else
            return
        end
    end,
    -- raid name
    raidname = function(unit)
        local showName = C.DB.Unitframe.GroupShowName
        local shorten = C.DB.Unitframe.ShortenName
        local str = UnitName(unit)
        local num = GetLocale() == 'zhCN' and 2 or 4

        if showName then
            return shorten and F.ShortenString(str, num) or str
        elseif not UnitIsConnected(unit) then
            return _G.PLAYER_OFFLINE
        elseif UnitIsDeadOrGhost(unit) and UnitIsConnected(unit) then
            return _G.DEAD
        else
            return
        end
    end,
    -- nameplate name
    npname = function(unit)
        local nameOnly = C.DB.Nameplate.NameOnlyMode
        local shorten = C.DB.Unitframe.ShortenName
        local num = GetLocale() == 'zhCN' and 6 or 10
        local str = UnitName(unit)
        local newStr = AbbrName(str, num) or str

        return shorten and not nameOnly and F.ShortenString(newStr, num, true) or str
    end,
    -- target name
    tarname = function(unit)
        local tarUnit = unit .. 'target'
        if UnitExists(tarUnit) then
            local tarClass = select(2, UnitClass(tarUnit))
            return '<' .. F:RGBToHex(colors.class[tarClass]) .. UnitName(tarUnit) .. '|r>'
        end
    end,
    -- name color
    color = function(unit)
        local class = select(2, UnitClass(unit))
        local reaction = UnitReaction(unit, 'player')
        local isOffline = not UnitIsConnected(unit)
        local isTapped = UnitIsTapDenied(unit)
        local isDead = UnitIsDeadOrGhost(unit)

        if (unit == 'targettarget' and UnitIsUnit('targettarget', 'player')) or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player')) then
            return F:RGBToHex(1, 0, 0)
        elseif isTapped or isOffline then
            return F:RGBToHex(colors.tapped)
        elseif isDead then
            return F:RGBToHex(1, 0, 0)
        elseif UnitIsPlayer(unit) then
            return F:RGBToHex(colors.class[class])
        elseif reaction then
            return F:RGBToHex(colors.reaction[reaction])
        else
            return F:RGBToHex(1, 1, 1)
        end
    end,
    -- nameplate title (name only mode)
    nptitle = function(unit)
        if UnitIsPlayer(unit) then
            return
        end

        F.ScanTip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
        F.ScanTip:SetUnit(unit)

        local title = _G[string.format('FreeUI_ScanTooltipTextLeft%d', GetCVarBool('colorblindmode') and 3 or 2)]:GetText()
        if title and not string.find(title, '^' .. _G.LEVEL) then
            return title
        end
    end,
    -- group role
    grouprole = function(unit)
        local role = UnitGroupRolesAssigned(unit)

        if role == 'TANK' then
            return '|cff3884ff#|r'
        elseif role == 'HEALER' then
            return '|cff2aff3d+|r'
        elseif role == 'DAMAGER' then
            return '|cffff0052*|r'
        end
    end,
    -- group leader
    groupleader = function(unit)
        local isLeader = (UnitInParty(unit) or UnitInRaid(unit)) and UnitIsGroupLeader(unit)

        return isLeader and '|cffffffff!|r'
    end,
    -- player resting
    resting = function(unit)
        if (unit == 'player' and IsResting()) then
            return '|cff2C8D51Zzz|r'
        end
    end,
    -- player PvP
    pvp = function(unit)
        if UnitIsPVP(unit) then
            return '|cffCC3300P|r'
        end
    end,
    classification = function(unit)
        local class, level = UnitClassification(unit), UnitLevel(unit)

        if (class == 'worldboss' or level == -1) then
            return '|cff9D2933' .. _G.BOSS .. '|r'
        elseif (class == 'rare') then
            return '|cffFF99FF' .. _G.RARE .. '|r'
        elseif (class == 'rareelite') then
            return '|cffFF0099' .. _G.RAREELITE .. '|r'
        elseif (class == 'elite') then
            return '|cffCC3300' .. _G.ELITE .. '|r'
        end
    end
}

for tag, func in next, _tags do
    tagMethods['free:' .. tag] = func
    tagEvents['free:' .. tag] = events[tag]
end

function UNITFRAME:CreateGroupLeaderTag(self)
    local font = C.Assets.Fonts.Pixel
    local text = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    text:SetPoint('TOPLEFT', 2, -2)

    self:Tag(text, '[free:groupleader]')
    self.GroupLeader = text
end

function UNITFRAME:CreateGroupRoleTag(self)
    local font = C.Assets.Fonts.Pixel
    local text = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    text:SetPoint('BOTTOM', 1, 1)

    self:Tag(text, '[free:grouprole]')
    self.GroupRole = text
end

function UNITFRAME:CreateGroupNameTag(self)
    local style = self.unitStyle
    local font = C.Assets.Fonts.Condensed
    local outline = _G.FREE_ADB.FontOutline
    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    if style == 'party' then
        self:Tag(text, '[free:color][free:partyname]')
    else
        self:Tag(text, '[free:color][free:raidname]')
    end

    self.GroupNameTag = text
end

function UNITFRAME:CreateNameTag(self)
    local font = C.Assets.Fonts.Condensed
    local style = self.unitStyle
    local isNP = style == 'nameplate'
    local outline = _G.FREE_ADB.FontOutline
    local boldFont = C.Assets.Fonts.Bold

    local text = F.CreateFS(self.Health, isNP and boldFont or font, 11, outline, nil, nil, outline or 'THICK')

    if style == 'target' then
        text:SetJustifyH('RIGHT')
        text:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
    elseif style == 'arena' or style == 'boss' then
        text:SetJustifyH('LEFT')
        text:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
    elseif style == 'nameplate' then
        text:SetJustifyH('CENTER')
        text:SetPoint('BOTTOM', self, 'TOP', 0, -3)
    else
        text:SetJustifyH('CENTER')
        text:SetPoint('BOTTOM', self, 'TOP', 0, 3)
    end

    if style == 'nameplate' then
        self:Tag(text, '[free:npname]')
    elseif style == 'arena' then
        self:Tag(text, '[free:color][free:name] [arenaspec]')
    else
        self:Tag(text, '[free:color][free:name]')
    end

    self.NameTag = text
end

function UNITFRAME:CreateHealthTag(self)
    local font = C.Assets.Fonts.Condensed
    local style = self.unitStyle
    local outline = _G.FREE_ADB.FontOutline

    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')
    text:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

    if style == 'target' then
        self:Tag(text, '[free:dead][free:offline][free:healthvalue] [free:healthperc]')
    elseif style == 'boss' then
        text:ClearAllPoints()
        text:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
        text:SetJustifyH('RIGHT')
        self:Tag(text, '[free:dead][free:healthvalue] [free:healthperc]')
    elseif style == 'arena' then
        text:ClearAllPoints()
        text:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
        text:SetJustifyH('RIGHT')
        self:Tag(text, '[free:dead][free:offline][free:healthvalue]')
    end

    self.HealthTag = text
end

function UNITFRAME:CreateAltPowerTag(self)
    local font = C.Assets.Fonts.Condensed
    local style = self.unitStyle
    local outline = _G.FREE_ADB.FontOutline

    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    if style == 'boss' then
        text:SetPoint('LEFT', self, 'RIGHT', 2, 0)
    else
        text:SetPoint('BOTTOM', self.Health, 'TOP', 0, 3)
    end

    self:Tag(text, '[free:altpowerperc]')

    self.AltPowerTag = text
end

local function Player_OnEnter(self)
    self.LeftTag:Show()
    self.RightTag:Show()
    self:UpdateTags()
end

local function Player_OnLeave(self)
    self.LeftTag:Hide()
    self.RightTag:Hide()
end

function UNITFRAME:CreatePlayerTags(self)
    local font = C.Assets.Fonts.Condensed
    local outline = _G.FREE_ADB.FontOutline

    local leftTag = F.CreateFS(self, font, 11, outline, nil, nil, outline or 'THICK')
    leftTag:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

    self:Tag(leftTag, '[free:healthvalue] [free:healthperc] [free:dead] [free:pvp] [free:resting]')

    local rightTag = F.CreateFS(self, font, 11, outline, nil, nil, outline or 'THICK')
    rightTag:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

    self:Tag(rightTag, '[powercolor][free:powervalue]')

    self.LeftTag = leftTag
    self.RightTag = rightTag

    if C.DB.Unitframe.HidePlayerTags then
        self.LeftTag:Hide()
        self.RightTag:Hide()
        self:HookScript('OnEnter', Player_OnEnter)
        self:HookScript('OnLeave', Player_OnLeave)
    end
end

function NAMEPLATE:CreateNameplateHealthTag(self)
    if not C.DB.Nameplate.HealthPerc then
        return
    end

    local font = C.Assets.Fonts.Condensed
    local outline = _G.FREE_ADB.FontOutline

    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')
    text:SetPoint('CENTER', self, 'BOTTOM')

    self:Tag(text, '[free:nphp]')

    self.HealthTag = text
end

function UNITFRAME:UpdateGroupTags()
    for _, frame in pairs(oUF.objects) do
        if frame.raidType == 'party' or frame.raidType == 'raid' then
            frame:UpdateTags()
        end
    end
end
