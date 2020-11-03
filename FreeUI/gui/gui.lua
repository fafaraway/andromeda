local F, C, L = unpack(select(2, ...))
local GUI = F.GUI


local checkboxes, sidePanels = {}, {}
local guiTab, guiPage = {}, {}

local tabsList = {
	L.GUI.APPEARANCE.NAME,
	L.GUI.NOTIFICATION.NAME,
	L.GUI.INFOBAR.NAME,
	L.GUI.CHAT.NAME,
	L.GUI.AURA.NAME,
	L.GUI.ACTIONBAR.NAME,
	L.GUI.COMBAT.NAME,
	L.GUI.ANNOUNCEMENT.NAME,
	L.GUI.INVENTORY.NAME,
	L.GUI.MAP.NAME,
	L.GUI.TOOLTIP.NAME,
	L.GUI.UNITFRAME.NAME,
	L.GUI.NAMEPLATE.NAME,
	L.GUI.MISC.NAME,
	L.GUI.PROFILE.NAME,
	L.GUI.CREDITS.NAME,
}

local iconsList = {
	'Interface\\ICONS\\Ability_Hunter_BeastWithin',
	'Interface\\ICONS\\Ability_Mage_ColdAsIce',
	'Interface\\ICONS\\Ability_Racial_EmbraceoftheLoa_Bwonsomdi',
	'Interface\\ICONS\\Spell_Shadow_Seduction',
	'Interface\\ICONS\\Spell_Shadow_Shadesofdarkness',
	'Interface\\ICONS\\Ability_Warrior_BloodFrenzy',
	'Interface\\ICONS\\Ability_Warrior_Challange',
	'Interface\\ICONS\\Ability_Warrior_RallyingCry',
	'Interface\\ICONS\\INV_Misc_Bag_30',
	'Interface\\ICONS\\Achievement_Ashran_Tourofduty',
	'Interface\\ICONS\\Ability_Priest_BindingPrayers',
	'Interface\\ICONS\\Ability_Mage_MassInvisibility',
	'Interface\\ICONS\\Ability_Paladin_BeaconsOfLight',
	'Interface\\ICONS\\ABILITY_MONK_SERENITY',
	'Interface\\ICONS\\INV_Misc_Blingtron',
	'Interface\\ICONS\\Raf-Icon',
}

GUI.TextureList = {
	[1] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex', name = L.GUI.APPEARANCE.TEXTURE_NORM},
	[2] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex', name = L.GUI.APPEARANCE.TEXTURE_GRAD},
	[3] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex', name = L.GUI.APPEARANCE.TEXTURE_FLAT},
}

local function AddTextureToOption(parent, index)
	local tex = parent[index]:CreateTexture()
	tex:SetInside(nil, 4, 4)
	tex:SetTexture(GUI.TextureList[index].texture)
	tex:SetVertexColor(.6, .6, .6)
end

local function SaveValue(key, value, newValue)
	if key == 'ACCOUNT' then
		if newValue ~= nil then
			FREE_ADB[value] = newValue
		else
			return FREE_ADB[value]
		end
	else
		if newValue ~= nil then
			C.DB[key][value] = newValue
		else
			return C.DB[key][value]
		end
	end
end

function GUI:ToggleSidePanel(name)
	for _, frame in next, sidePanels do
		if frame:GetName() == name then
			F:TogglePanel(frame)
		else
			frame:Hide()
		end
	end
end

local function CreateGearButton(self)
	local bu = CreateFrame('Button', nil, self)
	bu:SetSize(20, 20)
	bu.icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.icon:SetAllPoints()
	bu.icon:SetTexture(C.Assets.gear_tex)
	bu.icon:SetVertexColor(.6, .6, .6)
	bu:SetHighlightTexture(C.Assets.gear_tex)

	return bu
end

