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

local function createButton(text, clickFunc)
	local bu = CreateFrame("Button", nil, bar)
	bu:SetPoint("TOP", bar, "TOP")
	bu:SetPoint("BOTTOM", bar, "BOTTOM")
	bu:SetWidth(130)
	F.CreateBD(bu, .1)

	local buText = F.CreateFS(bu)
	buText:SetPoint("CENTER")
	buText:SetText(text)

	bu:SetScript("OnEnter", buttonOnEnter)
	bu:SetScript("OnLeave", buttonOnLeave)
	bu:SetScript("OnClick", clickFunc)

	return bu
end

local buttonMicroMenu = createButton("Micro menu", function()
	if DropDownList1:IsShown() then
		ToggleFrame(DropDownList1)
	else
		F.MicroMenu()
	end
end)
buttonMicroMenu:SetPoint("LEFT", bar, "LEFT")

local buttonChatMenu = createButton("Chat menu", function()
	ToggleFrame(ChatMenu)
end)
buttonChatMenu:SetPoint("LEFT", buttonMicroMenu, "RIGHT", -1, 0)

local buttonDbm = createButton("Toggle DBM", function()
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
buttonDbm:SetPoint("RIGHT", bar, "RIGHT")

local buttonDamageMeter = createButton("Toggle damage meter", function()
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
buttonDamageMeter:SetPoint("RIGHT", buttonDbm, "LEFT", 1, 0)