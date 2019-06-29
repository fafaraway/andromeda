local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local strfind, gsub, unpack = string.find, gsub, unpack
local GetItemIcon, GetSpellTexture = GetItemIcon, GetSpellTexture
local newString = '0:0:64:64:5:59:5:59'

function TOOLTIP:SetupTooltipIcon(icon)
	local title = icon and _G[self:GetName()..'TextLeft1']
	if title then
		title:SetFormattedText('|T%s:20:20:'..newString..':%d|t %s', icon, 20, title:GetText())
	end

	for i = 2, self:NumLines() do
		local line = _G[self:GetName()..'TextLeft'..i]
		if not line then break end
		local text = line:GetText() or ''
		if strmatch(text, '|T.-:[%d+:]+|t') then
			line:SetText(gsub(text, '|T(.-):[%d+:]+|t', '|T%1:20:20:'..newString..'|t'))
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
	if self and self.Icon then
		self.Icon:SetTexCoord(unpack(C.TexCoord))
		self.IconBorder:SetAlpha(0)
	end
end

local function reskinQuestCurrencyRewardIcon(_, _, self)
	TOOLTIP.ReskinRewardIcon(self)
end

function TOOLTIP:ReskinTooltipIcons()
	if not C.tooltip.tipIcon then return end

	TOOLTIP.HookTooltipMethod(GameTooltip)
	TOOLTIP.HookTooltipMethod(ItemRefTooltip)

	hooksecurefunc(GameTooltip, "SetAzeriteEssence", function(self)
		TOOLTIP.SetupTooltipIcon(self)
	end)
	hooksecurefunc(GameTooltip, "SetAzeriteEssenceSlot", function(self)
		TOOLTIP.SetupTooltipIcon(self)
	end)

	-- Tooltip rewards icon
	_G.BONUS_OBJECTIVE_REWARD_WITH_COUNT_FORMAT = '|T%1$s:16:16:'..newString..'|t |cffffffff%2$s|r %3$s'
	_G.BONUS_OBJECTIVE_REWARD_FORMAT = '|T%1$s:16:16:'..newString..'|t %2$s'

	hooksecurefunc('EmbeddedItemTooltip_SetItemByQuestReward', TOOLTIP.ReskinRewardIcon)
	hooksecurefunc('EmbeddedItemTooltip_SetItemByID', TOOLTIP.ReskinRewardIcon)
	hooksecurefunc('EmbeddedItemTooltip_SetCurrencyByID', TOOLTIP.ReskinRewardIcon)
	hooksecurefunc('QuestUtils_AddQuestCurrencyRewardsToTooltip', reskinQuestCurrencyRewardIcon)
end