local F, C = unpack(select(2, ...))
local THEME = F:GetModule('THEME')
local TOOLTIP = F:GetModule('TOOLTIP')


function THEME:ReskinDBMBar()
	local RaidNotice_AddMessage_ = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if strfind(textString, '|T') then
			if strmatch(textString, ':(%d+):(%d+)') then
				local size1, size2 = strmatch(textString, ':(%d+):(%d+)')
				size1, size2 = size1 + 3, size2 + 3
				textString = gsub(textString,':(%d+):(%d+)',':'..size1..':'..size2..':0:0:64:64:5:59:5:59')
			elseif strmatch(textString, ':(%d+)|t') then
				local size = strmatch(textString, ':(%d+)|t')
				size = size + 3
				textString = gsub(textString,':(%d+)|t',':'..size..':'..size..':0:0:64:64:5:59:5:59|t')
			end
		end

		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end

	if not IsAddOnLoaded('DBM-Core') then return end
	if not FreeUIConfigs['theme']['reskin_dbm'] then return end

	local buttonsize = 24

	local function reskinBarIcon(icon, bar)
		if icon.styled then return end

		icon:SetSize(buttonsize, buttonsize)
		icon.SetSize = F.Dummy
		icon:ClearAllPoints()
		icon:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMLEFT', -5, -4)
		local bg = F.ReskinIcon(icon)
		F.CreateSD(bg)
		bg.icon = bg:CreateTexture(nil, 'BACKGROUND')
		bg.icon:SetInside()
		bg.icon:SetTexture('Interface\\Icons\\Spell_Nature_WispSplode')
		bg.icon:SetTexCoord(unpack(C.TexCoord))

		icon.styled = true
	end

	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if not bar.styeld then
				local frame		= bar.frame
				local tbar		= _G[frame:GetName()..'Bar']
				local spark		= _G[frame:GetName()..'BarSpark']
				local texture	= _G[frame:GetName()..'BarTexture']
				local icon1		= _G[frame:GetName()..'BarIcon1']
				local icon2		= _G[frame:GetName()..'BarIcon2']
				local name		= _G[frame:GetName()..'BarName']
				local timer		= _G[frame:GetName()..'BarTimer']

				if bar.color then
					tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
				else
					tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
				end

				if bar.enlarged then
					frame:SetWidth(bar.owner.options.HugeWidth)
					tbar:SetWidth(bar.owner.options.HugeWidth)
				else
					frame:SetWidth(bar.owner.options.Width)
					tbar:SetWidth(bar.owner.options.Width)
				end

				if not frame.styled then
					frame:SetScale(1)
					frame.SetScale = F.Dummy
					frame:SetHeight(buttonsize/2)
					frame.SetHeight = F.Dummy
					frame.styled = true
				end

				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed = true
				end

				reskinBarIcon(icon1, tbar)
				reskinBarIcon(icon2, tbar)

				if not tbar.styled then
					F.StripTextures(tbar)
					F.CreateSB(tbar, true)
					tbar:SetInside(frame, 2, 2)
					tbar.SetPoint = F.Dummy
					tbar.styled = true
				end

				if not texture.styled then
					texture:SetTexture(C.Assets.norm_tex)
					texture.SetTexture = F.Dummy
					texture.styled = true
				end

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint('LEFT', frame, 'LEFT', 2, 8)
					name:SetPoint('RIGHT', frame, 'LEFT', tbar:GetWidth()*.85, 8)
					name.SetPoint = F.Dummy
					name:SetFont(C.Assets.Fonts.Normal, 12, 'OUTLINE')
					name.SetFont = F.Dummy
					name:SetJustifyH('LEFT')
					name:SetWordWrap(false)
					name:SetShadowColor(0, 0, 0, 0)
					name:SetShadowOffset(2, -2)
					name.styled = true
				end

				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint('RIGHT', frame, 'RIGHT', -2, 8)
					timer.SetPoint = F.Dummy
					timer:SetFont(C.Assets.Fonts.Number, 11, 'OUTLINE')
					timer.SetFont = F.Dummy
					timer:SetJustifyH('RIGHT')
					timer:SetShadowColor(0, 0, 0, 0)
					name:SetShadowOffset(2, -2)
					timer.styled = true
				end

				tbar:SetAlpha(1)
				frame:SetAlpha(1)
				frame:Show()
				bar:Update(0)

				bar.styeld = true
			end
		end
	end
	hooksecurefunc(DBT, 'CreateBar', SkinBars)

	local function SkinRange()
		if DBMRangeCheckRadar and not DBMRangeCheckRadar.styled then
			TOOLTIP.ReskinTooltip(DBMRangeCheckRadar)
			DBMRangeCheckRadar.styled = true
		end

		if DBMRangeCheck and not DBMRangeCheck.styled then
			TOOLTIP.ReskinTooltip(DBMRangeCheck)
			DBMRangeCheck.styled = true
		end
	end
	hooksecurefunc(DBM.RangeCheck, 'Show', SkinRange)

	if DBM.InfoFrame then
		DBM.InfoFrame:Show(5, 'test')
		DBM.InfoFrame:Hide()
		DBMInfoFrame:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	end

	-- Force Settings
	if not DBM_AllSavedOptions['Default'] then DBM_AllSavedOptions['Default'] = {} end
	DBM_AllSavedOptions['Default']['BlockVersionUpdateNotice'] = true
	DBM_AllSavedOptions['Default']['EventSoundVictory'] = 'None'
	DBT_AllPersistentOptions['Default']['DBM'].BarYOffset = 20
	DBT_AllPersistentOptions['Default']['DBM'].HugeBarYOffset = 20
	DBT_AllPersistentOptions['HugeBarsEnabled'] = false
	DBT_AllPersistentOptions['HugeScale'] = 1.0
	if IsAddOnLoaded('DBM-VPYike') then
		DBM_AllSavedOptions['Default']['CountdownVoice'] = 'VP:Yike'
		DBM_AllSavedOptions['Default']['ChosenVoicePack'] = 'Yike'
	end
