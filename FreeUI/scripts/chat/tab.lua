-- Fane by Tekkub, modified.

local F, C, L = unpack(select(2, ...))


local tabFont = {
		C.font.normal,
		12,
		"OUTLINE"
	}

CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 1

CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1

local Fane = CreateFrame("Frame")

local updateFS = function(self, _, _, ...)
	local fstring = self:GetFontString()

	if((...)) then
		fstring:SetTextColor(...)
	end

	fstring:SetShadowColor(0, 0, 0, 0)
end

local OnEnter = function(self)
	local emphasis = _G["ChatFrame"..self:GetID()..'TabFlash']:IsShown()
	updateFS(self, emphasis, 'OUTLINEMONOCHROME', 0, .8, 1)
end

local OnLeave = function(self)
	local r, g, b
	local id = self:GetID()
	local emphasis = _G["ChatFrame"..id..'TabFlash']:IsShown()

	if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
		r, g, b = unpack(C.class)
	elseif emphasis then
		r, g, b = 1, 0, 0
	else
		r, g, b = 1, 1, 1
	end

	updateFS(self, emphasis, nil, r, g, b)
end

local ChatFrame2_SetAlpha = function(self, alpha)
	if(CombatLogQuickButtonFrame_Custom) then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local ChatFrame2_GetAlpha = function(self)
	if(CombatLogQuickButtonFrame_Custom) then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if(not frame.Fane) then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()

		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()

		frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
		frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
		frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide

		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()

		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)

		if C.client == "zhCN" or C.client == "zhTW" then
			frame:GetFontString():SetFont(unpack(tabFont))
		else
			F.SetFS(frame:GetFontString())
		end

		frame.Fane = true
	end

	-- We can't trust sel. :(
	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame, nil, nil, unpack(C.class))
	else
		updateFS(frame, nil, nil, 1, 1, 1)
	end
end

hooksecurefunc('FCF_StartAlertFlash', function(frame)
	local tab = _G['ChatFrame' .. frame:GetID() .. 'Tab']
	updateFS(tab, true, nil, 1, 0, 0)
end)

hooksecurefunc('FCFTab_UpdateColors', faneifyTab)

for i = 1, NUM_CHAT_WINDOWS do
	faneifyTab(_G['ChatFrame'.. i.."Tab"])
end

function Fane:ADDON_LOADED(event, addon)
	if(addon == 'Blizzard_CombatLog') then
		self:UnregisterEvent(event)
		self[event] = nil

		return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
	end
end
Fane:RegisterEvent'ADDON_LOADED'

Fane:SetScript('OnEvent', function(self, event, ...)
	return self[event](self, event, ...)
end)