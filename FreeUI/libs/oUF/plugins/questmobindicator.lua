--[[
# Element: Quest Indicator
Handles the visibility and updating of an indicator based on the unit's involvement in a quest.
## Widget
QuestMobIndicator - Any UI widget.
## Notes
A default texture will be applied if the widget is a Texture and doesn't have a texture or a color set.
## Examples
    -- Position and size
    local QuestMobIndicator = self:CreateTexture(nil, 'OVERLAY')
    QuestMobIndicator:SetSize(16, 16)
    QuestMobIndicator:SetPoint('TOPRIGHT', self)
    -- Register it with oUF
    self.QuestMobIndicator = QuestMobIndicator
--]]
local _, ns = ...
local oUF = ns.oUF

if (oUF.isClassic) then
	return
end

local TooltipScanner = CreateFrame('GameTooltip', 'QuestMobScanningTooltip', nil, 'GameTooltipTemplate') -- Tooltip name cannot be nil
TooltipScanner:SetOwner(WorldFrame, 'ANCHOR_NONE')

local function BreakdownTooltipLine(lineNumber)
	local tooltipLine = _G['QuestMobScanningTooltipTextLeft' .. lineNumber]
	local tooltipText = tooltipLine:GetText()
	local r, g, b = tooltipLine:GetTextColor()

	return tooltipText, r, g, b
end

local function GetUnitQuestInfo(unitGUID)
	local questName, questUnit, questProgress
	local questList = {}
	local questTexture = {[628564] = true, [3083385] = true}
	local objectiveCount = 0

	if not unitGUID then
		return
	end

	TooltipScanner:ClearLines()
	TooltipScanner:SetUnit(unitGUID)

	-- Get lines with quest information on them
	for line = 1, TooltipScanner:NumLines() do
		-- Get amount of quest objectives through counting textures
		local texture = _G['QuestMobScanningTooltipTexture' .. line]
		if texture and questTexture[texture:GetTexture()] then
			objectiveCount = objectiveCount + 1
		end

		if line > 1 then
			local tooltipText, r, g, b = BreakdownTooltipLine(line)
			local lineIsQuestHeader = (b == 0 and r > 0.99 and g > 0.82) -- Note: Quest Name Heading is colored Yellow. (As well as the player on that quest as of 8.2.5)

			if lineIsQuestHeader then
				questName = tooltipText
				questList[questName] = questList[questName] or {}
			elseif questName and objectiveCount > 0 then
				table.insert(questList[questName], tooltipText)
				objectiveCount = objectiveCount - 1 -- Decrease objective Count
			end
		end
	end

	if questList[UnitName('player')] then
		return {player = questList[UnitName('player')]} -- Wrap it so the quest widget can parse it properly
	elseif not IsInGroup() then
		return questList
	end

	return {}
end

local function Update(self, event, unit)
	if (unit ~= self.unit) then
		return
	end

	local element = self.QuestMobIndicator

	--[[ Callback: QuestMobIndicator:PreUpdate()
	Called before the element has been updated.
	* self - the QuestMobIndicator element
	--]]
	if (element.PreUpdate) then
		element:PreUpdate()
	end


	local isDungeon = IsInInstance()
	local questList = GetUnitQuestInfo(unit)
	local showIcon = false

	for questName, questObjectives in pairs(questList) do
		for k,questObjective in ipairs(questObjectives) do
			local questProgress, questTotal
			if questObjective then
				questProgress, questTotal = string.match(questObjective, "([0-9]+)/([0-9]+)")
				questProgress = tonumber(questProgress)
				questTotal = tonumber(questTotal)
			end

			if (not isDungeon and ((questName and not (questProgress and questTotal)) or (questProgress and questTotal and questProgress < questTotal))) then
				showIcon = true
			end
		end
	end

	if (showIcon) then
		element:Show()
	else
		element:Hide()
	end

	--[[ Callback: QuestMobIndicator:PostUpdate(isQuestBoss)
	Called after the element has been updated.
	* self        - the QuestMobIndicator element
	* isQuestBoss - indicates if the element is shown (boolean)
	--]]
	if (element.PostUpdate) then
		return element:PostUpdate(isQuestBoss)
	end
end

local function Path(self, ...)
	--[[ Override: QuestMobIndicator.Override(self, event, ...)
	Used to completely override the internal update function.
	* self  - the parent object
	* event - the event triggering the update (string)
	* ...   - the arguments accompanying the event
	--]]
	return (self.QuestMobIndicator.Override or Update)(self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.QuestMobIndicator
	if (element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_CLASSIFICATION_CHANGED', Path)

		if (element:IsObjectType('Texture') and not element:GetTexture()) then
			element:SetTexture([[Interface\TargetingFrame\PortraitQuestBadge]])
		end

		return true
	end
end

local function Disable(self)
	local element = self.QuestMobIndicator
	if (element) then
		element:Hide()

		self:UnregisterEvent('UNIT_CLASSIFICATION_CHANGED', Path)
	end
end

oUF:AddElement('QuestMobIndicator', Path, Enable, Disable)
