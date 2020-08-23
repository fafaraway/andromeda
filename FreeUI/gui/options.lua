local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')


--[[ callback ]]

local function UpdateBagStatus()
	F:GetModule('INVENTORY'):UpdateAllBags()
end

local function UpdateMinimapScale()
	F:GetModule('MAP'):UpdateMinimapScale()
end


--[[ side panel functions ]]

-- appearance
local function SetupVignettingAlpha()
	GUI:ToggleSidePanel('vignettingAlphaSide')
end

local function SetupBackdropAlpha()
	GUI:ToggleSidePanel('backdropAlphaSide')
end

-- aura
local function SetupAuraSize()
	GUI:ToggleSidePanel('auraSizeSide')
end


-- inventory
local function SetupItemLevel()
	GUI:ToggleSidePanel('itemLevelSide')
end

local function SetupBagSize()
	GUI:ToggleSidePanel('bagSizeSide')
end

local function SetupBagFilters()
	GUI:ToggleSidePanel('bagFilterSide')
end

local function SetupBagIlvl()
	GUI:ToggleSidePanel('bagIlvlSide')
end

-- chat
local function SetupChatFilter()
	GUI:ToggleSidePanel('chatFilterSide')
end

local function SetupChatSize()
	GUI:ToggleSidePanel('chatSizeSide')
end

-- tooltip
local function SetupTipFontSize()
	GUI:ToggleSidePanel('tipFontSizeSide')
end

-- actionbar
local function SetupActionbarSize()
	GUI:ToggleSidePanel('actionbarSizeSide')
end

local function SetupCooldown()
	GUI:ToggleSidePanel('cooldownSide')
end

-- unitframe
local function SetupUnitSize()
	GUI:ToggleSidePanel('unitSizeSide')
end

local function SetupPetSize()
	GUI:ToggleSidePanel('petSizeSide')
end

local function SetupFocusSize()
	GUI:ToggleSidePanel('focusSizeSide')
end

local function SetupGroupSize()
	GUI:ToggleSidePanel('groupSizeSide')
end

local function SetupBossSize()
	GUI:ToggleSidePanel('bossSizeSide')
end

local function SetupRangeCheckAlpha()
	GUI:ToggleSidePanel('rangeCheckAlphaSide')
end

local function SetupCastbarColor()
	GUI:ToggleSidePanel('castbarColorSide')
end

local function SetupCastbarSize()
	GUI:ToggleSidePanel('castbarSizeSide')
end

-- combat
local function SetupHealthThreshold()
	GUI:ToggleSidePanel('healthThresholdSide')
end

-- map
local function SetupMapScale()
	GUI:ToggleSidePanel('mapScaleSide')
end

-- infobar
local function SetupInfoBarHeight()
	GUI:ToggleSidePanel('infoBarHeightSide')
end


-- options section
--[[ local function addGeneralSection()
	local parent = FreeUIOptionsFrame.General
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Crown_of_the_Heavens_Icon')

	local basic = GUI:AddSubCategory(parent, 'GUI.localization.general.sub_basic')
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local blizzMover = GUI:CreateCheckBox(parent, 'blizz_mover')
	blizzMover:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local alreadyKnown = GUI:CreateCheckBox(parent, 'already_known')
	alreadyKnown:SetPoint('LEFT', blizzMover, 'RIGHT', 160, 0)

	local hideBossBanner = GUI:CreateCheckBox(parent, 'hide_boss_banner')
	hideBossBanner:SetPoint('TOPLEFT', blizzMover, 'BOTTOMLEFT', 0, -8)

	local hideTalkingHead = GUI:CreateCheckBox(parent, 'hide_talking_head')
	hideTalkingHead:SetPoint('LEFT', hideBossBanner, 'RIGHT', 160, 0)

	local itemLevel = GUI:CreateCheckBox(parent, 'item_level', nil, SetupItemLevel)
	itemLevel:SetPoint('TOPLEFT', hideBossBanner, 'BOTTOMLEFT', 0, -8)

	local mailButton = GUI:CreateCheckBox(parent, 'mail_button')
	mailButton:SetPoint('TOPLEFT', itemLevel, 'BOTTOMLEFT', 0, -8)

	local undressButton = GUI:CreateCheckBox(parent, 'undress_button')
	undressButton:SetPoint('LEFT', mailButton, 'RIGHT', 160, 0)

	local errors = GUI:CreateCheckBox(parent, 'tidy_errors')
	errors:SetPoint('TOPLEFT', mailButton, 'BOTTOMLEFT', 0, -8)

	local colorPicker = GUI:CreateCheckBox(parent, 'color_picker')
	colorPicker:SetPoint('LEFT', errors, 'RIGHT', 160, 0)

	local tradeTargetInfo = GUI:CreateCheckBox(parent, 'trade_target_info')
	tradeTargetInfo:SetPoint('TOPLEFT', errors, 'BOTTOMLEFT', 0, -8)

	local petFilter = GUI:CreateCheckBox(parent, 'pet_filter')
	petFilter:SetPoint('LEFT', tradeTargetInfo, 'RIGHT', 160, 0)

	local queueTimer = GUI:CreateCheckBox(parent, 'queue_timer')
	queueTimer:SetPoint('TOPLEFT', tradeTargetInfo, 'BOTTOMLEFT', 0, -8)

	local keystone = GUI:CreateCheckBox(parent, 'account_keystone')
	keystone:SetPoint('LEFT', queueTimer, 'RIGHT', 160, 0)

	local tradeTabs = GUI:CreateCheckBox(parent, 'trade_tabs')
	tradeTabs:SetPoint('TOPLEFT', queueTimer, 'BOTTOMLEFT', 0, -8)



	local missingStats = GUI:CreateCheckBox(parent, 'missing_stats')
	missingStats:SetPoint('TOPLEFT', tradeTabs, 'BOTTOMLEFT', 0, -8)

	local delete = GUI:CreateCheckBox(parent, 'easy_delete')
	delete:SetPoint('LEFT', missingStats, 'RIGHT', 160, 0)

	local focus = GUI:CreateCheckBox(parent, 'easy_focus')
	focus:SetPoint('TOPLEFT', missingStats, 'BOTTOMLEFT', 0, -8)

	local ouf = GUI:CreateCheckBox(parent, 'easy_focus_on_ouf')
	ouf:SetPoint('LEFT', focus, 'RIGHT', 160, 0)

	focus.children = {ouf}

	local loot = GUI:CreateCheckBox(parent, 'instant_loot')
	loot:SetPoint('TOPLEFT', focus, 'BOTTOMLEFT', 0, -8)

	local naked = GUI:CreateCheckBox(parent, 'easy_naked')
	naked:SetPoint('LEFT', loot, 'RIGHT', 160, 0)

	local mark = GUI:CreateCheckBox(parent, 'easy_mark')
	mark:SetPoint('TOPLEFT', loot, 'BOTTOMLEFT', 0, -8)

	local reject = GUI:CreateCheckBox(parent, 'auto_reject_stranger', nil, nil, true)
	reject:SetPoint('LEFT', mark, 'RIGHT', 160, 0)

	local camera = GUI:AddSubCategory(parent, 'GUI.localization.general.sub_camera')
	camera:SetPoint('TOPLEFT', mark, 'BOTTOMLEFT', 0, -16)

	local actionCam = GUI:CreateCheckBox(parent, 'action_camera')
	actionCam:SetPoint('TOPLEFT', camera, 'BOTTOMLEFT', 0, -8)

	local fasterCam = GUI:CreateCheckBox(parent, 'faster_camera')
	fasterCam:SetPoint('LEFT', actionCam, 'RIGHT', 160, 0)

	local uiscale = GUI:AddSubCategory(parent, 'GUI.localization.general.sub_uiscale')
	uiscale:SetPoint('TOPLEFT', actionCam, 'BOTTOMLEFT', 0, -16)

	local uiScaleMult = GUI:CreateSlider(parent, 'ui_scale', 1, 2, 1, 2, 0.1, nil, true)
	uiScaleMult:SetPoint('TOPLEFT', uiscale, 'BOTTOMLEFT', 16, -32)


	local itemLevelSide = GUI:CreateSidePanel(parent, 'itemLevelSide', 'GUI.localization.general.item_level', true)

	local gemEnchant = GUI:CreateCheckBox(parent, 'gem_enchant')
	gemEnchant:SetParent(itemLevelSide)
	gemEnchant:SetPoint('TOPLEFT', itemLevelSide, 'TOPLEFT', 20, -60)

	local azeriteTraits = GUI:CreateCheckBox(parent, 'azerite_traits')
	azeriteTraits:SetParent(itemLevelSide)
	azeriteTraits:SetPoint('TOPLEFT', gemEnchant, 'BOTTOMLEFT', 00, -8)

	local merchantIlvl = GUI:CreateCheckBox(parent, 'merchant_ilvl')
	merchantIlvl:SetParent(itemLevelSide)
	merchantIlvl:SetPoint('TOPLEFT', azeriteTraits, 'BOTTOMLEFT', 00, -8)

	itemLevel.children = {gemEnchant, azeriteTraits, merchantIlvl}
end ]]


