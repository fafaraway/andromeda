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
            -- self:SetScale(0.7)
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
        C_CVar.SetCVar('showTutorials', 0)
        C_CVar.SetCVar('showNPETutorials', 0)
        C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
        -- C_CVar.RegisterCVar('hideHelptips', 1) -- this can actually block interaction with mission tables

        local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', _G.NUM_LE_FRAME_TUTORIALS)
        if pendingChanges or not lastInfoFrame then
            for i = 1, _G.NUM_LE_FRAME_TUTORIALS do
                C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
            end
            for i = 1, _G.NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
                C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
            end
        end

        -- disable alert of new talent
        if not InCombatLockdown() then
            function MainMenuMicroButton_AreAlertsEnabled()
                return false
            end
        end

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

do
    local distanceText = _G.SuperTrackedFrame.DistanceText
    if not distanceText.__SetText then
        distanceText.__SetText = distanceText.SetText
        hooksecurefunc(distanceText, 'SetText', function(frame, text)
            if strmatch(text, '%d%d%d%d.%d+') then
                text = gsub(text, '(%d+)%.%d+', '%1')
                frame:__SetText(text)
            end
        end)
    end
end

-- Fix Drag Collections taint
do
    local done
    local function OnEvent(event, addon)
        if event == 'ADDON_LOADED' and addon == 'Blizzard_Collections' then
            -- Fix undragable issue
            local checkBox = _G.WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox
            checkBox.Label:ClearAllPoints()
            checkBox.Label:SetPoint('LEFT', checkBox, 'RIGHT', 2, 1)
            checkBox.Label:SetWidth(152)

            _G.CollectionsJournal:HookScript('OnShow', function()
                if not done then
                    if InCombatLockdown() then
                        F:RegisterEvent('PLAYER_REGEN_ENABLED', OnEvent)
                    else
                        F.CreateMF(_G.CollectionsJournal)
                    end
                    done = true
                end
            end)
            F:UnregisterEvent(event, OnEvent)
        elseif event == 'PLAYER_REGEN_ENABLED' then
            F.CreateMF(_G.CollectionsJournal)
            F:UnregisterEvent(event, OnEvent)
        end
    end

    F:RegisterEvent('ADDON_LOADED', OnEvent)
end

-- Select target when click on raid units
do
    local function FixRaidGroupButton()
        for i = 1, 40 do
            local bu = _G['RaidGroupButton' .. i]
            if bu and bu.unit and not bu.clickFixed then
                bu:SetAttribute('type', 'target')
                bu:SetAttribute('unit', bu.unit)

                bu.clickFixed = true
            end
        end
    end

    local function OnEvent(event, addon)
        if event == 'ADDON_LOADED' and addon == 'Blizzard_RaidUI' then
            if not InCombatLockdown() then
                FixRaidGroupButton()
            else
                F:RegisterEvent('PLAYER_REGEN_ENABLED', OnEvent)
            end
            F:UnregisterEvent(event, OnEvent)
        elseif event == 'PLAYER_REGEN_ENABLED' then
            if _G.RaidGroupButton1 and _G.RaidGroupButton1:GetAttribute('type') ~= 'target' then
                FixRaidGroupButton()
                F:UnregisterEvent(event, OnEvent)
            end
        end
    end

    F:RegisterEvent('ADDON_LOADED', OnEvent)
end

-- Fix blizz guild news hyperlink error
do
    local function FixGuildNews(event, addon)
        if addon ~= 'Blizzard_GuildUI' then
            return
        end

        local _GuildNewsButton_OnEnter = _G.GuildNewsButton_OnEnter
        function _G.GuildNewsButton_OnEnter(self)
            if not (self.newsInfo and self.newsInfo.whatText) then
                return
            end
            _GuildNewsButton_OnEnter(self)
        end

        F:UnregisterEvent(event, FixGuildNews)
    end

    F:RegisterEvent('ADDON_LOADED', FixGuildNews)
end

-- Fix blizz bug in addon list
do
    local _AddonTooltip_Update = _G.AddonTooltip_Update
    function _G.AddonTooltip_Update(owner)
        if not owner then
            return
        end
        if owner:GetID() < 1 then
            return
        end
        _AddonTooltip_Update(owner)
    end
end

-- Fix empty string in party guide promote
do
    if not _G.PROMOTE_GUIDE then
        _G.PROMOTE_GUIDE = _G.PARTY_PROMOTE_GUIDE
    end
end

-- Unregister talent event
do
    if _G.PlayerTalentFrame then
        _G.PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
    else
        hooksecurefunc('TalentFrame_LoadUI', function()
            _G.PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
        end)
    end
end

-- Fix achievement date missing in zhTW
do
    if GetLocale() == 'zhTW' then
        local function fixAchievementData(event, addon)
            if addon ~= 'Blizzard_AchievementUI' then
                return
            end

            hooksecurefunc('AchievementButton_Localize', function(button)
                button.DateCompleted:SetPoint('TOP', button.Shield, 'BOTTOM', -2, 6)
            end)

            F:UnregisterEvent(event, fixAchievementData)
        end
        F:RegisterEvent('ADDON_LOADED', fixAchievementData)
    end
end
