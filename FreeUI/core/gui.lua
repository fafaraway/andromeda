local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')



local sidePanelsTable = {}
local guiTab, guiPage, f, dataFrame = {}, {}

local moduleList = {
	'GENERAL',
	'THEME',
	'NOTIFICATION',
	'ANNOUNCEMENT',
	'AUTOMATION',
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
}

local moduleIconList = {
	'Interface\\ICONS\\Ability_Crown_of_the_Heavens_Icon',
	'Interface\\ICONS\\Ability_Hunter_BeastWithin',
	'Interface\\ICONS\\Ability_Warrior_Revenge',
	'Interface\\ICONS\\Ability_Warrior_RallyingCry',
	'Interface\\ICONS\\Ability_Siege_Engineer_Magnetic_Crush',
	'Interface\\ICONS\\Ability_Priest_Ascension',
	'Interface\\ICONS\\Spell_Shadow_Seduction',
	'Interface\\ICONS\\Spell_Shadow_Shadesofdarkness',
	'Interface\\ICONS\\Spell_Holy_SearingLightPriest',
	'Interface\\ICONS\\Ability_Parry',
	'Interface\\ICONS\\INV_Misc_Bag_30',
	'Interface\\ICONS\\Achievement_Ashran_Tourofduty',
	'Interface\\ICONS\\ABILITY_Rogue_RollTheBones04',
	'Interface\\ICONS\\INV_Misc_ScrollUnrolled03d',
	'Interface\\ICONS\\Ability_Mage_MassInvisibility',
}

local function SelectTab(i)
	for num = 1, #moduleList do
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
	self:SetBackdropColor(cr, cg, cb, .3)
end

local function tabOnLeave(self)
	if self.checked then return end
	self:SetBackdropColor(0, 0, 0, .3)
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame('Button', nil, parent)
	tab:SetSize(140, 28)
	tab:SetPoint('TOPLEFT', 10, -32*i - 20)

	F.Reskin(tab)

	tab.index = i

	tab.icon = tab:CreateTexture(nil, 'OVERLAY')
	tab.icon:SetSize(20, 20)
	tab.icon:SetPoint('LEFT', tab, 6, 0)
	tab.icon:SetTexture(moduleIconList[i])
	F.ReskinIcon(tab.icon)

	tab.text = F.CreateFS(tab, C.Assets.Fonts.Normal, 13, nil, L[name] or nil, 'CLASS', 'THICK')
	tab.text:SetPoint('LEFT', tab.icon, 'RIGHT', 8, 0)

	tab:HookScript('OnClick', tabOnClick)
	tab:HookScript('OnEnter', tabOnEnter)
	tab:HookScript('OnLeave', tabOnLeave)

	return tab
end

local function CreateGearButton(self, name)
	local bu = CreateFrame('Button', name, self)
	bu:SetSize(20, 20)
	bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture('Interface\\AddOns\\FreeUI\\assets\\textures\\gear_tex')
	bu.Icon:SetVertexColor(.6, .6, .6)
	bu:SetHighlightTexture('Interface\\AddOns\\FreeUI\\assets\\textures\\gear_tex')

	return bu
end

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

local function CreateSidePanel(parent, name, title)
	local frame = CreateFrame('Frame', name, parent)
	frame:SetSize(200, 640)
	frame:SetPoint('TOPLEFT', parent:GetParent(), 'TOPRIGHT', 3, 0)

	frame.header = frame:CreateFontString(nil, 'ARTWORK', 'SystemFont_Shadow_Med3')
	frame.header:SetPoint('TOPLEFT', 20, -25)
	frame.header:SetText('|cffe9c55d'..title..'|r')
	frame.header:SetShadowColor(0, 0, 0, 1)
	frame.header:SetShadowOffset(2, -2)

	frame.bg = CreateFrame('Frame', nil, frame)
	frame.bg:SetSize(180, 540)
	frame.bg:SetPoint('TOPLEFT', 10, -50)

	frame.close = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate')
	frame.close:SetPoint('BOTTOM', 0, 6)
	frame.close:SetSize(80, 24)
	frame.close:SetText(CLOSE)
	frame.close:SetScript('OnClick', function()
		frame:Hide()
	end)

	parent:HookScript('OnHide', function()
		if frame:IsShown() then frame:Hide() end
	end)

	F.SetBD(frame)
	F.CreateBDFrame(frame.bg, .3)
	F.Reskin(frame.close)

	tinsert(sidePanelsTable, frame)

	return frame
end

local function TogglePanel(frame)
	if frame:IsShown() then
		frame:Hide()
	else
		frame:Show()
	end
