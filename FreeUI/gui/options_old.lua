local F, C, L = unpack(select(2, ...))
local GUI = F.GUI


--[[ callback ]]

local function UpdateBagStatus()
	F.INVENTORY:UpdateAllBags()
end

local function UpdateMinimapScale()
	F.MAP:UpdateMinimapScale()
end

local function UpdateQuestTrackerScale()
	F.QUEST:UpdateTrackerScale()
end

local function UpdateNameplateCustomUnitList()
	F.NAMEPLATE:CreateUnitTable()
end

local function RefreshNameplates()
	F.NAMEPLATE:RefreshAllPlates()
end

local function UpdateNameplateCVars()
	F.NAMEPLATE:PlateInsideView()
	F.NAMEPLATE:UpdatePlateScale()
	F.NAMEPLATE:UpdatePlateTargetScale()
	F.NAMEPLATE:UpdatePlateAlpha()
	F.NAMEPLATE:UpdatePlateOccludedAlpha()
	F.NAMEPLATE:UpdatePlateDistance()
	F.NAMEPLATE:UpdatePlateVerticalSpacing()
	F.NAMEPLATE:UpdatePlateHorizontalSpacing()
end


--[[ side panel ]]

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

local function SetupChatFading()
	GUI:ToggleSidePanel('chatFadingSide')
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

local function SetupBar1Fade()
	GUI:ToggleSidePanel('bar1FadeSide')
end

local function SetupBar2Fade()
	GUI:ToggleSidePanel('bar2FadeSide')
end

local function SetupBar3Fade()
	GUI:ToggleSidePanel('bar3FadeSide')
end

local function SetupBar4Fade()
	GUI:ToggleSidePanel('bar4FadeSide')
end

local function SetupBar5Fade()
	GUI:ToggleSidePanel('bar5FadeSide')
end

local function SetupPetBarFade()
	GUI:ToggleSidePanel('petBarFadeSide')
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

local function SetupClassPower()
	GUI:ToggleSidePanel('classPowerSide')
end

local function SetupAltPower()
	GUI:ToggleSidePanel('altPowerSide')
end

local function SetupPower()
	GUI:ToggleSidePanel('powerSide')
end

local function SetupClassColor()
	GUI:ToggleSidePanel('classColorSide')
end

local function SetupCombatFader()
	GUI:ToggleSidePanel('combatFaderSide')
end

-- plate
local function SetupPlateSize()
	GUI:ToggleSidePanel('plateSizeSide')
end

local function SetupPlateAura()
	GUI:ToggleSidePanel('FreeUI_SetupPlateAura')
end

local function SetupThreatColors()
	GUI:ToggleSidePanel('threatColorsSide')
end

local function SetupCustomPlate()
	GUI:ToggleSidePanel('customPlateSide')
end

-- combat
local function SetupHealthThreshold()
	GUI:ToggleSidePanel('healthThresholdSide')
end

local function SetupFCT()
	GUI:ToggleSidePanel('fctSide')
end

local function SetupAnnouncement()
	GUI:ToggleSidePanel('announcementSide')
end

-- map
local function SetupMapScale()
	GUI:ToggleSidePanel('mapScaleSide')
end

-- infobar
local function SetupInfoBarHeight()
	GUI:ToggleSidePanel('infoBarHeightSide')
end

-- quest
local function SetupQuestTracker()
	GUI:ToggleSidePanel('trackerScaleSide')
end


--[[  ]]

local function sortBars(barTable)
	local num = 1
	for _, bar in pairs(barTable) do
		if num == 1 then
			bar:SetPoint('TOPLEFT', 2, -4)
		else
			bar:SetPoint('TOPLEFT', 2, -4 - (25 * (num - 1)))
		end
		num = num + 1
	end
end

local function CreateNamePlateAuraFilter(parent)
	local plateAuraSide = GUI:CreateSidePanel(parent, 'FreeUI_SetupPlateAura')

	local auraSize = GUI:CreateSlider(plateAuraSide, 'nameplate', 'aura_size', RefreshNameplates, {16, 30, 1})
	auraSize:SetPoint('TOP', plateAuraSide.child, 'TOP', 0, -24)

	local auraNumber = GUI:CreateSlider(plateAuraSide, 'nameplate', 'aura_number', RefreshNameplates, {3, 9, 1})
	auraNumber:SetPoint('TOP', auraSize, 'BOTTOM', 0, -56)

	local frameData = {
		[1] = {header = L['NAMEPLATE_AURA_WHITE_LIST'], tip = L['NAMEPLATE_AURA_WHITE_LIST_TIP'], offset = -220, barList = {}},
		[2] = {header = L['NAMEPLATE_AURA_BLACK_LIST'], tip = L['NAMEPLATE_AURA_BLACK_LIST_TIP'], offset = -400, barList = {}},
	}

	local function createBar(parent, index, spellID)
		local name, _, texture = GetSpellInfo(spellID)
		local bar = CreateFrame('Frame', nil, parent)
		bar:SetSize(140, 18)
		frameData[index].barList[spellID] = bar

		local icon, close = GUI:CreateBarWidgets(bar, texture)
		F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
		close:SetScript('OnClick', function()
			bar:Hide()
			FREE_ADB['nameplate_aura_filter'][index][spellID] = nil
			frameData[index].barList[spellID] = nil
			sortBars(frameData[index].barList)
		end)

		local spellName = F.CreateFS(bar, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'LEFT', 24, 0)
		spellName:SetWidth(120)
		spellName:SetJustifyH('LEFT')
		if index == 2 then spellName:SetTextColor(1, 0, 0) end

		sortBars(frameData[index].barList)
	end

	local function addClick(parent, index)
		local spellID = tonumber(parent.box:GetText())
		if not spellID or not GetSpellInfo(spellID) then UIErrorsFrame:AddMessage(C.RedColor..'Incorrect SpellID') return end
		if FREE_ADB['nameplate_aura_filter'][index][spellID] then UIErrorsFrame:AddMessage(C.RedColor..'Existing ID') return end

		FREE_ADB['nameplate_aura_filter'][index][spellID] = true
		createBar(parent.child, index, spellID)
		parent.box:SetText('')
	end

	for index, value in ipairs(frameData) do
		F.CreateFS(plateAuraSide, C.Assets.Fonts.Regular, 12, nil, value.header, 'BLUE', true, 'TOPLEFT', 20, value.offset)
		local frame = CreateFrame('Frame', nil, plateAuraSide)
		frame:SetSize(160, 170)
		frame:SetPoint('TOPLEFT', 10, value.offset - 10)

		local scroll = GUI:CreateScroll(frame, 140, 120)
		scroll.box = F.CreateEditBox(frame, 90, 20)
		scroll.box:SetPoint('TOPLEFT', 10, -10)
		scroll.box.title = value.header
		F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', value.tip, 'BLUE')

		scroll.add = F.CreateButton(frame, 40, 20, ADD, 10)
		scroll.add:SetPoint('TOPRIGHT', -10, -10)
		scroll.add:SetScript('OnClick', function()
			addClick(scroll, index)
		end)

		for spellID in pairs(FREE_ADB['nameplate_aura_filter'][index]) do
			createBar(scroll.child, index, spellID)
		end
	end
end


--[[  ]]









--[[ module options ]]

local function AppearanceOptions()
	local parent = FreeUI_GUI[1]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local cursorTrail = GUI:CreateCheckBox(parent, 'APPEARANCE', 'cursor_trail')
	cursorTrail:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local vignetting = GUI:CreateCheckBox(parent, 'APPEARANCE', 'vignetting', nil, SetupVignettingAlpha)
	vignetting:SetPoint('LEFT', cursorTrail, 'RIGHT', 160, 0)

	local reskinBlizz = GUI:CreateCheckBox(parent, 'APPEARANCE', 'reskin_blizz', nil, SetupBackdropAlpha)
	reskinBlizz:SetPoint('TOPLEFT', cursorTrail, 'BOTTOMLEFT', 0, -8)

	local shadowBorder = GUI:CreateCheckBox(parent, 'APPEARANCE', 'shadow_border')
	shadowBorder:SetPoint('LEFT', reskinBlizz, 'RIGHT', 160, 0)


	local addons = GUI:AddSubCategory(parent)
	addons:SetPoint('TOPLEFT', reskinBlizz, 'BOTTOMLEFT', 0, -16)

	local DBM = GUI:CreateCheckBox(parent, 'APPEARANCE', 'reskin_dbm')
	DBM:SetPoint('TOPLEFT', addons, 'BOTTOMLEFT', 0, -8)

	local BigWigs = GUI:CreateCheckBox(parent, 'APPEARANCE', 'reskin_bigwigs')
	BigWigs:SetPoint('LEFT', DBM, 'RIGHT', 160, 0)

	local WowLua = GUI:CreateCheckBox(parent, 'APPEARANCE', 'reskin_wowlua')
	WowLua:SetPoint('TOPLEFT', DBM, 'BOTTOMLEFT', 0, -8)

	local PGF = GUI:CreateCheckBox(parent, 'APPEARANCE', 'reskin_pgf')
	PGF:SetPoint('LEFT', WowLua, 'RIGHT', 160, 0)


	local other = GUI:AddSubCategory(parent)
	other:SetPoint('TOPLEFT', WowLua, 'BOTTOMLEFT', 0, -16)


	local uiScale = GUI:CreateSlider(parent, 'APPEARANCE', 'ui_scale', nil, {.4, 2, .01})
	uiScale:SetPoint('TOPLEFT', other, 'BOTTOMLEFT', 0, -24)

	local texture = GUI:CreateDropDown(parent, 'APPEARANCE', 'texture_style', nil, {L['GUI_UNITFRAME_TEXTURE_NORM'], L['GUI_UNITFRAME_TEXTURE_GRAD'], L['GUI_UNITFRAME_TEXTURE_FLAT']}, L['GUI_UNITFRAME_TEXTURE_STYLE'])
	texture:SetPoint('LEFT', uiScale, 'RIGHT', 80, 0)


	local vignettingAlphaSide = GUI:CreateSidePanel(parent, 'vignettingAlphaSide')

	local vignettingAlpha = GUI:CreateSlider(vignettingAlphaSide, 'APPEARANCE', 'vignetting_alpha', nil, {0, 1, 0.1})
	vignettingAlpha:SetPoint('TOP', vignettingAlphaSide.child, 'TOP', 0, -24)


	local backdropAlphaSide = GUI:CreateSidePanel(parent, 'backdropAlphaSide')

	local backdropAlpha = GUI:CreateSlider(backdropAlphaSide, 'APPEARANCE', 'backdrop_alpha', nil, {0.1, 1, 0.01})
	backdropAlpha:SetPoint('TOP', backdropAlphaSide.child, 'TOP', 0, -24)

