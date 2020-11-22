local F, C, L = unpack(select(2, ...))
local GUI = F.GUI

local extraGUIs = {}
local function toggleExtraGUI(guiName)
	for name, frame in pairs(extraGUIs) do
		if name == guiName then
			F:TogglePanel(frame)
		else
			frame:Hide()
		end
	end
end

local function hideExtraGUIs()
	for _, frame in pairs(extraGUIs) do
		frame:Hide()
	end
end

local function createExtraGUI(parent, name, title, bgFrame)
	local frame = CreateFrame('Frame', name, parent)
	frame:SetSize(260, 640)
	frame:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)
	F.SetBD(frame)

	if title then
		F.CreateFS(frame, C.Assets.Fonts.Regular, 14, nil, title, 'YELLOW', true, 'TOPLEFT', 10, -25)
	end

	if bgFrame then
		frame.bg = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
		frame.bg:SetSize(240, 540)
		frame.bg:SetPoint('TOPLEFT', 10, -50)
		F.CreateBDFrame(frame.bg, .25, false, .04, .04, .04)
	end

	if not parent.extraGUIHook then
		parent:HookScript('OnHide', hideExtraGUIs)
		parent.extraGUIHook = true
	end
	extraGUIs[name] = frame

	return frame
end

local function createOptionCheck(parent, offset, text)
	local box = F.CreateCheckBox(parent, true)
	box:SetSize(20, 20)
	box:SetHitRectInsets(-5, -5, -5, -5)
	box:SetPoint('TOPLEFT', 20, -offset)
	F.CreateFS(box, C.Assets.Fonts.Regular, 12, nil, text, nil, true, 'LEFT', 22, 0)
	return box
end

local function sortBars(barTable)
	local num = 1
	for _, bar in pairs(barTable) do
		bar:SetPoint('TOPLEFT', 10, -10 - 35 * (num - 1))
		num = num + 1
	end
end

local function labelOnEnter(self)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self:GetParent(), 'ANCHOR_RIGHT', 0, 3)
	GameTooltip:AddLine(self.text)
	GameTooltip:AddLine(self.tip, .6, .8, 1, 1)
	GameTooltip:Show()
end

local function createLabel(parent, text, tip)
	local label = F.CreateFS(parent, C.Assets.Fonts.Regular, 12, nil, text, 'YELLOW', true, 'CENTER', 0, 25)
	if not tip then
		return
	end
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetAllPoints(label)
	frame.text = text
	frame.tip = tip
	frame:SetScript('OnEnter', labelOnEnter)
	frame:SetScript('OnLeave', F.HideTooltip)
end

local function clearEdit(options)
	for i = 1, #options do
		GUI:ClearEdit(options[i])
	end
end

function GUI:CreateDropdown(parent, text, x, y, data, tip, width, height)
	local dd = F.CreateDropDown(parent, width or 90, height or 30, data)
	dd:SetPoint('TOPLEFT', x, y)
	createLabel(dd, text, tip)

	return dd
end

function GUI:ClearEdit(element)
	if element.Type == 'EditBox' then
		element:ClearFocus()
		element:SetText('')
	elseif element.Type == 'CheckBox' then
		element:SetChecked(false)
	elseif element.Type == 'DropDown' then
		element.Text:SetText('')
		for i = 1, #element.options do
			element.options[i].selected = false
		end
	end
end

function GUI:CreateEditbox(parent, text, x, y, tip, width, height)
	local eb = F.CreateEditBox(parent, width or 90, height or 30)
	eb:SetPoint('TOPLEFT', x, y)
	eb:SetMaxLetters(255)
	createLabel(eb, text, tip)

	return eb
end

function GUI:CreateScroll(parent, width, height, text)
	local scroll = CreateFrame('ScrollFrame', nil, parent, 'UIPanelScrollFrameTemplate')
	scroll:SetSize(width, height)
	scroll:SetPoint('TOPLEFT', 10, -50)
	F.CreateBDFrame(scroll, .25, false, .04, .04, .04)
	if text then
		F.CreateFS(scroll, C.Assets.Fonts.Regular, 12, 'OUTLINE', text, nil, true, 'TOPLEFT', 5, 20)
	end
	scroll.child = CreateFrame('Frame', nil, scroll)
	scroll.child:SetSize(width, 1)
	scroll:SetScrollChild(scroll.child)
	F.ReskinScroll(scroll.ScrollBar)

	return scroll
