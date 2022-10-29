local F, C, L = unpack(select(2, ...))
local QUEST = F:GetModule('Quest')

local linkQuest = 'http://www.wowhead.com/quest=%d'
local linkAchievement = 'http://www.wowhead.com/achievement=%d'


local function Button_Onclick(self)
    if self.id and IsControlKeyDown() then
        local text = linkAchievement:format(self.id)
        _G.StaticPopup_Show('ANDROMEDA_WOWHEAD_LINK', _, _, text)
    end
end

function QUEST:Load(addon)
    if addon == 'Blizzard_AchievementUI' then
        hooksecurefunc('AchievementButton_OnClick', Button_Onclick)

        F:UnregisterEvent(self, QUEST.Load)
    end
end

function QUEST:WowheadLink()
    if not C.DB.Quest.WowheadLink then
        return
    end

    hooksecurefunc('QuestObjectiveTracker_OnOpenDropDown', function(self)
        local id = self.activeFrame.id
        local info = _G.UIDropDownMenu_CreateInfo()
        info.text = L['Wowhead Link']
        info.func = function()
            local text = linkQuest:format(id)
            _G.StaticPopup_Show('ANDROMEDA_WOWHEAD_LINK', _, _, text)
        end
        info.notCheckable = true
        _G.UIDropDownMenu_AddButton(info, _G.UIDROPDOWN_MENU_LEVEL)
    end)

    hooksecurefunc('BonusObjectiveTracker_OnOpenDropDown', function(self)
        local id = self.activeFrame.TrackedQuest.questID
        local info = _G.UIDropDownMenu_CreateInfo()
        info.text = L['Wowhead Link']
        info.func = function()
            local text = linkQuest:format(id)
            _G.StaticPopup_Show('ANDROMEDA_WOWHEAD_LINK', _, _, text)
        end
        info.notCheckable = true
        _G.UIDropDownMenu_AddButton(info, _G.UIDROPDOWN_MENU_LEVEL)
    end)

    hooksecurefunc('AchievementObjectiveTracker_OnOpenDropDown', function(self)
        local id = self.activeFrame.id
        local info = _G.UIDropDownMenu_CreateInfo()
        info.text = L['Wowhead Link']
        info.func = function()
            local text = linkAchievement:format(id)
            _G.StaticPopup_Show('ANDROMEDA_WOWHEAD_LINK', _, _, text)
        end
        info.notCheckable = true
        _G.UIDropDownMenu_AddButton(info, _G.UIDROPDOWN_MENU_LEVEL)
    end)

    if IsAddOnLoaded('Blizzard_AchievementUI') then
        hooksecurefunc('AchievementButton_OnClick', Button_Onclick)
    else
        F:RegisterEvent('ADDON_LOADED', QUEST.Load)
    end
end
