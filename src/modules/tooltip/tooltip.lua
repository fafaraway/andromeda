local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local npcIDstring = '%s ' .. C.INFO_COLOR .. '%s'
local blanchyFix = '|n%s+|n'

TOOLTIP.MountIDs = {}
local mountIDs = C_MountJournal.GetMountIDs()
for _, mountID in ipairs(mountIDs) do
    local _, spellID = C_MountJournal.GetMountInfoByID(mountID)
    TOOLTIP.MountIDs[spellID] = mountID
end

local classification = {
    elite = ' |cffcc8800' .. _G.ELITE .. '|r',
    rare = ' |cffff99cc' .. L['Rare'] .. '|r',
    rareelite = ' |cffff99cc' .. L['Rare'] .. '|r ' .. '|cffcc8800' .. _G.ELITE .. '|r',
    worldboss = ' |cffff0000' .. _G.BOSS .. '|r',
}

local function CanAccessObject(obj)
    return issecure() or not obj:IsForbidden()
end

function TOOLTIP:GetUnit()
    local data = self:GetTooltipData()
    local guid = data and data.guid
    local unit = guid and UnitTokenFromGUID(guid)

    return unit, guid
end

local FACTION_COLORS = {
    [_G.FACTION_ALLIANCE] = '|cff4080ff%s|r',
    [_G.FACTION_HORDE] = '|cffff5040%s|r',
}

function TOOLTIP:UpdateFactionLine(lineData)
    if self:IsForbidden() then
        return
    end

    if not self:IsTooltipType(Enum.TooltipDataType.Unit) then
        return
    end

    local linetext = lineData.leftText
    if linetext == _G.PVP then
        return true
    elseif FACTION_COLORS[linetext] then
        lineData.leftText = format(FACTION_COLORS[linetext], linetext)
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
        return F:RgbToHex(F:UnitColor(unit)) .. UnitName(unit) .. '|r'
    end
end

function TOOLTIP:OnTooltipCleared()
    if self:IsForbidden() then
        return
    end

    self.tipUpdate = 1
    self.tipUnit = nil

    _G.GameTooltip_ClearMoney(self)
    _G.GameTooltip_ClearStatusBars(self)
    _G.GameTooltip_ClearProgressBars(self)
    _G.GameTooltip_ClearWidgetSet(self)

    if self.StatusBar then
        self.StatusBar:ClearWatch()
    end
end

local function FadeOut(self)
    self:Hide()
end

local passedNames = {
    ['GetUnit'] = true,
    ['GetWorldCursor'] = true,
}
function TOOLTIP:RefreshLines()
    local getterName = self.info and self.info.getterName
    if passedNames[getterName] then
        TOOLTIP.OnTooltipSetUnit(self)
    end
end

function TOOLTIP:OnTooltipSetUnit()
    if self:IsForbidden() or self ~= _G.GameTooltip then
        return
    end

    if C.DB.Tooltip.HideInCombat and InCombatLockdown() and not C_PetBattles.IsInBattle() then
        if not IsShiftKeyDown() then
            self:Hide()
        end
        return
    end

    local unit, guid = TOOLTIP.GetUnit(self)
    if not unit or not UnitExists(unit) then
        return
    end
    self.tipUnit = unit

    local isAltKeyDown = IsAltKeyDown()
    local isPlayer = UnitIsPlayer(unit)
    if isPlayer then
        local name, realm = UnitName(unit)
        local pvpName = UnitPVPName(unit)
        local relationship = UnitRealmRelationship(unit)
        if not C.DB.Tooltip.HideTitle and pvpName then
            name = pvpName
        end
        if realm and realm ~= '' then
            if isAltKeyDown or not C.DB.Tooltip.HideRealm then
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

        local guildName, rank, _, guildRealm = GetGuildInfo(unit)
        local hasText = _G.GameTooltipTextLeft2:GetText()
        if guildName and hasText then
            local myGuild, _, _, myGuildRealm = GetGuildInfo('player')
            if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
                _G.GameTooltipTextLeft2:SetTextColor(0.25, 1, 0.25)
            else
                _G.GameTooltipTextLeft2:SetTextColor(0.6, 0.8, 1)
            end

            if C.DB.Tooltip.HideGuildRank then
                rank = ''
            end
            if guildRealm and isAltKeyDown then
                guildName = guildName .. '-' .. guildRealm
            end
            if not isAltKeyDown then
                if strlen(guildName) > 31 then
                    guildName = '...'
                end
            end
            _G.GameTooltipTextLeft2:SetText('<' .. guildName .. '> ' .. rank)
        end
    end

    local r, g, b = F:UnitColor(unit)
    local hexColor = F:RgbToHex(r, g, b)
    local text = _G.GameTooltipTextLeft1:GetText()
    if text then
        local ricon = GetRaidTargetIndex(unit)
        if ricon and ricon > 8 then
            ricon = nil
        end
        ricon = ricon and _G.ICON_LIST[ricon] .. '18|t ' or ''
        _G.GameTooltipTextLeft1:SetFormattedText('%s%s%s', ricon, hexColor, text)
    end

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
        local textLevel = format('%s%s%s|r', F:RgbToHex(diff), boss or format('%d', level), classification[classify] or '')
        local tiptextLevel = TOOLTIP.GetLevelLine(self)
        if tiptextLevel then
            local pvpFlag = isPlayer and UnitIsPVP(unit) and format(' |cffff0000%s|r', _G.PVP) or ''
            local unitClass = isPlayer and format('%s %s', UnitRace(unit) or '', hexColor .. (UnitClass(unit) or '') .. '|r') or UnitCreatureType(unit) or ''
            tiptextLevel:SetFormattedText('%s%s %s %s', textLevel, pvpFlag, unitClass, (not alive and '|cffCCCCCC' .. _G.DEAD .. '|r' or ''))
        end
    end

    if UnitExists(unit .. 'target') then
        local tarRicon = GetRaidTargetIndex(unit .. 'target')
        if tarRicon and tarRicon > 8 then
            tarRicon = nil
        end
        local tar = format('%s%s', (tarRicon and _G.ICON_LIST[tarRicon] .. '10|t') or '', TOOLTIP:GetTarget(unit .. 'target'))
        self:AddLine(C.INFO_COLOR .. _G.TARGET .. ':|r ' .. tar)
    end

    if not isPlayer and IsAltKeyDown() then
        local npcID = F:GetNpcId(guid)
        if npcID then
            local reaction = UnitReaction(unit, 'player')
            local standingText = reaction and hexColor .. _G['FACTION_STANDING_LABEL' .. reaction]
            self:AddLine(format(npcIDstring, standingText or '', npcID))
        end
    end

    TOOLTIP.InspectUnitSpecAndLevel(self, unit)
    TOOLTIP.AddMythicPlusScore(self, unit)
    TOOLTIP.ScanTargets(self, unit)
    TOOLTIP.AddCovenantInfo()
