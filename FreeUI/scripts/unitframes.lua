local F, C, L = unpack(select(2, ...))

if not C.unitframes.enable then return end

local parent, ns = ...
local oUF = ns.oUF

local name = UnitName("player")
local realm = GetRealmName()
local class = select(2, UnitClass("player"))
local locale = GetLocale()

local unitframeFont = {
		C.font.normal,
		12,
		"OUTLINE"
	}

local powerHeight = C.unitframes.power_height
local altPowerHeight = C.unitframes.altpower_height
local classPowerHeight = C.unitframes.classPower_height
local playerWidth = C.unitframes.player_width
local playerHeight = C.unitframes.player_height
local targetWidth = C.unitframes.target_width
local targetHeight = C.unitframes.target_height
local targettargetWidth = C.unitframes.targettarget_width
local targettargetHeight = C.unitframes.targettarget_height
local focusWidth = C.unitframes.focus_width
local focusHeight = C.unitframes.focus_height
local focustargetWidth = C.unitframes.focustarget_width
local focustargetHeight = C.unitframes.focustarget_height
local petWidth = C.unitframes.pet_width
local petHeight = C.unitframes.pet_height
local bossWidth = C.unitframes.boss_width
local bossHeight = C.unitframes.boss_height
local arenaWidth = C.unitframes.arena_width
local arenaHeight = C.unitframes.arena_height
local partyWidth = C.unitframes.party_width
local partyHeight = C.unitframes.party_height
local partyWidthHealer = C.unitframes.party_width_healer
local partyHeightHealer = C.unitframes.party_height_healer
local raidWidth = C.unitframes.raid_width
local raidHeight = C.unitframes.raid_height

local CBinterrupt = C.unitframes.castbarColorInterrupt
local CBnormal = C.unitframes.castbarColorNormal

-- [[ Initialize / load layout option ]]

-- this can't use the normal options system
-- because we want users to be able to switch layout using /commands even when options gui is disabled
local addonLoaded
addonLoaded = function(_, addon)
	if addon ~= "FreeUI" then return end

	F.UnregisterEvent("ADDON_LOADED", addonLoaded)
	addonLoaded = nil
end

F.RegisterEvent("ADDON_LOADED", addonLoaded)

--[[ Short values ]]

local siValue = function(val)
	if(val >= 1e6) then
		return format("%.2fm", val * 0.000001)
	elseif(val >= 1e4) then
		return format("%.1fk", val * 0.001)
	else
		return val
	end
end

local function hex(r, g, b)
	if not r then return '|cffFFFFFF' end
	if(type(r) == 'table') then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

-- [[ Smooth ]]

local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local smoother, min, max = CreateFrame('Frame'), math.min, math.max
smoother:SetScript('OnUpdate', function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)

-- [[ Update resurrection/selection name colour ]]

local updateNameColour = function(self, unit)
	if UnitIsUnit(unit, "target") then
		self.Text:SetTextColor(.1, .7, 1)
	elseif UnitIsDead(unit) then
		self.Text:SetTextColor(.7, .2, .1)
	else
		self.Text:SetTextColor(1, 1, 1)
	end
end

-- to use on child frame
local updateNameColourAlt = function(self)
	local frame = self:GetParent()
	if frame.unit then
		if UnitIsUnit(frame.unit, "target") then
			frame.Text:SetTextColor(.1, .7, 1)
		elseif UnitIsDead(frame.unit) then
			frame.Text:SetTextColor(.7, .2, .1)
		else
			frame.Text:SetTextColor(1, 1, 1)
		end
	else
		frame.Text:SetTextColor(1, 1, 1)
	end
end

--[[ Tags ]]

oUF.Tags.Methods['free:playerHealth'] = function(unit)
	if UnitIsDead(unit) or UnitIsGhost(unit) then return end

	return siValue(UnitHealth(unit))
end
oUF.Tags.Events['free:playerHealth'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['free:health'] = function(unit)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)

	return format("|cffffffff%s|r %.0f", siValue(min), (min/max)*100)
end
oUF.Tags.Events['free:health'] = oUF.Tags.Events.missinghp

-- boss health requires frequent updates to work
oUF.Tags.Methods['free:bosshealth'] = function(unit)
	local val = oUF.Tags.Methods['free:health'](unit)
	return val or ""
end
oUF.Tags.Events['free:bosshealth'] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_TARGETABLE_CHANGED"

-- utf8 short string

local function usub(str, len)
	local i = 1
	local n = 0
	while true do
		local b,e = string.find(str, "([%z\1-\127\194-\244][\128-\191]*)", i)
		if(b == nil) then
			return str
		end
		i = e + 1
		n = n + 1
		if(n > len) then
			local r = string.sub(str, 1, b-1)
			return r
		end
	end
end

local function getSummary(str)
	local t = string.gsub(str, "<.->", "")
	return usub(t, 100, "...")
end

local function shortName(unit)
	local name = UnitName(unit)
	if name and name:len() > 4 then name = usub(name, 4) end

	return name
end

oUF.Tags.Methods['free:name'] = function(unit)
	if not UnitIsConnected(unit) then
		return "Off"
	elseif UnitIsDead(unit) then
		return "Dead"
	elseif UnitIsGhost(unit) then
		return "Ghost"
	else
		return shortName(unit)
	end
end
oUF.Tags.Events['free:name'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['free:missinghealth'] = function(unit)
	local min, max = UnitHealth(unit), UnitHealthMax(unit)

	if not UnitIsConnected(unit) then
		return "Off"
	elseif UnitIsDead(unit) then
		return "Dead"
	elseif UnitIsGhost(unit) then
		return "Ghost"
	elseif min ~= max then
		return siValue(max-min)
	end
end
oUF.Tags.Events['free:missinghealth'] = oUF.Tags.Events.missinghp

oUF.Tags.Methods['free:power'] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	if(min == 0 or max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit)) then return end

	return siValue(min)
end
oUF.Tags.Events['free:power'] = oUF.Tags.Events.missingpp


--[[ Update health ]]

local PostUpdateHealth = function(Health, unit, min, max)
	local self = Health:GetParent()
	local r, g, b
	local reaction = C.reactioncolours[UnitReaction(unit, "player") or 5]

	local offline = not UnitIsConnected(unit)
	local tapped = not UnitPlayerControlled(unit) and UnitIsTapDenied(unit)

	if tapped or offline then
		r, g, b = .6, .6, .6
	elseif unit == "pet" then
		local _, class = UnitClass("player")
		r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b
	elseif UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		if class then r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b else r, g, b = 1, 1, 1 end
	-- elseif unit:find("boss%d") then
	-- 	r, g, b = self.ColorGradient(min, max, unpack(self.colors.smooth))
	else
		r, g, b = unpack(reaction)
	end

	if unit == "target" or unit:find("arena") then
		Health.value:SetTextColor(unpack(reaction))
	end

	if C.unitframes.transMode then
		if offline or UnitIsDead(unit) or UnitIsGhost(unit) then
			self.Healthdef:Hide()
		else
			self.Healthdef:SetMinMaxValues(0, max)
			self.Healthdef:SetValue(max-min)

			if UnitIsPlayer(unit) then
				if C.unitframes.healthClassColor then
					self.Healthdef:GetStatusBarTexture():SetVertexColor(r, g, b)
				else
					self.Healthdef:GetStatusBarTexture():SetVertexColor(.63, 0, 0)
				end
			else
				self.Healthdef:GetStatusBarTexture():SetVertexColor(unpack(reaction))
			end

			self.Healthdef:Show()
		end

		if tapped or offline then
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha("VERTICAL", .6, .6, .6, .6, .4, .4, .4, .6)
			else
				self.gradient:SetGradientAlpha("VERTICAL", .6, .6, .6, .6, .6, .6, .6, .6)
			end
		else
			if C.unitframes.gradient then
				self.gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
			else
				self.gradient:SetGradientAlpha("VERTICAL", .1, .1, .1, .6, .1, .1, .1, .6)
			end
		end

		if self.Text then
			updateNameColour(self, unit)
		end
	else
		if UnitIsDead(unit) or UnitIsGhost(unit) then
			Health:SetValue(0)
		end
		Health:GetStatusBarTexture():SetGradient("VERTICAL", r, g, b, r/2, g/2, b/2)
	end
