local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local types = {
    spell = 'SpellID',
    item = 'ItemID',
    currency = 'CurrencyID',
    quest = 'QuestID',
    achievement = 'AchievementID',
    unit = 'NPCID'
}

function TOOLTIP:AddLineForID(id, linkType)
    if C.DB.Tooltip.IDsByAlt and not IsAltKeyDown() then
        return
    end

    for i = 1, self:NumLines() do
        local line = _G[self:GetName() .. 'TextLeft' .. i]
        if not line then
            break
        end
        local text = line:GetText()
        if text and text == linkType then
            return
        end
    end

    self:AddLine(' ')
    self:AddDoubleLine(linkType .. ':', id, 1, .5, .3, 1, 1, 1)
    self:Show()
end

function TOOLTIP:SetHyperLinkID(link)
    local linkType, id = string.match(link, '^(%a+):(%d+)')
    if not linkType or not id then
        return
    end

    if linkType == 'spell' or linkType == 'enchant' or linkType == 'trade' then
        TOOLTIP.AddLineForID(self, id, types.spell)
    elseif linkType == 'quest' then
        TOOLTIP.AddLineForID(self, id, types.quest)
    elseif linkType == 'achievement' then
        TOOLTIP.AddLineForID(self, id, types.achievement)
    elseif linkType == 'item' then
        TOOLTIP.AddLineForID(self, id, types.item)
    end
end

function TOOLTIP:SetItemID()
    local link = select(2, self:GetItem())
    if link then
        local id = GetItemInfoFromHyperlink(link)
        local keystone = string.match(link, '|Hkeystone:([0-9]+):')
        if keystone then
            id = tonumber(keystone)
        end
        if id then
            TOOLTIP.AddLineForID(self, id, types.item)
        end
    end
end

function TOOLTIP:AddID()
    if not C.DB.Tooltip.IDs then
        return
    end

    -- Update all
    hooksecurefunc(_G.GameTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)
    hooksecurefunc(_G.ItemRefTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)

    -- Spells
    hooksecurefunc(
        _G.GameTooltip,
        'SetUnitAura',
        function(self, ...)
            local id = select(10, UnitAura(...))
            if id then
                TOOLTIP.AddLineForID(self, id, types.spell)
            end
        end
    )

    _G.GameTooltip:HookScript(
        'OnTooltipSetSpell',
        function(self)
            local id = select(2, self:GetSpell())
            if id then
                TOOLTIP.AddLineForID(self, id, types.spell)
            end
        end
    )

    hooksecurefunc(
        'SetItemRef',
        function(link)
            local id = tonumber(string.match(link, 'spell:(%d+)'))
            if id then
                TOOLTIP.AddLineForID(_G.ItemRefTooltip, id, types.spell)
            end
        end
    )

    -- Items
    _G.GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
    _G.GameTooltipTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
    _G.ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
    _G.ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
    _G.ShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
    _G.ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
    _G.ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)

    hooksecurefunc(
        _G.GameTooltip,
        'SetToyByItemID',
        function(self, id)
            if id then
                TOOLTIP.AddLineForID(self, id, types.item)
            end
        end
    )

    hooksecurefunc(
        _G.GameTooltip,
        'SetRecipeReagentItem',
        function(self, recipeID, reagentIndex)
            local link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex)
            local id = link and string.match(link, 'item:(%d+):')
            if id then
                TOOLTIP.AddLineForID(self, id, types.item)
            end
        end
    )

    -- Currencies
    hooksecurefunc(
        _G.GameTooltip,
        'SetCurrencyToken',
        function(self, index)
            local id = tonumber(string.match(C_CurrencyInfo.GetCurrencyListLink(index), 'currency:(%d+)'))
            TOOLTIP.AddLineForID(self, id, types.currency)
        end
    )

    hooksecurefunc(
        _G.GameTooltip,
        'SetCurrencyByID',
        function(self, id)
            TOOLTIP.AddLineForID(self, id, types.currency)
        end
    )

    hooksecurefunc(
        _G.GameTooltip,
        'SetCurrencyTokenByID',
        function(self, id)
            TOOLTIP.AddLineForID(self, id, types.currency)
        end
    )

    -- NPCs
    _G.GameTooltip:HookScript(
        'OnTooltipSetUnit',
        function(self)
            if C_PetBattles.IsInBattle() then
                return
            end

            local unit = select(2, self:GetUnit())
            if unit then
                local guid = UnitGUID(unit) or ''
                local id = tonumber(guid:match('-(%d+)-%x+$'), 10)
                if id and guid:match('%a+') ~= 'Player' then
                    TOOLTIP.AddLineForID(self, id, types.unit)
                end
            end
        end
    )

    -- Quests
    hooksecurefunc(
        'QuestMapLogTitleButton_OnEnter',
        function(self)
            if self.questID then
                TOOLTIP.AddLineForID(_G.GameTooltip, self.questID, types.quest)
            end
        end
    )
end