end

local function NotificationOptions()
	local parent = FreeUI_GUI[2]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'notification', 'enable_notification')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local bagFull = GUI:CreateCheckBox(parent, 'notification', 'bag_full')
	bagFull:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local newMail = GUI:CreateCheckBox(parent, 'notification', 'new_mail')
	newMail:SetPoint('LEFT', bagFull, 'RIGHT', 160, 0)

	local rareAlert = GUI:CreateCheckBox(parent, 'notification', 'rare_found')
	rareAlert:SetPoint('TOPLEFT', bagFull, 'BOTTOMLEFT', 0, -8)

	local versionCheck = GUI:CreateCheckBox(parent, 'notification', 'version_check')
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

local function InfobarOptions()
	local parent = FreeUI_GUI[3]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

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

local function ChatOptions()
	local parent = FreeUI_GUI[4]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'chat', 'enable_chat')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local lock = GUI:CreateCheckBox(parent, 'chat', 'lock_position', nil, SetupChatSize)
	lock:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local fading = GUI:CreateCheckBox(parent, 'chat', 'fade_out', nil, SetupChatFading)
	fading:SetPoint('LEFT', lock, 'RIGHT', 160, 0)

	local outline = GUI:CreateCheckBox(parent, 'chat', 'font_outline')
	outline:SetPoint('TOPLEFT', lock, 'BOTTOMLEFT', 0, -8)

	local feature = GUI:AddSubCategory(parent)
	feature:SetPoint('TOPLEFT', outline, 'BOTTOMLEFT', 0, -16)

	local chatCopy = GUI:CreateCheckBox(parent, 'chat', 'copy_button')
	chatCopy:SetPoint('TOPLEFT', feature, 'BOTTOMLEFT', 0, -8)

	local voiceIcon = GUI:CreateCheckBox(parent, 'chat', 'voice_button')
	voiceIcon:SetPoint('LEFT', chatCopy, 'RIGHT', 160, 0)

	local abbreviate = GUI:CreateCheckBox(parent, 'chat', 'abbr_channel_names')
	abbreviate:SetPoint('TOPLEFT', chatCopy, 'BOTTOMLEFT', 0, -8)

	local cycles = GUI:CreateCheckBox(parent, 'chat', 'tab_cycle')
	cycles:SetPoint('LEFT', abbreviate, 'RIGHT', 160, 0)

	local sticky = GUI:CreateCheckBox(parent, 'chat', 'whisper_sticky')
	sticky:SetPoint('TOPLEFT', abbreviate, 'BOTTOMLEFT', 0, -8)

	local whisperAlert = GUI:CreateCheckBox(parent, 'chat', 'whisper_sound', nil, SetupWhisperTimer)
	whisperAlert:SetPoint('LEFT', sticky, 'RIGHT', 160, 0)

	local bubble = GUI:CreateCheckBox(parent, 'chat', 'smart_bubble')
	bubble:SetPoint('TOPLEFT', sticky, 'BOTTOMLEFT', 0, -8)

	local clickInvite = GUI:CreateCheckBox(parent, 'chat', 'click_to_invite')
	clickInvite:SetPoint('LEFT', bubble, 'RIGHT', 160, 0)

	local filter = GUI:AddSubCategory(parent)
	filter:SetPoint('TOPLEFT', bubble, 'BOTTOMLEFT', 0, -16)

	local chatFilter = GUI:CreateCheckBox(parent, 'chat', 'filters', nil, SetupChatFilter)
	chatFilter:SetPoint('TOPLEFT', filter, 'BOTTOMLEFT', 0, -8)

	local blockAddonSpam = GUI:CreateCheckBox(parent, 'chat', 'block_addon_spam')
	blockAddonSpam:SetPoint('LEFT', chatFilter, 'RIGHT', 160, 0)

	local blockStranger = GUI:CreateCheckBox(parent, 'chat', 'block_stranger_whisper')
	blockStranger:SetPoint('TOPLEFT', chatFilter, 'BOTTOMLEFT', 0, -8)

	local allowFriendsSpam = GUI:CreateCheckBox(parent, 'chat', 'allow_friends_spam')
	allowFriendsSpam:SetPoint('LEFT', blockStranger, 'RIGHT', 160, 0)

	local itemLinks = GUI:CreateCheckBox(parent, 'chat', 'item_links')
	itemLinks:SetPoint('TOPLEFT', blockStranger, 'BOTTOMLEFT', 0, -8)

	local spamageMeter = GUI:CreateCheckBox(parent, 'chat', 'spamage_meter')
	spamageMeter:SetPoint('LEFT', itemLinks, 'RIGHT', 160, 0)


	local function toggleChatOptions()
		local shown = enable:GetChecked()
		lock:SetShown(shown)
		lock.bu:SetShown(shown)
		fading:SetShown(shown)
		fading.bu:SetShown(shown)
		outline:SetShown(shown)
		voiceIcon:SetShown(shown)
		abbreviate:SetShown(shown)
		whisperAlert:SetShown(shown)
		itemLinks:SetShown(shown)
		spamageMeter:SetShown(shown)
		sticky:SetShown(shown)
		cycles:SetShown(shown)
		chatCopy:SetShown(shown)
		clickInvite:SetShown(shown)
		chatFilter:SetShown(shown)
		chatFilter.bu:SetShown(shown)
		blockAddonSpam:SetShown(shown)
		blockStranger:SetShown(shown)
		allowFriendsSpam:SetShown(shown)
		feature:SetShown(shown)
		filter:SetShown(shown)
		bubble:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleChatOptions)
	parent:HookScript('OnShow', toggleChatOptions)


	local chatSizeSide = GUI:CreateSidePanel(parent, 'chatSizeSide')

	local chatSizeWidth = GUI:CreateSlider(chatSizeSide, 'chat', 'window_width', nil, {100, 600, 1})
	chatSizeWidth:SetPoint('TOP', chatSizeSide.child, 'TOP', 0, -24)

	local chatSizeHeight = GUI:CreateSlider(chatSizeSide, 'chat', 'window_height', nil, {100, 600, 1})
	chatSizeHeight:SetPoint('TOP', chatSizeWidth, 'BOTTOM', 0, -56)


	local chatFadingSide = GUI:CreateSidePanel(parent, 'chatFadingSide')

	local fadingVisible = GUI:CreateSlider(chatFadingSide, 'chat', 'fading_visible', nil, {30, 300, 1})
	fadingVisible:SetPoint('TOP', chatFadingSide.child, 'TOP', 0, -24)

	local fadingDuration = GUI:CreateSlider(chatFadingSide, 'chat', 'fading_duration', nil, {1, 6, 1})
	fadingDuration:SetPoint('TOP', fadingVisible, 'BOTTOM', 0, -56)


	local chatFilterSide = GUI:CreateSidePanel(parent, 'chatFilterSide')

	local filterMatches = GUI:CreateSlider(chatFilterSide, 'chat', 'matche_number', nil, {1, 5, 1})
	filterMatches:SetPoint('TOP', chatFilterSide.child, 'TOP', 0, -24)

	local keywordsList = GUI:CreateEditBox(chatFilterSide, 'chat', 'keywords_list', nil, {140, 140, 999, true})
	keywordsList:SetPoint('TOP', filterMatches, 'BOTTOM', 0, -56)
end

