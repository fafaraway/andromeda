local F, C = unpack(select(2, ...))

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

-- make it only split stacks with shift-rightclick if the TradeSkillFrame is open
-- shift-leftclick should be reserved for the search box
do
    -- local function hideSplitFrame(_, button)
    --     if _G.TradeSkillFrame and _G.TradeSkillFrame:IsShown() then
    --         if button == 'LeftButton' then
    --             _G.StackSplitFrame:Hide()
    --         end
    --     end
    -- end
    -- hooksecurefunc('ContainerFrameItemButton_OnModifiedClick', hideSplitFrame)
    -- hooksecurefunc('MerchantItemButton_OnModifiedClick', hideSplitFrame)
end