end

local function ToggleSidePanel(name)
	for _, frame in next, sidePanelsTable do
		if frame:GetName() == name then
			TogglePanel(frame)
		else
			frame:Hide()
		end
	end
end


local auraSizeSidePanel
local function SetupUnitFrame(parent)
	print('toggle 1')
	ToggleSidePanel('AuraSizeSidePanel')
	print('toggle 2')



	if auraSizeSidePanel then return end
	print('toggle 3')
	auraSizeSidePanel = CreateSidePanel(parent, 'AuraSizeSidePanel', 'test test')

	print('toggle 4')
end



local function SetupAuraSize()
	SetupUnitFrame(guiPage[8])
end





local optionList = { -- type, key, value, name, horizon, doubleline
	[1] = {

	},
	[2] = {
		{1, 'theme', 'cursor_trail', L['AURA_ENABLE']},
		{1, 'theme', 'vignetting', L['AURA_REMINDER']},
		{3, 'theme', 'vignetting_alpha', 'vignetting_alpha', true, {.1, 1, .01}},
	},
	[3] = {

	},
	[4] = {

	},
	[5] = {

	},
	[6] = {

	},
	[7] = {

	},
	[8] = {
		{1, 'aura', 'enable_aura', L['AURA_ENABLE'], nil, SetupAuraSize},
		{1, 'aura', 'buff_reminder', L['AURA_REMINDER'], true},
		{},--blank
		{1, 'aura', 'enable_aura', L['AURA_ENABLE']},
		{1, 'aura', 'buff_reminder', L['AURA_REMINDER'], true},
	},
	[9] = {

	},
	[10] = {

	},
	[11] = {

	},
	[12] = {

	},
	[13] = {

	},
	[14] = {

	},
	[15] = {

	},
}





local function CreateOption(i)
	local parent, offset = guiPage[i].child, 80

	for _, option in pairs(optionList[i]) do
		local optType, key, value, name, horizon, data, callback, tooltip = unpack(option)
		-- Checkboxes
		if optType == 1 then
			local cb = F.CreateCheckBox(parent)
			cb:SetSize(20, 20)
			cb:SetHitRectInsets(-5, -5, -5, -5)

			if type(horizon) == 'table' then
				cb:SetPoint(unpack(horizon))
			elseif horizon then
				cb:SetPoint('TOPLEFT', 200, -offset + 35)
			else
				cb:SetPoint('TOPLEFT', 10, -offset)
				offset = offset + 35
			end

			cb.name = F.CreateFS(cb, C.Assets.Fonts.Normal, 12, nil, name, nil, 'THICK', 'LEFT', 30, 0)

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

			if tooltip then
				cb.title = 'Tips'
				F.AddTooltip(cb, 'ANCHOR_RIGHT', tooltip, 'BLUE')
			end

		elseif optType == 3 then
			local min, max, step = unpack(data)
			local x, y
			if horizon then
				x, y = 200, -offset + 35
			else
				x, y = 40, -offset - 30
				offset = offset + 70
			end
			local s = F.CreateSlider(parent, name, min, max, step, x, y)
			s.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]
			s:SetValue(SaveValue(key, value))
			s:SetScript('OnValueChanged', function(_, v)
				local current = F:Round(tonumber(v), 2)
				SaveValue(key, value, current)
				s.value:SetText(current)
				if callback then callback() end
			end)
			s.value:SetText(F:Round(SaveValue(key, value), 2))
			if tooltip then
				s.title = 'Tips'
				F.AddTooltip(s, 'ANCHOR_RIGHT', tooltip, 'BLUE')
			end

		else
			if not key then
				local line = CreateFrame('Frame', nil, parent)
				line:SetPoint('TOPLEFT', 10, -offset - 10)
				F.CreateGF(line, 360, C.Mult, 'Horizontal', 1, 1, 1, .25, .25)
			end
			offset = offset + 35
		end
	end

	local footer = CreateFrame('Frame', nil, parent)
	footer:SetSize(20, 20)
	footer:SetPoint('TOPLEFT', 25, -offset)
end













