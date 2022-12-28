local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

UNITFRAME.Positions = {
    player = { 'CENTER', _G.UIParent, 'CENTER', 0, -180 },
    pet = { 'RIGHT', 'oUF_Player', 'LEFT', -6, 0 },
    target = { 'LEFT', _G.UIParent, 'CENTER', 120, -140 },
    tot = { 'LEFT', 'oUF_Target', 'RIGHT', 6, 0 },
    focus = { 'BOTTOM', _G.UIParent, 'BOTTOM', -240, 220 },
    tof = { 'TOPLEFT', 'oUF_Focus', 'TOPRIGHT', 6, 0 },
    boss = { 'CENTER', _G.UIParent, 'CENTER', 500, 0 },
    arena = { 'CENTER', _G.UIParent, 'CENTER', 500, 0 },
    party = { 'CENTER', _G.UIParent, 'CENTER', -330, 0 },
    raid = { 'TOPRIGHT', 'Minimap', 'TOPLEFT', -6, -42 },
    simple = { 'TOPLEFT', C.UI_GAP, -100 },
}

-- Utility

function UNITFRAME:GetHeightVal(bar, val1, val2, val3, val4, val5, val6, val7, val8, val9, val10)
    local style = bar.unitStyle
    if style == 'player' then
        return val1
    elseif style == 'pet' then
        return val2
    elseif style == 'target' then
        return val3
    elseif style == 'targettarget' then
        return val4
    elseif style == 'focus' then
        return val5
    elseif style == 'focustarget' then
        return val6
    elseif style == 'party' then
        return val7
    elseif style == 'raid' then
        return val8
    elseif style == 'boss' then
        return val9
    elseif style == 'arena' then
        return val10
    end
end

-- Backdrop

local function onEnter(self)
    UnitFrame_OnEnter(self)
    self.__highlight:Show()
end

local function onLeave(self)
    UnitFrame_OnLeave(self)
    self.__highlight:Hide()
end

function UNITFRAME:CreateBackdrop(self, onKeyDown)
    local hl = self:CreateTexture(nil, 'OVERLAY')
    hl:SetAllPoints()
    hl:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
    hl:SetTexCoord(0, 1, 0.5, 1)
    hl:SetVertexColor(0.6, 0.6, 0.6)
    hl:SetBlendMode('ADD')
    hl:Hide()

    self.__highlight = hl

    self:RegisterForClicks(onKeyDown and 'AnyDown' or 'AnyUp')
    self:HookScript('OnEnter', onEnter)
    self:HookScript('OnLeave', onLeave)

    local bg = F.SetBD(self)
    bg:SetBackdropBorderColor(0, 0, 0, 1)
    bg:SetFrameStrata('BACKGROUND')

    self.__bg = bg
    self.__sd = bg.__shadow
end

-- Target border

local function updateTargetBorder(self)
    if UnitIsUnit('target', self.unit) then
        self.__tarBorder:Show()
    else
        self.__tarBorder:Hide()
    end
end

function UNITFRAME:CreateTargetBorder(self)
    local sd = F.CreateBDFrame(self, 0)
    sd:SetBackdropBorderColor(1, 1, 1)
    -- sd:SetFrameLevel(self:GetFrameLevel() + 5)
    sd:Hide()

    self.__tarBorder = sd

    self:RegisterEvent('PLAYER_TARGET_CHANGED', updateTargetBorder, true)
    self:RegisterEvent('GROUP_ROSTER_UPDATE', updateTargetBorder, true)
end

-- Sound effect for target/focus changed

function UNITFRAME:PlayerTargetChanged()
    if UnitExists('target') and not C_PlayerInteractionManager.IsReplacingUnit() then
        if UnitIsEnemy('target', 'player') then
            PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
        elseif UnitIsFriend('target', 'player') then
            PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
        else
            PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
        end
    else
        PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
    end
end

function UNITFRAME:PlayerFocusChanged()
    if UnitExists('focus') and not C_PlayerInteractionManager.IsReplacingUnit() then
        if UnitIsEnemy('focus', 'player') then
            PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
        elseif UnitIsFriend('focus', 'player') then
            PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
        else
            PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
        end
    else
        PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
    end
end

function UNITFRAME:CreateTargetSound()
    F:RegisterEvent('PLAYER_TARGET_CHANGED', UNITFRAME.PlayerTargetChanged)
    F:RegisterEvent('PLAYER_FOCUS_CHANGED', UNITFRAME.PlayerFocusChanged)
end

-- Remove blizz raid frame

function UNITFRAME:RemoveBlizzRaidFrame()
    if _G.CompactPartyFrame then
        _G.CompactPartyFrame:UnregisterAllEvents()
    end

    CompactRaidFrameManager_SetSetting('IsShown', '0')
    _G.UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
    _G.CompactRaidFrameManager:UnregisterAllEvents()
    _G.CompactRaidFrameManager:SetParent(F.HiddenFrame)
end

-- Make sure the state of each element is reliable #TODO

function UNITFRAME:UpdateAllElements()
    UNITFRAME:UpdatePortrait()
    UNITFRAME:UpdateGCDTicker()
    UNITFRAME:UpdateAuras()
    UNITFRAME:UpdateFader()
    UNITFRAME:UpdateClassPower()
    UNITFRAME:UpdateRaidTargetIndicator()
end

function UNITFRAME:OnLogin()
    UNITFRAME:InitFilters()
    UNITFRAME:SpawnUnits()
    UNITFRAME:UpdateAllElements()
end
