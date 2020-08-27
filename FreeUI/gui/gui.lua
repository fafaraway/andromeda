local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')


local checkboxes, sidePanels = {}, {}
local guiTab, guiPage = {}, {}

local tabsList = {
	'APPEARANCE',
	'NOTIFICATION',
	'ANNOUNCEMENT',
	'INFOBAR',
	'CHAT',
	'AURA',
	'ACTIONBAR',
	'COMBAT',
	'INVENTORY',
	'MAP',
	'QUEST',
	'TOOLTIP',
	'UNITFRAME',
	'MISC',
	'DATA',
	'CREDIT',
}

local iconsList = {
	'Interface\\ICONS\\Ability_Hunter_BeastWithin',
	'Interface\\ICONS\\Ability_Warrior_Revenge',
	'Interface\\ICONS\\Ability_Warrior_RallyingCry',
	'Interface\\ICONS\\INV_Misc_Horn_04',
	'Interface\\ICONS\\Spell_Shadow_Seduction',
	'Interface\\ICONS\\Spell_Shadow_Shadesofdarkness',
	'Interface\\ICONS\\Spell_Holy_SearingLightPriest',
	'Interface\\ICONS\\Ability_Parry',
	'Interface\\ICONS\\INV_Misc_Bag_30',
	'Interface\\ICONS\\Achievement_Ashran_Tourofduty',
	'Interface\\ICONS\\ABILITY_Rogue_RollTheBones04',
	'Interface\\ICONS\\INV_Misc_ScrollUnrolled03d',
	'Interface\\ICONS\\Ability_Mage_MassInvisibility',
	'Interface\\ICONS\\Misc_Legionfall_Paladin',
	'Interface\\ICONS\\INV_Misc_Blingtron',
	'Interface\\ICONS\\INV_Misc_CelebrationCake_01',
}


local function SaveValue(key, value, newValue)
	if key == 'CLASSCOLORS' then
		if newValue ~= nil then
			FreeADB['class_colors'][value] = newValue
		else
			return FreeADB['class_colors'][value]
		end
	elseif key == 'POWERCOLORS' then
		if newValue ~= nil then
			FreeADB['power_colors'][value] = newValue
		else
			return FreeADB['power_colors'][value]
		end

	elseif key == 'APPEARANCE' then
		if newValue ~= nil then
			FreeADB['appearance'][value] = newValue
		else
			return FreeADB['appearance'][value]
		end

	elseif key == 'ACCOUNT' then
		if newValue ~= nil then
			FreeADB[value] = newValue
		else
			return FreeADB[value]
		end
	else
		if newValue ~= nil then
			FreeDB[key][value] = newValue
		else
			return FreeDB[key][value]
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
	bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(C.Assets.gear_tex)
	bu.Icon:SetVertexColor(.6, .6, .6)
	bu:SetHighlightTexture(C.Assets.gear_tex)

	return bu
end

local function ToggleChildren(self, checked)
	local tR, tG, tB
	if checked then
		tR, tG, tB = 1, 1, 1
	else
		tR, tG, tB = .3, .3, .3
	end

	for _, child in next, self.children do
		if child.radioHeader then -- radio button group
			child.radioHeader:SetTextColor(tR, tG, tB)

			for _, radioButton in pairs(child.buttons) do
				radioButton:SetEnabled(checked)
				radioButton.text:SetTextColor(tR, tG, tB)
			end
		else
			child:SetEnabled(checked)
			child.Text:SetTextColor(tR, tG, tB)

		end

		if child.Low then
			child.Low:SetTextColor(tR, tG, tB)
			child.High:SetTextColor(tR, tG, tB)
			child.value:SetTextColor(tR, tG, tB)
			child:GetThumbTexture():SetVertexColor(tR, tG, tB)
		end
	end


end

local function UpdateSettings()
	for _, box in pairs(checkboxes) do
		if box.children then ToggleChildren(box, box:GetChecked()) end
	end
end

local function OnToggle(self)
	local checked = self:GetChecked()

	if checked then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end

	if self.children then
		ToggleChildren(self, checked)
	end

	for _, frame in next, sidePanels do
		if not checked then
			frame:Hide()
		end
	end
end

local function CombatLockdown(event)
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

function Toggle_FreeUI_GUI() -- this is for binding usage
	if FreeUI_GUI:IsShown() then
		FreeUI_GUI:Hide()
	else
		FreeUI_GUI:Show()
	end
end

local function SelectTab(i)
	for num = 1, #tabsList do
		if num == i then
			guiTab[num]:SetBackdropColor(C.r, C.g, C.b, .25)
			guiTab[num].checked = true
			guiPage[num]:Show()
		else
			guiTab[num]:SetBackdropColor(0, 0, 0, 0)
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
	self:SetBackdropColor(C.r, C.g, C.b, .3)
end

