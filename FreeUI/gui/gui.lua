local F, C, L = unpack(select(2, ...))
local GUI = F.GUI

local guiTab = {}
local guiPage = {}
GUI.Tab = guiTab
GUI.Page = guiPage

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
	L.GUI.GROUPFRAME.NAME,
	L.GUI.NAMEPLATE.NAME,
	L.GUI.MISC.NAME,
	L.GUI.PROFILE.NAME,
	L.GUI.CREDITS.NAME
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
	'Interface\\ICONS\\Spell_Priest_Pontifex',
	'Interface\\ICONS\\Ability_Paladin_BeaconsOfLight',
	'Interface\\ICONS\\ABILITY_MONK_SERENITY',
	'Interface\\ICONS\\INV_Misc_Blingtron',
	'Interface\\ICONS\\Raf-Icon'
}

GUI.TexturesList = {
	[1] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\norm_tex', name = L.GUI.MISC.TEXTURE_NORM},
	[2] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\grad_tex', name = L.GUI.MISC.TEXTURE_GRAD},
	[3] = {texture = 'Interface\\AddOns\\FreeUI\\assets\\textures\\flat_tex', name = L.GUI.MISC.TEXTURE_FLAT}
}

local function AddTextureToOption(parent, index)
	local tex = parent[index]:CreateTexture()
	tex:SetInside(nil, 4, 4)
	tex:SetTexture(GUI.TexturesList[index].texture)
	tex:SetVertexColor(.6, .6, .6)
end

local function UpdateValue(key, value, newValue)
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

local function CreateGearButton(self, name)
	local bu = CreateFrame('Button', name, self)
	bu:SetSize(20, 20)
	bu.Icon = bu:CreateTexture(nil, 'ARTWORK')
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(C.Assets.gear_tex)
	bu.Icon:SetVertexColor(.6, .6, .6)
	bu:SetHighlightTexture(C.Assets.gear_tex)

	return bu
end

local function CombatLockdown(event)
	if not FreeUI_GUI then
		return
	end

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
	if self.checked then
		return
	end
	self.__bg:SetBackdropColor(C.r, C.g, C.b, .25)
end

local function tabOnLeave(self)
	if self.checked then
		return
	end
	self.__bg:SetBackdropColor(0, 0, 0, 0)
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame('Button', nil, parent, 'BackdropTemplate')
	tab:SetSize(140, 26)
	F.Reskin(tab)

	tab.index = i

	-- if tab.index >= 15 then
	-- 	tab:SetPoint('TOPLEFT', 10, -31*i - 30)
	-- else
	tab:SetPoint('TOPLEFT', 10, -31 * i - 20)
	-- end

	--parent[name] = tab

	tab.icon = tab:CreateTexture(nil, 'OVERLAY')
	tab.icon:SetSize(20, 20)
	tab.icon:SetPoint('LEFT', tab, 3, 0)
	tab.icon:SetTexture(iconsList[i])
	F.ReskinIcon(tab.icon)

	tab.text = F.CreateFS(tab, C.Assets.Fonts.Regular, 13, 'OUTLINE', name, nil, true)
	tab.text:SetPoint('LEFT', tab.icon, 'RIGHT', 6, 0)

	tab:HookScript('OnClick', tabOnClick)
	tab:HookScript('OnEnter', tabOnEnter)
	tab:HookScript('OnLeave', tabOnLeave)

	return tab
end

