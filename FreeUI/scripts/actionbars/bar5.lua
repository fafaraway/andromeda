local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbars.bar5

function Bar:CreateBar5()
	local padding, margin = 2, 2
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = C.actionbars.layout

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar5", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(cfg.size + 2*padding)
	frame:SetHeight(num*cfg.size + (num-1)*margin + 2*padding)
	if layout == 1 or layout == 4 or layout == 5 then
		frame.Pos = {"RIGHT", UIParent, "RIGHT", -(frame:GetWidth()-1), 0}
	else
		frame.Pos = {"RIGHT", UIParent, "RIGHT", -1, 0}
	end
	frame:SetScale(cfg.scale)

	--move the buttons into position and reparent them
	MultiBarLeft:SetParent(frame)
	MultiBarLeft:EnableMouse(false)
	hooksecurefunc(MultiBarLeft, "SetScale", function(self, scale)
		if scale < 1 then self:SetScale(1) end
	end)

	for i = 1, num do
		local button = _G["MultiBarLeftButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("TOPRIGHT", frame, -padding, -padding)
		else
			local previous = _G["MultiBarLeftButton"..i-1]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)



	--create the mouseover functionality
	if cfg.fader then
		F.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end