end

function GUI:CreateBarWidgets(parent, texture)
	local icon = CreateFrame('Frame', nil, parent)
	icon:SetSize(16, 16)
	icon:SetPoint('LEFT', 5, 0)
	F.PixelIcon(icon, texture, true)

	local close = CreateFrame('Button', nil, parent)
	close:SetSize(16, 16)
	close:SetPoint('RIGHT', -5, 0)
	close.Icon = close:CreateTexture(nil, 'ARTWORK')
	close.Icon:SetAllPoints()
	close.Icon:SetTexture(C.Assets.close_tex)
	close.Icon:SetVertexColor(1, 0, 0)
	close:SetHighlightTexture(close.Icon:GetTexture())

	return icon, close
end

local function createOptionTitle(parent, title, offset)
	F.CreateFS(parent, C.Assets.Fonts.Regular, 14, nil, title, 'YELLOW', true, 'TOP', 0, offset)
	local line = F.SetGradient(parent, 'H', .5, .5, .5, .25, .25, 160, C.Mult)
	line:SetPoint('TOPLEFT', 30, offset - 20)
end

local function createOptionSwatch(parent, name, value, x, y)
	local swatch = F.CreateColorSwatch(parent, name, value)
	swatch:SetPoint('TOPLEFT', x, y)
	-- swatch.text:SetTextColor(1, .8, 0)
end

local function sliderValueChanged(self, v)
	local current
	if self.__step < 1 then
		current = tonumber(format('%.1f', v))
	else
		current = tonumber(format('%.0f', v))
	end

	self.value:SetText(current)
	C.DB['unitframe'][self.__value] = current
	self.__update()
end

local function createOptionSlider(parent, title, minV, maxV, step, defaultV, x, y, value, func)
	local slider = F.CreateSlider(parent, title, minV, maxV, step, x, y, 180)
	slider:SetValue(C.DB['unitframe'][value])
	slider.value:SetText(C.DB['unitframe'][value])
	slider.__value = value
	slider.__update = func
	slider.__default = defaultV
	slider.__step = step
	slider:SetScript('OnValueChanged', sliderValueChanged)
end

function GUI:SetupInventoryFilter(parent)
	local guiName = 'FreeUI_GUI_Inventory_Filter'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.INVENTORY.FILTER_SETUP)
	local scroll = GUI:CreateScroll(panel, 220, 540)
	scroll:ClearAllPoints()
	scroll:SetPoint('TOPLEFT', 10, -50)

	local filterOptions = {
		[1] = 'item_filter_junk',
		[2] = 'item_filter_consumable',
		[3] = 'item_filter_azerite',
		[4] = 'item_filter_equipment',
		[5] = 'item_filter_gear_set',
		[6] = 'item_filter_legendary',
		[7] = 'item_filter_mount_pet',
		[8] = 'item_filter_favourite',
		[9] = 'item_filter_trade',
		[10] = 'item_filter_quest'
	}

	local function filterOnClick(self)
		local value = self.__value
		C.DB['inventory'][value] = not C.DB['inventory'][value]
		self:SetChecked(C.DB['inventory'][value])
		GUI.UpdateInventoryStatus()
	end

	local offset = 20
	for _, value in ipairs(filterOptions) do
		local box = createOptionCheck(scroll, offset, L.GUI.INVENTORY[strupper(value)])
		box:SetChecked(C.DB['inventory'][value])
		box.__value = value
		box:SetScript('OnClick', filterOnClick)

		offset = offset + 35
	end
end

