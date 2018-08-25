local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")

local scripts = {
	"OnShow", "OnHide", "OnEvent", "OnEnter", "OnLeave", "OnUpdate", "OnValueChanged", "OnClick", "OnMouseDown", "OnMouseUp",
}

local framesToHide = {
	MainMenuBar, OverrideActionBar,
}

local framesToDisable = {
	MainMenuBar,
	MicroButtonAndBagsBar, MainMenuBarArtFrame, StatusTrackingBarManager,
	ActionBarDownButton, ActionBarUpButton, MainMenuBarVehicleLeaveButton,
	OverrideActionBar,
	OverrideActionBarExpBar, OverrideActionBarHealthBar, OverrideActionBarPowerBar, OverrideActionBarPitchFrame,
}

local frameToIgnore = {
	MainMenuBar, PetActionBarFrame
}

local function DisableAllScripts(frame)
	for _, script in next, scripts do
		if frame:HasScript(script) then
			frame:SetScript(script, nil)
		end
	end
end

function Bar:HideBlizz()
	for _, frame in next, frameToIgnore do
		frame.ignoreFramePositionManager = true
		frame:SetAttribute("ignoreFramePositionManager", true)
	end

	for _, frame in next, framesToHide do
		frame:SetParent(F.HiddenFrame)
	end

	for _, frame in next, framesToDisable do
		frame:UnregisterAllEvents()
		DisableAllScripts(frame)
	end
end

-- fix blizzard cooldown flash
local function FixCooldownFlash(self)
	if not self then return end
	if self:GetEffectiveAlpha() > 0 then
		self:Show()
	else
		self:Hide()
	end
end
hooksecurefunc(getmetatable(ActionButton1Cooldown).__index, "SetCooldown", FixCooldownFlash)