end

--[[ Update power ]]

local PostUpdatePower = function(Power, unit, cur, max, min)
	local Health = Power:GetParent().Health
	local self = Power:GetParent()
	if max == 0 or not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		Power:SetValue(0)
	end

	if Power.Text then
		Power.Text:SetTextColor(Power:GetStatusBarColor())
	end
end




--[[ Debuff highlight ]]

--[[local PostUpdateIcon = function(_, unit, icon, index, _, filter)
	local _, _, _, _, dtype = UnitAura(unit, index, icon.filter)
	local texture = icon.icon
	
	-- if icon.isDebuff and dtype and UnitIsFriend("player", unit) then
	if icon.isDebuff then
		icon.bg:SetVertexColor(.8, .1, .2)

		if dtype then
			local color = DebuffTypeColor[dtype]
			icon.bg:SetVertexColor(color.r, color.g, color.b)
		end
		
	else
		icon.bg:SetVertexColor(.9, .9, .8)
	end
	-- if icon.isDebuff and not icon.isPlayer and unit ~= "player" then
	if icon.isDebuff and not icon.isPlayer then
		texture:SetDesaturated(true)
	else
		texture:SetDesaturated(false)
	end
end]]

local function PostCreateIcon(element, button)

	local bg = button:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	local sd = CreateFrame("Frame", nil, button)
	sd.size = 4
	sd.offset = -1
	sd:SetBackdrop({
		edgeFile = C.media.glow,
		edgeSize = 4,
	})
	sd:SetPoint("TOPLEFT", button, -sd.size - 0 - sd.offset, sd.size + 0 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", button, sd.size + 0 + sd.offset, -sd.size - 0 - sd.offset)
	sd:SetBackdropBorderColor(.03, .03, .03)
	sd:SetAlpha(.5)

	button.sd = sd
	button.bg = bg
	
	button.overlay:SetTexture(nil)

	button.cd:SetReverse(true)
	button.cd:SetHideCountdownNumbers(true)

	--button.icon:SetTexCoord(.08, .92, .25+.125, .85-.125)
	button.icon:SetDrawLayer('ARTWORK')

	button:SetScript('OnEnter', OnAuraEnter)

	-- We create a parent for aura strings so that they appear over the cooldown widget
	local StringParent = CreateFrame('Frame', nil, button)
	StringParent:SetFrameLevel(20)

	button.count:SetParent(StringParent)
	button.count:ClearAllPoints()
	button.count:SetPoint('TOP', button, 2, -2)

	F.SetFS(button.count)

	local Duration = StringParent:CreateFontString(nil, 'OVERLAY')
	Duration:SetPoint('TOPLEFT', button, 0, -1)
	F.SetFS(Duration)
	button.Duration = Duration



	--button:HookScript('OnUpdate', UpdateAura)
end

local function PostUpdateIcon(element, _, button, _, _, duration, _, debuffType)



	button:SetSize(element.size, element.size*.75)
	button.icon:SetTexCoord(.08, .92, .25+.125, .85-.125)


	if button.isDebuff and element.showDebuffType then
		local color = oUF.colors.debuff[debuffType] or oUF.colors.debuff.none
		button.bg:SetVertexColor(color[1], color[2], color[3])
	else
		button.bg:SetVertexColor(.1, .1, .1)
	end

	if duration then 
		button.sd:Show()
		button.bg:Show()
	end

end

local function PostUpdateGapIcon(_, _, icon)
	if icon.sd and icon.sd:IsShown() then
		icon.sd:Hide()
	end
	if icon.bg and icon.bg:IsShown() then
		icon.bg:Hide()
	end
end


-- [[  Update Portrait ]]

local function PostUpdatePortrait(element, unit)
	-- element:SetModelAlpha(0.1)
	element:SetDesaturation(1)
end

-- [[ Threat update (party) ]]

local UpdateThreat = function(self, event, unit)
	if(unit ~= self.unit) then return end

	local threat = self.Threat

	unit = unit or self.unit
	local status = UnitThreatSituation(unit)

	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self.bd:SetBackdropBorderColor(r, g, b)
	else
		self.bd:SetBackdropBorderColor(0, 0, 0)
	end
end

-- [[ update class power ]]

local function PostUpdateClassPower(element, cur, max, diff, powerType)
	if(diff) then
		for index = 1, max do
			local Bar = element[index]
			local maxWidth, gap = playerWidth, 3
			if(max == 3) then
				Bar:SetWidth(((maxWidth / 3) - ((2 * gap) / 3)))
			elseif(max == 4) then
				Bar:SetWidth(((maxWidth /4) - ((3 * gap) / 4)))
			elseif(max == 5 or max == 10) then
				Bar:SetWidth(((maxWidth / 5) - ((4 * gap) / 5)))
			elseif(max == 6) then
				Bar:SetWidth(((maxWidth / 6) - ((5 * gap) / 6)))
			end

			if(max == 10) then
				-- Rogue anticipation talent, align >5 on top of the first 5
				if(index == 6) then
					Bar:ClearAllPoints()
					Bar:SetPoint('LEFT', element[index - 5])
				end
			else
				if(index > 1) then
					Bar:ClearAllPoints()
					Bar:SetPoint('LEFT', element[index - 1], 'RIGHT', gap, 0)
				end
			end
		end
	end
end

local function UpdateClassPowerColor(element)
	local _, playerClass = UnitClass('player')
	local r, g, b = 1, 1, 2/5
	if(not UnitHasVehicleUI('player')) then
		if(playerClass == 'MONK') then
			r, g, b = 0, 4/5, 3/5
		elseif(playerClass == 'WARLOCK') then
			r, g, b = 2/3, 1/3, 2/3
		elseif(playerClass == 'PALADIN') then
			r, g, b = 1, 1, 2/5
		elseif(playerClass == 'MAGE') then
			r, g, b = 5/6, 1/2, 5/6
		end
	end

	for index = 1, #element do
		local Bar = element[index]
		if(playerClass == 'ROGUE' and UnitPowerMax('player', SPELL_POWER_COMBO_POINTS) == 10 and index > 5) then
			r, g, b = 1, 0, 0
		end

		Bar:SetStatusBarColor(r, g, b)
		Bar.bg:SetColorTexture(r * 1/3, g * 1/3, b * 1/3)
	end
end


--[[ Hide Blizz frames ]]

if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
	CompactRaidFrameManager:SetParent(FreeUIHider)
	CompactUnitFrameProfiles:UnregisterAllEvents()
end

for i = 1, MAX_PARTY_MEMBERS do
	local pet = "PartyMemberFrame"..i.."PetFrame"
	_G[pet]:SetParent(FreeUIHider)
	_G[pet.."HealthBar"]:UnregisterAllEvents()
end


--[[ Global ]]

local Shared = function(self, unit, isSingle)
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")

	self.colors.power.MANA = {100/255, 149/255, 237/255}
	self.colors.power.FURY = { 54/255, 199/255, 63/255 }
	self.colors.power.PAIN = { 255/255, 156/255, 0 }
	self.colors.power.INSANITY = { .4, 0, .8 }

	local bd = CreateFrame("Frame", nil, self)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameStrata("BACKGROUND")

	-- dark border
	if C.unitframes.darkBorder then
		F.CreateSD(bd)
	end

	self.bd = bd

	--[[ Health ]]

	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetFrameStrata("LOW")
	Health:SetStatusBarTexture(C.media.texture)
	Health:SetStatusBarColor(0, 0, 0, 0)

	Health.frequentUpdates = true
	SmoothBar(Health)

	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")
	Health:SetPoint("BOTTOM", 0, 1 + powerHeight)

	self.Health = Health

	--[[ Gradient ]]

	if C.unitframes.transMode then
		local gradient = Health:CreateTexture(nil, "BACKGROUND")
		gradient:SetPoint("TOPLEFT")
		gradient:SetPoint("BOTTOMRIGHT")
		gradient:SetTexture(C.media.backdrop)

		if C.unitframes.gradient then
			gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .1, .1, .1, .6)
		else
			gradient:SetGradientAlpha("VERTICAL", .3, .3, .3, .6, .3, .3, .3, .6)
		end

		self.gradient = gradient

		F.CreateBD(bd, C.unitframes.transModeAlpha)
	else
		F.CreateBD(bd)
	end

	--[[ Health deficit colour ]]

	if C.unitframes.transMode then
		local Healthdef = CreateFrame("StatusBar", nil, self)
		Healthdef:SetFrameStrata("LOW")
		Healthdef:SetAllPoints(Health)
		Healthdef:SetStatusBarTexture(C.media.texture)
		Healthdef:SetStatusBarColor(1, 1, 1)

		Healthdef:SetReverseFill(true)
		SmoothBar(Healthdef)

		self.Healthdef = Healthdef
	end


	--[[ Power ]]

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetStatusBarTexture(C.media.texture)

	Power.frequentUpdates = true
	SmoothBar(Power)

	Power:SetHeight(powerHeight)

	Power:SetPoint("LEFT")
	Power:SetPoint("RIGHT")
	Power:SetPoint("TOP", Health, "BOTTOM", 0, -1)

	self.Power = Power

	local Powertex = Power:CreateTexture(nil, "OVERLAY")
	Powertex:SetHeight(1)
	Powertex:SetPoint("TOPLEFT", 0, 1)
	Powertex:SetPoint("TOPRIGHT", 0, 1)
	Powertex:SetTexture(C.media.backdrop)
	Powertex:SetVertexColor(0, 0, 0)

	Power.bg = Power:CreateTexture(nil, "BACKGROUND")
	Power.bg:SetHeight(powerHeight)
	Power.bg:SetPoint("LEFT")
	Power.bg:SetPoint("RIGHT")
	Power.bg:SetTexture(C.media.backdrop)
	Power.bg:SetVertexColor(0, 0, 0, .1)

	Power.colorReaction = true

	if C.unitframes.transMode then
		if unit == "player" and C.unitframes.powerTypeColor then
			Power.colorPower = true
		else
			Power.colorClass = true
		end
	else
		Power.colorPower = true
	end


	--[[ Alt Power ]]

	if unit == "player" or unit == "pet" then
		local AltPowerBar = CreateFrame("StatusBar", nil, self)
		AltPowerBar:SetWidth(playerWidth)
		AltPowerBar:SetHeight(altPowerHeight)
		AltPowerBar:SetStatusBarTexture(C.media.texture)
		AltPowerBar:SetPoint("BOTTOM", oUF_FreePlayer, 0, -C.unitframes.power_height-3)

		local abd = CreateFrame("Frame", nil, AltPowerBar)
		abd:SetPoint("TOPLEFT", -1, 1)
		abd:SetPoint("BOTTOMRIGHT", 1, -1)
		abd:SetFrameLevel(AltPowerBar:GetFrameLevel()-1)
		F.CreateBD(abd, .5)

		AltPowerBar.Text = F.CreateFS(AltPowerBar, C.FONT_SIZE_NORMAL, "RIGHT")
		AltPowerBar.Text:SetPoint("BOTTOM", oUF_FreePlayer, "TOP", 0, 3)

		AltPowerBar:SetScript("OnValueChanged", function(_, value)
			local min, max = AltPowerBar:GetMinMaxValues()
			local r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))
			AltPowerBar:SetStatusBarColor(r, g, b)
			AltPowerBar.Text:SetTextColor(r, g, b)
		end)

		AltPowerBar.PostUpdate = function(_, _, cur)
			AltPowerBar.Text:SetText(cur)
		end

		SmoothBar(AltPowerBar)

		AltPowerBar:EnableMouse(true)


		self.AlternativePower = AltPowerBar		

	end

	--[[ Portrait ]]

	if C.unitframes.portrait then
		local Portrait = CreateFrame('PlayerModel', nil, self)
		Portrait:SetAllPoints(Health)
		Portrait:SetFrameLevel(Health:GetFrameLevel() - 1)
		Portrait:SetAlpha(.1)
		Portrait.PostUpdate = PostUpdatePortrait
		self.Portrait = Portrait
	end

	--[[ Castbar ]]

	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(C.media.backdrop)
	Castbar:SetStatusBarColor(0, 0, 0, 0)

	local Spark = Castbar:CreateTexture(nil, "OVERLAY")
	Spark:SetBlendMode("ADD")
	Spark:SetWidth(16)
	Castbar.Spark = Spark

	self.Castbar = Castbar

	local PostCastStart = function(Castbar, unit, spell, spellrank)
		if self.Iconbg then
			if Castbar.interrupt and (unit=="target" or unit=="focus" or unit:find("boss%d")) then
				self.Iconbg:SetVertexColor(1, 0, 0)
				if unit=="target" or unit=="focus" then
					Castbar:SetStatusBarColor(unpack(CBinterrupt))
				end
			elseif unit=="player" then
				self.Iconbg:SetVertexColor(0, 0, 0)
				if C.unitframes.castbarSeparate then
					Castbar:SetStatusBarColor(C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b)
				else
					Castbar:SetStatusBarColor(0, 0, 0, .3)
				end
			else
				self.Iconbg:SetVertexColor(0, 0, 0)
				if unit=="target" or unit=="focus" then
					Castbar:SetStatusBarColor(unpack(CBnormal))
				end
			end
		end
	end

	local PostCastStop = function(Castbar, unit)
		if Castbar.Text then Castbar.Text:SetText("") end
	end

	local PostCastStopUpdate = function(self, event, unit)
		if(unit ~= self.unit) then return end
		return PostCastStop(self.Castbar, unit)
	end

	self:RegisterEvent("UNIT_NAME_UPDATE", PostCastStopUpdate)
	table.insert(self.__elements, PostCastStopUpdate)

	-- [[ Heal prediction ]]

	local mhpb = self:CreateTexture()
	mhpb:SetTexture(C.media.texture)
	mhpb:SetVertexColor(0, .5, 1)

	local ohpb = self:CreateTexture()
	ohpb:SetTexture(C.media.texture)
	ohpb:SetVertexColor(.5, 0, 1)

	self.HealPrediction = {
		-- status bar to show my incoming heals
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = 1,
		frequentUpdates = true,
	}

	if C.unitframes.absorb then
		local absorbBar = self:CreateTexture()
		absorbBar:SetTexture(C.media.texture)
		absorbBar:SetVertexColor(.8, .34, .8)

		local overAbsorbGlow = self:CreateTexture(nil, "OVERLAY")
		overAbsorbGlow:SetWidth(16)
		overAbsorbGlow:SetBlendMode("ADD")
		overAbsorbGlow:SetPoint("TOPLEFT", self.Health, "TOPRIGHT", -7, 0)
		overAbsorbGlow:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMRIGHT", -7, 0)

		self.HealPrediction["absorbBar"] = absorbBar
		self.HealPrediction["overAbsorbGlow"] = overAbsorbGlow
	end

	-- [[ Raid target icons ]]

	local RaidIcon = self:CreateTexture()
	RaidIcon:SetSize(16, 16)
	RaidIcon:SetPoint("CENTER", self, "CENTER", 0, 20)

	self.RaidIcon = RaidIcon

	-- [[ Spell Range ]]

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = .3}

	-- [[ shift + left click to set focus ]]

	local ModKey = "shift"
	local MouseButton = 1
	local key = ModKey .. "-type" .. (MouseButton or "")
	if(self.unit == "focus") then
		self:SetAttribute(key, "macro")
		self:SetAttribute("macrotext", "/clearfocus")
	else
		self:SetAttribute(key, "focus")
	end

	-- [[ Counter bar ]]

	--[[if unit == "player" or unit == "pet" then
		local CounterBar = CreateFrame("StatusBar", nil, self)
		CounterBar:SetWidth(playerWidth)
		CounterBar:SetHeight(16)
		CounterBar:SetStatusBarTexture(C.media.texture)
		CounterBar:SetPoint("TOP", UIParent, "TOP", 0, -100)

		local cbd = CreateFrame("Frame", nil, CounterBar)
		cbd:SetPoint("TOPLEFT", -1, 1)
		cbd:SetPoint("BOTTOMRIGHT", 1, -1)
		cbd:SetFrameLevel(CounterBar:GetFrameLevel()-1)
		F.CreateBD(cbd)

		CounterBar.Text = F.CreateFS(CounterBar)
		CounterBar.Text:SetPoint("CENTER")

		local r, g, b
		local max

		CounterBar:SetScript("OnValueChanged", function(_, value)
			_, max = CounterBar:GetMinMaxValues()
			r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))
			CounterBar:SetStatusBarColor(r, g, b)

			CounterBar.Text:SetText(floor(value))
		end)

		self.CounterBar = CounterBar
	end]]

	--[[ Set up the layout ]]

	self.colors = colors

	self.disallowVehicleSwap = true

	if(isSingle) then
		if unit == "player" then
			self:SetSize(playerWidth, playerHeight)
		elseif unit == "target" then
			self:SetSize(targetWidth, targetHeight)
		elseif unit == "targettarget" then
			self:SetSize(targettargetWidth, targettargetHeight)
		elseif unit:find("arena%d") then
			self:SetSize(arenaWidth, arenaHeight)
		elseif unit == "focus" then
			self:SetSize(focusWidth, focusHeight)
		elseif unit == "focustarget" then
			self:SetSize(focustargetWidth, focustargetHeight)
		elseif unit == "pet" then
			self:SetSize(petWidth, petHeight)
		elseif unit and unit:find("boss%d") then
			self:SetSize(bossWidth, bossHeight)
		end
	end

	Castbar.PostChannelStart = PostCastStart
	Castbar.PostCastStart = PostCastStart

	Castbar.PostCastStop = PostCastStop
	Castbar.PostChannelStop = PostCastStop

	Health.PostUpdate = PostUpdateHealth
	Power.PostUpdate = PostUpdatePower
