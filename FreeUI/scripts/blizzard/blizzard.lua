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




