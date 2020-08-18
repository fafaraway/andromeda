local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')


--[[ callback ]]

local function UpdateBagStatus()
	F:GetModule('Inventory'):UpdateAllBags()
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
local function SetupTipExtra()
	GUI:ToggleSidePanel('tipExtraSide')
end

local function SetupTipFont()
	GUI:ToggleSidePanel('tipFontSide')
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


	local addons = GUI:AddSubCategory(parent)
	addons:SetPoint('TOPLEFT', reskinBlizz, 'BOTTOMLEFT', 0, -16)

	local DBM = GUI:CreateCheckBox(parent, 'theme', 'reskin_dbm')
	DBM:SetPoint('TOPLEFT', addons, 'BOTTOMLEFT', 0, -8)

	local WeakAuras = GUI:CreateCheckBox(parent, 'theme', 'reskin_weakauras')
	WeakAuras:SetPoint('LEFT', DBM, 'RIGHT', 160, 0)

	local Skada = GUI:CreateCheckBox(parent, 'theme', 'reskin_skada')
	Skada:SetPoint('TOPLEFT', DBM, 'BOTTOMLEFT', 0, -8)

	local PGF = GUI:CreateCheckBox(parent, 'theme', 'reskin_pgf')
	PGF:SetPoint('LEFT', Skada, 'RIGHT', 160, 0)


	local vignettingAlphaSide = GUI:CreateSidePanel(parent, 'vignettingAlphaSide')

	local vignettingAlpha = GUI:CreateSlider(vignettingAlphaSide, 'theme', 'vignetting_alpha', nil, {0, 1, 0.1})
	vignettingAlpha:SetPoint('TOP', 0, -90)


	local backdropAlphaSide = GUI:CreateSidePanel(parent, 'backdropAlphaSide')

	local backdropAlpha = GUI:CreateSlider(backdropAlphaSide, 'theme', 'backdrop_alpha', nil, {0.1, 1, 0.01})
	backdropAlpha:SetPoint('TOP', 0, -90)

end