function GUI:SetupActionBarFader(parent)
	local guiName = 'FreeUI_GUI_Actionbar_Fader'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.ACTIONBAR.FADER_SETUP)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local faderValues = {0, 1, .3, .3}

	local function Update()
		F.ACTIONBAR:UpdateActionBarFade()
	end

	local function sliderValuesChanged(self, v)
		local current = tonumber(format('%.1f', v))
		self.value:SetText(current)
		C.DB['actionbar'][self.__value] = current
		self.__update()
	end

	local function createOptionSliders(parent, title, minV, maxV, step, defaultV, x, y, value, func)
		local slider = F.CreateSlider(parent, title, minV, maxV, step, x, y, 180)
		slider:SetValue(C.DB['actionbar'][value])
		slider.value:SetText(C.DB['actionbar'][value])
		slider.__value = value
		slider.__update = func
		slider.__default = defaultV
		slider:SetScript('OnValueChanged', sliderValuesChanged)
	end

	local filterOptions = {
		[1] = 'condition_combating',
		[2] = 'condition_targeting',
		[3] = 'condition_dungeon',
		[4] = 'condition_pvp',
		[5] = 'condition_vehicle'
	}

	local function filterOnClick(self)
		local value = self.__value
		C.DB['actionbar'][value] = not C.DB['actionbar'][value]
		self:SetChecked(C.DB['actionbar'][value])
		GUI.UpdateInventoryStatus()
	end

	local offset = 20
	for _, value in ipairs(filterOptions) do
		local box = createOptionCheck(scroll.child, offset, L.GUI.ACTIONBAR[strupper(value)])
		box:SetChecked(C.DB['actionbar'][value])
		box.__value = value
		box:SetScript('OnClick', filterOnClick)

		offset = offset + 35
	end

	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_OUT_ALPHA, 0, 1, .1, faderValues[1], 20, -offset - 20, 'fade_out_alpha', Update)
	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_IN_ALPHA, 0, 1, .1, faderValues[2], 20, -offset - 100, 'fade_in_alpha', Update)
	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_OUT_DURATION, 0, 1, .1, faderValues[3], 20, -offset - 180, 'fade_out_duration', Update)
	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_IN_DURATION, 0, 1, .1, faderValues[4], 20, -offset - 260, 'fade_in_duration', Update)
end

function GUI:NamePlateAuraFilter(parent)
	local guiName = 'FreeUI_GUI_NamePlate_Aura_Filter'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName)

	local frameData = {
		[1] = {
			text = L.GUI.NAMEPLATE.AURA_WHITE_LIST,
			tip = L.GUI.NAMEPLATE.AURA_WHITE_LIST_TIP,
			offset = -25,
			barList = {}
		},
		[2] = {
			text = L.GUI.NAMEPLATE.AURA_BLACK_LIST,
			tip = L.GUI.NAMEPLATE.AURA_BLACK_LIST_TIP,
			offset = -315,
			barList = {}
		}
	}

	local function createBar(parent, index, spellID)
		local name, _, texture = GetSpellInfo(spellID)
		local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
		bar:SetSize(180, 30)
		F.CreateBD(bar, .3)
		frameData[index].barList[spellID] = bar

		local icon, close = GUI:CreateBarWidgets(bar, texture)
		F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
		close:SetScript(
			'OnClick',
			function()
				bar:Hide()
				FREE_ADB['nameplate_aura_filter_list'][index][spellID] = nil
				frameData[index].barList[spellID] = nil
				sortBars(frameData[index].barList)
			end
		)

		local spellName = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 30, 0)
		spellName:SetWidth(180)
		spellName:SetJustifyH('LEFT')
		if index == 2 then
			spellName:SetTextColor(1, 0, 0)
		end

		sortBars(frameData[index].barList)
	end

	local function addClick(parent, index)
		local spellID = tonumber(parent.box:GetText())
		if not spellID or not GetSpellInfo(spellID) then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.NAMEPLATE.AURA_INCORRECT_ID)
			return
		end
		if FREE_ADB['nameplate_aura_filter_list'][index][spellID] then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.NAMEPLATE.AURA_EXISTING_ID)
			return
		end

		FREE_ADB['nameplate_aura_filter_list'][index][spellID] = true
		createBar(parent.child, index, spellID)
		parent.box:SetText('')
	end

	for index, value in ipairs(frameData) do
		F.CreateFS(panel, C.Assets.Fonts.Regular, 14, nil, value.text, 'YELLOW', true, 'TOPLEFT', 20, value.offset)
		local frame = CreateFrame('Frame', nil, panel, 'BackdropTemplate')
		frame:SetSize(240, 250)
		frame:SetPoint('TOPLEFT', 10, value.offset - 25)
		F.CreateBD(frame, .3)

		local scroll = GUI:CreateScroll(frame, 200, 200)
		scroll:ClearAllPoints()
		scroll:SetPoint('BOTTOMLEFT', 10, 10)
		scroll.box = F.CreateEditBox(frame, 145, 25)
		scroll.box:SetPoint('TOPLEFT', 10, -10)
		F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', value.tip, 'BLUE')
		scroll.add = F.CreateButton(frame, 70, 25, ADD)
		scroll.add:SetPoint('TOPRIGHT', -8, -10)
		scroll.add:SetScript(
			'OnClick',
			function()
				addClick(scroll, index)
			end
		)

		for spellID in pairs(FREE_ADB['nameplate_aura_filter_list'][index]) do
			createBar(scroll.child, index, spellID)
		end
	end
