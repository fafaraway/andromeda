local F, C, L = unpack(select(2, ...))
local INFOBAR, cfg = F:GetModule('Infobar'), C.Infobar


local barAlpha, buttonAlpha
if cfg.mouseover then
	barAlpha = 0.25
	buttonAlpha = 0
else
	barAlpha = 0.65
	buttonAlpha = 1
end

local bar = CreateFrame('Frame', 'FreeUI_Infobar', UIParent)
bar.buttons = {}

INFOBAR.POSITION_LEFT, INFOBAR.POSITION_MIDDLE, INFOBAR.POSITION_RIGHT = 1, 2, 3

local function onEvent(event)
	if event == 'PLAYER_REGEN_DISABLED' then
		bar.bg:SetBackdropBorderColor(1, 0, 0, 1)
	else
		bar.bg:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

local function fadeIn(self, elapsed)
	if barAlpha < 0.5 then
		barAlpha = barAlpha + elapsed
		buttonAlpha = buttonAlpha + (elapsed * 4)
	else
		barAlpha = 0.5
		buttonAlpha = 1
		self:SetScript('OnUpdate', nil)
	end

	self.bg:SetBackdropColor(0, 0, 0, barAlpha)

	for _, button in pairs(bar.buttons) do
		button:SetAlpha(buttonAlpha)
	end
end

local function fadeOut(self, elapsed)
	if barAlpha > .25 then
		barAlpha = barAlpha - elapsed
		buttonAlpha = buttonAlpha - (elapsed * 4)
	else
		barAlpha = .25
		buttonAlpha = 0
		self:SetScript('OnUpdate', nil)
	end

	self.bg:SetBackdropColor(0, 0, 0, barAlpha)

	for _, button in pairs(bar.buttons) do
		button:SetAlpha(buttonAlpha)
	end
end

local function showBar()
	bar:SetScript('OnUpdate', fadeIn)
	bar:SetFrameStrata('HIGH')
end
bar.showBar = showBar

local function hideBar()
	bar:SetScript('OnUpdate', fadeOut)
	bar:SetFrameStrata('BACKGROUND')
end
bar.hideBar = hideBar

local function buttonOnEnterNoFade(self)
	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeaveNoFade(self)
	self:SetBackdropColor(0, 0, 0, .1)
end

local function buttonOnEnter(self)
	if cfg.mouseover then
		showBar()
	end
	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeave(self)
	if cfg.mouseover then
		hideBar()
	end
	self:SetBackdropColor(0, 0, 0, .1)
end

local function reanchorButtons()
	local leftOffset, rightOffset = 0, 0

	for i = 1, #bar.buttons do
		local bu = bar.buttons[i]

		if bu:IsShown() then
			if bu.position == INFOBAR.POSITION_LEFT then
				bu:SetPoint('LEFT', bar, 'LEFT', leftOffset, 0)
				leftOffset = leftOffset + (bu:GetWidth() - C.Mult)
			elseif bu.position == INFOBAR.POSITION_RIGHT then
				bu:SetPoint('RIGHT', bar, 'RIGHT', rightOffset, 0)
				rightOffset = rightOffset - (bu:GetWidth() - C.Mult)
			else
				bu:SetPoint('CENTER', bar)
			end
		end
	end
end

function INFOBAR:showButton(button)
	button:Show()
	reanchorButtons()
end

function INFOBAR:hideButton(button)
	button:Hide()
	reanchorButtons()
end

function INFOBAR:addButton(text, position, width, clickFunc)
	local bu = CreateFrame('Button', nil, bar)
	bu:SetPoint('TOP', bar, 'TOP')
	bu:SetPoint('BOTTOM', bar, 'BOTTOM')
	bu:SetWidth(width)
	F.CreateBD(bu, .1)

	if cfg.mouseover then
		bu:SetAlpha(0)
	end

	local buText = F.CreateFS(bu, C.Assets.Fonts.Number, cfg.fontSize, nil, text, nil, true, 'CENTER', 0, 0)
	bu.Text = buText

	bu:SetScript('OnMouseUp', clickFunc)
	bu:SetScript('OnEnter', buttonOnEnter)
	bu:SetScript('OnLeave', buttonOnLeave)

	bu.position = position

	tinsert(bar.buttons, bu)

	reanchorButtons()

	return bu
end
bar.addButton = addButton


function INFOBAR:OnLogin()
	if not cfg.enable then return end

	bar:Point((cfg.top and 'TOPLEFT') or 'BOTTOMLEFT', 0, 0)
	bar:Point((cfg.top and 'TOPRIGHT') or 'BOTTOMRIGHT', 0, 0)

	bar:SetFrameStrata('BACKGROUND')
	bar:SetHeight(cfg.height)
	bar.bg = F.CreateBDFrame(bar, barAlpha)

	RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')

	F:RegisterEvent('PLAYER_REGEN_DISABLED', onEvent)
	F:RegisterEvent('PLAYER_REGEN_ENABLED', onEvent)

	if cfg.mouseover then
		bar:SetScript('OnEnter', showBar)
		bar:SetScript('OnLeave', hideBar)
	end

	self:Stats()
	self:SpecTalent()
	self:Durability()
	self:Guild()
	self:Friends()
	self:Report()
end