local function AppearanceOptions()
	local parent = FreeUI_GUI.APPEARANCE
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Hunter_BeastWithin')

	local basic = GUI:AddSubCategory(parent, L['GUI_APPEARANCE_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local cursorTrail = GUI:CreateCheckBox(parent, 'theme', 'cursor_trail')
	cursorTrail:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local vignetting = GUI:CreateCheckBox(parent, 'theme', 'vignetting', nil, SetupVignettingAlpha)
	vignetting:SetPoint('LEFT', cursorTrail, 'RIGHT', 160, 0)

	local reskinBlizz = GUI:CreateCheckBox(parent, 'theme', 'reskin_blizz', nil, SetupBackdropAlpha)
	reskinBlizz:SetPoint('TOPLEFT', cursorTrail, 'BOTTOMLEFT', 0, -8)

	local shadowBorder = GUI:CreateCheckBox(parent, 'theme', 'shadow_border')
	shadowBorder:SetPoint('LEFT', reskinBlizz, 'RIGHT', 160, 0)

	local adjustFont = GUI:CreateCheckBox(parent, 'theme', 'adjust_font')
	adjustFont:SetPoint('TOPLEFT', reskinBlizz, 'BOTTOMLEFT', 0, -8)


	local addons = GUI:AddSubCategory(parent)
	addons:SetPoint('TOPLEFT', adjustFont, 'BOTTOMLEFT', 0, -16)

	local DBM = GUI:CreateCheckBox(parent, 'theme', 'reskin_dbm')
	DBM:SetPoint('TOPLEFT', addons, 'BOTTOMLEFT', 0, -8)

	local WeakAuras = GUI:CreateCheckBox(parent, 'theme', 'reskin_weakauras')
	WeakAuras:SetPoint('LEFT', DBM, 'RIGHT', 160, 0)

	local Skada = GUI:CreateCheckBox(parent, 'theme', 'reskin_skada')
	Skada:SetPoint('TOPLEFT', DBM, 'BOTTOMLEFT', 0, -8)

	local PGF = GUI:CreateCheckBox(parent, 'theme', 'reskin_pgf')
	PGF:SetPoint('LEFT', Skada, 'RIGHT', 160, 0)

	local other = GUI:AddSubCategory(parent)
	other:SetPoint('TOPLEFT', Skada, 'BOTTOMLEFT', 0, -16)


	local uiScale = GUI:CreateSlider(parent, 'ACCOUNT', 'ui_scale', nil, {.4, 2, .01})
	uiScale:SetPoint('TOPLEFT', other, 'BOTTOMLEFT', 0, -24)

	local texture = GUI:CreateDropDown(parent, 'unitframe', 'texture_style', nil, {L['GUI_UNITFRAME_TEXTURE_NORM'], L['GUI_UNITFRAME_TEXTURE_GRAD'], L['GUI_UNITFRAME_TEXTURE_FLAT']})
	texture:SetPoint('LEFT', uiScale, 'RIGHT', 80, 0)


	local vignettingAlphaSide = GUI:CreateSidePanel(parent, 'vignettingAlphaSide')

	local vignettingAlpha = GUI:CreateSlider(vignettingAlphaSide, 'theme', 'vignetting_alpha', nil, {0, 1, 0.1})
	vignettingAlpha:SetPoint('TOP', vignettingAlphaSide.child, 'TOP', 0, -24)


	local backdropAlphaSide = GUI:CreateSidePanel(parent, 'backdropAlphaSide')

	local backdropAlpha = GUI:CreateSlider(backdropAlphaSide, 'theme', 'backdrop_alpha', nil, {0.1, 1, 0.01})
	backdropAlpha:SetPoint('TOP', backdropAlphaSide.child, 'TOP', 0, -24)

end

local function AuraOptions()
	local parent = FreeUI_GUI.AURA
	parent.tab.icon:SetTexture('Interface\\ICONS\\Spell_Shadow_Shadesofdarkness')

	local basic = GUI:AddSubCategory(parent, L['GUI_AURA_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'aura', 'enable_aura', nil, SetupAuraSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local reverseBuffs = GUI:CreateCheckBox(parent, 'aura', 'reverse_buffs')
	reverseBuffs:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local reverseDebuffs = GUI:CreateCheckBox(parent, 'aura', 'reverse_debuffs')
	reverseDebuffs:SetPoint('LEFT', reverseBuffs, 'RIGHT', 160, 0)

	local reminder = GUI:CreateCheckBox(parent, 'aura', 'buff_reminder')
	reminder:SetPoint('TOPLEFT', reverseBuffs, 'BOTTOMLEFT', 0, -8)


	-- aura size side panel
	local auraSizeSide = GUI:CreateSidePanel(parent, 'auraSizeSide')

	local buffSize = GUI:CreateSlider(auraSizeSide, 'aura', 'buff_size', nil, {20, 50, 1})
	buffSize:SetPoint('TOP', auraSizeSide.child, 'TOP', 0, -24)

	local buffsPerRow = GUI:CreateSlider(auraSizeSide, 'aura', 'buffs_per_row', nil, {6, 16, 1})
	buffsPerRow:SetPoint('TOP', buffSize, 'BOTTOM', 0, -50)

	local debuffSize = GUI:CreateSlider(auraSizeSide, 'aura', 'debuff_size', nil, {20, 50, 1})
	debuffSize:SetPoint('TOP', buffsPerRow, 'BOTTOM', 0, -50)

	local debuffsPerRow = GUI:CreateSlider(auraSizeSide, 'aura', 'debuffs_per_row', nil, {6, 16, 1})
	debuffsPerRow:SetPoint('TOP', debuffSize, 'BOTTOM', 0, -50)

	local margin = GUI:CreateSlider(auraSizeSide, 'aura', 'margin', nil, {3, 10, 1})
	margin:SetPoint('TOP', debuffsPerRow, 'BOTTOM', 0, -50)

	local offset = GUI:CreateSlider(auraSizeSide, 'aura', 'offset', nil, {6, 16, 1})
	offset:SetPoint('TOP', margin, 'BOTTOM', 0, -50)


	local function toggleAuraOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		reverseBuffs:SetShown(shown)
		reverseDebuffs:SetShown(shown)
		reminder:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleAuraOptions)
	parent:HookScript('OnShow', toggleAuraOptions)
end

local function QuestOptions()
	local parent = FreeUI_GUI.QUEST
	parent.tab.icon:SetTexture('Interface\\ICONS\\ABILITY_Rogue_RollTheBones04')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'quest', 'enable_quest')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local questLevel = GUI:CreateCheckBox(parent, 'quest', 'quest_level')
	questLevel:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local rewardHightlight = GUI:CreateCheckBox(parent, 'quest', 'reward_highlight')
	rewardHightlight:SetPoint('LEFT', questLevel, 'RIGHT', 160, 0)

	local questProgress = GUI:CreateCheckBox(parent, 'quest', 'quest_progress')
	questProgress:SetPoint('TOPLEFT', questLevel, 'BOTTOMLEFT', 0, -8)

	local completeRing = GUI:CreateCheckBox(parent, 'quest', 'complete_ring')
	completeRing:SetPoint('LEFT', questProgress, 'RIGHT', 160, 0)

	local extraButton = GUI:CreateCheckBox(parent, 'quest', 'extra_button')
	extraButton:SetPoint('TOPLEFT', questProgress, 'BOTTOMLEFT', 0, -8)


	local function toggleQuestOptions()
		local shown = enable:GetChecked()
		questLevel:SetShown(shown)
		rewardHightlight:SetShown(shown)
		questProgress:SetShown(shown)
		completeRing:SetShown(shown)
		extraButton:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleQuestOptions)
	parent:HookScript('OnShow', toggleQuestOptions)
end

local function CombatOptions()
	local parent = FreeUI_GUI.COMBAT
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Parry')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'combat', 'enable_combat')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local combat = GUI:CreateCheckBox(parent, 'combat', 'combat_alert')
	combat:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local health = GUI:CreateCheckBox(parent, 'combat', 'health_alert', nil, SetupHealthThreshold)
	health:SetPoint('LEFT', combat, 'RIGHT', 160, 0)

	local spell = GUI:CreateCheckBox(parent, 'combat', 'spell_alert')
	spell:SetPoint('TOPLEFT', combat, 'BOTTOMLEFT', 0, -8)

	local pvp = GUI:AddSubCategory(parent)
	pvp:SetPoint('TOPLEFT', spell, 'BOTTOMLEFT', 0, -16)

	local autoTab = GUI:CreateCheckBox(parent, 'combat', 'auto_tab')
	autoTab:SetPoint('TOPLEFT', pvp, 'BOTTOMLEFT', 0, -8)

	local PVPSound = GUI:CreateCheckBox(parent, 'combat', 'pvp_sound')
	PVPSound:SetPoint('LEFT', autoTab, 'RIGHT', 160, 0)


	local healthThresholdSide = GUI:CreateSidePanel(parent, 'healthThresholdSide')

	local healthThreshold = GUI:CreateSlider(healthThresholdSide, 'combat', 'health_alert_threshold', nil, {0.1, 0.8, 0.1})
	healthThreshold:SetPoint('TOP', healthThresholdSide.child, 'TOP', 0, -24)


	local function toggleCombatOptions()
		local shown = enable:GetChecked()
		combat:SetShown(shown)
		health:SetShown(shown)
		health.bu:SetShown(shown)
		spell:SetShown(shown)
		pvp:SetShown(shown)
		pvp.line:SetShown(shown)
		autoTab:SetShown(shown)
		PVPSound:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleCombatOptions)
	parent:HookScript('OnShow', toggleCombatOptions)
