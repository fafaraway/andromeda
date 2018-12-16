local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule("tooltip")

function module:OnLogin()
	self:extraInfo()
	self:azeriteTrait()
end

if not C.tooltip.enable then return end


local COALESCED_REALM_TOOLTIP1 = string.split(FOREIGN_SERVER_LABEL, COALESCED_REALM_TOOLTIP)
local INTERACTIVE_REALM_TOOLTIP1 = string.split(INTERACTIVE_SERVER_LABEL, INTERACTIVE_REALM_TOOLTIP)

PVP_ENABLED = "|cffff0000PVP|r"

local classification = {
	elite = " |cffcc8800"..ELITE.."|r",
	rare = " |cffff99cc"..L["rare"].."|r",
	rareelite = " |cffff99cc"..L["rare"].."|r ".."|cffcc8800"..ELITE.."|r",
	worldboss = " |cffff0000"..BOSS.."|r",
}

local function getUnit(self)
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		if mFocus then
			unit = mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))
		end
	end
	return (unit or "mouseover")
end

local function hideLines(self)
    for i = 3, self:NumLines() do
        local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext then
			if C.tooltip.hidePVP and linetext == PVP_ENABLED then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif linetext:find(COALESCED_REALM_TOOLTIP1) or linetext:find(INTERACTIVE_REALM_TOOLTIP1) then
				tiptext:SetText(nil)
				tiptext:Hide()
				local pretiptext = _G["GameTooltipTextLeft"..i-1]
				pretiptext:SetText(nil)
				pretiptext:Hide()
				self:Show()
			elseif linetext == FACTION_HORDE then
				if C.tooltip.hideFaction then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040"..linetext.."|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if C.tooltip.hideFaction then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff"..linetext.."|r")
				end
			end
		end
    end
end

local function getTarget(unit)
	if UnitIsUnit(unit, "player") then
		return ("|cffff0000%s|r"):format(">"..string.upper(YOU).."<")
	else
		return F.HexRGB(F.UnitColor(unit))..UnitName(unit).."|r"
	end
end


GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if(C.tooltip.combatHide and InCombatLockdown()) then
		return self:Hide()
	end

	hideLines(self)

	local unit = getUnit(self)

	if(UnitExists(unit)) then
		self.ttUnit = unit

		local hexColor = F.HexRGB(F.UnitColor(unit))
		local ricon = GetRaidTargetIndex(unit)
		if ricon and ricon > 8 then ricon = nil end
		if ricon then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."18|t", text)
		end

		if UnitIsPlayer(unit) then
			local unitName
			if C.tooltip.hideTitle and C.tooltip.hideRealm then
				unitName = UnitName(unit)
			elseif C.tooltip.hideTitle then
				unitName = GetUnitName(unit, true)
			elseif C.tooltip.hideRealm then
				unitName = UnitPVPName(unit) or UnitName(unit)
			end
			if unitName then GameTooltipTextLeft1:SetText(unitName) end

			local relationship = UnitRealmRelationship(unit)
			if relationship == LE_REALM_RELATION_VIRTUAL then
				self:AppendText(("|cffcccccc%s|r"):format(INTERACTIVE_SERVER_LABEL))
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				self:AppendText((" |cff00cc00<%s>|r"):format(status))
			end

			local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
			local text = GameTooltipTextLeft2:GetText()
			if rank and text then
				rankIndex = rankIndex + 1
				if C.tooltip.hideGuildRank then
					GameTooltipTextLeft2:SetText("<"..text..">")
				else
					GameTooltipTextLeft2:SetText("<"..text..">  "..rank.."("..rankIndex..")")
				end

				local myGuild, _, _, myGuildRealm = GetGuildInfo("player")
				if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
					GameTooltipTextLeft2:SetTextColor(182/255, 243/255, 136/255)
				else
					GameTooltipTextLeft2:SetTextColor(166/255, 217/255, 243/255)
				end
			end
		end

		local line1 = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText("%s", hexColor..line1)

		local alive = not UnitIsDeadOrGhost(unit)
		local level
		if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
			level = UnitBattlePetLevel(unit)
		else
			level = UnitLevel(unit)
		end

		if level then
			local boss
			if level == -1 then boss = "|cffff0000??|r" end

			local diff = GetCreatureDifficultyColor(level)
			local classify = UnitClassification(unit)
			local textLevel = ("%s%s%s|r"):format(F.HexRGB(diff), boss or ("%d"):format(level), classification[classify] or "")
			local tiptextLevel
			for i = 2, self:NumLines() do
				local tiptext = _G["GameTooltipTextLeft"..i]
				local linetext = tiptext:GetText()
				if linetext and linetext:find(LEVEL) then
					tiptextLevel = tiptext
				end
			end

			local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
			local unitClass = UnitIsPlayer(unit) and ("%s %s"):format(UnitRace(unit) or "", hexColor..(UnitClass(unit) or "").."|r") or ""
			if tiptextLevel then
				tiptextLevel:SetFormattedText(("%s %s%s %s"), textLevel, creature, unitClass, (not alive and "|cffCCCCCC"..DEAD.."|r" or ""))
			end
		end

		if UnitExists(unit.."target") then
			local tarRicon = GetRaidTargetIndex(unit.."target")
			if tarRicon and tarRicon > 8 then tarRicon = nil end
			local tar = ("%s%s"):format((tarRicon and ICON_LIST[tarRicon].."10|t") or "", getTarget(unit.."target"))
			self:AddLine(TARGET..": "..tar)
		end

		if alive then
			GameTooltipStatusBar:SetStatusBarColor(F.UnitColor(unit))
		else
			GameTooltipStatusBar:Hide()
		end
	else
		GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
	end
