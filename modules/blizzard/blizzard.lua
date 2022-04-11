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
    BLIZZARD:UIWidgetMover()
    BLIZZARD:EnhancedColorPicker()
    BLIZZARD:EnhancedMerchant()
    BLIZZARD:EnhancedFriendsList()
    BLIZZARD:EnhancedPremade()
    BLIZZARD:EnhancedDressup()
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
    local frame = CreateFrame('Frame', 'FreeUIVehicleIndicatorMover', _G.UIParent)
    frame:SetSize(100, 100)
    F.Mover(frame, L['Vehicle Indicator'], 'VehicleIndicator', {'BOTTOMRIGHT', _G.Minimap, 'TOPRIGHT', 0, 0})

    hooksecurefunc(_G.VehicleSeatIndicator, 'SetPoint', function(self, _, parent)
        if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', frame)
            self:SetScale(.7)
        end
    end)
end

function BLIZZARD:DurabilityFrameMover()
    local frame = CreateFrame('Frame', 'FreeUIDurabilityFrameMover', _G.UIParent)
    frame:SetSize(100, 100)
    F.Mover(frame, L['Durability Indicator'], 'DurabilityFrame', {'TOPRIGHT', _G.ObjectiveTrackerFrame, 'TOPLEFT', -10, 0})

    hooksecurefunc(_G.DurabilityFrame, 'SetPoint', function(self, _, parent)
        if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', frame)
            self:SetScale(.7)
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

function BLIZZARD:UIWidgetMover()
    local frame = CreateFrame('Frame', 'FreeUI_UIWidgetMover', _G.UIParent)
    frame:SetSize(200, 50)
    F.Mover(frame, L['Widget Frame'], 'UIWidgetFrame', {'TOP', 0, -80})

    hooksecurefunc(_G.UIWidgetBelowMinimapContainerFrame, 'SetPoint', function(self, _, parent)
        if parent == 'MinimapCluster' or parent == _G.MinimapCluster then
            self:ClearAllPoints()
            self:SetPoint('TOP', frame)
        end
    end)
end

