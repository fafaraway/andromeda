local F, C, L = unpack(select(2, ...))
local AUTO = F:GetModule('Automation')

-- automatically select the talent tab
do
    local function selectTalentTab()
        if not InCombatLockdown() then
            PlayerTalentTab_OnClick(_G['PlayerTalentFrameTab' .. _G.TALENTS_TAB])
        end
    end

    F:HookAddOn('Blizzard_TalentUI', function()
        hooksecurefunc('PlayerTalentFrame_Toggle', selectTalentTab)
    end)
end

-- automatically place keystones in the font of power
do
    local function autoKeystone()
        for bagID = _G.BACKPACK_CONTAINER, _G.NUM_BAG_SLOTS do
            for slotID = 1, GetContainerNumSlots(bagID) do
                local itemLink = GetContainerItemLink(bagID, slotID)
                if itemLink and itemLink:match('|Hkeystone:') then
                    PickupContainerItem(bagID, slotID)
                    if CursorHasItem() then
                        C_ChallengeMode.SlotKeystone()
                        return
                    end
                end
            end
        end
    end

    F:RegisterEvent('CHALLENGE_MODE_KEYSTONE_RECEPTABLE_OPEN', autoKeystone)
end

-- track repair vendors if we're severely damaged
do
    local function trackRepair()
        local alert = 0
        for index in next, _G.INVENTORY_ALERT_STATUS_SLOTS do
            local status = GetInventoryAlertStatus(index)
            if status > alert then
                alert = status
            end
        end

        for index = 1, GetNumTrackingTypes() do
            if GetTrackingInfo(index) == _G.MINIMAP_TRACKING_REPAIR then
                return SetTracking(index, alert > 0)
            end
        end
    end

    F:RegisterEvent('UPDATE_INVENTORY_DURABILITY', trackRepair)
end

-- track mailbox if we have pending mail
do
    local function trackMailbox()
        for index = 1, GetNumTrackingTypes() do
            local name, _, active = GetTrackingInfo(index)
            if name == _G.MINIMAP_TRACKING_MAILBOX then
                return SetTracking(index, HasNewMail() and not active)
            end
        end
    end

    F:RegisterEvent('UPDATE_INVENTORY_DURABILITY', trackMailbox)
end

-- auto select current event boss from LFD tool
do
    local doneHoliday
    _G.LFDParentFrame:HookScript('OnShow', function()
        if not doneHoliday then
            for index = 1, _G.GetNumRandomDungeons() do
                local dungeonID = _G.GetLFGRandomDungeonInfo(index)
                local isHoliday = _G.select(15, _G.GetLFGDungeonInfo(dungeonID))
                if isHoliday then
                    if _G.GetLFGDungeonRewards(dungeonID) then
                        doneHoliday = true
                    else
                        _G.LFDQueueFrame_SetType(dungeonID)
                    end
                end
            end
        end
    end)
end

-- auto fill delete confirm string
do
    local deleteDialog = StaticPopupDialogs['DELETE_GOOD_ITEM']
    if deleteDialog.OnShow then
        hooksecurefunc(deleteDialog, 'OnShow', function(self)
            self.editBox:SetText(_G.DELETE_ITEM_CONFIRM_STRING)
        end)
    end
end

-- auto collapse TradeSkillFrame RecipeList
do
    local function CollapseTradeSkills(self)
        self.tradeSkillChanged = nil
        self.collapsedCategories = {}

        for _, categoryID in ipairs({ _G.C_TradeSkillUI.GetCategories() }) do
            self.collapsedCategories[categoryID] = true
        end

        self:Refresh()
    end

    F:HookAddOn('Blizzard_TradeSkillUI', function(self)
        hooksecurefunc(_G.TradeSkillFrame.RecipeList, 'OnDataSourceChanged', CollapseTradeSkills)
    end)
end

function AUTO:OnLogin() end
