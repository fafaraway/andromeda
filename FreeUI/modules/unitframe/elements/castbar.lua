local F, C, L = unpack(select(2, ...))
local UNITFRAME, cfg, oUF = F:GetModule('Unitframe'), C.Unitframe, F.oUF


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
	[GetSpellName(740)] = 4,		-- 宁静
	[GetSpellName(755)] = 3,		-- 生命通道
	[GetSpellName(5143)] = 5, 		-- 奥术飞弹
	[GetSpellName(12051)] = 3, 		-- 唤醒
	[GetSpellName(15407)] = 4,		-- 精神鞭笞
	[GetSpellName(47540)] = 3,		-- 苦修
	[GetSpellName(64843)] = 4,		-- 神圣赞美诗
	[GetSpellName(198590)] = 5,		-- 吸取灵魂
	[GetSpellName(205021)] = 5,		-- 冰霜射线
	[GetSpellName(205065)] = 6,		-- 虚空洪流
	[GetSpellName(234153)] = 5,		-- 吸取生命
	[GetSpellName(291944)] = 6,		-- 再生
}

if C.MyClass == 'PRIEST' then
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
				ticks[i]:SetTexture(C.Assets.Textures.statusbar)
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
				self.Time:SetFormattedText(decimal, (self.casting and self.max + self.delay or self.max - self.delay) - duration)
			else
				self.Time:SetFormattedText(decimal, self.max - duration)
				if self.Lag and self.SafeZone and self.SafeZone.timeDiff and self.SafeZone.timeDiff ~= 0 then
					self.Lag:SetFormattedText('%d ms', self.SafeZone.timeDiff * 1000)
				end
			end
		else
			if duration > 1e4 then
				self.Time:SetText('∞')
			else
				self.Time:SetFormattedText(decimal, (self.casting and self.max + self.delay or self.max - self.delay) - duration)
			end
		end
		self.duration = duration
		self:SetValue(duration)
		if (not cfg.castbar_focus_separate and self.__owner.unit == 'focus') or (FreeUIConfig['unitframe']['layout'] == "HEALER" and self.__owner.unit == 'target') then
			self.Spark:SetPoint('CENTER', self, 'RIGHT', -((duration / self.max) * self:GetWidth()), 0)
		else
			self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
		end
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

	if self.Icon and not self.Icon:GetTexture() then
		self.Icon:SetTexture(136243)
	end

	if self.iconBg then
		if self.notInterruptible then
			self.iconBg:SetBackdropColor(unpack(self.notInterruptibleColor))
		else
			self.iconBg:SetBackdropColor(unpack(self.CastingColor))
		end
	end

	if self.iconGlow then
		if self.notInterruptible then
			self.iconGlow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .5)
		else
			self.iconGlow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .35)
		end
	end

	if self.Glow and not (cfg.castbar_focus_separate and self.unitStyle == 'focus') then
		if self.notInterruptible then
			self.Glow:SetBackdropBorderColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .35)
		else
			self.Glow:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .35)
		end
	end

	if cfg.castbar_focus_separate and self.__owner.unit == 'focus' then
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], 1)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], 1)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .6)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 1)
	else
		if self.notInterruptible then
			self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .4)
		else
			self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .4)
		end

		self.Bg:SetBackdropColor(0, 0, 0, .2)
		self.Bg:SetBackdropBorderColor(0, 0, 0, 0)
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


function UNITFRAME:AddCastBar(self)
	if not cfg.castbar then return end

	local castbar = CreateFrame('StatusBar', 'oUF_Castbar'..self.unitStyle, self)
	castbar:SetStatusBarTexture(C.Assets.Textures.statusbar)
	castbar:SetStatusBarColor(0, 0, 0, 0)
	castbar.Bg = F.CreateBDFrame(castbar)
	castbar.Glow = F.CreateSD(castbar.Bg, .35, 4, 4)

	if (not cfg.castbar_focus_separate and self.unitStyle == 'focus') or (FreeUIConfig['unitframe']['layout'] == "HEALER" and self.unitStyle == 'target') then
		castbar:SetFillStyle('REVERSE')
	end

	if self.unitStyle == 'focus' and cfg.castbar_focus_separate then
		castbar:SetSize(cfg.castbar_focus_width, cfg.castbar_focus_height)
		castbar:ClearAllPoints()
		
		F.Mover(castbar, L['MOVER_UNITFRAME_FOCUS_CASTBAR'], 'FocusCastbar', {'CENTER', UIParent, 'CENTER', 0, 200}, cfg.castbar_focus_width, cfg.castbar_focus_height)
	else
		castbar:SetAllPoints(self)
		castbar:SetFrameLevel(self.Health:GetFrameLevel() + 3)
		castbar:SetSize(self:GetWidth(), self:GetHeight())
	end

	self.Castbar = castbar

	local spark = castbar:CreateTexture(nil, 'OVERLAY')
	spark:SetBlendMode('ADD')
	spark:SetAlpha(.7)
	spark:SetSize(20, castbar:GetHeight() * 2)
	castbar.Spark = spark

	
	if cfg.castbar_timer then
		local timer = F.CreateFS(castbar, C.Assets.Fonts.Number, 11, 'OUTLINE')
		timer:SetPoint('CENTER', castbar)
		castbar.Time = timer
	end
	
	local iconFrame = CreateFrame('Frame', nil, castbar)
	if cfg.castbar_focus_separate and self.unitStyle == 'focus' then
		iconFrame:SetSize(castbar:GetHeight() + 4, castbar:GetHeight() + 4)
	else
		iconFrame:SetSize(castbar:GetHeight() + 6, castbar:GetHeight() + 6)
	end

	if (not cfg.castbar_focus_separate and self.unitStyle == 'focus') or (FreeUIConfig['unitframe']['layout'] == "HEALER" and self.unitStyle == 'target') then
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('LEFT', castbar, 'RIGHT', 4, 0)
	else
		iconFrame:ClearAllPoints()
		iconFrame:SetPoint('RIGHT', castbar, 'LEFT', -4, 0)
	end

	local icon = iconFrame:CreateTexture(nil, 'OVERLAY')
	icon:SetAllPoints(iconFrame)
	icon:SetTexCoord(unpack(C.TexCoord))
	castbar.Icon = icon
	castbar.iconBg = F.CreateBDFrame(iconFrame)
	castbar.iconGlow = F.CreateSD(iconFrame, .35, 4, 4)
	
	if self.unitStyle == 'player' then
		local safeZone = castbar:CreateTexture(nil,'OVERLAY')
		safeZone:SetTexture(C.Assets.Textures.backdrop)
		safeZone:SetVertexColor(223/255, 63/255, 107/255, .6)
		safeZone:SetPoint('TOPRIGHT')
		safeZone:SetPoint('BOTTOMRIGHT')
		castbar.SafeZone = safeZone
	end

	castbar.decimal = '%.1f'
	
	castbar.CastingColor = {110/255, 176/255, 216/255}
	castbar.ChannelingColor = {92/255, 193/255, 216/255}
	castbar.notInterruptibleColor = {190/255, 10/255, 18/255}
	castbar.CompleteColor = {63/255, 161/255, 124/255}
	castbar.FailColor = {187/255, 99/255, 110/255}

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