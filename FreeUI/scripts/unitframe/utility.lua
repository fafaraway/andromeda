local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module = F:RegisterModule('Unitframe')
local cfg = C.unitframe
local oUF = ns.oUF


if cfg.enableGroup then
	if IsAddOnLoaded('Blizzard_CompactRaidFrames') then
		CompactRaidFrameManager:SetParent(FreeUIHider)
		CompactUnitFrameProfiles:UnregisterAllEvents()
	end
end


local function reskinTimerBar(bar)
	bar:SetSize(200, 20)
	F.StripTextures(bar)

	local statusbar = _G[bar:GetName()..'StatusBar']
	if statusbar then
		statusbar:SetAllPoints()
		statusbar:SetStatusBarTexture(C.media.sbTex)
	else
		bar:SetStatusBarTexture(C.media.backdrop)
	end

	local text = _G[bar:GetName()..'Text']
	if text then
		text:ClearAllPoints()
		text:SetPoint('CENTER')
	end

	local bg = F.CreateBDFrame(bar)
	F.CreateSD(bg, .35, 4, 4)
end

function module:ReskinMirrorBars()
	local previous
	for i = 1, 3 do
		local bar = _G['MirrorTimer'..i]
		reskinTimerBar(bar)

		if previous then
			bar:SetPoint('TOP', previous, 'BOTTOM', 0, -5)
		end
		previous = bar
	end
end

function module:ReskinTimerTrakcer(self)
	local function updateTimerTracker()
		for _, timer in pairs(TimerTracker.timerList) do
			if timer.bar and not timer.bar.styled then
				reskinTimerBar(timer.bar)

				timer.bar.styled = true
			end
		end
	end
	self:RegisterEvent('START_TIMER', updateTimerTracker, true)
end


function module:createBarMover(bar, text, value, anchor)
	local mover = F.Mover(bar, text, value, anchor, bar:GetHeight()+bar:GetWidth()+5, bar:GetHeight()+5)
	bar:ClearAllPoints()
	bar:SetPoint('RIGHT', mover)
end


local handler = CreateFrame('Frame')
handler:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

function handler:MODIFIER_STATE_CHANGED(key, state)
	if (key ~= 'RALT') then return end

	for _, object in next, oUF.objects do
		local unit = object.realUnit or object.unit
		if (unit == 'target') then
			local auras = object.Auras
			if (state == 1) then
				auras.CustomFilter = nil
			else
				auras.CustomFilter = module.CustomFilter
			end
			auras:ForceUpdate()
			break
		end
	end
end

function handler:PLAYER_ENTERING_WORLD()
	self:RegisterEvent('PLAYER_REGEN_DISABLED')
	self:RegisterEvent('PLAYER_REGEN_ENABLED')
	if (InCombatLockdown()) then
		self:PLAYER_REGEN_DISABLED()
	else
		self:PLAYER_REGEN_ENABLED()
	end
end
handler:RegisterEvent('PLAYER_ENTERING_WORLD')

function handler:PLAYER_REGEN_DISABLED()
	self:UnregisterEvent('MODIFIER_STATE_CHANGED')
end

function handler:PLAYER_REGEN_ENABLED()
	self:RegisterEvent('MODIFIER_STATE_CHANGED')
end

function handler:PLAYER_TARGET_CHANGED()
	if (UnitExists('target')) then
		if (UnitIsEnemy('target', 'player')) then
			PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
		elseif (UnitIsFriend('target', 'player')) then
			PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
		else
			PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
		end
	else
		PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
	end
end

function handler:PLAYER_FOCUS_CHANGED()
	if UnitExists('focus') then
		if UnitIsEnemy('focus', 'player') then
			PlaySound(SOUNDKIT.IG_CREATURE_AGGRO_SELECT)
		elseif UnitIsFriend('player', 'focus') then
			PlaySound(SOUNDKIT.IG_CHARACTER_NPC_SELECT)
		else
			PlaySound(SOUNDKIT.IG_CREATURE_NEUTRAL_SELECT)
		end
	else
		PlaySound(SOUNDKIT.INTERFACE_SOUND_LOST_TARGET_UNIT)
	end
end

local announcedPVP
function handler:UNIT_FACTION(unit, ...)
	if unit ~= 'player' then return end

	if UnitIsPVPFreeForAll('player') or UnitIsPVP('player') then
		if not announcedPVP then
			announcedPVP = true
			PlaySound(SOUNDKIT.IG_PVP_UPDATE)
		end
	else
		announcedPVP = nil
	end
end

handler:RegisterEvent('PLAYER_TARGET_CHANGED')
handler:RegisterEvent('PLAYER_FOCUS_CHANGED')
handler:RegisterEvent('UNIT_FACTION')