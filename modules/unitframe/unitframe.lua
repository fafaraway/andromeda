local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

UNITFRAME.Positions = {
    player = { 'CENTER', UIParent, 'CENTER', 0, -180 },
    pet = { 'RIGHT', 'oUF_Player', 'LEFT', -6, 0 },
    target = { 'LEFT', UIParent, 'CENTER', 120, -140 },
    tot = { 'LEFT', 'oUF_Target', 'RIGHT', 6, 0 },
    focus = { 'BOTTOM', UIParent, 'BOTTOM', -240, 220 },
    tof = { 'TOPLEFT', 'oUF_Focus', 'TOPRIGHT', 6, 0 },
    boss = { 'CENTER', UIParent, 'CENTER', 500, 0 },
    arena = { 'CENTER', UIParent, 'CENTER', 500, 0 },
    party = { 'CENTER', UIParent, 'CENTER', -330, 0 },
    raid = { 'TOPRIGHT', 'Minimap', 'TOPLEFT', -6, -42 },
    simple = { 'TOPLEFT', C.UI_GAP, -100 },
}

-- Backdrop

local function UF_OnEnter(self)
    UnitFrame_OnEnter(self)
    self.Highlight:Show()
end

local function UF_OnLeave(self)
    UnitFrame_OnLeave(self)
    self.Highlight:Hide()
end

function UNITFRAME:CreateBackdrop(self, onKeyDown)
    local highlight = self:CreateTexture(nil, 'OVERLAY')
    highlight:SetAllPoints()
    highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
    highlight:SetTexCoord(0, 1, 0.5, 1)
    highlight:SetVertexColor(0.6, 0.6, 0.6)
    highlight:SetBlendMode('BLEND')
    highlight:Hide()
    self.Highlight = highlight

    self:RegisterForClicks(onKeyDown and 'AnyDown' or 'AnyUp')
    self:HookScript('OnEnter', UF_OnEnter)
    self:HookScript('OnLeave', UF_OnLeave)

    self.backdrop = F.SetBD(self, 0)
    if C.DB.Unitframe.InvertedColorMode then
        self.backdrop:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    else
        self.backdrop:SetBackdropColor(0.1, 0.1, 0.1, 0)
    end
    self.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
    self.backdrop:SetFrameStrata('BACKGROUND')
    self.shadow = self.backdrop.__shadow
end

-- Selected border

local function UpdateSelectedBorder(self)
    if UnitIsUnit('target', self.unit) then
        self.Border:Show()
    else
        self.Border:Hide()
    end
end

function UNITFRAME:CreateSelectedBorder(self)
    local border = F.CreateBDFrame(self)
    border:SetBackdropBorderColor(1, 1, 1, 1)
    border:SetBackdropColor(0, 0, 0, 0)
    border:SetFrameLevel(self:GetFrameLevel() + 5)
    border:Hide()

    self.Border = border
    self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
    self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end

-- Sound effect for target/focus changed

function UNITFRAME:PLAYER_TARGET_CHANGED()
    if UnitExists('target') then
        if UnitIsEnemy('target', 'player') then
            PlaySound(873)
        elseif UnitIsFriend('target', 'player') then
            PlaySound(867)
        else
            PlaySound(871)
        end
    else
        PlaySound(684)
    end
end

function UNITFRAME:PLAYER_FOCUS_CHANGED()
    if UnitExists('focus') then
        if UnitIsEnemy('focus', 'player') then
            PlaySound(873)
        elseif UnitIsFriend('focus', 'player') then
            PlaySound(867)
        else
            PlaySound(871)
        end
    else
        PlaySound(684)
    end
end

function UNITFRAME:CreateTargetSound()
    F:RegisterEvent('PLAYER_TARGET_CHANGED', UNITFRAME.PLAYER_TARGET_CHANGED)
    F:RegisterEvent('PLAYER_FOCUS_CHANGED', UNITFRAME.PLAYER_FOCUS_CHANGED)
end

-- Remove blizz raid frame

local function HideBlizzPartyFrame(baseName, doNotReparent)
    local frame = _G[baseName]

    if frame then
        frame:UnregisterAllEvents()
        frame:Hide()

        if not doNotReparent then
            frame:SetParent(F.HiddenFrame)
        end

        local health = frame.healthBar or frame.healthbar
        if health then
            health:UnregisterAllEvents()
        end

        local power = frame.manabar
        if power then
            power:UnregisterAllEvents()
        end

        local spell = frame.castBar or frame.spellbar
        if spell then
            spell:UnregisterAllEvents()
        end

        local altpowerbar = frame.powerBarAlt
        if altpowerbar then
            altpowerbar:UnregisterAllEvents()
        end

        local buffFrame = frame.BuffFrame
        if buffFrame then
            buffFrame:UnregisterAllEvents()
        end
    end
end

function UNITFRAME:RemoveBlizzRaidFrame()
    -- raid
    CompactRaidFrameManager_SetSetting('IsShown', '0')
    UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
    CompactRaidFrameManager:UnregisterAllEvents()
    CompactRaidFrameManager:SetParent(F.HiddenFrame)

    -- party
    for i = 1, 4 do
        HideBlizzPartyFrame('PartyMemberFrame' .. i)
    end
end

-- Make sure the state of each element is reliable #TODO

function UNITFRAME:UpdateAllElements()
    UNITFRAME:UpdatePortrait()
    UNITFRAME:UpdateGCDTicker()
    UNITFRAME:UpdateAuras()
    UNITFRAME:UpdateFader()
    UNITFRAME:UpdateClassPower()
end

function UNITFRAME:OnLogin()
    UNITFRAME:AddDungeonSpells()
    UNITFRAME:AddDominationSpells()
    UNITFRAME:AddNathriaSpells()
    UNITFRAME:AddSepulcherSpells()
    UNITFRAME:SpawnUnits()
    UNITFRAME:UpdateAllElements()
end
