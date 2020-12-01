local F, C, L = unpack(select(2, ...))
local COMBAT = F:GetModule('COMBAT')


local _G = getfenv(0)
local next, strmatch = next, string.match
local InCombatLockdown = InCombatLockdown

local modifier = 'shift' -- shift, alt or ctrl
local mouseButton = '1' -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any
local pending = {}

function COMBAT:Focuser_Setup()
	if not self or self.focuser then return end
	if self:GetName() and (not C.DB.combat.easy_focus_on_unitframes and strmatch(self:GetName(), 'oUF_')) then return end

	if not InCombatLockdown() then
		self:SetAttribute(modifier..'-type'..mouseButton, 'focus')
		self.focuser = true
		pending[self] = nil
	else
		pending[self] = true
	end
end

function COMBAT:Focuser_CreateFrameHook(name, _, template)
	if name and template == 'SecureUnitButtonTemplate' then
		COMBAT.Focuser_Setup(_G[name])
	end
end

function COMBAT.Focuser_OnEvent(event)
	if event == 'PLAYER_REGEN_ENABLED' then
		if next(pending) then
			for frame in next, pending do
				COMBAT.Focuser_Setup(frame)
			end
		end
	else
		for _, object in next, F.oUF.objects do
			if not object.focuser then
				COMBAT.Focuser_Setup(object)
			end
		end
	end
end


function COMBAT:Focuser()
	if not C.DB.combat.easy_focus then return end

	-- Keybinding override so that models can be shift/alt/ctrl+clicked
	local f = CreateFrame('CheckButton', 'FocuserButton', UIParent, 'SecureActionButtonTemplate')
	f:SetAttribute('type1', 'macro')
	f:SetAttribute('macrotext', '/focus mouseover')
	SetOverrideBindingClick(FocuserButton, true, modifier..'-BUTTON'..mouseButton, 'FocuserButton')

	hooksecurefunc('CreateFrame', COMBAT.Focuser_CreateFrameHook)

	COMBAT:Focuser_OnEvent()
	F:RegisterEvent('PLAYER_REGEN_ENABLED', COMBAT.Focuser_OnEvent)
	F:RegisterEvent('GROUP_ROSTER_UPDATE', COMBAT.Focuser_OnEvent)
end