end

local function InventoryOptions()
	local parent = FreeUI_GUI.INVENTORY
	parent.tab.icon:SetTexture('Interface\\ICONS\\INV_Misc_Bag_30')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'inventory', 'enable_inventory', nil, SetupBagSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local newitemFlash = GUI:CreateCheckBox(parent, 'inventory', 'new_item_flash')
	newitemFlash:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local reverseSort = GUI:CreateCheckBox(parent, 'inventory', 'reverse_sort')
	reverseSort:SetPoint('LEFT', newitemFlash, 'RIGHT', 160, 0)

	local combineFreeSlots = GUI:CreateCheckBox(parent, 'inventory', 'combine_free_slots')
	combineFreeSlots:SetPoint('TOPLEFT', newitemFlash, 'BOTTOMLEFT', 0, -8)

	local itemLevel = GUI:CreateCheckBox(parent, 'inventory', 'item_level', nil, SetupBagIlvl)
	itemLevel:SetPoint('LEFT', combineFreeSlots, 'RIGHT', 160, 0)


	local filter = GUI:AddSubCategory(parent)
	filter:SetPoint('TOPLEFT', combineFreeSlots, 'BOTTOMLEFT', 0, -16)

	local useCategory = GUI:CreateCheckBox(parent, 'inventory', 'item_filter', UpdateBagStatus)
	useCategory:SetPoint('TOPLEFT', filter, 'BOTTOMLEFT', 0, -8)

	local itemFilterLegendary = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_legendary', UpdateBagStatus)
	itemFilterLegendary:SetPoint('LEFT', useCategory, 'RIGHT', 160, 0)

	local itemFilterJunk = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_junk', UpdateBagStatus)
	itemFilterJunk:SetPoint('TOPLEFT', useCategory, 'BOTTOMLEFT', 0, -8)

	local itemFilterTrade = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_trade', UpdateBagStatus)
	itemFilterTrade:SetPoint('LEFT', itemFilterJunk, 'RIGHT', 160, 0)

	local itemFilterConsumable = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_consumable', UpdateBagStatus)
	itemFilterConsumable:SetPoint('TOPLEFT', itemFilterJunk, 'BOTTOMLEFT', 0, -8)

	local itemFilterQuest = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_quest', UpdateBagStatus)
	itemFilterQuest:SetPoint('LEFT', itemFilterConsumable, 'RIGHT', 160, 0)

	local itemFilterSet = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_gear_set', UpdateBagStatus)
	itemFilterSet:SetPoint('TOPLEFT', itemFilterConsumable, 'BOTTOMLEFT', 0, -8)

	local itemFilterAzerite = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_azerite', UpdateBagStatus)
	itemFilterAzerite:SetPoint('LEFT', itemFilterSet, 'RIGHT', 160, 0)

	local itemFilterMountPet = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_mount_pet', UpdateBagStatus)
	itemFilterMountPet:SetPoint('TOPLEFT', itemFilterSet, 'BOTTOMLEFT', 0, -8)

	local itemFilterFavourite = GUI:CreateCheckBox(parent, 'inventory', 'item_filter_favourite', UpdateBagStatus)
	itemFilterFavourite:SetPoint('LEFT', itemFilterMountPet, 'RIGHT', 160, 0)

	useCategory.children = {itemFilterSet, itemFilterLegendary, itemFilterMountPet, itemFilterFavourite, itemFilterTrade, itemFilterQuest, itemFilterJunk, itemFilterAzerite, itemFilterConsumable}


	-- bag size side panel
	local bagSizeSide = GUI:CreateSidePanel(parent, 'bagSizeSide')

	local slotSize = GUI:CreateSlider(bagSizeSide, 'inventory', 'slot_size', nil, {20, 60, 1})
	slotSize:SetPoint('TOP', bagSizeSide.child, 'TOP', 0, -24)

	local spacing = GUI:CreateSlider(bagSizeSide, 'inventory', 'spacing', nil, {3, 6, 1})
	spacing:SetPoint('TOP', slotSize, 'BOTTOM', 0, -50)

	local bagColumns = GUI:CreateSlider(bagSizeSide, 'inventory', 'bag_columns', nil, {8, 16, 1})
	bagColumns:SetPoint('TOP', spacing, 'BOTTOM', 0, -50)

	local bankColumns = GUI:CreateSlider(bagSizeSide, 'inventory', 'bank_columns', nil, {8, 16, 1})
	bankColumns:SetPoint('TOP', bagColumns, 'BOTTOM', 0, -50)


	-- item level to show side panel
	local itemLevelSide = GUI:CreateSidePanel(parent, 'bagIlvlSide')

	local iLvltoShow = GUI:CreateSlider(itemLevelSide, 'inventory', 'item_level_to_show', nil, {1, 500, 1})
	iLvltoShow:SetPoint('TOP', itemLevelSide.child, 'TOP', 0, -24)

	itemLevel.children = {iLvltoShow}


	local function toggleInventoryOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		newitemFlash:SetShown(shown)
		reverseSort:SetShown(shown)
		combineFreeSlots:SetShown(shown)
		itemLevel:SetShown(shown)
		itemLevel.bu:SetShown(shown)
		filter:SetShown(shown)
		filter.line:SetShown(shown)
		useCategory:SetShown(shown)
		itemFilterLegendary:SetShown(shown)
		itemFilterMountPet:SetShown(shown)
		itemFilterFavourite:SetShown(shown)
		itemFilterTrade:SetShown(shown)
		itemFilterQuest:SetShown(shown)
		itemFilterJunk:SetShown(shown)
		itemFilterSet:SetShown(shown)
		itemFilterAzerite:SetShown(shown)
		itemFilterConsumable:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInventoryOptions)
	parent:HookScript('OnShow', toggleInventoryOptions)
end

