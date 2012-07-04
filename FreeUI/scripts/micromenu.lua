local F, C = unpack(FreeUI)

local menuFrame = CreateFrame("Frame", "FreeUI_MicroMenu", UIParent, "UIDropDownMenuTemplate")

local microMenu = {
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function() ToggleFrame(SpellBookFrame) end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			LoadAddOn("Blizzard_TalentUI")
		end

		if not GlyphFrame then
			LoadAddOn("Blizzard_GlyphUI")
		end
		PlayerTalentFrame_Toggle()
	end},
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = MOUNTS_AND_PETS,
	func = function() TogglePetJournal() end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame(1) end},
	{text = LFG_TITLE,
	func = function() PVEFrame_ToggleFrame(); end},
	{text = PLAYER_V_PLAYER,
	func = function() ToggleFrame(PVPFrame) end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LoadAddOn("Blizzard_LookingForGuildUI") end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = RAID,
	func = function() ToggleFrame(RaidParentFrame) end},
	{text = HELP_BUTTON,
	func = function() ToggleHelpFrame() end},
	{text = CALENDAR_VIEW_EVENT,
	func = function()
	if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
		Calendar_Toggle()
	end},
	{text = ENCOUNTER_JOURNAL,
	func = function() ToggleEncounterJournal() end},
}

-- spellbook need at least 1 opening else it taint in combat
local taint = CreateFrame("Frame")
taint:RegisterEvent("PLAYER_ENTERING_WORLD")
taint:SetScript("OnEvent", function(self)
	ToggleFrame(SpellBookFrame)
	ToggleFrame(SpellBookFrame)
end)

F.MicroMenu = function()
	EasyMenu(microMenu, menuFrame, Minimap, -185, 253, 1)
end