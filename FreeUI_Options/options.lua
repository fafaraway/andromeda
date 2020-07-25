local _, ns = ...





ns.textureList = {
	'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex',
	'Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex',
	'Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex',
}

ns.dropdownList = {
	['Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex'] = ns.localization.dropdown.normal,
	['Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex'] = ns.localization.dropdown.gradient,
	['Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex'] = ns.localization.dropdown.flat,
}


ns.AddCategories = function()
	ns.AddCategory('General')
	ns.AddCategory('Theme')
	ns.AddCategory('Notification')
	ns.AddCategory('Announcement')
	ns.AddCategory('Automation')
	ns.AddCategory('Infobar')
	ns.AddCategory('Chat')
	ns.AddCategory('Aura')
	ns.AddCategory('Actionbar')
	ns.AddCategory('Cooldown')
	ns.AddCategory('Combat')
	ns.AddCategory('Inventory')
	ns.AddCategory('Map')
	ns.AddCategory('Quest')
	ns.AddCategory('Tooltip')
	ns.AddCategory('Unitframe')
end


local function togglePanel(frame)
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end

local function toggleSidePanel(name)
	for _, frame in next, ns.sidePanels do
		if frame:GetName() == name then
			togglePanel(frame)
		else
			frame:Hide()
		end
	end
end

local function setupItemLevel()
	toggleSidePanel('itemLevelSide')
end

local function setupBagSize()
	toggleSidePanel('bagSizeSide')
end

local function setupBagFilters()
	toggleSidePanel('bagFilterSide')
end

local function setupBagIlvl()
	toggleSidePanel('bagIlvlSide')
end


local function addGeneralOptions()
	local parent = FreeUIOptionsFrame.General
	parent.tab.icon:SetTexture('Interface\\ICONS\\Ability_Crown_of_the_Heavens_Icon')

	local basic = ns.AddSubCategory(parent, ns.localization.general.sub_basic)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local blizzMover = ns.CreateCheckBox(parent, 'blizz_mover')
	blizzMover:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local alreadyKnown = ns.CreateCheckBox(parent, 'already_known')
	alreadyKnown:SetPoint('LEFT', blizzMover, 'RIGHT', 160, 0)

	local hideBossBanner = ns.CreateCheckBox(parent, 'hide_boss_banner')
	hideBossBanner:SetPoint('TOPLEFT', blizzMover, 'BOTTOMLEFT', 0, -8)

	local hideTalkingHead = ns.CreateCheckBox(parent, 'hide_talking_head')
	hideTalkingHead:SetPoint('LEFT', hideBossBanner, 'RIGHT', 160, 0)

	local itemLevel = ns.CreateCheckBox(parent, 'item_level', setupItemLevel)
	itemLevel:SetPoint('TOPLEFT', hideBossBanner, 'BOTTOMLEFT', 0, -8)

	local mailButton = ns.CreateCheckBox(parent, 'mail_button')
	mailButton:SetPoint('TOPLEFT', itemLevel, 'BOTTOMLEFT', 0, -8)

	local undressButton = ns.CreateCheckBox(parent, 'undress_button')
	undressButton:SetPoint('LEFT', mailButton, 'RIGHT', 160, 0)

	local errors = ns.CreateCheckBox(parent, 'tidy_errors')
	errors:SetPoint('TOPLEFT', mailButton, 'BOTTOMLEFT', 0, -8)

	local colorPicker = ns.CreateCheckBox(parent, 'color_picker')
	colorPicker:SetPoint('LEFT', errors, 'RIGHT', 160, 0)

	local tradeTargetInfo = ns.CreateCheckBox(parent, 'trade_target_info')
	tradeTargetInfo:SetPoint('TOPLEFT', errors, 'BOTTOMLEFT', 0, -8)

	local petFilter = ns.CreateCheckBox(parent, 'pet_filter')
	petFilter:SetPoint('LEFT', tradeTargetInfo, 'RIGHT', 160, 0)

	local queueTimer = ns.CreateCheckBox(parent, 'queue_timer')
	queueTimer:SetPoint('TOPLEFT', tradeTargetInfo, 'BOTTOMLEFT', 0, -8)
	
	local keystone = ns.CreateCheckBox(parent, 'account_keystone')
	keystone:SetPoint('LEFT', queueTimer, 'RIGHT', 160, 0)

	local tradeTabs = ns.CreateCheckBox(parent, 'trade_tabs')
	tradeTabs:SetPoint('TOPLEFT', queueTimer, 'BOTTOMLEFT', 0, -8)

	local rareAlert = ns.CreateCheckBox(parent, 'rare_alert')
	rareAlert:SetPoint('LEFT', tradeTabs, 'RIGHT', 160, 0)

	local missingStats = ns.CreateCheckBox(parent, 'missing_stats')
	missingStats:SetPoint('TOPLEFT', tradeTabs, 'BOTTOMLEFT', 0, -8)

	local delete = ns.CreateCheckBox(parent, 'easy_delete')
	delete:SetPoint('LEFT', missingStats, 'RIGHT', 160, 0)

	local focus = ns.CreateCheckBox(parent, 'easy_focus')
	focus:SetPoint('TOPLEFT', missingStats, 'BOTTOMLEFT', 0, -8)

	local ouf = ns.CreateCheckBox(parent, 'easy_focus_on_ouf')
	ouf:SetPoint('LEFT', focus, 'RIGHT', 160, 0)

	focus.children = {ouf}

	local loot = ns.CreateCheckBox(parent, 'instant_loot')
	loot:SetPoint('TOPLEFT', focus, 'BOTTOMLEFT', 0, -8)

	local naked = ns.CreateCheckBox(parent, 'easy_naked')
	naked:SetPoint('LEFT', loot, 'RIGHT', 160, 0)

	local mark = ns.CreateCheckBox(parent, 'easy_mark')
	mark:SetPoint('TOPLEFT', loot, 'BOTTOMLEFT', 0, -8)

	local reject = ns.CreateCheckBox(parent, 'auto_reject_stranger', nil, true)
	reject:SetPoint('LEFT', mark, 'RIGHT', 160, 0)

	local camera = ns.AddSubCategory(parent, ns.localization.general.sub_camera)
	camera:SetPoint('TOPLEFT', mark, 'BOTTOMLEFT', 0, -16)

	local actionCam = ns.CreateCheckBox(parent, 'action_camera')
	actionCam:SetPoint('TOPLEFT', camera, 'BOTTOMLEFT', 0, -8)

	local fasterCam = ns.CreateCheckBox(parent, 'faster_camera')
	fasterCam:SetPoint('LEFT', actionCam, 'RIGHT', 160, 0)

	local uiscale = ns.AddSubCategory(parent, ns.localization.general.sub_uiscale)
	uiscale:SetPoint('TOPLEFT', actionCam, 'BOTTOMLEFT', 0, -16)

	local uiScaleMult = ns.CreateNumberSlider(parent, 'ui_scale', 1, 2, 1, 2, 0.1, true)
	uiScaleMult:SetPoint('TOPLEFT', uiscale, 'BOTTOMLEFT', 16, -32)


	local itemLevelSide = ns.CreateSidePanel(parent, 'itemLevelSide', ns.localization.general.item_level, true)

	local gemEnchant = ns.CreateCheckBox(parent, 'gem_enchant')
	gemEnchant:SetParent(itemLevelSide)
	gemEnchant:SetPoint('TOPLEFT', itemLevelSide, 'TOPLEFT', 20, -60)

	local azeriteTraits = ns.CreateCheckBox(parent, 'azerite_traits')
	azeriteTraits:SetParent(itemLevelSide)
	azeriteTraits:SetPoint('TOPLEFT', gemEnchant, 'BOTTOMLEFT', 00, -8)

	local merchantIlvl = ns.CreateCheckBox(parent, 'merchant_ilvl')
	merchantIlvl:SetParent(itemLevelSide)
	merchantIlvl:SetPoint('TOPLEFT', azeriteTraits, 'BOTTOMLEFT', 00, -8)

	itemLevel.children = {gemEnchant, azeriteTraits, merchantIlvl}