local function UnitframeOptions()
	local parent = FreeUI_GUI.UNITFRAME
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Mage_MassInvisibility')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'unitframe', 'enable_unitframe', nil, SetupUnitSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local transparency = GUI:CreateCheckBox(parent, 'unitframe', 'transparency')
	transparency:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)



	local portrait = GUI:CreateCheckBox(parent, 'unitframe', 'portrait')
	portrait:SetPoint('TOPLEFT', transparency, 'BOTTOMLEFT', 0, -8)

	local fader = GUI:CreateCheckBox(parent, 'unitframe', 'fader')
	fader:SetPoint('LEFT', portrait, 'RIGHT', 160, 0)


	local feature = GUI:AddSubCategory(parent)
	feature:SetPoint('TOPLEFT', portrait, 'BOTTOMLEFT', 0, -16)

	local rangeCheck = GUI:CreateCheckBox(parent, 'unitframe', 'range_check', nil, SetupRangeCheckAlpha)
	rangeCheck:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local gcdSpark = GUI:CreateCheckBox(parent, 'unitframe', 'gcd_spark')
	gcdSpark:SetPoint('LEFT', rangeCheck, 'RIGHT', 160, 0)

	local healPrediction = GUI:CreateCheckBox(parent, 'unitframe', 'heal_prediction')
	healPrediction:SetPoint('TOPLEFT', rangeCheck, 'BOTTOMLEFT', 0, -8)

	local overAbsorb = GUI:CreateCheckBox(parent, 'unitframe', 'over_absorb')
	overAbsorb:SetPoint('LEFT', healPrediction, 'RIGHT', 160, 0)

	local debuffsByPlayer = GUI:CreateCheckBox(parent, 'unitframe', 'target_debuffs_by_player')
	debuffsByPlayer:SetPoint('TOPLEFT', healPrediction, 'BOTTOMLEFT', 0, -8)

	local classPowerBar = GUI:CreateCheckBox(parent, 'unitframe', 'class_power_bar')
	classPowerBar:SetPoint('LEFT', debuffsByPlayer, 'RIGHT', 160, 0)

	local staggerBar = GUI:CreateCheckBox(parent, 'unitframe', 'stagger_bar')
	staggerBar:SetPoint('TOPLEFT', debuffsByPlayer, 'BOTTOMLEFT', 0, -8)

	local totemsBar = GUI:CreateCheckBox(parent, 'unitframe', 'totems_bar')
	totemsBar:SetPoint('LEFT', staggerBar, 'RIGHT', 160, 0)

	local runesBar = GUI:CreateCheckBox(parent, 'unitframe', 'runes_bar')
	runesBar:SetPoint('TOPLEFT', staggerBar, 'BOTTOMLEFT', 0, -8)


	local castbar = GUI:AddSubCategory(parent)
	castbar:SetPoint('TOPLEFT', runesBar, 'BOTTOMLEFT', 0, -16)

	local enableCastbar = GUI:CreateCheckBox(parent, 'unitframe', 'enable_castbar', nil, SetupCastbarColor)
	enableCastbar:SetPoint('TOPLEFT', castbar, 'BOTTOMLEFT', 0, -8)

	local castbarTimer = GUI:CreateCheckBox(parent, 'unitframe', 'castbar_timer')
	castbarTimer:SetPoint('LEFT', enableCastbar, 'RIGHT', 160, 0)

	local castbarFocusSeparate = GUI:CreateCheckBox(parent, 'unitframe', 'castbar_focus_separate', nil, SetupCastbarSize)
	castbarFocusSeparate:SetPoint('TOPLEFT', enableCastbar, 'BOTTOMLEFT', 0, -8)


	local pet = GUI:AddSubCategory(parent)
	pet:SetPoint('TOPLEFT', castbarFocusSeparate, 'BOTTOMLEFT', 0, -16)

	local enablePet = GUI:CreateCheckBox(parent, 'unitframe', 'enable_pet', nil, SetupPetSize)
	enablePet:SetPoint('TOPLEFT', pet, 'BOTTOMLEFT', 0, -8)

	local petAura = GUI:CreateCheckBox(parent, 'unitframe', 'pet_auras')
	petAura:SetPoint('LEFT', enablePet, 'RIGHT', 160, 0)


	local focus = GUI:AddSubCategory(parent)
	focus:SetPoint('TOPLEFT', enablePet, 'BOTTOMLEFT', 0, -16)

	local enableFocus = GUI:CreateCheckBox(parent, 'unitframe', 'enable_focus', nil, SetupFocusSize)
	enableFocus:SetPoint('TOPLEFT', focus, 'BOTTOMLEFT', 0, -8)

	local focusAura = GUI:CreateCheckBox(parent, 'unitframe', 'focus_auras')
	focusAura:SetPoint('LEFT', enableFocus, 'RIGHT', 160, 0)


	local group = GUI:AddSubCategory(parent)
	group:SetPoint('TOPLEFT', enableFocus, 'BOTTOMLEFT', 0, -16)

	local enableGroup = GUI:CreateCheckBox(parent, 'unitframe', 'enable_group', nil, SetupGroupSize)
	enableGroup:SetPoint('TOPLEFT', group, 'BOTTOMLEFT', 0, -8)

	local groupNames = GUI:CreateCheckBox(parent, 'unitframe', 'group_names')
	groupNames:SetPoint('LEFT', enableGroup, 'RIGHT', 160, 0)

	local groupColorSmooth = GUI:CreateCheckBox(parent, 'unitframe', 'group_color_smooth')
	groupColorSmooth:SetPoint('TOPLEFT', enableGroup, 'BOTTOMLEFT', 0, -8)

	local threatIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_threat_indicator')
	threatIndicator:SetPoint('LEFT', groupColorSmooth, 'RIGHT', 160, 0)

	local leaderIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_leader_indicator')
	leaderIndicator:SetPoint('TOPLEFT', groupColorSmooth, 'BOTTOMLEFT', 0, -8)

	local roleIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_role_indicator')
	roleIndicator:SetPoint('LEFT', leaderIndicator, 'RIGHT', 160, 0)

	local summonIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_summon_indicator')
	summonIndicator:SetPoint('TOPLEFT', leaderIndicator, 'BOTTOMLEFT', 0, -8)

	local phaseIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_phase_indicator')
	phaseIndicator:SetPoint('LEFT', summonIndicator, 'RIGHT', 160, 0)

	local readyCheckIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_ready_check_indicator')
	readyCheckIndicator:SetPoint('TOPLEFT', summonIndicator, 'BOTTOMLEFT', 0, -8)

	local resurrectIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'group_resurrect_indicator')
	resurrectIndicator:SetPoint('LEFT', readyCheckIndicator, 'RIGHT', 160, 0)

	local cornerBuffs = GUI:CreateCheckBox(parent, 'unitframe', 'group_corner_buffs')
	cornerBuffs:SetPoint('TOPLEFT', readyCheckIndicator, 'BOTTOMLEFT', 0, -8)

	local debuffHighlight = GUI:CreateCheckBox(parent, 'unitframe', 'group_debuff_highlight')
	debuffHighlight:SetPoint('LEFT', cornerBuffs, 'RIGHT', 160, 0)

	local groupDebuffs = GUI:CreateCheckBox(parent, 'unitframe', 'group_debuffs')
	groupDebuffs:SetPoint('TOPLEFT', cornerBuffs, 'BOTTOMLEFT', 0, -8)

	local clickCast = GUI:CreateCheckBox(parent, 'unitframe', 'group_click_cast')
	clickCast:SetPoint('LEFT', groupDebuffs, 'RIGHT', 160, 0)


	local boss = GUI:AddSubCategory(parent)
	boss:SetPoint('TOPLEFT', groupDebuffs, 'BOTTOMLEFT', 0, -16)

	local enableBoss = GUI:CreateCheckBox(parent, 'unitframe', 'enable_boss', nil, SetupBossSize)
	enableBoss:SetPoint('TOPLEFT', boss, 'BOTTOMLEFT', 0, -8)

	local bossAura = GUI:CreateCheckBox(parent, 'unitframe', 'boss_auras')
	bossAura:SetPoint('LEFT', enableBoss, 'RIGHT', 160, 0)

	local bossColorSmooth = GUI:CreateCheckBox(parent, 'unitframe', 'boss_color_smooth')
	bossColorSmooth:SetPoint('TOPLEFT', enableBoss, 'BOTTOMLEFT', 0, -8)

	local bossDebuffsByPlayer = GUI:CreateCheckBox(parent, 'unitframe', 'boss_debuffs_by_player')
	bossDebuffsByPlayer:SetPoint('LEFT', bossColorSmooth, 'RIGHT', 160, 0)


	local arena = GUI:AddSubCategory(parent)
	arena:SetPoint('TOPLEFT', bossColorSmooth, 'BOTTOMLEFT', 0, -16)

	local enableArena = GUI:CreateCheckBox(parent, 'unitframe', 'enable_arena', nil, SetupArenaSize)
	enableArena:SetPoint('TOPLEFT', arena, 'BOTTOMLEFT', 0, -8)






	-- unitframes size side panel
	local unitSizeSide = GUI:CreateSidePanel(parent, 'unitSizeSide')

	local playerWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'player_width', nil, {80, 200, 1})
	playerWidth:SetPoint('TOP', unitSizeSide.child, 'TOP', 0, -24)

	local playerHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'player_height', nil, {6, 30, 1})
	playerHeight:SetPoint('TOP', playerWidth, 'BOTTOM', 0, -50)

	local targetWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_width', nil, {80, 200, 1})
	targetWidth:SetPoint('TOP', playerHeight, 'BOTTOM', 0, -50)

	local targetHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_height', nil, {6, 30, 1})
	targetHeight:SetPoint('TOP', targetWidth, 'BOTTOM', 0, -50)

	local totWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_width', nil, {80, 200, 1})
	totWidth:SetPoint('TOP', targetHeight, 'BOTTOM', 0, -50)

	local totHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_height', nil, {6, 30, 1})
	totHeight:SetPoint('TOP', totWidth, 'BOTTOM', 0, -50)

	local powerHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'power_bar_height', nil, {1, 8, 1})
	powerHeight:SetPoint('TOP', totHeight, 'BOTTOM', 0, -50)

	local altPowerHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'alternative_power_height', nil, {1, 8, 1})
	altPowerHeight:SetPoint('TOP', powerHeight, 'BOTTOM', 0, -50)


	-- group size side panel
	local groupSizeSide = GUI:CreateSidePanel(parent, 'groupSizeSide')

	local partyWidth = GUI:CreateSlider(groupSizeSide, 'unitframe', 'party_width', nil, {20, 100, 1})
	partyWidth:SetPoint('TOP', groupSizeSide.child, 'TOP', 0, -24)

	local partyHeight = GUI:CreateSlider(groupSizeSide, 'unitframe', 'party_height', nil, {20, 100, 1})
	partyHeight:SetPoint('TOP', partyWidth, 'BOTTOM', 0, -50)

	local partyGap = GUI:CreateSlider(groupSizeSide, 'unitframe', 'party_gap', nil, {5, 20, 1})
	partyGap:SetPoint('TOP', partyHeight, 'BOTTOM', 0, -50)

	local raidWidth = GUI:CreateSlider(groupSizeSide, 'unitframe', 'raid_width', nil, {20, 100, 1})
	raidWidth:SetPoint('TOP', partyGap, 'BOTTOM', 0, -50)

	local raidHeight = GUI:CreateSlider(groupSizeSide, 'unitframe', 'raid_height', nil, {20, 100, 1})
	raidHeight:SetPoint('TOP', raidWidth, 'BOTTOM', 0, -50)

	local raidGap = GUI:CreateSlider(groupSizeSide, 'unitframe', 'raid_gap', nil, {5, 20, 1})
	raidGap:SetPoint('TOP', raidHeight, 'BOTTOM', 0, -50)

	-- castbar color side panel
	local castbarColorSide = GUI:CreateSidePanel(parent, 'castbarColorSide')

	local castingColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'castingColor')
	castingColor:SetPoint('TOPLEFT', castbarColorSide.child, 'TOPLEFT', 10, -10)

	local notInterruptibleColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'notInterruptibleColor')
	notInterruptibleColor:SetPoint('TOP', castingColor, 'BOTTOM', 0, -16)

	local completeColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'completeColor')
	completeColor:SetPoint('TOP', notInterruptibleColor, 'BOTTOM', 0, -16)

	local failColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'failColor')
	failColor:SetPoint('TOP', completeColor, 'BOTTOM', 0, -16)

	-- castbar size side panel
	local castbarSizeSide = GUI:CreateSidePanel(parent, 'castbarSizeSide')

	local castbarFocusWidth = GUI:CreateSlider(castbarSizeSide, 'unitframe', 'castbar_focus_width', nil, {100, 400, 1})
	castbarFocusWidth:SetPoint('TOP', castbarSizeSide.child, 'TOP', 0, -24)

	local castbarFocusHeight = GUI:CreateSlider(castbarSizeSide, 'unitframe', 'castbar_focus_height', nil, {8, 30, 1})
	castbarFocusHeight:SetPoint('TOP', castbarFocusWidth, 'BOTTOM', 0, -50)

	-- range check alpha side panel
	local rangeCheckAlphaSide = GUI:CreateSidePanel(parent, 'rangeCheckAlphaSide')

	local rangeCheckAlpha = GUI:CreateSlider(rangeCheckAlphaSide, 'unitframe', 'range_check_alpha', nil, {0.3, 1, 0.1})
	rangeCheckAlpha:SetPoint('TOP', rangeCheckAlphaSide.child, 'TOP', 0, -24)


