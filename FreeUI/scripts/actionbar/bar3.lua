local F, C = unpack(select(2, ...))
local Bar = F:GetModule("Actionbar")


function Bar:CreateBar3()
	local cfg = C.actionbar
	local buttonSize = cfg.buttonSizeNormal*C.Mult
	local padding = cfg.padding*C.Mult
	local margin = cfg.margin*C.Mult

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar3", UIParent, "SecureHandlerStateTemplate")

	if cfg.layoutStyle == 2 then
		frame:SetWidth(18*buttonSize + 17*margin + 2*padding)
		frame:SetHeight(2*buttonSize + margin + 2*padding)
	else
		frame:SetWidth(num*buttonSize + (num-1)*margin + 2*padding)
		frame:SetHeight(buttonSize + 2*padding)
	end

	frame:SetScale(1)

	if cfg.layoutStyle == 2 then
		frame:SetPoint(unpack(cfg.bar1Pos))
	else
		local function positionBars()
			if InCombatLockdown() then return end
			local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
			if leftShown then
				frame:SetPoint("BOTTOM", 'FreeUI_ActionBar2', "TOP", 0, 0)
			else
				frame:SetPoint("BOTTOM", 'FreeUI_ActionBar1', "TOP", 0, 0)
			end
		end
		hooksecurefunc("MultiActionBar_Update", positionBars)
	end

	--move the buttons into position and reparent them
	MultiBarBottomRight:SetParent(frame)
	MultiBarBottomRight:EnableMouse(false)

	for i = 1, num do
		local button = _G["MultiBarBottomRightButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(buttonSize, buttonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("TOPLEFT", frame, padding, -padding)
		elseif (i == 4 and cfg.layoutStyle == 2) then
			local previous = _G["MultiBarBottomRightButton1"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		elseif (i == 7 and cfg.layoutStyle == 2) then
			local previous = _G["MultiBarBottomRightButton3"]
			button:SetPoint("LEFT", previous, "RIGHT", 12*buttonSize+13*margin, 0)
		elseif (i == 10 and cfg.layoutStyle == 2) then
			local previous = _G["MultiBarBottomRightButton7"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -margin)
		else
			local previous = _G["MultiBarBottomRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create the mouseover functionality
	if (cfg.bar3Mouseover and cfg.layoutStyle == 1) or cfg.layoutStyle == 3 then
		F.CreateButtonFrameFader(frame, buttonList, F.fader)
	end
end