end


local function addAuraOptions()
	local Aura = FreeUIOptionsFrame.Aura
	Aura.tab.icon:SetTexture('Interface\\ICONS\\Spell_Shadow_Shadesofdarkness')

	local basic = ns.AddSubCategory(Aura, ns.localization.aura.sub_basic)
	basic:SetPoint('TOPLEFT', Aura.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Aura, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local reverseBuffs = ns.CreateCheckBox(Aura, 'reverseBuffs')
	reverseBuffs:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local reverseDebuffs = ns.CreateCheckBox(Aura, 'reverseDebuffs')
	reverseDebuffs:SetPoint('LEFT', reverseBuffs, 'RIGHT', 160, 0)

	local reminder = ns.CreateCheckBox(Aura, 'reminder')
	reminder:SetPoint('TOPLEFT', reverseBuffs, 'BOTTOMLEFT', 0, -8)

	local size = ns.AddSubCategory(Aura, ns.localization.aura.sub_adjustment)
	size:SetPoint('TOPLEFT', reminder, 'BOTTOMLEFT', 0, -16)

	local buffSize = ns.CreateNumberSlider(Aura, 'buffSize', 20, 60, 20, 60, 1, true)
	buffSize:SetPoint('TOPLEFT', size, 'BOTTOMLEFT', 16, -32)

	local debuffSize = ns.CreateNumberSlider(Aura, 'debuffSize', 20, 60, 20, 60, 1, true)
	debuffSize:SetPoint('LEFT', buffSize, 'RIGHT', 60, 0)

	local buffsPerRow = ns.CreateNumberSlider(Aura, 'buffsPerRow', 6, 16, 6, 16, 1, true)
	buffsPerRow:SetPoint('TOPLEFT', buffSize, 'BOTTOMLEFT', 0, -64)

	local debuffsPerRow = ns.CreateNumberSlider(Aura, 'debuffsPerRow', 6, 16, 6, 16, 1, true)
	debuffsPerRow:SetPoint('LEFT', buffsPerRow, 'RIGHT', 60, 0)

	local margin = ns.CreateNumberSlider(Aura, 'margin', 3, 10, 3, 10, 1, true)
	margin:SetPoint('TOPLEFT', buffsPerRow, 'BOTTOMLEFT', 0, -64)

	local offset = ns.CreateNumberSlider(Aura, 'offset', 6, 16, 6, 16, 1, true)
	offset:SetPoint('LEFT', margin, 'RIGHT', 60, 0)

	local function toggleAuraOptions()
		local shown = enable:GetChecked()
		reverseBuffs:SetShown(shown)
		reverseDebuffs:SetShown(shown)
		reminder:SetShown(shown)
		buffSize:SetShown(shown)
		debuffSize:SetShown(shown)
		buffsPerRow:SetShown(shown)
		debuffsPerRow:SetShown(shown)
		margin:SetShown(shown)
		offset:SetShown(shown)
		size:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleAuraOptions)
	Aura:HookScript('OnShow', toggleAuraOptions)
end