end

function GUI:SetupUnitFrameSize(parent)
	local guiName = 'FreeUI_GUI_Unitframe_Setup'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.UNITFRAME.UNITFRAME_SIZE_SETTING_HEADER)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local sliderRange = {
		['player'] = {50, 300},
		['target'] = {50, 300},
		['focus'] = {50, 300},
		['pet'] = {50, 300},
		['boss'] = {50, 300},
		['arena'] = {50, 300}
	}

	local defaultValue = {
		['player'] = {120, 8},
		['target'] = {160, 8},
		['focus'] = {60, 8},
		['pet'] = {50, 8},
		['boss'] = {120, 20},
		['arena'] = {120, 16}
	}

	local function UpdateSize(self, unit)
	end

	local function createOptionGroup(parent, title, offset, value, func)
		createOptionTitle(parent, title, offset)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_WIDTH, sliderRange[value][1], sliderRange[value][2], 1, defaultValue[value][1], 20, offset - 60, value .. '_width', func)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_HEIGHT, 4, 20, 1, defaultValue[value][2], 20, offset - 130, value .. '_height', func)
	end

	local function createPowerOptionGroup(parent, title, offset, value, func)
		createOptionTitle(parent, title, offset)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_POWER_HEIGHT, 1, 10, 1, 1, 20, offset - 60, 'power_bar_height', func)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_ALT_POWER_HEIGHT, 1, 10, 1, 2, 20, offset - 130, 'alt_power_height', func)
	end

	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_PLAYER, -10, 'player', UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_TARGET, -210, 'target', UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_FOCUS, -410, 'focus', UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_PET, -610, 'pet', UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_BOSS, -810, 'boss', UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_ARENA, -1010, 'arena', UpdateSize)
	createPowerOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_POWER, -1210, nil, UpdateSize)
end

function GUI:SetupGroupFrameSize(parent)
	local guiName = 'FreeUI_GUI_Groupframe_Setup'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.UNITFRAME.GROUPFRAME_SIZE_SETTING_HEADER)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local sliderRange = {['party'] = {20, 100}, ['raid'] = {20, 100}}

	local defaultValue = {['party'] = {62, 28, 6}, ['raid'] = {28, 20, 5}}

	local function UpdateSize(self, unit)
	end

	local function createOptionGroup(parent, title, offset, value, func)
		createOptionTitle(parent, title, offset)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_WIDTH, sliderRange[value][1], sliderRange[value][2], 1, defaultValue[value][1], 20, offset - 60, value .. '_width', func)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_HEIGHT, sliderRange[value][1], sliderRange[value][2], 1, defaultValue[value][2], 20, offset - 130, value .. '_height', func)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_GAP, 5, 10, 1, defaultValue[value][3], 20, offset - 200, value .. '_gap', func)
	end

	createOptionGroup(scroll.child, L.GUI.GROUPFRAME.CAT_PARTY, -10, 'party', UpdateSize)
	createOptionGroup(scroll.child, L.GUI.GROUPFRAME.CAT_RAID, -280, 'raid', UpdateSize)
end

function GUI:SetupUnitFrameFader(parent)
	local guiName = 'FreeUI_GUI_Unitframe_Fader'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.UNITFRAME.FADER_SETTING_HEADER)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local faderValues = {0, 1, .3, .3}

	local function Update()
	end

	local filterOptions = {
		[1] = 'condition_combat',
		[2] = 'condition_target',
		[3] = 'condition_instance',
		[4] = 'condition_arena',
		[5] = 'condition_casting',
		[6] = 'condition_injured',
		[7] = 'condition_mana',
		[8] = 'condition_power'
	}

	local function filterOnClick(self)
		local value = self.__value
		C.DB['unitframe'][value] = not C.DB['unitframe'][value]
		self:SetChecked(C.DB['unitframe'][value])
		GUI.UpdateInventoryStatus()
	end

	local offset = 20
	for _, value in ipairs(filterOptions) do
		local box = createOptionCheck(scroll.child, offset, L.GUI.UNITFRAME[strupper(value)])
		box:SetChecked(C.DB['unitframe'][value])
		box.__value = value
		box:SetScript('OnClick', filterOnClick)

		offset = offset + 35
	end

	createOptionSlider(scroll.child, L.GUI.UNITFRAME.FADE_OUT_ALPHA, 0, 1, .1, faderValues[1], 20, -offset - 20, 'fade_out_alpha', Update)
	createOptionSlider(scroll.child, L.GUI.UNITFRAME.FADE_IN_ALPHA, 0, 1, .1, faderValues[2], 20, -offset - 100, 'fade_in_alpha', Update)
	createOptionSlider(scroll.child, L.GUI.UNITFRAME.FADE_OUT_DURATION, 0, 1, .1, faderValues[3], 20, -offset - 180, 'fade_out_duration', Update)
	createOptionSlider(scroll.child, L.GUI.UNITFRAME.FADE_IN_DURATION, 0, 1, .1, faderValues[4], 20, -offset - 260, 'fade_in_duration', Update)
