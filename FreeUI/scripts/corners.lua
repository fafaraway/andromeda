local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

-- Left corner

local left = CreateFrame("Frame")
left:SetBackdrop({
	bgFile = C.media.backdrop,
	edgeFile = C.media.glow,
	edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3},
})
left:SetBackdropColor(.4, .6, 1)
left:SetBackdropBorderColor(.4, .6, 1)
left:SetAlpha(0)
left:SetSize(8, 8)
left:SetPoint("BOTTOMLEFT")
left:EnableMouse(true)
left:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		if DropDownList1:IsShown() then
			ToggleFrame(DropDownList1)
		else
			F.MicroMenu()
		end
	elseif button == "RightButton" then
		ToggleFrame(ChatMenu)
	end
end)

left:SetScript("OnEnter", function(self)
	self:SetAlpha(1)
	F.CreatePulse(self)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 14, 14)
		GameTooltip:AddLine("FreeUI", r, g, b)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Left-click:", "Toggle micro menu", r, g, b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Right-click:", "Toggle chat menu", r, g, b, 1, 1, 1)
		GameTooltip:Show()
	end
end)

left:SetScript("OnLeave", function()
	left:SetScript("OnUpdate", nil)
	left:SetAlpha(0)
	GameTooltip:Hide()
end)

-- Right corner

local right = CreateFrame("Frame")
right:SetBackdrop({
	bgFile = C.media.backdrop,
	edgeFile = C.media.glow,
	edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3},
})
right:SetBackdropColor(1, 0, 0)
right:SetBackdropBorderColor(1, 0, 0)
right:SetAlpha(0)
right:SetSize(8, 8)
right:SetPoint("BOTTOMRIGHT")
right:EnableMouse(true)
right:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
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
	elseif button == "RightButton" then
		if IsAddOnLoaded("DBM-Core") then
			DisableAddOn("DBM-Core")
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM disabled. Type|r /rl |cfffffffffor the changes to apply.|r", unpack(C.class))
		else
			EnableAddOn("DBM-Core")
			LoadAddOn("DBM-Core")
			if IsAddOnLoaded("DBM-Core") then
				DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM loaded.|r", r, g, b)
			else
				DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM not found!|r", r, g, b)
			end
		end
	end
end)

right:SetScript("OnEnter", function(self)
	self:SetAlpha(1)
	F.CreatePulse(self)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -14, 14)
		GameTooltip:AddLine("FreeUI", r, g, b)
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Left-click:", "Toggle alDamageMeter", r, g, b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Right-click:", "Toggle DBM", r, g, b, 1, 1, 1)
		GameTooltip:Show()
	end
end)

right:SetScript("OnLeave", function(self)
	self:SetScript("OnUpdate", nil)
	self:SetAlpha(0)
	GameTooltip:Hide()
end)