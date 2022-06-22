local F, C, L = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local colors = oUF.colors
local tags = oUF.Tags
local tagMethods = tags.Methods
local tagEvents = tags.Events
-- local tagSharedEvents = tags.SharedEvents

local events = {
    healthvalue = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE',
    healthperc = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION UNIT_NAME_UPDATE',
    powervalue = 'UNIT_MAXPOWER UNIT_POWER_UPDATE UNIT_CONNECTION UNIT_DISPLAYPOWER',
    altpowerperc = 'UNIT_MAXPOWER UNIT_POWER_UPDATE',
    dead = 'UNIT_HEALTH',
    offline = 'UNIT_HEALTH UNIT_CONNECTION',
    ddg = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    name = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    groupname = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    npname = 'UNIT_NAME_UPDATE',
    tarname = 'UNIT_NAME_UPDATE UNIT_THREAT_SITUATION_UPDATE UNIT_HEALTH',
    color = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED',
    grouprole = 'PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE',
    groupleader = 'PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE',
    resting = 'PLAYER_UPDATE_RESTING',
    pvp = 'UNIT_FACTION',
}

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
    -- power value
    powervalue = function(unit)
        local cur, max = UnitPower(unit), UnitPowerMax(unit)
        if cur == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
            return
        end

        return F:Numb(cur)
    end,
    -- altpower perc
    altpowerperc = function(unit)
        local cur = UnitPower(unit, _G.ALTERNATE_POWER_INDEX)
        local max = UnitPowerMax(unit, _G.ALTERNATE_POWER_INDEX)

        if max > 0 and not UnitIsDeadOrGhost(unit) then
            return ('%s%%'):format(math.floor(cur / max * 100 + 0.5))
        end
    end,

    -- offline ghost dead
    ddg = function(unit)
        if not UnitIsConnected(unit) and GetNumArenaOpponentSpecs() == 0 then
            return '|cffcccccc' .. _G.PLAYER_OFFLINE .. '|r'
        elseif UnitIsGhost(unit) then
            return '|cffcccccc' .. L['Ghost'] .. '|r'
        elseif UnitIsDead(unit) then
            return '|cffcccccc' .. _G.DEAD .. '|r'
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
        local shorten = C.DB.Unitframe.AbbrName
        local isTargted = (unit == 'targettarget' and UnitIsUnit('targettarget', 'player'))
        local isFocusTargeted = (unit == 'focustarget' and UnitIsUnit('focustarget', 'player'))
        local isBoss = (unit:match('boss%d?$'))
        local num = GetLocale() == 'zhCN' and 8 or 10
        local numBoss = GetLocale() == 'zhCN' and 6 or 8
        local numTar = GetLocale() == 'zhCN' and 5 or 8
        local str = UnitName(unit)
        local newStr = F.AbbrNameString(str) or str

        if isTargted or isFocusTargeted then
            return '<' .. _G.YOU .. '>'
        elseif unit == 'targettarget' or unit == 'focus' or unit == 'focustarget' then
            return shorten and F.ShortenString(newStr, numTar, true) or str
        elseif isBoss then
            return shorten and F.ShortenString(newStr, numBoss, true) or str
        else
            return shorten and F.ShortenString(newStr, num, true) or str
        end
    end,
    -- group name
    groupname = function(unit)
        local isRaid = unit:match('raid(%d)')
        local showName = C.DB.Unitframe.GroupName
        local partyLength = C.DB.Unitframe.PartyNameLength
        local raidLength = C.DB.Unitframe.RaidNameLength
        local str = UnitName(unit)

        if showName then
            return F.ShortenString(str, isRaid and raidLength or partyLength)
        end
    end,
    -- target name
    tarname = function(unit)
        local tarUnit = unit .. 'target'
        if UnitExists(tarUnit) then
            local tarClass = select(2, UnitClass(tarUnit))
            return '<' .. F:RgbToHex(colors.class[tarClass]) .. UnitName(tarUnit) .. '|r>'
        end
    end,
    -- name color
    color = function(unit)
        local class = select(2, UnitClass(unit))
        local reaction = UnitReaction(unit, 'player')
        local isOffline = not UnitIsConnected(unit)
        local isTapped = UnitIsTapDenied(unit)
        local isDead = UnitIsDeadOrGhost(unit)

        if
            (unit == 'targettarget' and UnitIsUnit('targettarget', 'player'))
            or (unit == 'focustarget' and UnitIsUnit('focustarget', 'player'))
        then
            return F:RgbToHex(1, 0, 0)
        elseif isTapped or isOffline then
            return F:RgbToHex(colors.tapped)
        elseif isDead then
            return F:RgbToHex(1, 0, 0)
        elseif UnitIsPlayer(unit) then
            return F:RgbToHex(colors.class[class])
        elseif reaction then
            return F:RgbToHex(colors.reaction[reaction])
        else
            return F:RgbToHex(1, 1, 1)
        end
    end,

    -- group role
    grouprole = function(unit)
        local showRole = C.DB.Unitframe.GroupRole
        local role = UnitGroupRolesAssigned(unit)

        if not showRole then
            return
        elseif role == 'TANK' then
            return '|cff3884ff#|r'
        elseif role == 'HEALER' then
            return '|cff2aff3d+|r'
        elseif role == 'DAMAGER' then
            return '|cffff0052*|r'
        end
    end,
    -- group leader
    groupleader = function(unit)
        local showLeader = C.DB.Unitframe.GroupLeader
        local isLeader = (UnitInParty(unit) or UnitInRaid(unit)) and UnitIsGroupLeader(unit)

        if not showLeader then
            return
        else
            return isLeader and '|cffffffff!|r'
        end
    end,
    -- player resting
    resting = function(unit)
        if unit == 'player' and IsResting() then
            return '|cff2C8D51Zzz|r'
        end
    end,
    -- player PvP
    pvp = function(unit)
        if UnitIsPVP(unit) then
            return '|cffCC3300P|r'
        end
    end,
}

