local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')


local checkboxes = {}
local sidePanels = {}
local offset = 50
local activeTab = nil


local function SaveValue(key, value, newValue)
	if key == 'ACCOUNT' then
		if newValue ~= nil then
			FreeUIConfigsGlobal[value] = newValue
		else
			return FreeUIConfigsGlobal[value]
		end
	else
		if newValue ~= nil then
			FreeUIConfigs[key][value] = newValue
		else
			return FreeUIConfigs[key][value]
		end
	end
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

	for _, frame in next, sidePanels do
		if not checked then
			frame:Hide()
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

	UpdateSettings()

	if self.children then
		ToggleChildren(self, checked)
	end

	UpdateSettings()
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

	f.verticalLine = f:CreateTexture()
	f.verticalLine:SetSize(1, 540)
	f.verticalLine:SetPoint('TOPLEFT', 180, -50)
	f.verticalLine:SetColorTexture(.5, .5, .5, .1)

	f.logo = F.CreateFS(f, C.AssetsPath..'fonts\\header.ttf', 22, nil, C.Title, nil, 'THICK', 'TOP', 0, -4)
	f.desc = F.CreateFS(f, C.Assets.Fonts.Number, 10, nil, 'Version: '..C.Version, {.7,.7,.7}, 'THICK', 'TOP', 0, -30)

	f.horizontalLineLeft  = CreateFrame('Frame', nil, f)
	f.horizontalLineLeft:SetPoint('TOP', -60, -26)
	F.CreateGF(f.horizontalLineLeft, 120, 1, 'Horizontal', .7, .7, .7, 0, .7)
	f.horizontalLineLeft:SetFrameStrata('HIGH')

	f.horizontalLineRight = CreateFrame('Frame', nil, f)
	f.horizontalLineRight:SetPoint('TOP', 60, -26)
	F.CreateGF(f.horizontalLineRight, 120, 1, 'Horizontal', .7, .7, .7, .7, 0)
	f.horizontalLineRight:SetFrameStrata('HIGH')

	f.close = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.close:SetPoint('BOTTOMRIGHT', -6, 6)
	f.close:SetSize(80, 24)
	f.close:SetText(CLOSE)
	f.close:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		f:Hide()
	end)
	F.Reskin(f.close)

	f.okay = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.okay:SetPoint('RIGHT', f.close, 'LEFT', -6, 0)
	f.okay:SetSize(80, 24)
	f.okay:SetText(APPLY)
	--f.okay:Disable()
	f.okay:SetScript('OnClick', function()
		StaticPopup_Show('FREEUI_RELOAD')
		f:Hide()
	end)
	F.Reskin(f.okay)

	local function CombatLockdown(event)
		if event == 'PLAYER_REGEN_DISABLED' then
			if f:IsShown() then
				f:Hide()
				F:RegisterEvent('PLAYER_REGEN_ENABLED', CombatLockdown)
			end
		else
			f:Show()
			F:UnregisterEvent(event, CombatLockdown)
		end
	end
	F:RegisterEvent('PLAYER_REGEN_DISABLED', CombatLockdown)
end

local function CreateGameMenuButton()
	local bu = CreateFrame('Button', 'GameMenuFrameFreeUI', GameMenuFrame, 'GameMenuButtonTemplate')
	bu:SetText(C.Title)
	bu:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	if FreeUIConfigs['theme']['reskin_blizz'] then F.Reskin(bu) end

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

local function SetActiveTab(tab)
	activeTab = tab
	activeTab:SetBackdropColor(C.r, C.g, C.b, .25)
	activeTab.panel:Show()
end

local onTabClick = function(tab)
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	activeTab.panel:Hide()
	activeTab:SetBackdropColor(0, 0, 0, 0)
	SetActiveTab(tab)
end

local function AddCategory(name)
	local tag = name

	local f = CreateFrame('ScrollFrame', 'FreeUI_GUI_'..name, FreeUI_GUI, 'UIPanelScrollFrameTemplate')
	f:SetSize(380, 540)
	f:SetPoint('TOPLEFT', 190, -50)
	f:Hide()
	F.CreateBDFrame(f, .3)

	f.child = CreateFrame('Frame', nil, f)
	f.child:SetPoint('TOPLEFT', 0, 0)
	f.child:SetPoint('BOTTOMRIGHT', 0, 0)
	f.child:SetSize(420, 1)

	f:SetScrollChild(f.child)
	F.ReskinScroll(f.ScrollBar)

	f.Title = F.CreateFS(f.child, C.Assets.Fonts.Normal, 14, nil, L['GUI_'..name] or name, 'YELLOW', 'THICK', 'TOPLEFT', 14, -16)

	f.subText = F.CreateFS(f.child, C.Assets.Fonts.Normal, 12, nil, L['GUI_'..name..'_DESC'] or name, 'GREY', 'THICK')
	f.subText:SetPoint('TOPLEFT', f.Title, 'BOTTOMLEFT', 0, -8)
	f.subText:SetJustifyH('LEFT')
	f.subText:SetJustifyV('TOP')
	f.subText:SetSize(420, 30)

	local tab = CreateFrame('Button', nil, FreeUI_GUI)
	tab:SetPoint('TOPLEFT', 10, -offset)
	tab:SetSize(160, 28)
	F.Reskin(tab)

	local icon = tab:CreateTexture(nil, 'OVERLAY')
	icon:SetSize(20, 20)
	icon:SetPoint('LEFT', tab, 6, 0)
	icon:SetTexture('Interface\\ICONS\\INV_Misc_QuestionMark')
	F.ReskinIcon(icon)
	tab.icon = icon

	tab.Text = tab:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med3')
	tab.Text:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
	tab.Text:SetTextColor(.9, .9, .9)
	tab.Text:SetText(L['GUI_'..name] or name)

	tab:SetScript('OnMouseUp', onTabClick)

	tab.panel = f
	f.tab = tab

	FreeUI_GUI[tag] = f

	offset = offset + 32
