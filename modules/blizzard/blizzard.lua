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

    self:UpdateBossBanner()
    self:UpdateBossEmote()

    self:TradeTargetInfo()
    self:TicketStatusMover()
    self:VehicleIndicatorMover()
    self:DurabilityFrameMover()
    self:UIWidgetMover()
    self:MawBuffsFrameMover()
end

do
    --[[ function BLIZZARD:TestBossBanner()
        -- Requires you be in raid or party
        BossBanner_OnEvent(BossBanner, "BOSS_KILL", 1128, "Kargath Bladefist")
        BossBanner_OnEvent(BossBanner, "ENCOUNTER_LOOT_RECEIVED", 1128, 118308, ({GetItemInfo(118308)})[2], 1, "Cat", "DRUID")
        BossBanner_OnEvent(BossBanner, "ENCOUNTER_LOOT_RECEIVED", 1128, 118309, ({GetItemInfo(118309)})[2], 1, "Cat", "DRUID")
        BossBanner_OnEvent(BossBanner, "ENCOUNTER_LOOT_RECEIVED", 1128, 118310, ({GetItemInfo(118310)})[2], 1, "Cat", "DRUID")
        BossBanner_OnEvent(BossBanner, "ENCOUNTER_LOOT_RECEIVED", 1128, 118311, ({GetItemInfo(118311)})[2], 1, "Cat", "DRUID")
        BossBanner_OnEvent(BossBanner, "ENCOUNTER_LOOT_RECEIVED", 1128, 118312, ({GetItemInfo(118312)})[2], 1, "Cat", "DRUID")
    end

    SLASH_BOSSBANNER1 = '/bossbanner'
    function SlashCmdList.BOSSBANNER()
        BLIZZARD:TestBossBanner()
    end

    -- Old BossBanner_OnEvent function
    local origBossBanner_OnEvent = BossBanner_OnEvent


    local hideBossBanner = true
    local hideLootList = true
    local function OnEvent(...)
        local _, event = ...
        if event == "BOSS_KILL" then
            if not hideBossBanner then
                return origBossBanner_OnEvent(...)
            end
        end
        if event == "ENCOUNTER_LOOT_RECEIVED" then
            if not hideBossBanner or not hideLootList then
                return origBossBanner_OnEvent(...)
            end
        end

    end

    -- Override BossBanner_OnEvent
    BossBanner_OnEvent = OnEvent

    -- Set script to new Function
    BossBanner:SetScript("OnEvent", OnEvent) ]]

    function BLIZZARD:UpdateBossBanner()
        if C.DB.General.HideBossBanner then
            _G.BossBanner:UnregisterAllEvents()
        else
            _G.BossBanner:RegisterEvent('BOSS_KILL')
            _G.BossBanner:RegisterEvent('ENCOUNTER_LOOT_RECEIVED')
        end
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

function BLIZZARD:TradeTargetInfo()
    local infoText = F.CreateFS(_G.TradeFrame, C.Assets.Fonts.Regular, 14, true)
    infoText:ClearAllPoints()
    infoText:SetPoint('TOP', _G.TradeFrameRecipientNameText, 'BOTTOM', 0, -5)

    local function updateColor()
        local r, g, b = F:UnitColor('NPC')
        _G.TradeFrameRecipientNameText:SetTextColor(r, g, b)

        local guid = UnitGUID('NPC')
        if not guid then
            return
        end
        local text = C.RedColor .. L['Stranger']
        if C_BattleNet.GetGameAccountInfoByGUID(guid) or C_FriendList.IsFriend(guid) then
            text = C.GreenColor .. _G.FRIEND
        elseif IsGuildMember(guid) then
            text = C.BlueColor .. _G.GUILD
        end
        infoText:SetText(text)
    end
    hooksecurefunc('TradeFrame_Update', updateColor)
end

do
    local deleteDialog = _G.StaticPopupDialogs['DELETE_GOOD_ITEM']
    if deleteDialog.OnShow then
        hooksecurefunc(
            deleteDialog,
            'OnShow',
            function(self)
                self.editBox:SetText(_G.DELETE_ITEM_CONFIRM_STRING)
            end
        )
    end
end

function BLIZZARD:VehicleIndicatorMover()
    local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', _G.UIParent)
    frame:SetSize(100, 100)
    F.Mover(frame, L['Vehicle Indicator'], 'VehicleIndicator', {'BOTTOMRIGHT', _G.Minimap, 'TOPRIGHT', 0, 0})

    hooksecurefunc(
        _G.VehicleSeatIndicator,
        'SetPoint',
        function(self, _, parent)
            if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
                self:ClearAllPoints()
                self:SetPoint('TOPLEFT', frame)
                self:SetScale(.7)
            end
        end
    )
