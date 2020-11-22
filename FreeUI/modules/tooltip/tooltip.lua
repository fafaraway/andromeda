local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('TOOLTIP')


local wipe, tinsert, tconcat = table.wipe, table.insert, table.concat
local IsInGroup, IsInRaid, GetNumGroupMembers = IsInGroup, IsInRaid, GetNumGroupMembers
local UnitExists, UnitIsUnit, UnitIsDeadOrGhost, UnitName = UnitExists, UnitIsUnit, UnitIsDeadOrGhost, UnitName
local strfind, format, strupper, strlen, pairs, unpack = string.find, string.format, string.upper, string.len, pairs, unpack
local ICON_LIST = ICON_LIST
local PVP, LEVEL, FACTION_HORDE, FACTION_ALLIANCE = PVP, LEVEL, FACTION_HORDE, FACTION_ALLIANCE
local YOU, TARGET, AFK, DND, DEAD, PLAYER_OFFLINE = YOU, TARGET, AFK, DND, DEAD, PLAYER_OFFLINE
local FOREIGN_SERVER_LABEL, INTERACTIVE_SERVER_LABEL = FOREIGN_SERVER_LABEL, INTERACTIVE_SERVER_LABEL
local LE_REALM_RELATION_COALESCED, LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_COALESCED, LE_REALM_RELATION_VIRTUAL
local UnitIsPVP, UnitFactionGroup, UnitRealmRelationship = UnitIsPVP, UnitFactionGroup, UnitRealmRelationship
local UnitIsConnected, UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND = UnitIsConnected, UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND
local InCombatLockdown, IsShiftKeyDown, GetMouseFocus, GetItemInfo = InCombatLockdown, IsShiftKeyDown, GetMouseFocus, GetItemInfo
local GetCreatureDifficultyColor, UnitCreatureType, UnitClassification = GetCreatureDifficultyColor, UnitCreatureType, UnitClassification
local UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel = UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel
local UnitIsPlayer, UnitName, UnitPVPName, UnitClass, UnitRace, UnitLevel = UnitIsPlayer, UnitName, UnitPVPName, UnitClass, UnitRace, UnitLevel
local GetRaidTargetIndex, UnitGroupRolesAssigned, GetGuildInfo, IsInGuild = GetRaidTargetIndex, UnitGroupRolesAssigned, GetGuildInfo, IsInGuild
local C_PetBattles_GetNumAuras, C_PetBattles_GetAuraInfo = C_PetBattles.GetNumAuras, C_PetBattles.GetAuraInfo

local targetTable = {}

local classification = {
	elite = ' |cffcc8800'..ELITE..'|r',
	rare = ' |cffff99cc'..L['TOOLTIP_RARE']..'|r',
	rareelite = ' |cffff99cc'..L['TOOLTIP_RARE']..'|r '..'|cffcc8800'..ELITE..'|r',
	worldboss = ' |cffff0000'..BOSS..'|r',
}

function TOOLTIP:GetUnit()
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute('unit'))) or 'mouseover'
	end
	return unit
end

function TOOLTIP:HideLines()
	for i = 3, self:NumLines() do
		local tiptext = _G['GameTooltipTextLeft'..i]
		local linetext = tiptext:GetText()
		if linetext then
			if linetext == PVP then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif linetext == FACTION_HORDE then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif linetext == FACTION_ALLIANCE then
				tiptext:SetText(nil)
				tiptext:Hide()
			end
		end
	end
end

function TOOLTIP:GetLevelLine()
	for i = 2, self:NumLines() do
		local tiptext = _G['GameTooltipTextLeft'..i]
		local linetext = tiptext:GetText()
		if linetext and strfind(linetext, LEVEL) then
			return tiptext
		end
	end
end

function TOOLTIP:GetTarget(unit)
	if UnitIsUnit(unit, 'player') then
		return format('|cffff0000%s|r', '>'..strupper(YOU)..'<')
	else
		return F.RGBToHex(F.UnitColor(unit))..UnitName(unit)..'|r'
	end
