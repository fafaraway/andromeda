local F, C, L = unpack(select(2, ...))
local M = F:GetModule('General')

-- Force warning
do
    local function ForceWarning_OnEvent(_, event)
        if event == 'UPDATE_BATTLEFIELD_STATUS' then
            for i = 1, GetMaxBattlefieldID() do
                local status = GetBattlefieldStatus(i)
                if status == 'confirm' then
                    PlaySound(_G.SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
                    break
                end
                i = i + 1
            end
        elseif event == 'PET_BATTLE_QUEUE_PROPOSE_MATCH' then
            PlaySound(_G.SOUNDKIT.PVP_THROUGH_QUEUE, 'Master')
        elseif event == 'LFG_PROPOSAL_SHOW' then
            PlaySound(_G.SOUNDKIT.READY_CHECK, 'Master')
        elseif event == 'RESURRECT_REQUEST' then
            PlaySound(37, 'Master')
        end
    end

    local function ReadyCheckHook(_, initiator)
        if initiator ~= 'player' then
            PlaySound(_G.SOUNDKIT.READY_CHECK, 'Master')
        end
    end

    function M:ForceWarning()
        F:RegisterEvent('UPDATE_BATTLEFIELD_STATUS', ForceWarning_OnEvent)
        F:RegisterEvent('PET_BATTLE_QUEUE_PROPOSE_MATCH', ForceWarning_OnEvent)
        F:RegisterEvent('LFG_PROPOSAL_SHOW', ForceWarning_OnEvent)
        F:RegisterEvent('RESURRECT_REQUEST', ForceWarning_OnEvent)

        hooksecurefunc('ShowReadyCheck', ReadyCheckHook)
    end
end

-- Support cmd /way if TomTom disabled
do
    local pointString = C.InfoColor .. '|Hworldmap:%d+:%d+:%d+|h[|A:Waypoint-MapPin-ChatIcon:13:13:0:0|a%s (%s, %s)%s]|h|r'

    local function GetCorrectCoord(x)
        x = tonumber(x)
        if x then
            if x > 100 then
                return 100
            elseif x < 0 then
                return 0
            end
            return x
        end
    end

    function M:JerryWay()
        if IsAddOnLoaded('TomTom') then
            return
        end

        _G.SlashCmdList['FREEUI_JERRY_WAY'] = function(msg)
            msg = string.gsub(msg, '(%d)[%.,] (%d)', '%1 %2')
            local x, y, z = string.match(msg, '(%S+)%s(%S+)(.*)')
            if x and y then
                local mapID = C_Map.GetBestMapForUnit('player')
                if mapID then
                    local mapInfo = C_Map.GetMapInfo(mapID)
                    local mapName = mapInfo and mapInfo.name
                    if mapName then
                        x = GetCorrectCoord(x)
                        y = GetCorrectCoord(y)

                        if x and y then
                            print(string.format(pointString, mapID, x * 100, y * 100, mapName, x, y, z or ''))
                        end
                    end
                end
            end
        end
        _G.SLASH_FREEUI_JERRY_WAY1 = '/way'
    end
end

-- Auto select current event boss from LFD tool
do
    local firstLFD
    local function LFD_OnShow()
        if not firstLFD then
            firstLFD = 1
            for i = 1, GetNumRandomDungeons() do
                local id = GetLFGRandomDungeonInfo(i)
                local isHoliday = select(15, GetLFGDungeonInfo(id))
                if isHoliday and not GetLFGDungeonRewards(id) then
                    _G.LFDQueueFrame_SetType(id)
                end
            end
        end
    end

    _G.LFDParentFrame:HookScript('OnShow', LFD_OnShow)
end

-- Auto collapse TradeSkillFrame RecipeList
do
    local function CollapseTradeSkills(self)
        self.tradeSkillChanged = nil
        self.collapsedCategories = {}

        for _, categoryID in ipairs({_G.C_TradeSkillUI.GetCategories()}) do
            self.collapsedCategories[categoryID] = true
        end

        self:Refresh()
    end

    F:HookAddOn('Blizzard_TradeSkillUI', function(self)
        hooksecurefunc(_G.TradeSkillFrame.RecipeList, 'OnDataSourceChanged', CollapseTradeSkills)
    end)
end

-- automatically select the talent tab
do
    local function SelectTalentTab()
        if not InCombatLockdown() then
            PlayerTalentTab_OnClick(_G['PlayerTalentFrameTab' .. _G.TALENTS_TAB])
        end
    end

    F:HookAddOn('Blizzard_TalentUI', function()
        hooksecurefunc('PlayerTalentFrame_Toggle', SelectTalentTab)
    end)
end

-- alt+click to buy a stack
do
    local str = '\n|cffff0000<' .. L['Alt+Click to buy a stack'] .. '>|r'
    _G.ITEM_VENDOR_STACK_BUY = _G.ITEM_VENDOR_STACK_BUY .. str

    local function OnModifiedClick(self)
        if not IsAltKeyDown() then
            return
        end

        local id = self:GetID()
        local itemLink = GetMerchantItemLink(id)

        if not itemLink then
            return
        end

        local maxStack = select(8, GetItemInfo(itemLink))
        if maxStack and maxStack > 1 then
            local numAvailable = select(5, GetMerchantItemInfo(id))
            if numAvailable > -1 then
                BuyMerchantItem(id, numAvailable)
            else
                BuyMerchantItem(id, GetMerchantItemMaxStack(id))
            end
        end
    end

    hooksecurefunc('MerchantItemButton_OnModifiedClick', OnModifiedClick)
end

-- mute some annoying sounds
do
    local soundsList = {
        -- Train
        -- Blood Elf
        '539219',
        '539203',
        '1313588',
        '1306531',
        -- Draenei
        '539516',
        '539730',
        -- Dwarf
        '539802',
        '539881',
        -- Gnome
        '540271',
        '540275',
        -- Goblin
        '541769',
        '542017',
        -- Human
        '540535',
        '540734',
        -- Night Elf
        '540870',
        '540947',
        '1316209',
        '1304872',
        -- Orc
        '541157',
        '541239',
        -- Pandaren
        '636621',
        '630296',
        '630298',
        -- Tauren
        '542818',
        '542896',
        -- Troll
        '543085',
        '543093',
        -- Undead
        '542526',
        '542600',
        -- Worgen
        '542035',
        '542206',
        '541463',
        '541601',
        -- Dark Iron
        '1902030',
        '1902543',
        -- Highmount
        '1730534',
        '1730908',
        -- Kul Tiran
        '2531204',
        '2491898',
        -- Lightforg
        '1731282',
        '1731656',
        -- MagharOrc
        '1951457',
        '1951458',
        -- Mechagnom
        '3107651',
        '3107182',
        -- Nightborn
        '1732030',
        '1732405',
        -- Void Elf
        '1732785',
        '1733163',
        -- Vulpera
        '3106252',
        '3106717',
        -- Zandalari
        '1903049',
        '1903522',

        -- Smolderheart
        '2066602',
        '2066605',
    }

    for _, soundID in pairs(soundsList) do
        MuteSoundFile(soundID)
    end
end

-- faster movie skip
do
    local function CinematicFrame_OnKeyDown(self, key)
        if key == 'ESCAPE' then
            if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
                self.closeDialog:Hide()
            end
        end
    end

    local function CinematicFrame_OnKeyUp(self, key)
        if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
            if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
                self.closeDialog.confirmButton:Click()
            end
        end
    end

    local function MovieFrame_OnKeyUp(self, key)
        if key == 'SPACE' or key == 'ESCAPE' or key == 'ENTER' then
            if self:IsShown() and self.CloseDialog and self.CloseDialog.ConfirmButton then
                self.CloseDialog.ConfirmButton:Click()
            end
        end
    end

    function M:FasterMovieSkip()
        if not C.DB.General.FasterMovieSkip then
            return
        end

        if _G.CinematicFrame.closeDialog and not _G.CinematicFrame.closeDialog.confirmButton then
            _G.CinematicFrame.closeDialog.confirmButton = _G.CinematicFrameCloseDialogConfirmButton
        end

        _G.CinematicFrame:HookScript('OnKeyDown', CinematicFrame_OnKeyDown)
        _G.CinematicFrame:HookScript('OnKeyUp', CinematicFrame_OnKeyUp)
        _G.MovieFrame:HookScript('OnKeyUp', MovieFrame_OnKeyUp)
    end
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


function M:OnLogin()
    M:ForceWarning()
    M:JerryWay()
    M:FasterMovieSkip()
end
