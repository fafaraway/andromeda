local F, C = unpack(select(2, ...))
local MISC, cfg = F:GetModule('Misc'), C.General


local LFGTimer = CreateFrame('Frame', nil, _G.LFGDungeonReadyDialog)
_G.LFGDungeonReadyDialog.nextUpdate = 0

local function updateLFGTimer()
	if not LFGTimer.bar then
		LFGTimer:SetPoint('BOTTOMLEFT')
		LFGTimer:SetPoint('BOTTOMRIGHT')
		LFGTimer:SetHeight(3)

		LFGTimer.bar = CreateFrame('StatusBar', nil, LFGTimer)
		LFGTimer.bar:SetStatusBarTexture(C.Assets.Textures.statusbar)
		LFGTimer.bar:SetPoint('TOPLEFT', C.Mult, -C.Mult)
		LFGTimer.bar:SetPoint('BOTTOMLEFT', -C.Mult, C.Mult)
		LFGTimer.bar:SetFrameLevel(_G.LFGDungeonReadyDialog:GetFrameLevel() + 1)
		LFGTimer.bar:SetStatusBarColor(C.r, C.g, C.b)
	end

	local obj = _G.LFGDungeonReadyDialog
	local oldTime = _G.GetTime()
	local flag = 0
	local duration = 40
	local interval = 0.1
	obj:SetScript('OnUpdate', function(self, elapsed)
		obj.nextUpdate = obj.nextUpdate + elapsed
		if obj.nextUpdate > interval then
			local newTime = _G.GetTime()
			if (newTime - oldTime) < duration then
				local width = LFGTimer:GetWidth() * (newTime - oldTime) / duration
				LFGTimer.bar:SetPoint('BOTTOMRIGHT', LFGTimer, 0 - width, 0)
				flag = flag + 1
				if flag >= 10 then
					flag = 0
				end
			else
				obj:SetScript('OnUpdate', nil)
			end
			obj.nextUpdate = 0
		end
	end)
end

local PVPTimer = CreateFrame('Frame', nil, _G.PVPReadyDialog)
_G.PVPReadyDialog.nextUpdate = 0

local function UpdatePVPTimer()
	if not PVPTimer.bar then
		PVPTimer:SetPoint('BOTTOMLEFT')
		PVPTimer:SetPoint('BOTTOMRIGHT')
		PVPTimer:SetHeight(3)

		PVPTimer.bar = CreateFrame('StatusBar', nil, PVPTimer)
		PVPTimer.bar:SetStatusBarTexture(C.Assets.Textures.statusbar)
		PVPTimer.bar:SetPoint('TOPLEFT', C.Mult, -C.Mult)
		PVPTimer.bar:SetPoint('BOTTOMLEFT', -C.Mult, C.Mult)
		PVPTimer.bar:SetFrameLevel(_G.PVPReadyDialog:GetFrameLevel() + 1)
		PVPTimer.bar:SetStatusBarColor(C.r, C.g, C.b)
	end

	local obj = _G.PVPReadyDialog
	local oldTime = _G.GetTime()
	local flag = 0
	local duration = 90
	local interval = 0.1
	obj:SetScript('OnUpdate', function(self, elapsed)
		obj.nextUpdate = obj.nextUpdate + elapsed
		if obj.nextUpdate > interval then
			local newTime = GetTime()
			if (newTime - oldTime) < duration then
				local width = PVPTimer:GetWidth() * (newTime - oldTime) / duration
				PVPTimer.bar:SetPoint('BOTTOMRIGHT', PVPTimer, 0 - width, 0)
				flag = flag + 1
				if flag >= 10 then
					flag = 0
				end
			else
				obj:SetScript('OnUpdate', nil)
			end
			obj.nextUpdate = 0
		end
	end)
end

function MISC:QueueTimer()
	if not cfg.queue_timer then return end

	LFGTimer:RegisterEvent('LFG_PROPOSAL_SHOW')
	LFGTimer:SetScript('OnEvent', function(self)
		if _G.LFGDungeonReadyDialog:IsShown() then
			updateLFGTimer()
		end
	end)

	PVPTimer:RegisterEvent('UPDATE_BATTLEFIELD_STATUS')
	PVPTimer:SetScript('OnEvent', function(self)
		if _G.PVPReadyDialog:IsShown() then
			UpdatePVPTimer()
		end
	end)
end

MISC:RegisterMisc('QueueTimer', MISC.QueueTimer)