end

-- [[ Unit specific functions ]]

local UnitSpecific = {
	pet = function(self, ...)
		Shared(self, ...)
		self.mystyle = "pet"

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(petHeight - powerHeight - 1)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())

		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Auras.initialAnchor = "TOPLEFT"
		Auras["growth-x"] = "RIGHT"
		Auras["growth-y"] = "DOWN"
		Auras['spacing-x'] = 3
		Auras['spacing-y'] = -3

		Auras.numDebuffs = 4
		Auras.numBuffs = 4
		Auras:SetHeight(100)
		Auras:SetWidth(petWidth)
		Auras.size = 20

		Auras.gap = true

		self.Auras = Auras

		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
	end,

	player = function(self, ...)
		Shared(self, ...)
		self.mystyle = "player"

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		-- Health and power

		Health:SetHeight(playerHeight - powerHeight - 1)

		local HealthPoints = F.CreateFS(Health, C.FONT_SIZE_NORMAL, "LEFT")
		HealthPoints:SetPoint("BOTTOMLEFT", Health, "TOPLEFT", 0, 3)
		self:Tag(HealthPoints, '[dead][offline][free:playerHealth]')
		Health.value = HealthPoints

		local PowerText = F.CreateFS(Power, C.FONT_SIZE_NORMAL, "RIGHT")
		PowerText:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", 0, 3)
		self:Tag(PowerText, '[free:power]')
		Power.Text = PowerText

		-- Cast bar

		if C.unitframes.castbar then
			Castbar.Width = self:GetWidth()
			Spark:SetHeight(self.Health:GetHeight())
			Castbar.Text = F.CreateFS(Castbar)
			Castbar.Text:SetDrawLayer("ARTWORK")

			local IconFrame = CreateFrame("Frame", nil, Castbar)

			local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
			Icon:SetAllPoints(IconFrame)
			Icon:SetTexCoord(.08, .92, .08, .92)

			F.CreateSD(IconFrame)

			Castbar.Icon = Icon

			self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
			self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
			self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
			self.Iconbg:SetTexture(C.media.backdrop)

			if C.unitframes.castbarSeparate then
				Castbar:SetStatusBarTexture(C.media.texture)
				--Castbar:SetStatusBarColor(unpack(C.class))
				Castbar:SetWidth(C.unitframes.player_castbar_width)
				Castbar:SetHeight(self:GetHeight())
				Castbar:SetPoint(unpack(C.unitframes.player_castbar))
				Castbar.Text:SetAllPoints(Castbar)
				Castbar.Text:SetFont(unpack(unitframeFont))

				local sf = Castbar:CreateTexture(nil, "OVERLAY")
				sf:SetVertexColor(.5, .5, .5, .5)
				Castbar.SafeZone = sf
				IconFrame:SetPoint("RIGHT", Castbar, "LEFT", -6, 0)
				IconFrame:SetSize(22, 22)

				local bg = CreateFrame("Frame", nil, Castbar)
				bg:SetPoint("TOPLEFT", -1, 1)
				bg:SetPoint("BOTTOMRIGHT", 1, -1)
				bg:SetFrameLevel(Castbar:GetFrameLevel()-1)
				F.CreateBD(bg)
				F.CreateSD(bg, 5, 0, 0, 0, .8, -2)
			else
				Castbar:SetAllPoints(Health)
				Castbar.Text:Hide()
				IconFrame:SetPoint("RIGHT", self, "LEFT", -6, 0)
				IconFrame:SetSize(22, 22)
			end
		end

		-- PVP indicator
		if C.unitframes.pvp then
			local PvPIndicator = F.CreateFS(self)
			PvPIndicator:SetPoint("BOTTOMRIGHT", Health, "TOPRIGHT", -50, 3)
			PvPIndicator:SetText("P")

			local UpdatePvPIndicator = function(self, event, unit)
				if(unit ~= self.unit) then return end

				local PvPIndicator = self.PvPIndicator

				local factionGroup = UnitFactionGroup(unit)
				if(UnitIsPVPFreeForAll(unit) or (factionGroup and factionGroup ~= "Neutral" and UnitIsPVP(unit))) then
					if factionGroup == "Alliance" then
						PvPIndicator:SetTextColor(0, 0.68, 0.94)
					else
						PvPIndicator:SetTextColor(1, 0, 0)
					end

					PvPIndicator:Show()
				else
					PvPIndicator:Hide()
				end
			end

			self.PvPIndicator = PvPIndicator
			PvPIndicator.Override = UpdatePvPIndicator
		end


		-- DK runes
		if class == "DEATHKNIGHT" and C.classmod.classResource then
			local Runes = CreateFrame("Frame", nil, self)
			Runes:SetWidth(playerWidth)
			Runes:SetHeight(classPowerHeight)

			local function moveAnchor()
				if self.AlternativePower:IsShown() then
					Runes:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
				else
					Runes:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
				end
			end
			self.AlternativePower:HookScript("OnShow", moveAnchor)
			self.AlternativePower:HookScript("OnHide", moveAnchor)
			moveAnchor()

			for index = 1, 6 do
				local Rune = CreateFrame('StatusBar', nil, self)
				Rune:SetHeight(classPowerHeight)
				Rune:SetStatusBarTexture(C.media.texture)

				F.CreateBDFrame(Rune)

				if(index == 1) then
					Rune:SetPoint("LEFT", Runes)
					Rune:SetWidth(playerWidth/6)
				else
					Rune:SetPoint('LEFT', Runes[index - 1], 'RIGHT', 3, 0)
					Rune:SetWidth((playerWidth/6)-3)
				end

				Runes[index] = Rune
			end
			self.Runes = Runes

		end

		-- class resource
		if C.classmod.classResource then
			local ClassPower = {}
			ClassPower.UpdateColor = UpdateClassPowerColor
			ClassPower.PostUpdate = PostUpdateClassPower

			for index = 1, 11 do -- have to create an extra to force __max to be different from UnitPowerMax
				local Bar = CreateFrame('StatusBar', nil, self)
				Bar:SetHeight(C.unitframes.classPower_height)
				Bar:SetStatusBarTexture(C.media.texture)
				--Bar:SetBackdrop(C.media.backdrop)
				Bar:SetBackdropColor(0, 0, 0)

				F.CreateBDFrame(Bar)

				if(index > 1) then
					Bar:SetPoint('LEFT', ClassPower[index - 1], 'RIGHT', 4, 0)
				else
					Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
				end

				local function moveAnchor()
					if self.AlternativePower:IsShown() then
						Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
					else
						Bar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
					end
				end
				self.AlternativePower:HookScript("OnShow", moveAnchor)
				self.AlternativePower:HookScript("OnHide", moveAnchor)
				moveAnchor()

				if(index > 5) then
					Bar:SetFrameLevel(Bar:GetFrameLevel() + 1)
				end

				local Background = Bar:CreateTexture(nil, 'BORDER')
				Background:SetAllPoints()
				Bar.bg = Background

				ClassPower[index] = Bar
			end
			self.ClassPower = ClassPower
			
		end

		-- Status indicator

		local statusIndicator = CreateFrame("Frame")
		local statusText = F.CreateFS(Health)
		statusText:SetPoint("LEFT", HealthPoints, "RIGHT", 10, 0)

		local function updateStatus()
			if UnitAffectingCombat("player") and C.unitframes.statusIndicatorCombat then
				statusText:SetText("!")
				statusText:SetTextColor(1, 0, 0)
			elseif IsResting() then
				statusText:SetText("Zzz")
				statusText:SetTextColor(.8, .8, .8)
			else
				statusText:SetText("")
			end
		end

		local function checkEvents()
			if C.unitframes.statusIndicator then
				statusText:Show()
				statusIndicator:RegisterEvent("PLAYER_ENTERING_WORLD")
				statusIndicator:RegisterEvent("PLAYER_UPDATE_RESTING")

				if C.unitframes.statusIndicatorCombat then
					statusIndicator:RegisterEvent("PLAYER_REGEN_ENABLED")
					statusIndicator:RegisterEvent("PLAYER_REGEN_DISABLED")
				else
					statusIndicator:UnregisterEvent("PLAYER_REGEN_ENABLED")
					statusIndicator:UnregisterEvent("PLAYER_REGEN_DISABLED")
				end

				updateStatus()
			else
				statusIndicator:UnregisterEvent("PLAYER_ENTERING_WORLD")
				statusIndicator:UnregisterEvent("PLAYER_UPDATE_RESTING")
				statusIndicator:UnregisterEvent("PLAYER_REGEN_ENABLED")
				statusIndicator:UnregisterEvent("PLAYER_REGEN_DISABLED")
				statusText:Hide()
			end
		end

		checkEvents()

		F.AddOptionsCallback("unitframes", "statusIndicator", checkEvents)
		F.AddOptionsCallback("unitframes", "statusIndicatorCombat", checkEvents)

		statusIndicator:SetScript("OnEvent", updateStatus)
	end,

	target = function(self, ...)
		Shared(self, ...)
		self.mystyle = "target"

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(targetHeight - powerHeight - 1)

		local HealthPoints = F.CreateFS(Health, C.FONT_SIZE_NORMAL, "LEFT")
		HealthPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		self:Tag(HealthPoints, '[dead][offline][free:health]')
		Health.value = HealthPoints

		local PowerText = F.CreateFS(Power)
		PowerText:SetPoint("BOTTOMLEFT", HealthPoints, "BOTTOMRIGHT", 3, 0)
		if powerType ~= 0 then PowerText.frequentUpdates = .1 end
		self:Tag(PowerText, '[free:power]')

		-- Cast bar

		if C.unitframes.castbar then
			Castbar.Width = self:GetWidth()
			Spark:SetHeight(self.Health:GetHeight())
			Castbar.Text = F.CreateFS(Castbar)
			Castbar.Text:SetDrawLayer("ARTWORK")

			local IconFrame = CreateFrame("Frame", nil, Castbar)
			IconFrame:SetPoint("TOPRIGHT", self, "TOPLEFT", -4, 0)
			IconFrame:SetHeight(24)
			IconFrame:SetWidth(24)

			F.CreateSD(IconFrame)

			local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
			Icon:SetAllPoints(IconFrame)
			Icon:SetTexCoord(.08, .92, .08, .92)

			Castbar.Icon = Icon

			self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
			self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
			self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
			self.Iconbg:SetTexture(C.media.backdrop)

			Castbar:SetStatusBarTexture(C.media.texture)
			Castbar:SetWidth(C.unitframes.target_castbar_width)
			Castbar:SetHeight(C.unitframes.castbarHeight)
			Castbar:SetPoint(unpack(C.unitframes.target_castbar))
			Castbar.Text:SetPoint("TOP", Castbar, "BOTTOM", 0, -4)
			Castbar.Text:SetFont(unpack(unitframeFont))

			local sf = Castbar:CreateTexture(nil, "OVERLAY")
			sf:SetVertexColor(.5, .5, .5, .5)
			Castbar.SafeZone = sf

			local bg = CreateFrame("Frame", nil, Castbar)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(Castbar:GetFrameLevel()-1)
			F.CreateBD(bg)
			F.CreateSD(bg, 5, 0, 0, 0, .8, -2)
		end

		local Name = F.CreateFS(self)
		Name:SetPoint("BOTTOMLEFT", PowerText, "BOTTOMRIGHT")
		Name:SetPoint("RIGHT", self)
		Name:SetFont(unpack(unitframeFont))
		Name:SetWidth(C.unitframes.targettarget_width)
		Name:SetJustifyH("RIGHT")
		Name:SetTextColor(1, 1, 1)
		Name:SetWordWrap(false)

		self:Tag(Name, '[name]')
		self.Name = Name

		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 24)
		Auras.initialAnchor = "BOTTOMLEFT"
		Auras["growth-x"] = "RIGHT"
		Auras["growth-y"] = "UP"
		Auras['spacing-x'] = 4
		Auras['spacing-y'] = 0

		Auras.numDebuffs = C.unitframes.num_target_debuffs
		Auras.numBuffs = C.unitframes.num_target_buffs
		Auras:SetHeight(500)
		Auras:SetWidth(targetWidth)
		Auras.size = 36


		Auras.gap = true

		self.Auras = Auras

		Auras.showDebuffType = true
		Auras.showStealableBuffs = true
		
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		Auras.PostUpdateGapIcon = PostUpdateGapIcon


		-- complicated filter is complicated
		-- icon hides if:
		-- it's a debuff on an enemy target which isn't yours, isn't cast by the target and isn't in the useful buffs filter
		-- it's a buff on an enemy player target which is not important

		if C.unitframes.castbyPlayer then

			local playerUnits = {
				player = true,
				pet = true,
				vehicle = true,
			}

			Auras.CustomFilter = function(_, unit, icon, _, _, _, _, _, _, _, caster, _, _, spellID)
				if(icon.isDebuff and not UnitIsFriend("player", unit) and not playerUnits[icon.owner] and icon.owner ~= self.unit)
				or(not icon.isDebuff and UnitIsPlayer(unit) and not UnitIsFriend("player", unit)) then
					return false
				end
				return true
			end

		end



		local QuestIcon = F.CreateFS(self)
		QuestIcon:SetText("!")
		QuestIcon:SetTextColor(228/255, 225/255, 16/255)
		QuestIcon:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 2)

		QuestIcon.PostUpdate = function(self, isQuestBoss)
			if isQuestBoss then
				Name:ClearAllPoints()
				Name:SetPoint("BOTTOMLEFT", PowerText, "BOTTOMRIGHT")
				Name:SetPoint("RIGHT", QuestIcon, "LEFT", 0, 0)
			else
				Name:ClearAllPoints()
				Name:SetPoint("BOTTOMLEFT", PowerText, "BOTTOMRIGHT")
				Name:SetPoint("RIGHT", self)
			end
		end

		self.QuestIndicator = QuestIcon
	end,

	targettarget = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(targettargetHeight - powerHeight - 1)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(Health:GetHeight())

		self.RaidIcon:ClearAllPoints()
		self.RaidIcon:SetPoint("LEFT", self, "RIGHT", 3, 0)

		local tt = CreateFrame("Frame", nil, self)
		tt:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		tt:SetWidth(C.unitframes.targettarget_width)

		local ttt = F.CreateFS(tt, C.FONT_SIZE_NORMAL, "RIGHT")
		ttt:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		ttt:SetFont(unpack(unitframeFont))
		ttt:SetWordWrap(false)
		ttt:SetWidth(C.unitframes.targettarget_width)

		tt:RegisterEvent("UNIT_TARGET")
		tt:RegisterEvent("PLAYER_TARGET_CHANGED")
		tt:SetScript("OnEvent", function()
			if(UnitName("targettarget")==UnitName("player")) then
				ttt:SetText("> YOU <")
				ttt:SetTextColor(1, 0, 0)
			else
				ttt:SetText(UnitName"targettarget")
				ttt:SetTextColor(1, 1, 1)
			end
		end)

	end,

	focus = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(focusHeight - powerHeight - 1)

		-- Cast bar

		if C.unitframes.castbar then
			Castbar.Width = self:GetWidth()
			Spark:SetHeight(self.Health:GetHeight())
			Castbar.Text = F.CreateFS(Castbar)
			Castbar.Text:SetDrawLayer("ARTWORK")

			self.RaidIcon:ClearAllPoints()
			self.RaidIcon:SetPoint("RIGHT", self, "LEFT", -3, 0)

			local IconFrame = CreateFrame("Frame", nil, Castbar)

			local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
			Icon:SetAllPoints(IconFrame)
			Icon:SetTexCoord(.08, .92, .08, .92)

			F.CreateSD(IconFrame)

			Castbar.Icon = Icon

			self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
			self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
			self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
			self.Iconbg:SetTexture(C.media.backdrop)

			Castbar:SetStatusBarTexture(C.media.texture)
			--Castbar:SetStatusBarColor(219/255, 0, 11/255)
			Castbar:SetWidth(C.unitframes.focus_castbar_width)
			Castbar:SetHeight(C.unitframes.castbarHeight)
			Castbar:SetPoint(unpack(C.unitframes.focus_castbar))
			Castbar.Text:SetPoint("BOTTOM", Castbar, "TOP", 0, 4)
			Castbar.Text:SetFont(unpack(unitframeFont))

			local sf = Castbar:CreateTexture(nil, "OVERLAY")
			sf:SetVertexColor(.5, .5, .5, .5)
			Castbar.SafeZone = sf
			IconFrame:SetPoint("LEFT", Castbar, "RIGHT", 4, 0)
			IconFrame:SetSize(14, 14)

			local bg = CreateFrame("Frame", nil, Castbar)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(Castbar:GetFrameLevel()-1)
			F.CreateBD(bg)
			F.CreateSD(bg, 5, 0, 0, 0, .8, -2)
		end

		local Name = F.CreateFS(self)
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		Name:SetFont(unpack(unitframeFont))
		Name:SetWidth(C.unitframes.focus_width)
		Name:SetJustifyH"RIGHT"
		Name:SetWordWrap(false)
		Name:SetTextColor(1, 1, 1)

		self:Tag(Name, '[name]')
		self.Name = Name
	end,

	focustarget = function(self, ...)
		Shared(self, ...)

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		Health:SetHeight(focustargetHeight - powerHeight - 1)

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(Health:GetHeight())

		self.RaidIcon:ClearAllPoints()
		self.RaidIcon:SetPoint("LEFT", self, "RIGHT", 3, 0)

		local tt = CreateFrame("Frame", nil, self)
		tt:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)

		local ttt = F.CreateFS(tt, C.FONT_SIZE_NORMAL, "LEFT")
		ttt:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		ttt:SetFont(unpack(unitframeFont))
		ttt:SetWordWrap(false)
		ttt:SetWidth(C.unitframes.focustarget_width)

		tt:RegisterEvent("UNIT_TARGET")
		tt:RegisterEvent("PLAYER_FOCUS_CHANGED")
		tt:SetScript("OnEvent", function()
			if(UnitName("focustarget")==UnitName("player")) then
				ttt:SetText("> YOU <")
				ttt:SetTextColor(1, 0, 0)
			else
				ttt:SetText(UnitName"focustarget")
				ttt:SetTextColor(1, 1, 1)
			end
		end)
	end,


	boss = function(self, ...)
		Shared(self, ...)
		self.mystyle = "boss"

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		self:SetAttribute('initial-height', bossHeight)
		self:SetAttribute('initial-width', bossWidth)

		Health:SetHeight(bossHeight - powerHeight - 1)

		local HealthPoints = F.CreateFS(Health, C.FONT_SIZE_NORMAL, "RIGHT")
		HealthPoints:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 4)
		self:Tag(HealthPoints, '[dead][free:bosshealth]')

		Health.value = HealthPoints

		local Name = F.CreateFS(self, C.FONT_SIZE_NORMAL, "LEFT")
		Name:SetFont(unpack(unitframeFont))
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		Name:SetWidth((bossWidth / 2) + 10)
		Name:SetWordWrap(false)

		self:Tag(Name, '[name]')
		self.Name = Name

		local AltPowerBar = CreateFrame("StatusBar", nil, self)
		AltPowerBar:SetWidth(bossWidth)
		AltPowerBar:SetHeight(altPowerHeight)
		AltPowerBar:SetStatusBarTexture(C.media.texture)
		AltPowerBar:SetPoint("BOTTOM", 0, -2)

		local abd = CreateFrame("Frame", nil, AltPowerBar)
		abd:SetPoint("TOPLEFT", -1, 1)
		abd:SetPoint("BOTTOMRIGHT", 1, -1)
		abd:SetFrameLevel(AltPowerBar:GetFrameLevel()-1)
		F.CreateBD(abd)

		AltPowerBar.Text = F.CreateFS(AltPowerBar, C.FONT_SIZE_NORMAL, "CENTER")
		AltPowerBar.Text:SetPoint("BOTTOM", Health, "TOP", 0, 3)

		AltPowerBar:SetScript("OnValueChanged", function(_, value)
			local min, max = AltPowerBar:GetMinMaxValues()
			local r, g, b = self.ColorGradient(value, max, unpack(self.colors.smooth))

			AltPowerBar:SetStatusBarColor(r, g, b)
			AltPowerBar.Text:SetTextColor(r, g, b)
		end)

		AltPowerBar.PostUpdate = function(_, _, cur)
			AltPowerBar.Text:SetText(cur)
		end


		self.AlternativePower = AltPowerBar		


		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())

		Castbar.Text = F.CreateFS(self)
		Castbar.Text:SetFont(unpack(unitframeFont))
		Castbar.Text:SetDrawLayer("ARTWORK")
		Castbar.Text:SetAllPoints(Health)

		local IconFrame = CreateFrame("Frame", nil, Castbar)
		IconFrame:SetPoint("RIGHT", self, "LEFT", -4, 0)
		IconFrame:SetHeight(22)
		IconFrame:SetWidth(22)

		F.CreateSD(IconFrame)

		local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
		Icon:SetAllPoints(IconFrame)
		Icon:SetTexCoord(.08, .92, .08, .92)

		Castbar.Icon = Icon

		self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
		self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
		self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
		self.Iconbg:SetTexture(C.media.backdrop)

		--[[local Buffs = CreateFrame("Frame", nil, self)
		Buffs.initialAnchor = "TOPLEFT"
		Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Buffs["growth-x"] = "RIGHT"
		Buffs["growth-y"] = "DOWN"
		Buffs['spacing-x'] = 3
		Buffs['spacing-y'] = 3

		Buffs:SetHeight(22)
		Buffs:SetWidth(bossWidth - 24)
		Buffs.num = 8
		Buffs.size = 26

		self.Buffs = Buffs
		Buffs.PostUpdateIcon = PostUpdateIcon

		local Debuffs = CreateFrame("Frame", nil, self)
		Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -4)
		Debuffs.initialAnchor = "TOPRIGHT"
		Debuffs["growth-x"] = "LEFT"
		Debuffs["growth-y"] = "DOWN"
		Debuffs["spacing-x"] = 3
		Debuffs['spacing-y'] = 3
		Debuffs:SetHeight(22)
		Debuffs:SetWidth(bossWidth - 24)
		Debuffs.size = 26
		Debuffs.num = 8
		self.Debuffs = Debuffs
		self.Debuffs.onlyShowPlayer = true

		Debuffs.PostUpdateIcon = PostUpdateIcon]]

		



		local Auras = CreateFrame("Frame", nil, self)
		Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Auras.initialAnchor = "TOPLEFT"
		Auras["growth-x"] = "RIGHT"
		Auras["growth-y"] = "DOWN"
		Auras['spacing-x'] = 4
		Auras['spacing-y'] = 0

		Auras.numDebuffs = C.unitframes.num_target_debuffs
		Auras.numBuffs = C.unitframes.num_target_buffs
		Auras:SetHeight(500)
		Auras:SetWidth(targetWidth)
		Auras.size = 36


		Auras.gap = true

		self.Auras = Auras

		Auras.showDebuffType = true
		Auras.showStealableBuffs = true

		
		Auras.PostCreateIcon = PostCreateIcon
		Auras.PostUpdateIcon = PostUpdateIcon
		Auras.PostUpdateGapIcon = postUpdateGapIcon

	


		AltPowerBar:HookScript("OnShow", function()
			Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -(4 + altPowerHeight))
		end)

		AltPowerBar:HookScript("OnHide", function()
			Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		end)
	end,

	arena = function(self, ...)
		if not C.unitframes.enableArena then return end

		Shared(self, ...)
		self.mystyle = "arena"

		local Health = self.Health
		local Power = self.Power
		local Castbar = self.Castbar
		local Spark = Castbar.Spark

		self:SetAttribute('initial-height', arenaHeight)
		self:SetAttribute('initial-width', arenaWidth)

		Health:SetHeight(arenaHeight - powerHeight - 1)

		local HealthPoints = F.CreateFS(Health, C.FONT_SIZE_NORMAL, "RIGHT")
		HealthPoints:SetPoint("RIGHT", self, "TOPRIGHT", 0, 6)
		self:Tag(HealthPoints, '[dead][offline][free:health]')

		Health.value = HealthPoints

		local Name = F.CreateFS(self, C.FONT_SIZE_NORMAL, "LEFT")
		Name:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 2)
		Name:SetWidth(110)
		Name:SetHeight(12)
		Name:SetFont(unpack(unitframeFont))

		self:Tag(Name, '[name]')
		self.Name = Name

		Castbar:SetAllPoints(Health)
		Castbar.Width = self:GetWidth()

		Spark:SetHeight(self.Health:GetHeight())

		Castbar.Text = F.CreateFS(self)
		Castbar.Text:SetFont(unpack(unitframeFont))
		Castbar.Text:SetDrawLayer("ARTWORK")
		Castbar.Text:SetAllPoints(Health)

		local IconFrame = CreateFrame("Frame", nil, Castbar)
		IconFrame:SetPoint("LEFT", self, "RIGHT", 3, 0)
		IconFrame:SetHeight(22)
		IconFrame:SetWidth(22)

		F.CreateSD(IconFrame)

		local Icon = IconFrame:CreateTexture(nil, "OVERLAY")
		Icon:SetAllPoints(IconFrame)
		Icon:SetTexCoord(.08, .92, .08, .92)

		Castbar.Icon = Icon

		self.Iconbg = IconFrame:CreateTexture(nil, "BACKGROUND")
		self.Iconbg:SetPoint("TOPLEFT", -1 , 1)
		self.Iconbg:SetPoint("BOTTOMRIGHT", 1, -1)
		self.Iconbg:SetTexture(C.media.backdrop)

		--[[local Buffs = CreateFrame("Frame", nil, self)
		Buffs.initialAnchor = "TOPLEFT"
		Buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
		Buffs["growth-x"] = "RIGHT"
		Buffs["growth-y"] = "DOWN"
		Buffs['spacing-x'] = 3
		Buffs['spacing-y'] = 3

		Buffs:SetHeight(22)
		Buffs:SetWidth(arenaWidth)
		Buffs.num = C.unitframes.num_arena_buffs
		Buffs.size = 22

		self.Buffs = Buffs

		Buffs.PostUpdateIcon = PostUpdateIcon]]

		self.RaidIcon:SetPoint("LEFT", self, "RIGHT", 3, 0)
	end,
}

