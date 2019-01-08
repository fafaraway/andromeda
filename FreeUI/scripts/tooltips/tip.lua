local F, C, L = unpack(select(2, ...))
if not C.tooltip.enable then return end
local module = F:RegisterModule("tooltip")

function module:OnLogin()
	self:extraInfo()
	self:azeriteTrait()
end




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

	if GameTooltipStatusBar:IsShown() then
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltipStatusBar:GetParent(), "TOPLEFT", 1, -3)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar:GetParent(), "TOPRIGHT", -1, -3)
		if C.Mult and not GameTooltipStatusBar.bg then
			GameTooltipStatusBar:SetStatusBarTexture(C.media.sbTex)
			GameTooltipStatusBar:SetHeight(2)
			local bg = F.CreateBG(GameTooltipStatusBar)
			--F.CreateBD(bg, .7)
			F.CreateTex(bg)
			GameTooltipStatusBar.bg = bg
		end
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

hooksecurefunc("GameTooltip_ShowStatusBar", function(self)
	if self.statusBarPool then
		local bar = self.statusBarPool:Acquire()
		if bar and not bar.styled then
			local _, bd, tex = bar:GetRegions()
			tex:SetTexture(C.media.sbTex)
			bd:Hide()
			local bg = F.CreateBDFrame(bd)

			bar.styled = true
		end
	end
end)

-- world quest progress bar
hooksecurefunc("GameTooltip_ShowProgressBar", function(self)
	if self.progressBarPool then
		local bar = self.progressBarPool:Acquire()
		if bar and not bar.styled then
			F.StripTextures(bar.Bar, true)
			bar.Bar:SetStatusBarTexture(C.media.sbTex)
			F.CreateBD(bar, .25)
			bar:SetSize(216, 18)
			F.SetFS(bar.Bar.Label)

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