local function addInventoryOptions()
	local parent = FreeUIOptionsFrame.Inventory
	parent.tab.icon:SetTexture('Interface\\ICONS\\INV_Misc_Bag_30')

	local basic = ns.AddSubCategory(parent, ns.localization.inventory.sub_basic)
	basic:SetPoint('TOPLEFT', parent.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(parent, 'enable_module', setupBagSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local newitemFlash = ns.CreateCheckBox(parent, 'new_item_flash')
	newitemFlash:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local reverseSort = ns.CreateCheckBox(parent, 'reverse_sort')
	reverseSort:SetPoint('LEFT', newitemFlash, 'RIGHT', 160, 0)

	local combineFreeSlots = ns.CreateCheckBox(parent, 'combine_free_slots')
	combineFreeSlots:SetPoint('TOPLEFT', newitemFlash, 'BOTTOMLEFT', 0, -8)

	local itemLevel = ns.CreateCheckBox(parent, 'item_level', setupBagIlvl)
	itemLevel:SetPoint('LEFT', combineFreeSlots, 'RIGHT', 160, 0)

	local useCategory = ns.CreateCheckBox(parent, 'item_filter', setupBagFilters)
	useCategory:SetPoint('TOPLEFT', combineFreeSlots, 'BOTTOMLEFT', 0, -8)

	local function toggleInventoryOptions()
		local shown = enable:GetChecked()
		newitemFlash:SetShown(shown)
		reverseSort:SetShown(shown)
		itemLevel:SetShown(shown)
		combineFreeSlots:SetShown(shown)
		useCategory:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleInventoryOptions)
	parent:HookScript('OnShow', toggleInventoryOptions)




	local bagSizeSide = ns.CreateSidePanel(parent, 'bagSizeSide', ns.localization.inventory.sub_adjustment)


	local slotSize = ns.CreateNumberSlider(parent, 'slot_size', 20, 60, 20, 60, 1, true)
	slotSize:SetParent(bagSizeSide)
	slotSize:SetPoint('TOP', bagSizeSide, 'TOP', 0, -80)

	local spacing = ns.CreateNumberSlider(parent, 'spacing', 3, 6, 3, 6, 1, true)
	spacing:SetParent(bagSizeSide)
	spacing:SetPoint('TOP', slotSize, 'BOTTOM', 0, -60)

	local bagColumns = ns.CreateNumberSlider(parent, 'bag_columns', 8, 16, 8, 16, 1, true)
	bagColumns:SetParent(bagSizeSide)
	bagColumns:SetPoint('TOP', spacing, 'BOTTOM', 0, -60)

	local bankColumns = ns.CreateNumberSlider(parent, 'bank_columns', 8, 16, 8, 16, 1, true)
	bankColumns:SetParent(bagSizeSide)
	bankColumns:SetPoint('TOP', bagColumns, 'BOTTOM', 0, -60)

	enable.children = {slotSize, spacing, bagColumns, bankColumns}




	local itemLevelSide = ns.CreateSidePanel(parent, 'bagIlvlSide', ns.localization.inventory.item_level, true)

	local iLvltoShow = ns.CreateNumberSlider(parent, 'item_level_to_show', 1, 500, 1, 500, 1, true)
	iLvltoShow:SetParent(itemLevelSide)
	iLvltoShow:SetPoint('TOP', itemLevelSide, 'TOP', 0, -80)

	itemLevel.children = {iLvltoShow}


	local bagFilterSide = ns.CreateSidePanel(parent, 'bagFilterSide', ns.localization.inventory.bag_filters_header)

	local itemFilterJunk = ns.CreateCheckBox(parent, 'item_filter_junk')
	itemFilterJunk:SetParent(bagFilterSide)
	itemFilterJunk:SetPoint('TOPLEFT', bagFilterSide, 'TOPLEFT', 20, -60)

	local itemFilterTrade = ns.CreateCheckBox(parent, 'item_filter_trade')
	itemFilterTrade:SetParent(bagFilterSide)
	itemFilterTrade:SetPoint('TOPLEFT', itemFilterJunk, 'BOTTOMLEFT', 00, -8)

	local itemFilterConsumable = ns.CreateCheckBox(parent, 'item_filter_consumable')
	itemFilterConsumable:SetParent(bagFilterSide)
	itemFilterConsumable:SetPoint('TOPLEFT', itemFilterTrade, 'BOTTOMLEFT', 00, -8)

	local itemFilterQuest = ns.CreateCheckBox(parent, 'item_filter_quest')
	itemFilterQuest:SetParent(bagFilterSide)
	itemFilterQuest:SetPoint('TOPLEFT', itemFilterConsumable, 'BOTTOMLEFT', 00, -8)

	local itemFilterSet = ns.CreateCheckBox(parent, 'item_filter_gear_set')
	itemFilterSet:SetParent(bagFilterSide)
	itemFilterSet:SetPoint('TOPLEFT', itemFilterQuest, 'BOTTOMLEFT', 00, -8)

	local itemFilterAzerite = ns.CreateCheckBox(parent, 'item_filter_azerite')
	itemFilterAzerite:SetParent(bagFilterSide)
	itemFilterAzerite:SetPoint('TOPLEFT', itemFilterSet, 'BOTTOMLEFT', 00, -8)

	local itemFilterMountPet = ns.CreateCheckBox(parent, 'item_filter_mount_pet')
	itemFilterMountPet:SetParent(bagFilterSide)
	itemFilterMountPet:SetPoint('TOPLEFT', itemFilterAzerite, 'BOTTOMLEFT', 00, -8)

	local itemFilterFavourite = ns.CreateCheckBox(parent, 'item_filter_favourite')
	itemFilterFavourite:SetParent(bagFilterSide)
	itemFilterFavourite:SetPoint('TOPLEFT', itemFilterMountPet, 'BOTTOMLEFT', 00, -8)

	local itemFilterLegendary = ns.CreateCheckBox(parent, 'item_filter_legendary')
	itemFilterLegendary:SetParent(bagFilterSide)
	itemFilterLegendary:SetPoint('TOPLEFT', itemFilterFavourite, 'BOTTOMLEFT', 00, -8)

	useCategory.children = {itemFilterSet, itemFilterLegendary, itemFilterMountPet, itemFilterFavourite, itemFilterTrade, itemFilterQuest, itemFilterJunk, itemFilterAzerite, itemFilterConsumable}
end


local function addCombatOptions()
	local Combat = FreeUIOptionsFrame.Combat
	Combat.tab.icon:SetTexture('Interface\\ICONS\\Ability_Parry')

	local basic = ns.AddSubCategory(Combat, ns.localization.combat.sub_basic)
	basic:SetPoint('TOPLEFT', Combat.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Combat, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local combat = ns.CreateCheckBox(Combat, 'combat_alert')
	combat:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local health = ns.CreateCheckBox(Combat, 'health_alert')
	health:SetPoint('LEFT', combat, 'RIGHT', 160, 0)

	local spell = ns.CreateCheckBox(Combat, 'spell_alert')
	spell:SetPoint('TOPLEFT', combat, 'BOTTOMLEFT', 0, -8)

	local fct = ns.AddSubCategory(Combat, ns.localization.combat.sub_fct)
	fct:SetPoint('TOPLEFT', spell, 'BOTTOMLEFT', 0, -16)

	local outgoing = ns.CreateCheckBox(Combat, 'fct_outgoing')
	outgoing:SetPoint('TOPLEFT', fct, 'BOTTOMLEFT', 0, -8)

	local incoming = ns.CreateCheckBox(Combat, 'fct_incoming')
	incoming:SetPoint('LEFT', outgoing, 'RIGHT', 160, 0)

	local pet = ns.CreateCheckBox(Combat, 'fct_pet')
	pet:SetPoint('TOPLEFT', outgoing, 'BOTTOMLEFT', 0, -8)

	local periodic = ns.CreateCheckBox(Combat, 'fct_periodic')
	periodic:SetPoint('LEFT', pet, 'RIGHT', 160, 0)

	local merge = ns.CreateCheckBox(Combat, 'fct_merge')
	merge:SetPoint('TOPLEFT', pet, 'BOTTOMLEFT', 0, -8)

	local pvp = ns.AddSubCategory(Combat, ns.localization.combat.sub_pvp)
	pvp:SetPoint('TOPLEFT', merge, 'BOTTOMLEFT', 0, -16)

	local autoTab = ns.CreateCheckBox(Combat, 'auto_tab')
	autoTab:SetPoint('TOPLEFT', pvp, 'BOTTOMLEFT', 0, -8)

	local PVPSound = ns.CreateCheckBox(Combat, 'pvp_sound')
	PVPSound:SetPoint('LEFT', autoTab, 'RIGHT', 160, 0)

	local adjustment = ns.AddSubCategory(Combat, ns.localization.combat.sub_adjustment)
	adjustment:SetPoint('TOPLEFT', autoTab, 'BOTTOMLEFT', 0, -16)

	local threshold = ns.CreateNumberSlider(Combat, 'health_alert_threshold', 0.2, 0.6, 0.2, 0.6, 0.1, true)
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


local function addCooldownOptions()
	local Cooldown = FreeUIOptionsFrame.Cooldown
	Cooldown.tab.icon:SetTexture('Interface\\ICONS\\Spell_Nature_TimeStop')

	local basic = ns.AddSubCategory(Cooldown, ns.localization.cooldown.sub_basic)
	basic:SetPoint('TOPLEFT', Cooldown.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Cooldown, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local decimal = ns.CreateCheckBox(Cooldown, 'decimal')
	decimal:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local excludeWA = ns.CreateCheckBox(Cooldown, 'excludeWA')
	excludeWA:SetPoint('LEFT', decimal, 'RIGHT', 160, 0)

	local pulse = ns.CreateCheckBox(Cooldown, 'pulse')
	pulse:SetPoint('TOPLEFT', decimal, 'BOTTOMLEFT', 0, -8)

	local adjustment = ns.AddSubCategory(Cooldown, ns.localization.cooldown.sub_adjustment)
	adjustment:SetPoint('TOPLEFT', pulse, 'BOTTOMLEFT', 0, -16)

	local decimalCount = ns.CreateNumberSlider(Cooldown, 'decimalCount', 1, 10, 10, 10, 1, true)
	decimalCount:SetPoint('TOPLEFT', adjustment, 'BOTTOMLEFT', 16, -32)


	local function toggleCooldownOptions()
		local shown = enable:GetChecked()
		decimal:SetShown(shown)
		excludeWA:SetShown(shown)
		pulse:SetShown(shown)
		decimalCount:SetShown(shown)
		adjustment:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleCooldownOptions)
	Cooldown:HookScript('OnShow', toggleCooldownOptions)
end


local function addActionbarOptions()
	local Actionbar = FreeUIOptionsFrame.Actionbar
	Actionbar.tab.icon:SetTexture('Interface\\ICONS\\Spell_Holy_SearingLightPriest')

	local basic = ns.AddSubCategory(Actionbar, ns.localization.actionbar.sub_basic)
	basic:SetPoint('TOPLEFT', Actionbar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Actionbar, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local hotkey = ns.CreateCheckBox(Actionbar, 'button_hotkey')
	hotkey:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local macro = ns.CreateCheckBox(Actionbar, 'button_macro_name')
	macro:SetPoint('LEFT', hotkey, 'RIGHT', 160, 0)

	local count = ns.CreateCheckBox(Actionbar, 'button_count')
	count:SetPoint('TOPLEFT', hotkey, 'BOTTOMLEFT', 0, -8)

	local class = ns.CreateCheckBox(Actionbar, 'button_class_color')
	class:SetPoint('LEFT', count, 'RIGHT', 160, 0)

	local range = ns.CreateCheckBox(Actionbar, 'button_range')
	range:SetPoint('TOPLEFT', count, 'BOTTOMLEFT', 0, -8)

	local extend = ns.CreateCheckBox(Actionbar, 'bar3_divide')
	extend:SetPoint('LEFT', range, 'RIGHT', 160, 0)

	local extra = ns.AddSubCategory(Actionbar, ns.localization.actionbar.sub_extra)
	extra:SetPoint('TOPLEFT', range, 'BOTTOMLEFT', 0, -16)

	local bar1 = ns.CreateCheckBox(Actionbar, 'bar1')
	bar1:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local bar1Fade = ns.CreateCheckBox(Actionbar, 'bar1_fade')
	bar1Fade:SetPoint('LEFT', bar1, 'RIGHT', 160, 0)

	bar1.children = {bar1Fade}

	local bar2 = ns.CreateCheckBox(Actionbar, 'bar2')
	bar2:SetPoint('TOPLEFT', bar1, 'BOTTOMLEFT', 0, -8)

	local bar2Fade = ns.CreateCheckBox(Actionbar, 'bar2_fade')
	bar2Fade:SetPoint('LEFT', bar2, 'RIGHT', 160, 0)

	bar2.children = {bar2Fade}

	local bar3 = ns.CreateCheckBox(Actionbar, 'bar3')
	bar3:SetPoint('TOPLEFT', bar2, 'BOTTOMLEFT', 0, -8)

	local bar3Fade = ns.CreateCheckBox(Actionbar, 'bar3_fade')
	bar3Fade:SetPoint('LEFT', bar3, 'RIGHT', 160, 0)

	bar3.children = {bar3Fade}

	local bar4 = ns.CreateCheckBox(Actionbar, 'bar4')
	bar4:SetPoint('TOPLEFT', bar3, 'BOTTOMLEFT', 0, -8)

	local bar4Fade = ns.CreateCheckBox(Actionbar, 'bar4_fade')
	bar4Fade:SetPoint('LEFT', bar4, 'RIGHT', 160, 0)

	bar4.children = {bar4Fade}

	local bar5 = ns.CreateCheckBox(Actionbar, 'bar5')
	bar5:SetPoint('TOPLEFT', bar4, 'BOTTOMLEFT', 0, -8)

	local bar5Fade = ns.CreateCheckBox(Actionbar, 'bar5_fade')
	bar5Fade:SetPoint('LEFT', bar5, 'RIGHT', 160, 0)

	bar5.children = {bar5Fade}

	local petBar = ns.CreateCheckBox(Actionbar, 'pet_bar')
	petBar:SetPoint('TOPLEFT', bar5, 'BOTTOMLEFT', 0, -8)

	local petBarFade = ns.CreateCheckBox(Actionbar, 'pet_bar_fade')
	petBarFade:SetPoint('LEFT', petBar, 'RIGHT', 160, 0)

	petBar.children = {petBarFade}

	local size = ns.AddSubCategory(Actionbar, ns.localization.actionbar.sub_adjustment)
	size:SetPoint('TOPLEFT', petBar, 'BOTTOMLEFT', 0, -16)

	local buttonSizeNormal = ns.CreateNumberSlider(Actionbar, 'button_size_normal', 20, 50, 20, 50, 1, true)
	buttonSizeNormal:SetPoint('TOPLEFT', size, 'BOTTOMLEFT', 16, -32)

	local buttonSizeSmall = ns.CreateNumberSlider(Actionbar, 'button_size_small', 20, 50, 20, 50, 1, true)
	buttonSizeSmall:SetPoint('LEFT', buttonSizeNormal, 'RIGHT', 60, 0)

	local buttonSizeBig = ns.CreateNumberSlider(Actionbar, 'button_size_big', 20, 50, 20, 50, 1, true)
	buttonSizeBig:SetPoint('TOPLEFT', buttonSizeNormal, 'BOTTOMLEFT', 0, -64)

	local function toggleActionbarOptions()
		local shown = enable:GetChecked()
		hotkey:SetShown(shown)
		macro:SetShown(shown)
		count:SetShown(shown)
		class:SetShown(shown)
		range:SetShown(shown)
		extend:SetShown(shown)
		bar1:SetShown(shown)
		bar1Fade:SetShown(shown)
		bar2:SetShown(shown)
		bar2Fade:SetShown(shown)
		bar3:SetShown(shown)
		bar3Fade:SetShown(shown)
		bar4:SetShown(shown)
		bar4Fade:SetShown(shown)
		bar5:SetShown(shown)
		bar5Fade:SetShown(shown)
		petBar:SetShown(shown)
		petBarFade:SetShown(shown)
		buttonSizeNormal:SetShown(shown)
		buttonSizeSmall:SetShown(shown)
		buttonSizeBig:SetShown(shown)
		size:SetShown(shown)
		extra:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleActionbarOptions)
	Actionbar:HookScript('OnShow', toggleActionbarOptions)
end


local function addAnnouncementOptions()
	local Announcement = FreeUIOptionsFrame.Announcement
	Announcement.tab.icon:SetTexture('Interface\\ICONS\\Ability_Warrior_RallyingCry')

	local basic = ns.AddSubCategory(Announcement, ns.localization.announcement.sub_basic)
	basic:SetPoint('TOPLEFT', Announcement.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Announcement, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local feast = ns.CreateCheckBox(Announcement, 'feast_cauldron')
	feast:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local bot = ns.CreateCheckBox(Announcement, 'bot_codex')
	bot:SetPoint('LEFT', feast, 'RIGHT', 160, 0)

	local refreshment = ns.CreateCheckBox(Announcement, 'conjure_refreshment')
	refreshment:SetPoint('TOPLEFT', feast, 'BOTTOMLEFT', 0, -8)

	local soulwell = ns.CreateCheckBox(Announcement, 'create_soulwell')
	soulwell:SetPoint('LEFT', refreshment, 'RIGHT', 160, 0)

	local summoning = ns.CreateCheckBox(Announcement, 'ritual_of_summoning')
	summoning:SetPoint('TOPLEFT', refreshment, 'BOTTOMLEFT', 0, -8)

	local portal = ns.CreateCheckBox(Announcement, 'mage_portal')
	portal:SetPoint('LEFT', summoning, 'RIGHT', 160, 0)

	local mail = ns.CreateCheckBox(Announcement, 'mail_service')
	mail:SetPoint('TOPLEFT', summoning, 'BOTTOMLEFT', 0, -8)

	local toy = ns.CreateCheckBox(Announcement, 'special_toy')
	toy:SetPoint('LEFT', mail, 'RIGHT', 160, 0)

	local combat = ns.AddSubCategory(Announcement, ns.localization.announcement.sub_combat)
	combat:SetPoint('TOPLEFT', mail, 'BOTTOMLEFT', 0, -16)

	local interrupt = ns.CreateCheckBox(Announcement, 'my_interrupt')
	interrupt:SetPoint('TOPLEFT', combat, 'BOTTOMLEFT', 0, -8)

	local dispel = ns.CreateCheckBox(Announcement, 'my_dispel')
	dispel:SetPoint('LEFT', interrupt, 'RIGHT', 160, 0)

	local rez = ns.CreateCheckBox(Announcement, 'combat_rez')
	rez:SetPoint('TOPLEFT', interrupt, 'BOTTOMLEFT', 0, -8)

	local sapped = ns.CreateCheckBox(Announcement, 'get_sapped')
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


local function addUnitframeOptions()
	local Unitframe = FreeUIOptionsFrame.Unitframe
	Unitframe.tab.icon:SetTexture('Interface\\ICONS\\Ability_Mage_MassInvisibility')

	local basic = ns.AddSubCategory(Unitframe, ns.localization.unitframe.sub_basic)
	basic:SetPoint('TOPLEFT', Unitframe.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Unitframe, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)



	local texture = ns.CreateDropDown(Unitframe, 'texture', true, ns.textureList, true)
	texture:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 00, -30)

	--[[ local healer = ns.CreateCheckBox(Unitframe, 'healer')
	healer:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 16, -8)

	local transMode = ns.CreateCheckBox(Unitframe, 'transMode')
	transMode:SetPoint('LEFT', healer, 'RIGHT', 160, 0)

	local colourSmooth = ns.CreateCheckBox(Unitframe, 'colourSmooth')
	colourSmooth:SetPoint('TOPLEFT', healer, 'BOTTOMLEFT', 0, -8)

	local portrait = ns.CreateCheckBox(Unitframe, 'portrait')
	portrait:SetPoint('LEFT', colourSmooth, 'RIGHT', 160, 0)

	local frameVisibility = ns.CreateCheckBox(Unitframe, 'frameVisibility')
	frameVisibility:SetPoint('TOPLEFT', colourSmooth, 'BOTTOMLEFT', 0, -8)

	local feature = ns.AddSubCategory(Unitframe, ns.localization.unitframe.sub_feature)
	feature:SetPoint('TOPLEFT', frameVisibility, 'BOTTOMLEFT', -16, -16)

	local dispellable = ns.CreateCheckBox(Unitframe, 'dispellable')
	dispellable:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local rangeCheck = ns.CreateCheckBox(Unitframe, 'rangeCheck')
	rangeCheck:SetPoint('LEFT', dispellable, 'RIGHT', 160, 0)

	local comboPoints = ns.CreateCheckBox(Unitframe, 'comboPoints')
	comboPoints:SetPoint('TOPLEFT', dispellable, 'BOTTOMLEFT', 0, -8)

	local energyTicker = ns.CreateCheckBox(Unitframe, 'energyTicker')
	energyTicker:SetPoint('LEFT', comboPoints, 'RIGHT', 160, 0)

	local clickCast = ns.CreateCheckBox(Unitframe, 'clickCast')
	clickCast:SetPoint('TOPLEFT', comboPoints, 'BOTTOMLEFT', 0, -8)

	local onlyShowPlayer = ns.CreateCheckBox(Unitframe, 'onlyShowPlayer')
	onlyShowPlayer:SetPoint('LEFT', clickCast, 'RIGHT', 160, 0)

	local adjustClassColors = ns.CreateCheckBox(Unitframe, 'adjustClassColors')
	adjustClassColors:SetPoint('TOPLEFT', clickCast, 'BOTTOMLEFT', 0, -8)

	local castbar = ns.AddSubCategory(Unitframe, ns.localization.unitframe.sub_basic)
	castbar:SetPoint('TOPLEFT', adjustClassColors, 'BOTTOMLEFT', 0, -16)

	local enableCastbar = ns.CreateCheckBox(Unitframe, 'enableCastbar')
	enableCastbar:SetPoint('TOPLEFT', castbar, 'BOTTOMLEFT', 0, -8)

	local castbar_separatePlayer = ns.CreateCheckBox(Unitframe, 'castbar_separatePlayer')
	castbar_separatePlayer:SetPoint('TOPLEFT', enableCastbar, 'BOTTOMLEFT', 16, -8)

	enableCastbar.children = {castbar_separatePlayer}

	local extra = ns.AddSubCategory(Unitframe, ns.localization.unitframe.sub_basic)
	extra:SetPoint('TOPLEFT', castbar_separatePlayer, 'BOTTOMLEFT', -16, -16)

	local enableGroup = ns.CreateCheckBox(Unitframe, 'enableGroup')
	enableGroup:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local groupNames = ns.CreateCheckBox(Unitframe, 'groupNames')
	groupNames:SetPoint('TOPLEFT', enableGroup, 'BOTTOMLEFT', 16, -8)

	local groupColourSmooth = ns.CreateCheckBox(Unitframe, 'groupColourSmooth')
	groupColourSmooth:SetPoint('LEFT', groupNames, 'RIGHT', 160, 0)

	local groupFilter = ns.CreateNumberSlider(Unitframe, 'groupFilter', 4, 8, 4, 8, 1, true)
	groupFilter:SetPoint('TOPLEFT', groupNames, 'BOTTOMLEFT', 0, -30)

	local function toggleUFOptions()
		local shown = enable:GetChecked()
		feature:SetShown(shown)
		extra:SetShown(shown)
		castbar:SetShown(shown)

		transMode:SetShown(shown)
		portrait:SetShown(shown)
		healer:SetShown(shown)
		colourSmooth:SetShown(shown)
		frameVisibility:SetShown(shown)

		enableGroup:SetShown(shown)
		groupNames:SetShown(shown)
		groupColourSmooth:SetShown(shown)
		groupFilter:SetShown(shown)

		dispellable:SetShown(shown)
		rangeCheck:SetShown(shown)
		energyTicker:SetShown(shown)
		onlyShowPlayer:SetShown(shown)
		clickCast:SetShown(shown)
		comboPoints:SetShown(shown)
		adjustClassColors:SetShown(shown)
		
		enableCastbar:SetShown(shown)
		castbar_separatePlayer:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleUFOptions)
	Unitframe:HookScript('OnShow', toggleUFOptions)

	local function toggleGroupOptions()
		local shown = enableGroup:GetChecked()
		groupNames:SetShown(shown)
		groupColourSmooth:SetShown(shown)
		groupFilter:SetShown(shown)
	end

	enableGroup:HookScript('OnClick', toggleGroupOptions)
	Unitframe:HookScript('OnShow', toggleGroupOptions) ]]
