local F, C, L = unpack(select(2, ...))
local GUI = F.GUI


local unpack, pairs, ipairs, tinsert = unpack, pairs, ipairs, tinsert
local min, max, strmatch, tonumber = min, max, strmatch, tonumber
local GetSpellInfo, GetSpellTexture = GetSpellInfo, GetSpellTexture
local GetInstanceInfo, EJ_GetInstanceInfo = GetInstanceInfo, EJ_GetInstanceInfo


local function sortBars(barTable)
	local num = 1
	for _, bar in pairs(barTable) do
		bar:SetPoint('TOPLEFT', 10, -10 - 35*(num-1))
		num = num + 1
	end
end

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
		frame.bg:SetSize(180, 540)
		frame.bg:SetPoint('TOPLEFT', 10, -50)
		F.CreateBDFrame(frame.bg, 1)
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


local function clearEdit(options)
	for i = 1, #options do
		GUI:ClearEdit(options[i])
	end
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

function GUI:CreateScroll(parent, width, height, text)
	local scroll = CreateFrame('ScrollFrame', nil, parent, 'UIPanelScrollFrameTemplate')
	scroll:SetSize(width, height)
	scroll:SetPoint('TOPLEFT', 10, -50)
	F.CreateBDFrame(scroll, .2)
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
	F.CreateFS(parent, C.Assets.Fonts.Regular, 14, nil, title, 'YELLOW', true, "TOP", 0, offset)
	local line = F.SetGradient(parent, "H", .5, .5, .5, .25, .25, 160, C.Mult)
	line:SetPoint("TOPLEFT", 30, offset-20)
end


function GUI:ItemFilter(parent)
	local guiName = 'FreeUI_GUI_Inventory_Filter'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

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
		[10] = 'item_filter_quest',
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

function GUI:ActionBarFader(parent)
	local guiName = 'FreeUI_GUI_Actionbar_Fader'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, L.GUI.ACTIONBAR.FADER_SETUP)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local faderValues = {0, 1, .3, .3}

	local function Update()
		F.ACTIONBAR:UpdateActionBarFade()
	end

	local function sliderValueChanged(self, v)
		local current = tonumber(format('%.1f', v))
		self.value:SetText(current)
		C.DB['actionbar'][self.__value] = current
		self.__update()
	end

	local function createOptionSliders(parent, title, minV, maxV, step, defaultV, x, y, value, func)
		local slider = F.CreateSlider(parent, title, minV, maxV, step, x, y, 160)
		slider:SetValue(C.DB['actionbar'][value])
		slider.value:SetText(C.DB['actionbar'][value])
		slider.__value = value
		slider.__update = func
		slider.__default = defaultV
		slider:SetScript('OnValueChanged', sliderValueChanged)
	end

	local filterOptions = {
		[1] = 'condition_combating',
		[2] = 'condition_targeting',
		[3] = 'condition_dungeon',
		[4] = 'condition_pvp',
		[5] = 'condition_vehicle',
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

	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_OUT_ALPHA, 0, 1, .1, faderValues[1], 20, -offset-20, 'fade_out_alpha', Update)
	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_IN_ALPHA, 0, 1, .1, faderValues[2], 20, -offset-100, 'fade_in_alpha', Update)
	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_OUT_DURATION, 0, 1, .1, faderValues[3], 20, -offset-180, 'fade_out_duration', Update)
	createOptionSliders(scroll.child, L.GUI.ACTIONBAR.FADE_IN_DURATION, 0, 1, .1, faderValues[4], 20, -offset-260, 'fade_in_duration', Update)
end

