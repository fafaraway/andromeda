local F, C = unpack(select(2, ...))
local Bar = F:GetModule('Actionbar')


function Bar:CreateBar2()
	local cfg = C.actionbar
	local buttonSize = cfg.buttonSizeNormal*C.Mult
	local padding = cfg.padding*C.Mult
	local margin = cfg.margin*C.Mult

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame('Frame', 'FreeUI_ActionBar2', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(num*buttonSize + (num-1)*margin + 2*padding)
	frame:SetHeight(buttonSize + 2*padding)
	frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
	frame:SetScale(1)

	--move the buttons into position and reparent them
	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)

	for i = 1, num do
		local button = _G['MultiBarBottomLeftButton'..i]
		table.insert(buttonList, button) --add the button object to the list
		table.insert(self.activeButtons, button)
		button:SetSize(buttonSize, buttonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['MultiBarBottomLeftButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	if cfg.layoutStyle == 3 then
		frame.frameVisibility = '[mod:shift] show; hide'
		F.CreateButtonFrameFader(frame, buttonList, F.faderOnShow)
	else
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	--[[frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if cfg.layoutStyle == 3 then
		F.CreateButtonFrameFader(frame, buttonList, F.fader)
	end]]

end