end

function TOOLTIP:GameTooltip_OnUpdate(elapsed)
    self.tipUpdate = (self.tipUpdate or 0) + elapsed
    if self.tipUpdate < 0.1 then
        return
    end
    if self.tipUnit and not UnitExists(self.tipUnit) then
        self:Hide()
        return
    end

    self.tipUpdate = 0
end

function TOOLTIP:RefreshStatusBar(value)
    if not self.text then
        local outline = _G.ANDROMEDA_ADB.FontOutline
        self.text = F.CreateFS(self, C.Assets.Fonts.Bold, 11, outline or nil, '', nil, outline and 'NONE' or 'THICK')
    end
    local unit = self.guid and UnitTokenFromGUID(self.guid)
    local unitHealthMax = unit and UnitHealthMax(unit)
    if unitHealthMax and unitHealthMax ~= 0 then
        --self.text:SetText(F.Numb(value * unitHealthMax) .. ' | ' .. F.Numb(unitHealthMax))
        self:SetStatusBarColor(F:UnitColor(unit))
    else
        --self.text:SetFormattedText('%d%%', value * 100)
    end
end

function TOOLTIP:ReskinStatusBar()
    self.StatusBar:ClearAllPoints()
    self.StatusBar:SetPoint('BOTTOMLEFT', _G.GameTooltip, 'TOPLEFT', 1, -4)
    self.StatusBar:SetPoint('BOTTOMRIGHT', _G.GameTooltip, 'TOPRIGHT', -1, -4)
    self.StatusBar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
    self.StatusBar:SetHeight(3)
    F.CreateBDFrame(self.StatusBar)
end

function TOOLTIP:GameTooltip_ShowStatusBar()
    if not self or not CanAccessObject(self) then
        return
    end
    if not self.statusBarPool then
        return
    end

    local bar = self.statusBarPool:GetNextActive()
    if bar and not bar.styled then
        F.StripTextures(bar)
        F.CreateBDFrame(bar, 0.25)
        bar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)

        bar.styled = true
    end
end

function TOOLTIP:GameTooltip_ShowProgressBar()
    if not self or not CanAccessObject(self) then
        return
    end
    if not self.progressBarPool then
        return
    end

    local bar = self.progressBarPool:GetNextActive()
    if bar and not bar.styled then
        F.StripTextures(bar.Bar)
        F.CreateBDFrame(bar.Bar, 0.25)
        bar.Bar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)

        bar.styled = true
    end
end