function GUI:NamePlateAuraFilter(parent)
	local guiName = 'FreeUI_GUI_NamePlate_Aura_Filter'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName)

	local frameData = {
		[1] = {text = L.GUI.NAMEPLATE.AURA_WHITE_LIST, tip = L.GUI.NAMEPLATE.AURA_WHITE_LIST_TIP, offset = -25, barList = {}},
		[2] = {text = L.GUI.NAMEPLATE.AURA_BLACK_LIST, tip = L.GUI.NAMEPLATE.AURA_BLACK_LIST_TIP, offset = -315, barList = {}},
	}

	local function createBar(parent, index, spellID)
		local name, _, texture = GetSpellInfo(spellID)
		local bar = CreateFrame('Frame', nil, parent, 'BackdropTemplate')
		bar:SetSize(180, 30)
		F.CreateBD(bar, .25)
		frameData[index].barList[spellID] = bar

		local icon, close = GUI:CreateBarWidgets(bar, texture)
		F.AddTooltip(icon, 'ANCHOR_RIGHT', spellID)
		close:SetScript('OnClick', function()
			bar:Hide()
			FREE_ADB['nameplate_aura_filter_list'][index][spellID] = nil
			frameData[index].barList[spellID] = nil
			sortBars(frameData[index].barList)
		end)

		local spellName = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 30, 0)
		spellName:SetWidth(180)
		spellName:SetJustifyH('LEFT')
		if index == 2 then spellName:SetTextColor(1, 0, 0) end

		sortBars(frameData[index].barList)
	end

	local function addClick(parent, index)
		local spellID = tonumber(parent.box:GetText())
		if not spellID or not GetSpellInfo(spellID) then UIErrorsFrame:AddMessage(C.RedColor..L.GUI.NAMEPLATE.AURA_INCORRECT_ID) return end
		if FREE_ADB['nameplate_aura_filter_list'][index][spellID] then UIErrorsFrame:AddMessage(C.RedColor..L.GUI.NAMEPLATE.AURA_EXISTING_ID) return end

		FREE_ADB['nameplate_aura_filter_list'][index][spellID] = true
		createBar(parent.child, index, spellID)
		parent.box:SetText('')
	end

	for index, value in ipairs(frameData) do
		F.CreateFS(panel, C.Assets.Fonts.Regular, 14, nil, value.text, 'YELLOW', true, 'TOPLEFT', 20, value.offset)
		local frame = CreateFrame('Frame', nil, panel, 'BackdropTemplate')
		frame:SetSize(240, 250)
		frame:SetPoint('TOPLEFT', 10, value.offset - 25)
		F.CreateBD(frame, .25)

		local scroll = GUI:CreateScroll(frame, 200, 200)
		scroll:ClearAllPoints()
		scroll:SetPoint('BOTTOMLEFT', 10, 10)
		scroll.box = F.CreateEditBox(frame, 145, 25)
		scroll.box:SetPoint('TOPLEFT', 10, -10)
		F.AddTooltip(scroll.box, 'ANCHOR_RIGHT', value.tip, 'BLUE')
		scroll.add = F.CreateButton(frame, 70, 25, ADD)
		scroll.add:SetPoint('TOPRIGHT', -8, -10)
		scroll.add:SetScript('OnClick', function()
			addClick(scroll, index)
		end)

		for spellID in pairs(FREE_ADB['nameplate_aura_filter_list'][index]) do
			createBar(scroll.child, index, spellID)
		end
	end
end