do
	local range = {
		insideAlpha = 1,
		outsideAlpha = .3,
	}

	UnitSpecific.party = function(self, ...)
		Shared(self, ...)
		self.mystyle = "party"

		self.disallowVehicleSwap = false

		local Health, Power = self.Health, self.Power

		local Text = F.CreateFS(Health, C.FONT_SIZE_NORMAL, "CENTER")
		Text:SetPoint("CENTER", 1, 0)

		self.Text = Text

		self:Tag(Text, '[dead][offline]')

		Health:SetHeight(partyHeight - powerHeight - 1)
		if C.unitframes.partyNameAlways then
			Text:SetFont(unpack(unitframeFont))
			self:Tag(Text, '[free:name]')
		elseif C.unitframes.partyMissingHealth then
			self:Tag(Text, '[free:missinghealth]')
		else
			self:Tag(Text, '[dead][offline]')
		end

		self.ResurrectIcon = self:CreateTexture(nil, "OVERLAY")
		self.ResurrectIcon:SetSize(16, 16)
		self.ResurrectIcon:SetPoint("CENTER")

		self.RaidIcon:ClearAllPoints()
		self.RaidIcon:SetPoint("CENTER", self, "CENTER")

		local LeaderIndicator = F.CreateFS(self, C.FONT_SIZE_NORMAL, "LEFT")
		LeaderIndicator:SetText("l")
		LeaderIndicator:SetPoint("TOPLEFT", Health, 2, -1)

		self.LeaderIndicator = LeaderIndicator

		--[[local MasterLooter = F.CreateFS(self, C.FONT_SIZE_NORMAL, "RIGHT")
		MasterLooter:SetText("m")
		MasterLooter:SetPoint("TOPRIGHT", Health, 1, 0)

		self.MasterLooter = MasterLooter]]

		local rc = self:CreateTexture(nil, "OVERLAY")
		rc:SetPoint("TOPLEFT", Health)
		rc:SetSize(16, 16)

		self.ReadyCheck = rc

		local UpdateLFD = function(self, event)
			local lfdrole = self.LFDRole
			local role = UnitGroupRolesAssigned(self.unit)

			if role == "DAMAGER" then
				lfdrole:SetTextColor(1, .1, .1, 1)
				lfdrole:SetText(".")
			elseif role == "TANK" then
				lfdrole:SetTextColor(.3, .4, 1, 1)
				lfdrole:SetText("x")
			elseif role == "HEALER" then
				lfdrole:SetTextColor(0, 1, 0, 1)
				lfdrole:SetText("+")
			else
				lfdrole:SetTextColor(0, 0, 0, 0)
			end
		end

		local lfd = F.CreateFS(Health, C.FONT_SIZE_NORMAL, "CENTER")
		lfd:SetPoint("BOTTOM", Health, 1, 1)
		lfd.Override = UpdateLFD

		self.LFDRole = lfd

		local Debuffs = CreateFrame("Frame", nil, self)
		Debuffs.initialAnchor = "CENTER"
		Debuffs:SetPoint("BOTTOM", 0, powerHeight - 1)
		Debuffs["growth-x"] = "RIGHT"
		Debuffs["spacing-x"] = 4

		Debuffs:SetHeight(16)
		Debuffs:SetWidth(37)
		Debuffs.num = 2
		Debuffs.size = 16

		self.Debuffs = Debuffs

		Debuffs.PostCreateIcon = function(icons, index)
			index:EnableMouse(false)
		end

		-- Import the global table for faster usage
		local hideDebuffs = C.hideDebuffs

		Debuffs.CustomFilter = function(_, _, _, _, _, _, _, _, _, _, caster, _, _, spellID)
			if hideDebuffs[spellID] then
				return false
			end
			return true
		end

		Debuffs.PostUpdate = function(icons)
			local vb = icons.visibleDebuffs

			if vb == 2 then
				Debuffs:SetPoint("BOTTOM", -9, 0)
			else
				Debuffs:SetPoint("BOTTOM")
			end
		end

		--[[Debuffs.PostUpdateIcon = function(icons, unit, icon, index, _, filter)
			local _, _, _, _, dtype = UnitAura(unit, index, icon.filter)
			if dtype and UnitIsFriend("player", unit) then
				local color = DebuffTypeColor[dtype]
				icon.bg:SetVertexColor(color.r, color.g, color.b)
			else
				icon.bg:SetVertexColor(0, 0, 0)
			end
			icon:EnableMouse(false)
		end]]

		local Buffs = CreateFrame("Frame", nil, self)
		Buffs.initialAnchor = "CENTER"
		Buffs:SetPoint("TOP", 0, -2)
		Buffs["growth-x"] = "RIGHT"
		Buffs["spacing-x"] = 3

		Buffs:SetSize(43, 12)
		Buffs.num = 3
		Buffs.size = 12

		self.Buffs = Buffs

		Buffs.PostCreateIcon = function(icons, index)
			index:EnableMouse(false)
			index.cd.noshowcd = true
		end

		Buffs.PostUpdateIcon = function(_, _, icon)
			icon:EnableMouse(false)
		end

		local myBuffs = C.myBuffs
		local allBuffs = C.allBuffs

		Buffs.CustomFilter = function(_, _, _, _, _, _, _, _, _, _, caster, _, _, spellID)
			if (caster == "player" and myBuffs[spellID]) or allBuffs[spellID] then
				return true
			end
		end

		Buffs.PostUpdate = function(icons)
			local vb = icons.visibleBuffs

			if vb == 3 then
				Buffs:SetPoint("TOP", -15, -2)
			elseif vb == 2 then
				Buffs:SetPoint("TOP", -7, -2)
			else
				Buffs:SetPoint("TOP", 0, -2)
			end
		end

		local Threat = CreateFrame("Frame", nil, self)
		self.Threat = Threat
		Threat.Override = UpdateThreat

		local select = CreateFrame("Frame", nil, self)
		select:RegisterEvent("PLAYER_TARGET_CHANGED")
		select:SetScript("OnEvent", updateNameColourAlt)

		self.Range = range
	end
