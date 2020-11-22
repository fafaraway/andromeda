local F, C, L = unpack(select(2, ...))
local GUI = F.GUI

local pairs, strsplit, Ambiguate = pairs, strsplit, Ambiguate
local strfind, tostring, select = strfind, tostring, select
local SetPortraitTexture, StaticPopup_Show = SetPortraitTexture, StaticPopup_Show
local myFullName = C.MyFullName

-- Static popups
StaticPopupDialogs['FREEUI_RESET'] = {
	text = L.GUI.PROFILE.RESET_WARNING,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FREE_DB = {}
		FREE_ADB = {}
		FREE_PDB = {}
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

StaticPopupDialogs['FREEUI_RESET_PROFILE'] = {
	text = L.GUI.PROFILE.RESET_PROFILE_WARNING,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		wipe(C.DB)
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

StaticPopupDialogs['FREEUI_APPLY_PROFILE'] = {
	text = L.GUI.PROFILE.APPLY_SELECTED_PROFILE,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		FREE_ADB['profile_index'][myFullName] = GUI.currentProfile
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

StaticPopupDialogs['FREEUI_DOWNLOAD_PROFILE'] = {
	text = L.GUI.PROFILE.DOWNLOAD_SELECTED_PROFILE,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		local profileIndex = FREE_ADB['profile_index'][myFullName]
		if GUI.currentProfile == 1 then
			FREE_PDB[profileIndex - 1] = FREE_DB
		elseif profileIndex == 1 then
			FREE_DB = FREE_PDB[GUI.currentProfile - 1]
		else
			FREE_PDB[profileIndex - 1] = FREE_PDB[GUI.currentProfile - 1]
		end
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

StaticPopupDialogs['FREEUI_UPLOAD_PROFILE'] = {
	text = L.GUI.PROFILE.UPLOAD_CURRENT_PROFILE,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		if GUI.currentProfile == 1 then
			FREE_DB = C.DB
		else
			FREE_PDB[GUI.currentProfile - 1] = C.DB
		end
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

StaticPopupDialogs['FREEUI_DELETE_UNIT_PROFILE'] = {
	text = '',
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		local name, realm = strsplit('-', self.text.text_arg1)
		if FREE_GOLDCOUNT[realm] and FREE_GOLDCOUNT[realm][name] then
			FREE_GOLDCOUNT[realm][name] = nil
		end
		FREE_ADB['ProfileIndex'][self.text.text_arg1] = nil
	end,
	OnShow = function(self)
		local r, g, b
		local class = self.text.text_arg2
		if class == 'NONE' then
			r, g, b = .5, .5, .5
		else
			r, g, b = F.ClassColor(class)
		end
		self.text:SetText(format(L.GUI.PROFILE.DELETE_UNIT_PROFILE_WARNING, F.HexRGB(r, g, b), self.text.text_arg1))
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false
}

function GUI:CreateProfileIcon(bar, index, texture, title, description)
	local button = CreateFrame('Button', nil, bar)
	button:SetSize(32, 32)
	button:SetPoint('RIGHT', -5 - (index - 1) * 37, 0)
	F.PixelIcon(button, texture, true)
	button.title = title
	F.AddTooltip(button, 'ANCHOR_RIGHT', description, 'BLUE')

	return button
end

function GUI:Reset_OnClick()
	StaticPopup_Show('FREEUI_RESET_PROFILE')
end

function GUI:Apply_OnClick()
	GUI.currentProfile = self:GetParent().index
	StaticPopup_Show('FREEUI_APPLY_PROFILE')
end

function GUI:Download_OnClick()
	GUI.currentProfile = self:GetParent().index
	StaticPopup_Show('FREEUI_DOWNLOAD_PROFILE')
end

function GUI:Upload_OnClick()
	GUI.currentProfile = self:GetParent().index
	StaticPopup_Show('FREEUI_UPLOAD_PROFILE')
end

function GUI:GetClassFromGoldInfo(name, realm)
	local class = 'NONE'
	if FREE_GOLDCOUNT[realm] and FREE_GOLDCOUNT[realm][name] then
		class = FREE_GOLDCOUNT[realm][name][2]
	end

	return class
end

function GUI:FindProfleUser(icon)
	icon.list = {}
	for fullName, index in pairs(FREE_ADB['profile_index']) do
		if index == icon.index then
			local name, realm = strsplit('-', fullName)
			if not icon.list[realm] then
				icon.list[realm] = {}
			end
			icon.list[realm][Ambiguate(fullName, 'none')] = GUI:GetClassFromGoldInfo(name, realm)
		end
	end
end

function GUI:Icon_OnEnter()
	if not next(self.list) then
		return
	end

	GameTooltip:SetOwner(self, 'ANCHOR_TOP')
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L.GUI.PROFILE.SHARED_CHARACTERS)
	GameTooltip:AddLine(' ')
	local r, g, b
	for _, value in pairs(self.list) do
		for name, class in pairs(value) do
			if class == 'NONE' then
				r, g, b = .5, .5, .5
			else
				r, g, b = F.ClassColor(class)
			end
			GameTooltip:AddLine(name, r, g, b)
		end
	end
	GameTooltip:Show()
end

function GUI:Note_OnEscape()
	self:SetText(FREE_ADB['profile_names'][self.index])
end

function GUI:Note_OnEnter()
	local text = self:GetText()
	if text == '' then
		FREE_ADB['profile_names'][self.index] = self.__defaultText
		self:SetText(self.__defaultText)
	else
		FREE_ADB['profile_names'][self.index] = text
	end
end

function GUI:CreateProfileBar(parent, index)
	local bar = F.CreateBDFrame(parent, .25)
	bar:ClearAllPoints()
	bar:SetPoint('TOPLEFT', 10, -10 - 45 * (index - 1))
	bar:SetSize(440, 40)
	bar.index = index

	local icon = CreateFrame('Frame', nil, bar)
	icon:SetSize(32, 32)
	icon:SetPoint('LEFT', 5, 0)
	if index == 1 then
		F.PixelIcon(icon, nil, true) -- character
		SetPortraitTexture(icon.Icon, 'player')
	else
		F.PixelIcon(icon, 235423, true) -- share
		icon.Icon:SetTexCoord(.6, .9, .1, .4)
		icon.index = index
		GUI:FindProfleUser(icon)
		icon:SetScript('OnEnter', GUI.Icon_OnEnter)
		icon:SetScript('OnLeave', F.HideTooltip)
	end

	local note = F.CreateEditBox(bar, 180, 30)
	note:SetPoint('LEFT', icon, 'RIGHT', 5, 0)
	note:SetMaxLetters(20)
	if index == 1 then
		note.__defaultText = L.GUI.PROFILE.DEFAULT_CHARACTER_PROFILE
	else
		note.__defaultText = L.GUI.PROFILE.DEFAULT_SHARED_PROFILE .. (index - 1)
	end
	if not FREE_ADB['profile_names'][index] then
		FREE_ADB['profile_names'][index] = note.__defaultText
	end
	note:SetText(FREE_ADB['profile_names'][index])
	note.index = index
	note:HookScript('OnEnterPressed', GUI.Note_OnEnter)
	note:HookScript('OnEscapePressed', GUI.Note_OnEscape)
	note.title = L.GUI.PROFILE.PROFILE_NAME
	F.AddTooltip(note, 'ANCHOR_TOP', L.GUI.PROFILE.PROFILE_NAME_TIP, 'BLUE')

	local reset = GUI:CreateProfileIcon(bar, 1, 'Atlas:transmog-icon-revert', L.GUI.PROFILE.RESET_PROFILE, L.GUI.PROFILE.RESET_PROFILE_TIP)
	reset:SetScript('OnClick', GUI.Reset_OnClick)
	bar.reset = reset

	local apply = GUI:CreateProfileIcon(bar, 2, 'Interface\\RAIDFRAME\\ReadyCheck-Ready', L.GUI.PROFILE.SELECT_PROFILE, L.GUI.PROFILE.SELECT_PROFILE_TIP)
	apply:SetScript('OnClick', GUI.Apply_OnClick)
	bar.apply = apply

	local download = GUI:CreateProfileIcon(bar, 3, 'Atlas:streamcinematic-downloadicon', L.GUI.PROFILE.DOWNLOAD_PROFILE, L.GUI.PROFILE.DOWNLOAD_PROFILE_TIP)
	download.Icon:SetTexCoord(.25, .75, .25, .75)
	download:SetScript('OnClick', GUI.Download_OnClick)
	bar.download = download

	local upload = GUI:CreateProfileIcon(bar, 4, 'Atlas:bags-icon-addslots', L.GUI.PROFILE.UPLOAD_PROFILE, L.GUI.PROFILE.UPLOAD_PROFILE_TIP)
	upload.Icon:SetInside(nil, 6, 6)
	upload:SetScript('OnClick', GUI.Upload_OnClick)
	bar.upload = upload

	return bar
end

local function UpdateButtonStatus(button, enable)
	button:EnableMouse(enable)
	button.Icon:SetDesaturated(not enable)
end

function GUI:UpdateCurrentProfile()
	for index, bar in pairs(GUI.bars) do
		if index == GUI.currentProfile then
			UpdateButtonStatus(bar.upload, false)
			UpdateButtonStatus(bar.download, false)
			UpdateButtonStatus(bar.apply, false)
			UpdateButtonStatus(bar.reset, true)
			bar:SetBackdropColor(C.r, C.g, C.b, .25)
			bar.apply.bg:SetBackdropBorderColor(1, 1, 0)
		else
			UpdateButtonStatus(bar.upload, true)
			UpdateButtonStatus(bar.download, true)
			UpdateButtonStatus(bar.apply, true)
			UpdateButtonStatus(bar.reset, false)
			bar:SetBackdropColor(0, 0, 0, .25)
			bar.apply.bg:SetBackdropBorderColor(0, 0, 0)
		end
	end
end

function GUI:Delete_OnEnter()
	local text = self:GetText()
	if not text or text == '' then
		return
	end
	local name, realm = strsplit('-', text)
	if not realm then
		realm = C.MyRealm
		text = name .. '-' .. realm
		self:SetText(text)
	end

	if FREE_ADB['ProfileIndex'][text] or (FREE_GOLDCOUNT[realm] and FREE_GOLDCOUNT[realm][name]) then
		StaticPopup_Show('FREEUI_DELETE_UNIT_PROFILE', text, GUI:GetClassFromGoldInfo(name, realm))
	else
		UIErrorsFrame:AddMessage(C.RedColor .. L.GUI.PROFILE.INCORRECT_UNIT_NAME)
	end
end

function GUI:Delete_OnEscape()
	self:SetText('')
end

function GUI:CreateProfileGUI(parent)
	local reset = F.CreateButton(parent, 100, 24, L.GUI.PROFILE.RESET)
	reset:SetPoint('BOTTOMRIGHT', -20, 20)
	reset:SetScript(
		'OnClick',
		function()
			StaticPopup_Show('FREEUI_RESET')
		end
	)
	F.AddTooltip(reset, 'ANCHOR_TOP', F.StyleAddonName(L.GUI.PROFILE.RESET_TIP), 'RED')

	local import = F.CreateButton(parent, 100, 24, L.GUI.PROFILE.IMPORT)
	import:SetPoint('BOTTOMLEFT', 20, 20)
	import:SetScript(
		'OnClick',
		function()
			parent:GetParent():Hide()
			GUI:CreateDataFrame()
			GUI.ProfileDataFrame.Header:SetText(L.GUI.PROFILE.IMPORT_HEADER)
			GUI.ProfileDataFrame.text:SetText(L.GUI.PROFILE.IMPORT)
			GUI.ProfileDataFrame.editBox:SetText('')
		end
	)
	F.AddTooltip(import, 'ANCHOR_TOP', L.GUI.PROFILE.IMPORT_TIP, 'BLUE')

	local export = F.CreateButton(parent, 100, 24, L.GUI.PROFILE.EXPORT)
	export:SetPoint('LEFT', import, 'RIGHT', 5, 0)
	export:SetScript(
		'OnClick',
		function()
			parent:GetParent():Hide()
			GUI:CreateDataFrame()
			GUI.ProfileDataFrame.Header:SetText(L.GUI.PROFILE.EXPORT_HEADER)
			GUI.ProfileDataFrame.text:SetText(OKAY)
			GUI:ExportData()
		end
	)
	F.AddTooltip(export, 'ANCHOR_TOP', L.GUI.PROFILE.EXPORT_TIP, 'BLUE')

	local delete = F.CreateEditBox(parent, 205, 24)
	delete:SetPoint('BOTTOMLEFT', import, 'TOPLEFT', 0, 10)
	delete:HookScript('OnEnterPressed', GUI.Delete_OnEnter)
	delete:HookScript('OnEscapePressed', GUI.Delete_OnEscape)
	delete.title = L.GUI.PROFILE.DELETE_UNIT_PROFILE
	F.AddTooltip(delete, 'ANCHOR_TOP', L.GUI.PROFILE.DELETE_UNIT_PROFILE_TIP, 'BLUE')

	F.CreateFS(parent, C.Assets.Fonts.Bold, 14, nil, L.GUI.PROFILE.PROFILE_MANAGEMENT, 'YELLOW', 'THICK', 'TOPLEFT', 20, -20)
	local description = F.CreateFS(parent, C.Assets.Fonts.Regular, 13, nil, L.GUI.PROFILE.PROFILE_DESCRIPTION, nil, 'THICK', 'TOPLEFT', 20, -40)
	description:SetPoint('TOPRIGHT', -20, -40)
	description:SetWordWrap(true)
	description:SetJustifyH('LEFT')

	GUI.currentProfile = FREE_ADB['profile_index'][myFullName]

	local numBars = 6
	local panel = F.CreateBDFrame(parent, .25)
	panel:ClearAllPoints()
	panel:SetPoint('TOPRIGHT', -20, -120)
	panel:SetWidth(parent:GetWidth() - 40)
	panel:SetHeight(15 + numBars * 45)
	panel:SetFrameLevel(11)

	GUI.bars = {}
	for i = 1, numBars do
		GUI.bars[i] = GUI:CreateProfileBar(panel, i)
	end

	GUI:UpdateCurrentProfile()
end
