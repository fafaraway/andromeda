local F, C, L = unpack(select(2, ...))

if not C.tooltip.enable then return end

local ADDON_NAME, ns = ...
local GameTooltip = _G["GameTooltip"]

-- Position
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	if C.tooltip.anchorCursor then
		self:SetOwner(parent, "ANCHOR_CURSOR")
	else
		self:SetOwner(parent, "ANCHOR_NONE")
		self:SetPoint(unpack(C.tooltip.tipPosition))
	end
end)

local locale = GetLocale()
local BOSS, ELITE = BOSS, ELITE
local RARE, RAREELITE
if (locale == "zhCN") then
	RARE = "稀有"
	RAREELITE = "稀有精英"
elseif (locale == "zhTW") then
	RARE = "稀有"
	RAREELITE = "稀有精英"
else
	RARE = "Rare"
	RAREELITE = "Rare Elite"
end

local classification = {
	elite = ("|cffFFCC00 %s|r"):format(ELITE),
	rare = ("|cffCC00FF %s|r"):format(RARE),
	rareelite = ("|cffCC00FF %s|r"):format(RAREELITE),
	worldboss = ("|cffFF0000?? %s|r"):format(BOSS)
}

local hex = function(r, g, b)
	if(r and not b) then
		r, g, b = r.r, r.g, r.b
	end

	return (b and format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)) or "|cffFFFFFF"
end

local qqColor = { r=1, g=0, b=0 }
local nilcolor = { r=1, g=1, b=1 }
local tapped = { r=.6, g=.6, b=.6 }
local deadColor = { r=.6, g=.6, b=.6 }


local function unitColor(unit)
	local colors

	if(UnitPlayerControlled(unit)) then
		local _, class = UnitClass(unit)
		if(class and UnitIsPlayer(unit)) then
			-- Players have color
			colors = C.classcolours[class]
		elseif(UnitCanAttack(unit, "player")) then
			-- Hostiles are red
			colors = FACTION_BAR_COLORS[2]
		elseif(UnitCanAttack("player", unit)) then
			-- Units we can attack but which are not hostile are yellow
			colors = FACTION_BAR_COLORS[4]
		elseif(UnitIsPVP(unit)) then
			-- Units we can assist but are PvP flagged are green
			colors = FACTION_BAR_COLORS[6]
		end
	elseif(UnitIsTapDenied(unit, "player")) then
		colors = tappedColor
	end

	if(not colors) then
		local reaction = UnitReaction(unit, "player")
		colors = reaction and FACTION_BAR_COLORS[reaction] or nilColor
	end

	return colors.r, colors.g, colors.b
end
GameTooltip_UnitColor = unitColor

local function getUnit(self)
	local _, unit = self and self:GetUnit()
	if(not unit) then
		local mFocus = GetMouseFocus()

		if(mFocus) then
			unit = mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))
		end
	end

	return (unit or "mouseover")
end

local function hideLines(self)
	for i=3, self:NumLines() do
		local tipLine = _G["GameTooltipTextLeft"..i]
		local tipText = tipLine:GetText()

		if(tipText == FACTION_ALLIANCE) then
			tipLine:SetText(nil)
			tipLine:Hide()
		elseif(tipText == FACTION_HORDE) then
			tipLine:SetText(nil)
			tipLine:Hide()
		elseif(tipText == PVP) then
			tipLine:SetText(nil)
			tipLine:Hide()
		end
	end
end

local function formatLines(self)
	local hidden = {}
	local numLines = self:NumLines()

	for i=2, numLines do
		local tipLine = _G["GameTooltipTextLeft"..i]

		if(tipLine and not tipLine:IsShown()) then
			hidden[i] = tipLine
		end
	end

	for i, line in next, hidden do
		local nextLine = _G["GameTooltipTextLeft"..i+1]

		if(nextLine) then
			local point, relativeTo, relativePoint, x, y = line:GetPoint()
			nextLine:SetPoint(point, relativeTo, relativePoint, x, y)
		end
	end
end

local function SetStatusBar(self, unit)
	if(GameTooltipStatusBar:IsShown()) then
		GameTooltipStatusBar:SetStatusBarTexture(C.media.texture)
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetHeight(2)
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 1, -3)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -1, -3)

		local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(GameTooltipStatusBar)
		bg:SetTexture(C.media.texture)
		bg:SetVertexColor(.3, .3, .3, .5)
	end

	if(unit) then
		GameTooltipStatusBar:SetStatusBarColor(GameTooltip_UnitColor(unit))
	else
		GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
	end