end

function THEME:ReskinDBMGUI()
	if not FreeUIConfigs['theme']['reskin_dbm'] then return end
	if not IsAddOnLoaded('DBM-GUI') then return end

	tinsert(UISpecialFrames, 'DBM_GUI_OptionsFrame')

	F.StripTextures(_G['DBM_GUI_OptionsFrame'])
	F.CreateBDFrame(_G['DBM_GUI_OptionsFrame'], nil, true)
	F.CreateTex(_G['DBM_GUI_OptionsFrame'])

	_G['DBM_GUI_OptionsFrameHeader']:ClearAllPoints()
	_G['DBM_GUI_OptionsFrameHeader']:SetPoint('TOP', DBM_GUI_OptionsFrame, 0, 7)

	_G['DBM_GUI_OptionsFrameWebsite']:Hide()
	_G['DBM_GUI_OptionsFrameRevision']:Hide()
	_G['DBM_GUI_OptionsFrameTranslation']:Hide()

	F.StripTextures(_G['DBM_GUI_OptionsFramePanelContainer'])
	F.CreateBDFrame(_G['DBM_GUI_OptionsFramePanelContainer'])
	F.ReskinScroll(_G['DBM_GUI_OptionsFramePanelContainerFOVScrollBar'])

	_G['DBM_GUI_OptionsFrameTab1']:ClearAllPoints()
	_G['DBM_GUI_OptionsFrameTab1']:SetPoint('TOPLEFT', _G['DBM_GUI_OptionsFrameBossMods'], 'TOPLEFT', 10, 26)
	_G['DBM_GUI_OptionsFrameTab2']:ClearAllPoints()
	_G['DBM_GUI_OptionsFrameTab2']:SetPoint('TOPLEFT', _G['DBM_GUI_OptionsFrameTab1'], 'TOPRIGHT', 6, 0)


	local dbmtabs = {
		'DBM_GUI_OptionsFrameTab1',
		'DBM_GUI_OptionsFrameTab2',
	}

	for i = 1, 2 do
		local tab = _G[dbmtabs[i]]
		F.StripTextures(tab)

		if tab and not tab.styled then
			F.ReskinTab(tab)

			tab.styled = true
		end
	end

	_G['DBM_GUI_OptionsFrameBossMods']:HookScript('OnShow', function(self)
		F.StripTextures(self)

		if not self.styled then
			F.CreateBDFrame(self)

			self.styled = true
		end
	end)

	_G['DBM_GUI_OptionsFrameDBMOptions']:HookScript('OnShow', function(self)
		F.StripTextures(self)

		if not self.styled then
			F.CreateBDFrame(self)

			self.styled = true
		end
	end)

	local dbmbuttons = {
		'DBM_GUI_OptionsFrameWebsiteButton',
		'DBM_GUI_OptionsFrameOkay',
	}

	for i = 1, 2 do
		local buttons = _G[dbmbuttons[i]]
		if buttons and not buttons.overlay then
			F.Reskin(buttons)
		end
	end


	local count = 1
	local function restyleGUI()
		local option = _G['DBM_GUI_Option_'..count]
		while option do
			local objType = option:GetObjectType()
			if objType == 'CheckButton' then
				F.ReskinCheck(option)
			elseif objType == 'Slider' then
				F.ReskinSlider(option)
			elseif objType == 'EditBox' then
				F.ReskinInput(option)
			elseif option:GetName():find('DropDown') then
				F.ReskinDropDown(option)
			elseif objType == 'Button' then
				F.Reskin(option)
			elseif objType == 'Frame' then
				option:SetBackdrop(nil)
			end

			count = count + 1
			option = _G['DBM_GUI_Option_'..count]
			if not option then
				option = _G['DBM_GUI_DropDown'..count]
			end
		end
	end

	DBM:RegisterOnGuiLoadCallback(function()
		restyleGUI()
		hooksecurefunc(DBM_GUI, 'UpdateModList', restyleGUI)
		DBM_GUI_OptionsFrameBossMods:HookScript('OnShow', restyleGUI)
	end)