local function tabOnLeave(self)
	if self.checked then return end
	self:SetBackdropColor(0, 0, 0, .3)
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame('Button', nil, parent)
	tab:SetSize(160, 28)


	F.Reskin(tab)

	tab.index = i

	if tab.index >= 15 then
		tab:SetPoint('TOPLEFT', 10, -32*i - 50)
	else
		tab:SetPoint('TOPLEFT', 10, -32*i - 20)
	end

	parent[name] = tab

	tab.icon = tab:CreateTexture(nil, 'OVERLAY')
	tab.icon:SetSize(20, 20)
	tab.icon:SetPoint('LEFT', tab, 6, 0)
	tab.icon:SetTexture(iconsList[i])
	F.ReskinIcon(tab.icon)

	tab.text = F.CreateFS(tab, C.Assets.Fonts.Normal, 13, nil, name or nil, nil, 'THICK')
	tab.text:SetPoint('LEFT', tab.icon, 'RIGHT', 8, 0)

	tab:HookScript('OnClick', tabOnClick)
	tab:HookScript('OnEnter', tabOnEnter)
	tab:HookScript('OnLeave', tabOnLeave)

	return tab
end

local function CreateGUI()
	local f = CreateFrame('Frame', 'FreeUI_GUI', UIParent)
	f:SetSize(600, 640)
	f:SetPoint('CENTER')
	f:SetFrameStrata('HIGH')
	f:EnableMouse(true)
	F.CreateMF(f)
	F.CreateBDFrame(f, nil, true)
	tinsert(UISpecialFrames, f:GetName())

	local verticalLine = f:CreateTexture()
	verticalLine:SetSize(1, 540)
	verticalLine:SetPoint('TOPLEFT', 180, -50)
	verticalLine:SetColorTexture(.5, .5, .5, .1)

	local logo = F.CreateFS(f, C.AssetsPath..'fonts\\header.ttf', 22, nil, C.Title, nil, 'THICK', 'TOP', 0, -4)
	local desc = F.CreateFS(f, C.Assets.Fonts.Number, 10, nil, 'Version: '..C.Version, {.7,.7,.7}, 'THICK', 'TOP', 0, -30)

	local horizontalLineLeft  = CreateFrame('Frame', nil, f)
	horizontalLineLeft:SetPoint('TOP', -60, -26)
	horizontalLineLeft:SetFrameStrata('HIGH')
	F.CreateGF(horizontalLineLeft, 120, 1, 'Horizontal', .7, .7, .7, 0, .7)

	local horizontalLineRight = CreateFrame('Frame', nil, f)
	horizontalLineRight:SetPoint('TOP', 60, -26)
	horizontalLineRight:SetFrameStrata('HIGH')
	F.CreateGF(horizontalLineRight, 120, 1, 'Horizontal', .7, .7, .7, .7, 0)

	local btnClose = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	btnClose:SetPoint('BOTTOMRIGHT', -6, 6)
	btnClose:SetSize(80, 24)
	btnClose:SetText(CLOSE)
	btnClose:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		f:Hide()
	end)
	F.Reskin(btnClose)

	local btnApply = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	btnApply:SetPoint('RIGHT', btnClose, 'LEFT', -6, 0)
	btnApply:SetSize(80, 24)
	btnApply:SetText(APPLY)
	--btnApply:Disable()
	btnApply:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_RELOAD')
		f:Hide()
	end)
	F.Reskin(btnApply)


	for i, name in pairs(tabsList) do
		guiTab[i] = CreateTab(f, i, name)

		guiPage[i] = CreateFrame('ScrollFrame', 'FreeUI_GUI_'..name, f, 'UIPanelScrollFrameTemplate')
		guiPage[i]:SetPoint('TOPLEFT', 190, -50)
		guiPage[i]:SetSize(380, 540)
		F.CreateBDFrame(guiPage[i], .3)
		guiPage[i]:Hide()

		guiPage[i].child = CreateFrame('Frame', nil, guiPage[i])
		guiPage[i].child:SetSize(380, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		F.ReskinScroll(guiPage[i].ScrollBar)

		local header = F.CreateFS(guiPage[i].child, C.Assets.Fonts.Header, 14, nil, name or nil, 'CLASS', 'THICK', 'TOPLEFT', 14, -16)
		guiPage[i].header = header

		local desc = F.CreateFS(guiPage[i].child, C.Assets.Fonts.Normal, 12, nil, name, {.8, .8, .8}, 'THICK')
		desc:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -8)
		desc:SetJustifyH('LEFT')
		desc:SetJustifyV('TOP')
		desc:SetSize(360, 30)
		guiPage[i].desc = desc

		FreeUI_GUI[name] = guiPage[i].child
		FreeUI_GUI[name].header = header
		FreeUI_GUI[name].desc = desc
	end

	SelectTab(1)
end

local function CreateGameMenuButton()
	local bu = CreateFrame('Button', 'GameMenuFrameFreeUI', GameMenuFrame, 'GameMenuButtonTemplate')
	bu:SetText(C.Title)
	bu:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	if FreeADB.appearance.reskin_blizz then F.Reskin(bu) end

	GameMenuFrame:HookScript('OnShow', function(self)
		GameMenuButtonLogout:SetPoint('TOP', bu, 'BOTTOM', 0, -14)
		self:SetHeight(self:GetHeight() + bu:GetHeight() + 15)
	end)

	bu:SetScript('OnClick', function()
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.RedColor..ERR_NOT_IN_COMBAT) return end
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		HideUIPanel(GameMenuFrame)
		FreeUI_GUI:Show()
	end)
