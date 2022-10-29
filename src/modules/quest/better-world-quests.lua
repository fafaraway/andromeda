-- Better World Quests
-- Credit: p3lim
-- https://github.com/p3lim-wow/BetterWorldQuests

local parentMaps = {
    -- list of all continents and their sub-zones that have world quests
    [1550] = {
        -- Shadowlands
        [1525] = true, -- Revendreth
        [1533] = true, -- Bastion
        [1536] = true, -- Maldraxxus
        [1565] = true, -- Ardenwald
    },
}

local factionAssaultAtlasName = UnitFactionGroup('player') == 'Horde' and 'worldquest-icon-horde'
    or 'worldquest-icon-alliance'

local function AdjustedMapID(mapID)
    -- this will replace the Argus map ID with the one used by the taxi UI, since one of the
    -- features of this addon is replacing the Argus map art with the taxi UI one
    return mapID == 905 and 994 or mapID
end

-- create a new data provider that will display the world quests on zones from the list above,
-- based on WorldQuestDataProviderMixin
local DataProvider = CreateFromMixins(_G.WorldQuestDataProviderMixin)
DataProvider:SetMatchWorldMapFilters(true)
DataProvider:SetUsesSpellEffect(true)
DataProvider:SetCheckBounties(true)
DataProvider:SetMarkActiveQuests(true)

function DataProvider:GetPinTemplate()
    -- we use our own copy of the WorldMap_WorldQuestPinTemplate template to avoid interference
    return 'BetterWorldQuestPinTemplate'
end

function DataProvider:ShouldShowQuest(questInfo)
    local questID = questInfo.questId
    if self.focusedQuestID or self:IsQuestSuppressed(questID) then
        return false
    else
        -- returns true if the given quest is a world quest on one of the maps in our list
        local mapID = AdjustedMapID(self:GetMap():GetMapID())
        local questMapID = questInfo.mapID
        if mapID == questMapID or (parentMaps[mapID] and parentMaps[mapID][questMapID]) then
            return HaveQuestData(questID) and QuestUtils_IsQuestWorldQuest(questID)
        end
    end
end

function DataProvider:RefreshAllData()
    -- map is updated, draw world quest pins
    local pinsToRemove = {}
    for questID in next, self.activePins do
        -- mark all pins for removal
        pinsToRemove[questID] = true
    end

    local Map = self:GetMap()
    local mapID = AdjustedMapID(Map:GetMapID())

    local quests = mapID and C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
    if quests then
        for _, questInfo in next, quests do
            if self:ShouldShowQuest(questInfo) and self:DoesWorldQuestInfoPassFilters(questInfo) then
                local questID = questInfo.questId
                pinsToRemove[questID] = nil -- unmark the pin for removal

                local Pin = self.activePins[questID]
                if Pin then
                    -- update existing pin
                    Pin:RefreshVisuals()
                    Pin:SetPosition(questInfo.x, questInfo.y)

                    if self.pingPin and self.pingPin:IsAttachedToQuest(questID) then
                        self.pingPin:SetScalingLimits(1, 1, 1)
                        self.pingPin:SetPosition(questInfo.x, questInfo.y)
                    end
                else
                    -- create a new pin
                    self.activePins[questID] = self:AddWorldQuest(questInfo)
                end
            end
        end
    end

    for questID in next, pinsToRemove do
        -- iterate and remove all pins marked for removal
        if self.pingPin and self.pingPin:IsAttachedToQuest(questID) then
            self.pingPin:Stop()
        end

        Map:RemovePin(self.activePins[questID])
        self.activePins[questID] = nil
    end

    -- trigger callbacks like WorldQuestDataProviderMixin.RefreshAllData does
    Map:TriggerEvent('WorldQuestUpdate', Map:GetNumActivePinsByTemplate(self:GetPinTemplate()))
end

_G.WorldMapFrame:AddDataProvider(DataProvider)

