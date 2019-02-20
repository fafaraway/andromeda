local F, C = unpack(select(2, ...))
local _, ns = ...

local cast = CreateFrame("Frame")
local channelingTicks = {
	-- warlock
	[GetSpellInfo(755)] = 3,		-- health funnel
	[GetSpellInfo(198590)] = 5,		-- drain soul
	[GetSpellInfo(234153)] = 5,		-- drain life
	-- druid
	[GetSpellInfo(740)] = 4,		-- Tranquility
	-- priest
	[GetSpellInfo(15407)] = 4,		-- mind flay
	[GetSpellInfo(47540)] = 3,		-- penance
	[GetSpellInfo(64843)] = 4,		-- divine hymn
	[GetSpellInfo(205065)] = 6,
	-- mage
	[GetSpellInfo(5143)] = 5, 		-- arcane missiles
	[GetSpellInfo(12051)] = 3, 		-- evocation
	[GetSpellInfo(205021)] = 5,
}

if C.Class == "PRIEST" then
	local penance = GetSpellInfo(47540)
	local function updateTicks()
		local numTicks = 3
		if IsPlayerSpell(193134) then numTicks = 4 end	-- Enhanced Mind Flay
		channelingTicks[penance] = numTicks
	end
	F:RegisterEvent("PLAYER_LOGIN", updateTicks)
	F:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", updateTicks)
end

local ticks = {}
local function setBarTicks(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, "OVERLAY")
				ticks[k]:SetTexture(C.media.backdrop)
				ticks[k]:SetVertexColor(0, 0, 0, .7)
				ticks[k]:SetWidth(C.Mult)
				ticks[k]:SetHeight(castBar:GetHeight())
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for _, v in pairs(ticks) do
			v:Hide()
		end
	end
end

cast.OnCastbarUpdate = function(self, elapsed)
	--if not self.Lag then self.Lag = 0 end
	if GetNetStats() == 0 then return end

	if self.casting or self.channeling then
		local unitStyle = self.__owner.unitStyle
		local decimal = "%.2f"
		if unitStyle == "nameplate" or unitStyle == "boss" or unitStyle == "arena" then decimal = "%.1f" end

		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end

		if self.__owner.unit == "player" then
			if self.delay ~= 0 then
				self.Time:SetFormattedText(decimal.." | |cffff0000"..decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText(decimal.." | "..decimal, duration, self.max)
				--if self.SafeZone and self.SafeZone.timeDiff ~= 0 then self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000) end
			end
		else
			if duration > 1e4 then
				self.Time:SetText("∞ | ∞")
			else
				self.Time:SetFormattedText(decimal.." | "..decimal, duration, self.casting and self.max + self.delay or self.max - self.delay)
			end
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
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

cast.OnCastSent = function(self)
	if not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
	self.Castbar.SafeZone.castSent = true
end

cast.PostCastStart = function(self, unit)
	self:SetAlpha(1)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))

	if unit == "vehicle" then 
		self.SafeZone:Hide()
		--self.Lag:Hide()
	elseif unit == "player" then
		if GetNetStats() == 0 then return end
		local sf = self.SafeZone
		if not sf then return end

		sf.timeDiff = 0
		if sf.castSent == true then
			sf.timeDiff = GetTime() - sf.sendTime
			sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
			sf:SetWidth(self:GetWidth() * (sf.timeDiff + .001) / self.max)
			sf:Show()
			sf.castSent = false
		end

		--self.Lag:SetText("")
		if not UnitInVehicle("player") then
			sf:Show()
			--self.Lag:Show()
		else
			sf:Hide()
			--self.Lag:Hide()
		end

		if self.casting then
			setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			setBarTicks(self, self.channelingTicks)
		end
	elseif self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	end

	-- Fix for empty icon
	if self.Icon and not self.Icon:GetTexture() then
		self.Icon:SetTexture(136243)
	end

	if self.iconBG then
		if self.notInterruptible then
			self.iconBG:SetVertexColor(1, 0, 0)
		else
			self.iconBG:SetVertexColor(1, 1, 1)
		end
	end

	if self.iconSD then
		if self.notInterruptible then
			self.iconSD:SetBackdropBorderColor(1, 0, 0, .65)
		else
			self.iconSD:SetBackdropBorderColor(0, 0, 0, .35)
		end
	end

	if (unit == "target" and not C.unitframe.cbSeparate_target) or (unit == "player" and not C.unitframe.cbSeparate_player) then
		if self.notInterruptible then
			self.bg:SetBackdropBorderColor(1, 0, 0)
			self.sd:SetBackdropBorderColor(1, 0, 0, .5)
		else
			self.bg:SetBackdropBorderColor(0, 0, 0)
			self.sd:SetBackdropBorderColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .5)
		end
	end

	if (unit == "target" and C.unitframe.cbSeparate_target) or (unit == "player" and C.unitframe.cbSeparate_player) then
		self.bg:SetBackdropColor(0, 0, 0, .6)
	else
		self.bg:SetBackdropColor(0, 0, 0, .2)
	end

	if unit == "pet" 
		or unit:find("boss%d") or unit:find("arena%d") 
		or (unit == "player" and not C.unitframe.cbSeparate_player) 
		or (unit == "target" and not C.unitframe.cbSeparate_target) 
		or unit == "focus" 
		or (UnitInVehicle("player") and unit == "vehicle" and not C.unitframe.cbSeparate_player) then
			if self.notInterruptible then
				self:SetStatusBarColor(self.notInterruptibleColor[1], self.notInterruptibleColor[2], self.notInterruptibleColor[3], .4)
			else
				self:SetStatusBarColor(self.CastingColor[1], self.CastingColor[2], self.CastingColor[3], .4)
			end
	elseif (unit == "player" and C.unitframe.cbSeparate_player) then
		self:SetStatusBarColor(C.r, C.g, C.b, 1)
	end
end

cast.PostUpdateInterruptible = function(self, unit)
	if self.notInterruptible then
		self:SetStatusBarColor(unpack(self.notInterruptibleColor))
	else
		self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	end
end

cast.PostCastStop = function(self)
	if not self.fadeOut then 
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
end

cast.PostChannelStop = function(self)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end

cast.PostCastFailed = function(self)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	self.fadeOut = true
	self:Show()
end

ns.cast = cast