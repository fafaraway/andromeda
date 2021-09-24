local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local targetTable = {}
local classification = {
    elite = ' |cffcc8800' .. _G.ELITE .. '|r',
    rare = ' |cffff99cc' .. L['Rare'] .. '|r',
    rareelite = ' |cffff99cc' .. L['Rare'] .. '|r ' .. '|cffcc8800' .. _G.ELITE .. '|r',
    worldboss = ' |cffff0000' .. _G.BOSS .. '|r'
}

function TOOLTIP:GetUnit()
    local unit =
        (select(2, _G.GameTooltip:GetUnit())) or (GetMouseFocus() and GetMouseFocus().GetAttribute and GetMouseFocus():GetAttribute('unit')) or (UnitExists('mouseover') and 'mouseover') or nil
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
        if linetext and string.find(linetext, _G.LEVEL) then
            return tiptext
        end
    end
end

function TOOLTIP:GetTarget(unit)
    if UnitIsUnit(unit, 'player') then
        return string.format('|cffff0000%s|r', '>' .. string.upper(_G.YOU) .. '<')
    else
        return F:RGBToHex(F:UnitColor(unit)) .. UnitName(unit) .. '|r'
    end
end

function TOOLTIP:ScanTargetsInfo()
    if not IsInGroup() then
        return
    end

    local _, unit = self:GetUnit()
    if not UnitExists(unit) then
        return
    end

    table.wipe(targetTable)

    for i = 1, GetNumGroupMembers() do
        local member = (IsInRaid() and 'raid' .. i or 'party' .. i)
        if UnitIsUnit(unit, member .. 'target') and not UnitIsUnit('player', member) and not UnitIsDeadOrGhost(member) then
            local color = F:RGBToHex(F:UnitColor(member))
            local name = color .. UnitName(member) .. '|r'
            table.insert(targetTable, name)
        end
    end

    if #targetTable > 0 then
        _G.GameTooltip:AddLine(L['TargetBy'] .. ': ' .. C.InfoColor .. '(' .. #targetTable .. ')|r ' .. table.concat(targetTable, ', '), nil, nil, nil, 1)
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
                status = string.format(' |cffffcc00[%s]|r', status)
            end
            _G.GameTooltipTextLeft1:SetFormattedText('%s', name .. (status or ''))

            local guildName, rank, _, guildRealm = GetGuildInfo(unit)
            local hasText = _G.GameTooltipTextLeft2:GetText()
            if guildName and hasText then
                local myGuild, _, _, myGuildRealm = GetGuildInfo('player')
                if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
                    _G.GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
                else
                    _G.GameTooltipTextLeft2:SetTextColor(.6, .8, 1)
                end

                if C.DB.Tooltip.HideGuildRank then
                    rank = ''
                end
                if guildRealm and isShiftKeyDown then
                    guildName = guildName .. '-' .. guildRealm
                end
                if not isShiftKeyDown then
                    if string.len(guildName) > 31 then
                        guildName = '...'
                    end
                end
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

            local diff = _G.GetCreatureDifficultyColor(level)
            local classify = UnitClassification(unit)
            local textLevel = string.format('%s%s%s|r', F:RGBToHex(diff), boss or string.format('%d', level), classification[classify] or '')
            local tiptextLevel = TOOLTIP.GetLevelLine(self)
            if tiptextLevel then
                local pvpFlag = isPlayer and UnitIsPVP(unit) and string.format(' |cffff0000%s|r', _G.PVP) or ''
                local unitClass = isPlayer and string.format('%s %s', UnitRace(unit) or '', hexColor .. (UnitClass(unit) or '') .. '|r') or UnitCreatureType(unit) or ''
                tiptextLevel:SetFormattedText(('%s%s %s %s'), textLevel, pvpFlag, unitClass, (not alive and '|cffCCCCCC' .. _G.DEAD .. '|r' or ''))
            end
        end

        if UnitExists(unit .. 'target') then
            local tarRicon = GetRaidTargetIndex(unit .. 'target')
            if tarRicon and tarRicon > 8 then
                tarRicon = nil
            end
            local tar = string.format('%s%s', (tarRicon and _G.ICON_LIST[tarRicon] .. '10|t') or '', TOOLTIP:GetTarget(unit .. 'target'))
            self:AddLine(_G.TARGET .. ': ' .. tar)
        end

        self.StatusBar:SetStatusBarColor(F:UnitColor(unit))

        TOOLTIP.InspectUnitSpecAndLevel(self, unit)
        TOOLTIP.AddPvEProgress()
    else
        self.StatusBar:SetStatusBarColor(0, .9, 0)
    end
end

function TOOLTIP:OnTooltipCleared()
    self.tipUpdate = 1
    self.tipUnit = nil

    _G.GameTooltip_ClearMoney(self)
    _G.GameTooltip_ClearStatusBars(self)
    _G.GameTooltip_ClearProgressBars(self)
    _G.GameTooltip_ClearWidgetSet(self)
end

function TOOLTIP.GetDungeonScore(score)
    local color = C_ChallengeMode.GetDungeonScoreRarityColor(score) or _G.HIGHLIGHT_FONT_COLOR
    return color:WrapTextInColorCode(score)
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

function TOOLTIP:AuraSource(...)
    local unitCaster = select(7, UnitAura(...))
    if unitCaster then
        local name = GetUnitName(unitCaster, true)
        local hexColor = F:RGBToHex(F:UnitColor(unitCaster))
        self:AddDoubleLine(L['CastBy'] .. ':', hexColor .. name)
        self:Show()
    end
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
    if not C.IsNewPatch then
        hooksecurefunc('SharedTooltip_SetBackdropStyle', TOOLTIP.SharedTooltip_SetBackdropStyle)
    end
    hooksecurefunc('GameTooltip_AnchorComparisonTooltips', TOOLTIP.GameTooltip_ComparisonFix)

    if C.DB.Tooltip.DisableFading then
        _G.GameTooltip:HookScript('OnTooltipCleared', TOOLTIP.OnTooltipCleared)
        _G.GameTooltip:HookScript('OnUpdate', TOOLTIP.GameTooltip_OnUpdate)
        _G.GameTooltip.FadeOut = function(self)
            self:Hide()
        end
    end

    if C.DB.Tooltip.TargetBy then
        _G.GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.ScanTargetsInfo)
    end

    TOOLTIP:SetTooltipFonts()
    _G.GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.FixRecipeItemNameWidth)

    hooksecurefunc(_G.GameTooltip, 'SetUnitAura', TOOLTIP.AuraSource)

    TOOLTIP:ReskinTooltipIcons()
    TOOLTIP:LinkHover()
    TOOLTIP:ItemInfo()
    TOOLTIP:ExtraInfo()
    TOOLTIP:ConduitCollectionData()
    TOOLTIP:DominationRank()
    TOOLTIP:Achievement()
    TOOLTIP:AzeriteArmor()
    TOOLTIP:MountSource()
end