end

function TOOLTIP:OnTooltipSetUnit()
	if self:IsForbidden() then return end
	if C.DB.tooltip.hide_in_combat and InCombatLockdown() then self:Hide() return end

	TOOLTIP.HideLines(self)

	local unit = TOOLTIP.GetUnit(self)
	local isShiftKeyDown = IsShiftKeyDown()
	if UnitExists(unit) then
		local hexColor = F.RGBToHex(F.UnitColor(unit))
		local ricon = GetRaidTargetIndex(unit)
		local text = GameTooltipTextLeft1:GetText()
		if ricon and ricon > 8 then ricon = nil end
		if ricon and text then
			GameTooltipTextLeft1:SetFormattedText(('%s %s'), ICON_LIST[ricon]..'18|t', text)
		end

		local isPlayer = UnitIsPlayer(unit)
		if isPlayer then
			local name, realm = UnitName(unit)
			local pvpName = UnitPVPName(unit)
			local relationship = UnitRealmRelationship(unit)
			if not C.DB.tooltip.hide_title and pvpName then
				name = pvpName
			end
			if realm and realm ~= '' then
				if isShiftKeyDown or not C.DB.tooltip.hide_realm then
					name = name..'-'..realm
				elseif relationship == LE_REALM_RELATION_COALESCED then
					name = name..FOREIGN_SERVER_LABEL
				elseif relationship == LE_REALM_RELATION_VIRTUAL then
					name = name..INTERACTIVE_SERVER_LABEL
				end
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				status = format(' |cffffcc00[%s]|r', status)
			end
			GameTooltipTextLeft1:SetFormattedText('%s', name..(status or ''))

			local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
			local hasText = GameTooltipTextLeft2:GetText()
			if guildName and hasText then
				local myGuild, _, _, myGuildRealm = GetGuildInfo('player')
				if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
					GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
				else
					GameTooltipTextLeft2:SetTextColor(.6, .8, 1)
				end

				rankIndex = rankIndex + 1
				if C.DB.tooltip.hide_rank then rank = '' end
				if guildRealm and isShiftKeyDown then
					guildName = guildName..'-'..guildRealm
				end
				--[[ if cfg.hideJunkGuild and not isShiftKeyDown then
					if strlen(guildName) > 31 then guildName = '...' end
				end ]]
				GameTooltipTextLeft2:SetText('<'..guildName..'> '..rank)
			end
		end

		local line1 = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText('%s', hexColor..line1)

		local alive = not UnitIsDeadOrGhost(unit)
		local level
		if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
			level = UnitBattlePetLevel(unit)
		else
			level = UnitLevel(unit)
		end

		if level then
			local boss
			if level == -1 then boss = '|cffff0000??|r' end

			local diff = GetCreatureDifficultyColor(level)
			local classify = UnitClassification(unit)
			local textLevel = format('%s%s%s|r', F.RGBToHex(diff), boss or format('%d', level), classification[classify] or '')
			local tiptextLevel = TOOLTIP.GetLevelLine(self)
			if tiptextLevel then
				local pvpFlag = isPlayer and UnitIsPVP(unit) and format(' |cffff0000%s|r', PVP) or ''
				local unitClass = isPlayer and format('%s %s', UnitRace(unit) or '', hexColor..(UnitClass(unit) or '')..'|r') or UnitCreatureType(unit) or ''
				tiptextLevel:SetFormattedText(('%s%s %s %s'), textLevel, pvpFlag, unitClass, (not alive and '|cffCCCCCC'..DEAD..'|r' or ''))
			end
		end

		if UnitExists(unit..'target') then
			local tarRicon = GetRaidTargetIndex(unit..'target')
			if tarRicon and tarRicon > 8 then tarRicon = nil end
			local tar = format('%s%s', (tarRicon and ICON_LIST[tarRicon]..'10|t') or '', TOOLTIP:GetTarget(unit..'target'))
			self:AddLine(TARGET..': '..tar)
		end

		if alive then
			self.StatusBar:SetStatusBarColor(F.UnitColor(unit))
		else
			self.StatusBar:Hide()
		end
	else
		self.StatusBar:SetStatusBarColor(0, .9, 0)
	end

	TOOLTIP.InspectUnitSpecAndLevel(self)