local function AuraOptions()
	local parent = FreeUI_GUI[5]

	local basic = GUI:AddSubCategory(parent, L['GUI_AURA_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

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
	buffsPerRow:SetPoint('TOP', buffSize, 'BOTTOM', 0, -56)

	local debuffSize = GUI:CreateSlider(auraSizeSide, 'aura', 'debuff_size', nil, {20, 50, 1})
	debuffSize:SetPoint('TOP', buffsPerRow, 'BOTTOM', 0, -56)

	local debuffsPerRow = GUI:CreateSlider(auraSizeSide, 'aura', 'debuffs_per_row', nil, {6, 16, 1})
	debuffsPerRow:SetPoint('TOP', debuffSize, 'BOTTOM', 0, -56)

	local margin = GUI:CreateSlider(auraSizeSide, 'aura', 'margin', nil, {3, 10, 1})
	margin:SetPoint('TOP', debuffsPerRow, 'BOTTOM', 0, -56)

	local offset = GUI:CreateSlider(auraSizeSide, 'aura', 'offset', nil, {6, 16, 1})
	offset:SetPoint('TOP', margin, 'BOTTOM', 0, -56)


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

local function ActionbarOptions()
	local parent = FreeUI_GUI[6]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'actionbar', 'enable_actionbar', nil, SetupActionbarSize, nil, true)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local class = GUI:CreateCheckBox(parent, 'actionbar', 'button_class_color')
	class:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local range = GUI:CreateCheckBox(parent, 'actionbar', 'button_range')
	range:SetPoint('LEFT', class, 'RIGHT', 160, 0)

	local hotkey = GUI:CreateCheckBox(parent, 'actionbar', 'button_hotkey')
	hotkey:SetPoint('TOPLEFT', class, 'BOTTOMLEFT', 0, -8)

	local macro = GUI:CreateCheckBox(parent, 'actionbar', 'button_macro_name')
	macro:SetPoint('LEFT', hotkey, 'RIGHT', 160, 0)

	local count = GUI:CreateCheckBox(parent, 'actionbar', 'button_count')
	count:SetPoint('TOPLEFT', hotkey, 'BOTTOMLEFT', 0, -8)

	local cooldown = GUI:CreateCheckBox(parent, 'cooldown', 'enable_cooldown', nil, SetupCooldown)
	cooldown:SetPoint('LEFT', count, 'RIGHT', 160, 0)

	local extra = GUI:AddSubCategory(parent)
	extra:SetPoint('TOPLEFT', count, 'BOTTOMLEFT', 0, -16)

	local bar1 = GUI:CreateCheckBox(parent, 'actionbar', 'bar1')
	bar1:SetPoint('TOPLEFT', extra, 'BOTTOMLEFT', 0, -8)

	local bar1Fade = GUI:CreateCheckBox(parent, 'actionbar', 'bar1_fade', nil, SetupBar1Fade)
	bar1Fade:SetPoint('LEFT', bar1, 'RIGHT', 160, 0)

	bar1.sub = {bar1Fade}

	local bar2 = GUI:CreateCheckBox(parent, 'actionbar', 'bar2')
	bar2:SetPoint('TOPLEFT', bar1, 'BOTTOMLEFT', 0, -8)

	local bar2Fade = GUI:CreateCheckBox(parent, 'actionbar', 'bar2_fade', nil, SetupBar2Fade)
	bar2Fade:SetPoint('LEFT', bar2, 'RIGHT', 160, 0)

	bar2.sub = {bar2Fade}

	local bar3 = GUI:CreateCheckBox(parent, 'actionbar', 'bar3')
	bar3:SetPoint('TOPLEFT', bar2, 'BOTTOMLEFT', 0, -8)

	local bar3Fade = GUI:CreateCheckBox(parent, 'actionbar', 'bar3_fade', nil, SetupBar3Fade)
	bar3Fade:SetPoint('LEFT', bar3, 'RIGHT', 160, 0)

	bar3.sub = {bar3Fade}

	local bar4 = GUI:CreateCheckBox(parent, 'actionbar', 'bar4')
	bar4:SetPoint('TOPLEFT', bar3, 'BOTTOMLEFT', 0, -8)

	local bar4Fade = GUI:CreateCheckBox(parent, 'actionbar', 'bar4_fade', nil, SetupBar4Fade)
	bar4Fade:SetPoint('LEFT', bar4, 'RIGHT', 160, 0)

	bar4.sub = {bar4Fade}

	local bar5 = GUI:CreateCheckBox(parent, 'actionbar', 'bar5')
	bar5:SetPoint('TOPLEFT', bar4, 'BOTTOMLEFT', 0, -8)

	local bar5Fade = GUI:CreateCheckBox(parent, 'actionbar', 'bar5_fade', nil, SetupBar5Fade)
	bar5Fade:SetPoint('LEFT', bar5, 'RIGHT', 160, 0)

	bar5.sub = {bar5Fade}

	local petBar = GUI:CreateCheckBox(parent, 'actionbar', 'pet_bar')
	petBar:SetPoint('TOPLEFT', bar5, 'BOTTOMLEFT', 0, -8)

	local petBarFade = GUI:CreateCheckBox(parent, 'actionbar', 'pet_bar_fade', nil, SetupPetBarFade)
	petBarFade:SetPoint('LEFT', petBar, 'RIGHT', 160, 0)

	petBar.sub = {petBarFade}


	local stanceBar = GUI:CreateCheckBox(parent, 'actionbar', 'stance_bar')
	stanceBar:SetPoint('TOPLEFT', petBar, 'BOTTOMLEFT', 0, -8)



	local function toggleActionbarOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		class:SetShown(shown)
		range:SetShown(shown)
		macro:SetShown(shown)
		hotkey:SetShown(shown)
		count:SetShown(shown)
		cooldown:SetShown(shown)
		cooldown.bu:SetShown(shown)
		extra:SetShown(shown)
		extra.line:SetShown(shown)
		bar1:SetShown(shown)
		bar1Fade:SetShown(shown)
		bar1Fade.bu:SetShown(shown)
		bar2:SetShown(shown)
		bar2Fade:SetShown(shown)
		bar2Fade.bu:SetShown(shown)
		bar3:SetShown(shown)
		bar3Fade:SetShown(shown)
		bar3Fade.bu:SetShown(shown)
		bar4:SetShown(shown)
		bar4Fade:SetShown(shown)
		bar4Fade.bu:SetShown(shown)
		bar5:SetShown(shown)
		bar5Fade:SetShown(shown)
		bar5Fade.bu:SetShown(shown)
		petBar:SetShown(shown)
		petBarFade:SetShown(shown)
		petBarFade.bu:SetShown(shown)
		stanceBar:SetShown(shown)

	end

	enable:HookScript('OnClick', toggleActionbarOptions)
	parent:HookScript('OnShow', toggleActionbarOptions)


	do
		local bar1FadeSide = GUI:CreateSidePanel(parent, 'bar1FadeSide')

		local fadeInDuration = GUI:CreateSlider(bar1FadeSide, 'actionbar', 'fade_in_duration', nil, {0.1, 2, 0.1})
		fadeInDuration:SetPoint('TOP', bar1FadeSide.child, 'TOP', 0, -24)

		local fadeOutDuration = GUI:CreateSlider(bar1FadeSide, 'actionbar', 'fade_out_duration', nil, {0.1, 2, 0.1})
		fadeOutDuration:SetPoint('TOP', fadeInDuration, 'BOTTOM', 0, -56)

		local fadeSmooth = GUI:CreateCheckBox(bar1FadeSide, 'actionbar', 'fade_smooth')
		fadeSmooth:SetPoint('TOPLEFT', bar1FadeSide.child, 'TOPLEFT', 10, -150)

		local bar1FadeInAlpha = GUI:CreateSlider(bar1FadeSide, 'actionbar', 'bar1_fade_in_alpha', nil, {0.1, 1, 0.1})
		bar1FadeInAlpha:SetPoint('TOP', bar1FadeSide.child, 'TOP', 0, -200)

		local bar1FadeOutAlpha = GUI:CreateSlider(bar1FadeSide, 'actionbar', 'bar1_fade_out_alpha', nil, {0.1, 1, 0.1})
		bar1FadeOutAlpha:SetPoint('TOP', bar1FadeInAlpha, 'BOTTOM', 0, -56)

		local bar1FadeHover = GUI:CreateCheckBox(bar1FadeSide, 'actionbar', 'bar1_fade_hover')
		bar1FadeHover:SetPoint('TOPLEFT', bar1FadeSide.child, 'TOPLEFT', 10, -320)

		local bar1FadeCombat = GUI:CreateCheckBox(bar1FadeSide, 'actionbar', 'bar1_fade_combat')
		bar1FadeCombat:SetPoint('TOPLEFT', bar1FadeHover, 'BOTTOMLEFT', 0, -8)

		local bar1FadeTarget = GUI:CreateCheckBox(bar1FadeSide, 'actionbar', 'bar1_fade_target')
		bar1FadeTarget:SetPoint('TOPLEFT', bar1FadeCombat, 'BOTTOMLEFT', 0, -8)

		local bar1FadeArena = GUI:CreateCheckBox(bar1FadeSide, 'actionbar', 'bar1_fade_arena')
		bar1FadeArena:SetPoint('TOPLEFT', bar1FadeTarget, 'BOTTOMLEFT', 0, -8)

		local bar1FadeInstance = GUI:CreateCheckBox(bar1FadeSide, 'actionbar', 'bar1_fade_instance')
		bar1FadeInstance:SetPoint('TOPLEFT', bar1FadeArena, 'BOTTOMLEFT', 0, -8)
	end


	local bar2FadeSide = GUI:CreateSidePanel(parent, 'bar2FadeSide')

	local bar2FadeInAlpha = GUI:CreateSlider(bar2FadeSide, 'actionbar', 'bar2_fade_in_alpha', nil, {0.1, 1, 0.1})
	bar2FadeInAlpha:SetPoint('TOP', bar2FadeSide.child, 'TOP', 0, -24)

	local bar2FadeOutAlpha = GUI:CreateSlider(bar2FadeSide, 'actionbar', 'bar2_fade_out_alpha', nil, {0.1, 1, 0.1})
	bar2FadeOutAlpha:SetPoint('TOP', bar2FadeInAlpha, 'BOTTOM', 0, -56)

	local bar2FadeHover = GUI:CreateCheckBox(bar2FadeSide, 'actionbar', 'bar2_fade_hover')
	bar2FadeHover:SetPoint('TOPLEFT', bar2FadeSide.child, 'TOPLEFT', 10, -150)

	local bar2FadeCombat = GUI:CreateCheckBox(bar2FadeSide, 'actionbar', 'bar2_fade_combat')
	bar2FadeCombat:SetPoint('TOPLEFT', bar2FadeHover, 'BOTTOMLEFT', 0, -8)

	local bar2FadeTarget = GUI:CreateCheckBox(bar2FadeSide, 'actionbar', 'bar2_fade_target')
	bar2FadeTarget:SetPoint('TOPLEFT', bar2FadeCombat, 'BOTTOMLEFT', 0, -8)

	local bar2FadeArena = GUI:CreateCheckBox(bar2FadeSide, 'actionbar', 'bar2_fade_arena')
	bar2FadeArena:SetPoint('TOPLEFT', bar2FadeTarget, 'BOTTOMLEFT', 0, -8)

	local bar2FadeInstance = GUI:CreateCheckBox(bar2FadeSide, 'actionbar', 'bar2_fade_instance')
	bar2FadeInstance:SetPoint('TOPLEFT', bar2FadeArena, 'BOTTOMLEFT', 0, -8)


	local bar3Side = GUI:CreateSidePanel(parent, 'bar3Side')

	local bar3Divide = GUI:CreateCheckBox(bar3Side, 'actionbar', 'bar3_divide')
	bar3Divide:SetPoint('TOPLEFT', bar3Side.child, 'TOPLEFT', 10, -16)


	local bar3FadeSide = GUI:CreateSidePanel(parent, 'bar3FadeSide')

	local bar3FadeInAlpha = GUI:CreateSlider(bar3FadeSide, 'actionbar', 'bar3_fade_in_alpha', nil, {0.1, 1, 0.1})
	bar3FadeInAlpha:SetPoint('TOP', bar3FadeSide.child, 'TOP', 0, -24)

	local bar3FadeOutAlpha = GUI:CreateSlider(bar3FadeSide, 'actionbar', 'bar3_fade_out_alpha', nil, {0.1, 1, 0.1})
	bar3FadeOutAlpha:SetPoint('TOP', bar3FadeInAlpha, 'BOTTOM', 0, -56)

	local bar3FadeHover = GUI:CreateCheckBox(bar3FadeSide, 'actionbar', 'bar3_fade_hover')
	bar3FadeHover:SetPoint('TOPLEFT', bar3FadeSide.child, 'TOPLEFT', 10, -150)

	local bar3FadeCombat = GUI:CreateCheckBox(bar3FadeSide, 'actionbar', 'bar3_fade_combat')
	bar3FadeCombat:SetPoint('TOPLEFT', bar3FadeHover, 'BOTTOMLEFT', 0, -8)

	local bar3FadeTarget = GUI:CreateCheckBox(bar3FadeSide, 'actionbar', 'bar3_fade_target')
	bar3FadeTarget:SetPoint('TOPLEFT', bar3FadeCombat, 'BOTTOMLEFT', 0, -8)

	local bar3FadeArena = GUI:CreateCheckBox(bar3FadeSide, 'actionbar', 'bar3_fade_arena')
	bar3FadeArena:SetPoint('TOPLEFT', bar3FadeTarget, 'BOTTOMLEFT', 0, -8)

	local bar3FadeInstance = GUI:CreateCheckBox(bar3FadeSide, 'actionbar', 'bar3_fade_instance')
	bar3FadeInstance:SetPoint('TOPLEFT', bar3FadeArena, 'BOTTOMLEFT', 0, -8)


	local bar4FadeSide = GUI:CreateSidePanel(parent, 'bar4FadeSide')

	local bar4FadeInAlpha = GUI:CreateSlider(bar4FadeSide, 'actionbar', 'bar4_fade_in_alpha', nil, {0.1, 1, 0.1})
	bar4FadeInAlpha:SetPoint('TOP', bar4FadeSide.child, 'TOP', 0, -24)

	local bar4FadeOutAlpha = GUI:CreateSlider(bar4FadeSide, 'actionbar', 'bar4_fade_out_alpha', nil, {0.1, 1, 0.1})
	bar4FadeOutAlpha:SetPoint('TOP', bar4FadeInAlpha, 'BOTTOM', 0, -56)

	local bar4FadeHover = GUI:CreateCheckBox(bar4FadeSide, 'actionbar', 'bar4_fade_hover')
	bar4FadeHover:SetPoint('TOPLEFT', bar4FadeSide.child, 'TOPLEFT', 10, -150)

	local bar4FadeCombat = GUI:CreateCheckBox(bar4FadeSide, 'actionbar', 'bar4_fade_combat')
	bar4FadeCombat:SetPoint('TOPLEFT', bar4FadeHover, 'BOTTOMLEFT', 0, -8)

	local bar4FadeTarget = GUI:CreateCheckBox(bar4FadeSide, 'actionbar', 'bar4_fade_target')
	bar4FadeTarget:SetPoint('TOPLEFT', bar4FadeCombat, 'BOTTOMLEFT', 0, -8)

	local bar4FadeArena = GUI:CreateCheckBox(bar4FadeSide, 'actionbar', 'bar4_fade_arena')
	bar4FadeArena:SetPoint('TOPLEFT', bar4FadeTarget, 'BOTTOMLEFT', 0, -8)

	local bar4FadeInstance = GUI:CreateCheckBox(bar4FadeSide, 'actionbar', 'bar4_fade_instance')
	bar4FadeInstance:SetPoint('TOPLEFT', bar4FadeArena, 'BOTTOMLEFT', 0, -8)


	local bar5FadeSide = GUI:CreateSidePanel(parent, 'bar5FadeSide')

	local bar5FadeInAlpha = GUI:CreateSlider(bar5FadeSide, 'actionbar', 'bar5_fade_in_alpha', nil, {0.1, 1, 0.1})
	bar5FadeInAlpha:SetPoint('TOP', bar5FadeSide.child, 'TOP', 0, -24)

	local bar5FadeOutAlpha = GUI:CreateSlider(bar5FadeSide, 'actionbar', 'bar5_fade_out_alpha', nil, {0.1, 1, 0.1})
	bar5FadeOutAlpha:SetPoint('TOP', bar5FadeInAlpha, 'BOTTOM', 0, -56)

	local bar5FadeHover = GUI:CreateCheckBox(bar5FadeSide, 'actionbar', 'bar5_fade_hover')
	bar5FadeHover:SetPoint('TOPLEFT', bar5FadeSide.child, 'TOPLEFT', 10, -150)

	local bar5FadeCombat = GUI:CreateCheckBox(bar5FadeSide, 'actionbar', 'bar5_fade_combat')
	bar5FadeCombat:SetPoint('TOPLEFT', bar5FadeHover, 'BOTTOMLEFT', 0, -8)

	local bar5FadeTarget = GUI:CreateCheckBox(bar5FadeSide, 'actionbar', 'bar5_fade_target')
	bar5FadeTarget:SetPoint('TOPLEFT', bar5FadeCombat, 'BOTTOMLEFT', 0, -8)

	local bar5FadeArena = GUI:CreateCheckBox(bar5FadeSide, 'actionbar', 'bar5_fade_arena')
	bar5FadeArena:SetPoint('TOPLEFT', bar5FadeTarget, 'BOTTOMLEFT', 0, -8)

	local bar5FadeInstance = GUI:CreateCheckBox(bar5FadeSide, 'actionbar', 'bar5_fade_instance')
	bar5FadeInstance:SetPoint('TOPLEFT', bar5FadeArena, 'BOTTOMLEFT', 0, -8)


	local petBarFadeSide = GUI:CreateSidePanel(parent, 'petBarFadeSide')

	local petBarFadeInAlpha = GUI:CreateSlider(petBarFadeSide, 'actionbar', 'pet_bar_fade_in_alpha', nil, {0.1, 1, 0.1})
	petBarFadeInAlpha:SetPoint('TOP', petBarFadeSide.child, 'TOP', 0, -24)

	local petBarFadeOutAlpha = GUI:CreateSlider(petBarFadeSide, 'actionbar', 'pet_bar_fade_out_alpha', nil, {0.1, 1, 0.1})
	petBarFadeOutAlpha:SetPoint('TOP', petBarFadeInAlpha, 'BOTTOM', 0, -56)

	local petBarFadeHover = GUI:CreateCheckBox(petBarFadeSide, 'actionbar', 'pet_bar_fade_hover')
	petBarFadeHover:SetPoint('TOPLEFT', petBarFadeSide.child, 'TOPLEFT', 10, -150)

	local petBarFadeCombat = GUI:CreateCheckBox(petBarFadeSide, 'actionbar', 'pet_bar_fade_combat')
	petBarFadeCombat:SetPoint('TOPLEFT', petBarFadeHover, 'BOTTOMLEFT', 0, -8)

	local petBarFadeTarget = GUI:CreateCheckBox(petBarFadeSide, 'actionbar', 'pet_bar_fade_target')
	petBarFadeTarget:SetPoint('TOPLEFT', petBarFadeCombat, 'BOTTOMLEFT', 0, -8)

	local petBarFadeArena = GUI:CreateCheckBox(petBarFadeSide, 'actionbar', 'petBar_fade_arena')
	petBarFadeArena:SetPoint('TOPLEFT', petBarFadeTarget, 'BOTTOMLEFT', 0, -8)

	local petBarFadeInstance = GUI:CreateCheckBox(petBarFadeSide, 'actionbar', 'petBar_fade_instance')
	petBarFadeInstance:SetPoint('TOPLEFT', petBarFadeArena, 'BOTTOMLEFT', 0, -8)


	local cooldownSide = GUI:CreateSidePanel(parent, 'cooldownSide')

	local overrideWA = GUI:CreateCheckBox(cooldownSide, 'cooldown', 'override_weakauras')
	overrideWA:SetPoint('TOPLEFT', cooldownSide.child, 'TOPLEFT', 10, -16)

	local useDecimal = GUI:CreateCheckBox(cooldownSide, 'cooldown', 'decimal')
	useDecimal:SetPoint('TOP', overrideWA, 'BOTTOM', 0, -8)

	local decimalCooldown = GUI:CreateSlider(cooldownSide, 'cooldown', 'decimal_countdown', nil, {1, 10, 1})
	decimalCooldown:SetPoint('TOP', cooldownSide.child, 'TOP', 0, -90)

	local cdPulse = GUI:CreateCheckBox(cooldownSide, 'cooldown', 'pulse')
	cdPulse:SetPoint('TOP', useDecimal, 'BOTTOM', 0, -80)

	local pulseSize = GUI:CreateSlider(cooldownSide, 'cooldown', 'icon_size', nil, {20, 50, 1})
	pulseSize:SetPoint('TOP', decimalCooldown, 'TOP', 0, -100)



	local actionbarSizeSide = GUI:CreateSidePanel(parent, 'actionbarSizeSide')

	local buttonSizeSmall = GUI:CreateSlider(actionbarSizeSide, 'actionbar', 'button_size_small', nil, {20, 50, 1})
	buttonSizeSmall:SetPoint('TOP', actionbarSizeSide.child, 'TOP', 0, -24)

	local buttonSizeNormal = GUI:CreateSlider(actionbarSizeSide, 'actionbar', 'button_size_normal', nil, {20, 50, 1})
	buttonSizeNormal:SetPoint('TOP', buttonSizeSmall, 'BOTTOM', 0, -56)

	local buttonSizeBig = GUI:CreateSlider(actionbarSizeSide, 'actionbar', 'button_size_big', nil, {20, 50, 1})
	buttonSizeBig:SetPoint('TOP', buttonSizeNormal, 'BOTTOM', 0, -56)

	local buttonMargin = GUI:CreateSlider(actionbarSizeSide, 'actionbar', 'button_margin', nil, {0, 10, 1})
	buttonMargin:SetPoint('TOP', buttonSizeBig, 'BOTTOM', 0, -56)
end

local function CombatOptions()
	local parent = FreeUI_GUI[7]

	local basic = GUI:AddSubCategory(parent, L['COMBAT_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'combat', 'enable_combat')
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local combat = GUI:CreateCheckBox(parent, 'combat', 'combat_alert')
	combat:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local health = GUI:CreateCheckBox(parent, 'combat', 'health_alert', nil, SetupHealthThreshold)
	health:SetPoint('LEFT', combat, 'RIGHT', 160, 0)

	local spell = GUI:CreateCheckBox(parent, 'combat', 'spell_alert')
	spell:SetPoint('TOPLEFT', combat, 'BOTTOMLEFT', 0, -8)

	local announcement = GUI:CreateCheckBox(parent, 'announcement', 'enable', nil, SetupAnnouncement)
	announcement:SetPoint('LEFT', spell, 'RIGHT', 160, 0)

	local easyFocus = GUI:CreateCheckBox(parent, 'combat', 'easy_focus')
	easyFocus:SetPoint('TOPLEFT', spell, 'BOTTOMLEFT', 0, -8)

	local easyMark = GUI:CreateCheckBox(parent, 'combat', 'easy_mark')
	easyMark:SetPoint('LEFT', easyFocus, 'RIGHT', 160, 0)

	local fct = GUI:CreateCheckBox(parent, 'combat', 'fct', nil, SetupFCT)
	fct:SetPoint('TOPLEFT', easyFocus, 'BOTTOMLEFT', 0, -8)

	local pvp = GUI:AddSubCategory(parent, L['COMBAT_SUB_PVP'])
	pvp:SetPoint('TOPLEFT', fct, 'BOTTOMLEFT', 0, -16)

	local autoTab = GUI:CreateCheckBox(parent, 'combat', 'easy_tab')
	autoTab:SetPoint('TOPLEFT', pvp, 'BOTTOMLEFT', 0, -8)

	local PVPSound = GUI:CreateCheckBox(parent, 'combat', 'pvp_sound')
	PVPSound:SetPoint('LEFT', autoTab, 'RIGHT', 160, 0)




	enable.sub = {combat, health, spell, announcement, easyFocus, easyMark, fct, PVPSound, autoTab}


	local healthThresholdSide = GUI:CreateSidePanel(parent, 'healthThresholdSide')

	local healthThreshold = GUI:CreateSlider(healthThresholdSide, 'combat', 'health_alert_threshold', nil, {0.1, 0.8, 0.1})
	healthThreshold:SetPoint('TOP', healthThresholdSide.child, 'TOP', 0, -24)


	local fctSide = GUI:CreateSidePanel(parent, 'fctSide')

	local fctIn = GUI:CreateCheckBox(fctSide, 'combat', 'fct_in')
	fctIn:SetPoint('TOPLEFT', fctSide.child, 'TOPLEFT', 10, -16)

	local fctOut = GUI:CreateCheckBox(fctSide, 'combat', 'fct_out')
	fctOut:SetPoint('TOP', fctIn, 'BOTTOM', 0, -8)

	local fctPet = GUI:CreateCheckBox(fctSide, 'combat', 'fct_pet')
	fctPet:SetPoint('TOP', fctOut, 'BOTTOM', 0, -8)

	local fctPeriodic = GUI:CreateCheckBox(fctSide, 'combat', 'fct_periodic')
	fctPeriodic:SetPoint('TOP', fctPet, 'BOTTOM', 0, -8)

	local fctMerge = GUI:CreateCheckBox(fctSide, 'combat', 'fct_merge')
	fctMerge:SetPoint('TOP', fctPeriodic, 'BOTTOM', 0, -8)


	local announcementSide = GUI:CreateSidePanel(parent, 'announcementSide')

	local annouceInterrupt = GUI:CreateCheckBox(announcementSide, 'announcement', 'interrupt')
	annouceInterrupt:SetPoint('TOPLEFT', announcementSide.child, 'TOPLEFT', 10, -16)

	local annouceDispel = GUI:CreateCheckBox(announcementSide, 'announcement', 'dispel')
	annouceDispel:SetPoint('TOP', annouceInterrupt, 'BOTTOM', 0, -8)

	local annouceStolen = GUI:CreateCheckBox(announcementSide, 'announcement', 'stolen')
	annouceStolen:SetPoint('TOP', annouceDispel, 'BOTTOM', 0, -8)

	local annouceFeast = GUI:CreateCheckBox(announcementSide, 'announcement', 'feast')
	annouceFeast:SetPoint('TOP', annouceStolen, 'BOTTOM', 0, -8)

	local annouceCauldron = GUI:CreateCheckBox(announcementSide, 'announcement', 'cauldron')
	annouceCauldron:SetPoint('TOP', annouceFeast, 'BOTTOM', 0, -8)

	local annouceCodex = GUI:CreateCheckBox(announcementSide, 'announcement', 'codex')
	annouceCodex:SetPoint('TOP', annouceCauldron, 'BOTTOM', 0, -8)

	local annouceRefreshment = GUI:CreateCheckBox(announcementSide, 'announcement', 'refreshment')
	annouceRefreshment:SetPoint('TOP', annouceCodex, 'BOTTOM', 0, -8)

	local annouceSoulwell = GUI:CreateCheckBox(announcementSide, 'announcement', 'soulwell')
	annouceSoulwell:SetPoint('TOP', annouceRefreshment, 'BOTTOM', 0, -8)

	local annouceRepair = GUI:CreateCheckBox(announcementSide, 'announcement', 'repair')
	annouceRepair:SetPoint('TOP', annouceSoulwell, 'BOTTOM', 0, -8)

	local annouceMail = GUI:CreateCheckBox(announcementSide, 'announcement', 'mail')
	annouceMail:SetPoint('TOP', annouceRepair, 'BOTTOM', 0, -8)

	local annouceBattleRez = GUI:CreateCheckBox(announcementSide, 'announcement', 'battle_resurrection')
	annouceBattleRez:SetPoint('TOP', annouceMail, 'BOTTOM', 0, -8)

	local annoucePortal = GUI:CreateCheckBox(announcementSide, 'announcement', 'portal')
	annoucePortal:SetPoint('TOP', annouceBattleRez, 'BOTTOM', 0, -8)

	local annouceToy = GUI:CreateCheckBox(announcementSide, 'announcement', 'toy')
	annouceToy:SetPoint('TOP', annoucePortal, 'BOTTOM', 0, -8)


	-- local function toggleCombatOptions()
	-- 	local shown = enable:GetChecked()
	-- 	combat:SetShown(shown)
	-- 	health:SetShown(shown)
	-- 	health.bu:SetShown(shown)
	-- 	spell:SetShown(shown)
	-- 	easyFocus:SetShown(shown)
	-- 	easyMark:SetShown(shown)
	-- 	announcement:SetShown(shown)
	-- 	announcement.bu:SetShown(shown)
	-- 	fct:SetShown(shown)
	-- 	fct.bu:SetShown(shown)
	-- 	autoTab:SetShown(shown)
	-- 	PVPSound:SetShown(shown)
	-- end

	-- enable:HookScript('OnClick', toggleCombatOptions)
	-- parent:HookScript('OnShow', toggleCombatOptions)
end

local function InventoryOptions()
	local parent = FreeUI_GUI[8]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

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

	useCategory.sub = {itemFilterSet, itemFilterLegendary, itemFilterMountPet, itemFilterFavourite, itemFilterTrade, itemFilterQuest, itemFilterJunk, itemFilterAzerite, itemFilterConsumable}


	-- bag size side panel
	local bagSizeSide = GUI:CreateSidePanel(parent, 'bagSizeSide')

	local slotSize = GUI:CreateSlider(bagSizeSide, 'inventory', 'slot_size', nil, {20, 60, 1})
	slotSize:SetPoint('TOP', bagSizeSide.child, 'TOP', 0, -24)

	local spacing = GUI:CreateSlider(bagSizeSide, 'inventory', 'spacing', nil, {3, 6, 1})
	spacing:SetPoint('TOP', slotSize, 'BOTTOM', 0, -56)

	local bagColumns = GUI:CreateSlider(bagSizeSide, 'inventory', 'bag_columns', nil, {8, 16, 1})
	bagColumns:SetPoint('TOP', spacing, 'BOTTOM', 0, -56)

	local bankColumns = GUI:CreateSlider(bagSizeSide, 'inventory', 'bank_columns', nil, {8, 16, 1})
	bankColumns:SetPoint('TOP', bagColumns, 'BOTTOM', 0, -56)


	-- item level to show side panel
	local itemLevelSide = GUI:CreateSidePanel(parent, 'bagIlvlSide')

	local iLvltoShow = GUI:CreateSlider(itemLevelSide, 'inventory', 'item_level_to_show', nil, {1, 500, 1})
	iLvltoShow:SetPoint('TOP', itemLevelSide.child, 'TOP', 0, -24)

	itemLevel.sub = {iLvltoShow}


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

local function MapOptions()
	local parent = FreeUI_GUI[9]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

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
	minimapScale:SetPoint('TOP', mapScale, 'BOTTOM', 0, -56)


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

local function QuestOptions()
	local parent = FreeUI_GUI[10]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'quest', 'enable_quest', nil, SetupQuestTracker)
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


	do
		local trackerScaleSide = GUI:CreateSidePanel(parent, 'trackerScaleSide')

		local trackerScale = GUI:CreateSlider(trackerScaleSide, 'quest', 'tracker_scale', UpdateQuestTrackerScale, {0.5, 2, 0.1})
		trackerScale:SetPoint('TOP', trackerScaleSide.child, 'TOP', 0, -24)
	end


	local function toggleQuestOptions()
		local shown = enable:GetChecked()
		enable.bu:SetShown(shown)
		questLevel:SetShown(shown)
		rewardHightlight:SetShown(shown)
		questProgress:SetShown(shown)
		completeRing:SetShown(shown)
		extraButton:SetShown(shown)
	end

	enable:HookScript('OnClick', toggleQuestOptions)
	parent:HookScript('OnShow', toggleQuestOptions)
end

local function TooltipOptions()
	local parent = FreeUI_GUI[11]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

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

	local variousID = GUI:CreateCheckBox(parent, 'tooltip', 'various_ids')
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
	normalFontSize:SetPoint('TOP', headerFontSize, 'BOTTOM', 0, -56)


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

local function UnitframeOptions()
	local parent = FreeUI_GUI[12]

	local basic = GUI:AddSubCategory(parent, L['UNITFRAME_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'unitframe', 'enable_unitframe', nil, SetupUnitSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local transMode = GUI:CreateCheckBox(parent, 'unitframe', 'transparent_mode')
	transMode:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local portrait = GUI:CreateCheckBox(parent, 'unitframe', 'portrait')
	portrait:SetPoint('LEFT', transMode, 'RIGHT', 160, 0)

	local fader = GUI:CreateCheckBox(parent, 'unitframe', 'combat_fader', nil, SetupCombatFader)
	fader:SetPoint('TOPLEFT', transMode, 'BOTTOMLEFT', 0, -8)

	local rangeCheck = GUI:CreateCheckBox(parent, 'unitframe', 'range_check', nil, SetupRangeCheckAlpha)
	rangeCheck:SetPoint('LEFT', fader, 'RIGHT', 160, 0)

	local combatIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'player_combat_indicator')
	combatIndicator:SetPoint('TOPLEFT', fader, 'BOTTOMLEFT', 0, -8)

	local restingIndicator = GUI:CreateCheckBox(parent, 'unitframe', 'player_resting_indicator')
	restingIndicator:SetPoint('LEFT', combatIndicator, 'RIGHT', 160, 0)

	local colorSmooth = GUI:CreateCheckBox(parent, 'unitframe', 'color_smooth')
	colorSmooth:SetPoint('TOPLEFT', combatIndicator, 'BOTTOMLEFT', 0, -8)

	local classColor = GUI:CreateCheckBox(parent, 'unitframe', 'class_color', nil, SetupClassColor)
	classColor:SetPoint('LEFT', colorSmooth, 'RIGHT', 160, 0)

	local powerBar = GUI:CreateCheckBox(parent, 'unitframe', 'power_bar', nil, SetupPower)
	powerBar:SetPoint('TOPLEFT', colorSmooth, 'BOTTOMLEFT', 0, -8)

	local gcdSpark = GUI:CreateCheckBox(parent, 'unitframe', 'gcd_spark')
	gcdSpark:SetPoint('LEFT', powerBar, 'RIGHT', 160, 0)

	local healPrediction = GUI:CreateCheckBox(parent, 'unitframe', 'heal_prediction')
	healPrediction:SetPoint('TOPLEFT', powerBar, 'BOTTOMLEFT', 0, -8)

	local overAbsorb = GUI:CreateCheckBox(parent, 'unitframe', 'over_absorb')
	overAbsorb:SetPoint('LEFT', healPrediction, 'RIGHT', 160, 0)

	local classPowerBar = GUI:CreateCheckBox(parent, 'unitframe', 'class_power_bar', nil, SetupClassPower)
	classPowerBar:SetPoint('TOPLEFT', healPrediction, 'BOTTOMLEFT', 0, -8)

	local staggerBar = GUI:CreateCheckBox(parent, 'unitframe', 'stagger_bar')
	staggerBar:SetPoint('LEFT', classPowerBar, 'RIGHT', 160, 0)

	local totemsBar = GUI:CreateCheckBox(parent, 'unitframe', 'totems_bar')
	totemsBar:SetPoint('TOPLEFT', classPowerBar, 'BOTTOMLEFT', 0, -8)

	local hideTags = GUI:CreateCheckBox(parent, 'unitframe', 'player_hide_tags')
	hideTags:SetPoint('LEFT', totemsBar, 'RIGHT', 160, 0)

	local debuffsByPlayer = GUI:CreateCheckBox(parent, 'unitframe', 'debuffs_by_player')
	debuffsByPlayer:SetPoint('TOPLEFT', totemsBar, 'BOTTOMLEFT', 0, -8)

	local debuffType = GUI:CreateCheckBox(parent, 'unitframe', 'debuff_type')
	debuffType:SetPoint('LEFT', debuffsByPlayer, 'RIGHT', 160, 0)

	local stealableBuffs = GUI:CreateCheckBox(parent, 'unitframe', 'stealable_buffs')
	stealableBuffs:SetPoint('TOPLEFT', debuffsByPlayer, 'BOTTOMLEFT', 0, -8)


	local castbar = GUI:AddSubCategory(parent)
	castbar:SetPoint('TOPLEFT', stealableBuffs, 'BOTTOMLEFT', 0, -16)

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


	local focusSub = GUI:AddSubCategory(parent)
	focusSub:SetPoint('TOPLEFT', enablePet, 'BOTTOMLEFT', 0, -16)

	local enableFocus = GUI:CreateCheckBox(parent, 'unitframe', 'enable_focus', nil, SetupFocusSize)
	enableFocus:SetPoint('TOPLEFT', focusSub, 'BOTTOMLEFT', 0, -8)

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

	local cornerBuffs = GUI:CreateCheckBox(parent, 'unitframe', 'group_corner_buffs')
	cornerBuffs:SetPoint('TOPLEFT', groupColorSmooth, 'BOTTOMLEFT', 0, -8)

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

	local playerWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'player_width', nil, {50, 200, 1})
	playerWidth:SetPoint('TOP', unitSizeSide.child, 'TOP', 0, -24)

	local playerHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'player_height', nil, {6, 30, 1})
	playerHeight:SetPoint('TOP', playerWidth, 'BOTTOM', 0, -56)

	local targetWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_width', nil, {50, 200, 1})
	targetWidth:SetPoint('TOP', playerHeight, 'BOTTOM', 0, -56)

	local targetHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_height', nil, {6, 30, 1})
	targetHeight:SetPoint('TOP', targetWidth, 'BOTTOM', 0, -56)

	local totWidth = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_width', nil, {50, 200, 1})
	totWidth:SetPoint('TOP', targetHeight, 'BOTTOM', 0, -56)

	local totHeight = GUI:CreateSlider(unitSizeSide, 'unitframe', 'target_target_height', nil, {6, 30, 1})
	totHeight:SetPoint('TOP', totWidth, 'BOTTOM', 0, -56)


	-- alt power side panel
	local altPowerSide = GUI:CreateSidePanel(parent, 'altPowerSide')

	local altPowerHeight = GUI:CreateSlider(altPowerSide, 'unitframe', 'alt_power_height', nil, {1, 10, 1})
	altPowerHeight:SetPoint('TOP', altPowerSide.child, 'TOP', 0, -24)


	-- power side panel
	local powerSide = GUI:CreateSidePanel(parent, 'powerSide')

	local powerHeight = GUI:CreateSlider(powerSide, 'unitframe', 'power_bar_height', nil, {1, 10, 1})
	powerHeight:SetPoint('TOP', powerSide.child, 'TOP', 0, -24)

	local mana = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'MANA')
	mana:SetPoint('TOPLEFT', powerSide.child, 'TOPLEFT', 10, -80)

	local rage = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'RAGE')
	rage:SetPoint('TOP', mana, 'BOTTOM', 0, -16)

	local focus = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'FOCUS')
	focus:SetPoint('TOP', rage, 'BOTTOM', 0, -16)

	local energy = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'ENERGY')
	energy:SetPoint('TOP', focus, 'BOTTOM', 0, -16)

	local runic = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'RUNIC_POWER')
	runic:SetPoint('TOP', energy, 'BOTTOM', 0, -16)

	local lunar = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'LUNAR_POWER')
	lunar:SetPoint('TOP', runic, 'BOTTOM', 0, -16)

	local maelstrom = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'MAELSTROM')
	maelstrom:SetPoint('TOP', lunar, 'BOTTOM', 0, -16)

	local insanity = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'INSANITY')
	insanity:SetPoint('TOP', maelstrom, 'BOTTOM', 0, -16)

	local fury = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'FURY')
	fury:SetPoint('TOP', insanity, 'BOTTOM', 0, -16)

	local pain = GUI:CreateColorSwatch(powerSide, 'POWER_COLORS', 'PAIN')
	pain:SetPoint('TOP', fury, 'BOTTOM', 0, -16)




	-- focus size side panel
	local focusSizeSide = GUI:CreateSidePanel(parent, 'focusSizeSide')

	local focusWidth = GUI:CreateSlider(focusSizeSide, 'unitframe', 'focus_width', nil, {50, 300, 1})
	focusWidth:SetPoint('TOP', focusSizeSide.child, 'TOP', 0, -24)

	local focusHeight = GUI:CreateSlider(focusSizeSide, 'unitframe', 'focus_height', nil, {6, 30, 1})
	focusHeight:SetPoint('TOP', focusWidth, 'BOTTOM', 0, -56)

	local focusTargetWidth = GUI:CreateSlider(focusSizeSide, 'unitframe', 'focus_target_width', nil, {50, 300, 1})
	focusTargetWidth:SetPoint('TOP', focusHeight, 'BOTTOM', 0, -56)

	local focusTargetHeight = GUI:CreateSlider(focusSizeSide, 'unitframe', 'focus_target_height', nil, {6, 30, 1})
	focusTargetHeight:SetPoint('TOP', focusTargetWidth, 'BOTTOM', 0, -56)


	-- group size side panel
	local groupSizeSide = GUI:CreateSidePanel(parent, 'groupSizeSide')

	local partyWidth = GUI:CreateSlider(groupSizeSide, 'unitframe', 'party_width', nil, {20, 100, 1})
	partyWidth:SetPoint('TOP', groupSizeSide.child, 'TOP', 0, -24)

	local partyHeight = GUI:CreateSlider(groupSizeSide, 'unitframe', 'party_height', nil, {20, 100, 1})
	partyHeight:SetPoint('TOP', partyWidth, 'BOTTOM', 0, -56)

	local partyGap = GUI:CreateSlider(groupSizeSide, 'unitframe', 'party_gap', nil, {5, 20, 1})
	partyGap:SetPoint('TOP', partyHeight, 'BOTTOM', 0, -56)

	local raidWidth = GUI:CreateSlider(groupSizeSide, 'unitframe', 'raid_width', nil, {20, 100, 1})
	raidWidth:SetPoint('TOP', partyGap, 'BOTTOM', 0, -56)

	local raidHeight = GUI:CreateSlider(groupSizeSide, 'unitframe', 'raid_height', nil, {20, 100, 1})
	raidHeight:SetPoint('TOP', raidWidth, 'BOTTOM', 0, -56)

	local raidGap = GUI:CreateSlider(groupSizeSide, 'unitframe', 'raid_gap', nil, {5, 20, 1})
	raidGap:SetPoint('TOP', raidHeight, 'BOTTOM', 0, -56)


	-- castbar color side panel
	local castbarColorSide = GUI:CreateSidePanel(parent, 'castbarColorSide')

	local castingColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'casting_color')
	castingColor:SetPoint('TOPLEFT', castbarColorSide.child, 'TOPLEFT', 10, -10)

	local notInterruptibleColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'casting_not_interruptible_color')
	notInterruptibleColor:SetPoint('TOP', castingColor, 'BOTTOM', 0, -16)

	local completeColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'casting_complete_color')
	completeColor:SetPoint('TOP', notInterruptibleColor, 'BOTTOM', 0, -16)

	local failColor = GUI:CreateColorSwatch(castbarColorSide, 'unitframe', 'casting_fail_color')
	failColor:SetPoint('TOP', completeColor, 'BOTTOM', 0, -16)


	-- class color side panel
	local classColorSide = GUI:CreateSidePanel(parent, 'classColorSide')

	local deathknight = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'DEATHKNIGHT')
	deathknight:SetPoint('TOPLEFT', classColorSide.child, 'TOPLEFT', 10, -10)

	local warrior = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'WARRIOR')
	warrior:SetPoint('TOP', deathknight, 'BOTTOM', 0, -16)

	local paladin = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'PALADIN')
	paladin:SetPoint('TOP', warrior, 'BOTTOM', 0, -16)

	local mage = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'MAGE')
	mage:SetPoint('TOP', paladin, 'BOTTOM', 0, -16)

	local priest = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'PRIEST')
	priest:SetPoint('TOP', mage, 'BOTTOM', 0, -16)

	local hunter = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'HUNTER')
	hunter:SetPoint('TOP', priest, 'BOTTOM', 0, -16)

	local warlock = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'WARLOCK')
	warlock:SetPoint('TOP', hunter, 'BOTTOM', 0, -16)

	local demonhunter = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'DEMONHUNTER')
	demonhunter:SetPoint('TOP', warlock, 'BOTTOM', 0, -16)

	local rogue = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'ROGUE')
	rogue:SetPoint('TOP', demonhunter, 'BOTTOM', 0, -16)

	local druid = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'DRUID')
	druid:SetPoint('TOP', rogue, 'BOTTOM', 0, -16)

	local monk = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'MONK')
	monk:SetPoint('TOP', druid, 'BOTTOM', 0, -16)

	local shaman = GUI:CreateColorSwatch(classColorSide, 'CLASS_COLORS', 'SHAMAN')
	shaman:SetPoint('TOP', monk, 'BOTTOM', 0, -16)

	local reactionHostile = GUI:CreateColorSwatch(classColorSide, 'REACTION_COLORS', 'hostile')
	reactionHostile:SetPoint('TOP', shaman, 'BOTTOM', 0, -32)

	local reactionNeutral = GUI:CreateColorSwatch(classColorSide, 'REACTION_COLORS', 'neutral')
	reactionNeutral:SetPoint('TOP', reactionHostile, 'BOTTOM', 0, -16)

	local reactionFriendly = GUI:CreateColorSwatch(classColorSide, 'REACTION_COLORS', 'friendly')
	reactionFriendly:SetPoint('TOP', reactionNeutral, 'BOTTOM', 0, -16)


	-- castbar size side panel
	local castbarSizeSide = GUI:CreateSidePanel(parent, 'castbarSizeSide')

	local castbarFocusWidth = GUI:CreateSlider(castbarSizeSide, 'unitframe', 'castbar_focus_width', nil, {100, 400, 1})
	castbarFocusWidth:SetPoint('TOP', castbarSizeSide.child, 'TOP', 0, -24)

	local castbarFocusHeight = GUI:CreateSlider(castbarSizeSide, 'unitframe', 'castbar_focus_height', nil, {8, 30, 1})
	castbarFocusHeight:SetPoint('TOP', castbarFocusWidth, 'BOTTOM', 0, -56)


	-- range check alpha side panel
	local rangeCheckAlphaSide = GUI:CreateSidePanel(parent, 'rangeCheckAlphaSide')

	local rangeCheckAlpha = GUI:CreateSlider(rangeCheckAlphaSide, 'unitframe', 'range_check_alpha', nil, {0.3, 1, 0.1})
	rangeCheckAlpha:SetPoint('TOP', rangeCheckAlphaSide.child, 'TOP', 0, -24)


	-- combat fader alpha side panel
	local combatFaderSide = GUI:CreateSidePanel(parent, 'combatFaderSide')

	local combatFaderAlpha = GUI:CreateSlider(combatFaderSide, 'unitframe', 'fader_alpha', nil, {0, 1, 0.1})
	combatFaderAlpha:SetPoint('TOP', combatFaderSide.child, 'TOP', 0, -24)

	local faderSmooth = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_smooth')
	faderSmooth:SetPoint('TOPLEFT', combatFaderSide.child, 'TOPLEFT', 10, -80)

	local faderHover = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_hover')
	faderHover:SetPoint('TOPLEFT', faderSmooth, 'BOTTOMLEFT', 0, -8)

	local faderArena = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_arena')
	faderArena:SetPoint('TOPLEFT', faderHover, 'BOTTOMLEFT', 0, -8)

	local faderInstance = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_instance')
	faderInstance:SetPoint('TOPLEFT', faderArena, 'BOTTOMLEFT', 0, -8)

	local faderCombat = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_combat')
	faderCombat:SetPoint('TOPLEFT', faderInstance, 'BOTTOMLEFT', 0, -8)

	local faderTarget = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_target')
	faderTarget:SetPoint('TOPLEFT', faderCombat, 'BOTTOMLEFT', 0, -8)

	local faderCasting = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_casting')
	faderCasting:SetPoint('TOPLEFT', faderTarget, 'BOTTOMLEFT', 0, -8)

	local faderInjured = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_injured')
	faderInjured:SetPoint('TOPLEFT', faderCasting, 'BOTTOMLEFT', 0, -8)

	local faderMana = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_mana')
	faderMana:SetPoint('TOPLEFT', faderInjured, 'BOTTOMLEFT', 0, -8)

	local faderPower = GUI:CreateCheckBox(combatFaderSide, 'unitframe', 'fader_power')
	faderPower:SetPoint('TOPLEFT', faderMana, 'BOTTOMLEFT', 0, -8)


	-- class power side panel
	local classPowerSide = GUI:CreateSidePanel(parent, 'classPowerSide')

	local comboPoints = GUI:CreateColorSwatch(classPowerSide, 'CLASS_POWER_COLORS', 'combo_points')
	comboPoints:SetPoint('TOPLEFT', classPowerSide.child, 'TOPLEFT', 10, -10)

	local soulShards = GUI:CreateColorSwatch(classPowerSide, 'CLASS_POWER_COLORS', 'soul_shards')
	soulShards:SetPoint('TOP', comboPoints, 'BOTTOM', 0, -16)

	local holyPower = GUI:CreateColorSwatch(classPowerSide, 'CLASS_POWER_COLORS', 'holy_power')
	holyPower:SetPoint('TOP', soulShards, 'BOTTOM', 0, -16)

	local arcaneCharges = GUI:CreateColorSwatch(classPowerSide, 'CLASS_POWER_COLORS', 'arcane_charges')
	arcaneCharges:SetPoint('TOP', holyPower, 'BOTTOM', 0, -16)

	local chiOrbs = GUI:CreateColorSwatch(classPowerSide, 'CLASS_POWER_COLORS', 'chi_orbs')
	chiOrbs:SetPoint('TOP', arcaneCharges, 'BOTTOM', 0, -16)

	local bloodRunes = GUI:CreateColorSwatch(classPowerSide, 'RUNE_COLORS', 'blood')
	bloodRunes:SetPoint('TOP', chiOrbs, 'BOTTOM', 0, -32)

	local frostRunes = GUI:CreateColorSwatch(classPowerSide, 'RUNE_COLORS', 'frost')
	frostRunes:SetPoint('TOP', bloodRunes, 'BOTTOM', 0, -16)

	local unholyRunes = GUI:CreateColorSwatch(classPowerSide, 'RUNE_COLORS', 'unholy')
	unholyRunes:SetPoint('TOP', frostRunes, 'BOTTOM', 0, -16)






