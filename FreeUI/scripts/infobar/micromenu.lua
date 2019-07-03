local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')


local FreeUIMicroMenuButton = INFOBAR.FreeUIMicroMenuButton

local menuFrame = CreateFrame('Frame', 'FreeUI_MicroMenu', FreeUIMicroMenuButton, 'DropDownMenuTemplate')

local microMenu = {
	{text = CHARACTER_BUTTON, notCheckable = true, func = function() ToggleCharacter('PaperDollFrame') end},
	{text = SPELLBOOK_ABILITIES_BUTTON, notCheckable = true, func = function() ToggleFrame(SpellBookFrame) end},
	{text = TALENTS_BUTTON, notCheckable = true, func = function()
		if not PlayerTalentFrame then
			LoadAddOn('Blizzard_TalentUI')
		end

		if not GlyphFrame then
			LoadAddOn('Blizzard_GlyphUI')
		end
		PlayerTalentFrame_Toggle()
	end},
	{text = ACHIEVEMENT_BUTTON, notCheckable = true, func = ToggleAchievementFrame},
	{text = WORLD_MAP..' / '..QUESTLOG_BUTTON, notCheckable = true, func = function() ShowUIPanel(WorldMapFrame) end},
	{text = COLLECTIONS, notCheckable = true, func = function() ToggleCollectionsJournal() end},
	{text = SOCIAL_BUTTON, notCheckable = true, func = function() ToggleFriendsFrame(1) end},
	{text = COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVE, notCheckable = true, func = function() PVEFrame_ToggleFrame() end},
	{text = COMPACT_UNIT_FRAME_PROFILE_AUTOACTIVATEPVP, notCheckable = true, func = TogglePVPUI},
	{text = ACHIEVEMENTS_GUILD_TAB, notCheckable = true, func = function()
		if IsInGuild() then
			if not GuildFrame then GuildFrame_LoadUI() end
			GuildFrame_Toggle()
		else
			if not LookingForGuildFrame then LookingForGuildFrame_LoadUI() end
			LookingForGuildFrame_Toggle()
		end
	end},
	{text = RAID, notCheckable = true, func = function() ToggleFriendsFrame(4) end},
	{text = HELP_BUTTON, notCheckable = true, func = ToggleHelpFrame},
	{text = CALENDAR_VIEW_EVENT, notCheckable = true, func = function()
		if(not CalendarFrame) then LoadAddOn('Blizzard_Calendar') end
		Calendar_Toggle()
	end},
	{text = ENCOUNTER_JOURNAL, notCheckable = true, func = ToggleEncounterJournal},
	{text = BLIZZARD_STORE, notCheckable = true, func = function() StoreMicroButton:Click() end},
}

local taint
taint = function(event, addon)
	if addon ~= 'FreeUI' then return end
	ToggleFrame(SpellBookFrame)
	F.UnregisterEvent('ADDON_LOADED', taint)
end


function INFOBAR:MicroMenu()
	if not C.infobar.enable then return end
	if not C.infobar.microMenu then return end

	F:RegisterEvent('ADDON_LOADED', taint)

	local MicroMenu = function()
		menuFrame:SetPoint('TOPLEFT', FreeUIMicroMenuButton, 'TOPLEFT', 20, 0)
		EasyMenu(microMenu, menuFrame, menuFrame, 0, 0, 'MENU')
	end

	FreeUIMicroMenuButton = INFOBAR:addButton('Micro menu', INFOBAR.POSITION_LEFT, 100, function(self, button)
		if button == 'LeftButton' then
			if DropDownList1:IsShown() then
				ToggleFrame(DropDownList1)
			else
				MicroMenu()
			end
		end
	end)
end