end

function TOOLTIP:ReskinStatusBar()
	self.StatusBar:ClearAllPoints()
	self.StatusBar:SetPoint('BOTTOMLEFT', GameTooltip, 'TOPLEFT', 1, -4)
	self.StatusBar:SetPoint('BOTTOMRIGHT', GameTooltip, 'TOPRIGHT', -1, -4)
	self.StatusBar:SetStatusBarTexture(C.Assets.norm_tex)
	self.StatusBar:SetHeight(3)
	F.SetBD(self.StatusBar)
end

function TOOLTIP:GameTooltip_ShowStatusBar()
	if not self or self:IsForbidden() then return end
	if not self.statusBarPool then return end

	local bar = self.statusBarPool:GetNextActive()
	if bar and not bar.styled then
		F.StripTextures(bar)
		F.CreateBDFrame(bar, .25)
		bar:SetStatusBarTexture(C.Assets.norm_tex)

		bar.styled = true
	end
end

function TOOLTIP:GameTooltip_ShowProgressBar()
	if not self or self:IsForbidden() then return end
	if not self.progressBarPool then return end

	local bar = self.progressBarPool:GetNextActive()
	if bar and not bar.styled then
		F.StripTextures(bar.Bar)
		F.CreateBDFrame(bar.Bar, .25)
		bar.Bar:SetStatusBarTexture(C.Assets.norm_tex)

		bar.styled = true
	end
end

function TOOLTIP:ScanTargets()
	if not C.DB.tooltip.target_by then return end
	if not IsInGroup() then return end

	local _, unit = self:GetUnit()
	if not UnitExists(unit) then return end

	wipe(targetTable)

	for i = 1, GetNumGroupMembers() do
		local member = (IsInRaid() and 'raid'..i or 'party'..i)
		if UnitIsUnit(unit, member..'target') and not UnitIsUnit('player', member) and not UnitIsDeadOrGhost(member) then
			local color = F.RGBToHex(F.UnitColor(member))
			local name = color..UnitName(member)..'|r'
			tinsert(targetTable, name)
		end
	end

	if #targetTable > 0 then
		GameTooltip:AddLine(L['TOOLTIP_TARGETED']..C.InfoColor..'('..#targetTable..')|r '..tconcat(targetTable, ', '), nil, nil, nil, 1)
	end
end

function TOOLTIP:TargetedInfo()
	if not C.DB.tooltip.target_by then return end

	GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.ScanTargets)
end