end

function GUI:SetupCastbar(parent)
	local guiName = 'FreeUI_GUI_Castbar_Setup'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.UNITFRAME.CASTBAR_SETTING_HEADER)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	createOptionTitle(scroll.child, L.GUI.UNITFRAME.CASTBAR_COLORS, -10)
	createOptionSwatch(scroll.child, L.GUI.UNITFRAME.CASTING_COLOR, C.DB.unitframe.casting_color, 40, -40)
	createOptionSwatch(scroll.child, L.GUI.UNITFRAME.CASTING_UNINTERRUPTIBLE_COLOR, C.DB.unitframe.casting_uninterruptible_color, 40, -70)
	createOptionSwatch(scroll.child, L.GUI.UNITFRAME.CASTING_COMPLETE_COLOR, C.DB.unitframe.casting_complete_color, 40, -100)
	createOptionSwatch(scroll.child, L.GUI.UNITFRAME.CASTING_FAIL_COLOR, C.DB.unitframe.casting_fail_color, 40, -130)

	local defaultValue = {['focus'] = {200, 16}}

	local function createOptionGroup(parent, title, offset, value, func)
		createOptionTitle(parent, title, offset)
		createOptionSlider(parent, L.GUI.UNITFRAME.CASTBAR_WIDTH, 100, 400, 1, defaultValue[value][1], 20, offset - 60, 'castbar_' .. value .. '_width', func)
		createOptionSlider(parent, L.GUI.UNITFRAME.CASTBAR_HEIGHT, 6, 30, 1, defaultValue[value][2], 20, offset - 130, 'castbar_' .. value .. '_height', func)
	end

	local function updateFocusCastbar()
	end

	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CASTBAR_FOCUS, -180, 'focus', updateFocusCastbar)
end

function GUI:SetupCustomClassColor(parent)
	local guiName = 'FreeUI_GUI_ClassColor_Setup'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.MISC.CUSTOM_CLASS_COLOR_SETTING_HEADER)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.HUNTER, FREE_ADB.class_colors_list.HUNTER, 40, -20)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.WARRIOR, FREE_ADB.class_colors_list.WARRIOR, 40, -50)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.PALADIN, FREE_ADB.class_colors_list.PALADIN, 40, -80)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.MAGE, FREE_ADB.class_colors_list.MAGE, 40, -110)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.PRIEST, FREE_ADB.class_colors_list.PRIEST, 40, -140)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.DEATHKNIGHT, FREE_ADB.class_colors_list.DEATHKNIGHT, 40, -170)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.WARLOCK, FREE_ADB.class_colors_list.WARLOCK, 40, -200)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.DEMONHUNTER, FREE_ADB.class_colors_list.DEMONHUNTER, 40, -230)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.ROGUE, FREE_ADB.class_colors_list.ROGUE, 40, -260)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.DRUID, FREE_ADB.class_colors_list.DRUID, 40, -290)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.MONK, FREE_ADB.class_colors_list.MONK, 40, -320)
	createOptionSwatch(scroll.child, LOCALIZED_CLASS_NAMES_MALE.SHAMAN, FREE_ADB.class_colors_list.SHAMAN, 40, -350)

	local function updateClassColor()
	end
end

