--[[
    Generate wowhead link for quest and achievement
]]

local _G = _G
local unpack = unpack
local select = select
local hooksecurefunc = hooksecurefunc
local UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local StaticPopup_Show = StaticPopup_Show
local IsAddOnLoaded = IsAddOnLoaded
local IsControlKeyDown = IsControlKeyDown

local F, _, L = unpack(select(2, ...))
local WL = F:RegisterModule('WowheadLink')

local linkQuest = 'http://www.wowhead.com/quest=%d'
local linkAchievement = 'http://www.wowhead.com/achievement=%d'
local selfText

_G.StaticPopupDialogs.WOWHEAD_LINK = {
    text = L['Wowhead link'],
    button1 = _G.OKAY,
    timeout = 0,
    whileDead = true,
    hasEditBox = true,
    editBoxWidth = 350,
    OnShow = function(self, text)
        self.editBox:SetMaxLetters(0)
        self.editBox:SetText(text)
        self.editBox:HighlightText()
        selfText = text
    end,
    EditBoxOnEnterPressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
    EditBoxOnTextChanged = function(self)
        if self:GetText():len() < 1 then
            self:GetParent():Hide()
        else
            self:SetText(selfText)
            self:HighlightText()
        end
    end,
    preferredIndex = 5,
}

local function Button_Onclick(self)
    if self.id and IsControlKeyDown() then
        local text = linkAchievement:format(self.id)
        StaticPopup_Show('WOWHEAD_LINK', _, _, text)
    end
end

function WL:Load(addon)
    if addon == 'Blizzard_AchievementUI' then
        hooksecurefunc('AchievementButton_OnClick', Button_Onclick)

        F:UnregisterEvent(self, WL.Load)
    end
end

function WL:OnLogin()
    hooksecurefunc('QuestObjectiveTracker_OnOpenDropDown', function(self)
        local id = self.activeFrame.id
        local info = UIDropDownMenu_CreateInfo()
        info.text = L['Wowhead link']
        info.func = function()
            local text = linkQuest:format(id)
            StaticPopup_Show('WOWHEAD_LINK', _, _, text)
        end
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, _G.UIDROPDOWN_MENU_LEVEL)
    end)

    hooksecurefunc('BonusObjectiveTracker_OnOpenDropDown', function(self)
        local id = self.activeFrame.TrackedQuest.questID
        local info = UIDropDownMenu_CreateInfo()
        info.text = L['Wowhead link']
        info.func = function()
            local text = linkQuest:format(id)
            StaticPopup_Show('WOWHEAD_LINK', _, _, text)
        end
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, _G.UIDROPDOWN_MENU_LEVEL)
    end)

    hooksecurefunc('AchievementObjectiveTracker_OnOpenDropDown', function(self)
        local id = self.activeFrame.id
        local info = UIDropDownMenu_CreateInfo()
        info.text = L['Wowhead link']
        info.func = function()
            local text = linkAchievement:format(id)
            StaticPopup_Show('WOWHEAD_LINK', _, _, text)
        end
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, _G.UIDROPDOWN_MENU_LEVEL)
    end)

    if IsAddOnLoaded('Blizzard_AchievementUI') then
        hooksecurefunc('AchievementButton_OnClick', Button_Onclick)
    else
        F:RegisterEvent('ADDON_LOADED', WL.Load)
    end
end

