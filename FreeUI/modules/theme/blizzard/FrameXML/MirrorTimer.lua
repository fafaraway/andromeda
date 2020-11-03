local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	UIParent:UnregisterEvent('MIRROR_TIMER_START')

	local position = {
		['BREATH'] = 'TOP#UIParent#TOP#0#-96';
		['EXHAUSTION'] = 'TOP#UIParent#TOP#0#-116';
		['FEIGNDEATH'] = 'TOP#UIParent#TOP#0#-142';
	}

	local colors = {
		EXHAUSTION = {1, 0.9, 0};
		BREATH = {86/255, 147/255, 205/255};
		DEATH = {1, 0.7, 0};
		FEIGNDEATH = {1, 0.7, 0};
	}

	local Spawn, PauseAll
	do
		local barPool = {}

		local loadPosition = function(self)
			local pos = position[self.type]
			local p1, bar, p2, x, y = strsplit('#', pos)

			return self:SetPoint(p1, bar, p2, x, y)
		end

		local OnUpdate = function(self)
			if self.paused then return end

			self:SetValue(GetMirrorTimerProgress(self.type) / 1e3)
		end

		local Start = function(self, value, maxvalue, _, paused, text)
			if paused > 0 then
				self.paused = 1
			elseif self.paused then
				self.paused = nil
			end

			self.text:SetText(text)

			self:SetMinMaxValues(0, maxvalue / 1e3)
			self:SetValue(value / 1e3)

			if not self:IsShown() then self:Show() end
		end

		function Spawn(type)
			if barPool[type] then return barPool[type] end

			local r, g, b = unpack(colors[type])
			local bar = CreateFrame('StatusBar', nil, UIParent)
			bar:SetSize(200, 20)
			bar:SetStatusBarTexture(C.Assets.norm_tex)
			bar:SetStatusBarColor(r, g, b)
			bar:SetScript('OnUpdate', OnUpdate)

			bar.text = F.CreateFS(bar, C.Assets.Fonts.Regular, 12, nil, '', nil, 'THICK', 'CENTER', 0, 0)
			bar.bg = F.SetBD(bar)
			bar.type = type
			bar.Start = Start
			bar.Stop = Stop

			loadPosition(bar)

			barPool[type] = bar
			return bar
		end

		function PauseAll(val)
			for _, bar in next, barPool do
				bar.paused = val
			end
		end
	end


	local f = CreateFrame('Frame')
	f:SetScript('OnEvent', function(self, event, ...)
		return self[event](self, ...)
	end)

	function f:PLAYER_ENTERING_WORLD()
		for i = 1, MIRRORTIMER_NUMTIMERS do
			local type, value, maxvalue, scale, paused, text = GetMirrorTimerInfo(i)
			if type ~= 'UNKNOWN' then
				Spawn(type):Start(value, maxvalue, scale, paused, text)
			end
		end
	end

	function f:MIRROR_TIMER_START(type, value, maxvalue, scale, paused, text)
		return Spawn(type):Start(value, maxvalue, scale, paused, text)
	end

	function f:MIRROR_TIMER_STOP(type)
		return Spawn(type):Hide()
	end

	function f:MIRROR_TIMER_PAUSE(duration)
		return PauseAll((duration > 0 and duration) or nil)
	end

	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:RegisterEvent('MIRROR_TIMER_START')
	f:RegisterEvent('MIRROR_TIMER_STOP')
	f:RegisterEvent('MIRROR_TIMER_PAUSE')
end)
