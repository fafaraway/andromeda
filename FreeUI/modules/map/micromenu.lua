local F, C, L = unpack(select(2, ...))
local MAP = F:GetModule('MAP')


local menuFrame = CreateFrame('Frame', 'MinimapRightClickMenu', Minimap, 'UIDropDownMenuTemplate')
local menuList = {
	{
		text = MAINMENU_BUTTON,
		isTitle = true,
		notCheckable = true,
	},
	{
		text = CHARACTER_BUTTON,
		icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
		func = function()
			securecall(ToggleCharacter, 'PaperDollFrame')
		end,
		notCheckable = true,
	},
	{
		text = SPELLBOOK_ABILITIES_BUTTON,
		icon = 'Interface\\MINIMAP\\TRACKING\\Class',
		func = function()
			--securecall(ToggleSpellBook, SpellBookFrame)
			if not SpellBookFrame:IsShown() then
				ShowUIPanel(SpellBookFrame)
			else
				HideUIPanel(SpellBookFrame)
			end
		end,
		notCheckable = true,
	},
	{
		text = TALENTS_BUTTON,
		icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
		func = function()
			if (not PlayerTalentFrame) then
				LoadAddOn('Blizzard_TalentUI')
			end
			if (not GlyphFrame) then
				LoadAddOn('Blizzard_GlyphUI')
			end
			securecall(ToggleFrame, PlayerTalentFrame)
		end,
		notCheckable = true,
	},
	{
		text = ACHIEVEMENT_BUTTON,
		icon = 'Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Shield',
		func = function()
			securecall(ToggleAchievementFrame)
		end,
		notCheckable = true,
	},
	{
		text = MAP_AND_QUEST_LOG,
		icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
		func = function()
			securecall(ToggleFrame, WorldMapFrame)
		end,
		notCheckable = true,
	},
	{
		text = COMMUNITIES,
		icon = 'Interface\\GossipFrame\\ChatBubbleGossipIcon',
		arg1 = IsInGuild('player'),
		func = function()
			ToggleCommunitiesFrame()
		end,
		notCheckable = true,
	},
	{
		text = GUILD,
		icon = 'Interface\\GossipFrame\\TabardGossipIcon',
		arg1 = IsInGuild('player'),
		func = function()
			if (not GuildFrame) then
				LoadAddOn('Blizzard_GuildUI')
			end
			--GuildFrame_Toggle()
			securecall(ToggleFrame, GuildFrame)
		end,
		notCheckable = true,
	},
	{
		text = SOCIAL_BUTTON,
		icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
		func = function()
			securecall(ToggleFriendsFrame, 1)
		end,
		notCheckable = true,
	},
	{
		text = GROUP_FINDER,
		icon = 'Interface\\LFGFRAME\\BattleNetWorking0',
		func = function()
			securecall(ToggleLFDParentFrame)
			--securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame')
		end,
		notCheckable = true,
	},
	{
		text = COLLECTIONS,
		icon = 'Interface\\MINIMAP\\TRACKING\\Reagents',
		func = function()
			if InCombatLockdown() then
				print('|cffffff00'..ERR_NOT_IN_COMBAT..'|r') return
			end
			securecall(ToggleCollectionsJournal, 1)
		end,
		notCheckable = true,
	},
	{
		text = ADVENTURE_JOURNAL,
		icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
		func = function()
			securecall(ToggleEncounterJournal)
		end,
		notCheckable = true,
	},
	{
		text = BLIZZARD_STORE,
		icon = 'Interface\\MINIMAP\\TRACKING\\Auctioneer',
		func = function()
			if (not StoreFrame) then
				LoadAddOn('Blizzard_StoreUI')
			end
			securecall(ToggleStoreUI)
		end,
		notCheckable = true,
	},
	{
		text = '',
		isTitle = true,
		notCheckable = true,
	},
	{
		text = OTHER,
		isTitle = true,
		notCheckable = true,
	},
	{
		text = BACKPACK_TOOLTIP,
		icon = 'Interface\\MINIMAP\\TRACKING\\Banker',
		func = function()
			securecall(ToggleAllBags)
		end,
		notCheckable = true,
	},
	{
		text = GARRISON_LANDING_PAGE_TITLE,
		icon = 'Interface\\HELPFRAME\\OpenTicketIcon',
		func = function()
			securecall(ShowGarrisonLandingPage, 2)
			--HideUIPanel(GarrisonLandingPage)
			--ShowGarrisonLandingPage(LE_GARRISON_TYPE_6_0)
		end,
		notCheckable = true,
	},
	{
		text = ORDER_HALL_LANDING_PAGE_TITLE,
		icon = 'Interface\\GossipFrame\\WorkOrderGossipIcon',
		func = function()
			securecall(ShowGarrisonLandingPage, 3)
			--HideUIPanel(GarrisonLandingPage)
			--ShowGarrisonLandingPage(LE_GARRISON_TYPE_6_0)
		end,
		notCheckable = true,
	},
	{
		text = PLAYER_V_PLAYER,
		icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
		func = function()
			securecall(TogglePVPUI, 1)
		end,
		notCheckable = true,
	},
	{
		text = RAID,
		icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
		func = function()
			securecall(ToggleFriendsFrame, 3)
		end,
		notCheckable = true,
	},
	{
		text = GM_EMAIL_NAME,
		icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
		func = function()
			securecall(ToggleHelpFrame)
		end,
		notCheckable = true,
	},
	{
		text = SLASH_CALENDAR1:gsub('/(.*)','%1'),
		func = function()
			if not CalendarFrame then
				LoadAddOn('Blizzard_Calendar')
			end
			Calendar_Toggle()
		end,
		notCheckable = true,
	},
	{
		text = BATTLEFIELD_MINIMAP,
		colorCode = '|cff999999',
		func = function()
			if not BattlefieldMapFrame then
				LoadAddOn('Blizzard_BattlefieldMap')
			end
			BattlefieldMapFrame:Toggle()
		end,
		notCheckable = true,
	},
	{
		text = '',
		isTitle = true,
		notCheckable = true,
	},
}

-- taint control
local f = CreateFrame('Frame')
f:SetScript('OnEvent', function()
	ShowUIPanel(SpellBookFrame)
	HideUIPanel(SpellBookFrame)
end)
f:RegisterEvent('PLAYER_ENTERING_WORLD')


function MAP:MicroMenu()
	if not C.DB.map.micro_menu then return end

	Minimap:SetScript('OnMouseUp', function(self, button)
		if (button == 'MiddleButton') then
			EasyMenu(menuList, menuFrame, self, 0, 0, 'MENU', 3)
		elseif (button == 'RightButton') then
			--ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, (Minimap:GetWidth() * .7), -3)
			ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown,self, -(self:GetWidth()*.7), (self:GetWidth()*.3))
		else
			Minimap_OnClick(self)
		end
	end)
end