end)


GameTooltip:HookScript("OnTooltipCleared", function(self)
	self.ttUpdate = 1
	self.ttNumLines = 0
	self.ttUnit = nil
end)

GameTooltip:HookScript("OnUpdate", function(self, elapsed)
	self.ttUpdate = (self.ttUpdate or 0) + elapsed
	if(self.ttUpdate < .1) then return end

	if(not C.tooltip.fadeOnUnit) then
		if(self.ttUnit and not UnitExists(self.ttUnit)) then self:Hide() return end
	end

	self:SetBackdropColor(0, 0, 0, .65)

	self.ttUpdate = 0
end)

GameTooltip.FadeOut = function(self)
	if(not C.tooltip.fadeOnUnit) then
		self:Hide()
	end
end


-- StatusBar
GameTooltipStatusBar:SetStatusBarTexture(C.media.sbTex)
GameTooltipStatusBar:SetHeight(2)
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 1, -3)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -1, -3)

local bg = F.CreateBDFrame(GameTooltipStatusBar, 1)

local ssbc = CreateFrame("StatusBar").SetStatusBarColor
GameTooltipStatusBar._SetStatusBarColor = ssbc
function GameTooltipStatusBar:SetStatusBarColor(...)
	local unit = getUnit(GameTooltip)
	if(UnitExists(unit)) then
		return self:_SetStatusBarColor(F.UnitColor(unit))
	end
end

-- world quest progress bar
hooksecurefunc("GameTooltip_ShowProgressBar", function(self)
	if self.progressBarPool then
		local bar = self.progressBarPool:Acquire()
		if bar and not bar.styled then
			F.StripTextures(bar.Bar, true)
			bar.Bar:SetStatusBarTexture(C.media.sbTex)
			F.CreateBD(bar, .25)
			bar:SetSize(216, 18)

			bar.styled = true
		end
	end
end)