local function UpdateSubOptions(self, checked)
	local tR, tG, tB
	local bR, bG, bB, bA

	if checked then
		tR, tG, tB = 1, 1, 1
		bR, bG, bB, bA = .6, .6, .6, 1
	else
		tR, tG, tB = .3, .3, .3
		bR, bG, bB, bA = 0, 0, 0, 0
	end

	for _, child in next, self.sub do

		child:SetEnabled(checked)
		child.Text:SetTextColor(tR, tG, tB)

		if child.Low then
			child.Low:SetTextColor(tR, tG, tB)
			child.High:SetTextColor(tR, tG, tB)
			child.value:SetTextColor(tR, tG, tB)
			child:GetThumbTexture():SetVertexColor(tR, tG, tB)
		end

		if child.bu then
			child.bu:SetEnabled(checked)
			child.bu.icon:SetVertexColor(bR, bG, bB, bA)
		end
	end
end

local function UpdateGearButton(self, checked)
	if checked then
		self.bu:SetHighlightTexture(C.Assets.gear_tex)
		self.bu.icon:Show()
	else
		self.bu:SetHighlightTexture('')
		self.bu.icon:Hide()
	end
end


local function cbOnClick(self)
	local checked = self:GetChecked()

	if checked then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end

	if self.sub then
		UpdateSubOptions(self, checked)
	end

	if self.bu then
		UpdateGearButton(self, checked)
	end


	for _, frame in next, sidePanels do
		if not checked then
			frame:Hide()
		end
	end
end

local function UpdateSettings()
	for _, box in pairs(checkboxes) do
		if box.bu then
			UpdateGearButton(box, box:GetChecked())
		end

		if box.sub then
			UpdateSubOptions(box, box:GetChecked())
		end
	end
end

local function CombatLockdown(event)
	if not FreeUI_GUI then return end

	if event == 'PLAYER_REGEN_DISABLED' then
		if FreeUI_GUI:IsShown() then
			FreeUI_GUI:Hide()
			F:RegisterEvent('PLAYER_REGEN_ENABLED', CombatLockdown)
		end
	else
		FreeUI_GUI:Show()
		F:UnregisterEvent(event, CombatLockdown)
	end
end

local function SelectTab(i)
	for num = 1, #tabsList do
		if num == i then
			guiTab[num].__bg:SetBackdropColor(C.r, C.g, C.b, .25)
			guiTab[num].checked = true
			guiPage[num]:Show()
		else
			guiTab[num].__bg:SetBackdropColor(0, 0, 0, 0)
			guiTab[num].checked = false
			guiPage[num]:Hide()
		end
	end
end

local function tabOnClick(self)
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	SelectTab(self.index)
end

local function tabOnEnter(self)
	if self.checked then return end
	self.__bg:SetBackdropColor(C.r, C.g, C.b, .25)
end

local function tabOnLeave(self)
	if self.checked then return end
	self.__bg:SetBackdropColor(0, 0, 0, 0)
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame('Button', nil, parent, 'BackdropTemplate')
	tab:SetSize(140, 28)
	F.Reskin(tab)

	tab.index = i

	-- if tab.index >= 15 then
	-- 	tab:SetPoint('TOPLEFT', 10, -31*i - 30)
	-- else
	tab:SetPoint('TOPLEFT', 10, -31*i - 20)
	-- end

	--parent[name] = tab

	tab.icon = tab:CreateTexture(nil, 'OVERLAY')
	tab.icon:SetSize(20, 20)
	tab.icon:SetPoint('LEFT', tab, 6, 0)
	tab.icon:SetTexture(iconsList[i])
	F.ReskinIcon(tab.icon)

	tab.text = F.CreateFS(tab, C.Assets.Fonts.Regular, 13, nil, name, nil, 'THICK')
	tab.text:SetPoint('LEFT', tab.icon, 'RIGHT', 8, 0)

	tab:HookScript('OnClick', tabOnClick)
	tab:HookScript('OnEnter', tabOnEnter)
	tab:HookScript('OnLeave', tabOnLeave)

	return tab
end

