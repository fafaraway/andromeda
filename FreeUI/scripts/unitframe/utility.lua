local _, ns = ...
local F, C, L = unpack(select(2, ...))

if not C.unitframe.enable then return end

local module = F:RegisterModule('Unitframe')
local cfg, oUF = C.unitframe, ns.oUF



oUF.colors.power.MANA = {111/255, 185/255, 237/255}
oUF.colors.power.ENERGY = {1, 222/255, 80/255}
oUF.colors.power.FURY = { 54/255, 199/255, 63/255 }
oUF.colors.power.PAIN = { 255/255, 156/255, 0 }

oUF.colors.runes = {
	{151/255, 25/255, 0}, 			-- Blood
	{193/255, 219/255, 233/255}, 	-- Frost
	{98/255, 153/255, 51/255}, 		-- Unholy
}

oUF.colors.debuffType = {
	Curse = {.8, 0, 1},
	Disease = {.8, .6, 0},
	Magic = {0, .8, 1},
	Poison = {0, .8, 0},
	none = {0, 0, 0}
}

oUF.colors.reaction = {
	[1] = {255/255, 81/255, 74/255}, 	-- Exceptionally hostile
	[2] = {255/255, 81/255, 74/255}, 	-- Very Hostile

	[3] = {255/255, 81/255, 74/255}, 	-- Hostile
	[4] = {255/255, 236/255, 121/255}, 	-- Neutral
	[5] = {87/255, 255/255, 93/255}, 	-- Friendly

	[6] = {87/255, 255/255, 93/255}, 	-- Very Friendly
	[7] = {87/255, 255/255, 93/255}, 	-- Exceptionally friendly
	[8] = {87/255, 255/255, 93/255}, 	-- Exalted
}






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



function module:AddBackDrop(self)
	local highlight = self:CreateTexture(nil, 'OVERLAY')
	highlight:SetAllPoints()
	highlight:SetTexture('Interface\\PETBATTLES\\PetBattle-SelectedPetGlow')
	highlight:SetTexCoord(0, 1, .5, 1)
	highlight:SetVertexColor(.6, .6, .6)
	highlight:SetBlendMode('ADD')
	highlight:Hide()

	self:RegisterForClicks('AnyUp')
	self:HookScript('OnEnter', function()
		UnitFrame_OnEnter(self)
		highlight:Show()
	end)
	self:HookScript('OnLeave', function()
		UnitFrame_OnLeave(self)
		highlight:Hide()
	end)

	self.Highlight = highlight

	local bg = F.CreateBDFrame(self, 0.2)
	self.Bg = bg

	local glow = F.CreateSD(self.Bg, .35, 3, 3)
	self.Glow = glow
end


local function UpdateSelectedBorder(self)
	if UnitIsUnit('target', self.unit) then
		self.Border:Show()
	else
		self.Border:Hide()
	end
end

function module:AddSelectedBorder(self)
	local border = F.CreateBDFrame(self.Bg)
	border:SetBackdropBorderColor(1, 1, 1, 1)
	border:Hide()

	self.Border = border
	self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateSelectedBorder, true)
	self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateSelectedBorder, true)
end


function module:FormatTime(s)
	local day, hour, minute = 86400, 3600, 60

	if s >= day then
		return format('%d', F.Round(s/day))
	elseif s >= hour then
		return format('%d', F.Round(s/hour))
	elseif s >= minute then
		return format('%d', F.Round(s/minute))
	end
	return format('%d', mod(s, minute))
end