end

local function TooltipOptions()
	local parent = FreeUI_GUI.TOOLTIP
	parent.tab.icon:SetTexture('Interface\\ICONS\\INV_Misc_ScrollUnrolled03d')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'tooltip', 'enable_tooltip', nil, SetupTipFontSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local cursor = GUI:CreateCheckBox(parent, 'tooltip', 'follow_cursor')
	cursor:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local combatHide = GUI:CreateCheckBox(parent, 'tooltip', 'hide_in_combat')
	combatHide:SetPoint('LEFT', cursor, 'RIGHT', 160, 0)

	local tipIcon = GUI:CreateCheckBox(parent, 'tooltip', 'tip_icon')
	tipIcon:SetPoint('TOPLEFT', cursor, 'BOTTOMLEFT', 0, -8)

	local borderColor = GUI:CreateCheckBox(parent, 'tooltip', 'border_color')
	borderColor:SetPoint('LEFT', tipIcon, 'RIGHT', 160, 0)

	local hideTitle = GUI:CreateCheckBox(parent, 'tooltip', 'hide_title')
	hideTitle:SetPoint('TOPLEFT', tipIcon, 'BOTTOMLEFT', 0, -8)

	local hideRealm = GUI:CreateCheckBox(parent, 'tooltip', 'hide_realm')
	hideRealm:SetPoint('LEFT', hideTitle, 'RIGHT', 160, 0)

	local hideRank = GUI:CreateCheckBox(parent, 'tooltip', 'hide_rank')
	hideRank:SetPoint('TOPLEFT', hideTitle, 'BOTTOMLEFT', 0, -8)

	local targetBy = GUI:CreateCheckBox(parent, 'tooltip', 'target_by')
	targetBy:SetPoint('LEFT', hideRank, 'RIGHT', 160, 0)

	local linkHover = GUI:CreateCheckBox(parent, 'tooltip', 'link_hover')
	linkHover:SetPoint('TOPLEFT', hideRank, 'BOTTOMLEFT', 0, -8)

	local azeriteArmor = GUI:CreateCheckBox(parent, 'tooltip', 'azerite_armor')
	azeriteArmor:SetPoint('LEFT', linkHover, 'RIGHT', 160, 0)

	local specIlvl = GUI:CreateCheckBox(parent, 'tooltip', 'spec_ilvl')
	specIlvl:SetPoint('TOPLEFT', linkHover, 'BOTTOMLEFT', 0, -8)

	local pvpRating = GUI:CreateCheckBox(parent, 'tooltip', 'pvp_rating')
	pvpRating:SetPoint('LEFT', specIlvl, 'RIGHT', 160, 0)

	local itemCount = GUI:CreateCheckBox(parent, 'tooltip', 'item_count')
	itemCount:SetPoint('TOPLEFT', specIlvl, 'BOTTOMLEFT', 0, -8)

	local itemPrice = GUI:CreateCheckBox(parent, 'tooltip', 'item_price')
	itemPrice:SetPoint('LEFT', itemCount, 'RIGHT', 160, 0)

	local variousID = GUI:CreateCheckBox(parent, 'tooltip', 'various_id')
	variousID:SetPoint('TOPLEFT', itemCount, 'BOTTOMLEFT', 0, -8)

	local auraSource = GUI:CreateCheckBox(parent, 'tooltip', 'aura_source')
	auraSource:SetPoint('LEFT', variousID, 'RIGHT', 160, 0)

	local mountSource = GUI:CreateCheckBox(parent, 'tooltip', 'mount_source')
	mountSource:SetPoint('TOPLEFT', variousID, 'BOTTOMLEFT', 0, -8)


	-- tooltip font size side panel
	local tipFontSizeSide = GUI:CreateSidePanel(parent, 'tipFontSizeSide')

	local headerFontSize = GUI:CreateSlider(tipFontSizeSide, 'tooltip', 'header_font_size', nil, {8, 20, 1})
	headerFontSize:SetPoint('TOP', tipFontSizeSide.child, 'TOP', 0, -24)

	local normalFontSize = GUI:CreateSlider(tipFontSizeSide, 'tooltip', 'normal_font_size', nil, {8, 20, 1})
	normalFontSize:SetPoint('TOP', headerFontSize, 'BOTTOM', 0, -50)


	local function toggleTooltipOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		cursor:SetShown(shown)
		combatHide:SetShown(shown)
		tipIcon:SetShown(shown)
		borderColor:SetShown(shown)
		hideTitle:SetShown(shown)
		hideRealm:SetShown(shown)
		hideRank:SetShown(shown)
		targetBy:SetShown(shown)
		linkHover:SetShown(shown)
		azeriteArmor:SetShown(shown)
		specIlvl:SetShown(shown)
		pvpRating:SetShown(shown)
		variousID:SetShown(shown)
		itemCount:SetShown(shown)
		itemPrice:SetShown(shown)
		auraSource:SetShown(shown)
		mountSource:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleTooltipOptions)
	parent:HookScript('OnShow', toggleTooltipOptions)
