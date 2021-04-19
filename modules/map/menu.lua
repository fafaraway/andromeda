local F, C, L = unpack(select(2, ...))
local MAP = F.MAP

local menuList = {
	-- 標題
	{
		text = MAINMENU_BUTTON,
		isTitle = true,
		notCheckable = true
	},
	-- 角色
	{
		text = CHARACTER_BUTTON,
		icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleCharacter, 'PaperDollFrame')
		end,
		notCheckable = true
	},
	-- 法術書
	{
		text = SPELLBOOK_ABILITIES_BUTTON,
		icon = 'Interface\\MINIMAP\\TRACKING\\Class',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			if not SpellBookFrame:IsShown() then
				ShowUIPanel(SpellBookFrame)
			else
				HideUIPanel(SpellBookFrame)
			end
		end,
		notCheckable = true
	},
	--天賦
	{
		text = TALENTS_BUTTON,
		icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			if not PlayerTalentFrame then
				LoadAddOn('Blizzard_TalentUI')
			end
			if not GlyphFrame then
				LoadAddOn('Blizzard_GlyphUI')
			end
			securecall(ToggleFrame, PlayerTalentFrame)
		end,
		notCheckable = true
	},
	{
		-- 成就
		text = ACHIEVEMENT_BUTTON,
		icon = 'Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Shield',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleAchievementFrame)
		end,
		notCheckable = true
	},
	{
		-- 地圖與任務日誌
		text = MAP_AND_QUEST_LOG, -- OLD: QUESTLOG_BUTTON
		icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
		func = function()
			securecall(ToggleFrame, WorldMapFrame)
		end,
		notCheckable = true
	},
	{
		-- 社群
		text = COMMUNITIES_FRAME_TITLE, -- OLD: COMMUNITIES
		icon = 'Interface\\FriendsFrame\\UI-Toast-ChatInviteIcon',
		arg1 = IsInGuild('player'),
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			ToggleCommunitiesFrame()
		end,
		notCheckable = true
	},
	{
		-- 好友
		text = SOCIAL_BUTTON,
		icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleFriendsFrame, 1)
		end,
		notCheckable = true
	},
	{
		-- 地城與團隊
		text = GROUP_FINDER, -- DUNGEONS_BUTTON
		icon = 'Interface\\LFGFRAME\\BattleNetWorking0',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleLFDParentFrame) --OR securecall(PVEFrame_ToggleFrame, "GroupFinderFrame")
		end,
		notCheckable = true
	},
	{
		-- 收藏
		text = COLLECTIONS, -- OLD: MOUNTS_AND_PETS
		icon = 'Interface\\MINIMAP\\TRACKING\\Reagents',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffffff00' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleCollectionsJournal, 1)
		end,
		notCheckable = true
	},
	{
		-- 冒險指南
		text = ADVENTURE_JOURNAL, -- OLD: ENCOUNTER_JOURNAL
		icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleEncounterJournal)
		end,
		notCheckable = true
	},
	{
		-- 遊戲商城
		text = BLIZZARD_STORE,
		icon = 'Interface\\MINIMAP\\TRACKING\\Auctioneer',
		func = function()
			if not StoreFrame then
				LoadAddOn('Blizzard_StoreUI')
			end
			securecall(ToggleStoreUI)
		end,
		notCheckable = true
	},
	{
		-- 空行
		text = '',
		isTitle = true,
		notCheckable = true
	},
	{
		-- 其他
		text = OTHER,
		isTitle = true,
		notCheckable = true
	},
	{
		-- 背包
		text = BACKPACK_TOOLTIP,
		icon = 'Interface\\MINIMAP\\TRACKING\\Banker',
		func = function()
			securecall(ToggleAllBags)
		end,
		notCheckable = true
	},
	--[[ {
		-- 要塞報告
		text = GARRISON_LANDING_PAGE_TITLE,
		icon = 'Interface\\HELPFRAME\\OpenTicketIcon',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ShowGarrisonLandingPage, 2)
		end,
		notCheckable = true
	},
	{
		-- 職業大廳報告
		text = ORDER_HALL_LANDING_PAGE_TITLE,
		icon = 'Interface\\GossipFrame\\WorkOrderGossipIcon',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ShowGarrisonLandingPage, 3)
		end,
		notCheckable = true
	}, ]]
	{
		-- PVP
		text = PLAYER_V_PLAYER,
		icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(TogglePVPUI, 1)
		end,
		notCheckable = true
	},
	{
		-- 團隊
		text = RAID,
		icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleFriendsFrame, 3)
		end,
		notCheckable = true
	},
	{
		-- 客服支援
		text = GM_EMAIL_NAME,
		icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			securecall(ToggleHelpFrame)
		end,
		notCheckable = true
	},
	{
		-- 語音
		text = CHANNEL,
		icon = 'Interface\\CHATFRAME\\UI-ChatIcon-ArmoryChat-AwayMobile',
		func = function()
			ToggleChannelFrame()
		end,
		notCheckable = true
	},
	{
		-- 行事曆
		text = L.Calendar,
		func = function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage('|cffff0000' .. ERR_NOT_IN_COMBAT .. '|r')
				return
			end
			if not CalendarFrame then
				LoadAddOn('Blizzard_Calendar')
			end
			Calendar_Toggle()
		end,
		notCheckable = true
	},
	{
		-- 區域地圖
		text = BATTLEFIELD_MINIMAP,
		colorCode = '|cff999999',
		func = function()
			if not BattlefieldMapFrame then
				LoadAddOn('Blizzard_BattlefieldMap')
			end
			BattlefieldMapFrame:Toggle()
		end,
		notCheckable = true
	},
	{
		-- 空行
		text = '',
		isTitle = true,
		notCheckable = true
	},
	{
		-- 插件標題
		text = ADDONS,
		isTitle = true,
		notCheckable = true
	},
	{
		-- 重載
		text = RELOADUI,
		colorCode = '|cff999999',
		func = function()
			ReloadUI()
		end,
		notCheckable = true
	}
}
MAP.MenuList = menuList
