local F, C = unpack(select(2, ...))
if not C.infobar.enable then return end

local module = F:RegisterModule('Infobar')


local barAlpha, buttonAlpha

if C.infobar.mouseover then
	barAlpha = 0.25
	buttonAlpha = 0
else
	barAlpha = 0.5
	buttonAlpha = 1
end

local bar = CreateFrame('Frame', 'FreeUIMenubar', UIParent)
bar:SetFrameStrata('BACKGROUND')
bar:SetPoint('TOPLEFT', -C.Mult, C.Mult)
bar:SetPoint('TOPRIGHT', C.Mult, C.Mult)
bar:SetHeight(C.infobar.height)
F.CreateBD(bar, barAlpha)

RegisterStateDriver(bar, 'visibility', '[petbattle] hide; show')

bar.buttons = {}

local function onEvent(event)
	if event == 'PLAYER_REGEN_DISABLED' then
		bar:SetBackdropBorderColor(1, 0, 0)
	else
		bar:SetBackdropBorderColor(0, 0, 0)
	end
end

F:RegisterEvent('PLAYER_REGEN_DISABLED', onEvent)
F:RegisterEvent('PLAYER_REGEN_ENABLED', onEvent)


module.POSITION_LEFT, module.POSITION_MIDDLE, module.POSITION_RIGHT = 1, 2, 3

local function fadeIn(self, elapsed)
	if barAlpha < .5 then
		barAlpha = barAlpha + elapsed
		buttonAlpha = buttonAlpha + (elapsed * 4)
	else
		barAlpha = .5
		buttonAlpha = 1
		self:SetScript('OnUpdate', nil)
	end

	self:SetBackdropColor(0, 0, 0, barAlpha)

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

	self:SetBackdropColor(0, 0, 0, barAlpha)

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


if C.infobar.mouseover then
	bar:SetScript('OnEnter', showBar)
	bar:SetScript('OnLeave', hideBar)
end

local function buttonOnEnterNoFade(self)
	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeaveNoFade(self)
	self:SetBackdropColor(0, 0, 0, .1)
end

local function buttonOnEnter(self)
	if C.infobar.mouseover then
		showBar()
	end
	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeave(self)
	if C.infobar.mouseover then
		hideBar()
	end
	self:SetBackdropColor(0, 0, 0, .1)
end

local function reanchorButtons()
	local leftOffset, rightOffset = 0, 0

	for i = 1, #bar.buttons do
		local bu = bar.buttons[i]

		if bu:IsShown() then
			if bu.position == module.POSITION_LEFT then
				bu:SetPoint('LEFT', bar, 'LEFT', leftOffset, 0)
				leftOffset = leftOffset + (bu:GetWidth() - C.Mult)
			elseif bu.position == module.POSITION_RIGHT then
				bu:SetPoint('RIGHT', bar, 'RIGHT', rightOffset, 0)
				rightOffset = rightOffset - (bu:GetWidth() - C.Mult)
			else
				bu:SetPoint('CENTER', bar)
			end
		end
	end
end

function module:showButton(button)
	button:Show()
	reanchorButtons()
end

function module:hideButton(button)
	button:Hide()
	reanchorButtons()
end

function module:addButton(text, position, width, clickFunc)
	local bu = CreateFrame('Button', nil, bar)
	bu:SetPoint('TOP', bar, 'TOP')
	bu:SetPoint('BOTTOM', bar, 'BOTTOM')
	bu:SetWidth(width)
	F.CreateBD(bu, .1)

	if C.infobar.mouseover then
		bu:SetAlpha(0)
	end

	local buText = F.CreateFS(bu, 'pixel', text, nil, nil, true, 'CENTER', 0, 0)
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

function module:OnLogin()
	self:Stats()
	self:MicroMenu()
	self:DMTool()
	self:SpecTalent()
	self:Friends()
	self:Currencies()
	self:Report()
end




