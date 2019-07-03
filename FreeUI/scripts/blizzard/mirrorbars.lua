local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')


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
		local bar = CreateFrame('StatusBar', nil, UIParent)

		bar:SetScript('OnUpdate', OnUpdate)

		local r, g, b = unpack(colors[type])

		bar.bg = F.CreateBDFrame(bar)
		bar.glow = F.CreateSD(bar.bg)

		local text = bar:CreateFontString(nil, 'OVERLAY')
		--text:SetFont(C.font.normal, 12, 'OUTLINE')
		text:SetJustifyH('CENTER')
		--text:SetShadowOffset(0, 0)
		text:SetTextColor(1, 1, 1)
		F.SetFS(text, C.isCNClient)

		text:SetPoint('LEFT', bar)
		text:SetPoint('RIGHT', bar)
		text:SetPoint('TOP', bar, 0, 1)
		text:SetPoint('BOTTOM', bar)

		bar:SetSize(200, 20)

		bar:SetStatusBarTexture(C.media.sbTex)
		bar:SetStatusBarColor(r, g, b)

		bar.type = type
		bar.text = text

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

function f:ADDON_LOADED(addon)
	if addon == 'FreeUI' then
		UIParent:UnregisterEvent('MIRROR_TIMER_START')

		self:UnregisterEvent('ADDON_LOADED')
		self.ADDON_LOADED = nil
	end
end

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

f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:RegisterEvent('MIRROR_TIMER_START')
f:RegisterEvent('MIRROR_TIMER_STOP')
f:RegisterEvent('MIRROR_TIMER_PAUSE')
