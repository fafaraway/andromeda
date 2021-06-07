local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local wipe = wipe
local format = format
local tconcat = table.concat
local strfind = strfind
local strupper = strupper
local GetMouseFocus = GetMouseFocus
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName
local InCombatLockdown = InCombatLockdown
local IsShiftKeyDown = IsShiftKeyDown
local UnitExists = UnitExists
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitIsPlayer = UnitIsPlayer
local UnitPVPName = UnitPVPName
local UnitRealmRelationship = UnitRealmRelationship
local UnitIsDND = UnitIsDND
local UnitIsAFK = UnitIsAFK
local GetGuildInfo = GetGuildInfo
local IsInGuild = IsInGuild
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsWildBattlePet = UnitIsWildBattlePet
local UnitIsBattlePetCompanion = UnitIsBattlePetCompanion
local UnitBattlePetLevel = UnitBattlePetLevel
local UnitLevel = UnitLevel
local GetCreatureDifficultyColor = GetCreatureDifficultyColor
local UnitClassification = UnitClassification
local UnitIsPVP = UnitIsPVP
local UnitRace = UnitRace
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local hooksecurefunc = hooksecurefunc
local UnitClass = UnitClass
local UnitCreatureType = UnitCreatureType
local UnitIsConnected = UnitIsConnected

local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:RegisterModule('Tooltip')

_G.ITEM_CREATED_BY = '' -- Remove creator name

local targetTable = {}
local classification = {
    elite = ' |cffcc8800' .. _G.ELITE .. '|r',
    rare = ' |cffff99cc' .. L['Rare'] .. '|r',
    rareelite = ' |cffff99cc' .. L['Rare'] .. '|r ' .. '|cffcc8800' .. _G.ELITE .. '|r',
    worldboss = ' |cffff0000' .. _G.BOSS .. '|r'
}

function TOOLTIP:GetUnit()
    local _, unit = self and self:GetUnit()
    if not unit then
        local mFocus = GetMouseFocus()
        unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute('unit'))) or 'mouseover'
    end
    return unit
end

function TOOLTIP:HideLines()
    for i = 3, self:NumLines() do
        local tiptext = _G['GameTooltipTextLeft' .. i]
        local linetext = tiptext:GetText()
        if linetext then
            if linetext == _G.PVP then
                tiptext:SetText(nil)
                tiptext:Hide()
            elseif linetext == _G.FACTION_HORDE then
                tiptext:SetText(nil)
                tiptext:Hide()
            elseif linetext == _G.FACTION_ALLIANCE then
                tiptext:SetText(nil)
                tiptext:Hide()
            end
        end
    end
end

function TOOLTIP:GetLevelLine()
    for i = 2, self:NumLines() do
        local tiptext = _G['GameTooltipTextLeft' .. i]
        local linetext = tiptext:GetText()
        if linetext and strfind(linetext, _G.LEVEL) then
            return tiptext
        end
    end
end

function TOOLTIP:GetTarget(unit)
    if UnitIsUnit(unit, 'player') then
        return format('|cffff0000%s|r', '>' .. strupper(_G.YOU) .. '<')
    else
        return F:RGBToHex(F:UnitColor(unit)) .. UnitName(unit) .. '|r'
    end
end

