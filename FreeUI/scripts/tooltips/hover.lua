local orig1, orig2, GameTooltip = {}, {}, GameTooltip
local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true, instancelock = true, currency = true, keystone = true}

local function tonumber_all(v, ...)
	if select('#', ...) == 0 then
		return tonumber(v)
	else
		return tonumber(v), tonumber_all(...)
	end
end

local function ShowBattlePetTooltip(frame, pre, ...)
	GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT")
	BattlePetToolTip_Show(tonumber_all(...))
end

local function OnHyperlinkEnter(frame, link, ...)
	local linktype = link:match("^([^:]+)")
	if linktype and linktypes[linktype] then
		GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	elseif linktype and linktype == 'battlepet' then
		ShowBattlePetTooltip(frame, strsplit(":", link))
	end

	if orig1[frame] then return orig1[frame](frame, link, ...) end
end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	BattlePetTooltip:Hide()
	if orig2[frame] then return orig2[frame](frame, ...) end
end

for i=1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript("OnHyperlinkEnter")
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

	orig2[frame] = frame:GetScript("OnHyperlinkLeave")
	frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end