end

-- Subcategory
function GUI:AddSubCategory(category, name)
	local header = F.CreateFS(category, C.Assets.Fonts.Normal, 12, nil, name or 'Sub category', 'YELLOW', 'THICK')

	local line = category:CreateTexture(nil, 'ARTWORK')
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

	f.header = F.CreateFS(f, C.Assets.Fonts.Normal, 12, nil, header, 'YELLOW', 'THICK', 'TOPLEFT', 20, -25)

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

	F.CreateBDFrame(f, nil, true)
	F.CreateBDFrame(f.child, .3)
	F.Reskin(f.close)

	return f
end

-- Checkbox
function GUI:CreateCheckBox(parent, key, value, callback, extra, caution)
	local checkbox = F.CreateCheckBox(parent)
	checkbox:SetSize(20, 20)
	checkbox:SetHitRectInsets(-5, -5, -5, -5)

	checkbox.Text = F.CreateFS(checkbox, C.Assets.Fonts.Normal, 12, nil, L['GUI_'..strupper(key)..'_'..strupper(value)] or value, caution and 'RED' or nil, 'THICK', 'LEFT', 20, 0)

	checkbox:SetChecked(SaveValue(key, value))
	checkbox:SetScript('OnClick', function()
		SaveValue(key, value, checkbox:GetChecked())
		if callback then callback() end
	end)
	checkbox:HookScript('OnClick', OnToggle)

	if extra and type(extra) == 'function' then
		local bu = CreateGearButton(parent)
		bu:SetPoint('LEFT', checkbox.Text, 'RIGHT', 0, 1)
		bu:SetScript('OnClick', extra)

		checkbox.bu = bu
	end

	if L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'] then
		checkbox.title = L['GUI_TIPS']
		F.AddTooltip(checkbox, 'ANCHOR_RIGHT', L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'], 'BLUE')
	end

	tinsert(checkboxes, checkbox)

	return checkbox
end

-- Sliders
function GUI:CreateSlider(parent, key, value, callback, extra)
	local minValue, maxValue, step = unpack(extra)

	local slider = F.CreateSlider(parent, value, minValue, maxValue, step, 160)
	slider.Text:SetText(L['GUI_'..strupper(key)..'_'..strupper(value)] or value)
	slider.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]
	slider:SetValue(SaveValue(key, value))
	slider:SetScript('OnValueChanged', function(_, v)
		local current = F:Round(tonumber(v), 2)
		SaveValue(key, value, current)
		slider.value:SetText(current)
		if callback then callback() end
	end)

	slider.value:SetText(F:Round(SaveValue(key, value), 2))

	if L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'] then
		slider.title = L['GUI_TIPS']
		F.AddTooltip(slider, 'ANCHOR_RIGHT', L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'], 'BLUE')
	end

	return slider
end

-- Editbox
function GUI:CreateEditBox(parent, key, value, callback, extra)
	local width, height = unpack(extra)

	local editbox = F.CreateEditBox(parent, width, height)
	editbox:EnableMouse(true)
	editbox:SetMultiLine(true)
	editbox:SetMaxLetters(9999)
	editbox:SetText(SaveValue(key, value))
	editbox:SetJustifyH('LEFT')
	editbox:SetJustifyV('TOP')

	editbox.text = editbox:GetRegions()
	-- if editbox.text:GetObjectType() == 'FontString' then
	-- 	editbox.text:SetJustifyH("RIGHT")
	-- end

	editbox:HookScript('OnEscapePressed', function()
		editbox:SetText(SaveValue(key, value))
	end)

	editbox:HookScript('OnEnterPressed', function()
		SaveValue(key, value, editbox:GetText())
		if callback then callback() end
	end)

	editbox.title = F.CreateFS(editbox, C.Assets.Fonts.Normal, 12, nil, L['GUI_'..strupper(key)..'_'..strupper(value)] or value, 'SYSTEM', true)
	editbox.title:SetPoint('BOTTOM', editbox, 'TOP', 0, 6)


	if L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'] then
		editbox.title = L['GUI_TIPS']
		F.AddTooltip(editbox, 'ANCHOR_RIGHT', L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'], 'BLUE')
	end

	return editbox
end

-- Dropdown
function GUI:CreateDropDown(parent, key, value, callback, extra)
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

	F.CreateFS(dropdown, C.Assets.Fonts.Normal, 11, nil, L['GUI_'..strupper(key)..'_'..strupper(value)] or value, 'INFO', 'THICK', 'CENTER', 0, 20)

	return dropdown
end

-- Color swatch
function GUI:CreateColorSwatch(parent, key, value)
	local f = F.CreateColorSwatch(parent, L['GUI_'..strupper(key)..'_'..strupper(value)] or value, SaveValue(key, value))

	return f
end


function GUI:OnLogin()
	CreateGUI()
	CreateGameMenuButton()

	GUI:AddOptions()

	UpdateSettings()

	F:RegisterEvent('PLAYER_REGEN_DISABLED', CombatLockdown)
end