-- fix compare tooltips margin
hooksecurefunc("GameTooltip_ShowCompareItem", function(self, shift)
	if not self then
		self = GameTooltip
	end

	-- Find correct side
	local shoppingTooltip1, shoppingTooltip2 = unpack(self.shoppingTooltips)
	local primaryItemShown, secondaryItemShown = shoppingTooltip1:SetCompareItem(shoppingTooltip2, self)
	local side = "left"
	local rightDist = 0
	local leftPos = self:GetLeft()
	local rightPos = self:GetRight()

	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	rightDist = GetScreenWidth() - rightPos

	if leftPos and (rightDist < leftPos) then
		side = "left"
	else
		side = "right"
	end

	-- See if we should slide the tooltip
	if self:GetAnchorType() and self:GetAnchorType() ~= "ANCHOR_PRESERVE" then
		local totalWidth = 0
		if primaryItemShown then
			totalWidth = totalWidth + shoppingTooltip1:GetWidth()
		end
		if secondaryItemShown then
			totalWidth = totalWidth + shoppingTooltip2:GetWidth()
		end

		if side == "left" and totalWidth > leftPos then
			self:SetAnchorType(self:GetAnchorType(), totalWidth - leftPos, 0)
		elseif side == "right" and (rightPos + totalWidth) > GetScreenWidth() then
			self:SetAnchorType(self:GetAnchorType(), -((rightPos + totalWidth) - GetScreenWidth()), 0)
		end
	end

	-- Anchor the compare tooltips
	if secondaryItemShown then
		shoppingTooltip2:SetOwner(self, "ANCHOR_NONE")
		shoppingTooltip2:ClearAllPoints()
		if side and side == "left" then
			shoppingTooltip2:SetPoint("TOPRIGHT", self, "TOPLEFT", -8, -10)
		else
			shoppingTooltip2:SetPoint("TOPLEFT", self, "TOPRIGHT", 8, -10)
		end

		shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
		shoppingTooltip1:ClearAllPoints()

		if side and side == "left" then
			shoppingTooltip1:SetPoint("TOPRIGHT", shoppingTooltip2, "TOPLEFT", -8, 0)
		else
			shoppingTooltip1:SetPoint("TOPLEFT", shoppingTooltip2, "TOPRIGHT", 8, 0)
		end
	else
		shoppingTooltip1:SetOwner(self, "ANCHOR_NONE")
		shoppingTooltip1:ClearAllPoints()

		if side and side == "left" then
			shoppingTooltip1:SetPoint("TOPRIGHT", self, "TOPLEFT", -8, -10)
		else
			shoppingTooltip1:SetPoint("TOPLEFT", self, "TOPRIGHT", 8, -10)
		end

		shoppingTooltip2:Hide()
	end

	shoppingTooltip1:SetCompareItem(shoppingTooltip2, self)
	shoppingTooltip1:Show()
end)


-- Tooltip skin
local function style(self)
	self:SetScale(1)

	if not self.tipStyled then
		F.ReskinClose(ItemRefCloseButton)
		
		self:SetBackdrop(nil)
		local bg = F.CreateBDFrame(self)
		bg:SetFrameLevel(self:GetFrameLevel())
		self.bg = bg

		if C.appearance.shadow then
			local sd = CreateFrame("Frame", nil, self)
			sd:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = 4})
			sd:SetPoint("TOPLEFT", -4, 4)
			sd:SetPoint("BOTTOMRIGHT", 4, -4)
			sd:SetBackdropBorderColor(0, 0, 0, .5)
			self.sd = sd
		end

		-- other gametooltip-like support
		self.GetBackdrop = function() return bg:GetBackdrop() end
		self.GetBackdropColor = function() return 0, 0, 0, .7 end
		self.GetBackdropBorderColor = function() return 0, 0, 0 end

		self.tipStyled = true
	end

	self.bg:SetBackdropBorderColor(0, 0, 0)
	self.bg:SetBackdropColor(0, 0, 0, .6)
	if self.sd then
		self.sd:SetBackdropBorderColor(0, 0, 0, .3)
	end

	if C.tooltip.borderColor and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			if color then
				--self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
				if self.sd then
					self.sd:SetBackdropBorderColor(color.r, color.g, color.b, .3)
				end
			end
		end
	end

	--[[if self.NumLines and self:NumLines() > 0 then
		for index = 1, self:NumLines() do
			if index == 1 then
				_G[self:GetName().."TextLeft"..index]:SetFont(C.font.normal, 14)
			else
				_G[self:GetName().."TextLeft"..index]:SetFont(C.font.normal, 12)
			end
			_G[self:GetName().."TextRight"..index]:SetFont(C.font.normal, 12)
		end
	end]]
