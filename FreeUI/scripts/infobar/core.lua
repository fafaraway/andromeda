local F, C = unpack(select(2, ...))
local module = F:RegisterModule("infobar")
if not C.infoBar.enable then return end

local barAlpha, buttonAlpha

if C.infoBar.buttons_mouseover then
	barAlpha = 0.25
	buttonAlpha = 0
else
	barAlpha = 0.5
	buttonAlpha = 1
end

-- [[ Bar ]]

local bar = CreateFrame("Frame", "FreeUIMenubar", UIParent)
bar:SetFrameStrata("BACKGROUND")

RegisterStateDriver(bar, "visibility", "[petbattle] hide; show")


bar:SetPoint("TOPLEFT", -1, 1)
bar:SetPoint("TOPRIGHT", 1, 1)


bar:SetHeight(C.infoBar.height)
F.CreateBD(bar, barAlpha)

bar.buttons = {}

local function onEvent(event)
	if event == "PLAYER_REGEN_DISABLED" then
		bar:SetBackdropBorderColor(1, 0, 0)
	else
		bar:SetBackdropBorderColor(0, 0, 0)
	end
end

F:RegisterEvent("PLAYER_REGEN_DISABLED", onEvent)
F:RegisterEvent("PLAYER_REGEN_ENABLED", onEvent)


-- [[ Buttons ]]

if not C.infoBar.enableButtons then return end

module.POSITION_LEFT, module.POSITION_MIDDLE, module.POSITION_RIGHT = 1, 2, 3

local function fadeIn(self, elapsed)
	if barAlpha < .5 then
		barAlpha = barAlpha + elapsed
		buttonAlpha = buttonAlpha + (elapsed * 4)
	else
		barAlpha = .5
		buttonAlpha = 1
		self:SetScript("OnUpdate", nil)
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
		self:SetScript("OnUpdate", nil)
	end

	self:SetBackdropColor(0, 0, 0, barAlpha)

	for _, button in pairs(bar.buttons) do
		button:SetAlpha(buttonAlpha)
	end
end

local function showBar()
	bar:SetScript("OnUpdate", fadeIn)
	bar:SetFrameStrata("HIGH")
end
bar.showBar = showBar

local function hideBar()
	bar:SetScript("OnUpdate", fadeOut)
	bar:SetFrameStrata("BACKGROUND")
end
bar.hideBar = hideBar

if C.infoBar.buttons_mouseover then
	bar:SetScript("OnEnter", showBar)
	bar:SetScript("OnLeave", hideBar)
end

local function buttonOnEnterNoFade(self)
	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeaveNoFade(self)
	self:SetBackdropColor(0, 0, 0, .1)
end

local function buttonOnEnter(self)
	if C.infoBar.buttons_mouseover then
		showBar()
	end

	self:SetBackdropColor(C.r, C.g, C.b, .4)
end

local function buttonOnLeave(self)
	if C.infoBar.buttons_mouseover then
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
				bu:SetPoint("LEFT", bar, "LEFT", leftOffset, 0)
				leftOffset = leftOffset + 129
			elseif bu.position == module.POSITION_RIGHT then
				bu:SetPoint("RIGHT", bar, "RIGHT", rightOffset, 0)
				rightOffset = rightOffset - 129
			else
				bu:SetPoint("CENTER", bar)
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

function module:addButton(text, position, clickFunc)
	local bu = CreateFrame("Button", nil, bar)
	bu:SetPoint("TOP", bar, "TOP")
	bu:SetPoint("BOTTOM", bar, "BOTTOM")
	bu:SetWidth(130)
	F.CreateBD(bu, .1)

	if C.infoBar.buttons_mouseover then
		bu:SetAlpha(0)
	end

	local buText = F.CreateFS(bu, C.media.pixel, 8, 'OUTLINEMONOCHROME', nil, {0, 0, 0}, 1, -1)
	buText:SetPoint("CENTER")
	buText:SetText(text)
	bu.Text = buText

	bu:SetScript("OnMouseUp", clickFunc)
	bu:SetScript("OnEnter", buttonOnEnter)
	bu:SetScript("OnLeave", buttonOnLeave)

	bu.position = position

	tinsert(bar.buttons, bu)

	reanchorButtons()

	return bu
end

bar.addButton = addButton








--[[module:addButton("Toggle Skada", module.POSITION_LEFT, function(self, button)
	if IsAddOnLoaded("Skada") then
		if button == "MiddleButton" then
			Skada:Reset()
		elseif button == "RightButton" then
			Skada:SetActive(false)
		else
			Skada:SetActive(true)
		end
	else
		EnableAddOn("Skada")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffSkada enabled. Type|r /rl |cfffffffffor the changes to apply.|r", C.r, C.g, C.b)
	end
end)]]












function module:OnLogin()
	

end