end

local function MapOptions()
	local parent = FreeUI_GUI.MAP
	parent.tab.icon:SetTexture('Interface\\ICONS\\Achievement_Ashran_Tourofduty')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'map', 'enable_map', nil, SetupMapScale)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local coords = GUI:CreateCheckBox(parent, 'map', 'coords')
	coords:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local miniMap = GUI:AddSubCategory(parent)
	miniMap:SetPoint('TOPLEFT', coords, 'BOTTOMLEFT', 0, -16)

	local newMail = GUI:CreateCheckBox(parent, 'map', 'new_mail')
	newMail:SetPoint('TOPLEFT', miniMap, 'BOTTOMLEFT', 0, -8)

	local calendar = GUI:CreateCheckBox(parent, 'map', 'calendar')
	calendar:SetPoint('LEFT', newMail, 'RIGHT', 160, 0)

	local instanceType = GUI:CreateCheckBox(parent, 'map', 'instance_type')
	instanceType:SetPoint('TOPLEFT', newMail, 'BOTTOMLEFT', 0, -8)

	local whoPings = GUI:CreateCheckBox(parent, 'map', 'who_pings')
	whoPings:SetPoint('LEFT', instanceType, 'RIGHT', 160, 0)

	local microMenu = GUI:CreateCheckBox(parent, 'map', 'micro_menu')
	microMenu:SetPoint('TOPLEFT', instanceType, 'BOTTOMLEFT', 0, -8)

	local worldMarker = GUI:CreateCheckBox(parent, 'map', 'world_marker')
	worldMarker:SetPoint('LEFT', microMenu, 'RIGHT', 160, 0)

	local expBar = GUI:CreateCheckBox(parent, 'map', 'progress_bar')
	expBar:SetPoint('TOPLEFT', microMenu, 'BOTTOMLEFT', 0, -8)


	-- map size side panel
	local mapScaleSide = GUI:CreateSidePanel(parent, 'mapScaleSide')

	local mapScale = GUI:CreateSlider(mapScaleSide, 'map', 'map_scale', UpdateMinimapScale, {0.5, 1, 0.1})
	mapScale:SetPoint('TOP', mapScaleSide.child, 'TOP', 0, -24)

	local minimapScale = GUI:CreateSlider(mapScaleSide, 'map', 'minimap_scale', UpdateMinimapScale, {0.5, 1, 0.1})
	minimapScale:SetPoint('TOP', mapScale, 'BOTTOM', 0, -50)


	local function toggleMapOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		coords:SetShown(shown)
		miniMap:SetShown(shown)
		newMail:SetShown(shown)
		calendar:SetShown(shown)
		instanceType:SetShown(shown)
		whoPings:SetShown(shown)
		expBar:SetShown(shown)
		microMenu:SetShown(shown)
		worldMarker:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleMapOptions)
	parent:HookScript('OnShow', toggleMapOptions)
end

local function InfobarOptions()
	local parent = FreeUI_GUI.INFOBAR
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Priest_Ascension')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'infobar', 'enable_infobar', nil, SetupInfoBarHeight)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local anchorTop = GUI:CreateCheckBox(parent, 'infobar', 'anchor_top')
	anchorTop:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local mouseover = GUI:CreateCheckBox(parent, 'infobar', 'mouseover')
	mouseover:SetPoint('LEFT', anchorTop, 'RIGHT', 160, 0)

	local stats = GUI:CreateCheckBox(parent, 'infobar', 'stats')
	stats:SetPoint('TOPLEFT', anchorTop, 'BOTTOMLEFT', 0, -8)

	local report = GUI:CreateCheckBox(parent, 'infobar', 'report')
	report:SetPoint('LEFT', stats, 'RIGHT', 160, 0)

	local friends = GUI:CreateCheckBox(parent, 'infobar', 'friends')
	friends:SetPoint('TOPLEFT', stats, 'BOTTOMLEFT', 0, -8)

	local guild = GUI:CreateCheckBox(parent, 'infobar', 'guild')
	guild:SetPoint('LEFT', friends, 'RIGHT', 160, 0)

	local durability = GUI:CreateCheckBox(parent, 'infobar', 'durability')
	durability:SetPoint('TOPLEFT', friends, 'BOTTOMLEFT', 0, -8)

	local spec = GUI:CreateCheckBox(parent, 'infobar', 'spec')
	spec:SetPoint('LEFT', durability, 'RIGHT', 160, 0)


	-- infobar height side panel
	local infoBarHeightSide = GUI:CreateSidePanel(parent, 'infoBarHeightSide')

	local barHeight = GUI:CreateSlider(infoBarHeightSide, 'infobar', 'bar_height', nil, {10, 20, 1})
	barHeight:SetPoint('TOP', infoBarHeightSide.child, 'TOP', 0, -24)


	local function toggleInfobarOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		anchorTop:SetShown(shown)
		mouseover:SetShown(shown)
		stats:SetShown(shown)
		spec:SetShown(shown)
		report:SetShown(shown)
		durability:SetShown(shown)
		guild:SetShown(shown)
		friends:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInfobarOptions)
	parent:HookScript('OnShow', toggleInfobarOptions)
end

