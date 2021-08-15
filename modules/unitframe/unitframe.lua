local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local UnitFrame_OnEnter = UnitFrame_OnEnter
local UnitFrame_OnLeave = UnitFrame_OnLeave
local CompactRaidFrameManager_SetSetting = CompactRaidFrameManager_SetSetting
local CompactRaidFrameManager = CompactRaidFrameManager
local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitIsFriend = UnitIsFriend
local UnitIsEnemy = UnitIsEnemy
local PlaySound = PlaySound
local EJ_GetInstanceInfo = EJ_GetInstanceInfo

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

--[[ Backdrop ]]

local function UF_OnEnter(self)
    UnitFrame_OnEnter(self)
    self.Highlight:Show()
end

local function UF_OnLeave(self)
    UnitFrame_OnLeave(self)
    self.Highlight:Hide()
end

function UNITFRAME:CreateBackdrop(self)
    local highlight = self:CreateTexture(nil, 'OVERLAY')
    highlight:SetAllPoints()
    highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
    highlight:SetTexCoord(0, 1, .5, 1)
    highlight:SetVertexColor(.6, .6, .6)
    highlight:SetBlendMode('BLEND')
    highlight:Hide()
    self.Highlight = highlight

    self:RegisterForClicks('AnyUp')
    self:HookScript('OnEnter', UF_OnEnter)
    self:HookScript('OnLeave', UF_OnLeave)

    self.backdrop = F.SetBD(self, 0)
    self.backdrop:SetBackdropColor(.1, .1, .1, .8)
    self.backdrop:SetBackdropBorderColor(0, 0, 0, 1)
    self.shadow = self.backdrop.__shadow

    if not self.unitStyle == 'player' then
        return
    end

    local width = C.DB.Unitframe.PlayerWidth
    local height = C.DB.Unitframe.ClassPowerBarHeight

    local classPowerBarHolder = CreateFrame('Frame', nil, self)
    classPowerBarHolder:SetSize(width, height)
    classPowerBarHolder:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)

    self.ClassPowerBarHolder = classPowerBarHolder
end

--[[ Selected border ]]

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

--[[ Sound effect for target/focus changed ]]

function UNITFRAME:PLAYER_TARGET_CHANGED()
    if (UnitExists('target')) then
        if (UnitIsEnemy('target', 'player')) then
            PlaySound(873)
        elseif (UnitIsFriend('target', 'player')) then
            PlaySound(867)
        else
            PlaySound(871)
        end
    else
        PlaySound(684)
    end
end

function UNITFRAME:PLAYER_FOCUS_CHANGED()
    if (UnitExists('focus')) then
        if (UnitIsEnemy('focus', 'player')) then
            PlaySound(873)
        elseif (UnitIsFriend('focus', 'player')) then
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

--[[ Remove blizz raid frame ]]

function UNITFRAME:RemoveBlizzRaidFrame()
    if CompactRaidFrameManager_SetSetting then
        CompactRaidFrameManager_SetSetting('IsShown', '0')
        _G.UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
        CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager:SetParent(F.HiddenFrame)
    end
end

--[[  ]]

local RaidBuffs = {}
function UNITFRAME:AddClassSpells(list)
    for class, value in pairs(list) do
        RaidBuffs[class] = value
    end
end

local RaidDebuffs = {}
function UNITFRAME:RegisterDebuff(_, instID, _, spellID, level)
    local instName = EJ_GetInstanceInfo(instID)
    if not instName then
        if C.IsDeveloper then
            print('Invalid instance ID: ' .. instID)
        end
        return
    end

    if not RaidDebuffs[instName] then
        RaidDebuffs[instName] = {}
    end
    if not level then
        level = 2
    end
    if level > 6 then
        level = 6
    end

    RaidDebuffs[instName][spellID] = level
end

function UNITFRAME:OnLogin()
    UNITFRAME:AddDungeonSpells()
    UNITFRAME:AddDonimationSpells()
    UNITFRAME:AddNathriaSpells()

    for instName, value in pairs(RaidDebuffs) do
        for spell, priority in pairs(value) do
            if _G.FREE_ADB['RaidDebuffsList'][instName] and _G.FREE_ADB['RaidDebuffsList'][instName][spell] and _G.FREE_ADB['RaidDebuffsList'][instName][spell] == priority then
                _G.FREE_ADB['RaidDebuffsList'][instName][spell] = nil
            end
        end
    end
    for instName, value in pairs(_G.FREE_ADB['RaidDebuffsList']) do
        if not next(value) then
            _G.FREE_ADB['RaidDebuffsList'][instName] = nil
        end
    end

    C.RaidBuffsList = RaidBuffs
    C.RaidDebuffsList = RaidDebuffs

    UNITFRAME:SpawnUnits()
end
