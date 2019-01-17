local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbar

function Bar:CreateBar4()

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar4", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(cfg.buttonSizeSmall + 2*cfg.padding)
	frame:SetHeight(num*cfg.buttonSizeSmall + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetPoint("RIGHT", UIParent, "RIGHT", -4, 0)
	frame:SetScale(1)

	--move the buttons into position and reparent them
	MultiBarRight:SetParent(frame)
	MultiBarRight:EnableMouse(false)
	hooksecurefunc(MultiBarRight, "SetScale", function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, num do
		local button = _G["MultiBarRightButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.buttonSizeSmall, cfg.buttonSizeSmall)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("TOPRIGHT", frame, -cfg.padding, -cfg.padding)
		else
			local previous = _G["MultiBarRightButton"..i-1]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -cfg.margin)
		end

	end

	--show/hide the frame on a given state driver
	if not cfg.sideBarEnable then
		frame.frameVisibility = "hide"
	else
		frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	end
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create the mouseover functionality
	if cfg.sideBarEnable and cfg.sideBarFade then
		F.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	--fix annoying visibility
	local function updateVisibility(event)
		if InCombatLockdown() then
			F:RegisterEvent("PLAYER_REGEN_ENABLED", updateVisibility)
		else
			InterfaceOptions_UpdateMultiActionBars()
			F:UnregisterEvent(event, updateVisibility)
		end
	end
	F:RegisterEvent("UNIT_EXITING_VEHICLE", updateVisibility)
	F:RegisterEvent("UNIT_EXITED_VEHICLE", updateVisibility)
	F:RegisterEvent("PET_BATTLE_CLOSE", updateVisibility)
	F:RegisterEvent("PET_BATTLE_OVER", updateVisibility)
end