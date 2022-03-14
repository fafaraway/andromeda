local F, C = unpack(select(2, ...))
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
    local f = CreateFrame('Frame')
    f:RegisterEvent('ADDON_LOADED')
    f:SetScript('OnEvent', function(self, _, addon)
        if addon ~= 'Blizzard_TradeSkillUI' then
            return
        end

        hooksecurefunc(_G.TradeSkillFrame.RecipeList, 'OnDataSourceChanged', function(self)
            self.tradeSkillChanged = nil
            self.collapsedCategories = {}

            for _, categoryID in ipairs({_G.C_TradeSkillUI.GetCategories()}) do
                self.collapsedCategories[categoryID] = true
            end

            self:Refresh()
        end)

        self:UnregisterAllEvents()
    end)
end

function M:OnLogin()
    M:ForceWarning()
    M:JerryWay()
end