local function CreateGUIFrame()
	if f then f:Show() return end

	local f = CreateFrame('Frame', 'FreeUI_GUI', UIParent)
	f:SetSize(580, 640)
	f:SetPoint('CENTER')
	f:SetFrameStrata('HIGH')
	f:EnableMouse(true)
	F.CreateMF(f)
	F.CreateBDFrame(f, nil, true)
	tinsert(UISpecialFrames, f:GetName())


	f.logo = f:CreateTexture()
	f.logo:SetSize(512, 128)
	f.logo:SetPoint('TOP')
	f.logo:SetTexture(C.Assets.logo_small)
	f.logo:SetScale(.3)

	f.desc = F.CreateFS(f, C.Assets.Fonts.Pixel, 8, 'OUTLINE, MONOCHROME', C.Version, {.7,.7,.7}, false, 'TOP', 0, -30)

	f.horizontalLeft = CreateFrame('Frame', nil, f)
	f.horizontalLeft:SetPoint('TOP', -60, -26)
	f.horizontalLeft:SetFrameStrata('HIGH')
	F.CreateGF(f.horizontalLeft, 120, 1, 'Horizontal', .7, .7, .7, 0, .7)

	f.horizontalRight = CreateFrame('Frame', nil, f)
	f.horizontalRight:SetPoint('TOP', 60, -26)
	f.horizontalRight:SetFrameStrata('HIGH')
	F.CreateGF(f.horizontalRight, 120, 1, 'Horizontal', .7, .7, .7, .7, 0)

	f.vertical = f:CreateTexture()
	f.vertical:SetSize(1, 540)
	f.vertical:SetPoint('TOPLEFT', 160, -50)
	f.vertical:SetColorTexture(.5, .5, .5, .1)

	f.closeButton = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.closeButton:SetPoint('BOTTOMRIGHT', -6, 6)
	f.closeButton:SetSize(80, 24)
	f.closeButton:SetText(CLOSE)
	f.closeButton:SetScript('OnClick', function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		f:Hide()
	end)
	F.Reskin(f.closeButton)

	f.okayButton = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	f.okayButton:SetPoint('RIGHT', f.closeButton, 'LEFT', -6, 0)
	f.okayButton:SetSize(80, 24)
	f.okayButton:SetText(OKAY)
	f.okayButton:Disable()
	F.Reskin(f.okayButton)

	f.needReload = f:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	f.needReload:SetPoint('BOTTOM', 0, 12)
	f.needReload:SetText('GUI.localization.misc.need_reload')
	f.needReload:Hide()


	for i, name in pairs(moduleList) do
		guiTab[i] = CreateTab(f, i, name)

		guiPage[i] = CreateFrame('ScrollFrame', name, f, 'UIPanelScrollFrameTemplate')
		guiPage[i]:SetPoint('TOPLEFT', 170, -50)
		guiPage[i]:SetSize(380, 520)
		F.CreateBDFrame(guiPage[i], .3)
		guiPage[i]:Hide()
		guiPage[i].child = CreateFrame('Frame', nil, guiPage[i])
		guiPage[i].child:SetSize(380, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		F.ReskinScroll(guiPage[i].ScrollBar)

		local header = F.CreateFS(guiPage[i].child, C.Assets.Fonts.Normal, 14, nil, L[name] or nil, 'CLASS', 'THICK', 'TOPLEFT', 14, -16)

		local desc = F.CreateFS(guiPage[i].child, C.Assets.Fonts.Normal, 12, nil, L[name..'_DESC'] or nil, {.8, .8, .8}, 'THICK')
		desc:SetPoint('TOPLEFT', header, 'BOTTOMLEFT', 0, -8)
		desc:SetJustifyH('LEFT')
		desc:SetJustifyV('TOP')
		desc:SetSize(360, 30)

		CreateOption(i)
	end

	local function showLater(event)
		if event == 'PLAYER_REGEN_DISABLED' then
			if f:IsShown() then
				f:Hide()
				F:RegisterEvent('PLAYER_REGEN_ENABLED', showLater)
			end
		else
			f:Show()
			F:UnregisterEvent(event, showLater)
		end
	end
	F:RegisterEvent('PLAYER_REGEN_DISABLED', showLater)

	SelectTab(1)
end


local function CreateGameMenuButton()
	local b = CreateFrame('Button', 'GameMenuFrameFreeUI', GameMenuFrame, 'GameMenuButtonTemplate')
	b:SetText(C.Title)
	b:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	if FreeUIConfigs['theme']['reskin_blizz'] then F.Reskin(b) end

	GameMenuFrame:HookScript('OnShow', function(self)
		GameMenuButtonLogout:SetPoint('TOP', b, 'BOTTOM', 0, -14)
		self:SetHeight(self:GetHeight() + b:GetHeight() + 15)
	end)

	b:SetScript('OnClick', function()
		if InCombatLockdown() then UIErrorsFrame:AddMessage(C.RedColor..ERR_NOT_IN_COMBAT) return end
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		HideUIPanel(GameMenuFrame)
		CreateGUIFrame()
	end)
end








function GUI:OnLogin()

	CreateGameMenuButton()

end