function GUI:UnitFrameSetup(parent)
	local guiName = "FreeUI_GUI_Unitframe_Setup"
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, 'UnitFrame Size')
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local sliderRange = {
		["player"] = {100, 300},
		["target"] = {100, 300},
		["focus"] = {100, 300},
		["pet"] = {100, 300},
		["boss"] = {100, 300},
		["arena"] = {100, 300},
	}

	local defaultValue = {
		["player"] = {120, 8},
		["target"] = {160, 8},
		["focus"] = {60, 8},
		["pet"] = {50, 8},
		["boss"] = {120, 20},
		["arena"] = {120, 16},
	}

	local function sliderValueChanged(self, v)
	local current = tonumber(format("%.0f", v))
		self.value:SetText(current)
		C.DB["unitframe"][self.__value] = current
		self.__update()
	end

	local function createOptionSlider(parent, title, minV, maxV, defaultV, x, y, value, func)
		local slider = F.CreateSlider(parent, title, minV, maxV, 1, x, y, 160)
		slider:SetValue(C.DB["unitframe"][value])
		slider.value:SetText(C.DB["unitframe"][value])
		slider.__value = value
		slider.__update = func
		slider.__default = defaultV
		slider:SetScript("OnValueChanged", sliderValueChanged)
	end

	local function UpdateSize(self, unit)

	end

	local function createOptionGroup(parent, title, offset, value, func)
		createOptionTitle(parent, title, offset)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_WIDTH, sliderRange[value][1], sliderRange[value][2], defaultValue[value][1], 30, offset-60, value.."_width", func)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_HEIGHT, 4, 20, defaultValue[value][2], 30, offset-130, value.."_height", func)
	end

	local function createPowerOptionGroup(parent, title, offset, value, func)
		createOptionTitle(parent, title, offset)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_POWER_HEIGHT, 1, 10, 1, 30, offset-60, 'power_bar_height', func)
		createOptionSlider(parent, L.GUI.UNITFRAME.SET_ALT_POWER_HEIGHT, 1, 10, 2, 30, offset-130, 'alt_power_height', func)
	end

	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_PLAYER, -10, "player", UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_TARGET, -210, "target", UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_FOCUS, -410, "focus", UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_PET, -610, "pet", UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_BOSS, -810, "boss", UpdateSize)
	createOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_ARENA, -1010, "arena", UpdateSize)
	createPowerOptionGroup(scroll.child, L.GUI.UNITFRAME.CAT_POWER, -1210, nil, UpdateSize)
end

function GUI:UnitFrameFader(parent)
	local guiName = 'FreeUI_GUI_Unitframe_Fader'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, L.GUI.UNITFRAME.FADER_SETUP)
	local scroll = GUI:CreateScroll(panel, 220, 540)

	local faderValues = {0, 1, .3, .3}

	local function Update()
		--F.ACTIONBAR:UpdateActionBarFade()
	end

	local function sliderValueChanged(self, v)
		local current = tonumber(format('%.1f', v))
		self.value:SetText(current)
		C.DB['unitframe'][self.__value] = current
		self.__update()
	end

	local function createOptionSliders(parent, title, minV, maxV, step, defaultV, x, y, value, func)
		local slider = F.CreateSlider(parent, title, minV, maxV, step, x, y, 160)
		slider:SetValue(C.DB['unitframe'][value])
		slider.value:SetText(C.DB['unitframe'][value])
		slider.__value = value
		slider.__update = func
		slider.__default = defaultV
		slider:SetScript('OnValueChanged', sliderValueChanged)
	end

	local filterOptions = {
		[1] = 'condition_combat',
		[2] = 'condition_target',
		[3] = 'condition_instance',
		[4] = 'condition_arena',
		[5] = 'condition_casting',
		[6] = 'condition_injured',
		[7] = 'condition_mana',
		[8] = 'condition_power',
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

	createOptionSliders(scroll.child, L.GUI.UNITFRAME.FADE_OUT_ALPHA, 0, 1, .1, faderValues[1], 20, -offset-20, 'fade_out_alpha', Update)
	createOptionSliders(scroll.child, L.GUI.UNITFRAME.FADE_IN_ALPHA, 0, 1, .1, faderValues[2], 20, -offset-100, 'fade_in_alpha', Update)
	createOptionSliders(scroll.child, L.GUI.UNITFRAME.FADE_OUT_DURATION, 0, 1, .1, faderValues[3], 20, -offset-180, 'fade_out_duration', Update)
	createOptionSliders(scroll.child, L.GUI.UNITFRAME.FADE_IN_DURATION, 0, 1, .1, faderValues[4], 20, -offset-260, 'fade_in_duration', Update)
end