end

local function getTarget(unit)
	if(UnitIsUnit(unit, "player")) then
		return ("|cffff0000%s|r"):format(C.tooltip.YOU)
	else
		return UnitName(unit)
	end
end

local function ShowTarget(self, unit)
	if (UnitExists(unit.."target")) then
		local tarRicon, text = GetRaidTargetIndex(unit.."target")
		
		if (tarRicon and ICON_LIST[tarRicon]) then
			text = ("%s %s"):format(ICON_LIST[tarRicon].."10|t", getTarget(unit.."target"))
		else
			text = getTarget(unit.."target")
		end

		self:AddLine(TARGET .. ":" .. hex(unitColor(unit.."target")).. text .."|r")
	end
end

GT_Cache = {}
local Cache = GT_Cache
local function getPlayer(unit, origName)
	local guid = UnitGUID(unit)
	if not (Cache[guid]) then
		local class, _, race, _, _, name, realm = GetPlayerInfoByGUID(guid)
		if not name then return end

		if not C.tooltip.hideTitle then
			name = origName:gsub("-(.*)", "")
		end

		if (realm and strlen(realm) > 0) then
			if not C.tooltip.hideRealm then
				realm = ("-"..realm)
			else
				realm = C.tooltip.realmText
			end
		end

		Cache[guid] = {
			name = name,
			class = class,
			race = race,
			realm = realm,
		}
	end
	return Cache[guid], guid
end

local function OnSetUnit(self)
	if(C.tooltip.combatHide and InCombatLockdown()) then
		return self:Hide()
	end

	hideLines(self)

	local unit = getUnit(self)
	local player, guid, isInGuild

	if(UnitExists(unit)) then
		self.ftipUnit = unit

		local isPlayer = UnitIsPlayer(unit)

		if(isPlayer) then
			player, guid = getPlayer(unit, GameTooltipTextLeft1:GetText())

			local Name = player and (player.name .. (player.realm or ""))
			if(Name) then GameTooltipTextLeft1:SetText(Name) end

			local guild, gRank = GetGuildInfo(unit)
			if(guild) then
				isInGuild = true

				if C.tooltip.hideRank then gRank = nil end
				GameTooltipTextLeft2:SetFormattedText(C.tooltip.guildText, guild, gRank or "")
			end
		end

		local status = (UnitIsAFK(unit) and CHAT_FLAG_AFK) or (UnitIsDND(unit) and CHAT_FLAG_DND) or
		(not UnitIsConnected(unit) and "<DC>")
		if(status) then
			self:AppendText((" |cff00cc00%s|r"):format(status))
		end

		local ricon = GetRaidTargetIndex(unit)
		if(ricon) then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."12|t", text)
		end

		local level
		if (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)) then
			level = UnitBattlePetLevel(unit)
		else
			level = UnitLevel(unit)
		end

		if(level) then
			local levelLine
			for i = (isInGuild and 3) or 2, self:NumLines() do
				local line = _G["GameTooltipTextLeft"..i]
				local text = line:GetText()

				if(text and text:find(LEVEL)) then
					levelLine = line
					break
				end
			end

			if(levelLine) then
				local creature = not isPlayer and UnitCreatureType(unit)
				local race = player and player.race or UnitRace(unit)
				local dead = UnitIsDeadOrGhost(unit) and hex(deadColor)..CORPSE.."|r"
				local classify = UnitClassification(unit)

				local class = player and hex(unitColor(unit))..(player.class or "").."|r"
				if(isBattlePet) then
					class = ("|cff80ACEF(%s)|r"):format(_G["BATTLE_PET_NAME_"..UnitBattlePetType(unit)])
				end

				local lvltxt, diff
				if(level == -1) then
					level = classification.worldboss
					lvltxt = level
				else
					level = ("%d"):format(level)
					diff = not isBattlePet and GetQuestDifficultyColor(level)
					lvltxt = ("%s%s|r%s"):format(hex(diff), level, (classify and classification[classify] or ""))
				end

				if(dead) then
					levelLine:SetFormattedText("%s %s", lvltxt, dead)
					GameTooltipStatusBar:Hide()
				else
					levelLine:SetFormattedText("%s %s", lvltxt, (creature or race) or "")
				end

				if(class) then
					lvltxt = levelLine:GetText()
					levelLine:SetFormattedText("%s %s", lvltxt, class)
				end

				if(UnitIsPVP(unit) and UnitCanAttack("player", unit)) then
					lvltxt = levelLine:GetText()
					levelLine:SetFormattedText("%s |cff00FF00(%s)|r", lvltxt, PVP)
				end
			end

			GameTooltipStatusBar:SetStatusBarColor(unitColor(unit))
		end

		ShowTarget(self, unit)
	end

	SetStatusBar(self, unit)
	formatLines(self)
