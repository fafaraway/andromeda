local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ACTIONBAR')


local barsList = {
	'FreeUI_ActionBar1',
	'FreeUI_ActionBar2',
	'FreeUI_ActionBar3',
	'FreeUI_ActionBar4',
	'FreeUI_ActionBar5',
	'FreeUI_CustomBar',
	'FreeUI_ActionBarPet',
	'FreeUI_ActionBarStance',
}

function ACTIONBAR:FadeBlingTexture(cooldown, alpha)
	if not cooldown then return end
	cooldown:SetBlingTexture(alpha > 0.5 and 131010 or C.Assets.blank_tex)
end

function ACTIONBAR:FadeBlings(alpha)
	for _, button in pairs(ACTIONBAR.buttons) do
		ACTIONBAR:FadeBlingTexture(button.cooldown, alpha)
	end
end

function ACTIONBAR:Bar_OnEnter()
	if not ACTIONBAR.fadeParent.mouseLock then
		F:UIFrameFadeIn(ACTIONBAR.fadeParent, ACTIONBAR.fadeInDuration, ACTIONBAR.fadeParent:GetAlpha(), ACTIONBAR.fadeInAlpha)
		ACTIONBAR:FadeBlings(ACTIONBAR.fadeInAlpha)
	end
end

function ACTIONBAR:Bar_OnLeave()
	if not ACTIONBAR.fadeParent.mouseLock then
		F:UIFrameFadeOut(ACTIONBAR.fadeParent, ACTIONBAR.fadeOutDuration, ACTIONBAR.fadeParent:GetAlpha(), ACTIONBAR.fadeOutAlpha)
		ACTIONBAR:FadeBlings(ACTIONBAR.fadeOutAlpha)
	end
end

function ACTIONBAR:FadeParent_OnEvent()
	local inInstance, instanceType = IsInInstance()

	if (UnitAffectingCombat('player') and C.DB.actionbar.condition_combating)
	or ((UnitExists('target') or UnitExists('focus')) and C.DB.actionbar.condition_targeting)
	or ((instanceType == 'pvp' or instanceType == 'arena') and C.DB.actionbar.condition_pvp)
	or ((instanceType == 'party' or instanceType == 'raid') and C.DB.actionbar.condition_dungeon)
	or (UnitHasVehicleUI('player') and C.DB.actionbar.condition_vehicle) then
		self.mouseLock = true
		F:UIFrameFadeIn(self, ACTIONBAR.fadeInDuration, self:GetAlpha(), ACTIONBAR.fadeInAlpha)
		ACTIONBAR:FadeBlings(ACTIONBAR.fadeInAlpha)
	else
		self.mouseLock = false
		F:UIFrameFadeOut(self, ACTIONBAR.fadeOutDuration, self:GetAlpha(), ACTIONBAR.fadeOutAlpha)
		ACTIONBAR:FadeBlings(ACTIONBAR.fadeOutAlpha)
	end
end

function ACTIONBAR:HookActionBar()
	for _, v in pairs(barsList) do
		local bar = _G[v]
		if bar then
			bar:SetParent(ACTIONBAR.fadeParent)
			bar:HookScript('OnEnter', ACTIONBAR.Bar_OnEnter)
			bar:HookScript('OnLeave', ACTIONBAR.Bar_OnLeave)
		end
	end

	for _, button in pairs(ACTIONBAR.buttons) do
		button:HookScript('OnEnter', ACTIONBAR.Bar_OnEnter)
		button:HookScript('OnLeave', ACTIONBAR.Bar_OnLeave)
	end
end

function ACTIONBAR:UpdateActionBarFade()
	if not C.DB.actionbar.fade then return end

	ACTIONBAR.fadeOutAlpha = C.DB.actionbar.fade_out_alpha or 0
	ACTIONBAR.fadeInAlpha = C.DB.actionbar.fade_in_alpha or 1
	ACTIONBAR.fadeInDuration = C.DB.actionbar.fade_in_duration or .3
	ACTIONBAR.fadeOutDuration = C.DB.actionbar.fade_out_duration or .3

	ACTIONBAR.fadeParent = CreateFrame('Frame', nil, _G.UIParent)
	ACTIONBAR.fadeParent:SetAlpha(ACTIONBAR.fadeOutAlpha)
	ACTIONBAR.fadeParent:SetScript('OnEvent', ACTIONBAR.FadeParent_OnEvent)

	if C.DB.actionbar.condition_combating then
		ACTIONBAR.fadeParent:RegisterEvent('PLAYER_REGEN_DISABLED')
		ACTIONBAR.fadeParent:RegisterEvent('PLAYER_REGEN_ENABLED')
	end

	if C.DB.actionbar.condition_targeting then
		ACTIONBAR.fadeParent:RegisterEvent('PLAYER_TARGET_CHANGED')
		ACTIONBAR.fadeParent:RegisterEvent('PLAYER_FOCUS_CHANGED')
	end

	if C.DB.actionbar.condition_dungeon or C.DB.actionbar.condition_pvp then
		ACTIONBAR.fadeParent:RegisterEvent('PLAYER_ENTERING_WORLD')
		ACTIONBAR.fadeParent:RegisterEvent('ZONE_CHANGED_NEW_AREA')
	end

	if C.DB.actionbar.condition_vehicle then
		ACTIONBAR.fadeParent:RegisterEvent('UNIT_ENTERED_VEHICLE')
		ACTIONBAR.fadeParent:RegisterEvent('UNIT_EXITED_VEHICLE')
		ACTIONBAR.fadeParent:RegisterEvent('VEHICLE_UPDATE')
	end

	ACTIONBAR.HookActionBar()
end