GUI.OptionsList = { -- type, key, value, name, horizon, doubleline
	[1] = { -- appearance
		{1, 'ACCOUNT', 'cursor_trail', L.GUI.APPEARANCE.CURSOR_TRAIL},
		{1, 'ACCOUNT', 'shadow_border', L.GUI.APPEARANCE.SHADOW_BORDER, true},
		{1, 'ACCOUNT', 'reskin_blizz', L.GUI.APPEARANCE.RESKIN_BLIZZ, nil, nil, nil, L.GUI.APPEARANCE.RESKIN_BLIZZ_TIP},
		{1, 'ACCOUNT', 'vignetting', L.GUI.APPEARANCE.VIGNETTING, true},
		{3, 'ACCOUNT', 'backdrop_alpha', L.GUI.APPEARANCE.BACKDROP_ALPHA, nil, {0, 1, .01}, nil, L.GUI.APPEARANCE.BACKDROP_ALPHA_TIP},
		{3, 'ACCOUNT', 'vignetting_alpha', L.GUI.APPEARANCE.VIGNETTING_ALPHA, true, {0, 1, .01}},
		{},
		{1, 'ACCOUNT', 'reskin_dbm', L.GUI.APPEARANCE.RESKIN_DBM},
		{1, 'ACCOUNT', 'reskin_pgf', L.GUI.APPEARANCE.RESKIN_PGF, true},
		{},
		{3, 'ACCOUNT', 'ui_scale', L.GUI.APPEARANCE.UI_SCALE, nil, {.5, 2, .01}, nil, L.GUI.APPEARANCE.UI_SCALE_TIP},
	},
	[2] = { -- notification

		{},

	},
	[3] = {

		{},--blank

	},
	[4] = {

		{},--blank

	},
	[5] = {

		{},--blank

	},
	[6] = {

		{},--blank

	},
	[7] = {

		{},--blank

	},
	[8] = { -- announcement
		{1, 'announcement', 'enable', L.GUI.ANNOUNCEMENT.ENABLE, nil, nil, nil, L.GUI.ANNOUNCEMENT.ENABLE_TIP},
		{1, 'announcement', 'interrupt', L.GUI.ANNOUNCEMENT.INTERRUPT, nil, nil, nil, L.GUI.ANNOUNCEMENT.INTERRUPT_TIP},
		{1, 'announcement', 'dispel', L.GUI.ANNOUNCEMENT.DISPEL, true, nil, nil, L.GUI.ANNOUNCEMENT.DISPEL_TIP},
		{1, 'announcement', 'combat_resurrection', L.GUI.ANNOUNCEMENT.COMBAT_RESURRECTION, nil, nil, nil, L.GUI.ANNOUNCEMENT.COMBAT_RESURRECTION_TIP},
		{1, 'announcement', 'utility', L.GUI.ANNOUNCEMENT.UTILITY, true, nil, nil, L.GUI.ANNOUNCEMENT.UTILITY_TIP},

	},
	[9] = {

		{},--blank

	},
	[10] = {

		{},--blank

	},
	[11] = {

		{},--blank

	},
	[12] = {

		{},--blank

	},

	[13] = { -- nameplate
		{1, 'nameplate', 'enable', L.GUI.NAMEPLATE.ENABLE},

		{1, 'nameplate', 'target_indicator', L.GUI.NAMEPLATE.TARGET_INDICATOR},
		{1, 'nameplate', 'threat_indicator', L.GUI.NAMEPLATE.THREAT_INDICATOR, true},
		{},--blank
		{1, 'nameplate', 'target_indicator', L.GUI.NAMEPLATE.TARGET_INDICATOR},
		{1, 'nameplate', 'threat_indicator', L.GUI.NAMEPLATE.THREAT_INDICATOR, true},
	},
	[14] = { -- misc
		{4, 'ACCOUNT', 'texture_style', L.GUI.APPEARANCE.TEXTURE_STYLE, false, {}},
		{4, 'ACCOUNT', 'number_format', L.GUI.APPEARANCE.NUMBER_FORMAT, true, {L.GUI.APPEARANCE.NUMBER_TYPE1, L.GUI.APPEARANCE.NUMBER_TYPE2, L.GUI.APPEARANCE.NUMBER_TYPE3}},
	},
	[15] = { -- profile

	},
	[16] = { -- credits

		{},--blank

	},
}