function TOOLTIP:OnTooltipSetUnit()
    if self:IsForbidden() then
        return
    end
    if C.DB.Tooltip.HideInCombat and InCombatLockdown() then
        self:Hide()
        return
    end

    TOOLTIP.HideLines(self)

    local unit = TOOLTIP.GetUnit(self)
    local isShiftKeyDown = IsShiftKeyDown()
    if UnitExists(unit) then
        self.tipUnit = unit
        local hexColor = F:RGBToHex(F:UnitColor(unit))
        local ricon = GetRaidTargetIndex(unit)
        local text = _G.GameTooltipTextLeft1:GetText()
        if ricon and ricon > 8 then
            ricon = nil
        end
        if ricon and text then
            _G.GameTooltipTextLeft1:SetFormattedText(('%s %s'), _G.ICON_LIST[ricon] .. '18|t', text)
        end

        local isPlayer = UnitIsPlayer(unit)
        if isPlayer then
            local name, realm = UnitName(unit)
            local pvpName = UnitPVPName(unit)
            local relationship = UnitRealmRelationship(unit)
            if not C.DB.Tooltip.HideTitle and pvpName then
                name = pvpName
            end
            if realm and realm ~= '' then
                if isShiftKeyDown or not C.DB.Tooltip.HideRealm then
                    name = name .. '-' .. realm
                elseif relationship == _G.LE_REALM_RELATION_COALESCED then
                    name = name .. _G.FOREIGN_SERVER_LABEL
                elseif relationship == _G.LE_REALM_RELATION_VIRTUAL then
                    name = name .. _G.INTERACTIVE_SERVER_LABEL
                end
            end

            local status = (UnitIsAFK(unit) and _G.AFK) or (UnitIsDND(unit) and _G.DND) or (not UnitIsConnected(unit) and _G.PLAYER_OFFLINE)
            if status then
                status = format(' |cffffcc00[%s]|r', status)
            end
            _G.GameTooltipTextLeft1:SetFormattedText('%s', name .. (status or ''))

            local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
            local hasText = _G.GameTooltipTextLeft2:GetText()
            if guildName and hasText then
                local myGuild, _, _, myGuildRealm = GetGuildInfo('player')
                if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
                    _G.GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
                else
                    _G.GameTooltipTextLeft2:SetTextColor(.6, .8, 1)
                end

                rankIndex = rankIndex + 1
                if C.DB.Tooltip.HideGuildRank then
                    rank = ''
                end
                if guildRealm and isShiftKeyDown then
                    guildName = guildName .. '-' .. guildRealm
                end
                --[[ if cfg.hideJunkGuild and not isShiftKeyDown then
                    if strlen(guildName) > 31 then guildName = '...' end
                end ]]
                _G.GameTooltipTextLeft2:SetText('<' .. guildName .. '> ' .. rank)
            end
        end

        local line1 = _G.GameTooltipTextLeft1:GetText()
        _G.GameTooltipTextLeft1:SetFormattedText('%s', hexColor .. line1)

        local alive = not UnitIsDeadOrGhost(unit)
        local level
        if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
            level = UnitBattlePetLevel(unit)
        else
            level = UnitLevel(unit)
        end

        if level then
            local boss
            if level == -1 then
                boss = '|cffff0000??|r'
            end

            local diff = GetCreatureDifficultyColor(level)
            local classify = UnitClassification(unit)
            local textLevel = format('%s%s%s|r', F:RGBToHex(diff), boss or format('%d', level), classification[classify] or '')
            local tiptextLevel = TOOLTIP.GetLevelLine(self)
            if tiptextLevel then
                local pvpFlag = isPlayer and UnitIsPVP(unit) and format(' |cffff0000%s|r', _G.PVP) or ''
                local unitClass = isPlayer and format('%s %s', UnitRace(unit) or '', hexColor .. (UnitClass(unit) or '') .. '|r') or UnitCreatureType(unit) or ''
                tiptextLevel:SetFormattedText(('%s%s %s %s'), textLevel, pvpFlag, unitClass, (not alive and '|cffCCCCCC' .. _G.DEAD .. '|r' or ''))
            end
        end

        if UnitExists(unit .. 'target') then
            local tarRicon = GetRaidTargetIndex(unit .. 'target')
            if tarRicon and tarRicon > 8 then
                tarRicon = nil
            end
            local tar = format('%s%s', (tarRicon and _G.ICON_LIST[tarRicon] .. '10|t') or '', TOOLTIP:GetTarget(unit .. 'target'))
            self:AddLine(_G.TARGET .. ': ' .. tar)
        end

        if alive then
            self.StatusBar:SetStatusBarColor(F:UnitColor(unit))
        else
            self.StatusBar:Hide()
        end
    else
        self.StatusBar:SetStatusBarColor(0, .9, 0)
    end

    TOOLTIP.InspectUnitSpecAndLevel(self)
