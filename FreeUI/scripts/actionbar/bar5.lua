local F, C = unpack(select(2, ...))
local Bar = F:GetModule("Actionbar")


function Bar:CreateBar5()
	local cfg = C.actionbar
	local buttonSize = cfg.buttonSizeSmall*C.Mult
	local padding = cfg.padding*C.Mult
	local margin = cfg.margin*C.Mult

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar5", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(buttonSize + 2*padding)
	frame:SetHeight(num*buttonSize + (num-1)*margin + 2*padding)
	frame:SetPoint("RIGHT", 'FreeUI_ActionBar4', "LEFT", 0, 0)
	frame:SetScale(1)

	--move the buttons into position and reparent them
	MultiBarLeft:SetParent(frame)
	MultiBarLeft:EnableMouse(false)
	hooksecurefunc(MultiBarLeft, "SetScale", function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, num do
		local button = _G["MultiBarLeftButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(buttonSize, buttonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("TOPRIGHT", frame, -padding, -padding)
		else
			local previous = _G["MultiBarLeftButton"..i-1]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		end
	end

	--show/hide the frame on a given state driver
	if not cfg.sideBar then
		frame.frameVisibility = "hide"
	else
		frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	end
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create the mouseover functionality
	if cfg.sideBar and cfg.sideBarMouseover then
		F.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end