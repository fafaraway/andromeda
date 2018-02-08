local F, C, L = unpack(select(2, ...))

if not C.tooltip.enable then return end

local ADDON_NAME, ns = ...

local _, _G = _, _G
local GameTooltip = _G["GameTooltip"]

-- Position
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	if C.tooltip.anchorCursor then
		self:SetOwner(parent, "ANCHOR_CURSOR")
	else
		self:SetOwner(parent, "ANCHOR_NONE")
		self:SetPoint(unpack(C.tooltip.position))
	end
end)


local cfg = {
	font = C.font.normal,
	fontflag = "OUTLINE",

	cursor = C.tooltip.cursor,
	point = C.tooltip.position,
	backdrop = {
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	},
	bgcolor = { r=0, g=0, b=0, t=.65 }, -- background
	bdrcolor = { r=0, g=0, b=0 }, -- border
	statusbar = C.media.texture,
	sbHeight = C.tooltip.sbHeight,
	fadeOnUnit = C.tooltip.fadeOnUnit, -- fade from units instead of hiding instantly
	combathide = C.tooltip.combathide, -- hide just interface toolitps in combat
	combathideALL = C.tooltip.combathideALL,
	showGRank = C.tooltip.showGRank,
	guildText = "|cffE41F9B<%s>|r |cffA0A0A0%s|r",
	showRealm = C.tooltip.realm,
	realmText = " (*)",
	YOU = "<YOU>",
	playerTitle = C.tooltip.playerTitle,
}

ns.cfg = cfg

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

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local qqColor = { r=1, g=0, b=0 }
local nilColor = { r=1, g=1, b=1 }
local tappedColor = { r=.6, g=.6, b=.6 }
local deadColor = { r=.6, g=.6, b=.6 }


local classification = {
	elite = ("|cffFFCC00 %s|r"):format(ELITE),
	rare = ("|cffCC00FF %s|r"):format(RARE),
	rareelite = ("|cffCC00FF %s|r"):format(RAREELITE),
	worldboss = ("|cffFF0000?? %s|r"):format(BOSS)
}

local TooltipHeaderText = {}
TooltipHeaderText[1], TooltipHeaderText[2], TooltipHeaderText[3] = GameTooltipHeaderText:GetFont()
GameTooltipHeaderText:SetFont(cfg.font or TooltipHeaderText[1], TooltipHeaderText[2], cfg.fontflag or TooltipHeaderText[3])

local TooltipText = {}
TooltipText[1], TooltipText[2], TooltipText[3] = GameTooltipText:GetFont()
GameTooltipText:SetFont(cfg.font or TooltipText[1], TooltipText[2], cfg.fontflag or TooltipText[3])

local TooltipTextSmall = {}
TooltipTextSmall[1], TooltipTextSmall[2], TooltipTextSmall[3] = GameTooltipTextSmall:GetFont()
GameTooltipTextSmall:SetFont(cfg.font or TooltipTextSmall[1], TooltipTextSmall[2], cfg.fontflag or TooltipTextSmall[3])


local hex = function(r, g, b)
	if(r and not b) then
		r, g, b = r.r, r.g, r.b
	end

	return (b and format('|cff%02x%02x%02x', r * 255, g * 255, b * 255)) or "|cffFFFFFF"
end


local function unitColor(unit)
	local colors

	if(UnitPlayerControlled(unit)) then
		local _, class = UnitClass(unit)
		if(class and UnitIsPlayer(unit)) then
			-- Players have color
			colors = RAID_CLASS_COLORS[class]
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

FreebTip_Cache = {}
local Cache = FreebTip_Cache
local function getPlayer(unit, origName)
	local guid = UnitGUID(unit)
	if not (Cache[guid]) then
		local class, _, race, _, _, name, realm = GetPlayerInfoByGUID(guid)
		if not name then return end

		if(cfg.playerTitle) then
			name = origName:gsub("-(.*)", "")
		end

		if (realm and strlen(realm) > 0) then
			if(cfg.showRealm) then
				realm = ("-"..realm)
			else
				realm = cfg.realmText
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

local function getTarget(unit)
	if(UnitIsUnit(unit, "player")) then
		return ("|cffff0000%s|r"):format(cfg.YOU)
	else
		return UnitName(unit)
	end
end

local function ShowTarget(self, unit)
	if (UnitExists(unit.."target")) then
		local tarRicon = GetRaidTargetIndex(unit.."target")
		local tar = ("%s %s"):format((tarRicon and ICON_LIST[tarRicon].."10|t") or "", getTarget(unit.."target"))

		self:AddLine(TARGET .. ":" .. hex(unitColor(unit.."target")).. tar .."|r")
	end
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


