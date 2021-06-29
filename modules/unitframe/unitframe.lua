local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local UnitFrame_OnEnter = UnitFrame_OnEnter
local UnitFrame_OnLeave = UnitFrame_OnLeave
local GetSpecialization = GetSpecialization
local CompactRaidFrameManager_SetSetting = CompactRaidFrameManager_SetSetting
local CompactRaidFrameManager = CompactRaidFrameManager
local UnitIsUnit = UnitIsUnit

local F, C = unpack(select(2, ...))
local UNITFRAME = F:RegisterModule('Unitframe')
local NAMEPLATE = F:RegisterModule('Nameplate')

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

    F.CreateTex(self)

    local bg = F.CreateBDFrame(self)
    bg:SetBackdropBorderColor(0, 0, 0, 1)
    bg:SetBackdropColor(0, 0, 0, 0)
    self.Bg = bg

    local glow = F.CreateSD(self.Bg)
    self.Glow = glow

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
    local border = F.CreateBDFrame(self.Bg)
    border:SetBackdropBorderColor(1, 1, 1, 1)
    border:SetBackdropColor(0, 0, 0, 0)
    border:SetFrameLevel(self:GetFrameLevel() + 5)
    border:Hide()

    self.Border = border
    self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
    self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end


function UNITFRAME:OnLogin()
    if not C.DB.Unitframe.Enable then
        return
    end

    F:SetSmoothingAmount(.3)

    UNITFRAME:UpdateHealthColor()
    UNITFRAME:UpdateClassColor()

    self:SpawnPlayer()
    self:SpawnPet()
    self:SpawnTarget()
    self:SpawnTargetTarget()
    self:SpawnFocus()
    self:SpawnFocusTarget()

    self:SpawnBoss()


    if C.DB.Unitframe.Arena then
        self:SpawnArena()
    end

    if not C.DB.Unitframe.Group then
        return
    end

    -- get rid of blizz raid frame
    if CompactRaidFrameManager_SetSetting then
        CompactRaidFrameManager_SetSetting('IsShown', '0')
        _G.UIParent:UnregisterEvent('GROUP_ROSTER_UPDATE')
        CompactRaidFrameManager:UnregisterAllEvents()
        CompactRaidFrameManager:SetParent(F.HiddenFrame)
    end

    self:SpawnParty()
    self:SpawnRaid()
    self:ClickCast()

    if C.DB.Unitframe.PositionBySpec then
        local function UpdateSpecPos(event, ...)
            local unit, _, spellID = ...
            if (event == 'UNIT_SPELLCAST_SUCCEEDED' and unit == 'player' and spellID == 200749) or event == 'ON_LOGIN' then
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end

                if not C.DB['UIAnchor']['raid_position' .. specIndex] then
                    C.DB['UIAnchor']['raid_position' .. specIndex] = {'TOPLEFT', 'oUF_Target', 'BOTTOMLEFT', 0, -10}
                end

                UNITFRAME.RaidMover:ClearAllPoints()
                UNITFRAME.RaidMover:SetPoint(unpack(C.DB['UIAnchor']['raid_position' .. specIndex]))

                if UNITFRAME.RaidMover then
                    UNITFRAME.RaidMover:ClearAllPoints()
                    UNITFRAME.RaidMover:SetPoint(unpack(C.DB['UIAnchor']['raid_position' .. specIndex]))
                end

                if not C.DB['UIAnchor']['party_position' .. specIndex] then
                    C.DB['UIAnchor']['party_position' .. specIndex] =
                        {'BOTTOMRIGHT', 'oUF_Player', 'TOPLEFT', -100, 60}
                end
                if UNITFRAME.PartyMover then
                    UNITFRAME.PartyMover:ClearAllPoints()
                    UNITFRAME.PartyMover:SetPoint(unpack(C.DB['UIAnchor']['party_position' .. specIndex]))
                end
            end
        end
        UpdateSpecPos('ON_LOGIN')
        F:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', UpdateSpecPos)

        if UNITFRAME.RaidMover then
            UNITFRAME.RaidMover:HookScript('OnDragStop', function()
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end
                C.DB['UIAnchor']['raid_position' .. specIndex] = C.DB['UIAnchor']['RaidFrame']
            end)
        end

        if UNITFRAME.PartyMover then
            UNITFRAME.PartyMover:HookScript('OnDragStop', function()
                local specIndex = GetSpecialization()
                if not specIndex then
                    return
                end
                C.DB['UIAnchor']['party_position' .. specIndex] = C.DB['UIAnchor']['PartyFrame']
            end)
        end
    end
end
