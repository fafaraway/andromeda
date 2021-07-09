local _G = _G
local unpack = unpack
local select = select
local strmatch = strmatch
local tonumber = tonumber
local UnitAura = UnitAura
local GetItemCount = GetItemCount
local GetItemInfo = GetItemInfo
local GetUnitName = GetUnitName
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local C_TradeSkillUI_GetRecipeReagentItemLink = C_TradeSkillUI.GetRecipeReagentItemLink
local IsAltKeyDown = IsAltKeyDown
local GameTooltip_ClearMoney = GameTooltip_ClearMoney
local hooksecurefunc = hooksecurefunc
local UnitGUID = UnitGUID
local C_PetBattles_IsInBattle = C_PetBattles.IsInBattle
local C_CurrencyInfo_GetCurrencyListLink = C_CurrencyInfo.GetCurrencyListLink

local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local types = {
    spell = 'SpellID',
    item = 'ItemID',
    currency = 'CurrencyID',
    quest = 'QuestID',
    achievement = 'AchievementID',
    unit = 'NPCID'
}

function TOOLTIP:AddLineForID(id, linkType, noadd)
    if not id or id == '' then
        return
    end

    if type(id) == 'table' and #id == 1 then
        id = id[1]
    end

    if not IsAltKeyDown() then
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

    local left, right
    if type(id) == 'table' then
        left = _G.NORMAL_FONT_COLOR_CODE .. linkType .. 's:' .. _G.FONT_COLOR_CODE_CLOSE
        right = C.BlueColor .. table.concat(id, ', ') .. _G.FONT_COLOR_CODE_CLOSE
    else
        left = _G.NORMAL_FONT_COLOR_CODE .. linkType .. ':' .. _G.FONT_COLOR_CODE_CLOSE
        right = C.BlueColor .. id .. _G.FONT_COLOR_CODE_CLOSE
    end

    if not noadd then
        self:AddLine(' ')
    end

    if linkType == types.item then
        local bagCount = GetItemCount(id)
        local bankCount = GetItemCount(id, true) - bagCount
        local itemStackCount = select(8, GetItemInfo(id))
        -- local itemSellPrice = select(11, GetItemInfo(id))

        if bankCount > 0 then
            self:AddDoubleLine(_G.BAGSLOT .. '/' .. _G.BANK .. ':', C.BlueColor .. bagCount .. '/' .. bankCount)
        elseif bagCount > 1 then
            self:AddDoubleLine(_G.BAGSLOT .. ':', C.BlueColor .. bagCount)
        end
        if itemStackCount and itemStackCount > 1 then
            self:AddDoubleLine(L['Stack'] .. ':', C.BlueColor .. itemStackCount)
        end
    end

    -- self:AddDoubleLine(linkType, format('%s', C.WhiteColor .. id))
    self:AddDoubleLine(left, right)
    self:Show()
end

function TOOLTIP:SetHyperLinkID(link)
    local linkType, id = strmatch(link, '^(%a+):(%d+)')
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
        local keystone = strmatch(link, '|Hkeystone:([0-9]+):')
        if keystone then
            id = tonumber(keystone)
        end
        if id then
            TOOLTIP.AddLineForID(self, id, types.item)
        end
    end
end



function TOOLTIP:RemoveMoneyLine() -- #TODO
    if not self.shownMoneyFrames then
        return
    end

    GameTooltip_ClearMoney(self)
end

function TOOLTIP:ExtraInfo()
    if not C.DB.Tooltip.ExtraInfo then
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
            local id = tonumber(strmatch(link, 'spell:(%d+)'))
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

    -- GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.RemoveMoneyLine)

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
            local link = C_TradeSkillUI_GetRecipeReagentItemLink(recipeID, reagentIndex)
            local id = link and strmatch(link, 'item:(%d+):')
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
            local id = tonumber(strmatch(C_CurrencyInfo_GetCurrencyListLink(index), 'currency:(%d+)'))
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
            if C_PetBattles_IsInBattle() then
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