-- GameTooltip HookScripts

local function OnSetUnit(self)
	if(cfg.combathide and InCombatLockdown()) then
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

				if(not cfg.showGRank) then gRank = nil end
				GameTooltipTextLeft2:SetFormattedText(cfg.guildText, guild, gRank or "")
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


		local isBattlePet = UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit)
		local level = isBattlePet and UnitBattlePetLevel(unit) or UnitLevel(unit)

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

	formatLines(self)
end
GameTooltip:HookScript("OnTooltipSetUnit", OnSetUnit)

local tipCleared = function(self)
	if(self.factionIcon) then
		self.factionIcon:Hide()
	end

	self.ftipUpdate = 1
	self.ftipNumLines = 0
	self.ftipUnit = nil
end
GameTooltip:HookScript("OnTooltipCleared", tipCleared)

local function GTUpdate(self, elapsed)
	self.ftipUpdate = (self.ftipUpdate or 0) + elapsed
	if(self.ftipUpdate < .1) then return end

	if(not cfg.fadeOnUnit) then
		if(self.ftipUnit and not UnitExists(self.ftipUnit)) then self:Hide() return end
	end

	self:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t)

	self.ftipUpdate = 0
end
GameTooltip:HookScript("OnUpdate", GTUpdate)

GameTooltip.FadeOut = function(self)
	if(not cfg.fadeOnUnit) then
		self:Hide()
	end
end

-- StatusBar
GameTooltipStatusBar:SetStatusBarTexture(cfg.statusbar)
GameTooltipStatusBar:SetHeight(cfg.sbHeight)
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 1, -3)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -1, -3)

local gtSBbg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
gtSBbg:SetAllPoints(GameTooltipStatusBar)
gtSBbg:SetTexture(cfg.statusbar)
gtSBbg:SetVertexColor(0.3, 0.3, 0.3, 0.5)

local ssbc = CreateFrame("StatusBar").SetStatusBarColor
GameTooltipStatusBar._SetStatusBarColor = ssbc
function GameTooltipStatusBar:SetStatusBarColor(...)
	local unit = getUnit(GameTooltip)
	if(UnitExists(unit)) then
		return self:_SetStatusBarColor(unitColor(unit))
	end
end


-- Style