local function AuraOptions()
	local parent = FreeUI_GUI.AURA
	parent.tab.icon:SetTexture('Interface\\ICONS\\Spell_Shadow_Shadesofdarkness')

	local basic = GUI:AddSubCategory(parent, L['GUI_AURA_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'aura', 'enable_aura', nil, SetupAuraSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -16)

	local reverseBuffs = GUI:CreateCheckBox(parent, 'aura', 'reverse_buffs')
	reverseBuffs:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local reverseDebuffs = GUI:CreateCheckBox(parent, 'aura', 'reverse_debuffs')
	reverseDebuffs:SetPoint('LEFT', reverseBuffs, 'RIGHT', 160, 0)

	local auraSource = GUI:CreateCheckBox(parent, 'aura', 'aura_source')
	auraSource:SetPoint('TOPLEFT', reverseBuffs, 'BOTTOMLEFT', 0, -8)

	local reminder = GUI:CreateCheckBox(parent, 'aura', 'buff_reminder')
	reminder:SetPoint('LEFT', auraSource, 'RIGHT', 160, 0)


	local auraSizeSide = GUI:CreateSidePanel(parent, 'auraSizeSide')

	local buffSize = GUI:CreateSlider(auraSizeSide, 'aura', 'buff_size', nil, {20, 50, 1})
	buffSize:SetPoint('TOP', auraSizeSide, 'TOP', 0, -90)

	local buffsPerRow = GUI:CreateSlider(auraSizeSide, 'aura', 'buffs_per_row', nil, {6, 16, 1})
	buffsPerRow:SetPoint('TOP', buffSize, 'BOTTOM', 0, -66)

	local debuffSize = GUI:CreateSlider(auraSizeSide, 'aura', 'debuff_size', nil, {20, 50, 1})
	debuffSize:SetPoint('TOP', buffsPerRow, 'BOTTOM', 0, -66)

	local debuffsPerRow = GUI:CreateSlider(auraSizeSide, 'aura', 'debuffs_per_row', nil, {6, 16, 1})
	debuffsPerRow:SetPoint('TOP', debuffSize, 'BOTTOM', 0, -66)

	local margin = GUI:CreateSlider(auraSizeSide, 'aura', 'margin', nil, {3, 10, 1})
	margin:SetPoint('TOP', debuffsPerRow, 'BOTTOM', 0, -66)

	local offset = GUI:CreateSlider(auraSizeSide, 'aura', 'offset', nil, {6, 16, 1})
	offset:SetPoint('TOP', margin, 'BOTTOM', 0, -66)


	enable.children = {reverseBuffs, reverseDebuffs, auraSource, reminder, buffSize, buffsPerRow, debuffSize, debuffsPerRow, margin, offset}

end


local function QuestOptions()
	local parent = FreeUI_GUI.QUEST
	parent.tab.icon:SetTexture('Interface\\ICONS\\ABILITY_Rogue_RollTheBones04')

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'quest', 'enable_quest')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local questLevel = GUI:CreateCheckBox(parent, 'quest', 'show_level')
	questLevel:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local rewardHightlight = GUI:CreateCheckBox(parent, 'quest', 'auto_select_reward')
	rewardHightlight:SetPoint('LEFT', questLevel, 'RIGHT', 160, 0)

	local completeRing = GUI:CreateCheckBox(parent, 'quest', 'complete_ring')
	completeRing:SetPoint('TOPLEFT', questLevel, 'BOTTOMLEFT', 0, -8)

	local questNotifier = GUI:CreateCheckBox(parent, 'quest', 'quest_notifier')
	questNotifier:SetPoint('LEFT', completeRing, 'RIGHT', 160, 0)

	local extraQuestButton = GUI:CreateCheckBox(parent, 'quest', 'extra_quest_button')
	extraQuestButton:SetPoint('TOPLEFT', completeRing, 'BOTTOMLEFT', 0, -8)

	enable.children = {questLevel, rewardHightlight, completeRing, questNotifier, extraQuestButton}

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

	local useCategory = GUI:CreateCheckBox(parent, 'inventory', 'item_filter', UpdateBagStatus, SetupBagFilters)
	useCategory:SetPoint('TOPLEFT', combineFreeSlots, 'BOTTOMLEFT', 0, -8)


	local bagSizeSide = GUI:CreateSidePanel(parent, 'bagSizeSide')

	local slotSize = GUI:CreateSlider(bagSizeSide, 'inventory', 'slot_size', nil, {20, 60, 1})
	slotSize:SetPoint('TOP', bagSizeSide, 'TOP', 0, -90)

	local spacing = GUI:CreateSlider(bagSizeSide, 'inventory', 'spacing', nil, {3, 6, 1})
	spacing:SetPoint('TOP', slotSize, 'BOTTOM', 0, -66)

	local bagColumns = GUI:CreateSlider(bagSizeSide, 'inventory', 'bag_columns', nil, {8, 16, 1})
	bagColumns:SetPoint('TOP', spacing, 'BOTTOM', 0, -66)

	local bankColumns = GUI:CreateSlider(bagSizeSide, 'inventory', 'bank_columns', nil, {8, 16, 1})
	bankColumns:SetPoint('TOP', bagColumns, 'BOTTOM', 0, -66)


	local itemLevelSide = GUI:CreateSidePanel(parent, 'bagIlvlSide')

	local iLvltoShow = GUI:CreateSlider(itemLevelSide, 'inventory', 'item_level_to_show', nil, {1, 500, 1})
	iLvltoShow:SetPoint('TOP', itemLevelSide, 'TOP', 0, -90)

	itemLevel.children = {iLvltoShow}


	local bagFilterSide = GUI:CreateSidePanel(parent, 'bagFilterSide')

	local itemFilterJunk = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_junk', UpdateBagStatus)
	itemFilterJunk:SetPoint('TOPLEFT', bagFilterSide, 'TOPLEFT', 20, -60)

	local itemFilterTrade = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_trade', UpdateBagStatus)
	itemFilterTrade:SetPoint('TOPLEFT', itemFilterJunk, 'BOTTOMLEFT', 00, -8)

	local itemFilterConsumable = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_consumable', UpdateBagStatus)
	itemFilterConsumable:SetPoint('TOPLEFT', itemFilterTrade, 'BOTTOMLEFT', 00, -8)

	local itemFilterQuest = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_quest', UpdateBagStatus)
	itemFilterQuest:SetPoint('TOPLEFT', itemFilterConsumable, 'BOTTOMLEFT', 00, -8)

	local itemFilterSet = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_gear_set', UpdateBagStatus)
	itemFilterSet:SetPoint('TOPLEFT', itemFilterQuest, 'BOTTOMLEFT', 00, -8)

	local itemFilterAzerite = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_azerite', UpdateBagStatus)
	itemFilterAzerite:SetPoint('TOPLEFT', itemFilterSet, 'BOTTOMLEFT', 00, -8)

	local itemFilterMountPet = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_mount_pet', UpdateBagStatus)
	itemFilterMountPet:SetPoint('TOPLEFT', itemFilterAzerite, 'BOTTOMLEFT', 00, -8)

	local itemFilterFavourite = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_favourite', UpdateBagStatus)
	itemFilterFavourite:SetPoint('TOPLEFT', itemFilterMountPet, 'BOTTOMLEFT', 00, -8)

	local itemFilterLegendary = GUI:CreateCheckBox(bagFilterSide, 'inventory', 'item_filter_legendary', UpdateBagStatus)
	itemFilterLegendary:SetPoint('TOPLEFT', itemFilterFavourite, 'BOTTOMLEFT', 00, -8)

	useCategory.children = {itemFilterSet, itemFilterLegendary, itemFilterMountPet, itemFilterFavourite, itemFilterTrade, itemFilterQuest, itemFilterJunk, itemFilterAzerite, itemFilterConsumable}

	enable.children = {newitemFlash, reverseSort, combineFreeSlots, itemLevel, useCategory, slotSize, spacing, bagColumns, bankColumns, iLvltoShow, itemFilterSet, itemFilterLegendary, itemFilterMountPet, itemFilterFavourite, itemFilterTrade, itemFilterQuest, itemFilterJunk, itemFilterAzerite, itemFilterConsumable}
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

	local texture = GUI:CreateDropdown(parent, 'unitframe', 'texture_style', nil, {L['GUI_UNITFRAME_TEXTURE_NORM'], L['GUI_UNITFRAME_TEXTURE_GRAD'], L['GUI_UNITFRAME_TEXTURE_FLAT']})
	texture:SetPoint('LEFT', transparency, 'RIGHT', 160, 0)

	local portrait = GUI:CreateCheckBox(parent, 'unitframe', 'portrait')
	portrait:SetPoint('TOPLEFT', transparency, 'BOTTOMLEFT', 0, -8)

	local fader = GUI:CreateCheckBox(parent, 'unitframe', 'fader')
	fader:SetPoint('TOPLEFT', portrait, 'BOTTOMLEFT', 0, -8)

	local feature = GUI:AddSubCategory(parent)
	feature:SetPoint('TOPLEFT', fader, 'BOTTOMLEFT', 0, -16)

	local rangeCheck = GUI:CreateCheckBox(parent, 'unitframe', 'range_check', nil, SetupRangeCheckAlpha)
	rangeCheck:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local gcdSpark = GUI:CreateCheckBox(parent, 'unitframe', 'gcd_spark')
	gcdSpark:SetPoint('LEFT', rangeCheck, 'RIGHT', 160, 0)

	local healPrediction = GUI:CreateCheckBox(parent, 'unitframe', 'heal_prediction')
	healPrediction:SetPoint('TOPLEFT', rangeCheck, 'BOTTOMLEFT', 0, -8)

	local overAbsorb = GUI:CreateCheckBox(parent, 'unitframe', 'over_absorb')
	overAbsorb:SetPoint('LEFT', healPrediction, 'RIGHT', 160, 0)

	local debuffsByPlayer = GUI:CreateCheckBox(parent, 'unitframe', 'debuffs_by_player')
	debuffsByPlayer:SetPoint('TOPLEFT', healPrediction, 'BOTTOMLEFT', 0, -8)

	local pet = GUI:AddSubCategory(parent)
	pet:SetPoint('TOPLEFT', debuffsByPlayer, 'BOTTOMLEFT', 0, -16)

	local enablePet = GUI:CreateCheckBox(parent, 'unitframe', 'enable_pet', nil, SetupPetSize)
	enablePet:SetPoint('TOPLEFT', pet, 'BOTTOMLEFT', 0, -8)

	local focus = GUI:AddSubCategory(parent)
	focus:SetPoint('TOPLEFT', enablePet, 'BOTTOMLEFT', 0, -16)

	local enableFocus = GUI:CreateCheckBox(parent, 'unitframe', 'enable_focus', nil, SetupFocusSize)
	enableFocus:SetPoint('TOPLEFT', focus, 'BOTTOMLEFT', 0, -8)

	local group = GUI:AddSubCategory(parent)
	group:SetPoint('TOPLEFT', enableFocus, 'BOTTOMLEFT', 0, -16)

	local enableGroup = GUI:CreateCheckBox(parent, 'unitframe', 'enable_group', nil, SetupGroupSize)
	enableGroup:SetPoint('TOPLEFT', group, 'BOTTOMLEFT', 0, -8)


	local groupNames = GUI:CreateCheckBox(parent, 'unitframe', 'group_names')
	groupNames:SetPoint('TOPLEFT', enableGroup, 'BOTTOMLEFT', 0, -8)

	local groupColorSmooth = GUI:CreateCheckBox(parent, 'unitframe', 'group_color_smooth')
	groupColorSmooth:SetPoint('LEFT', groupNames, 'RIGHT', 160, 0)



	local boss = GUI:AddSubCategory(parent)
	boss:SetPoint('TOPLEFT', groupNames, 'BOTTOMLEFT', 0, -16)

	local enableBoss = GUI:CreateCheckBox(parent, 'unitframe', 'enable_boss', nil, SetupBossSize)
	enableBoss:SetPoint('TOPLEFT', boss, 'BOTTOMLEFT', 0, -8)




	local unitSizeSide = GUI:CreateSidePanel(parent, 'unitSizeSide')

	local playerWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'player_width', nil, {80, 200, 1})
	playerWidth:SetPoint('TOP', unitSizeSide, 'TOP', 0, -90)

	local playerHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'player_height', nil, {10, 30, 1})
	playerHeight:SetPoint('TOP', playerWidth, 'BOTTOM', 0, -66)

	local targetWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_width', nil, {80, 200, 1})
	targetWidth:SetPoint('TOP', playerHeight, 'BOTTOM', 0, -66)

	local targetHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_height', nil, {10, 30, 1})
	targetHeight:SetPoint('TOP', targetWidth, 'BOTTOM', 0, -66)

	local totWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_width', nil, {80, 200, 1})
	totWidth:SetPoint('TOP', targetHeight, 'BOTTOM', 0, -66)

	local totHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_height', nil, {10, 30, 1})
	totHeight:SetPoint('TOP', totWidth, 'BOTTOM', 0, -66)

	local totHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_height', nil, {10, 30, 1})
	totHeight:SetPoint('TOP', totWidth, 'BOTTOM', 0, -66)