end


local function addThemeOptions()
	local Theme = FreeUIOptionsFrame.Theme
	Theme.tab.icon:SetTexture('Interface\\ICONS\\Ability_Hunter_BeastWithin')

	local basic = ns.AddSubCategory(Theme, ns.localization.theme.sub_basic)
	basic:SetPoint('TOPLEFT', Theme.subText, 'BOTTOMLEFT', 0, -8)

	local cursorTrail = ns.CreateCheckBox(Theme, 'cursor_trail')
	cursorTrail:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local vignetting = ns.CreateCheckBox(Theme, 'vignetting')
	vignetting:SetPoint('LEFT', cursorTrail, 'RIGHT', 160, 0)

	local reskinBlizz = ns.CreateCheckBox(Theme, 'reskin_blizz')
	reskinBlizz:SetPoint('TOPLEFT', cursorTrail, 'BOTTOMLEFT', 0, -8)

	local flatStyle = ns.CreateCheckBox(Theme, 'flat_style')
	flatStyle:SetPoint('LEFT', reskinBlizz, 'RIGHT', 160, 0)

	local shadowBorder = ns.CreateCheckBox(Theme, 'shadow_border')
	shadowBorder:SetPoint('TOPLEFT', reskinBlizz, 'BOTTOMLEFT', 0, -8)

	local addons = ns.AddSubCategory(Theme, ns.localization.theme.sub_addons)
	addons:SetPoint('TOPLEFT', shadowBorder, 'BOTTOMLEFT', 0, -16)

	local DBM = ns.CreateCheckBox(Theme, 'reskin_dbm')
	DBM:SetPoint('TOPLEFT', addons, 'BOTTOMLEFT', 0, -8)

	local WeakAuras = ns.CreateCheckBox(Theme, 'reskin_weakauras')
	WeakAuras:SetPoint('LEFT', DBM, 'RIGHT', 160, 0)

	local Skada = ns.CreateCheckBox(Theme, 'reskin_skada')
	Skada:SetPoint('TOPLEFT', DBM, 'BOTTOMLEFT', 0, -8)

	local PGF = ns.CreateCheckBox(Theme, 'reskin_pgf')
	PGF:SetPoint('LEFT', Skada, 'RIGHT', 160, 0)

	local adjustment = ns.AddSubCategory(Theme, ns.localization.theme.sub_adjustment)
	adjustment:SetPoint('TOPLEFT', Skada, 'BOTTOMLEFT', 0, -16)

	local backdropColor = ns.CreateColourPicker(Theme, 'backdrop_color', true)
	backdropColor:SetPoint('TOPLEFT', adjustment, 'BOTTOMLEFT', 16, -32)

	local backdropAlpha = ns.CreateNumberSlider(Theme, 'backdrop_alpha', 0.1, 1, 0.1, 1, 0.01, true)
	backdropAlpha:SetPoint('LEFT', backdropColor, 'RIGHT', 160, 0)

	local backdropBorderColor = ns.CreateColourPicker(Theme, 'backdrop_border_color', true)
	backdropBorderColor:SetPoint('TOPLEFT', backdropColor, 'BOTTOMLEFT', 0, -52)

	local backdropBorderAlpha = ns.CreateNumberSlider(Theme, 'backdrop_border_alpha', 0.1, 1, 0.1, 1, 0.01, true)
	backdropBorderAlpha:SetPoint('LEFT', backdropBorderColor, 'RIGHT', 160, 0)

	local flatColor = ns.CreateColourPicker(Theme, 'flat_color', true)
	flatColor:SetPoint('TOPLEFT', backdropBorderColor, 'BOTTOMLEFT', 0, -52)

	local flatAlpha = ns.CreateNumberSlider(Theme, 'flat_alpha', 0.1, 1, 0.1, 1, 0.01, true)
	flatAlpha:SetPoint('LEFT', flatColor, 'RIGHT', 160, 0)
