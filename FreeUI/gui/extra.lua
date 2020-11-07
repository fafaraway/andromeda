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

local function createExtraGUI(parent, name, title)
	local frame = CreateFrame('Frame', name, parent)
	frame:SetSize(260, 640)
	frame:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)
	F.SetBD(frame)

	if title then
		F.CreateFS(frame, C.Assets.Fonts.Regular, 14, 'OUTLINE', title, nil, true, 'TOPLEFT', 10, -25)
	end

	frame.bg = CreateFrame('Frame', nil, frame)
	frame.bg:SetSize(180, 540)
	frame.bg:SetPoint('TOPLEFT', 10, -50)
	--F.CreateBDFrame(frame.bg, .25)

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
	F.CreateFS(box, C.Assets.Fonts.Regular, 12, 'OUTLINE', text, nil, true, 'LEFT', 22, 0)
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
	local scroll = CreateFrame('ScrollFrame', nil, parent.bg, 'UIPanelScrollFrameTemplate')
	scroll:SetSize(width, height)
	scroll:SetPoint('BOTTOMLEFT', 0, 0)
	F.CreateBDFrame(scroll, .25)
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



function GUI:UpdateItemFilterStatus()
	F:GetModule('INVENTORY'):UpdateAllBags()

	local label = BAG_FILTER_EQUIPMENT
	if C.DB.inventory.item_filter_gear_set then
		label = L['INVENTORY_EQUIPEMENT_SET']
	end
	_G.FreeUI_BackpackEquipment.label:SetText(label)
	_G.FreeUI_BackpackBankEquipment.label:SetText(label)
end

function GUI:ItemFilter(parent)
	local guiName = 'FreeUI_GUI_Inventory_Filter'
	toggleExtraGUI(guiName)
	if extraGUIs[guiName] then return end

	local panel = createExtraGUI(parent, guiName, L.GUI.INVENTORY.FILTER_SETUP)
	local scroll = GUI:CreateScroll(panel, 220, 540)



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
		GUI.UpdateItemFilterStatus()
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
		local slider = F.CreateSlider(parent, title, minV, maxV, step, x, y)
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
		GUI.UpdateItemFilterStatus()
	end

	local offset = 20
	for _, value in ipairs(filterOptions) do
		local box = createOptionCheck(scroll, offset, L.GUI.ACTIONBAR[strupper(value)])
		box:SetChecked(C.DB['actionbar'][value])
		box.__value = value
		box:SetScript('OnClick', filterOnClick)

		offset = offset + 35
	end

	createOptionSliders(scroll, L.GUI.ACTIONBAR.FADE_OUT_ALPHA, 0, 1, .1, faderValues[1], 20, -offset-20, 'fade_out_alpha', Update)
	createOptionSliders(scroll, L.GUI.ACTIONBAR.FADE_IN_ALPHA, 0, 1, .1, faderValues[2], 20, -offset-100, 'fade_in_alpha', Update)
	createOptionSliders(scroll, L.GUI.ACTIONBAR.FADE_OUT_DURATION, 0, 1, .1, faderValues[3], 20, -offset-180, 'fade_out_duration', Update)
	createOptionSliders(scroll, L.GUI.ACTIONBAR.FADE_IN_DURATION, 0, 1, .1, faderValues[4], 20, -offset-260, 'fade_in_duration', Update)
end
