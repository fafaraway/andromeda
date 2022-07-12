local F = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local USED_STRING = ' |cffff0000(' .. _G.USED .. ')|r'

local questItems = {
    [181443] = 61459, -- 聚会通报官的聚会帽
    [187136] = 64367, -- 研究报告-圣物检查技巧
    [190184] = 65623, -- 无穷熏香
    [188793] = 65282, -- 临时密文分析工具
}

function TOOLTIP:AlreadyUsed_CheckStatus()
    local _, link = self:GetItem()
    if not link then
        return
    end

    local itemID = GetItemInfoFromHyperlink(link)
    local questID = itemID and questItems[itemID]

    if questID and C_QuestLog.IsQuestFlaggedCompleted(questID) then
        local line = _G[self:GetName() .. 'TextLeft1']
        local text = line and line:GetText()
        if text then
            line:SetText(text .. USED_STRING)
            self:Show()
        end
    end
end

function TOOLTIP:AlreadyUsed()
    _G.GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.AlreadyUsed_CheckStatus)
    _G.ItemRefTooltip:HookScript('OnTooltipSetItem', TOOLTIP.AlreadyUsed_CheckStatus)
    _G.ShoppingTooltip1:HookScript('OnTooltipSetItem', TOOLTIP.AlreadyUsed_CheckStatus)
    _G.EmbeddedItemTooltip:HookScript('OnTooltipSetItem', TOOLTIP.AlreadyUsed_CheckStatus)
end
