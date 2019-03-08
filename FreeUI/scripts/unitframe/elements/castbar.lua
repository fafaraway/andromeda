local _, ns = ...
local F, C, L = unpack(select(2, ...))

local module, cfg = F:GetModule('Unitframe'), C.unitframe

local unpack, GetTime, IsPlayerSpell = unpack, GetTime, IsPlayerSpell
local UnitChannelInfo, UnitInVehicle, UnitIsUnit = UnitChannelInfo, UnitInVehicle, UnitIsUnit

local function GetSpellName(spellID)
	local name = GetSpellInfo(spellID)
	if not name then
		print('oUF-Plugins-Castbar: '.. spellID..' not found.')
		return 0
	end
	return name
end

local channelingTicks = {
	-- warlock
	[GetSpellName(755)] = 3,		-- health funnel
	[GetSpellName(198590)] = 5,		-- drain soul
	[GetSpellName(234153)] = 5,		-- drain life
	-- druid
	[GetSpellName(740)] = 4,		-- Tranquility
	-- priest
	[GetSpellName(15407)] = 4,		-- mind flay
	[GetSpellName(47540)] = 3,		-- penance
	[GetSpellName(64843)] = 4,		-- divine hymn
	[GetSpellName(205065)] = 6,
	-- mage
	[GetSpellName(5143)] = 5, 		-- arcane missiles
	[GetSpellName(12051)] = 3, 		-- evocation
	[GetSpellName(205021)] = 5,
}

if C.Class == 'PRIEST' then
	local penance = GetSpellName(47540)
	local function updateTicks()
		local numTicks = 3
		if IsPlayerSpell(193134) then numTicks = 4 end	-- Enhanced Mind Flay
		channelingTicks[penance] = numTicks
	end
	F:RegisterEvent('PLAYER_LOGIN', updateTicks)
	F:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', updateTicks)
end

local ticks = {}
local function updateCastBarTicks(bar, numTicks)
	if numTicks and numTicks > 0 then
		local delta = bar:GetWidth() / numTicks
		for i = 1, numTicks do
			if not ticks[i] then
				ticks[i] = bar:CreateTexture(nil, 'OVERLAY')
				ticks[i]:SetTexture(C.media.sbTex)
				ticks[i]:SetVertexColor(0, 0, 0, .7)
				ticks[i]:SetWidth(C.Mult)
				ticks[i]:SetHeight(bar:GetHeight())
			end
			ticks[i]:ClearAllPoints()
			ticks[i]:SetPoint('CENTER', bar, 'LEFT', delta * i, 0 )
			ticks[i]:Show()
		end
	else
		for _, tick in pairs(ticks) do
			tick:Hide()
		end
	end
end

local function OnCastbarUpdate(self, elapsed)
	if self.casting or self.channeling then
		local decimal = self.decimal

		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end

		if self.__owner.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText(decimal..' | |cffff0000'..decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText(decimal..' | '..decimal, duration, self.max)
				if self.Lag and self.SafeZone and self.SafeZone.timeDiff ~= 0 then
					self.Lag:SetFormattedText('%d ms', self.SafeZone.timeDiff * 1000)
				end
			end
		else
			if duration > 1e4 then
				self.Time:SetText('∞ | ∞')
			else
				self.Time:SetFormattedText(decimal..' | '..decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			end
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - .02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

local function OnCastSent(self)
	local element = self.Castbar
	if not element.SafeZone then return end
	element.SafeZone.sendTime = GetTime()
	element.SafeZone.castSent = true
end

local function PostCastStart(self, unit)
	self:SetAlpha(1)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))

	if unit == 'vehicle' or UnitInVehicle('player') then
		if self.SafeZone then self.SafeZone:Hide() end
		if self.Lag then self.Lag:Hide() end
	elseif unit == 'player' then
		local safeZone = self.SafeZone
		if not safeZone then return end
 
		safeZone.timeDiff = 0
		if safeZone.castSent then
			safeZone.timeDiff = GetTime() - safeZone.sendTime
			safeZone.timeDiff = safeZone.timeDiff > self.max and self.max or safeZone.timeDiff
			safeZone:SetWidth(self:GetWidth() * (safeZone.timeDiff + .001) / self.max)
			safeZone:Show()
			safeZone.castSent = false
		end

		local numTicks = 0
		if self.channeling then
			local spellID = UnitChannelInfo(unit)
			numTicks = channelingTicks[spellID] or 0
		end
		updateCastBarTicks(self, numTicks)
	elseif not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	end

	-- Fix for empty icon
	if self.Icon and not self.Icon:GetTexture() then
		self.Icon:SetTexture(136243)
	end


	if self.iconBg then
		if self.notInterruptible then
			self.iconBg:SetVertexColor(unpack(self.notInterruptibleColor))
		else
			self.iconBg:SetVertexColor(unpack(self.CastingColor))
		end
	end

	if self.iconGlow then
		if self.notInterruptible then
			self.iconGlow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .65)
		else
			self.iconGlow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .65)
		end
	end

	if (unit == 'player' and not C.unitframe.castbar_separatePlayer) or (unit == 'target' and not C.unitframe.castbar_separateTarget) then
		if self.notInterruptible then
			self.Glow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .5)
		else
			self.Glow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .5)
		end
	end

	if (unit == 'player' and C.unitframe.castbar_separatePlayer) or (unit == 'target' and C.unitframe.castbar_separateTarget) then
		self.Bg:SetBackdropColor(0, 0, 0, .6)
	else
		self.Bg:SetBackdropColor(0, 0, 0, .2)
	end

	if (unit == 'player' and C.unitframe.castbar_separatePlayer) then
		self:SetStatusBarColor(C.r, C.g, C.b, 1)
	end

	if not ((unit == 'player' and C.unitframe.castbar_separatePlayer) or (unit == 'target' and C.unitframe.castbar_separateTarget)) then
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .4)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .4)
		end
	end
