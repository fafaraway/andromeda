local F, C = unpack(select(2, ...))
local THEME, TOOLTIP = F.THEME, F.TOOLTIP

-- Credit: hokohuang

local _G = getfenv(0)


local function strToPath(str)
	local path = {}
	for v in string.gmatch(str, '([^\.]+)') do
		table.insert(path, v)
	end
	return path
end

local function getValue(pathStr, tbl)
	local keys = strToPath(pathStr)
	local value
	for _, key in pairs(keys) do
		value = value and value[key] or tbl[key]
	end
	return value
end

local MS_Blizzard_Frames = {
	'inset',
	'InsetFrame',
	'LeftInset',
	'RightInset',
	'NineSlice',
	'BorderFrame',
	'bottomInset',
	'BottomInset',
	'bgLeft',
	'bgRight',
	'FilligreeOverlay',
}

local function MS_StripTextures(Object, Kill, Alpha)
	if Object:IsObjectType('Texture') then
		if Kill then
			F.HideObject(Object)
		elseif Alpha then
			Object:SetAlpha(0)
		else
			Object:SetTexture(nil)
		end
	else
		local FrameName = Object.GetName and Object:GetName()
		for _, Blizzard in pairs(MS_Blizzard_Frames) do
			local BlizzFrame = Object[Blizzard] or FrameName and _G[FrameName..Blizzard]
			if BlizzFrame then
				MS_StripTextures(BlizzFrame, Kill)
			end
		end

		if Object.GetNumRegions then
			for i = 1, Object:GetNumRegions() do
				local Region = select(i, Object:GetRegions())
				if Region and Region:IsObjectType('Texture') then
					if Kill then
						F.HideObject(Object)
					elseif Alpha then
						Region:SetAlpha(0)
					else
						Region:SetTexture(nil)
					end
				end
			end
		end
	end
end

local function reskinMSButton(bu)
	bu:SetHeight(28)
	F.Reskin(bu)
	bu.styled = true
end

local function reskinMSInput(input)
	input:DisableDrawLayer('BACKGROUND')
	F.ReskinEditBox(input)
	input.bg:SetPoint('TOPLEFT', 3, 0)
end