local mover
function TOOLTIP:GameTooltip_SetDefaultAnchor(parent)
	if self:IsForbidden() then return end
	if not parent then return end

	if C.DB.tooltip.follow_cursor then
		self:SetOwner(parent, 'ANCHOR_CURSOR_RIGHT')
	else
		if not mover then
			mover = F.Mover(self, L['TOOLTIP_MOVER'], 'GameTooltip', {'BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -C.UIGap, 260}, 240, 120)
		end
		self:SetOwner(parent, 'ANCHOR_NONE')
		self:ClearAllPoints()
		self:SetPoint('BOTTOMRIGHT', mover)
	end
end

-- Fix comparison error on cursor
function TOOLTIP:GameTooltip_ComparisonFix(anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
	local point = shoppingTooltip1:GetPoint(2)
	if secondaryItemShown then
		if point == 'TOP' then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint('TOPLEFT', anchorFrame, 'TOPRIGHT', 4, 0)
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip2:SetPoint('TOPLEFT', shoppingTooltip1, 'TOPRIGHT', 4, 0)
		elseif point == 'RIGHT' then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint('TOPRIGHT', anchorFrame, 'TOPLEFT', -4, 0)
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip2:SetPoint('TOPRIGHT', shoppingTooltip1, 'TOPLEFT', -4, 0)
		end
	else
		if point == 'LEFT' then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint('TOPLEFT', anchorFrame, 'TOPRIGHT', 4, 0)
		elseif point == 'RIGHT' then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint('TOPRIGHT', anchorFrame, 'TOPLEFT', -4, 0)
		end
	end
end


-- Tooltip skin
local fakeBg = CreateFrame('Frame', nil, UIParent, 'BackdropTemplate')
fakeBg:SetBackdrop({ bgFile = C.Assets.bd_tex, edgeFile = C.Assets.bd_tex, edgeSize = 1 })
local function __GetBackdrop() return fakeBg:GetBackdrop() end
local function __GetBackdropColor() return C.BackdropColor[1], C.BackdropColor[2], C.BackdropColor[3], .65 end
local function __GetBackdropBorderColor() return 0, 0, 0 end

function TOOLTIP:ReskinTooltip()
	if not self then
		if C.isDeveloper then F.Print('Unknown tooltip spotted.') end
		return
	end
	if self:IsForbidden() then return end
	self:SetScale(1)

	if not self.tipStyled then
		if self.SetBackdrop then self:SetBackdrop(nil) end
		self:DisableDrawLayer('BACKGROUND')
		self.bg = F.SetBD(self)
		self.bg:SetInside(self)
		self.bg:SetFrameLevel(self:GetFrameLevel())

		if self.StatusBar then
			TOOLTIP.ReskinStatusBar(self)
		end

		if self.GetBackdrop then
			self.GetBackdrop = __GetBackdrop
			self.GetBackdropColor = __GetBackdropColor
			self.GetBackdropBorderColor = __GetBackdropBorderColor
		end

		self.tipStyled = true
	end

	self.bg:SetBackdropColor(C.BackdropColor[1], C.BackdropColor[2], C.BackdropColor[3], .65)
	self.bg:SetBackdropBorderColor(0, 0, 0, 1)
	if self.bg.__shadow then
		self.bg.__shadow:SetBackdropBorderColor(0, 0, 0, .25)
	end

	if C.DB.tooltip.border_color and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local color = C.QualityColors[quality or 1]
			if color then
				self.bg:SetBackdropBorderColor(color.r, color.g, color.b, .6)
				if self.bg.__shadow then
					self.bg.__shadow:SetBackdropBorderColor(color.r, color.g, color.b, .25)
				end
			end
		end
	end
end

function TOOLTIP:SharedTooltip_SetBackdropStyle()
	if not self.tipStyled then return end
	self:SetBackdrop(nil)
end

local function TooltipSetFont(obj, font, size)
	obj:SetFont(font, size)
	obj:SetShadowColor(0, 0, 0, 1)
	obj:SetShadowOffset(1, -1)
end

function TOOLTIP:SetTooltipFonts()
	local textSize = 14
	local headerSize = 16

	TooltipSetFont(GameTooltipHeaderText, C.Assets.Fonts.Bold, headerSize)
	TooltipSetFont(GameTooltipText, C.Assets.Fonts.Regular, textSize)
	TooltipSetFont(GameTooltipTextSmall, C.Assets.Fonts.Regular, textSize)
	if GameTooltip.hasMoney then
		for i = 1, GameTooltip.numMoneyFrames do
			TooltipSetFont(_G['GameTooltipMoneyFrame'..i..'PrefixText'], C.Assets.Fonts.Regular, textSize)
			TooltipSetFont(_G['GameTooltipMoneyFrame'..i..'SuffixText'], C.Assets.Fonts.Regular, textSize)
			TooltipSetFont(_G['GameTooltipMoneyFrame'..i..'GoldButtonText'], C.Assets.Fonts.Regular, textSize)
			TooltipSetFont(_G['GameTooltipMoneyFrame'..i..'SilverButtonText'], C.Assets.Fonts.Regular, textSize)
			TooltipSetFont(_G['GameTooltipMoneyFrame'..i..'CopperButtonText'], C.Assets.Fonts.Regular, textSize)
		end
	end

	for _, tt in ipairs(GameTooltip.shoppingTooltips) do
		for i = 1, tt:GetNumRegions() do
			local region = select(i, tt:GetRegions())
			if region:IsObjectType('FontString') then
				TooltipSetFont(region, C.Assets.Fonts.Regular, textSize)
			end
		end
	end
end


function TOOLTIP:OnLogin()
	if not C.DB.tooltip.enable then return end

	GameTooltip.StatusBar = GameTooltipStatusBar

	local ssbc = CreateFrame('StatusBar').SetStatusBarColor
	GameTooltipStatusBar._SetStatusBarColor = ssbc
	function GameTooltipStatusBar:SetStatusBarColor(...)
		local unit = TOOLTIP.GetUnit(GameTooltip)
		if(UnitExists(unit)) then
			return self:_SetStatusBarColor(F.UnitColor(unit))
		end
	end

	GameTooltip:HookScript('OnTooltipSetUnit', TOOLTIP.OnTooltipSetUnit)
	hooksecurefunc('GameTooltip_ShowStatusBar', TOOLTIP.GameTooltip_ShowStatusBar)
	hooksecurefunc('GameTooltip_ShowProgressBar', TOOLTIP.GameTooltip_ShowProgressBar)
	hooksecurefunc('GameTooltip_SetDefaultAnchor', TOOLTIP.GameTooltip_SetDefaultAnchor)
	hooksecurefunc('SharedTooltip_SetBackdropStyle', TOOLTIP.SharedTooltip_SetBackdropStyle)
	hooksecurefunc('GameTooltip_AnchorComparisonTooltips', TOOLTIP.GameTooltip_ComparisonFix)

	TOOLTIP:SetTooltipFonts()
	TOOLTIP:ReskinTooltipIcons()
	TOOLTIP:LinkHover()
	TOOLTIP:ExtraInfo()
	TOOLTIP:TargetedInfo()
	TOOLTIP:AzeriteArmor()
	TOOLTIP:ConduitCollectionData()
end


-- Tooltip Skin Registration
local tipTable = {}
function TOOLTIP:RegisterTooltips(addon, func)
	tipTable[addon] = func
end
local function addonStyled(_, addon)
	if tipTable[addon] then
		tipTable[addon]()
		tipTable[addon] = nil
	end
end
F:RegisterEvent('ADDON_LOADED', addonStyled)

TOOLTIP:RegisterTooltips('FreeUI', function()
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
		QuestScrollFrame.StoryTooltip,
		QuestScrollFrame.CampaignTooltip,
		GeneralDockManagerOverflowButtonList,
		ReputationParagonTooltip,
		NamePlateTooltip,
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
		IMECandidatesFrame,
		QuickKeybindTooltip
	}
	for _, f in pairs(tooltips) do
		f:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	end

	-- DropdownMenu
	local function reskinDropdown()
		for _, name in pairs({'DropDownList', 'L_DropDownList', 'Lib_DropDownList'}) do
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G[name..i..'MenuBackdrop']
				if menu and not menu.styled then
					menu:HookScript('OnShow', TOOLTIP.ReskinTooltip)
					menu.styled = true
				end
			end
		end
	end
	hooksecurefunc('UIDropDownMenu_CreateFrames', reskinDropdown)

	-- IME
	IMECandidatesFrame.selection:SetVertexColor(C.r, C.g, C.b)

	-- Pet Tooltip
	PetBattlePrimaryUnitTooltip:HookScript('OnShow', function(self)
		self.Border:SetAlpha(0)
		if not self.iconStyled then
			if self.glow then self.glow:Hide() end
			self.Icon:SetTexCoord(unpack(C.TexCoord))
			self.iconStyled = true
		end
	end)

	hooksecurefunc('PetBattleUnitTooltip_UpdateForUnit', function(self)
		local nextBuff, nextDebuff = 1, 1
		for i = 1, C_PetBattles_GetNumAuras(self.petOwner, self.petIndex) do
			local _, _, _, isBuff = C_PetBattles_GetAuraInfo(self.petOwner, self.petIndex, i)
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

	-- Others
	C_Timer.After(5, function()
		-- BagSync
		if BSYC_EventAlertTooltip then
			TOOLTIP.ReskinTooltip(BSYC_EventAlertTooltip)
		end
		-- Lib
		if LibDBIconTooltip then
			TOOLTIP.ReskinTooltip(LibDBIconTooltip)
		end
		if AceConfigDialogTooltip then
			TOOLTIP.ReskinTooltip(AceConfigDialogTooltip)
		end
		-- TomTom
		if TomTomTooltip then
			TOOLTIP.ReskinTooltip(TomTomTooltip)
		end
		-- RareScanner
		if RSMapItemToolTip then
			TOOLTIP.ReskinTooltip(RSMapItemToolTip)
		end
		if LootBarToolTip then
			TOOLTIP.ReskinTooltip(LootBarToolTip)
		end

		-- Narcissus
		if NarciGameTooltip then
			TOOLTIP.ReskinTooltip(NarciGameTooltip)
		end
	end)

	if IsAddOnLoaded('BattlePetBreedID') then
		hooksecurefunc('BPBID_SetBreedTooltip', function(parent)
			if parent == FloatingBattlePetTooltip then
				TOOLTIP.ReskinTooltip(BPBID_BreedTooltip2)
			else
				TOOLTIP.ReskinTooltip(BPBID_BreedTooltip)
			end
		end)
	end

	if IsAddOnLoaded('MythicDungeonTools') then
		local styledMDT
		hooksecurefunc(MDT, 'ShowInterface', function()
			if not styledMDT then
				TOOLTIP.ReskinTooltip(MDT.tooltip)
				TOOLTIP.ReskinTooltip(MDT.pullTooltip)
				styledMDT = true
			end
		end)
	end
end)

TOOLTIP:RegisterTooltips('Blizzard_DebugTools', function()
	TOOLTIP.ReskinTooltip(FrameStackTooltip)
	TOOLTIP.ReskinTooltip(EventTraceTooltip)
	FrameStackTooltip:SetScale(UIParent:GetScale())
	EventTraceTooltip:SetParent(UIParent)
	EventTraceTooltip:SetFrameStrata('TOOLTIP')
end)

TOOLTIP:RegisterTooltips('Blizzard_Collections', function()
	PetJournalPrimaryAbilityTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	PetJournalSecondaryAbilityTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
end)

TOOLTIP:RegisterTooltips('Blizzard_GarrisonUI', function()
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
		f:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	end
end)

TOOLTIP:RegisterTooltips('Blizzard_PVPUI', function()
	ConquestTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
end)

TOOLTIP:RegisterTooltips('Blizzard_Contribution', function()
	ContributionBuffTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	ContributionBuffTooltip.Icon:SetTexCoord(unpack(C.TexCoord))
	ContributionBuffTooltip.Border:SetAlpha(0)
end)

TOOLTIP:RegisterTooltips('Blizzard_EncounterJournal', function()
	EncounterJournalTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	EncounterJournalTooltip.Item1.icon:SetTexCoord(unpack(C.TexCoord))
	EncounterJournalTooltip.Item1.IconBorder:SetAlpha(0)
	EncounterJournalTooltip.Item2.icon:SetTexCoord(unpack(C.TexCoord))
	EncounterJournalTooltip.Item2.IconBorder:SetAlpha(0)
end)

TOOLTIP:RegisterTooltips('Blizzard_Calendar', function()
	CalendarContextMenu:HookScript('OnShow', TOOLTIP.ReskinTooltip)
	CalendarInviteStatusContextMenu:HookScript('OnShow', TOOLTIP.ReskinTooltip)
end)

TOOLTIP:RegisterTooltips('Blizzard_IslandsQueueUI', function()
	local tooltip = IslandsQueueFrameTooltip:GetParent()
	tooltip.IconBorder:SetAlpha(0)
	tooltip.Icon:SetTexCoord(unpack(C.TexCoord))
	tooltip:GetParent():HookScript('OnShow', TOOLTIP.ReskinTooltip)
end)
