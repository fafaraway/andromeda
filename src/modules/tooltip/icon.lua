local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local newString = '0:0:64:64:5:59:5:59'

function TOOLTIP:SetupTooltipIcon(icon)
    local title = icon and _G[self:GetName() .. 'TextLeft1']
    local titleText = title and title:GetText()
    if titleText then
        title:SetFormattedText('|T%s:20:20:' .. newString .. ':%d|t %s', icon, 20, titleText)
    end

    for i = 2, self:NumLines() do
        local line = _G[self:GetName() .. 'TextLeft' .. i]
        if not line then
            break
        end

        local text = line:GetText()
        if text and text ~= ' ' then
            local newText, count = gsub(text, '|T([^:]-):[%d+:]+|t', '|T%1:14:14:' .. newString .. '|t')
            if count > 0 then
                line:SetText(newText)
            end
        end
    end
end

function TOOLTIP:HookTooltipCleared()
    self.tipModified = false
end

function TOOLTIP:HookTooltipSetItem()
    if not self.tipModified then
        local _, link = self:GetItem()
        if link then
            TOOLTIP.SetupTooltipIcon(self, GetItemIcon(link))
        end

        self.tipModified = true
    end
end

function TOOLTIP:HookTooltipSetSpell()
    if not self.tipModified then
        local _, id = self:GetSpell()
        if id then
            TOOLTIP.SetupTooltipIcon(self, GetSpellTexture(id))
        end

        self.tipModified = true
    end
end

function TOOLTIP:HookTooltipMethod()
    self:HookScript('OnTooltipSetItem', TOOLTIP.HookTooltipSetItem)
    self:HookScript('OnTooltipSetSpell', TOOLTIP.HookTooltipSetSpell)
    self:HookScript('OnTooltipCleared', TOOLTIP.HookTooltipCleared)
end

function TOOLTIP:ReskinRewardIcon()
    self.Icon:SetTexCoord(unpack(C.TEX_COORD))
    self.bg = F.CreateBDFrame(self.Icon, 0)
    F.ReskinIconBorder(self.IconBorder)
end

function TOOLTIP:ReskinTipIcon()
    if not C.DB.Tooltip.Icon then
        return
    end

    TOOLTIP.HookTooltipMethod(_G.GameTooltip)
    TOOLTIP.HookTooltipMethod(_G.ItemRefTooltip)

    hooksecurefunc(_G.GameTooltip, 'SetUnitAura', function(self)
        TOOLTIP.SetupTooltipIcon(self)
    end)

    hooksecurefunc(_G.GameTooltip, 'SetAzeriteEssence', function(self)
        TOOLTIP.SetupTooltipIcon(self)
    end)
    hooksecurefunc(_G.GameTooltip, 'SetAzeriteEssenceSlot', function(self)
        TOOLTIP.SetupTooltipIcon(self)
    end)

    -- Tooltip rewards icon
    TOOLTIP.ReskinRewardIcon(_G.GameTooltip.ItemTooltip)
    TOOLTIP.ReskinRewardIcon(_G.EmbeddedItemTooltip.ItemTooltip)
end
