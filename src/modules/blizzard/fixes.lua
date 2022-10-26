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

-- Fix WhoFrame level column width
do
    hooksecurefunc('WhoList_Update', function()
        if not C.IS_NEW_PATCH then
            return
        end

        local buttons = _G.WhoListScrollFrame.buttons
        for i = 1, #buttons do
            local button = buttons[i]
            local level = button.Level
            if level and not level.fontStyled then
                level:SetWidth(32)
                level:SetJustifyH('LEFT')
                level.fontStyled = true
            end
        end
    end)
end

-- Fix Trade Skill Search
do
    hooksecurefunc('ChatEdit_InsertLink', function(text) -- shift-clicked
        if C.IS_NEW_PATCH then
            return
        end

        -- change from SearchBox:HasFocus to :IsShown again
        if text and _G.TradeSkillFrame and _G.TradeSkillFrame:IsShown() then
            local spellId = strmatch(text, 'enchant:(%d+)')
            local spell = GetSpellInfo(spellId)
            local item = GetItemInfo(strmatch(text, 'item:(%d+)') or 0)
            local search = spell or item
            if not search then
                return
            end

            -- search needs to be lowercase for .SetRecipeItemNameFilter
            _G.TradeSkillFrame.SearchBox:SetText(search)

            -- jump to the recipe
            if spell then -- can only select recipes on the learned tab
                if _G.PanelTemplates_GetSelectedTab(_G.TradeSkillFrame.RecipeList) == 1 then
                    _G.TradeSkillFrame:SelectRecipe(tonumber(spellId))
                end
            elseif item then
                F:Delay(0.1, function() -- wait a bit or we cant select the recipe yet
                    for _, v in pairs(_G.TradeSkillFrame.RecipeList.dataList) do
                        if v.name == item then
                            -- TradeSkillFrame.RecipeList:RefreshDisplay() -- didnt seem to help
                            _G.TradeSkillFrame:SelectRecipe(v.recipeID)
                            return
                        end
                    end
                end)
            end
        end
    end)
end

-- make it only split stacks with shift-rightclick if the TradeSkillFrame is open
-- shift-leftclick should be reserved for the search box
do
    local function hideSplitFrame(_, button)
        if _G.TradeSkillFrame and _G.TradeSkillFrame:IsShown() then
            if button == 'LeftButton' then
                _G.StackSplitFrame:Hide()
            end
        end
    end
    hooksecurefunc('ContainerFrameItemButton_OnModifiedClick', hideSplitFrame)
    hooksecurefunc('MerchantItemButton_OnModifiedClick', hideSplitFrame)
end

-- SpellBook fix in 46157
do
    if not C.IS_BETA then
        return
    end

    local function replaceOnEnter(self)
        local slot = SpellBook_GetSpellBookSlot(self)
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

        if InClickBindingMode() and not self.canClickBind then
            _G.GameTooltip:AddLine(_G.CLICK_BINDING_NOT_AVAILABLE, _G.RED_FONT_COLOR.r, _G.RED_FONT_COLOR.g, _G.RED_FONT_COLOR.b)
            _G.GameTooltip:Show()
            return
        end

        _G.GameTooltip:SetSpellBookItem(slot, _G.SpellBookFrame.bookType)
        self.UpdateTooltip = nil

        if self.SpellHighlightTexture and self.SpellHighlightTexture:IsShown() then
            _G.GameTooltip:AddLine(_G.SPELLBOOK_SPELL_NOT_ON_ACTION_BAR, _G.LIGHTBLUE_FONT_COLOR.r, _G.LIGHTBLUE_FONT_COLOR.g, _G.LIGHTBLUE_FONT_COLOR.b)
        end
        _G.GameTooltip:Show()
    end

    local function handleSpellButton(button)
        button.OnEnter = replaceOnEnter
        button:SetScript('OnEnter', replaceOnEnter)
    end

    for i = 1, _G.SPELLS_PER_PAGE do
        handleSpellButton(_G['SpellButton' .. i])
    end

    local professions = { 'PrimaryProfession1', 'PrimaryProfession2', 'SecondaryProfession1', 'SecondaryProfession2', 'SecondaryProfession3' }
    for _, button in pairs(professions) do
        local bu = _G[button]
        handleSpellButton(bu.SpellButton1)
        handleSpellButton(bu.SpellButton2)
    end
end