end

function TOOLTIP:OnTooltipCleared()
    self.tipUpdate = 1
    self.tipUnit = nil
end

function TOOLTIP:GameTooltip_OnUpdate(elapsed)
    self.tipUpdate = (self.tipUpdate or 0) + elapsed
    if (self.tipUpdate < .1) then
        return
    end
    if (self.tipUnit and not UnitExists(self.tipUnit)) then
        self:Hide()
        return
    end
    local color = _G.FREE_ADB.BackdropColor
    local alpha = _G.FREE_ADB.BackdropAlpha
    self:SetBackdropColor(color.r, color.g, color.b, alpha)
    self.tipUpdate = 0
end

function TOOLTIP:StatusBar_OnValueChanged(value)
    if not C.DB.Tooltip.HealthValue then
        return
    end

    if self:IsForbidden() or not value then
        return
    end

    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end

    if not self.text then
        self.text = F.CreateFS(self, C.Assets.Fonts.Bold, 11, nil, '')
    end

    if value > 0 and max == 1 then
        self.text:SetFormattedText('%d%%', value * 100)
    else
        self.text:SetText(F:Numb(value) .. ' | ' .. F:Numb(max))
    end
end

function TOOLTIP:ReskinStatusBar()
    self.StatusBar:ClearAllPoints()
    self.StatusBar:SetPoint('BOTTOMLEFT', _G.GameTooltip, 'TOPLEFT', 1, -4)
    self.StatusBar:SetPoint('BOTTOMRIGHT', _G.GameTooltip, 'TOPRIGHT', -1, -4)
    self.StatusBar:SetStatusBarTexture(C.Assets.statusbar_tex)
    self.StatusBar:SetHeight(3)
    F.CreateBDFrame(self.StatusBar)
end

function TOOLTIP:GameTooltip_ShowStatusBar()
    if not self or self:IsForbidden() then
        return
    end
    if not self.statusBarPool then
        return
    end

    local bar = self.statusBarPool:GetNextActive()
    if bar and not bar.styled then
        F.StripTextures(bar)
        F.CreateBDFrame(bar, .25)
        bar:SetStatusBarTexture(C.Assets.statusbar_tex)

        bar.styled = true
    end
end

function TOOLTIP:GameTooltip_ShowProgressBar()
    if not self or self:IsForbidden() then
        return
    end
    if not self.progressBarPool then
        return
    end

    local bar = self.progressBarPool:GetNextActive()
    if bar and not bar.styled then
        F.StripTextures(bar.Bar)
        F.CreateBDFrame(bar.Bar, .25)
        bar.Bar:SetStatusBarTexture(C.Assets.statusbar_tex)

        bar.styled = true
    end
end

function TOOLTIP:ScanTargets()
    if not IsInGroup() then
        return
    end

    local _, unit = self:GetUnit()
    if not UnitExists(unit) then
        return
    end

    wipe(targetTable)

    for i = 1, GetNumGroupMembers() do
        local member = (IsInRaid() and 'raid' .. i or 'party' .. i)
        if UnitIsUnit(unit, member .. 'target') and not UnitIsUnit('player', member) and not UnitIsDeadOrGhost(member) then
            local color = F:RGBToHex(F:UnitColor(member))
            local name = color .. UnitName(member) .. '|r'
            tinsert(targetTable, name)
        end
    end

    if #targetTable > 0 then
        _G.GameTooltip:AddLine(L['TargetedBy'] .. ': ' .. C.InfoColor .. '(' .. #targetTable .. ')|r ' .. tconcat(targetTable, ', '), nil, nil, nil, 1)
    end
end

function TOOLTIP:TargetedInfo()
    if not C.DB.Tooltip.TargetBy then
        return
    end

    _G.GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.ScanTargets)