end

--[[ Register and activate style ]]

oUF:RegisterStyle("Free", Shared)
for unit,layout in next, UnitSpecific do
	oUF:RegisterStyle('Free - ' .. unit:gsub("^%l", string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if(UnitSpecific[unit]) then
		self:SetActiveStyle('Free - ' .. unit:gsub("^%l", string.upper))
	elseif(UnitSpecific[unit:match('[^%d]+')]) then -- boss1 -> boss
		self:SetActiveStyle('Free - ' .. unit:match('[^%d]+'):gsub("^%l", string.upper))
	else
		self:SetActiveStyle'Free'
	end

	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end

local function round(x)
	return floor(x + .5)
end

oUF:Factory(function(self)
	local partyPos, raidPos
	local player, target, focus, targettarget, focustarget, pet

	player = spawnHelper(self, 'player', unpack(C.unitframes.player))
	pet = spawnHelper(self, 'pet', unpack(C.unitframes.pet))
	target = spawnHelper(self, 'target', unpack(C.unitframes.target))
	targettarget = spawnHelper(self, 'targettarget', unpack(C.unitframes.targettarget))
	focus = spawnHelper(self, 'focus', unpack(C.unitframes.focus))
	focustarget = spawnHelper(self, 'focustarget', unpack(C.unitframes.focustarget))

	partyPos = C.unitframes.party
	raidPos = C.unitframes.raid

	-- spawnHelper(self, 'pet', "RIGHT", player, "LEFT", -5, 0)
	-- spawnHelper(self, 'targettarget', "LEFT", target, "RIGHT", 5, 0)
	-- spawnHelper(self, 'focustarget', "LEFT", focus, "RIGHT", 5, 0)

	for n = 1, MAX_BOSS_FRAMES do
		spawnHelper(self, 'boss' .. n, C.unitframes.boss.a, C.unitframes.boss.b, C.unitframes.boss.c, C.unitframes.boss.x, C.unitframes.boss.y + (66 * n))
	end

	if C.unitframes.enableArena then
		for n = 1, 5 do
			spawnHelper(self, 'arena' .. n, C.unitframes.arena.a, C.unitframes.arena.b, C.unitframes.arena.c, C.unitframes.arena.x, C.unitframes.arena.y - (66 * n))
		end
	end

	if not C.unitframes.enableGroup then return end

	self:SetActiveStyle'Free - Party'

	local party_width, party_height
	party_width = partyWidth
	party_height = partyHeight

	local party = self:SpawnHeader(nil, nil, "party,raid",
		'showParty', true,
		'showPlayer', true,
		'showSolo', false,
		'xoffset', 3,
		'yoffset', 3,
		'maxColumns', 5,
		'unitsperColumn', 1,
		'columnSpacing', 3,
		'point', "LEFT",
		'columnAnchorPoint', "LEFT",
		'groupBy', 'ASSIGNEDROLE',
		'groupingOrder', 'DAMAGER,HEALER,TANK',
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(party_height, party_width)
	)

	party:SetPoint(unpack(partyPos))

	local raid = self:SpawnHeader(nil, nil, "raid",
		'showParty', false,
		'showRaid', true,
		'xoffset', 3,
		'yOffset', -3,
		'point', "LEFT",
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'ASSIGNEDROLE',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 3,
		'columnAnchorPoint', "TOP",
		"sortMethod", "INDEX",
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(raidHeight, raidWidth)
	)

	raid:SetPoint(unpack(raidPos))

	-- 限制团队框体只显示4个队伍20名成员
	if C.unitframes.limitRaidSize then
		raid:SetAttribute("groupFilter", "1,2,3,4")
	end
	F.AddOptionsCallback("unitframes", "limitRaidSize", function()
		if C.unitframes.limitRaidSize then
			raid:SetAttribute("groupFilter", "1,2,3,4")
		else
			raid:SetAttribute("groupFilter", "1,2,3,4,5,6,7,8")
		end
	end)

	local raidToParty = CreateFrame("Frame")

	local function togglePartyAndRaid(event)
		if InCombatLockdown() then
			raidToParty:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		elseif (event and event == "PLAYER_REGEN_ENABLED") then
			raidToParty:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end

		local numGroup = GetNumGroupMembers()

		if numGroup > 5 then
			party:SetAttribute("showParty", false)
			party:SetAttribute("showRaid", false)
			raid:SetAttribute("showRaid", true)
		else
			raid:SetAttribute("showRaid", false)
			-- if in a party, or in a raid where everyone is in one party (subgroup), show party
			-- if in a raid where people are spread across subgroups, show raid
			if GetNumSubgroupMembers() + 1 < numGroup then
				party:SetAttribute("showParty", false)
				party:SetAttribute("showRaid", true)
			else
				party:SetAttribute("showParty", true)
				party:SetAttribute("showRaid", false)
			end
		end
	end

	raidToParty:SetScript("OnEvent", togglePartyAndRaid)

	local function checkShowRaidFrames()
		if C.unitframes.showRaidFrames then
			raidToParty:RegisterEvent("PLAYER_ENTERING_WORLD")
			raidToParty:RegisterEvent("GROUP_ROSTER_UPDATE")

			togglePartyAndRaid()
		else
			raidToParty:UnregisterEvent("PLAYER_ENTERING_WORLD")
			raidToParty:UnregisterEvent("GROUP_ROSTER_UPDATE")

			party:SetAttribute("showParty", false)
			party:SetAttribute("showRaid", false)
			raid:SetAttribute("showRaid", false)
		end
	end

	checkShowRaidFrames()
	F.AddOptionsCallback("unitframes", "showRaidFrames", checkShowRaidFrames)
end)
