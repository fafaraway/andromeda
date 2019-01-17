local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbar

function Bar:CreateBar2()

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar2", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.buttonSizeNormal + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetHeight(cfg.buttonSizeNormal + 2*cfg.padding)
	frame:SetPoint("BOTTOM", 'FreeUI_ActionBar1', "TOP", 0, 0)
	frame:SetScale(1)

	--move the buttons into position and reparent them
	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)

	for i = 1, num do
		local button = _G["MultiBarBottomLeftButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.buttonSizeNormal, cfg.buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	if cfg.layoutSimple then
		frame.frameVisibility = "[mod:shift] show; hide"
		F.CreateButtonFrameFader(frame, buttonList, cfg.faderOnShow)
	else
		frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
	end
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

end