local extra = {
	"QueueStatusFrame",
	"FloatingGarrisonFollowerTooltip",
	"FloatingGarrisonFollowerAbilityTooltip",
	"FloatingGarrisonMissionTooltip",
	"GarrisonFollowerAbilityTooltip",
	"GarrisonFollowerTooltip",
	"FloatingGarrisonShipyardFollowerTooltip",
	"GarrisonShipyardFollowerTooltip",
	"BattlePetTooltip",
	"PetBattlePrimaryAbilityTooltip",
	"PetBattlePrimaryUnitTooltip",
	"FloatingBattlePetTooltip",
	"FloatingPetBattleAbilityTooltip",
	"IMECandidatesFrame"
}

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
		bdFrame:SetBackdrop(cfg.backdrop)
		bdFrame.ftipBD = true
		
		F.CreateBD(bdFrame)
		F.CreateSD(bdFrame)
	end

	bdFrame:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t)
	bdFrame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)

	-- if(frame.GetItem) then
	-- 	local _, item = frame:GetItem()
	-- 	if(item) then
	-- 		local quality = select(3, GetItemInfo(item))
	-- 		if(quality) then
	-- 			local r, g, b = GetItemQualityColor(quality)
	-- 			frame:SetBackdropBorderColor(r, g, b)

	-- 			itemUpdate[frameName] = nil
	-- 		else

	-- 			itemUpdate[frameName] = true
	-- 		end
	-- 	end
	-- end

	-- if(frame.hasMoney and frame.numMoneyFrames ~= frame.ftipNumMFrames) then
	-- 	for i=1, frame.numMoneyFrames do
	-- 		_G[frameName.."MoneyFrame"..i.."PrefixText"]:SetFontObject(GameTooltipText)
	-- 		_G[frameName.."MoneyFrame"..i.."SuffixText"]:SetFontObject(GameTooltipText)
	-- 		_G[frameName.."MoneyFrame"..i.."GoldButtonText"]:SetFontObject(GameTooltipText)
	-- 		_G[frameName.."MoneyFrame"..i.."SilverButtonText"]:SetFontObject(GameTooltipText)
	-- 		_G[frameName.."MoneyFrame"..i.."CopperButtonText"]:SetFontObject(GameTooltipText)
	-- 	end

	-- 	frame.ftipNumMFrames = frame.numMoneyFrames
	-- end

	-- if(frame.shopping and not frame.ftipFontSet) then
	-- 	_G[frameName.."TextLeft1"]:SetFontObject(GameTooltipTextSmall)
	-- 	_G[frameName.."TextRight1"]:SetFontObject(GameTooltipText)
	-- 	_G[frameName.."TextLeft2"]:SetFontObject(GameTooltipHeaderText)
	-- 	_G[frameName.."TextRight2"]:SetFontObject(GameTooltipTextSmall)
	-- 	_G[frameName.."TextLeft3"]:SetFontObject(GameTooltipTextSmall)
	-- 	_G[frameName.."TextRight3"]:SetFontObject(GameTooltipTextSmall)
	-- 	_G[frameName.."TextRight4"]:SetFontObject(GameTooltipTextSmall)

	-- 	frame.ftipFontSet = true
	-- end

	-- if (frame.BattlePet and not frame.ftipBPfont) then
	-- 	frame.Name:SetFontObject(GameTooltipHeaderText)
	-- 	frame.BattlePet:SetFontObject(GameTooltipText)
	-- 	frame.PetType:SetFontObject(GameTooltipText)
	-- 	frame.Health:SetFontObject(GameTooltipText)
	-- 	frame.Level:SetFontObject(GameTooltipText)
	-- 	frame.Power:SetFontObject(GameTooltipText)
	-- 	frame.Speed:SetFontObject(GameTooltipText)
	-- 	frame.Owned:SetFontObject(GameTooltipText)
	-- 	frame.BorderTop:Hide()
	-- 	frame.BorderRight:Hide()
	-- 	frame.BorderBottom:Hide()
	-- 	frame.BorderLeft:Hide()
	-- 	frame.BorderTopLeft:Hide()
	-- 	frame.BorderTopRight:Hide()
	-- 	frame.BorderBottomLeft:Hide()
	-- 	frame.BorderBottomRight:Hide()
	-- 	frame.ftipBPfont = true
	-- end

	-- if (frame.Garrison and not frame.ftipGarrison) then
	-- 	frame.BorderTop:Hide()
	-- 	frame.BorderRight:Hide()
	-- 	frame.BorderBottom:Hide()
	-- 	frame.BorderLeft:Hide()
	-- 	frame.BorderTopLeft:Hide()
	-- 	frame.BorderTopRight:Hide()
	-- 	frame.BorderBottomLeft:Hide()
	-- 	frame.BorderBottomRight:Hide()
	-- 	frame.Background:Hide()
	-- 	frame.ftipGarrison = true
	-- end
	frame:SetScale(1)
end
ns.style = style

-- local function OverrideGetBackdropColor()
-- 	return cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t
-- end
-- GameTooltip.GetBackdropColor = OverrideGetBackdropColor
-- GameTooltip:SetBackdropColor(OverrideGetBackdropColor)

-- local function OverrideGetBackdropBorderColor()
-- 	return cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b
-- end
-- GameTooltip.GetBackdropBorderColor = OverrideGetBackdropBorderColor
-- GameTooltip:SetBackdropBorderColor(OverrideGetBackdropBorderColor)

local function framehook(frame)
	frame:HookScript("OnShow", function(self)
		if (cfg.combathideALL and cfg.combathideALL ~= 0 and InCombatLockdown()) then
			return self:Hide()
		end
		style(self)
	end)
end

local frameload = CreateFrame("Frame")
frameload:RegisterEvent("ADDON_LOADED")
frameload:RegisterEvent("PLAYER_ENTERING_WORLD")
frameload:SetScript("OnEvent", function(self, event, arg1)
	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		for i, tip in ipairs(tooltips) do
			local frame = _G[tip]
			if (frame) then
				framehook(frame)
			end
		end

		for i, tip in ipairs(extra) do
			local frame = _G[tip]
			if (frame) then
				framehook(frame)
				frame.extra = true
			end
		end
	end
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

-- Aura Source

if C.auras.aurasSource then
	local function addAuraInfo(self, caster, spellID)
		if(caster) then
			local color = hex(unitColor(caster))

			GameTooltip:AddDoubleLine("CastBy: "..color..UnitName(caster))
			GameTooltip:Show()
		end
	end

	local UnitAura, UnitBuff, UnitDebuff = UnitAura, UnitBuff, UnitDebuff
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