function THEME:ReskinMeetingStone()
	if not IsAddOnLoaded('MeetingStone') then return end
	if not FreeADB.appearance.reskin_meetingstone then return end

	local MSEnv = LibStub:GetLibrary('NetEaseEnv-1.0')._NSList.MeetingStone
	local GUI = LibStub('NetEaseGUI-2.0')

	local Panels = {
		'MainPanel',
		'ExchangePanel',
		'BrowsePanel.AdvFilterPanel',
	}

	local Buttons = {
		'BrowsePanel.SignUpButton',
		'CreatePanel.CreateButton',
		'CreatePanel.DisbandButton',
		'BrowsePanel.NoResultBlocker.Button',
		'RecentPanel.BatchDeleteButton',
		'BrowsePanel.RefreshFilterButton',
		'BrowsePanel.ResetFilterButton',
		'MallPanel.PurchaseButton',
	}

	local StretchButtons = {
		'BrowsePanel.AdvButton',
		'BrowsePanel.RefreshButton',
		'ManagerPanel.RefreshButton',
	}

	local Dropdowns = {
		'BrowsePanel.ActivityDropdown',
		'CreatePanel.ActivityType',
		'RecentPanel.ActivityDropdown',
		'RecentPanel.ClassDropdown',
		'RecentPanel.RoleDropdown',
	}

	local GridViews = {
		'ApplicantPanel.ApplicantList',
		'BrowsePanel.ActivityList',
		'RecentPanel.MemberList'
	}

	local EditBoxes = {
		'CreatePanel.HonorLevel',
		'CreatePanel.ItemLevel',
		'RecentPanel.SearchInput',
	}

	-- Panel
	for _, v in pairs(Panels) do
		local frame = getValue(v, MSEnv)
		if frame then
			if frame.Inset then MS_StripTextures(frame.Inset) end
			if frame.Inset2 then MS_StripTextures(frame.Inset2) end
			if frame.PortraitFrame then frame.PortraitFrame:SetAlpha(0) end
			if frame.CloseButton then F.ReskinClose(frame.CloseButton) end

			MS_StripTextures(frame)
			F.SetBD(frame)
		end
	end

	-- AdvFilterPanel
	local Browse = MSEnv.BrowsePanel
	local AdvFilter = Browse.AdvFilterPanel
	AdvFilter:SetPoint('TOPLEFT', MSEnv.MainPanel, 'TOPRIGHT', 3, -30)

	for i = 1, AdvFilter:GetNumChildren() do
		local child = select(i, AdvFilter:GetChildren())
		if child:IsObjectType('Button') and not child:GetText() then
			F.ReskinClose(child)
			break
		end
	end

	for i, box in ipairs(Browse.filters) do
		F.ReskinCheck(box.Check)
		reskinMSInput(box.MaxBox)
		reskinMSInput(box.MinBox)
		box.styled = true
	end

	-- CreatePanel
	local CreatePanel = MSEnv.CreatePanel
	local CreateWidget = CreatePanel.CreateWidget

	local line = select(1, CreatePanel:GetChildren())
	line:Hide()
	F.ReskinCheck(CreatePanel.PrivateGroup)

	for i = 1, CreateWidget:GetNumChildren() do
		local child = select(i, CreateWidget:GetChildren())
		child:DisableDrawLayer('BACKGROUND')
		local bg = F.CreateBDFrame(child, .25)
		bg:SetAllPoints()
	end

	local infoBG = F.CreateBDFrame(CreatePanel.InfoWidget, .25)
	infoBG:SetPoint('TOPLEFT', C.Mult, C.Mult)
	infoBG:SetPoint('BOTTOMRIGHT', -C.Mult, -C.Mult)
	F.CreateBDFrame(CreatePanel.MemberWidget, .25)
	F.CreateBDFrame(CreatePanel.MiscWidget, .25)
	CreatePanel.InfoWidget.Background:SetAlpha(0)
	CreatePanel.MemberWidget:DisableDrawLayer('BACKGROUND')
	CreatePanel.MiscWidget:DisableDrawLayer('BACKGROUND')

	-- Button
	for _, v in pairs(Buttons) do
		local button = getValue(v, MSEnv)
		if button then
			F.Reskin(button)
		end
	end

	for _, v in pairs(StretchButtons) do
		local button = getValue(v, MSEnv)
		if button then
			reskinMSButton(button)
		end
	end

	-- Dropdown
	for _, v in pairs(Dropdowns) do
		local dropdown = getValue(v, MSEnv)
		if dropdown then
			F.StripTextures(dropdown)
			local down = dropdown.MenuButton
			down:ClearAllPoints()
			down:SetPoint('RIGHT', -18, 0)
			F.ReskinArrow(down, 'down')
			down:SetSize(20, 20)

			local bg = F.CreateBDFrame(dropdown, 0)
			bg:SetPoint('TOPLEFT', 0, -2)
			bg:SetPoint('BOTTOMRIGHT', -18, 2)
			F.CreateGradient(bg)
		end
	end

	-- DropMenu
	local function reskinMHDropdown(self)
		if not self.tipStyled then
			self:SetBackdrop(nil)
			self:DisableDrawLayer('BACKGROUND')
			self.bg = F.CreateBDFrame(self, .7, true)
			self.bg:SetInside(self)
			self.bg:SetFrameLevel(self:GetFrameLevel())
			F.CreateTex(self.bg)
			self.tipStyled = true
		end
	end

	local DropMenu = GUI:GetClass('DropMenu')
	hooksecurefunc(DropMenu, 'Constructor', reskinMHDropdown)
	hooksecurefunc(DropMenu, 'Toggle', reskinMHDropdown)

	-- Tab
	local TabView = GUI:GetClass('TabView')
	hooksecurefunc(TabView, 'UpdateItems', function(self)
		for i = 1, self:GetItemCount() do
			local tab = self:GetButton(i)
			if not tab.styled then
				F.ReskinTab(tab, 4)
				tab.styled = true
			end
		end
	end)

	-- GridView
	for _, v in pairs(GridViews) do
		local grid = getValue(v, MSEnv)
		if grid and not grid.styled then
			for _, button in pairs(grid.sortButtons) do
				MS_StripTextures(button, false, true)
				button.Arrow:SetAlpha(1)
				local bg = F.CreateBDFrame(button, .25)
				bg:SetPoint('TOPLEFT', C.Mult, C.Mult)
				bg:SetPoint('BOTTOMRIGHT', -C.Mult, -C.Mult)
			end
			F.ReskinScroll(grid:GetScrollBar())
			grid.styled = true
		end
	end

	local ListView = GUI:GetClass('ListView')
	hooksecurefunc(ListView, 'UpdateItems', function(self)
		for i = 1, #self.buttons do
			local button = self:GetButton(i)
			if not button.styled and button:IsShown() then
				MS_StripTextures(button)
				F.CreateBD(button, .25)

				button:SetHighlightTexture(C.Assets.bd_tex)
				local hl = button:GetHighlightTexture()
				hl:SetVertexColor(C.r, C.g, C.b, .25)
				hl:SetInside()
				button:SetCheckedTexture(C.Assets.bd_tex)
				local check = button:GetCheckedTexture()
				check:SetVertexColor(C.r, C.g, C.b, .25)
				check:SetInside()

				if button.Option then
					F.Reskin(button.Option.InviteButton)
					F.Reskin(button.Option.DeclineButton)
				end

				if button.Summary then
					F.Reskin(button.Summary.CancelButton)
				end

				button.styled = true
			end
		end
	end)

	-- EditBox
	for _, v in pairs(EditBoxes) do
		local input = getValue(v, MSEnv)
		if input then
			reskinMSInput(input)
		end
	end

	-- Tooltip
	local Tooltip = GUI:GetClass('Tooltip')
	TOOLTIP.ReskinTooltip(Tooltip:GetGlobalTooltip())
	TOOLTIP.ReskinTooltip(MSEnv.MainPanel.GameTooltip)

	-- DataBroker
	local DataBroker = MSEnv.DataBroker.BrokerPanel
	DataBroker:SetBackdrop(nil)
	DataBroker:SetHeight(30)
	F.SetBD(DataBroker, 0, 0, 6, 0)

	if not MeetingStone_QuickJoin then return end  -- version check

	F.ReskinCheck(MeetingStone_QuickJoin)

	for i = 1, AdvFilter.Inset:GetNumChildren() do
		local child = select(i, AdvFilter.Inset:GetChildren())
		if child.Check and not child.styled then
			F.ReskinCheck(child.Check)
		end
	end

	local function reskinALFrame()
		if ALFrame and not ALFrame.styled then
			F.StripTextures(ALFrame)
			F.SetBD(ALFrame)
			F.Reskin(ALFrameButton)
			ALFrame.styled = true
		end
	end

	local ManagerPanel = MSEnv.ManagerPanel
	for i = 1, ManagerPanel:GetNumChildren() do
		local child = select(i, ManagerPanel:GetChildren())
		if child:IsObjectType('Button') and child.Icon and child.Text and not child.styled then
			reskinMSButton(child)
			child:HookScript('PostClick', reskinALFrame)
		end
	end
end