local function CreateOption(i)
	local parent, offset = guiPage[i].child, 20

	for _, option in pairs(GUI.OptionsList[i]) do
		local optType, key, value, name, horizon, data, callback, tip = unpack(option)
		-- Checkboxes
		if optType == 1 then
			local cb = F.CreateCheckBox(parent, true)
			cb:SetSize(20, 20)
			cb:SetHitRectInsets(-5, -5, -5, -5)
			if horizon then
				cb:SetPoint('TOPLEFT', 200, -offset + 35)
			else
				cb:SetPoint('TOPLEFT', 20, -offset)
				offset = offset + 35
			end
			cb.name = F.CreateFS(cb, C.Assets.Fonts.Regular, 12, nil, name, nil, 'THICK', 'LEFT', 24, 0)
			cb:SetChecked(SaveValue(key, value))
			cb:SetScript('OnClick', function()
				SaveValue(key, value, cb:GetChecked())
				if callback then callback() end
			end)
			if data and type(data) == 'function' then
				local bu = CreateGearButton(parent)
				bu:SetPoint('LEFT', cb.name, 'RIGHT', -2, 1)
				bu:SetScript('OnClick', data)
			end
			if tip then
				F.AddTooltip(cb, 'ANCHOR_TOPLEFT', tip, 'BLUE')
			end
		-- Slider
		elseif optType == 3 then
			local min, max, step = unpack(data)
			local x, y
			if horizon then
				x, y = 200, -offset + 60
			else
				x, y = 20, -offset - 20
				offset = offset + 80
			end
			local s = F.CreateSlider(parent, name, min, max, step, x, y, 140, tip)
			s.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]
			s:SetValue(SaveValue(key, value))
			s:SetScript('OnValueChanged', function(_, v)
				local current = F:Round(tonumber(v), 2)
				SaveValue(key, value, current)
				s.value:SetText(current)
				if callback then callback() end
			end)
			s.value:SetText(F:Round(SaveValue(key, value), 2))
			if tip then
				F.AddTooltip(s, 'ANCHOR_TOPLEFT', tip, 'BLUE')
			end
		-- Dropdown
		elseif optType == 4 then
			if value == 'texture_style' then
				for _, v in ipairs(GUI.TextureList) do
					tinsert(data, v.name)
				end
			end

			local dd = F.CreateDropDown(parent, 140, 20, data)
			if horizon then
				dd:SetPoint('TOPLEFT', 200, -offset + 45)
			else
				dd:SetPoint('TOPLEFT', 20, -offset - 25)
				offset = offset + 70
			end
			dd.Text:SetText(data[SaveValue(key, value)])

			local opt = dd.options
			dd.button:HookScript('OnClick', function()
				for num = 1, #data do
					if num == SaveValue(key, value) then
						opt[num]:SetBackdropColor(1, .8, 0, .3)
						opt[num].selected = true
					else
						opt[num]:SetBackdropColor(0, 0, 0, .3)
						opt[num].selected = false
					end
				end
			end)
			for i in pairs(data) do
				opt[i]:HookScript('OnClick', function()
					SaveValue(key, value, i)
					if callback then callback() end
				end)
				if value == 'texture_style' then
					AddTextureToOption(opt, i) -- texture preview
				end
			end

			F.CreateFS(dd, C.Assets.Fonts.Regular, 11, nil, name, 'INFO', 'THICK', 'CENTER', 0, 25)
		-- Blank, no optType
		else
			if not key then
				local line = F.SetGradient(parent, 'H', .5, .5, .5, .25, .25, 340, C.Mult)
				line:SetPoint('TOPLEFT', 20, -offset - 12)
			end
			offset = offset + 35
		end

	end

	local footer = CreateFrame('Frame', nil, parent)
	footer:SetSize(20, 20)
	footer:SetPoint('TOPLEFT', 25, -offset)
end

local function ScrollBarHook(self, delta)
	local scrollBar = self.ScrollBar
	scrollBar:SetValue(scrollBar:GetValue() - delta*35)
end