end

local function NamePlateOptions()
	local parent = FreeUI_GUI[13]

	local basic = GUI:AddSubCategory(parent, L['NAMEPLATE_SUB_BASIC'])
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local enable = GUI:CreateCheckBox(parent, 'nameplate', 'enable', nil, SetupPlateSize)
	enable:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local targetIndicator = GUI:CreateCheckBox(parent, 'nameplate', 'target_indicator', RefreshNameplates)
	targetIndicator:SetPoint('TOPLEFT', enable, 'BOTTOMLEFT', 0, -8)

	local threatIndicator = GUI:CreateCheckBox(parent, 'nameplate', 'threat_indicator', RefreshNameplates)
	threatIndicator:SetPoint('LEFT', targetIndicator, 'RIGHT', 160, 0)

	local classifyIndicator = GUI:CreateCheckBox(parent, 'nameplate', 'classify_indicator', RefreshNameplates)
	classifyIndicator:SetPoint('TOPLEFT', targetIndicator, 'BOTTOMLEFT', 0, -8)

	local explosiveScale = GUI:CreateCheckBox(parent, 'nameplate', 'explosive_scale', RefreshNameplates)
	explosiveScale:SetPoint('LEFT', classifyIndicator, 'RIGHT', 160, 0)

	local interruptName = GUI:CreateCheckBox(parent, 'nameplate', 'interrupt_name', RefreshNameplates)
	interruptName:SetPoint('TOPLEFT', classifyIndicator, 'BOTTOMLEFT', 0, -8)

	local plateAura = GUI:CreateCheckBox(parent, 'nameplate', 'plate_auras', RefreshNameplates, SetupPlateAura)
	plateAura:SetPoint('LEFT', interruptName, 'RIGHT', 160, 0)


	local colors = GUI:AddSubCategory(parent, L['NAMEPLATE_SUB_COLOR'])
	colors:SetPoint('TOPLEFT', interruptName, 'BOTTOMLEFT', 0, -16)

	local hostileCC = GUI:CreateCheckBox(parent, 'nameplate', 'hostile_class_color')
	hostileCC:SetPoint('TOPLEFT', colors, 'BOTTOMLEFT', 0, -8)

	local friendlyCC = GUI:CreateCheckBox(parent, 'nameplate', 'friendly_class_color')
	friendlyCC:SetPoint('LEFT', hostileCC, 'RIGHT', 160, 0)

	local tankMode = GUI:CreateCheckBox(parent, 'nameplate', 'tank_mode', nil, SetupThreatColors)
	tankMode:SetPoint('TOPLEFT', hostileCC, 'BOTTOMLEFT', 0, -8)

	local reverThreat = GUI:CreateCheckBox(parent, 'nameplate', 'dps_revert_threat')
	reverThreat:SetPoint('LEFT', tankMode, 'RIGHT', 160, 0)

	tankMode.sub = {reverThreat}

	local customPlate = GUI:CreateCheckBox(parent, 'nameplate', 'custom_unit_color', UpdateNameplateCustomUnitList, SetupCustomPlate)
	customPlate:SetPoint('TOPLEFT', tankMode, 'BOTTOMLEFT', 0, -8)


	local cvars = GUI:AddSubCategory(parent, L['NAMEPLATE_SUB_CVARS'])
	cvars:SetPoint('TOPLEFT', customPlate, 'BOTTOMLEFT', 0, -16)

	local minScale = GUI:CreateSlider(parent, 'nameplate', 'min_scale', UpdateNameplateCVars, {0.1, 1, 0.1})
	minScale:SetPoint('TOPLEFT', cvars, 'BOTTOMLEFT', 0, -32)

	local targetScale = GUI:CreateSlider(parent, 'nameplate', 'target_scale', UpdateNameplateCVars, {1, 2, 0.1})
	targetScale:SetPoint('LEFT', minScale, 'RIGHT', 20, 0)

	local minAlpha = GUI:CreateSlider(parent, 'nameplate', 'min_alpha', UpdateNameplateCVars, {0.1, 1, 0.1})
	minAlpha:SetPoint('TOPLEFT', minScale, 'BOTTOMLEFT', 0, -56)

	local occludedAlpha = GUI:CreateSlider(parent, 'nameplate', 'occluded_alpha', UpdateNameplateCVars, {0.1, 1, 0.1})
	occludedAlpha:SetPoint('LEFT', minAlpha, 'RIGHT', 20, 0)

	local verticalSpacing = GUI:CreateSlider(parent, 'nameplate', 'vertical_spacing', UpdateNameplateCVars, {0.1, 2, 0.1})
	verticalSpacing:SetPoint('TOPLEFT', minAlpha, 'BOTTOMLEFT', 0, -56)

	local horizontalSpacing = GUI:CreateSlider(parent, 'nameplate', 'horizontal_spacing', UpdateNameplateCVars, {0.1, 2, 0.1})
	horizontalSpacing:SetPoint('LEFT', verticalSpacing, 'RIGHT', 20, 0)

	local maxDistance = GUI:CreateSlider(parent, 'nameplate', 'max_distance', UpdateNameplateCVars, {40, 60, 1})
	maxDistance:SetPoint('TOPLEFT', verticalSpacing, 'BOTTOMLEFT', 0, -56)


	-- plate size side panel
	local plateSizeSide = GUI:CreateSidePanel(parent, 'plateSizeSide')

	local plateWidth = GUI:CreateSlider(plateSizeSide, 'nameplate', 'plate_width', RefreshNameplates, {40, 200, 1})
	plateWidth:SetPoint('TOP', plateSizeSide.child, 'TOP', 0, -24)

	local plateHeight = GUI:CreateSlider(plateSizeSide, 'nameplate', 'plate_height', RefreshNameplates, {6, 30, 1})
	plateHeight:SetPoint('TOP', plateWidth, 'BOTTOM', 0, -56)





	CreateNamePlateAuraFilter(parent)


	-- custom unit side panel
	local customPlateSide = GUI:CreateSidePanel(parent, 'customPlateSide')

	local customColor = GUI:CreateColorSwatch(customPlateSide, 'nameplate', 'custom_color')
	customColor:SetPoint('TOPLEFT', customPlateSide.child, 'TOPLEFT', 10, -10)

	local unitList = GUI:CreateEditBox(customPlateSide, 'nameplate', 'custom_unit_list', UpdateNameplateCustomUnitList, {140, 140, 999, true})
	unitList:SetPoint('TOPLEFT', customPlateSide.child, 'TOPLEFT', 10, -60)




	-- plate threat color side panel
	local threatColorsSide = GUI:CreateSidePanel(parent, 'threatColorsSide')

	local secureColor = GUI:CreateColorSwatch(threatColorsSide, 'nameplate', 'secure_color')
	secureColor:SetPoint('TOPLEFT', threatColorsSide.child, 'TOPLEFT', 10, -10)

	local transColor = GUI:CreateColorSwatch(threatColorsSide, 'nameplate', 'trans_color')
	transColor:SetPoint('TOP', secureColor, 'BOTTOM', 0, -16)

	local insecureColor = GUI:CreateColorSwatch(threatColorsSide, 'nameplate', 'insecure_color')
	insecureColor:SetPoint('TOP', transColor, 'BOTTOM', 0, -16)

	local offTankColor = GUI:CreateColorSwatch(threatColorsSide, 'nameplate', 'off_tank_color')
	offTankColor:SetPoint('TOP', insecureColor, 'BOTTOM', 0, -16)