end

-- Fix comparison position
function TOOLTIP:GameTooltip_ComparisonFix(anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
    local point = shoppingTooltip1:GetPoint(2)
    if secondaryItemShown then
        if point == 'TOP' then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint('TOPLEFT', anchorFrame, 'TOPRIGHT', 4, 0)
            shoppingTooltip2:ClearAllPoints()
            shoppingTooltip2:SetPoint('TOPLEFT', shoppingTooltip1, 'TOPRIGHT', 4, 0)
        elseif point == 'RIGHT' then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint('TOPRIGHT', anchorFrame, 'TOPLEFT', -4, 0)
            shoppingTooltip2:ClearAllPoints()
            shoppingTooltip2:SetPoint('TOPRIGHT', shoppingTooltip1, 'TOPLEFT', -4, 0)
        end
    else
        if point == 'LEFT' then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint('TOPLEFT', anchorFrame, 'TOPRIGHT', 4, 0)
        elseif point == 'RIGHT' then
            shoppingTooltip1:ClearAllPoints()
            shoppingTooltip1:SetPoint('TOPRIGHT', anchorFrame, 'TOPLEFT', -4, 0)
        end
    end
end

local mover
function TOOLTIP:GameTooltip_SetDefaultAnchor(parent)
    if self:IsForbidden() then
        return
    end
    if not parent then
        return
    end

    if C.DB.Tooltip.FollowCursor then
        self:SetOwner(parent, 'ANCHOR_CURSOR_RIGHT')
    else
        if not mover then
            mover = F.Mover(self, L['Tooltip'], 'GameTooltip', {'BOTTOMRIGHT', _G.UIParent, 'BOTTOMRIGHT', -C.UIGap, 260}, 240, 120)
        end
        self:SetOwner(parent, 'ANCHOR_NONE')
        self:ClearAllPoints()
        self:SetPoint('BOTTOMRIGHT', mover)
    end
end

function TOOLTIP:OnLogin()
    if not C.DB.Tooltip.Enable then
        return
    end

    _G.GameTooltip.StatusBar = _G.GameTooltipStatusBar

    _G.GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.OnTooltipSetUnit)
    _G.GameTooltip.StatusBar:SetScript('OnValueChanged', TOOLTIP.StatusBar_OnValueChanged)
    hooksecurefunc('GameTooltip_ShowStatusBar', TOOLTIP.GameTooltip_ShowStatusBar)
    hooksecurefunc('GameTooltip_ShowProgressBar', TOOLTIP.GameTooltip_ShowProgressBar)
    hooksecurefunc('GameTooltip_SetDefaultAnchor', TOOLTIP.GameTooltip_SetDefaultAnchor)
    hooksecurefunc('SharedTooltip_SetBackdropStyle', TOOLTIP.SharedTooltip_SetBackdropStyle)
    hooksecurefunc('GameTooltip_AnchorComparisonTooltips', TOOLTIP.GameTooltip_ComparisonFix)

    if C.DB.Tooltip.DisableFading then
        _G.GameTooltip:HookScript('OnTooltipCleared', TOOLTIP.OnTooltipCleared)
        _G.GameTooltip:HookScript('OnUpdate', TOOLTIP.GameTooltip_OnUpdate)
        _G.GameTooltip.FadeOut = function(self)
            self:Hide()
        end
    end

    TOOLTIP:SetTooltipFonts()
    TOOLTIP:ReskinTooltipIcons()
    TOOLTIP:LinkHover()
    TOOLTIP:ExtraInfo()
    TOOLTIP:TargetedInfo()
    TOOLTIP:ConduitCollectionData()
    TOOLTIP:Achievement()
end