-- Add Targeted By line
local targetTable = {}
function TOOLTIP:ScanTargets(unit)
    if not C.DB.Tooltip.TargetedBy then
        return
    end
    if not IsInGroup() then
        return
    end

    if not UnitExists(unit) then
        return
    end

    wipe(targetTable)

    for i = 1, GetNumGroupMembers() do
        local member = (IsInRaid() and 'raid' .. i or 'party' .. i)
        if UnitIsUnit(unit, member .. 'target') and not UnitIsUnit('player', member) and not UnitIsDeadOrGhost(member) then
            local color = F:RgbToHex(F:UnitColor(member))
            local name = color .. UnitName(member) .. '|r'
            tinsert(targetTable, name)
        end
    end

    if #targetTable > 0 then
        _G.GameTooltip:AddLine(L['TargetedBy'] .. ': ' .. C.INFO_COLOR .. '(' .. #targetTable .. ')|r ' .. table.concat(targetTable, ', '), nil, nil, nil, 1)
    end
end

-- Add mount source
function TOOLTIP:SetUnitAura(unit, index, filter)
    if not self or not CanAccessObject(self) then
        return
    end
    local _, _, _, _, _, _, _, _, _, id = UnitAura(unit, index, filter)

    if id then
        local mountText
        if TOOLTIP.MountIDs[id] then
            local _, _, sourceText = C_MountJournal.GetMountInfoExtraByID(TOOLTIP.MountIDs[id])
            mountText = sourceText and gsub(sourceText, blanchyFix, '|n')

            if mountText then
                self:AddLine(' ')
                self:AddLine(mountText, 1, 1, 1)
            end
        end
    end
end

function TOOLTIP:MountSource()
    hooksecurefunc(_G.GameTooltip, 'SetUnitAura', TOOLTIP.SetUnitAura)
    hooksecurefunc(_G.GameTooltip, 'SetUnitBuff', TOOLTIP.SetUnitAura)
    hooksecurefunc(_G.GameTooltip, 'SetUnitDebuff', TOOLTIP.SetUnitAura)
end

-- Add mythic plus score
function TOOLTIP.GetDungeonScore(score)
    local color = C_ChallengeMode.GetDungeonScoreRarityColor(score) or _G.HIGHLIGHT_FONT_COLOR
    return color:WrapTextInColorCode(score)
end

function TOOLTIP:AddMythicPlusScore(unit)
    if not C.DB.Tooltip.MythicPlusScore then
        return
    end

    if C.DB.Tooltip.PlayerInfoByAlt and not IsAltKeyDown() then
        return
    end

    local summary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary(unit)
    local score = summary and summary.currentSeasonScore
    if score and score > 0 then
        _G.GameTooltip:AddLine(format('%s:|r %s', C.INFO_COLOR .. _G.DUNGEON_SCORE, TOOLTIP.GetDungeonScore(score)))
    end
end

-- Fix
function TOOLTIP:FixStoneSoupError()
    local blockTooltips = {
        [556] = true, -- Stone Soup
    }
    hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, 'Setup', function(self)
        if self:IsForbidden() and blockTooltips[self.widgetSetID] and self.Bar then
            self.Bar.tooltip = nil
        end
    end)
end

-- Reanchor and movable
local mover
function TOOLTIP:GameTooltip_SetDefaultAnchor(parent)
    if not CanAccessObject(self) then
        return
    end
    if not parent then
        return
    end

    if C.DB.Tooltip.FollowCursor then
        self:SetOwner(parent, 'ANCHOR_CURSOR_RIGHT')
    else
        if not mover then
            mover = F.Mover(self, L['Tooltip'], 'GameTooltip', { 'BOTTOMRIGHT', _G.UIParent, 'BOTTOMRIGHT', -C.UI_GAP, 260 }, 240, 120)
        end
        self:SetOwner(parent, 'ANCHOR_NONE')
        self:ClearAllPoints()
        self:SetPoint('BOTTOMRIGHT', mover)
    end
end

function TOOLTIP:ResetUnit(btn)
    if (btn == 'LSHIFT' or btn == 'LALT') and UnitExists('mouseover') then
        _G.GameTooltip:RefreshData()
    end
end

function TOOLTIP:OnLogin()
    if not C.DB.Tooltip.Enable then
        return
    end

    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, TOOLTIP.OnTooltipSetUnit)
    hooksecurefunc(_G.GameTooltip.StatusBar, 'SetValue', TOOLTIP.RefreshStatusBar)
    _G.TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, TOOLTIP.UpdateFactionLine)
    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, TOOLTIP.FixRecipeItemNameWidth)

    hooksecurefunc('GameTooltip_ShowStatusBar', TOOLTIP.GameTooltip_ShowStatusBar)
    hooksecurefunc('GameTooltip_ShowProgressBar', TOOLTIP.GameTooltip_ShowProgressBar)
    hooksecurefunc('GameTooltip_SetDefaultAnchor', TOOLTIP.GameTooltip_SetDefaultAnchor)

    _G.GameTooltip:HookScript('OnTooltipCleared', TOOLTIP.OnTooltipCleared)
    _G.GameTooltip:HookScript('OnUpdate', TOOLTIP.GameTooltip_OnUpdate)
    _G.GameTooltip.FadeOut = FadeOut

    TOOLTIP:ReskinTipIcon()
    TOOLTIP:SetupFonts()
    TOOLTIP:AddIDs()
    TOOLTIP:ItemInfo()
    TOOLTIP:MountSource()
    TOOLTIP:HyperLink()
    TOOLTIP:CovenantInfo()
    TOOLTIP:Achievement()
    TOOLTIP:AzeriteArmor()
    TOOLTIP:ParagonRewards()
    TOOLTIP:FixStoneSoupError()

    F:RegisterEvent('MODIFIER_STATE_CHANGED', TOOLTIP.ResetUnit)
end