end

local function MiscOptions()
	local parent = FreeUI_GUI[14]

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)


	local hideBossBanner = GUI:CreateCheckBox(parent, 'blizzard', 'hide_boss_banner')
	hideBossBanner:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 0, -8)

	local hideTalkingHead = GUI:CreateCheckBox(parent, 'blizzard', 'hide_talking_head')
	hideTalkingHead:SetPoint('LEFT', hideBossBanner, 'RIGHT', 160, 0)

	local mailButton = GUI:CreateCheckBox(parent, 'blizzard', 'mail_button')
	mailButton:SetPoint('TOPLEFT', hideBossBanner, 'BOTTOMLEFT', 0, -8)

	local undressButton = GUI:CreateCheckBox(parent, 'blizzard', 'undress_button')
	undressButton:SetPoint('LEFT', mailButton, 'RIGHT', 160, 0)


	--[[ local keyword = GUI:CreateEditBox(parent, 'misc', 'invite_keyword', nil, {60, 20, 5, false})
	keyword:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 20, -40)

	local numberFormat = GUI:CreateDropDown(parent, 'misc', 'number_format', nil, {L['GUI_NUMBER_FORMAT_EN'], L['GUI_NUMBER_FORMAT_CN']}, L['GUI_NUMBER_FORMAT'])
	numberFormat:SetPoint('LEFT', keyword, 'RIGHT', 80, 0) ]]
