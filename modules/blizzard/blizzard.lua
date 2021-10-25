local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local UnitGUID = UnitGUID
local IsGuildMember = IsGuildMember
local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local C_FriendList_IsFriend = C_FriendList.IsFriend
local VehicleSeatIndicator = VehicleSeatIndicator

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

    self:ToggleBossBanner()
    self:ToggleBossEmote()

    self:TradeTargetInfo()
    self:TicketStatusMover()
    self:VehicleIndicatorMover()
    self:DurabilityFrameMover()
    self:UIWidgetMover()
    self:MawBuffsFrameMover()
end

function BLIZZARD:ToggleBossBanner()
    if C.DB.General.HideBossBanner then
        _G.BossBanner:UnregisterAllEvents()
    else
        _G.BossBanner:RegisterEvent('BOSS_KILL')
        _G.BossBanner:RegisterEvent('ENCOUNTER_LOOT_RECEIVED')
    end
end

function BLIZZARD:ToggleBossEmote()
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
        if C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
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
        VehicleSeatIndicator,
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

function BLIZZARD:MawBuffsFrameMover()
    local maw = _G.MawBuffsBelowMinimapFrame

    if C.DB.General.HideMawBuffsFrame then
        maw:SetAlpha(0)
        maw:SetScale(0.001)
    else
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
end
