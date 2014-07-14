local F, C = unpack(select(2, ...))

local r, g, b = unpack(C.class)
local barAlpha = 0.25
local buttonAlpha = 0

local bar = CreateFrame("Frame", "FreeUIMenubar", UIParent)
bar:SetFrameStrata("BACKGROUND")
bar:SetPoint("BOTTOMLEFT", -1, -1)
bar:SetPoint("BOTTOMRIGHT", 1, -1)
bar:SetHeight(13)
F.CreateBD(bar, .25)

bar.buttons = {}

local function onEvent(event)
	if event == "PLAYER_REGEN_DISABLED" then
		bar:SetBackdropBorderColor(1, 0, 0)
	else
		bar:SetBackdropBorderColor(0, 0, 0)
	end
end

F.RegisterEvent("PLAYER_REGEN_DISABLED", onEvent)
F.RegisterEvent("PLAYER_REGEN_ENABLED", onEvent)

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
end
bar.showBar = showBar

local function hideBar()
	bar:SetScript("OnUpdate", fadeOut)
end
bar.hideBar = hideBar

bar:SetScript("OnEnter", showBar)
bar:SetScript("OnLeave", hideBar)

local function buttonOnEnter(self)
	showBar()
	self:SetBackdropColor(r, g, b, .4)
end

local function buttonOnLeave(self)
	hideBar()
	self:SetBackdropColor(0, 0, 0, .1)
end

local leftOffset, rightOffset = 0, 0

local function addButton(text, onRightSide, clickFunc)
	local bu = CreateFrame("Button", nil, bar)
	bu:SetPoint("TOP", bar, "TOP")
	bu:SetPoint("BOTTOM", bar, "BOTTOM")
	bu:SetWidth(130)
	bu:SetAlpha(0)
	F.CreateBD(bu, .1)

	if onRightSide then
		bu:SetPoint("RIGHT", bar, "RIGHT", rightOffset, 0)
		rightOffset = rightOffset - 129
	else
		bu:SetPoint("LEFT", bar, "LEFT", leftOffset, 0)
		leftOffset = leftOffset + 129
	end

	local buText = F.CreateFS(bu)
	buText:SetPoint("CENTER")
	buText:SetText(text)
	bu.Text = buText

	bu:SetScript("OnEnter", buttonOnEnter)
	bu:SetScript("OnLeave", buttonOnLeave)
	bu:SetScript("OnClick", clickFunc)

	tinsert(bar.buttons, bu)

	return bu
end

bar.addButton = addButton

addButton("Micro menu", false, function()
	if DropDownList1:IsShown() then
		ToggleFrame(DropDownList1)
	else
		F.MicroMenu()
	end
end)

addButton("Chat menu", false, function()
	ChatMenu:ClearAllPoints()
	ChatMenu:SetPoint("BOTTOMLEFT", UIParent, 30, 30)
	ToggleFrame(ChatMenu)
end)

addButton("Toggle DBM", true, function()
	if IsAddOnLoaded("DBM-Core") then
		DisableAddOn("DBM-Core")
		DisableAddOn("DBM-StatusBarTimers")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM disabled. Type|r /rl |cfffffffffor the changes to apply.|r", r, g, b)
	else
		EnableAddOn("DBM-Core")
		EnableAddOn("DBM-StatusBarTimers")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM enabled. Type|r /rl |cfffffffffor the changes to apply.|r", r, g, b)
	end
end)

addButton("Toggle damage meter", true, function()
	if IsAddOnLoaded("alDamageMeter") then
		DisableAddOn("alDamageMeter")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffalDamageMeter disabled. Type|r /rl |cfffffffffor the changes to apply.|r", r, g, b)
	else
		EnableAddOn("alDamageMeter")
		LoadAddOn("alDamageMeter")
		if IsAddOnLoaded("alDamageMeter") then
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffalDamageMeter loaded.|r", r, g, b)
		else
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffalDamageMeter not found!|r", r, g, b)
		end
	end
end)

local specButton = addButton("No specialization", true, function()
	SetActiveSpecGroup(3 - GetActiveSpecGroup())
end)

specButton:RegisterEvent("PLAYER_LOGIN")
specButton:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
specButton:SetScript("OnEvent", function(self)
	if GetNumSpecGroups() >= 2 then
		local _, name = GetSpecializationInfo(GetSpecialization())
		self.Text:SetText(format("%d - %s", GetActiveSpecGroup(), name))
		self:Show()
	else
		self:Hide()
	end
end)