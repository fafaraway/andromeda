local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local BLIZZARD_LIST = {}

function BLIZZARD:RegisterBlizz(name, func)
    if not BLIZZARD_LIST[name] then
        BLIZZARD_LIST[name] = func
    end
end

function BLIZZARD:OnLogin()
    for name, func in next, BLIZZARD_LIST do
        if name and type(func) == 'function' then
            func()
        end
    end

    BLIZZARD:UpdateBossBanner()
    BLIZZARD:UpdateBossEmote()

    BLIZZARD:TicketStatusMover()
    BLIZZARD:VehicleIndicatorMover()
    BLIZZARD:DurabilityFrameMover()
    BLIZZARD:UIWidgetFrameMover()
    BLIZZARD:EnhancedColorPicker()
    BLIZZARD:EnhancedMerchant()
    -- BLIZZARD:EnhancedFriendsList()
    BLIZZARD:EnhancedPremade()
    BLIZZARD:EnhancedDressup()
    BLIZZARD:ClickBindingTab()
end

function BLIZZARD:UpdateBossBanner()
    if C.DB.General.HideBossBanner then
        _G.BossBanner:UnregisterEvent('ENCOUNTER_LOOT_RECEIVED')
    else
        _G.BossBanner:RegisterEvent('ENCOUNTER_LOOT_RECEIVED')
    end
end

function BLIZZARD:UpdateBossEmote()
    if C.DB.General.HideBossEmote then
        _G.RaidBossEmoteFrame:UnregisterAllEvents()
    else
        _G.RaidBossEmoteFrame:RegisterEvent('RAID_BOSS_EMOTE')
        _G.RaidBossEmoteFrame:RegisterEvent('RAID_BOSS_WHISPER')
        _G.RaidBossEmoteFrame:RegisterEvent('CLEAR_BOSS_EMOTES')
    end
end

function BLIZZARD:VehicleIndicatorMover()
    local frame = CreateFrame('Frame', C.ADDON_TITLE .. 'VehicleIndicatorMover', _G.UIParent)
    frame:SetSize(100, 100)
    F.Mover(frame, L['VehicleIndicator'], 'VehicleIndicator', { 'BOTTOMRIGHT', _G.Minimap, 'TOPRIGHT', 0, 0 })

    hooksecurefunc(_G.VehicleSeatIndicator, 'SetPoint', function(self, _, parent)
        if parent ~= frame then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', frame)
            self:SetScale(0.7)
        end
    end)
end

function BLIZZARD:DurabilityFrameMover()
    local frame = CreateFrame('Frame', C.ADDON_TITLE .. 'DurabilityFrameMover', _G.UIParent)
    frame:SetSize(100, 100)
    F.Mover(frame, L['DurabilityIndicator'], 'DurabilityIndicator', { 'TOPRIGHT', _G.ObjectiveTrackerFrame, 'TOPLEFT', -10, 0 })

    hooksecurefunc(_G.DurabilityFrame, 'SetPoint', function(self, _, parent)
        if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', frame)
            self:SetScale(0.7)
        end
    end)
end

function BLIZZARD:TicketStatusMover()
    hooksecurefunc(_G.TicketStatusFrame, 'SetPoint', function(self, relF)
        if relF == 'TOPRIGHT' then
            self:ClearAllPoints()
            self:SetPoint('TOP', _G.UIParent, 'TOP', 0, -100)
        end
    end)
end

function BLIZZARD:UIWidgetFrameMover()
    local frame1 = CreateFrame('Frame', C.ADDON_TITLE .. 'UIWidgetMover', _G.UIParent)
    frame1:SetSize(200, 50)
    F.Mover(frame1, L['UIWidgetFrame'], 'UIWidgetFrame', { 'TOP', 0, -80 })

    hooksecurefunc(_G.UIWidgetBelowMinimapContainerFrame, 'SetPoint', function(self, _, parent)
        if parent ~= frame1 then
            self:ClearAllPoints()
            self:SetPoint('CENTER', frame1)
        end
    end)

    local frame2 = CreateFrame('Frame', C.ADDON_TITLE .. 'WidgetPowerBarMover', _G.UIParent)
    frame2:SetSize(260, 40)
    F.Mover(frame2, L['UIWidgetPowerBar'], 'UIWidgetPowerBar', { 'BOTTOM', _G.UIParent, 'BOTTOM', 0, 150 })

    hooksecurefunc(_G.UIWidgetPowerBarContainerFrame, 'SetPoint', function(self, _, parent)
        if parent ~= frame2 then
            self:ClearAllPoints()
            self:SetPoint('CENTER', frame2)
        end
    end)
end

-- Add ClickBinding tab to SpellBookFrame
function BLIZZARD:ClickBindingTab()
    local cb = CreateFrame('CheckButton', C.ADDON_TITLE .. 'ClickCastingTab', _G.SpellBookSideTabsFrame, 'SpellBookSkillLineTabTemplate')
    cb:SetNormalTexture('Interface\\Icons\\trade_engineering')
    cb:Show()
    cb.tooltip = L['Click Binding']

    F.ReskinTab(cb)

    cb:SetScript('OnShow', function()
        local num = GetNumSpellTabs()
        local lastTab = _G['SpellBookSkillLineTab' .. num]

        cb:ClearAllPoints()
        cb:SetPoint('TOPLEFT', lastTab, 'BOTTOMLEFT', 0, -30)

        cb:SetChecked(InClickBindingMode())
        cb:SetCheckedTexture(C.Assets.Textures.ButtonChecked)
    end)

    cb:SetScript('OnClick', function()
        if InClickBindingMode() then
            _G.ClickBindingFrame.SaveButton:Click()
        else
            ToggleClickBindingFrame()
        end
    end)
end

-- Kill blizz tutorial, real man dont need these crap
-- Credit: ketho
-- https://github.com/ketho-wow/HideTutorial

do
    local pendingChanges

    local function addonLoaded(_, _, addon)
        if addon ~= C.ADDON_NAME then
            return
        end

        local tocVersion = select(4, GetBuildInfo())
        if not C.DB.HideTutorial or C.DB.HideTutorial < tocVersion then
            C.DB.HideTutorial = tocVersion
            pendingChanges = true
        end

        F:UnregisterEvent('ADDON_LOADED', addonLoaded)
    end

    local function variablesLoaded()
        local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', _G.NUM_LE_FRAME_TUTORIALS)
        if pendingChanges or not lastInfoFrame then
            C_CVar.SetCVar('showTutorials', 0)
            C_CVar.SetCVar('showNPETutorials', 0)
            C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
            for i = 1, _G.NUM_LE_FRAME_TUTORIALS do
                C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
            end
            for i = 1, _G.NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
                C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
            end
        end

        --if not IsAddOnLoaded(C.ADDON_NAME) then
            function MainMenuMicroButton_AreAlertsEnabled()
                return false
            end
        --end

        F:UnregisterEvent('VARIABLES_LOADED', variablesLoaded)
    end

    F:RegisterEvent('ADDON_LOADED', addonLoaded)
    F:RegisterEvent('VARIABLES_LOADED', variablesLoaded)

    hooksecurefunc('NPE_CheckTutorials', function()
        if C_PlayerInfo.IsPlayerNPERestricted() and UnitLevel('player') == 1 then
            F:Print('Disabling NPE tutorial.')
            SetCVar('showTutorials', 0)
        end
    end)
end