local function CreateOption(i)
	local parent, offset = guiPage[i].child, 20

	for _, option in pairs(GUI.OptionsList[i]) do
		local optType, key, value, name, horizon, data, callback, tip = unpack(option)
		if optType == 1 then -- checkbox
			local cb = F.CreateCheckBox(parent, true, nil, true)
			cb:SetSize(20, 20)
			cb:SetHitRectInsets(-5, -5, -5, -5)

			cb.name = F.CreateFS(cb, C.Assets.Fonts.Regular, 12, nil, name, nil, true, 'LEFT', 22, 0)

			if horizon then
				cb:SetPoint('TOPLEFT', 250, -offset + 35)
			else
				cb:SetPoint('TOPLEFT', 20, -offset)
				offset = offset + 35
			end

			cb:SetChecked(UpdateValue(key, value))

			cb:SetScript(
				'OnClick',
				function()
					UpdateValue(key, value, cb:GetChecked())
					if callback then
						callback()
					end
				end
			)

			if data and type(data) == 'function' then
				local bu = CreateGearButton(parent)
				bu:SetPoint('LEFT', cb.name, 'RIGHT', -2, 1)
				bu:SetScript('OnClick', data)
			end

			if tip then
				F.AddTooltip(cb, 'ANCHOR_TOPLEFT', tip, 'BLUE')
			end
		elseif optType == 2 then -- editbox
			local eb = F.CreateEditBox(parent, 140, 24)
			eb:SetMaxLetters(999)

			eb.name = F.CreateFS(eb, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'CENTER', 0, 25)

			if horizon then
				eb:SetPoint('TOPLEFT', 250, -offset + 45)
			else
				eb:SetPoint('TOPLEFT', 20, -offset - 25)
				offset = offset + 70
			end

			eb:SetText(UpdateValue(key, value))

			eb:HookScript(
				'OnEscapePressed',
				function()
					eb:SetText(UpdateValue(key, value))
				end
			)

			eb:HookScript(
				'OnEnterPressed',
				function()
					UpdateValue(key, value, eb:GetText())
					if callback then
						callback()
					end
				end
			)

			if tip then
				F.AddTooltip(eb, 'ANCHOR_TOPLEFT', tip, 'BLUE')
			end
		elseif optType == 3 then -- slider
			local min, max, step = unpack(data)

			local x, y
			if horizon then
				x, y = 250, -offset + 40
			else
				x, y = 20, -offset - 30
				offset = offset + 70
			end

			local s = F.CreateSlider(parent, name, min, max, step, x, y, 180, tip)
			s.__default = (key == 'ACCOUNT' and C.AccountSettings[value]) or C.CharacterSettings[key][value]

			s:SetValue(UpdateValue(key, value))

			s:SetScript(
				'OnValueChanged',
				function(_, v)
					local current = F:Round(tonumber(v), 2)
					UpdateValue(key, value, current)
					s.value:SetText(current)
					if callback then
						callback()
					end
				end
			)

			s.value:SetText(F:Round(UpdateValue(key, value), 2))

			if tip then
				F.AddTooltip(s, 'ANCHOR_TOPLEFT', tip, 'BLUE')
			end
		elseif optType == 4 then -- dropdown
			if value == 'texture_style' then
				for _, v in ipairs(GUI.TexturesList) do
					tinsert(data, v.name)
				end
			end

			local dd = F.CreateDropDown(parent, 140, 20, data)
			if horizon then
				dd:SetPoint('TOPLEFT', 256, -offset + 45)
			else
				dd:SetPoint('TOPLEFT', 26, -offset - 25)
				offset = offset + 70
			end

			dd.Text:SetText(data[UpdateValue(key, value)])

			local opt = dd.options
			dd.button:HookScript(
				'OnClick',
				function()
					for num = 1, #data do
						if num == UpdateValue(key, value) then
							opt[num]:SetBackdropColor(C.r, C.g, C.b, .3)
							opt[num].selected = true
						else
							opt[num]:SetBackdropColor(0, 0, 0, .3)
							opt[num].selected = false
						end
					end
				end
			)
			for i in pairs(data) do
				opt[i]:HookScript(
					'OnClick',
					function()
						UpdateValue(key, value, i)
						if callback then
							callback()
						end
					end
				)
				if value == 'texture_style' then
					AddTextureToOption(opt, i) -- texture preview
				end
			end

			F.CreateFS(dd, C.Assets.Fonts.Regular, 11, nil, name, nil, true, 'CENTER', 0, 25)
			if tip then
				F.AddTooltip(dd, "ANCHOR_RIGHT", tip, "BLUE")
			end
		elseif optType == 5 then -- colorswatch
			local f = F.CreateColorSwatch(parent, name, UpdateValue(key, value))
			local width = 25 + (horizon or 0) * 120
			if horizon then
				f:SetPoint('TOPLEFT', width, -offset + 30)
			else
				f:SetPoint('TOPLEFT', width, -offset - 5)
				offset = offset + 35
			end
		else -- blank, no optType
			if not key then
				local line = F.SetGradient(parent, 'H', .5, .5, .5, .25, .25, 440, C.Mult)
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
	scrollBar:SetValue(scrollBar:GetValue() - delta * 35)
end

