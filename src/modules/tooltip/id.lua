local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local LEARNT_STRING = '|cffff0000' .. _G.ALREADY_LEARNED .. '|r'

local typesList = {
    spell = _G.SPELLS .. 'ID:',
    item = _G.ITEMS .. 'ID:',
    quest = _G.QUESTS_LABEL .. 'ID:',
    talent = _G.TALENT .. 'ID:',
    achievement = _G.ACHIEVEMENTS .. 'ID:',
    currency = _G.CURRENCY .. 'ID:',
    azerite = L['Trait'] .. 'ID:',
}

function TOOLTIP:AddLineForID(id, linkType, noadd)
    if self:IsForbidden() then
        return
    end

    if C.DB.Tooltip.ShowIDsByAlt and not IsAltKeyDown() then
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

    if self.__isHoverTip and linkType == typesList.spell and IsPlayerSpell(id) and C_MountJournal.GetMountFromSpell(id) then
        self:AddLine(LEARNT_STRING)
    end

    if not noadd then
        self:AddLine(' ')
    end

    self:AddDoubleLine(linkType, format(C.INFO_COLOR .. '%s|r', id))
    self:Show()
end

function TOOLTIP:SetHyperLinkID(link)
    if self:IsForbidden() then
        return
    end

    local linkType, id = strmatch(link, '^(%a+):(%d+)')
    if not linkType or not id then
        return
    end

    if linkType == 'spell' or linkType == 'enchant' or linkType == 'trade' then
        TOOLTIP.AddLineForID(self, id, typesList.spell)
    elseif linkType == 'talent' then
        TOOLTIP.AddLineForID(self, id, typesList.talent, true)
    elseif linkType == 'quest' then
        TOOLTIP.AddLineForID(self, id, typesList.quest)
    elseif linkType == 'achievement' then
        TOOLTIP.AddLineForID(self, id, typesList.achievement)
    elseif linkType == 'item' then
        TOOLTIP.AddLineForID(self, id, typesList.item)
    elseif linkType == 'currency' then
        TOOLTIP.AddLineForID(self, id, typesList.currency)
    end
end

function TOOLTIP:SetItemID()
    if self:IsForbidden() then
        return
    end

    local link = select(2, self:GetItem())
    if link then
        local id = GetItemInfoFromHyperlink(link)
        local keystone = strmatch(link, '|Hkeystone:([0-9]+):')
        if keystone then
            id = tonumber(keystone)
        end
        if id then
            TOOLTIP.AddLineForID(self, id, typesList.item)
        end
    end
end

function TOOLTIP:AddIDs()
    if not C.DB.Tooltip.ShowIDs then
        return
    end

    local GameTooltip = _G.GameTooltip
    local ItemRefTooltip = _G.ItemRefTooltip
    local GameTooltipTooltip = _G.GameTooltipTooltip
    local ShoppingTooltip1 = _G.ShoppingTooltip1
    local ShoppingTooltip2 = _G.ShoppingTooltip2
    local ItemRefShoppingTooltip1 = _G.ItemRefShoppingTooltip1
    local ItemRefShoppingTooltip2 = _G.ItemRefShoppingTooltip2
    local TooltipDataProcessor = _G.TooltipDataProcessor

    -- Update all
    hooksecurefunc(GameTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)
    hooksecurefunc(ItemRefTooltip, 'SetHyperlink', TOOLTIP.SetHyperLinkID)

    -- Spells
    hooksecurefunc(GameTooltip, 'SetUnitAura', function(self, ...)
        if self:IsForbidden() then
            return
        end

        local _, _, _, _, _, _, caster, _, _, id = UnitAura(...)
        if id then
            TOOLTIP.AddLineForID(self, id, typesList.spell)
        end

        if caster then
            local name = GetUnitName(caster, true)
            local hexColor = F:RgbToHex(F:UnitColor(caster))
            self:AddDoubleLine(L['From'] .. ':', hexColor .. name)
            self:Show()
        end
    end)

    hooksecurefunc('SetItemRef', function(link)
        local id = tonumber(strmatch(link, 'spell:(%d+)'))
        if id then
            TOOLTIP.AddLineForID(ItemRefTooltip, id, typesList.spell)
        end
    end)

    if C.IS_BETA then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(self, data)
            if self:IsForbidden() then
                return
            end
            if data.id then
                TOOLTIP.AddLineForID(self, data.id, typesList.spell)
            end
        end)
    else
        GameTooltip:HookScript('OnTooltipSetSpell', function(self)
            local id = select(2, self:GetSpell())
            if id then
                TOOLTIP.AddLineForID(self, id, typesList.spell)
            end
        end)
    end

    -- Items
    if C.IS_BETA then
        local function addItemID(self, data)
            if self:IsForbidden() then
                return
            end
            if data.id then
                TOOLTIP.AddLineForID(self, data.id, typesList.item)
            end
        end
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, addItemID)
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Toy, addItemID)
    else
        GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        GameTooltipTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        ShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        ItemRefShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        ItemRefShoppingTooltip2:HookScript('OnTooltipSetItem', TOOLTIP.SetItemID)
        hooksecurefunc(GameTooltip, 'SetRecipeReagentItem', function(self, recipeID, reagentIndex)
            local link = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex)
            local id = link and strmatch(link, 'item:(%d+):')
            if id then
                TOOLTIP.AddLineForID(self, id, typesList.item)
            end
        end)
    end

    -- Currencies
    hooksecurefunc(GameTooltip, 'SetCurrencyToken', function(self, index)
        local id = tonumber(strmatch(C_CurrencyInfo.GetCurrencyListLink(index), 'currency:(%d+)'))
        if id then
            TOOLTIP.AddLineForID(self, id, typesList.currency)
        end
    end)

    hooksecurefunc(GameTooltip, 'SetCurrencyByID', function(self, id)
        if id then
            TOOLTIP.AddLineForID(self, id, typesList.currency)
        end
    end)

    if not C.IS_BETA then
        hooksecurefunc(GameTooltip, 'SetCurrencyTokenByID', function(self, id)
            if id then
                TOOLTIP.AddLineForID(self, id, typesList.currency)
            end
        end)
    end

    -- Azerite traits
    hooksecurefunc(GameTooltip, 'SetAzeritePower', function(self, _, _, id)
        if id then
            TOOLTIP.AddLineForID(self, id, typesList.azerite, true)
        end
    end)

    -- Quests
    hooksecurefunc('QuestMapLogTitleButton_OnEnter', function(self)
        if self.questID then
            TOOLTIP.AddLineForID(GameTooltip, self.questID, typesList.quest)
        end
    end)
end
