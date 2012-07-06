-- aTooltip by Alza, modified.

local F, C, L = unpack(select(2, ...))

PVP_ENABLED = ""

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	if C.general.tooltip_cursor == true then
		self:SetOwner(parent, "ANCHOR_CURSOR")
	else
		self:SetOwner(parent, "ANCHOR_NONE")
		self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 282)
	end
end)

--[[ BG ]]

local tooltips = {
	"GameTooltip",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ShoppingTooltip3",
	"WorldMapTooltip",
	"ChatMenu",
	"EmoteMenu",
	"LanguageMenu",
	"VoiceMacroMenu",
}

local backdrop = {
	bgFile = C.media.backdrop,
	edgeFile = C.media.backdrop,
	edgeSize = 1,
}

-- so other stuff which tries to look like GameTooltip doesn't mess up
local getBackdrop = function()
	return backdrop
end

local getBackdropColor = function()
	return 0, 0, 0, .6
end

local getBackdropBorderColor = function()
	return 0, 0, 0
end

for i = 1, #tooltips do
	local t = _G[tooltips[i]]
	t:SetBackdrop(nil)
	local bg = CreateFrame("Frame", nil, t)
	bg:SetPoint("TOPLEFT")
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(t:GetFrameLevel()-1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(0, 0, 0, .6)
	bg:SetBackdropBorderColor(0, 0, 0)
	
	t.GetBackdrop = getBackdrop
	t.GetBackdropColor = getBackdropColor
	t.GetBackdropBorderColor = getBackdropBorderColor
end

--[[ Statusbar ]]

hooksecurefunc("HealthBar_OnValueChanged", function(self)
	self:SetStatusBarColor(.3, 1, .3)
end)

local sb = _G["GameTooltipStatusBar"]
sb:SetHeight(3)
sb:ClearAllPoints()
sb:SetPoint("BOTTOMLEFT", GameTooltip, "BOTTOMLEFT", 1, 1)
sb:SetPoint("BOTTOMRIGHT", GameTooltip, "BOTTOMRIGHT", -1, 1)
sb:SetStatusBarTexture(C.media.texture)

local sep = GameTooltipStatusBar:CreateTexture(nil, "ARTWORK")
sep:SetHeight(1)
sep:SetPoint("BOTTOMLEFT", 0, 3)
sep:SetPoint("BOTTOMRIGHT", 0, 3)
sep:SetTexture(C.media.backdrop)
sep:SetVertexColor(0, 0, 0)

--[[ Unit tooltip styling ]]
local classification = {
	worldboss = "",
	rareelite = "R+",
	elite = "+",
	rare = "R",
}

local function Hex(r, g, b)
	return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
end

local function GetColor(unit)
	local r, g, b = 1, 1, 1

	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		r, g, b = C.classcolours[class or "WARRIOR"].r, C.classcolours[class or "WARRIOR"].g, C.classcolours[class or "WARRIOR"].b
	elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) or UnitIsDead(unit) then
		r, g, b = .6, .6, .6
	else
		r, g, b = unpack(C.reactioncolours[UnitReaction("player", unit) or 5])
	end

	return Hex(r, g, b)
end

local function OnTooltipSetUnit(self)
	local lines = self:NumLines()
	local _, unit = self:GetUnit()
	if(not unit) then return end

	local race = UnitRace(unit) or ""
	local level = UnitLevel(unit) or ""
	local c = UnitClassification(unit)
	local crtype = UnitCreatureType(unit)
	local unitName, unitRealm = UnitName(unit)

	if(level and level==-1) then
		if(c=="worldboss") then
			level = "|cffff0000Boss|r"
		else
			level = "|cffff0000??|r"
		end
	end

	local color = GetColor(unit)

	if unitRealm and unitRealm ~= "" then
		_G["GameTooltipTextLeft1"]:SetFormattedText(color.."%s - %s", unitName, unitRealm)
	else
		_G["GameTooltipTextLeft1"]:SetText(color..unitName)
	end

	if(UnitIsPlayer(unit)) then
		local guildName, guildRankName = GetGuildInfo(unit)
		if(guildName) then
			if C.general.tooltip_guildranks then
				_G["GameTooltipTextLeft2"]:SetFormattedText("%s ("..color.."%s|r)", guildName, guildRankName)
			else
				_G["GameTooltipTextLeft2"]:SetText(guildName)
			end
		end

		local n = guildName and 3 or 2
		_G["GameTooltipTextLeft"..n]:SetFormattedText("%s %s", level, race)
	else
		for i = 2, lines do
			local line = _G["GameTooltipTextLeft"..i]
			local text = line:GetText() or ""
			if((level and text:find("^"..LEVEL)) or (crtype and text:find("^"..crtype))) then
				line:SetFormattedText("%s%s %s", level, classification[c] or "", crtype or "")
				break
			end
		end
	end

	--[[ Target line ]]
	local tunit = unit.."target"
	if(UnitExists(tunit) and unit~="player") then
		local color = GetColor(tunit)
		local text = ""

		if(UnitName(tunit)==UnitName("player")) then
			text = "T: > YOU <"
		else
			text = "T: "..UnitName(tunit)
		end

		self:AddLine(color..text)
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

--[[ Item Icons ]]
local frame = CreateFrame("Frame", "ItemRefTooltipIconFrame", _G["ItemRefTooltip"])
frame:SetPoint("TOPRIGHT", _G["ItemRefTooltip"], "TOPLEFT", -2, -1)
frame:SetSize(32, 32)

local tex = frame:CreateTexture("ItemRefTooltipIcon", "TOOLTIP")
tex:SetAllPoints(frame)

F.CreateBG(frame)
			
local AddItemIcon = function()
	local frame = _G["ItemRefTooltipIconFrame"]
	frame:Hide()

	local _, link = _G["ItemRefTooltip"]:GetItem()
	local icon = link and GetItemIcon(link)
	if(not icon) then return end

	_G["ItemRefTooltipIcon"]:SetTexture(icon)
	_G["ItemRefTooltipIcon"]:SetTexCoord(.08, .92, .08, .92)
	frame:Show()
end

hooksecurefunc("SetItemRef", AddItemIcon)