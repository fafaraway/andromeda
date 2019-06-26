local F, C = unpack(select(2, ...))
local Bar = F:GetModule('Actionbar')


function Bar:CreateBar4()
	local cfg = C.actionbar
	local buttonSize = cfg.buttonSizeSmall*C.Mult
	local padding = cfg.padding*C.Mult
	local margin = cfg.margin*C.Mult

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar4', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(buttonSize + 2*padding)
	frame:SetHeight(num*buttonSize + (num-1)*margin + 2*padding)
	frame:SetPoint('RIGHT', UIParent, 'RIGHT', -4, 0)
	frame:SetScale(1)

	--move the buttons into position and reparent them
	MultiBarRight:SetParent(frame)
	MultiBarRight:EnableMouse(false)
	hooksecurefunc(MultiBarRight, 'SetScale', function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, num do
		local button = _G['MultiBarRightButton'..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(buttonSize, buttonSize)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarRightButton'..i-1]
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		end

	end

	--show/hide the frame on a given state driver
	if not cfg.sideBar then
		frame.frameVisibility = 'hide'
	else
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	--create the mouseover functionality
	if cfg.sideBar and cfg.sideBarMouseover then
		F.CreateButtonFrameFader(frame, buttonList, F.fader)
	end

	--fix annoying visibility
	local function updateVisibility(event)
		if InCombatLockdown() then
			F:RegisterEvent('PLAYER_REGEN_ENABLED', updateVisibility)
		else
			InterfaceOptions_UpdateMultiActionBars()
			F:UnregisterEvent(event, updateVisibility)
		end
	end
	F:RegisterEvent('UNIT_EXITING_VEHICLE', updateVisibility)
	F:RegisterEvent('UNIT_EXITED_VEHICLE', updateVisibility)
	F:RegisterEvent('PET_BATTLE_CLOSE', updateVisibility)
	F:RegisterEvent('PET_BATTLE_OVER', updateVisibility)
end