end


local function addInfobarOptions()
	local Infobar = FreeUIOptionsFrame.Infobar
	Infobar.tab.icon:SetTexture('Interface\\ICONS\\Ability_Priest_Ascension')

	local basic = ns.AddSubCategory(Infobar, ns.localization.infobar.sub_basic)
	basic:SetPoint('TOPLEFT', Infobar.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Infobar, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local mouseover = ns.CreateCheckBox(Infobar, 'mouseover')
	mouseover:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local stats = ns.CreateCheckBox(Infobar, 'stats')
	stats:SetPoint('LEFT', mouseover, 'RIGHT', 160, 0)

	local friends = ns.CreateCheckBox(Infobar, 'friends')
	friends:SetPoint('TOPLEFT', mouseover, 'BOTTOMLEFT', 0, -8)

	local guild = ns.CreateCheckBox(Infobar, 'guild')
	guild:SetPoint('LEFT', friends, 'RIGHT', 160, 0)

	local durability = ns.CreateCheckBox(Infobar, 'durability')
	durability:SetPoint('TOPLEFT', friends, 'BOTTOMLEFT', 0, -8)

	local spec = ns.CreateCheckBox(Infobar, 'spec')
	spec:SetPoint('LEFT', durability, 'RIGHT', 160, 0)

	local report = ns.CreateCheckBox(Infobar, 'report')
	report:SetPoint('TOPLEFT', durability, 'BOTTOMLEFT', 0, -8)

	local adjustment = ns.AddSubCategory(Infobar, ns.localization.infobar.sub_adjustment)
	adjustment:SetPoint('TOPLEFT', report, 'BOTTOMLEFT', 0, -16)

	local height = ns.CreateNumberSlider(Infobar, 'height', 10, 20, 10, 20, 1, true)
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


local function addChatOptions()
	local Chat = FreeUIOptionsFrame.Chat
	Chat.tab.icon:SetTexture('Interface\\ICONS\\Spell_Shadow_Seduction')

	local basic = ns.AddSubCategory(Chat, ns.localization.chat.sub_basic)
	basic:SetPoint('TOPLEFT', Chat.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Chat, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local lock = ns.CreateCheckBox(Chat, 'lock')
	lock:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local fading = ns.CreateCheckBox(Chat, 'fading')
	fading:SetPoint('LEFT', lock, 'RIGHT', 160, 0)

	local outline = ns.CreateCheckBox(Chat, 'outline')
	outline:SetPoint('TOPLEFT', lock, 'BOTTOMLEFT', 0, -8)

	local voiceIcon = ns.CreateCheckBox(Chat, 'voiceIcon')
	voiceIcon:SetPoint('LEFT', outline, 'RIGHT', 160, 0)

	local feature = ns.AddSubCategory(Chat, ns.localization.chat.sub_feature)
	feature:SetPoint('TOPLEFT', outline, 'BOTTOMLEFT', 0, -16)

	local abbreviate = ns.CreateCheckBox(Chat, 'abbreviate')
	abbreviate:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local cycles = ns.CreateCheckBox(Chat, 'cycles')
	cycles:SetPoint('LEFT', abbreviate, 'RIGHT', 160, 0)

	local itemLinks = ns.CreateCheckBox(Chat, 'itemLinks')
	itemLinks:SetPoint('TOPLEFT', abbreviate, 'BOTTOMLEFT', 0, -8)

	local spamageMeter = ns.CreateCheckBox(Chat, 'spamageMeter')
	spamageMeter:SetPoint('LEFT', itemLinks, 'RIGHT', 160, 0)

	local sticky = ns.CreateCheckBox(Chat, 'sticky')
	sticky:SetPoint('TOPLEFT', itemLinks, 'BOTTOMLEFT', 0, -8)

	local whisperAlert = ns.CreateCheckBox(Chat, 'whisperAlert')
	whisperAlert:SetPoint('LEFT', sticky, 'RIGHT', 160, 0)

	local chatCopy = ns.CreateCheckBox(Chat, 'chatCopy')
	chatCopy:SetPoint('TOPLEFT', sticky, 'BOTTOMLEFT', 0, -8)

	local urlCopy = ns.CreateCheckBox(Chat, 'urlCopy')
	urlCopy:SetPoint('LEFT', chatCopy, 'RIGHT', 160, 0)

	local bubble = ns.CreateCheckBox(Chat, 'auto_toggle_chat_bubble')
	bubble:SetPoint('TOPLEFT', chatCopy, 'BOTTOMLEFT', 0, -8)

	local filter = ns.AddSubCategory(Chat, ns.localization.chat.sub_filter)
	filter:SetPoint('TOPLEFT', bubble, 'BOTTOMLEFT', 0, -16)

	local chatFilter = ns.CreateCheckBox(Chat, 'filters')
	chatFilter:SetPoint('TOPLEFT', filter, 'BOTTOMLEFT', 0, -8)

	local blockAddonSpam = ns.CreateCheckBox(Chat, 'blockAddonSpam')
	blockAddonSpam:SetPoint('LEFT', chatFilter, 'RIGHT', 160, 0)

	local blockStranger = ns.CreateCheckBox(Chat, 'blockStranger')
	blockStranger:SetPoint('TOPLEFT', chatFilter, 'BOTTOMLEFT', 0, -8)

	local allowFriendsSpam = ns.CreateCheckBox(Chat, 'allowFriendsSpam')
	allowFriendsSpam:SetPoint('LEFT', blockStranger, 'RIGHT', 160, 0)

	local profanity = ns.CreateCheckBox(Chat, 'profanity')
	profanity:SetPoint('TOPLEFT', blockStranger, 'BOTTOMLEFT', 0, -8)

	local invite_keyword = ns.CreateEditBox(Chat, 'keywordsList', true)
	invite_keyword:SetPoint('TOPLEFT', profanity, 'BOTTOMLEFT', 6, -8)


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
	Chat:HookScript('OnShow', toggleChatOptions)
end 


local function addNotificationOptions()
	local Notification = FreeUIOptionsFrame.Notification
	Notification.tab.icon:SetTexture('Interface\\ICONS\\Ability_Warrior_Revenge')

	local basic = ns.AddSubCategory(Notification, ns.localization.notification.sub_basic)
	basic:SetPoint('TOPLEFT', Notification.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Notification, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local bagFull = ns.CreateCheckBox(Notification, 'bag_full')
	bagFull:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local newMail = ns.CreateCheckBox(Notification, 'new_mail')
	newMail:SetPoint('LEFT', bagFull, 'RIGHT', 160, 0)

	local versionCheck = ns.CreateCheckBox(Notification, 'version_check')
	versionCheck:SetPoint('TOPLEFT', bagFull, 'BOTTOMLEFT', 0, -8)


	local function toggleNotificationOptions()
		local shown = enable:GetChecked()
		bagFull:SetShown(shown)
		newMail:SetShown(shown)
		versionCheck:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleNotificationOptions)
	Notification:HookScript('OnShow', toggleNotificationOptions)
end


local function addAutomationOptions()
	local Automation = FreeUIOptionsFrame.Automation
	Automation.tab.icon:SetTexture('Interface\\ICONS\\Ability_Siege_Engineer_Magnetic_Crush')

	local basic = ns.AddSubCategory(Automation, ns.localization.automation.sub_basic)
	basic:SetPoint('TOPLEFT', Automation.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Automation, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local screen = ns.CreateCheckBox(Automation, 'auto_screenshot')
	screen:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local buyStack = ns.CreateCheckBox(Automation, 'easy_buy_stack')
	buyStack:SetPoint('LEFT', screen, 'RIGHT', 160, 0)


	local invite_keyword = ns.CreateEditBox(Automation, 'invite_keyword', true)
	invite_keyword:SetPoint('TOPLEFT', screen, 'BOTTOMLEFT', 6, -8)


	local function toggleAutomationOptions()
		local shown = enable:GetChecked()

		buyStack:SetShown(shown)

		screen:SetShown(shown)


	end

	enable:HookScript('OnClick', toggleAutomationOptions)
	Automation:HookScript('OnShow', toggleAutomationOptions)
end


local function addMapOptions()
	local Map = FreeUIOptionsFrame.Map
	Map.tab.icon:SetTexture('Interface\\ICONS\\Achievement_Ashran_Tourofduty')

	local basic = ns.AddSubCategory(Map, ns.localization.map.sub_basic)
	basic:SetPoint('TOPLEFT', Map.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Map, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local coords = ns.CreateCheckBox(Map, 'coords')
	coords:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local miniMap = ns.AddSubCategory(Map, ns.localization.map.sub_minimap)
	miniMap:SetPoint('TOPLEFT', coords, 'BOTTOMLEFT', 0, -16)

	local whoPings = ns.CreateCheckBox(Map, 'whoPings')
	whoPings:SetPoint('TOPLEFT', miniMap, 'BOTTOMLEFT', 0, -8)

	local microMenu = ns.CreateCheckBox(Map, 'microMenu')
	microMenu:SetPoint('LEFT', whoPings, 'RIGHT', 160, 0)

	local expBar = ns.CreateCheckBox(Map, 'expBar')
	expBar:SetPoint('TOPLEFT', whoPings, 'BOTTOMLEFT', 0, -8)

	local adjustment = ns.AddSubCategory(Map, ns.localization.map.sub_adjustment)
	adjustment:SetPoint('TOPLEFT', expBar, 'BOTTOMLEFT', 0, -16)

	local minimapScale = ns.CreateNumberSlider(Map, 'minimapScale', 0.5, 1, 0.5, 1, 0.1, true)
	minimapScale:SetPoint('TOPLEFT', adjustment, 'BOTTOMLEFT', 16, -32)


	local function toggleMapOptions()
		local shown = enable:GetChecked()
		coords:SetShown(shown)
		whoPings:SetShown(shown)
		expBar:SetShown(shown)
		microMenu:SetShown(shown)
		minimapScale:SetShown(shown)
		miniMap:SetShown(shown)
		adjustment:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleMapOptions)
	Map:HookScript('OnShow', toggleMapOptions)
end


local function addQuestOptions()
	local Quest = FreeUIOptionsFrame.Quest
	Quest.tab.icon:SetTexture('Interface\\ICONS\\ABILITY_Rogue_RollTheBones04')

	local basic = ns.AddSubCategory(Quest, ns.localization.quest.sub_basic)
	basic:SetPoint('TOPLEFT', Quest.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Quest, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local questLevel = ns.CreateCheckBox(Quest, 'questLevel')
	questLevel:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local rewardHightlight = ns.CreateCheckBox(Quest, 'rewardHightlight')
	rewardHightlight:SetPoint('LEFT', questLevel, 'RIGHT', 160, 0)

	local completeRing = ns.CreateCheckBox(Quest, 'completeRing')
	completeRing:SetPoint('TOPLEFT', questLevel, 'BOTTOMLEFT', 0, -8)

	local questNotifier = ns.CreateCheckBox(Quest, 'questNotifier')
	questNotifier:SetPoint('LEFT', completeRing, 'RIGHT', 160, 0)

	local extraQuestButton = ns.CreateCheckBox(Quest, 'extraQuestButton')
	extraQuestButton:SetPoint('TOPLEFT', completeRing, 'BOTTOMLEFT', 0, -8)


	local function toggleQuestOptions()
		local shown = enable:GetChecked()
		questLevel:SetShown(shown)
		rewardHightlight:SetShown(shown)
		completeRing:SetShown(shown)
		questNotifier:SetShown(shown)
		extraQuestButton:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleQuestOptions)
	Quest:HookScript('OnShow', toggleQuestOptions)
end


local function addTooltipOptions()
	local Tooltip = FreeUIOptionsFrame.Tooltip
	Tooltip.tab.icon:SetTexture('Interface\\ICONS\\INV_Misc_ScrollUnrolled03d')

	local basic = ns.AddSubCategory(Tooltip, ns.localization.tooltip.sub_basic)
	basic:SetPoint('TOPLEFT', Tooltip.subText, 'BOTTOMLEFT', 0, -8)

	local enable = ns.CreateCheckBox(Tooltip, 'enable')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local cursor = ns.CreateCheckBox(Tooltip, 'follow_cursor')
	cursor:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local combatHide = ns.CreateCheckBox(Tooltip, 'hide_in_combat')
	combatHide:SetPoint('LEFT', cursor, 'RIGHT', 160, 0)

	local tipIcon = ns.CreateCheckBox(Tooltip, 'icon')
	tipIcon:SetPoint('TOPLEFT', cursor, 'BOTTOMLEFT', 0, -8)

	local borderColor = ns.CreateCheckBox(Tooltip, 'border_color')
	borderColor:SetPoint('LEFT', tipIcon, 'RIGHT', 160, 0)

	local hideTitle = ns.CreateCheckBox(Tooltip, 'hide_title')
	hideTitle:SetPoint('TOPLEFT', tipIcon, 'BOTTOMLEFT', 0, -8)

	local hideRealm = ns.CreateCheckBox(Tooltip, 'hide_realm')
	hideRealm:SetPoint('LEFT', hideTitle, 'RIGHT', 160, 0)

	local hideRank = ns.CreateCheckBox(Tooltip, 'hide_rank')
	hideRank:SetPoint('TOPLEFT', hideTitle, 'BOTTOMLEFT', 0, -8)

	local targetBy = ns.CreateCheckBox(Tooltip, 'target_by')
	targetBy:SetPoint('LEFT', hideRank, 'RIGHT', 160, 0)

	local linkHover = ns.CreateCheckBox(Tooltip, 'link_hover')
	linkHover:SetPoint('TOPLEFT', hideRank, 'BOTTOMLEFT', 0, -8)

	local extraInfo = ns.CreateCheckBox(Tooltip, 'extra_info')
	extraInfo:SetPoint('LEFT', linkHover, 'RIGHT', 160, 0)

	local auraSource = ns.CreateCheckBox(Tooltip, 'aura_source')
	auraSource:SetPoint('TOPLEFT', linkHover, 'BOTTOMLEFT', 0, -8)

	local mountSource = ns.CreateCheckBox(Tooltip, 'mount_source')
	mountSource:SetPoint('LEFT', auraSource, 'RIGHT', 160, 0)

	local spec = ns.CreateCheckBox(Tooltip, 'spec_ilvl')
	spec:SetPoint('TOPLEFT', auraSource, 'BOTTOMLEFT', 0, -8)

	local azerite = ns.CreateCheckBox(Tooltip, 'azerite_trait')
	azerite:SetPoint('LEFT', spec, 'RIGHT', 160, 0)

	local pet = ns.CreateCheckBox(Tooltip, 'pet_info')
	pet:SetPoint('TOPLEFT', spec, 'BOTTOMLEFT', 0, -8)


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
		pet:SetShown(shown)
		auraSource:SetShown(shown)
		mountSource:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleTooltipOptions)
	Tooltip:HookScript('OnShow', toggleTooltipOptions)
end


ns.AddAllOptions = function()
	addGeneralOptions()
	addThemeOptions()
	addNotificationOptions()
	addAnnouncementOptions()
	addAutomationOptions()
	addInfobarOptions()
	addChatOptions()
	addAuraOptions()
	addActionbarOptions()
	addCooldownOptions()
	addCombatOptions()
	addInventoryOptions()
	addMapOptions()
	addQuestOptions()
	addTooltipOptions()
	addUnitframeOptions()
end