end

function BLIZZARD:DurabilityFrameMover()
    local frame = CreateFrame('Frame', 'FreeUIDurabilityFrameMover', _G.UIParent)
    frame:SetSize(100, 100)
    F.Mover(frame, L['Durability Indicator'], 'DurabilityFrame', {'TOPRIGHT', _G.ObjectiveTrackerFrame, 'TOPLEFT', -10, 0})

    hooksecurefunc(
        _G.DurabilityFrame,
        'SetPoint',
        function(self, _, parent)
            if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
                self:ClearAllPoints()
                self:SetPoint('TOPLEFT', frame)
                self:SetScale(.7)
            end
        end
    )
end

function BLIZZARD:TicketStatusMover()
    hooksecurefunc(
        _G.TicketStatusFrame,
        'SetPoint',
        function(self, relF)
            if relF == 'TOPRIGHT' then
                self:ClearAllPoints()
                self:SetPoint('TOP', _G.UIParent, 'TOP', 0, -100)
            end
        end
    )
end

function BLIZZARD:UIWidgetMover()
    local frame = CreateFrame('Frame', 'FreeUI_UIWidgetMover', _G.UIParent)
    frame:SetSize(200, 50)
    F.Mover(frame, L['Widget Frame'], 'UIWidgetFrame', {'TOP', 0, -80})

    hooksecurefunc(
        _G.UIWidgetBelowMinimapContainerFrame,
        'SetPoint',
        function(self, _, parent)
            if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
                self:ClearAllPoints()
                self:SetPoint('TOP', frame)
            end
        end
    )
end

do
    function BLIZZARD:UpdateMawBuffsFrameVisibility()
        local maw = _G.MawBuffsBelowMinimapFrame
        if C.DB.General.HideMawBuffsFrame then
            maw:SetAlpha(0)
            maw:SetScale(0.001)
        else
            maw:SetAlpha(1)
            maw:SetScale(1)
        end
    end

    function BLIZZARD:MawBuffsFrameMover()
        local maw = _G.MawBuffsBelowMinimapFrame

        if not C.DB.General.HideMawBuffsFrame then
            local frame = CreateFrame('Frame', 'FreeUI_MawBuffsMover', _G.UIParent)
            frame:SetSize(235, 28)
            local mover = F.Mover(frame, _G.MAW_POWER_DESCRIPTION, 'MawBuffs', {'BOTTOMRIGHT', _G.UIParent, 'RIGHT', -225, -80})
            frame:SetPoint('TOPLEFT', mover, 4, 12)

            hooksecurefunc(
                maw,
                'SetPoint',
                function(self, _, parent)
                    if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
                        self:ClearAllPoints()
                        self:SetPoint('TOPRIGHT', frame)
                    end
                end
            )
        end

        BLIZZARD:UpdateMawBuffsFrameVisibility()
    end
end

do
    local function OnEvent()
        local lastInfoFrame = C_CVar.GetCVarBitfield('closedInfoFrames', _G.NUM_LE_FRAME_TUTORIALS)
        if not lastInfoFrame then
            C_CVar.SetCVar('showTutorials', 0)
            C_CVar.SetCVar('showNPETutorials', 0)
            C_CVar.SetCVar('hideAdventureJournalAlerts', 1)
            -- help plates
            for i = 1, _G.NUM_LE_FRAME_TUTORIALS do
                C_CVar.SetCVarBitfield('closedInfoFrames', i, true)
            end
            for i = 1, _G.NUM_LE_FRAME_TUTORIAL_ACCCOUNTS do
                C_CVar.SetCVarBitfield('closedInfoFramesAccountWide', i, true)
            end
        end

        -- hide talent alert
        function _G.MainMenuMicroButton_AreAlertsEnabled()
            return false
        end
    end

    -- if you're in Exile's Reach and level 1 this cvar gets automatically enabled
    hooksecurefunc(
        'NPE_CheckTutorials',
        function()
            if C_PlayerInfo.IsPlayerNPERestricted() and UnitLevel('player') == 1 then
                SetCVar('showTutorials', 0)
                _G.NewPlayerExperience:Shutdown()
                -- for some reason this window still shows up
                _G.NPE_TutorialKeyboardMouseFrame_Frame:Hide()
            end
        end
    )

    F:RegisterEvent('ADDON_LOADED', OnEvent)
end