function GUI:SetupPartySpellCooldown(parent)
	local guiName = 'FreeUI_GUI_PartySpell_Setup'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.GROUPFRAME.PARTY_SPELL_SETTING_HEADER, true)

	local barTable = {}
	local ARCANE_TORRENT = GetSpellInfo(25046)

	local function createBar(parent, spellID, duration)
		local spellName = GetSpellInfo(spellID)
		if spellName == ARCANE_TORRENT then
			return
		end
		local texture = GetSpellTexture(spellID)

		local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
		bar:SetSize(180, 30)
		F.CreateBD(bar, .3)
		barTable[spellID] = bar

		local icon, close = GUI:CreateBarWidgets(bar, texture)
		F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID, 'system')
		close:SetScript(
			'OnClick',
			function()
				bar:Hide()
				FREE_ADB['party_spells_list'][spellID] = nil
				barTable[spellID] = nil
				sortBars(barTable)
			end
		)

		local name = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, spellName, nil, true, 'LEFT', 30, 0)
		name:SetWidth(120)
		name:SetJustifyH('LEFT')

		local timer = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, duration, nil, true, 'RIGHT', -30, 0)
		timer:SetWidth(60)
		timer:SetJustifyH('RIGHT')
		timer:SetTextColor(0, 1, 0)

		sortBars(barTable)
	end

	local frame = panel.bg
	local options = {}

	options[1] = GUI:CreateEditbox(frame, L.GUI.GROUPFRAME.SPELL_ID, 10, -30, L.GUI.GROUPFRAME.SPELL_ID_TIP, 90, 24)
	options[2] = GUI:CreateEditbox(frame, L.GUI.GROUPFRAME.SPELL_COOLDOWN, 120, -30, L.GUI.GROUPFRAME.SPELL_COOLDOWN_TIP, 90, 24)

	local scroll = GUI:CreateScroll(frame, 200, 430)
	scroll:ClearAllPoints()
	scroll:SetPoint('TOPLEFT', 10, -90)
	scroll.reset = F.CreateButton(frame, 60, 24, RESET)
	scroll.reset:SetPoint('TOPLEFT', 10, -60)
	StaticPopupDialogs['PARTY_SPELL_COOLDOWN_RESET'] = {
		text = L.GUI.GROUPFRAME.PARTY_SPELL_RESET_WARNING,
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			wipe(FREE_ADB['party_spells_list'])
			ReloadUI()
		end,
		whileDead = 1
	}
	scroll.reset:SetScript(
		'OnClick',
		function()
			StaticPopup_Show('PARTY_SPELL_COOLDOWN_RESET')
		end
	)

	local function addClick(scroll, options)
		local spellID, duration = tonumber(options[1]:GetText()), tonumber(options[2]:GetText())
		if not spellID or not duration then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.INCOMPLETE_INPUT)
			return
		end
		if not GetSpellInfo(spellID) then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.INCORRECT_SPELLID)
			return
		end
		if FREE_ADB['party_spells_list'][spellID] then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.EXISTING_ID)
			return
		end

		FREE_ADB['party_spells_list'][spellID] = duration
		createBar(scroll.child, spellID, duration)
		clearEdit(options)
	end

	scroll.add = F.CreateButton(frame, 60, 24, ADD)
	scroll.add:SetPoint('TOPRIGHT', -30, -60)
	scroll.add:SetScript(
		'OnClick',
		function()
			addClick(scroll, options)
		end
	)

	scroll.clear = F.CreateButton(frame, 60, 24, KEY_NUMLOCK_MAC)
	scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -10, 0)
	scroll.clear:SetScript(
		'OnClick',
		function()
			clearEdit(options)
		end
	)

	for spellID, duration in pairs(FREE_ADB['party_spells_list']) do
		createBar(scroll.child, spellID, duration)
	end
end

local function UpdateGroupDebuffs()
	F.UNITFRAME:UpdateGroupDebuffs()
end