--[[

local function addActionbarSection()
	local parent = FreeUIOptionsFrame.Actionbar
	parent.tab.icon:SetTexture('Interface\\ICONS\\Spell_Holy_SearingLightPriest')

	local basic = GUI:AddSubCategory(parent, 'GUI.localization.actionbar.sub_basic')
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'enable', nil, SetupActionbarSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)



	local class = GUI:CreateCheckBox(parent, 'button_class_color')
	class:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local range = GUI:CreateCheckBox(parent, 'button_range')
	range:SetPoint('LEFT', class, 'RIGHT', 160, 0)



	local hotkey = GUI:CreateCheckBox(parent, 'button_hotkey')
	hotkey:SetPoint('TOPLEFT', class, 'BOTTOMLEFT', 0, -8)

	local macro = GUI:CreateCheckBox(parent, 'button_macro_name')
	macro:SetPoint('LEFT', hotkey, 'RIGHT', 160, 0)

	local count = GUI:CreateCheckBox(parent, 'button_count')
	count:SetPoint('TOPLEFT', hotkey, 'BOTTOMLEFT', 0, -8)



	local cooldown = GUI:CreateCheckBox(parent, 'enable_cooldown', nil, SetupCooldown)
	cooldown:SetPoint('LEFT', count, 'RIGHT', 160, 0)

	local extra = GUI:AddSubCategory(parent, 'GUI.localization.actionbar.sub_extra')
	extra:SetPoint('TOPLEFT', count, 'BOTTOMLEFT', 0, -16)

	local bar1 = GUI:CreateCheckBox(parent, 'bar1')
	bar1:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local bar1Fade = GUI:CreateCheckBox(parent, 'bar1_fade')
	bar1Fade:SetPoint('LEFT', bar1, 'RIGHT', 160, 0)

	bar1.children = {bar1Fade}

	local bar2 = GUI:CreateCheckBox(parent, 'bar2')
	bar2:SetPoint('TOPLEFT', bar1, 'BOTTOMLEFT', 0, -8)

	local bar2Fade = GUI:CreateCheckBox(parent, 'bar2_fade')
	bar2Fade:SetPoint('LEFT', bar2, 'RIGHT', 160, 0)

	bar2.children = {bar2Fade}

	local bar3 = GUI:CreateCheckBox(parent, 'bar3')
	bar3:SetPoint('TOPLEFT', bar2, 'BOTTOMLEFT', 0, -8)

	local bar3Fade = GUI:CreateCheckBox(parent, 'bar3_fade')
	bar3Fade:SetPoint('LEFT', bar3, 'RIGHT', 160, 0)

	bar3.children = {bar3Fade}

	local bar4 = GUI:CreateCheckBox(parent, 'bar4')
	bar4:SetPoint('TOPLEFT', bar3, 'BOTTOMLEFT', 0, -8)

	local bar4Fade = GUI:CreateCheckBox(parent, 'bar4_fade')
	bar4Fade:SetPoint('LEFT', bar4, 'RIGHT', 160, 0)

	bar4.children = {bar4Fade}

	local bar5 = GUI:CreateCheckBox(parent, 'bar5')
	bar5:SetPoint('TOPLEFT', bar4, 'BOTTOMLEFT', 0, -8)

	local bar5Fade = GUI:CreateCheckBox(parent, 'bar5_fade')
	bar5Fade:SetPoint('LEFT', bar5, 'RIGHT', 160, 0)

	bar5.children = {bar5Fade}

	local petBar = GUI:CreateCheckBox(parent, 'pet_bar')
	petBar:SetPoint('TOPLEFT', bar5, 'BOTTOMLEFT', 0, -8)

	local petBarFade = GUI:CreateCheckBox(parent, 'pet_bar_fade')
	petBarFade:SetPoint('LEFT', petBar, 'RIGHT', 160, 0)

	petBar.children = {petBarFade}


	local cooldownSide = GUI:CreateSidePanel(parent, 'cooldownSide', 'GUI.localization.inventory.sub_adjustment')

	local ignoreWA = GUI:CreateCheckBox(parent, 'ignore_weakauras')
	ignoreWA:SetParent(cooldownSide)
	ignoreWA:SetPoint('TOPLEFT', cooldownSide, 'TOPLEFT', 20, -60)

	local cdPulse = GUI:CreateCheckBox(parent, 'cd_pulse')
	cdPulse:SetParent(cooldownSide)
	cdPulse:SetPoint('TOPLEFT', ignoreWA, 'BOTTOMLEFT', 0, -8)



	local useDecimal = GUI:CreateCheckBox(parent, 'use_decimal')
	useDecimal:SetParent(cooldownSide)
	useDecimal:SetPoint('TOPLEFT', cdPulse, 'BOTTOMLEFT', 0, -8)

	local decimalCooldown = GUI:CreateSlider(parent, 'decimal_countdown', 1, 10, 1, 10, 1, nil, true)
	decimalCooldown:SetParent(cooldownSide)
	decimalCooldown:SetPoint('TOP', cooldownSide, 'TOP', 0, -160)










	local actionbarSizeSide = GUI:CreateSidePanel(parent, 'actionbarSizeSide', 'GUI.localization.inventory.sub_adjustment')

	local buttonSizeSmall = GUI:CreateSlider(parent, 'button_size_small', 20, 50, 20, 50, 1, nil, true)
	buttonSizeSmall:SetParent(actionbarSizeSide)
	buttonSizeSmall:SetPoint('TOP', actionbarSizeSide, 'TOP', 0, -80)

	local buttonSizeNormal = GUI:CreateSlider(parent, 'button_size_normal', 20, 50, 20, 50, 1, nil, true)
	buttonSizeNormal:SetParent(buttonSizeSmall)
	buttonSizeNormal:SetPoint('TOP', buttonSizeSmall, 'BOTTOM', 0, -60)

	local buttonSizeBig = GUI:CreateSlider(parent, 'button_size_big', 20, 50, 20, 50, 1, nil, true)
	buttonSizeBig:SetParent(actionbarSizeSide)
	buttonSizeBig:SetPoint('TOP', buttonSizeNormal, 'BOTTOM', 0, -60)

	local buttonMargin = GUI:CreateSlider(parent, 'button_margin', 0, 10, 0, 10, 1, nil, true)
	buttonMargin:SetParent(actionbarSizeSide)
	buttonMargin:SetPoint('TOP', buttonSizeBig, 'BOTTOM', 0, -60)
end


local function addAnnouncementSection()
	local Announcement = FreeUIOptionsFrame.Announcement
	Announcement.tab.icon:SetTexture('Interface\\ICONS\\Ability_Warrior_RallyingCry')

	local basic = GUI:AddSubCategory(Announcement, 'GUI.localization.announcement.sub_basic')
	basic:SetPoint('TOPLEFT', Announcement.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(Announcement, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local feast = GUI:CreateCheckBox(Announcement, 'feast_cauldron')
	feast:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local bot = GUI:CreateCheckBox(Announcement, 'bot_codex')
	bot:SetPoint('LEFT', feast, 'RIGHT', 160, 0)

	local refreshment = GUI:CreateCheckBox(Announcement, 'conjure_refreshment')
	refreshment:SetPoint('TOPLEFT', feast, 'BOTTOMLEFT', 0, -8)

	local soulwell = GUI:CreateCheckBox(Announcement, 'create_soulwell')
	soulwell:SetPoint('LEFT', refreshment, 'RIGHT', 160, 0)

	local summoning = GUI:CreateCheckBox(Announcement, 'ritual_of_summoning')
	summoning:SetPoint('TOPLEFT', refreshment, 'BOTTOMLEFT', 0, -8)

	local portal = GUI:CreateCheckBox(Announcement, 'mage_portal')
	portal:SetPoint('LEFT', summoning, 'RIGHT', 160, 0)

	local mail = GUI:CreateCheckBox(Announcement, 'mail_service')
	mail:SetPoint('TOPLEFT', summoning, 'BOTTOMLEFT', 0, -8)

	local toy = GUI:CreateCheckBox(Announcement, 'special_toy')
	toy:SetPoint('LEFT', mail, 'RIGHT', 160, 0)

	local combat = GUI:AddSubCategory(Announcement, 'GUI.localization.announcement.sub_combat')
	combat:SetPoint('TOPLEFT', mail, 'BOTTOMLEFT', 0, -16)

	local interrupt = GUI:CreateCheckBox(Announcement, 'my_interrupt')
	interrupt:SetPoint('TOPLEFT', combat, 'BOTTOMLEFT', 0, -8)

	local dispel = GUI:CreateCheckBox(Announcement, 'my_dispel')
	dispel:SetPoint('LEFT', interrupt, 'RIGHT', 160, 0)

	local rez = GUI:CreateCheckBox(Announcement, 'combat_rez')
	rez:SetPoint('TOPLEFT', interrupt, 'BOTTOMLEFT', 0, -8)

	local sapped = GUI:CreateCheckBox(Announcement, 'get_sapped')
	sapped:SetPoint('LEFT', rez, 'RIGHT', 160, 0)


	local function toggleAnnouncementOptions()
		local shown = enable:GetChecked()
		interrupt:SetShown(shown)
		dispel:SetShown(shown)
		rez:SetShown(shown)
		sapped:SetShown(shown)
		feast:SetShown(shown)
		bot:SetShown(shown)
		portal:SetShown(shown)
		refreshment:SetShown(shown)
		soulwell:SetShown(shown)
		summoning:SetShown(shown)
		mail:SetShown(shown)
		toy:SetShown(shown)
		combat:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleAnnouncementOptions)
	Announcement:HookScript('OnShow', toggleAnnouncementOptions)
end





local function addChatSection()
	local parent = FreeUIOptionsFrame.Chat
	parent.tab.icon:SetTexture('Interface\\ICONS\\Spell_Shadow_Seduction')

	local basic = GUI:AddSubCategory(parent, 'GUI.localization.chat.sub_basic')
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local lock = GUI:CreateCheckBox(parent, 'lock_position', nil, SetupChatSize)
	lock:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local fading = GUI:CreateCheckBox(parent, 'fading')
	fading:SetPoint('LEFT', lock, 'RIGHT', 160, 0)

	local outline = GUI:CreateCheckBox(parent, 'font_outline')
	outline:SetPoint('TOPLEFT', lock, 'BOTTOMLEFT', 0, -8)

	local voiceIcon = GUI:CreateCheckBox(parent, 'voiceIcon')
	voiceIcon:SetPoint('LEFT', outline, 'RIGHT', 160, 0)

	local feature = GUI:AddSubCategory(parent, 'GUI.localization.chat.sub_feature')
	feature:SetPoint('TOPLEFT', outline, 'BOTTOMLEFT', 0, -16)

	local abbreviate = GUI:CreateCheckBox(parent, 'abbreviate')
	abbreviate:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local cycles = GUI:CreateCheckBox(parent, 'cycles')
	cycles:SetPoint('LEFT', abbreviate, 'RIGHT', 160, 0)

	local itemLinks = GUI:CreateCheckBox(parent, 'itemLinks')
	itemLinks:SetPoint('TOPLEFT', abbreviate, 'BOTTOMLEFT', 0, -8)

	local spamageMeter = GUI:CreateCheckBox(parent, 'spamageMeter')
	spamageMeter:SetPoint('LEFT', itemLinks, 'RIGHT', 160, 0)

	local sticky = GUI:CreateCheckBox(parent, 'sticky')
	sticky:SetPoint('TOPLEFT', itemLinks, 'BOTTOMLEFT', 0, -8)

	local whisperAlert = GUI:CreateCheckBox(parent, 'whisperAlert')
	whisperAlert:SetPoint('LEFT', sticky, 'RIGHT', 160, 0)

	local chatCopy = GUI:CreateCheckBox(parent, 'chatCopy')
	chatCopy:SetPoint('TOPLEFT', sticky, 'BOTTOMLEFT', 0, -8)

	local urlCopy = GUI:CreateCheckBox(parent, 'urlCopy')
	urlCopy:SetPoint('LEFT', chatCopy, 'RIGHT', 160, 0)

	local bubble = GUI:CreateCheckBox(parent, 'auto_toggle_chat_bubble')
	bubble:SetPoint('TOPLEFT', chatCopy, 'BOTTOMLEFT', 0, -8)

	local filter = GUI:AddSubCategory(parent, 'GUI.localization.chat.sub_filter')
	filter:SetPoint('TOPLEFT', bubble, 'BOTTOMLEFT', 0, -16)

	local chatFilter = GUI:CreateCheckBox(parent, 'filters', nil, SetupChatFilter)
	chatFilter:SetPoint('TOPLEFT', filter, 'BOTTOMLEFT', 0, -8)

	local blockAddonSpam = GUI:CreateCheckBox(parent, 'blockAddonSpam')
	blockAddonSpam:SetPoint('LEFT', chatFilter, 'RIGHT', 160, 0)

	local blockStranger = GUI:CreateCheckBox(parent, 'blockStranger')
	blockStranger:SetPoint('TOPLEFT', chatFilter, 'BOTTOMLEFT', 0, -8)

	local allowFriendsSpam = GUI:CreateCheckBox(parent, 'allowFriendsSpam')
	allowFriendsSpam:SetPoint('LEFT', blockStranger, 'RIGHT', 160, 0)

	local profanity = GUI:CreateCheckBox(parent, 'profanity')
	profanity:SetPoint('TOPLEFT', blockStranger, 'BOTTOMLEFT', 0, -8)


	local function toggleChatOptions()
		local shown = enable:GetChecked()
		lock:SetShown(shown)
		fading:SetShown(shown)
		outline:SetShown(shown)
		voiceIcon:SetShown(shown)
		abbreviate:SetShown(shown)
		whisperAlert:SetShown(shown)
		itemLinks:SetShown(shown)
		spamageMeter:SetShown(shown)
		sticky:SetShown(shown)
		cycles:SetShown(shown)
		profanity:SetShown(shown)
		chatCopy:SetShown(shown)
		urlCopy:SetShown(shown)
		chatFilter:SetShown(shown)
		blockAddonSpam:SetShown(shown)
		blockStranger:SetShown(shown)
		allowFriendsSpam:SetShown(shown)
		feature:SetShown(shown)
		filter:SetShown(shown)
		bubble:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleChatOptions)
	parent:HookScript('OnShow', toggleChatOptions)




	local chatSizeSide = GUI:CreateSidePanel(parent, 'chatSizeSide', 'GUI.localization.general.item_level')

	local chatSizeWidth = GUI:CreateSlider(parent, 'chat_size_width', 100, 600, 100, 600, 1, nil, true)
	chatSizeWidth:SetParent(chatSizeSide)
	chatSizeWidth:SetPoint('TOP', chatSizeSide, 'TOP', 0, -80)

	local chatSizeHeight = GUI:CreateSlider(parent, 'chat_size_height', 100, 600, 100, 600, 1, nil, true)
	chatSizeHeight:SetParent(chatSizeSide)
	chatSizeHeight:SetPoint('TOP', chatSizeWidth, 'BOTTOM', 0, -60)


	local chatFilterSide = GUI:CreateSidePanel(parent, 'chatFilterSide', 'GUI.localization.general.item_level')

	local filterMatches = GUI:CreateSlider(parent, 'matches', 1, 5, 1, 5, 1, nil, true)
	filterMatches:SetParent(chatFilterSide)
	filterMatches:SetPoint('TOP', chatFilterSide, 'TOP', 0, -80)

	local keywordsList = GUI.CreateEditBox(parent, 'keywordsList', true, nil, 140, 160, 999, nil, true)
	keywordsList:SetParent(chatFilterSide)
	keywordsList:SetPoint('TOP', filterMatches, 'BOTTOM', 0, -60)
end


local function addNotificationSection()
	local parent = FreeUIOptionsFrame.Notification
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Warrior_Revenge')

	local basic = GUI:AddSubCategory(parent, 'GUI.localization.notification.sub_basic')
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local bagFull = GUI:CreateCheckBox(parent, 'bag_full')
	bagFull:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local newMail = GUI:CreateCheckBox(parent, 'new_mail')
	newMail:SetPoint('LEFT', bagFull, 'RIGHT', 160, 0)

	local rareAlert = GUI:CreateCheckBox(parent, 'rare_alert')
	rareAlert:SetPoint('TOPLEFT', bagFull, 'BOTTOMLEFT', 0, -8)

	local versionCheck = GUI:CreateCheckBox(parent, 'version_check')
	versionCheck:SetPoint('LEFT', rareAlert, 'RIGHT', 160, 0)


	local function toggleNotificationOptions()
		local shown = enable:GetChecked()
		bagFull:SetShown(shown)
		newMail:SetShown(shown)
		rareAlert:SetShown(shown)
		versionCheck:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleNotificationOptions)
	parent:HookScript('OnShow', toggleNotificationOptions)