end

local function extrastyle(self)
	if not self.styled then
		self:DisableDrawLayer("BACKGROUND")
		style(self)

		self.styled = true
	end
end

hooksecurefunc("GameTooltip_SetBackdropStyle", function(self)
	if not self.tipStyled then return end
	self:SetBackdrop(nil)
end)

GAME_TOOLTIP_BACKDROP_STYLE_AZERITE_ITEM = {}


local function addonStyled(_, addon)
	if addon == "Blizzard_DebugTools" then
		local tooltips = {
			FrameStackTooltip,
			EventTraceTooltip
		}
		for _, tip in pairs(tooltips) do
			tip:SetParent(UIParent)
			tip:SetFrameStrata("TOOLTIP")
			tip:HookScript("OnShow", style)
		end

	elseif addon == "FreeUI" then
		
		local tooltips = {
			ChatMenu,
			EmoteMenu,
			LanguageMenu,
			VoiceMacroMenu,
			GameTooltip,
			EmbeddedItemTooltip,
			ItemRefTooltip,
			ItemRefShoppingTooltip1,
			ItemRefShoppingTooltip2,
			ShoppingTooltip1,
			ShoppingTooltip2,
			AutoCompleteBox,
			FriendsTooltip,
			WorldMapTooltip,
			WorldMapCompareTooltip1,
			WorldMapCompareTooltip2,
			QuestScrollFrame.StoryTooltip,
			GeneralDockManagerOverflowButtonList,
			ReputationParagonTooltip,
			QuestScrollFrame.WarCampaignTooltip,
			NamePlateTooltip,
			LibDBIconTooltip,
		}
		for _, f in pairs(tooltips) do
			if f then
				f:HookScript("OnShow", style)
			end
		end

		local extra = {
			QueueStatusFrame,
			FloatingGarrisonFollowerTooltip,
			FloatingGarrisonFollowerAbilityTooltip,
			FloatingGarrisonMissionTooltip,
			GarrisonFollowerAbilityTooltip,
			GarrisonFollowerTooltip,
			FloatingGarrisonShipyardFollowerTooltip,
			GarrisonShipyardFollowerTooltip,
			BattlePetTooltip,
			PetBattlePrimaryAbilityTooltip,
			PetBattlePrimaryUnitTooltip,
			FloatingBattlePetTooltip,
			FloatingPetBattleAbilityTooltip,
			IMECandidatesFrame
		}
		for _, f in pairs(extra) do
			if f then
				f:HookScript("OnShow", extrastyle)
			end
		end

		-- DropdownMenu
		hooksecurefunc("UIDropDownMenu_CreateFrames", function()
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G["DropDownList"..i.."MenuBackdrop"]
				if menu and not menu.styled then
					menu:HookScript("OnShow", style)
					menu.styled = true
				end

				local menu2 = _G["Lib_DropDownList"..i.."MenuBackdrop"]
				if menu2 and not menu2.styled then
					menu2:HookScript("OnShow", style)
					menu2.styled = true
				end
			end
		end)

		-- IME
		IMECandidatesFrame.selection:SetVertexColor(C.r, C.g, C.b)

		-- Pet Tooltip
		local petTips = {
			PetBattlePrimaryUnitTooltip.Delimiter,
			PetBattlePrimaryUnitTooltip.Delimiter2,
			PetBattlePrimaryAbilityTooltip.Delimiter1,
			PetBattlePrimaryAbilityTooltip.Delimiter2,
			FloatingPetBattleAbilityTooltip.Delimiter1,
			FloatingPetBattleAbilityTooltip.Delimiter2,
			FloatingBattlePetTooltip.Delimiter,
		}
		for _, element in pairs(petTips) do
			element:SetColorTexture(0, 0, 0)
			element:SetHeight(1.2)
		end

		PetBattlePrimaryUnitTooltip:HookScript("OnShow", function(self)
			self.Border:SetAlpha(0)
			if not self.tipStyled then
				if self.glow then self.glow:Hide() end
				self.Icon:SetTexCoord(unpack(C.TexCoord))
				self.tipStyled = true
			end
		end)

		hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", function(self)
			local nextBuff, nextDebuff = 1, 1
			for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
				local _, _, _, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
				if isBuff and self.Buffs then
					local frame = self.Buffs.frames[nextBuff]
					if frame and frame.Icon then
						frame.Icon:SetTexCoord(unpack(C.TexCoord))
					end
					nextBuff = nextBuff + 1
				elseif (not isBuff) and self.Debuffs then
					local frame = self.Debuffs.frames[nextDebuff]
					if frame and frame.Icon then
						frame.DebuffBorder:Hide()
						frame.Icon:SetTexCoord(unpack(C.TexCoord))
					end
					nextDebuff = nextDebuff + 1
				end
			end
		end)

	elseif addon == "Blizzard_Collections" then
		local pet = {
			PetJournalPrimaryAbilityTooltip,
			PetJournalSecondaryAbilityTooltip,
		}
		for _, f in pairs(pet) do
			if f then
				f:HookScript("OnShow", extrastyle)
			end
		end

		PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
		PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
		PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
		PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)

	elseif addon == "Blizzard_GarrisonUI" then
		local gt = {
			GarrisonMissionMechanicTooltip,
			GarrisonMissionMechanicFollowerCounterTooltip,
			GarrisonShipyardMapMissionTooltip,
			GarrisonBonusAreaTooltip,
			GarrisonBuildingFrame.BuildingLevelTooltip,
			GarrisonFollowerAbilityWithoutCountersTooltip,
			GarrisonFollowerMissionAbilityWithoutCountersTooltip
		}
		for _, f in pairs(gt) do
			if f then
				f:HookScript("OnShow", extrastyle)
			end
		end

	elseif addon == "Blizzard_PVPUI" then

		ConquestTooltip:HookScript("OnShow", style)

	elseif addon == "Blizzard_Contribution" then

		ContributionBuffTooltip:HookScript("OnShow", extrastyle)
		ContributionBuffTooltip.Icon:SetTexCoord(unpack(C.TexCoord))
		ContributionBuffTooltip.Border:SetAlpha(0)

	elseif addon == "Blizzard_EncounterJournal" then

		EncounterJournalTooltip:HookScript("OnShow", style)
		EncounterJournalTooltip.Item1.icon:SetTexCoord(unpack(C.TexCoord))
		EncounterJournalTooltip.Item2.icon:SetTexCoord(unpack(C.TexCoord))

	elseif addon == "Blizzard_Calendar" then
		local gt = {
			CalendarContextMenu,
			CalendarInviteStatusContextMenu,
		}
		for _, f in pairs(gt) do
			if f then
				f:HookScript("OnShow", style)
			end
		end

	elseif addon == "Blizzard_IslandsQueueUI" then

		local tip = IslandsQueueFrameTooltip
		tip:GetParent():GetParent():HookScript("OnShow", style)
		tip:GetParent().IconBorder:SetAlpha(0)
		tip:GetParent().Icon:SetTexCoord(.08, .92, .08, .92)
	end
end

F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
F.ReskinClose(FloatingGarrisonMissionTooltip.CloseButton)

F:RegisterEvent("ADDON_LOADED", addonStyled)

-- Position
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	if C.tooltip.anchorCursor then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
	else
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint(unpack(C.tooltip.tipPosition))
	end
end)