end

local function PostUpdateInterruptible(self, unit)
	if not UnitIsUnit(unit, 'player') and self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	else
		self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	end
end

local function PostCastStop(self)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

local function PostChannelStop(self)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

local function PostCastFailed(self)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
end


function module:AddCastBar(self)
	if not cfg.enableCastbar then return end

	local castbar = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	castbar:SetAllPoints(self)
	castbar:SetStatusBarTexture(C.media.sbTex)
	castbar:GetStatusBarTexture():SetBlendMode('BLEND')
	castbar:SetStatusBarColor(0, 0, 0, 0)
	castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
	self.Castbar = castbar

	local spark = castbar:CreateTexture(nil, 'OVERLAY')
	spark:SetBlendMode('ADD')
	spark:SetAlpha(.7)
	spark:SetHeight(castbar:GetHeight()*2)
	
	local text
	if C.Client == 'zhCN' or C.Client == 'zhTW' then
		text = F.CreateFS(castbar, {C.font.normal, 11}, '', nil, nil, '2')
	else
		text = F.CreateFS(castbar, 'pixel', '', nil, nil, true)
	end
	text:SetPoint('CENTER', castbar)
	
	local timer = F.CreateFS(castbar, 'pixel', '', nil, nil, true)
	timer:SetPoint('CENTER', castbar)

	if cfg.castbar_showSpellName then text:Show() else text:Hide() end
	if cfg.castbar_showSpellTimer then timer:Show() else timer:Hide() end
	
	local iconFrame = CreateFrame('Frame', nil, castbar)
	iconFrame:SetPoint('RIGHT', castbar, 'LEFT', -4*C.Mult, 0)
	iconFrame:SetSize(self:GetHeight()+6, self:GetHeight()+6)

	local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
	icon:SetAllPoints(iconFrame)
	icon:SetTexCoord(unpack(C.TexCoord))
	
	if self.unitStyle == 'player' then
		local safeZone = castbar:CreateTexture(nil,'OVERLAY')
		safeZone:SetTexture(C.media.backdrop)
		safeZone:SetVertexColor(223/255, 63/255, 107/255, .6)
		safeZone:SetPoint('TOPRIGHT')
		safeZone:SetPoint('BOTTOMRIGHT')
		castbar.SafeZone = safeZone
	end

	if self.unitStyle == 'target' and cfg.castbar_separateTarget then
		castbar:SetSize(self:GetWidth(), cfg.target_cb_height*C.Mult)
		castbar:ClearAllPoints()
		iconFrame:SetSize(castbar:GetHeight()+6, castbar:GetHeight()+6)

		F.Mover(castbar, L['MOVER_UNITFRAME_TARGET_CASTBAR'], 'TargetCastbar', {'TOPRIGHT', self, 'BOTTOMRIGHT', -6*C.Mult, -10*C.Mult}, cfg.target_cb_width, cfg.target_cb_height)
	elseif (self.unitStyle == 'target' and not cfg.castbar_separateTarget and cfg.healer_layout) or (self.unitStyle == 'player' and not cfg.castbar_separateTarget) then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', castbar, 'RIGHT', 4*C.Mult, 0)
	end

	if self.unitStyle == 'player' and cfg.castbar_separatePlayer then
		castbar:SetSize(self:GetWidth(), cfg.player_cb_height*C.Mult)
		castbar:ClearAllPoints()
		iconFrame:SetSize(castbar:GetHeight()+6, castbar:GetHeight()+6)

		if cfg.healer_layout then
			F.Mover(castbar, L['MOVER_UNITFRAME_PLAYER_CASTBAR'], 'PlayerCastbar', {'CENTER', UIParent, 'CENTER', 0, -200*C.Mult}, cfg.player_cb_width, cfg.player_cb_height)
		else
			F.Mover(castbar, L['MOVER_UNITFRAME_PLAYER_CASTBAR'], 'PlayerCastbar', {'TOPRIGHT', self, 'BOTTOMRIGHT', -6*C.Mult, -38*C.Mult}, cfg.player_cb_width, cfg.player_cb_height)
		end
	end

	if self.unitStyle == 'boss' then
		castbar.decimal = '%.1f'
	else
		castbar.decimal = '%.2f'
	end

	castbar.Bg = F.CreateBDFrame(castbar, .2)
	castbar.Glow = F.CreateSD(castbar.Bg, .35, 4, 4)
	castbar.Icon = icon
	castbar.iconBg = F.CreateBG(iconFrame)
	castbar.iconGlow = F.CreateSD(iconFrame, .35, 4, 4)
	castbar.Spark = spark
	castbar.Text = text
	castbar.Time = timer

	castbar.CastingColor = cfg.castbar_CastingColor
	castbar.ChannelingColor = cfg.castbar_ChannelingColor
	castbar.notInterruptibleColor = cfg.castbar_notInterruptibleColor
	castbar.CompleteColor = cfg.castbar_CompleteColor
	castbar.FailColor = cfg.castbar_FailColor

	castbar.OnUpdate = OnCastbarUpdate
	castbar.PostCastStart = PostCastStart
	castbar.PostChannelStart = PostCastStart
	castbar.PostCastStop = PostCastStop
	castbar.PostChannelStop = PostChannelStop
	castbar.PostCastFailed = PostCastFailed
	castbar.PostCastInterrupted = PostCastFailed
	castbar.PostCastInterruptible = PostUpdateInterruptible
	castbar.PostCastNotInterruptible = PostUpdateInterruptible
end