local function CreateGUI()
	if FreeUI_GUI then FreeUI_GUI:Show() return end

	local guiFrame = CreateFrame('Frame', 'FreeUI_GUI', UIParent, 'BackdropTemplate')
	tinsert(_G.UISpecialFrames, 'FreeUI_GUI')
	guiFrame:SetSize(600, 640)
	guiFrame:SetPoint('CENTER')
	guiFrame:SetFrameStrata('HIGH')
	guiFrame:EnableMouse(true)
	F.CreateMF(guiFrame)
	F.SetBD(guiFrame)

	local verticalLine = F.SetGradient(guiFrame, 'V', .5, .5, .5, .25, .25, C.Mult, 540)
	verticalLine:SetPoint('TOPLEFT', 160, -50)

	local logo = F.CreateFS(guiFrame, C.AssetsPath..'fonts\\bold.ttf', 22, nil, C.AddonName, nil, 'THICK', 'TOP', 0, -4)
	local desc = F.CreateFS(guiFrame, C.Assets.Fonts.Regular, 10, nil, 'Version: '..C.AddonVersion, {.7,.7,.7}, 'THICK', 'TOP', 0, -30)

	local lineLeft = F.SetGradient(guiFrame, 'H', .7, .7, .7, 0, .7, 120, C.Mult)
	lineLeft:SetPoint('TOP', -60, -26)

	local lineRight = F.SetGradient(guiFrame, 'H', .7, .7, .7, .7, 0, 120, C.Mult)
	lineRight:SetPoint('TOP', 60, -26)

	local btnClose = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
	btnClose:SetPoint('BOTTOMRIGHT', -6, 6)
	btnClose:SetSize(80, 24)
	btnClose:SetText(CLOSE)
	btnClose:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		guiFrame:Hide()
	end)
	F.Reskin(btnClose)

	local btnApply = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
	btnApply:SetPoint('RIGHT', btnClose, 'LEFT', -6, 0)
	btnApply:SetSize(80, 24)
	btnApply:SetText(APPLY)
	--btnApply:Disable()
	btnApply:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_RELOAD')
		guiFrame:Hide()
	end)
	F.Reskin(btnApply)


	for i, name in pairs(tabsList) do
		guiTab[i] = CreateTab(guiFrame, i, name)

		guiPage[i] = CreateFrame('ScrollFrame', nil, guiFrame, 'UIPanelScrollFrameTemplate')
		guiPage[i]:SetPoint('TOPLEFT', 170, -50)
		guiPage[i]:SetSize(400, 540)
		F.CreateBDFrame(guiPage[i], .25)
		guiPage[i]:Hide()

		guiPage[i].child = CreateFrame('Frame', nil, guiPage[i])
		guiPage[i].child:SetSize(400, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		F.ReskinScroll(guiPage[i].ScrollBar)
		guiPage[i]:SetScript("OnMouseWheel", ScrollBarHook)

		-- local header = F.CreateFS(guiPage[i].child, C.Assets.Fonts.Bold, 14, nil, L[strupper(name)..'_NAME'] or nil, 'CLASS', 'THICK', 'TOPLEFT', 14, -16)
		-- guiPage[i].header = header

		-- local desc = F.CreateFS(guiPage[i].child, C.Assets.Fonts.Regular, 12, nil, L[strupper(name)..'_DESC'] or nil, {.8, .8, .8}, 'THICK')
		-- desc:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -8)
		-- desc:SetJustifyH('LEFT')
		-- desc:SetJustifyV('TOP')
		-- desc:SetSize(360, 30)
		-- guiPage[i].desc = desc

		-- FreeUI_GUI[i] = guiPage[i].child
		-- FreeUI_GUI[i].tab = guiTab[i]
		-- FreeUI_GUI[i].header = header
		-- FreeUI_GUI[i].desc = desc

		CreateOption(i)
	end

	GUI:CreateProfileGUI(guiPage[15]) -- profile GUI

	SelectTab(1)
end

local function CreateGameMenuButton()
	local bu = CreateFrame('Button', 'GameMenuFrameFreeUI', GameMenuFrame, 'GameMenuButtonTemplate')
	bu:SetText(C.AddonName)
	bu:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	if FREE_ADB.reskin_blizz then F.Reskin(bu) end

	GameMenuFrame:HookScript('OnShow', function(self)
		GameMenuButtonLogout:SetPoint('TOP', bu, 'BOTTOM', 0, -14)
		self:SetHeight(self:GetHeight() + bu:GetHeight() + 15)
	end)

	bu:SetScript('OnClick', function()
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.RedColor..ERR_NOT_IN_COMBAT) return end
		CreateGUI()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)