function GUI:SetupGroupDebuffs(parent)
	local guiName = 'NDuiGUI_RaidDebuffs'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then
		return
	end

	local panel = createExtraGUI(parent, guiName, L.GUI.GROUPFRAME.GROUP_DEBUFF_SETTING_HEADER, true)
	panel:SetScript('OnHide', UpdateGroupDebuffs)

	local setupBars
	local frame = panel.bg
	local bars, options = {}, {}

	local iType = GUI:CreateDropdown(frame, L.GUI.GROUPFRAME.TYPE, 10, -30, {DUNGEONS, RAID}, L.GUI.GROUPFRAME.TYPE_TIP, 90, 24)
	for i = 1, 2 do
		iType.options[i]:HookScript(
			'OnClick',
			function()
				for j = 1, 2 do
					GUI:ClearEdit(options[j])
					if i == j then
						options[j]:Show()
					else
						options[j]:Hide()
					end
				end

				for k = 1, #bars do
					bars[k]:Hide()
				end
			end
		)
	end

	local dungeons = {}
	for dungeonID = 1182, 1189 do
		local name = EJ_GetInstanceInfo(dungeonID)
		if name then
			tinsert(dungeons, name)
		end
	end

	local raids = {
		[1] = EJ_GetInstanceInfo(1190)
	}

	options[1] = GUI:CreateDropdown(frame, DUNGEONS, 120, -30, dungeons, L.GUI.GROUPFRAME.DUNGEON_TIP, 90, 24)
	options[1]:Hide()
	options[2] = GUI:CreateDropdown(frame, RAID, 120, -30, raids, L.GUI.GROUPFRAME.RAID_TIP, 90, 24)
	options[2]:Hide()

	options[3] = GUI:CreateEditbox(frame, L.GUI.GROUPFRAME.SPELL_ID, 10, -90, L.GUI.GROUPFRAME.SPELL_ID_TIP, 90, 24)
	options[4] = GUI:CreateEditbox(frame, L.GUI.GROUPFRAME.PRIORITY, 120, -90, L.GUI.GROUPFRAME.PRIORITY_TIP, 90, 24)

	local function analyzePrio(priority)
		priority = priority or 2
		priority = min(priority, 6)
		priority = max(priority, 1)
		return priority
	end

	local function isAuraExisted(instName, spellID)
		print(instName)
		print(spellID)
		print(C.RaidDebuffsList[instName][spellID])
		local localPrio = C.RaidDebuffsList[instName][spellID]
		local savedPrio = FREE_ADB['raid_debuffs_list'][instName] and FREE_ADB['raid_debuffs_list'][instName][spellID]
		if (localPrio and savedPrio and savedPrio == 0) or (not localPrio and not savedPrio) then
			return false
		end
		return true
	end

	local function addClick(options)
		local dungeonName, raidName, spellID, priority = options[1].Text:GetText(), options[2].Text:GetText(), tonumber(options[3]:GetText()), tonumber(options[4]:GetText())
		local instName = dungeonName or raidName
		if not instName or not spellID then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.INCOMPLETE_INPUT)
			return
		end
		if spellID and not GetSpellInfo(spellID) then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.INCORRECT_SPELLID)
			return
		end
		if isAuraExisted(instName, spellID) then
			UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.GROUPFRAME.EXISTING_ID)
			return
		end

		priority = analyzePrio(priority)
		if not FREE_ADB['raid_debuffs_list'][instName] then
			FREE_ADB['raid_debuffs_list'][instName] = {}
		end
		FREE_ADB['raid_debuffs_list'][instName][spellID] = priority
		setupBars(instName)
		GUI:ClearEdit(options[3])
		GUI:ClearEdit(options[4])
	end

	local scroll = GUI:CreateScroll(frame, 200, 380)
	scroll:ClearAllPoints()
	scroll:SetPoint('TOPLEFT', 10, -150)
	scroll.reset = F.CreateButton(frame, 60, 24, RESET)
	scroll.reset:SetPoint('TOPLEFT', 10, -120)
	StaticPopupDialogs['GROUP_DEBUFF_RESET'] = {
		text = L.GUI.GROUPFRAME.GROUP_DEBUFF_RESET_WARNING,
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			FREE_ADB['raid_debuffs_list'] = {}
			ReloadUI()
		end,
		whileDead = 1
	}
	scroll.reset:SetScript(
		'OnClick',
		function()
			StaticPopup_Show('GROUP_DEBUFF_RESET')
		end
	)
	scroll.add = F.CreateButton(frame, 60, 24, ADD)
	scroll.add:SetPoint('TOPRIGHT', -30, -120)
	scroll.add:SetScript(
		'OnClick',
		function()
			addClick(options)
		end
	)
	scroll.clear = F.CreateButton(frame, 60, 24, KEY_NUMLOCK_MAC)
	scroll.clear:SetPoint('RIGHT', scroll.add, 'LEFT', -10, 0)
	scroll.clear:SetScript(
		'OnClick',
		function()
			clearEdit(options)
		end
	)

	local function iconOnEnter(self)
		local spellID = self:GetParent().spellID
		if not spellID then
			return
		end
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:ClearLines()
		GameTooltip:SetSpellByID(spellID)
		GameTooltip:Show()
	end

	local function createBar(index, texture)
		local bar = CreateFrame('Frame', nil, scroll.child, 'BackdropTemplate')
		bar:SetSize(180, 30)
		F.CreateBD(bar, .3)
		bar.index = index

		local icon, close = GUI:CreateBarWidgets(bar, texture)
		icon:SetScript('OnEnter', iconOnEnter)
		icon:SetScript('OnLeave', F.HideTooltip)
		bar.icon = icon

		close:SetScript(
			'OnClick',
			function()
				bar:Hide()
				if C.RaidDebuffsList[bar.instName][bar.spellID] then
					if not FREE_ADB['raid_debuffs_list'][bar.instName] then
						FREE_ADB['raid_debuffs_list'][bar.instName] = {}
					end
					FREE_ADB['raid_debuffs_list'][bar.instName][bar.spellID] = 0
				else
					FREE_ADB['raid_debuffs_list'][bar.instName][bar.spellID] = nil
				end
				setupBars(bar.instName)
			end
		)

		local spellName = F.CreateFS(bar, C.Assets.Fonts.Regular, 11, nil, '', nil, true, 'LEFT', 26, 0)
		spellName:SetWidth(120)
		spellName:SetJustifyH('LEFT')
		bar.spellName = spellName

		local prioBox = F.CreateEditBox(bar, 24, 24)
		prioBox:SetPoint('RIGHT', close, 'LEFT', -1, 0)
		prioBox:SetTextInsets(10, 0, 0, 0)
		prioBox:SetMaxLetters(1)
		prioBox:SetTextColor(0, 1, 0)
		prioBox.bg:SetBackdropColor(1, 1, 1, .3)
		prioBox:HookScript(
			'OnEscapePressed',
			function(self)
				self:SetText(bar.priority)
			end
		)
		prioBox:HookScript(
			'OnEnterPressed',
			function(self)
				local prio = analyzePrio(tonumber(self:GetText()))
				if not FREE_ADB['raid_debuffs_list'][bar.instName] then
					FREE_ADB['raid_debuffs_list'][bar.instName] = {}
				end
				FREE_ADB['raid_debuffs_list'][bar.instName][bar.spellID] = prio
				self:SetText(prio)
			end
		)
		F.AddTooltip(prioBox, 'ANCHOR_RIGHT', L.GUI.GROUPFRAME.PRIORITY_EDITBOX_TIP, 'BLUE')
		bar.prioBox = prioBox

		return bar
	end

	local function applyData(index, instName, spellID, priority)
		local name, _, texture = GetSpellInfo(spellID)
		if not bars[index] then
			bars[index] = createBar(index, texture)
		end
		bars[index].instName = instName
		bars[index].spellID = spellID
		bars[index].priority = priority
		bars[index].spellName:SetText(name)
		bars[index].prioBox:SetText(priority)
		bars[index].icon.Icon:SetTexture(texture)
		bars[index]:Show()
	end

	function setupBars(self)
		local instName = self.text or self
		local index = 0

		if C.RaidDebuffsList[instName] then
			for spellID, priority in pairs(C.RaidDebuffsList[instName]) do
				if not (FREE_ADB['raid_debuffs_list'][instName] and FREE_ADB['raid_debuffs_list'][instName][spellID]) then
					index = index + 1
					applyData(index, instName, spellID, priority)
				end
			end
		end

		if FREE_ADB['raid_debuffs_list'][instName] then
			for spellID, priority in pairs(FREE_ADB['raid_debuffs_list'][instName]) do
				if priority > 0 then
					index = index + 1
					applyData(index, instName, spellID, priority)
				end
			end
		end

		for i = 1, #bars do
			if i > index then
				bars[i]:Hide()
			end
		end

		for i = 1, index do
			bars[i]:SetPoint('TOPLEFT', 10, -10 - 35 * (i - 1))
		end
	end

	for i = 1, 2 do
		for j = 1, #options[i].options do
			options[i].options[j]:HookScript('OnClick', setupBars)
		end
	end

	local function autoSelectInstance()
		local instName, instType = GetInstanceInfo()
		if instType == 'none' then
			return
		end
		for i = 1, 2 do
			local option = options[i]
			for j = 1, #option.options do
				local name = option.options[j].text
				if instName == name then
					iType.options[i]:Click()
					options[i].options[j]:Click()
				end
			end
		end
	end
	autoSelectInstance()
	panel:HookScript('OnShow', autoSelectInstance)
end
