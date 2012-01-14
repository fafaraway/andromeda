local F, C, L = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local f = CreateFrame("Frame")
f:SetBackdrop({
	bgFile = C.media.backdrop,
	edgeFile = C.media.glow,
	edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3},
})
f:SetBackdropColor(1, 0, 0)
f:SetBackdropBorderColor(1, 0, 0)
f:SetAlpha(0)
f:SetSize(8, 8)
f:SetPoint("BOTTOMRIGHT")
f:EnableMouse(true)
f:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		if IsAddOnLoaded("alDamageMeter") then
			DisableAddOn("alDamageMeter")
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffalDamageMeter disabled. Type|r /rl |cfffffffffor the changes to apply.|r", unpack(C.class))
		else
			EnableAddOn("alDamageMeter")
			LoadAddOn("alDamageMeter")
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffalDamageMeter loaded.|r", unpack(C.class))
		end
	elseif button == "RightButton" then
		if IsAddOnLoaded("DBM-Core") then
			DisableAddOn("DBM-Core")
			DisableAddOn("!dbm")
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM disabled. Type|r /rl |cfffffffffor the changes to apply.|r", unpack(C.class))
		else
			EnableAddOn("!dbm")
			EnableAddOn("DBM-Core")
			LoadAddOn("!dbm")
			LoadAddOn("DBM-Core")
			DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffDBM loaded.|r", unpack(C.class))
		end
	end
end)

f:SetScript("OnEnter", function()
	f:SetAlpha(1)
	F.CreatePulse(f)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(f, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 14)
		GameTooltip:AddLine("FreeUI", unpack(C.class))
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("Left-click:", "Toggle alDamageMeter", r, g, b, 1, 1, 1)
		GameTooltip:AddDoubleLine("Right-click:", "Toggle DBM", r, g, b, 1, 1, 1)
		GameTooltip:Show()
	end
end)

f:SetScript("OnLeave", function()
	f:SetScript("OnUpdate", nil)
	f:SetAlpha(0)
	GameTooltip:Hide()
end)

local g = CreateFrame("Frame")
g:SetBackdrop({
	bgFile = C.media.backdrop,
	edgeFile = C.media.glow,
	edgeSize = 3,
	insets = {left = 3, right = 3, top = 3, bottom = 3},
})
g:SetBackdropColor(.4, .6, 1)
g:SetBackdropBorderColor(.4, .6, 1)
g:SetAlpha(0)
g:SetSize(8, 8)
g:SetPoint("BOTTOMLEFT")
g:EnableMouse(true)
g:SetScript("OnMouseDown", function(self, button)
		ToggleFrame(ChatMenu)
end)

g:SetScript("OnEnter", function()
	g:SetAlpha(1)
	F.CreatePulse(g)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(g, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMLEFT", g, "BOTTOMLEFT", 14, 14)
		GameTooltip:AddLine("FreeUI", unpack(C.class))
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Click to toggle chat menu", 1, 1, 1)
		GameTooltip:Show()
	end
end)

g:SetScript("OnLeave", function()
	g:SetScript("OnUpdate", nil)
	g:SetAlpha(0)
	GameTooltip:Hide()
end)