end

local function DataOptions()
	local parent = FreeUI_GUI[15]
	parent.tab.text:SetTextColor(F.HexToRGB('bd3a49'))

	local basic = GUI:AddSubCategory(parent)
	basic:SetPoint('TOPLEFT', parent.desc, 'BOTTOMLEFT', 0, -8)

	local btnExport = F.CreateButton(parent, 80, 26, L['GUI_DATA_EXPORT'])
	btnExport:SetPoint('TOPLEFT', basic, 'BOTTOMLEFT', 10, -20)
	btnExport:SetScript('OnClick', function()
		if FreeUI_GUI then FreeUI_GUI:Hide() end

		GUI:CreateDataFrame()
		FreeUI_Data.Header:SetText(L['GUI_DATA_EXPORT_HEADER'])
		FreeUI_Data.text:SetText(OKAY)
		GUI:ExportData()
	end)

	btnExport:SetScript('OnEnter', function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(btnExport, 'ANCHOR_NONE')
		GameTooltip:SetPoint('BOTTOM', btnExport, 'TOP', 0, 10)
		GameTooltip:AddLine(L.GUI.HINT)
		GameTooltip:AddLine(L['GUI_DATA_EXPORT_TIP'], .6, .8, 1, 1)
		GameTooltip:Show()
	end)
	btnExport:SetScript('OnLeave', F.HideTooltip)

	local btnImport = F.CreateButton(parent, 80, 26, L['GUI_DATA_IMPORT'])
	btnImport:SetPoint('LEFT', btnExport, 'RIGHT', 10, 0)
	btnImport:SetScript('OnClick', function()
		if FreeUI_GUI then FreeUI_GUI:Hide() end

		GUI:CreateDataFrame()
		FreeUI_Data.Header:SetText(L['GUI_DATA_IMPORT_HEADER'])
		FreeUI_Data.text:SetText(L['GUI_DATA_IMPORT'])
		FreeUI_Data.editBox:SetText('')
	end)

	btnImport:SetScript('OnEnter', function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(btnImport, 'ANCHOR_NONE')
		GameTooltip:SetPoint('BOTTOM', btnImport, 'TOP', 0, 10)
		GameTooltip:AddLine(L.GUI.HINT)
		GameTooltip:AddLine(L['GUI_DATA_IMPORT_TIP'], .6, .8, 1, 1)
		GameTooltip:Show()
	end)
	btnImport:SetScript('OnLeave', F.HideTooltip)

	local btnReset = F.CreateButton(parent, 80, 26, L['GUI_DATA_RESET'])
	btnReset:SetPoint('LEFT', btnImport, 'RIGHT', 10, 0)
	btnReset:SetScript('OnClick', function()
		if FreeUI_GUI then FreeUI_GUI:Hide() end

		StaticPopup_Show('FREEUI_RESET_OPTIONS')
	end)

	btnReset:SetScript('OnEnter', function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(btnReset, 'ANCHOR_NONE')
		GameTooltip:SetPoint('BOTTOM', btnReset, 'TOP', 0, 10)
		GameTooltip:AddLine(L.GUI.HINT)
		GameTooltip:AddLine(L['GUI_DATA_RESET_TIP'], .6, .8, 1, 1)
		GameTooltip:Show()
	end)
	btnReset:SetScript('OnLeave', F.HideTooltip)


	local buttons = {btnExport, btnImport, btnReset}
	for _, button in pairs(buttons) do
		F.Reskin(button)
	end
end

local function CreditsOptions()
	local parent = FreeUI_GUI[16]
	parent.tab.text:SetTextColor(F.HexToRGB('507ab5'))

end


function GUI:AddOptions()
	ActionbarOptions()

	AppearanceOptions()

	NotificationOptions()

	InfobarOptions()
	ChatOptions()
	AuraOptions()

	CombatOptions()
	InventoryOptions()
	MapOptions()
	QuestOptions()
	TooltipOptions()
	UnitframeOptions()
	NamePlateOptions()
	MiscOptions()
	DataOptions()
	CreditsOptions()
end