end

function THEME:Test()
	if not IsAddOnLoaded('DBM-GUI') then return end
	tinsert(UISpecialFrames, _G['DBM_GUI_OptionsFrame'])


	F.StripTextures(_G['DBM_GUI_OptionsFrame'])
	F.CreateBDFrame(_G['DBM_GUI_OptionsFrame'], nil, true)
	F.CreateTex(_G['DBM_GUI_OptionsFrame'])

	_G['DBM_GUI_OptionsFrameHeader']:ClearAllPoints()
	_G['DBM_GUI_OptionsFrameHeader']:SetPoint('TOP', _G['DBM_GUI_OptionsFrame'], 0, 2)

	_G['DBM_GUI_OptionsFrameWebsite']:Hide()
	_G['DBM_GUI_OptionsFrameRevision']:Hide()
	_G['DBM_GUI_OptionsFrameTranslation']:Hide()
	_G['DBM_GUI_OptionsFrameWebsiteButton']:Hide()

	_G['DBM_GUI_OptionsFrameOkay']:ClearAllPoints()
	_G['DBM_GUI_OptionsFrameOkay']:SetPoint('BOTTOMRIGHT', -20, 20)
	F.Reskin(_G['DBM_GUI_OptionsFrameOkay'])

	F.StripTextures(_G['DBM_GUI_OptionsFramePanelContainer'])
	F.CreateBDFrame(_G['DBM_GUI_OptionsFramePanelContainer'], .3)
	F.StripTextures(_G['DBM_GUI_OptionsFramePanelContainerFOV'])
	F.ReskinScroll(_G['DBM_GUI_OptionsFramePanelContainerFOVScrollBar'])

	_G['DBM_GUI_OptionsFramePanelContainerHeaderText']:Hide()

	DBM_GUI_OptionsFrame:HookScript('OnShow', function()
	end)

	local dbmtabs = {
		'DBM_GUI_OptionsFrameTab1',
		'DBM_GUI_OptionsFrameTab2',
	}

	for i = 1, 2 do
		local tab = _G[dbmtabs[i]]
		F.StripTextures(tab)

		if tab and not tab.styled then
			--F.ReskinTab(tab)

			tab.styled = true
		end
	end

	_G['DBM_GUI_OptionsFrameList']:HookScript('OnShow', function(self)
		F.StripTextures(self)

		if not self.styled then
			F.CreateBDFrame(self, .3)

			self.styled = true
		end
	end)


end