end
GameTooltip:HookScript("OnTooltipSetUnit", OnSetUnit)

local tipCleared = function(self)
	self.ftipUpdate = 1
	self.ftipNumLines = 0
	self.ftipUnit = nil
end
GameTooltip:HookScript("OnTooltipCleared", tipCleared)


local function GTUpdate(self, elapsed)
	if self:IsForbidden() then return end
	self:SetBackdropColor(0, 0, 0, .65)

	self.ftipUpdate = (self.ftipUpdate or 0) + elapsed
	if(self.ftipUpdate < .1) then return end

	if(not C.tooltip.fadeOnUnit) then
		if(self.ftipUnit and not UnitExists(self.ftipUnit)) then self:Hide() return end
	end

	self.ftipUpdate = 0
end
GameTooltip:HookScript("OnUpdate", GTUpdate)

GameTooltip.FadeOut = function(self)
	if(not C.tooltip.fadeOnUnit) then
		self:Hide()
	end
end


local tooltips = {
	"ChatMenu",
	"EmoteMenu",
	"LanguageMenu",
	"VoiceMacroMenu",
	"GameTooltip",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"AutoCompleteBox",
	"WorldMapTooltip",
	"WorldMapCompareTooltip1",
	"WorldMapCompareTooltip2",
	"WorldMapCompareTooltip3",
	"QuestScrollFrame.StoryTooltip",
	"GeneralDockManagerOverflowButtonList",
	"ReputationParagonTooltip",
	"FriendsTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
}

local itemUpdate = {}
local function style(frame)
	local frameName = frame and frame:GetName()
	if not (frameName) then return end

	local bdFrame = frame.BackdropFrame or frame
	if(not frame.ftipBD) then
		bdFrame.ftipBD = true
		
		F.CreateBD(bdFrame)
		F.CreateSD(bdFrame)
	end

	bdFrame:SetBackdropColor(0, 0, 0, .65)
	bdFrame:SetBackdropBorderColor(0, 0, 0)

	frame:SetScale(1)
end
ns.style = style

local frameload = CreateFrame("Frame")
frameload:RegisterEvent("PLAYER_ENTERING_WORLD")
frameload:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	for i, tip in ipairs(tooltips) do
		frame = _G[tip]

		if(frame) then
			frame:HookScript("OnShow", function(self)
				if(C.tooltip.combatHideALL and InCombatLockdown()) then
					return self:Hide()
				end

				style(self)
			end)
		end
	end

	style(GameTooltip)
end)

local itemEvent = CreateFrame("Frame")
itemEvent:RegisterEvent("GET_ITEM_INFO_RECEIVED")
itemEvent:SetScript("OnEvent", function(self, event, arg1)
	for k in next, itemUpdate do
		local tip = _G[k]
		if (tip and tip:IsShown()) then
			style(tip)
		end
	end
end)

GameTooltipHeaderText:SetFont(C.font.normal, 14, "OUTLINE")
GameTooltipText:SetFont(C.font.normal, 12, "OUTLINE")
GameTooltipTextSmall:SetFont(C.font.normal, 12, "OUTLINE")


if C.tooltip.aurasSource then
	local function addAuraInfo(self, caster, spellID)
		if(caster) then
			local color = hex(unitColor(caster))

			GameTooltip:AddLine("CastBy: "..color..UnitName(caster))
			GameTooltip:Show()
		end
	end

	hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
		local _,_,_,_,_,_,_, caster,_,_, spellID = UnitAura(...)
		addAuraInfo(self, caster, spellID)
	end)
	hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
		local _,_,_,_,_,_,_, caster,_,_, spellID = UnitBuff(...)
		addAuraInfo(self, caster, spellID)
	end)
	hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
		local _,_,_,_,_,_,_, caster,_,_, spellID = UnitDebuff(...)
		addAuraInfo(self, caster, spellID)
	end)
end