end

function GUI:AddSubCategory(category, name)
	local header = F.CreateFS(category.child, C.Assets.Fonts.Normal, 12, nil, name or 'Sub category', 'YELLOW', 'THICK')

	local line = category.child:CreateTexture(nil, 'ARTWORK')
	line:SetSize(350, 1)
	line:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -4)
	line:SetColorTexture(.5, .5, .5, .1)

	header.line = line

	return header, line
end

function GUI:CreateSidePanel(parent, name, title)
	local f = CreateFrame('Frame', name, parent)
	f:SetSize(200, 640)
	f:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)
	f:Hide()

	f.header = F.CreateFS(f, C.Assets.Fonts.Normal, 12, nil, title, 'YELLOW', 'THICK', 'TOPLEFT', 20, -25)

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

function GUI:ToggleSidePanel(name)
	for _, frame in next, sidePanels do
		if frame:GetName() == name then
			F:TogglePanel(frame)
		else
			frame:Hide()
		end
	end
end

function GUI:CreateGearButton(name)
	local bu = CreateFrame('Button', name, self)
	bu:SetSize(20, 20)
	bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(C.Assets.gear_tex)
	bu.Icon:SetVertexColor(.6, .6, .6)
	bu:SetHighlightTexture(C.Assets.gear_tex)

	return bu
end

-- Checkboxes
function GUI:CreateCheckBox(parent, key, value, callback, extra, caution)
	local checkbox = F.CreateCheckBox(parent.child)
	checkbox:SetSize(20, 20)
	checkbox:SetHitRectInsets(-5, -5, -5, -5)

	checkbox.Text = F.CreateFS(checkbox, C.Assets.Fonts.Normal, 12, nil, L['GUI_'..strupper(key)..'_'..strupper(value)] or value, caution and 'RED' or nil, 'THICK', 'LEFT', 24, 0)

	checkbox:SetChecked(SaveValue(key, value))
	checkbox:SetScript('OnClick', function()
		SaveValue(key, value, checkbox:GetChecked())
		if callback then callback() end
	end)
	checkbox:HookScript('OnClick', OnToggle)

	if extra and type(extra) == 'function' then
		local bu = GUI.CreateGearButton(parent.child)
		bu:SetPoint('LEFT', checkbox.Text, 'RIGHT', 0, 1)
		bu:SetScript('OnClick', extra)

		checkbox.bu = bu
	end

	if L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'] then
		checkbox.title = L['GUI_TIPS']
		F.AddTooltip(checkbox, 'ANCHOR_RIGHT', L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'], 'INFO')
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
		F.AddTooltip(slider, 'ANCHOR_RIGHT', L['GUI_'..strupper(key)..'_'..strupper(value)..'_TIP'], 'INFO')
	end

	return slider
end

-- Editbox
function GUI:CreateEditBox(parent, width, height, maxLetters)
	local editbox = F.CreateEditBox(parent, width, height)
	editbox:SetMaxLetters(maxLetters)
	editbox:SetText(SaveValue(key, value))

	editbox:HookScript('OnEscapePressed', function()
		editbox:SetText(SaveValue(key, value))
	end)

	editbox:HookScript('OnEnterPressed', function()
		SaveValue(key, value, editbox:GetText())
		if callback then callback() end
	end)

	editbox.title = 'Tips'
	local tip = 'EditBox Tip'
	if tooltip then tip = tooltip..'|n'..tip end
	F.AddTooltip(editbox, 'ANCHOR_RIGHT', tip, 'INFO')

	F.CreateFS(editbox, C.Assets.Fonts.Normal, 12, nil, name, 'SYSTEM', true, 'CENTER', 0, 25)
end

-- Dropdown
function GUI:CreateDropDown(parent, key, value, callback, extra)
	local dropdown = F.CreateDropDown(parent.child, 120, 22, extra)

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

-- Colorswatch
function GUI:CreateColorSwatch(parent, key, value)
	local f = F.CreateColorSwatch(parent.child, L['GUI_'..strupper(key)..'_'..strupper(value)] or value, SaveValue(key, value))
	local width = 30

	return f
end


function GUI:OnLogin()

	CreateGUI()
	CreateGameMenuButton()

	AddCategory('APPEARANCE')
	AddCategory('NOTIFICATION')
	AddCategory('ANNOUNCEMENT')
	AddCategory('AUTOMATION')
	AddCategory('INFOBAR')
	AddCategory('CHAT')
	AddCategory('AURA')
	AddCategory('ACTIONBAR')
	AddCategory('COMBAT')
	AddCategory('INVENTORY')
	AddCategory('MAP')
	AddCategory('QUEST')
	AddCategory('TOOLTIP')
	AddCategory('UNITFRAME')
	AddCategory('MISC')
	AddCategory('CREDITS')

	SetActiveTab(FreeUI_GUI.APPEARANCE.tab)

	self.AddOptions()

	UpdateSettings()
end

