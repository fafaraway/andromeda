local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule('blizzard')

function module:OnLogin()
	self:FontStyle()
	self:PetBattleUI()
	self:EnhanceColorPicker()
	self:PositionUIWidgets()
	self:QuestTracker()
end


-- Prevents spells from being automatically added to your action bar
-- This prevents icons from being animated onto the main action bar
IconIntroTracker.RegisterEvent = function() end
IconIntroTracker:UnregisterEvent('SPELL_PUSHED_TO_ACTIONBAR')

-- In the unlikely event that you're looking at a different action page while switching talents
-- the spell is automatically added to your main bar. This takes it back off.
local f = CreateFrame('frame')
f:SetScript('OnEvent', function(self, event, spellID, slotIndex, slotPos)
	-- This event should never fire in combat, but check anyway
	if not InCombatLockdown() then
		ClearCursor()
		PickupAction(slotIndex)
		ClearCursor()
	end
end)
f:RegisterEvent('SPELL_PUSHED_TO_ACTIONBAR')


C.reactioncolours = {
	[1] = {139/255, 39/255, 60/255}, 	-- Exceptionally hostile
	[2] = {217/255, 51/255, 22/255}, 	-- Very Hostile
	[3] = {231/255, 87/255, 83/255}, 	-- Hostile
	[4] = {213/255, 201/255, 128/255}, 	-- Neutral
	[5] = {184/255, 243/255, 147/255}, 	-- Friendly
	[6] = {115/255, 231/255, 62/255}, 	-- Very Friendly
	[7] = {107/255, 231/255, 157/255}, 	-- Exceptionally friendly
	[8] = {44/255, 153/255, 111/255}, 	-- Exalted
}

-- custom reputation color
hooksecurefunc('ReputationFrame_Update', function(showLFGPulse)
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

	for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionBar = _G['ReputationBar'..i..'ReputationBar']

		if factionIndex <= numFactions then
			local name, description, standingID = GetFactionInfo(factionIndex)
			local colorIndex = standingID

			local color = C.reactioncolours[colorIndex]
			factionBar:SetStatusBarColor(color[1], color[2], color[3])
		end
	end
end)

hooksecurefunc(ReputationBarMixin, 'Update', function(self)
	local name, reaction, minBar, maxBar, value, factionID = GetWatchedFactionInfo();
	local colorIndex = reaction;

	local color = C.reactioncolours[colorIndex];
	self:SetBarColor(color[1], color[2], color[3], 1);
end)