end


local function addAutomationSection()
	local Automation = FreeUIOptionsFrame.Automation
	Automation.tab.icon:SetTexture('Interface\\ICONS\\Ability_Siege_Engineer_Magnetic_Crush')

	local basic = GUI:AddSubCategory(Automation, 'GUI.localization.automation.sub_basic')
	basic:SetPoint('TOPLEFT', Automation.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(Automation, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local screen = GUI:CreateCheckBox(Automation, 'auto_screenshot')
	screen:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local buyStack = GUI:CreateCheckBox(Automation, 'easy_buy_stack')
	buyStack:SetPoint('LEFT', screen, 'RIGHT', 160, 0)


	local invite_keyword = GUI.CreateEditBox(Automation, 'invite_keyword', true)
	invite_keyword:SetPoint('TOPLEFT', screen, 'BOTTOMLEFT', 6, -8)


	local function toggleAutomationOptions()
		local shown = enable:GetChecked()

		buyStack:SetShown(shown)

		screen:SetShown(shown)


	end

	enable:HookScript('OnClick', toggleAutomationOptions)
	Automation:HookScript('OnShow', toggleAutomationOptions)
end




 ]]




function GUI:AddOptions()
	--addGeneralOptions()
	AppearanceOptions()
	-- addNotificationOptions()
	-- addAnnouncementOptions()
	-- addAutomationOptions()
	InfobarOptions()
	-- addChatOptions()
	AuraOptions()
	-- addActionbarOptions()
	CombatOptions()
	InventoryOptions()
	MapOptions()
	QuestOptions()
	TooltipOptions()
	UnitframeOptions()
end

