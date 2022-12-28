local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local newString = '0:0:64:64:5:59:5:59'

function TOOLTIP:SetupTooltipIcon(icon)
    local title = icon and _G[self:GetName() .. 'TextLeft1']
    local titleText = title and title:GetText()
    if titleText and not strfind(titleText, ':20:20:') then
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

function TOOLTIP:HookTooltipMethod()
    self:HookScript('OnTooltipCleared', TOOLTIP.HookTooltipCleared)
end

function TOOLTIP:ReskinRewardIcon()
    self.Icon:SetTexCoord(unpack(C.TEX_COORD))
    self.bg = F.CreateBDFrame(self.Icon, 0)
    F.ReskinIconBorder(self.IconBorder)
end

local getTooltipTextureByType = {
    [Enum.TooltipDataType.Item] = function(id)
        return GetItemIcon(id)
    end,

    [Enum.TooltipDataType.Toy] = function(id)
        return GetItemIcon(id)
    end,

    [Enum.TooltipDataType.Spell] = function(id)
        return GetSpellTexture(id)
    end,

    [Enum.TooltipDataType.Mount] = function(id)
        return select(3, C_MountJournal.GetMountInfoByID(id))
    end,
}

function TOOLTIP:ReskinTipIcon()
    if not C.DB.Tooltip.Icon then
        return
    end

    local GameTooltip = _G.GameTooltip
    local ItemRefTooltip = _G.ItemRefTooltip
    local TooltipDataProcessor = _G.TooltipDataProcessor
    local EmbeddedItemTooltip = _G.EmbeddedItemTooltip

    -- Add Icons
    TOOLTIP.HookTooltipMethod(GameTooltip)
    TOOLTIP.HookTooltipMethod(ItemRefTooltip)

    for tooltipType, getTex in next, getTooltipTextureByType do
        TooltipDataProcessor.AddTooltipPostCall(tooltipType, function(self)
            if self == GameTooltip or self == ItemRefTooltip then
                local data = self:GetTooltipData()
                local id = data and data.id

                if id then
                    TOOLTIP.SetupTooltipIcon(self, getTex(id))
                end
            end
        end)
    end

    -- Cut Icons
    hooksecurefunc(GameTooltip, 'SetUnitAura', function(self)
        TOOLTIP.SetupTooltipIcon(self)
    end)

    hooksecurefunc(GameTooltip, 'SetAzeriteEssence', function(self)
        TOOLTIP.SetupTooltipIcon(self)
    end)

    hooksecurefunc(GameTooltip, 'SetAzeriteEssenceSlot', function(self)
        TOOLTIP.SetupTooltipIcon(self)
    end)

    -- Tooltip rewards icon
    TOOLTIP.ReskinRewardIcon(GameTooltip.ItemTooltip)
    TOOLTIP.ReskinRewardIcon(EmbeddedItemTooltip.ItemTooltip)
end
