local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbar
cfg.buttonSizeNormal = cfg.buttonSizeNormal*C.Mult
cfg.padding = cfg.padding*C.Mult
cfg.margin = cfg.margin*C.Mult

function Bar:CreateBar3()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar3", UIParent, "SecureHandlerStateTemplate")

	if cfg.layoutStyle == 2 then
		frame:SetWidth(18*cfg.buttonSizeNormal + 17*cfg.margin + 2*cfg.padding)
		frame:SetHeight(2*cfg.buttonSizeNormal + cfg.margin + 2*cfg.padding)
	else
		frame:SetWidth(num*cfg.buttonSizeNormal + (num-1)*cfg.margin + 2*cfg.padding)
		frame:SetHeight(cfg.buttonSizeNormal + 2*cfg.padding)
	end

	frame:SetScale(1)

	if cfg.layoutStyle == 2 then
		frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 6)
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
		button:SetSize(cfg.buttonSizeNormal, cfg.buttonSizeNormal)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("TOPLEFT", frame, cfg.padding, -cfg.padding)
		elseif (i == 4 and cfg.layoutStyle == 2) then
			local previous = _G["MultiBarBottomRightButton1"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -cfg.margin)
		elseif (i == 7 and cfg.layoutStyle == 2) then
			local previous = _G["MultiBarBottomRightButton3"]
			button:SetPoint("LEFT", previous, "RIGHT", 12*cfg.buttonSizeNormal+13*cfg.margin, 0)
		elseif (i == 10 and cfg.layoutStyle == 2) then
			local previous = _G["MultiBarBottomRightButton7"]
			button:SetPoint("TOP", previous, "BOTTOM", 0, -cfg.margin)
		else
			local previous = _G["MultiBarBottomRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create the mouseover functionality
	if cfg.bar3Mouseover or cfg.layoutStyle == 3 then
		F.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end