_G.BetterWorldQuestPinMixin = CreateFromMixins(_G.WorldMap_WorldQuestPinMixin)
function _G.BetterWorldQuestPinMixin:OnLoad()
    _G.WorldQuestPinMixin.OnLoad(self)

    -- create any extra widgets we need if they don't already exist
    local Border = self:CreateTexture(nil, 'OVERLAY', nil, 1)
    Border:SetPoint('CENTER', 0, -3)
    Border:SetAtlas('worldquest-emissary-ring')
    Border:SetSize(72, 72)
    self.Border = Border

    -- create the indicator on a subframe so highlights don't overlap
    local Indicator = CreateFrame('Frame', nil, self):CreateTexture(nil, 'OVERLAY', nil, 2)
    Indicator:SetPoint('CENTER', self, -19, 19)
    Indicator:SetSize(44, 44)
    self.Indicator = Indicator

    local Bounty = self:CreateTexture(nil, 'OVERLAY', nil, 2)
    Bounty:SetSize(44, 44)
    Bounty:SetAtlas('QuestNormal')
    Bounty:SetPoint('CENTER', 22, 0)
    self.Bounty = Bounty

    -- make sure the tracked check mark doesn't appear underneath any of our widgets
    self.TrackedCheck:SetDrawLayer('OVERLAY', 3)
end

local function IsParentMap(mapID)
    return not not parentMaps[AdjustedMapID(mapID)]
end

function _G.BetterWorldQuestPinMixin:RefreshVisuals()
    _G.WorldMap_WorldQuestPinMixin.RefreshVisuals(self)

    -- update scale
    if IsParentMap(self:GetMap():GetMapID()) then
        self:SetScalingLimits(1, 0.3, 0.5)
    else
        self:SetScalingLimits(1, 0.425, 0.425)
    end

    -- hide frames we don't want to use
    self.BountyRing:Hide()

    -- set texture to the item/currency/value it rewards
    local questID = self.questID
    if GetNumQuestLogRewards(questID) > 0 then
        local _, texture = GetQuestLogRewardInfo(1, questID)
        SetPortraitToTexture(self.Texture, texture)
        self.Texture:SetSize(self:GetSize())
    elseif GetNumQuestLogRewardCurrencies(questID) > 0 then
        local _, texture = GetQuestLogRewardCurrencyInfo(1, questID)
        SetPortraitToTexture(self.Texture, texture)
        self.Texture:SetSize(self:GetSize())
    elseif GetQuestLogRewardMoney(questID) > 0 then
        SetPortraitToTexture(self.Texture, [[Interface\Icons\inv_misc_coin_01]])
        self.Texture:SetSize(self:GetSize())
    end

    -- update our own widgets
    local bountyQuestID = self.dataProvider:GetBountyQuestID()
    self.Bounty:SetShown(bountyQuestID and C_QuestLog.IsQuestCriteriaForBounty(questID, bountyQuestID))

    local questInfo = C_QuestLog.GetQuestTagInfo(questID)
    if questInfo.worldQuestType == Enum.QuestTagType_PvP then
        self.Indicator:SetAtlas('Warfronts-BaseMapIcons-Empty-Barracks-Minimap')
        self.Indicator:SetSize(58, 58)
        self.Indicator:Show()
    else
        self.Indicator:SetSize(44, 44)
        if questInfo.worldQuestType == Enum.QuestTagType_PetBattle then
            self.Indicator:SetAtlas('WildBattlePetCapturable')
            self.Indicator:Show()
        elseif questInfo.worldQuestType == Enum.QuestTagType_Profession then
            self.Indicator:SetAtlas(_G.WORLD_QUEST_ICONS_BY_PROFESSION[questInfo.tradeskillLineID])
            self.Indicator:Show()
        elseif questInfo.worldQuestType == Enum.QuestTagType_Dungeon then
            self.Indicator:SetAtlas('Dungeon')
            self.Indicator:Show()
        elseif questInfo.worldQuestType == Enum.QuestTagType_Raid then
            self.Indicator:SetAtlas('Raid')
            self.Indicator:Show()
        elseif questInfo.worldQuestType == Enum.QuestTagType_Invasion then
            self.Indicator:SetAtlas('worldquest-icon-burninglegion')
            self.Indicator:Show()
        elseif questInfo.worldQuestType == Enum.QuestTagType_FactionAssault then
            self.Indicator:SetAtlas(factionAssaultAtlasName)
            self.Indicator:SetSize(38, 38)
            self.Indicator:Show()
        else
            self.Indicator:Hide()
        end
    end
end

-- we need to remove the default data provider mixin
for provider in next, _G.WorldMapFrame.dataProviders do
    if provider.GetPinTemplate and provider.GetPinTemplate() == 'WorldMap_WorldQuestPinTemplate' then
        _G.WorldMapFrame:RemoveDataProvider(provider)
    end
end