end

--[[


local function addCombatSection()
	local Combat = FreeUIOptionsFrame.Combat
	Combat.tab.icon:SetTexture('Interface\\ICONS\\Ability_Parry')

	local basic = GUI:AddSubCategory(Combat, 'GUI.localization.combat.sub_basic')
	basic:SetPoint('TOPLEFT', Combat.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(Combat, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local combat = GUI:CreateCheckBox(Combat, 'combat_alert')
	combat:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local health = GUI:CreateCheckBox(Combat, 'health_alert')
	health:SetPoint('LEFT', combat, 'RIGHT', 160, 0)

	local spell = GUI:CreateCheckBox(Combat, 'spell_alert')
	spell:SetPoint('TOPLEFT', combat, 'BOTTOMLEFT', 0, -8)

	local fct = GUI:AddSubCategory(Combat, 'GUI.localization.combat.sub_fct')
	fct:SetPoint('TOPLEFT', spell, 'BOTTOMLEFT', 0, -16)

	local outgoing = GUI:CreateCheckBox(Combat, 'fct_outgoing')
	outgoing:SetPoint('TOPLEFT', fct, 'BOTTOMLEFT', 0, -8)

	local incoming = GUI:CreateCheckBox(Combat, 'fct_incoming')
	incoming:SetPoint('LEFT', outgoing, 'RIGHT', 160, 0)

	local pet = GUI:CreateCheckBox(Combat, 'fct_pet')
	pet:SetPoint('TOPLEFT', outgoing, 'BOTTOMLEFT', 0, -8)

	local periodic = GUI:CreateCheckBox(Combat, 'fct_periodic')
	periodic:SetPoint('LEFT', pet, 'RIGHT', 160, 0)

	local merge = GUI:CreateCheckBox(Combat, 'fct_merge')
	merge:SetPoint('TOPLEFT', pet, 'BOTTOMLEFT', 0, -8)

	local pvp = GUI:AddSubCategory(Combat, 'GUI.localization.combat.sub_pvp')
	pvp:SetPoint('TOPLEFT', merge, 'BOTTOMLEFT', 0, -16)

	local autoTab = GUI:CreateCheckBox(Combat, 'auto_tab')
	autoTab:SetPoint('TOPLEFT', pvp, 'BOTTOMLEFT', 0, -8)

	local PVPSound = GUI:CreateCheckBox(Combat, 'pvp_sound')
	PVPSound:SetPoint('LEFT', autoTab, 'RIGHT', 160, 0)

	local adjustment = GUI:AddSubCategory(Combat, 'GUI.localization.combat.sub_adjustment')
	adjustment:SetPoint('TOPLEFT', autoTab, 'BOTTOMLEFT', 0, -16)

	local threshold = GUI:CreateSlider(Combat, 'health_alert_threshold', 0.2, 0.6, 0.2, 0.6, 0.1, nil, true)
	threshold:SetPoint('TOPLEFT', adjustment, 'BOTTOMLEFT', 16, -32)

	health.children = {threshold}


	local function toggleCombatOptions()
		local shown = enable:GetChecked()
		outgoing:SetShown(shown)
		incoming:SetShown(shown)
		pet:SetShown(shown)
		merge:SetShown(shown)
		periodic:SetShown(shown)
		combat:SetShown(shown)
		spell:SetShown(shown)
		health:SetShown(shown)
		PVPSound:SetShown(shown)
		autoTab:SetShown(shown)
		adjustment:SetShown(shown)
		threshold:SetShown(shown)
		fct:SetShown(shown)
		pvp:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleCombatOptions)
	Combat:HookScript('OnShow', toggleCombatOptions)
end


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


local function addInfobarSection()
	local Infobar = FreeUIOptionsFrame.Infobar
	Infobar.tab.icon:SetTexture('Interface\\ICONS\\Ability_Priest_Ascension')

	local basic = GUI:AddSubCategory(Infobar, 'GUI.localization.infobar.sub_basic')
	basic:SetPoint('TOPLEFT', Infobar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(Infobar, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local mouseover = GUI:CreateCheckBox(Infobar, 'mouseover')
	mouseover:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local stats = GUI:CreateCheckBox(Infobar, 'stats')
	stats:SetPoint('LEFT', mouseover, 'RIGHT', 160, 0)

	local friends = GUI:CreateCheckBox(Infobar, 'friends')
	friends:SetPoint('TOPLEFT', mouseover, 'BOTTOMLEFT', 0, -8)

	local guild = GUI:CreateCheckBox(Infobar, 'guild')
	guild:SetPoint('LEFT', friends, 'RIGHT', 160, 0)

	local durability = GUI:CreateCheckBox(Infobar, 'durability')
	durability:SetPoint('TOPLEFT', friends, 'BOTTOMLEFT', 0, -8)

	local spec = GUI:CreateCheckBox(Infobar, 'spec')
	spec:SetPoint('LEFT', durability, 'RIGHT', 160, 0)

	local report = GUI:CreateCheckBox(Infobar, 'report')
	report:SetPoint('TOPLEFT', durability, 'BOTTOMLEFT', 0, -8)

	local adjustment = GUI:AddSubCategory(Infobar, 'GUI.localization.infobar.sub_adjustment')
	adjustment:SetPoint('TOPLEFT', report, 'BOTTOMLEFT', 0, -16)

	local height = GUI:CreateSlider(Infobar, 'height', 10, 20, 10, 20, 1, nil, true)
	height:SetPoint('TOPLEFT', adjustment, 'BOTTOMLEFT', 16, -32)


	local function toggleInfobarOptions()
		local shown = enable:GetChecked()
		mouseover:SetShown(shown)
		stats:SetShown(shown)
		spec:SetShown(shown)
		report:SetShown(shown)
		durability:SetShown(shown)
		guild:SetShown(shown)
		friends:SetShown(shown)
		height:SetShown(shown)
		adjustment:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInfobarOptions)
	Infobar:HookScript('OnShow', toggleInfobarOptions)
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


local function addMapSection()
	local Map = FreeUIOptionsFrame.Map
	Map.tab.icon:SetTexture('Interface\\ICONS\\Achievement_Ashran_Tourofduty')

	local basic = GUI:AddSubCategory(Map, 'GUI.localization.map.sub_basic')
	basic:SetPoint('TOPLEFT', Map.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(Map, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local coords = GUI:CreateCheckBox(Map, 'coords')
	coords:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local miniMap = GUI:AddSubCategory(Map, 'GUI.localization.map.sub_minimap')
	miniMap:SetPoint('TOPLEFT', coords, 'BOTTOMLEFT', 0, -16)

	local whoPings = GUI:CreateCheckBox(Map, 'whoPings')
	whoPings:SetPoint('TOPLEFT', miniMap, 'BOTTOMLEFT', 0, -8)

	local microMenu = GUI:CreateCheckBox(Map, 'microMenu')
	microMenu:SetPoint('TOPLEFT', whoPings, 'BOTTOMLEFT', 0, -8)

	local expBar = GUI:CreateCheckBox(Map, 'expBar')
	expBar:SetPoint('TOPLEFT', microMenu, 'BOTTOMLEFT', 0, -8)

	local minimapScale = GUI:CreateSlider(Map, 'minimapScale', 0.5, 1, 0.5, 1, 0.1, nil, true)
	minimapScale:SetPoint('LEFT', whoPings, 'RIGHT', 160, -20)


	local function toggleMapOptions()
		local shown = enable:GetChecked()
		coords:SetShown(shown)
		whoPings:SetShown(shown)
		expBar:SetShown(shown)
		microMenu:SetShown(shown)
		minimapScale:SetShown(shown)
		miniMap:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleMapOptions)
	Map:HookScript('OnShow', toggleMapOptions)
end





local function addTooltipSection()
	local parent = FreeUIOptionsFrame.Tooltip
	parent.tab.icon:SetTexture('Interface\\ICONS\\INV_Misc_ScrollUnrolled03d')

	local basic = GUI:AddSubCategory(parent, 'GUI.localization.tooltip.sub_basic')
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'enable', nil, SetupTipFont)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local cursor = GUI:CreateCheckBox(parent, 'follow_cursor')
	cursor:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local combatHide = GUI:CreateCheckBox(parent, 'hide_in_combat')
	combatHide:SetPoint('LEFT', cursor, 'RIGHT', 160, 0)

	local tipIcon = GUI:CreateCheckBox(parent, 'tip_icon')
	tipIcon:SetPoint('TOPLEFT', cursor, 'BOTTOMLEFT', 0, -8)

	local borderColor = GUI:CreateCheckBox(parent, 'border_color')
	borderColor:SetPoint('LEFT', tipIcon, 'RIGHT', 160, 0)

	local hideTitle = GUI:CreateCheckBox(parent, 'hide_title')
	hideTitle:SetPoint('TOPLEFT', tipIcon, 'BOTTOMLEFT', 0, -8)

	local hideRealm = GUI:CreateCheckBox(parent, 'hide_realm')
	hideRealm:SetPoint('LEFT', hideTitle, 'RIGHT', 160, 0)

	local hideRank = GUI:CreateCheckBox(parent, 'hide_rank')
	hideRank:SetPoint('TOPLEFT', hideTitle, 'BOTTOMLEFT', 0, -8)

	local targetBy = GUI:CreateCheckBox(parent, 'target_by')
	targetBy:SetPoint('LEFT', hideRank, 'RIGHT', 160, 0)

	local linkHover = GUI:CreateCheckBox(parent, 'link_hover')
	linkHover:SetPoint('TOPLEFT', hideRank, 'BOTTOMLEFT', 0, -8)

	local azerite = GUI:CreateCheckBox(parent, 'azerite_armor')
	azerite:SetPoint('LEFT', linkHover, 'RIGHT', 160, 0)

	local spec = GUI:CreateCheckBox(parent, 'spec_ilvl')
	spec:SetPoint('TOPLEFT', linkHover, 'BOTTOMLEFT', 0, -8)

	local extraInfo = GUI:CreateCheckBox(parent, 'extra_info', nil, SetupTipExtra)
	extraInfo:SetPoint('LEFT', spec, 'RIGHT', 160, 0)




	local tipFontSide = GUI:CreateSidePanel(parent, 'tipFontSide', 'GUI.localization.general.item_level')

	local headerFontSize = GUI:CreateSlider(parent, 'header_font_size', 8, 20, 8, 20, 1, nil, true)
	headerFontSize:SetParent(tipFontSide)
	headerFontSize:SetPoint('TOP', tipFontSide, 'TOP', 0, -80)

	local normalFontSize = GUI:CreateSlider(parent, 'normal_font_size', 8, 20, 8, 20, 1, nil, true)
	normalFontSize:SetParent(tipFontSide)
	normalFontSize:SetPoint('TOP', headerFontSize, 'BOTTOM', 0, -60)

	local backdropAlpha = GUI:CreateSlider(parent, 'tip_backdrop_alpha', 0.1, 1, 0.1, 1, 0.1, nil, true)
	backdropAlpha:SetParent(tipFontSide)
	backdropAlpha:SetPoint('TOP', normalFontSize, 'BOTTOM', 0, -60)




	local tipExtraSide = GUI:CreateSidePanel(parent, 'tipExtraSide', 'GUI.localization.general.item_level')

	local variousID = GUI:CreateCheckBox(parent, 'various_id')
	variousID:SetParent(tipExtraSide)
	variousID:SetPoint('TOPLEFT', bagFilterSide, 'TOPLEFT', 20, -60)

	local itemCount = GUI:CreateCheckBox(parent, 'item_count')
	itemCount:SetParent(tipExtraSide)
	itemCount:SetPoint('TOPLEFT', variousID, 'BOTTOMLEFT', 00, -8)

	local itemPrice = GUI:CreateCheckBox(parent, 'item_price')
	itemPrice:SetParent(tipExtraSide)
	itemPrice:SetPoint('TOPLEFT', itemCount, 'BOTTOMLEFT', 00, -8)

	local auraSource = GUI:CreateCheckBox(parent, 'aura_source')
	auraSource:SetParent(tipExtraSide)
	auraSource:SetPoint('TOPLEFT', itemPrice, 'BOTTOMLEFT', 00, -8)

	local mountSource = GUI:CreateCheckBox(parent, 'mount_source')
	mountSource:SetParent(tipExtraSide)
	mountSource:SetPoint('TOPLEFT', auraSource, 'BOTTOMLEFT', 00, -8)






	local function toggleTooltipOptions()
		local shown = enable:GetChecked()
		cursor:SetShown(shown)
		hideTitle:SetShown(shown)
		hideRealm:SetShown(shown)
		hideRank:SetShown(shown)
		combatHide:SetShown(shown)
		linkHover:SetShown(shown)
		borderColor:SetShown(shown)
		tipIcon:SetShown(shown)
		extraInfo:SetShown(shown)
		targetBy:SetShown(shown)
		spec:SetShown(shown)
		azerite:SetShown(shown)
		auraSource:SetShown(shown)
		mountSource:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleTooltipOptions)
	parent:HookScript('OnShow', toggleTooltipOptions)
end ]]




function GUI:AddOptions()
	--addGeneralOptions()
	AppearanceOptions()
	-- addNotificationOptions()
	-- addAnnouncementOptions()
	-- addAutomationOptions()
	-- addInfobarOptions()
	-- addChatOptions()
	AuraOptions()
	-- addActionbarOptions()
	-- addCombatOptions()
	InventoryOptions()
	-- addMapOptions()
	QuestOptions()
	-- addTooltipOptions()
	UnitframeOptions()
end

