local F, C = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local bar = CreateFrame("Frame", "FreeUIMenubar", UIParent)
bar:SetFrameStrata("BACKGROUND")
bar:SetPoint("BOTTOMLEFT", -1, -1)
bar:SetPoint("BOTTOMRIGHT", 1, -1)
bar:SetHeight(13)
bar:SetAlpha(0)
F.CreateBD(bar)

local function showBar()
	bar:SetAlpha(1)
end
bar.showBar = showBar

local function hideBar()
	bar:SetAlpha(0)
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

	return bu
end

bar.addButton = addButton

local buttonMicroMenu = addButton("Micro menu", false, function()
	if DropDownList1:IsShown() then
		ToggleFrame(DropDownList1)
	else
		F.MicroMenu()
	end
end)

local buttonChatMenu = addButton("Chat menu", false, function()
	ToggleFrame(ChatMenu)
end)

local buttonDbm = addButton("Toggle DBM", true, function()
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

local buttonDamageMeter = addButton("Toggle damage meter", true, function()
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