local function CreateGUI()
	if _G.FreeUI_GUI then
		_G.FreeUI_GUI:Show()
		return
	end

	local guiFrame = CreateFrame('Frame', 'FreeUI_GUI', UIParent)
	tinsert(_G.UISpecialFrames, 'FreeUI_GUI')
	guiFrame:SetSize(700, 640)
	guiFrame:SetPoint('CENTER')
	guiFrame:SetFrameStrata('HIGH')
	guiFrame:EnableMouse(true)
	F.CreateMF(guiFrame)
	F.SetBD(guiFrame)

	local verticalLine = F.SetGradient(guiFrame, 'V', .5, .5, .5, .25, .25, C.Mult, 540)
	verticalLine:SetPoint('TOPLEFT', 160, -50)

	local logo =
		F.CreateFS(guiFrame, C.AssetsPath .. 'fonts\\header.ttf', 22, nil, C.AddonName, nil, 'THICK', 'TOP', 0, -4)
	local desc =
		F.CreateFS(
		guiFrame,
		C.Assets.Fonts.Regular,
		10,
		nil,
		'Version: ' .. C.AddonVersion,
		{.7, .7, .7},
		'THICK',
		'TOP',
		0,
		-30
	)

	local lineLeft = F.SetGradient(guiFrame, 'H', .7, .7, .7, 0, .7, 120, C.Mult)
	lineLeft:SetPoint('TOP', -60, -26)

	local lineRight = F.SetGradient(guiFrame, 'H', .7, .7, .7, .7, 0, 120, C.Mult)
	lineRight:SetPoint('TOP', 60, -26)

	local btnClose = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
	btnClose:SetPoint('BOTTOMRIGHT', -6, 6)
	btnClose:SetSize(80, 24)
	btnClose:SetText(CLOSE)
	btnClose:SetScript(
		'OnClick',
		function()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
			guiFrame:Hide()
		end
	)
	F.Reskin(btnClose)

	local btnApply = CreateFrame('Button', nil, guiFrame, 'UIPanelButtonTemplate')
	btnApply:SetPoint('RIGHT', btnClose, 'LEFT', -6, 0)
	btnApply:SetSize(80, 24)
	btnApply:SetText(APPLY)
	--btnApply:Disable()
	btnApply:SetScript(
		'OnClick',
		function()
			StaticPopup_Show('FREEUI_RELOAD')
			guiFrame:Hide()
		end
	)
	F.Reskin(btnApply)

	for i, name in pairs(tabsList) do
		guiTab[i] = CreateTab(guiFrame, i, name)

		guiPage[i] = CreateFrame('ScrollFrame', nil, guiFrame, 'UIPanelScrollFrameTemplate')
		guiPage[i]:SetPoint('TOPLEFT', 170, -50)
		guiPage[i]:SetSize(500, 540)
		F.CreateBDFrame(guiPage[i], .25, false, .04, .04, .04)
		guiPage[i]:Hide()

		guiPage[i].child = CreateFrame('Frame', nil, guiPage[i])
		guiPage[i].child:SetSize(500, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		F.ReskinScroll(guiPage[i].ScrollBar)
		guiPage[i]:SetScript('OnMouseWheel', ScrollBarHook)

		CreateOption(i)
	end

	GUI:CreateProfileGUI(guiPage[16])
	GUI:CreateCreditsFrame(guiPage[17])

	SelectTab(1)
end

function F.ToggleGUI()
	if _G.FreeUI_GUI then
		if _G.FreeUI_GUI:IsShown() then
			_G.FreeUI_GUI:Hide()
		else
			_G.FreeUI_GUI:Show()
		end
	else
		CreateGUI()
	end
	_G.PlaySound(_G.SOUNDKIT.IG_MAINMENU_OPTION)
end

function GUI:OnLogin()
	local bu = CreateFrame('Button', 'GameMenuFrameFreeUI', GameMenuFrame, 'GameMenuButtonTemplate')
	bu:SetText(C.AddonName)
	bu:SetPoint('TOP', GameMenuButtonAddons, 'BOTTOM', 0, -14)
	if FREE_ADB.reskin_blizz then
		F.Reskin(bu)
	end

	GameMenuFrame:HookScript(
		'OnShow',
		function(self)
			GameMenuButtonLogout:SetPoint('TOP', bu, 'BOTTOM', 0, -14)
			self:SetHeight(self:GetHeight() + bu:GetHeight() + 15 + 20)

			GameMenuButtonStore:ClearAllPoints()
			GameMenuButtonStore:SetPoint('TOP', GameMenuButtonHelp, 'BOTTOM', 0, -4)

			GameMenuButtonWhatsNew:ClearAllPoints()
			GameMenuButtonWhatsNew:SetPoint('TOP', GameMenuButtonStore, 'BOTTOM', 0, -4)

			GameMenuButtonUIOptions:ClearAllPoints()
			GameMenuButtonUIOptions:SetPoint('TOP', GameMenuButtonOptions, 'BOTTOM', 0, -4)

			GameMenuButtonKeybindings:ClearAllPoints()
			GameMenuButtonKeybindings:SetPoint('TOP', GameMenuButtonUIOptions, 'BOTTOM', 0, -4)

			GameMenuButtonMacros:ClearAllPoints()
			GameMenuButtonMacros:SetPoint('TOP', GameMenuButtonKeybindings, 'BOTTOM', 0, -4)

			GameMenuButtonAddons:ClearAllPoints()
			GameMenuButtonAddons:SetPoint('TOP', GameMenuButtonMacros, 'BOTTOM', 0, -4)

			GameMenuButtonQuit:ClearAllPoints()
			GameMenuButtonQuit:SetPoint('TOP', GameMenuButtonLogout, 'BOTTOM', 0, -4)
		end
	)

	bu:SetScript(
		'OnClick',
		function()
			if InCombatLockdown() then
				UIErrorsFrame:AddMessage(C.RedColor .. ERR_NOT_IN_COMBAT)
				return
			end
			CreateGUI()
			HideUIPanel(GameMenuFrame)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		end
	)

	F:RegisterEvent('PLAYER_REGEN_DISABLED', CombatLockdown)
end