end

function F.ToggleGUI()
	if FreeUI_GUI then
		if FreeUI_GUI:IsShown() then
			FreeUI_GUI:Hide()
		else
			FreeUI_GUI:Show()
		end
	else
		CreateGUI()
	end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
end

function GUI:CreateScroll(parent, width, height, text)
	local scroll = CreateFrame('ScrollFrame', nil, parent, 'UIPanelScrollFrameTemplate')
	scroll:SetSize(width, height)
	scroll:SetPoint('BOTTOMLEFT', 10, 10)
	F.CreateBDFrame(scroll, .35)
	if text then
		F.CreateFS(scroll, C.Assets.Fonts.Regular, 12, nil, text, nil, false, 'TOPLEFT', 5, 20)
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

--[[ -- Subcategory
function GUI:AddSubCategory(parent, name)
	local header = F.CreateFS(parent, C.Assets.Fonts.Regular, 12, nil, name or 'Sub category', 'YELLOW', 'THICK')

	local line = parent:CreateTexture(nil, 'ARTWORK')
	line:SetSize(350, 1)
	line:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -4)
	line:SetColorTexture(.5, .5, .5, .1)

	header.line = line

	return header, line
end

-- Side panel
function GUI:CreateSidePanel(parent, name, header)
	local f = CreateFrame('Frame', name, (parent:GetParent()):GetParent())
	f:SetSize(200, 640)
	f:SetPoint('TOPLEFT', (parent:GetParent()):GetParent(), 'TOPRIGHT', 3, 0)
	f:Hide()

	f.header = F.CreateFS(f, C.Assets.Fonts.Regular, 12, nil, header, 'YELLOW', 'THICK', 'TOPLEFT', 20, -25)

	f.child = CreateFrame('Frame', nil, f)
	f.child:SetSize(180, 540)
	f.child:SetPoint('TOPLEFT', 10, -50)

	f.close = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.close:SetPoint('BOTTOM', 0, 6)
	f.close:SetSize(80, 24)
	f.close:SetText(CLOSE)
	f.close:SetScript('OnClick', function()
		f:Hide()
	end)

	parent:HookScript('OnHide', function()
		if f:IsShown() then f:Hide() end
	end)

	tinsert(sidePanels, f)
	parent.side = f

	F.CreateBDFrame(f, nil, true)
	F.CreateBDFrame(f.child, .25)
	F.Reskin(f.close)

	return f
end

-- Checkbox
function GUI:CreateCheckBox(parent, key, value, label, tip, callback, extra, caution, position)
	local checkbox = F.CreateCheckBox(parent)
	checkbox:SetSize(20, 20)
	checkbox:SetHitRectInsets(-5, -5, -5, -5)
	checkbox:SetChecked(SaveValue(key, value))
	checkbox.Text = F.CreateFS(checkbox, C.Assets.Fonts.Regular, 12, nil, label or value, caution and 'RED' or nil, 'THICK', 'LEFT', 20, 0)

	checkbox:SetScript('OnClick', function()
		SaveValue(key, value, checkbox:GetChecked())
		if callback then callback() end
	end)

	if extra and type(extra) == 'function' then
		local bu = CreateGearButton(checkbox)
		bu:SetPoint('LEFT', checkbox.Text, 'RIGHT', 0, 1)
		bu:SetScript('OnClick', extra)

		checkbox.bu = bu
	end

	checkbox:HookScript('OnClick', cbOnClick)

	if tip then
		checkbox.title = label
		F.AddTooltip(checkbox, 'ANCHOR_RIGHT', tip, 'BLUE')
	end

	tinsert(checkboxes, checkbox)

	return checkbox
end

-- Sliders
function GUI:CreateSlider(parent, key, value, callback, extra)
	local minValue, maxValue, step = unpack(extra)

	local slider = F.CreateSlider(parent, value, minValue, maxValue, step, 160)
	slider.Text:SetText(L[strupper(key)..'_'..strupper(value)] or value)
	slider.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or (key == 'APPEARANCE' and C.AccountSettings['appearance'][value]) or C.CharacterSettings[key][value]
	slider:SetValue(SaveValue(key, value))
	slider:SetScript('OnValueChanged', function(_, v)
		local current = F:Round(tonumber(v), 2)
		SaveValue(key, value, current)
		slider.value:SetText(current)
		if callback then callback() end
	end)

	slider.value:SetText(F:Round(SaveValue(key, value), 2))

	if L[strupper(key)..'_'..strupper(value)..'_TIP'] then
		slider.title = L[strupper(key)..'_'..strupper(value)]
		F.AddTooltip(slider, 'ANCHOR_RIGHT', L[strupper(key)..'_'..strupper(value)..'_TIP'], 'BLUE')
	end

	return slider
end

-- Editbox
function GUI:CreateEditBox(parent, key, value, callback, extra)
	local width, height, maxLetters, multiLine = unpack(extra)

	local editbox = F.CreateEditBox(parent, width, height)
	editbox:EnableMouse(true)
	editbox:SetMultiLine(multiLine)
	editbox:SetMaxLetters(maxLetters)
	editbox:SetSpacing(3)
	editbox:SetText(SaveValue(key, value))
	editbox:SetJustifyH('LEFT')
	editbox:SetJustifyV('TOP')

	editbox.text = editbox:GetRegions()
	-- if editbox.text:GetObjectType() == 'FontString' then
	-- 	editbox.text:SetJustifyH('RIGHT')
	-- end

	editbox:HookScript('OnEscapePressed', function()
		editbox:SetText(SaveValue(key, value))
	end)

	editbox:HookScript('OnEnterPressed', function()
		SaveValue(key, value, editbox:GetText())
		if callback then callback() end
	end)

	editbox.title = F.CreateFS(editbox, C.Assets.Fonts.Regular, 12, nil, L[strupper(key)..'_'..strupper(value)] or value, 'SYSTEM', true)
	editbox.title:SetPoint('BOTTOM', editbox, 'TOP', 0, 6)


	if L[strupper(key)..'_'..strupper(value)..'_TIP'] then
		editbox.title = L[strupper(key)..'_'..strupper(value)]
		F.AddTooltip(editbox, 'ANCHOR_RIGHT', L[strupper(key)..'_'..strupper(value)..'_TIP'], 'BLUE')
	end

	return editbox
end

-- Dropdown
function GUI:CreateDropDown(parent, key, value, callback, extra, label)
	local dropdown = F.CreateDropDown(parent, 120, 22, extra)

	dropdown.Text:SetText(extra[SaveValue(key, value)])

	local opt = dropdown.options
	dropdown.button:HookScript('OnClick', function()
		for num = 1, #extra do
			if num == SaveValue(key, value) then
				opt[num]:SetBackdropColor(C.r, C.g, C.b, .25)
				opt[num].selected = true
			else
				opt[num]:SetBackdropColor(0, 0, 0, .25)
				opt[num].selected = false
			end
		end
	end)
	for i in pairs(extra) do
		opt[i]:HookScript('OnClick', function()
			SaveValue(key, value, i)
			if callback then callback() end
		end)
	end

	F.CreateFS(dropdown, C.Assets.Fonts.Regular, 11, nil, label or value, 'INFO', 'THICK', 'CENTER', 0, 20)

	return dropdown
end

-- Color swatch
function GUI:CreateColorSwatch(parent, key, value)
	local swatch = F.CreateColorSwatch(parent, L[strupper(key)..'_'..strupper(value)] or value, SaveValue(key, value))

	if L[strupper(key)..'_'..strupper(value)..'_TIP'] then
		swatch.title = L[strupper(key)..'_'..strupper(value)]
		F.AddTooltip(swatch, 'ANCHOR_RIGHT', L[strupper(key)..'_'..strupper(value)..'_TIP'], 'BLUE')
	end

	return swatch
end ]]


function GUI:OnLogin()
	--CreateGUI()
	CreateGameMenuButton()

	--GUI:AddOptions()

	--UpdateSettings()



	F:RegisterEvent('PLAYER_REGEN_DISABLED', CombatLockdown)
end