for tag, func in next, _tags do
    tagMethods['free:' .. tag] = func
    tagEvents['free:' .. tag] = events[tag]
end

function UNITFRAME:CreateGroupLeaderTag(self)
    local font = C.Assets.Font.Pixel
    local text = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    text:SetPoint('TOPLEFT', 2, -2)

    self:Tag(text, '[free:groupleader]')
    self.GroupLeader = text
end

function UNITFRAME:CreateGroupRoleTag(self)
    local font = C.Assets.Font.Pixel
    local text = F.CreateFS(self.Health, font, 8, 'OUTLINE, MONOCHROME')
    text:SetPoint('BOTTOM', 1, 1)

    self:Tag(text, '[free:grouprole]')
    self.GroupRole = text
end

function UNITFRAME:CreateGroupNameTag(self)
    local font = C.Assets.Font.Condensed
    local outline = _G.FREE_ADB.FontOutline
    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    self:Tag(text, '[free:color][free:groupname] [free:ddg]')

    self.GroupNameTag = text
end

function UNITFRAME:CreateNameTag(self)
    local font = C.Assets.Font.Condensed
    local style = self.unitStyle
    local outline = _G.FREE_ADB.FontOutline

    local text = F.CreateFS(self.Health, font, 11, outline, nil, nil, outline or 'THICK')

    if style == 'target' then
        text:SetJustifyH('RIGHT')
        text:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)
    elseif style == 'arena' or style == 'boss' then
        text:SetJustifyH('LEFT')
        text:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)
    else
        text:SetJustifyH('CENTER')
        text:SetPoint('BOTTOM', self, 'TOP', 0, 3)
    end

    if style == 'arena' then
        self:Tag(text, '[free:color][free:name] [arenaspec]')
    else
        self:Tag(text, '[free:color][free:name]')
    end

    self.NameTag = text
end



function UNITFRAME:CreateHealthTag(self)
    local font = C.Assets.Font.Condensed
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
    local font = C.Assets.Font.Condensed
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
    if C.DB.Unitframe.HidePlayerTags then
        self.LeftTag:Hide()
        self.RightTag:Hide()
    else
        self.LeftTag:Show()
        self.RightTag:Show()
    end
end

local function UpdatePlayerTags(self)
    if C.DB.Unitframe.HidePlayerTags then
        self.LeftTag:Hide()
        self.RightTag:Hide()
        self:HookScript('OnEnter', Player_OnEnter)
        self:HookScript('OnLeave', Player_OnLeave)
    else
        self.LeftTag:Show()
        self.RightTag:Show()
        self:HookScript('OnEnter', Player_OnEnter)
        self:HookScript('OnLeave', Player_OnLeave)
    end
end

function UNITFRAME:CreatePlayerTags(self)
    local font = C.Assets.Font.Condensed
    local outline = _G.FREE_ADB.FontOutline

    local leftTag = F.CreateFS(self, font, 11, outline, nil, nil, outline or 'THICK')
    leftTag:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 3)

    self:Tag(leftTag, '[free:healthvalue] [free:healthperc] [free:dead] [free:pvp] [free:resting]')

    local rightTag = F.CreateFS(self, font, 11, outline, nil, nil, outline or 'THICK')
    rightTag:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', 0, 3)

    self:Tag(rightTag, '[powercolor][free:powervalue]')

    self.LeftTag = leftTag
    self.RightTag = rightTag

    UpdatePlayerTags(self)
end



function UNITFRAME:UpdateUnitTags()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle ~= 'party' and frame.unitStyle ~= 'raid' then
            if frame.unitStyle == 'player' then
                UpdatePlayerTags(frame)
            end
            frame:UpdateTags()
        end
    end
end

function UNITFRAME:UpdateGroupTags()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'party' or frame.unitStyle == 'raid' then
            frame:UpdateTags()
        end
    end
end
