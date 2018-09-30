local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbars

function Bar:CreateStancebar()

	local num = NUM_STANCE_SLOTS
	local NUM_POSSESS_SLOTS = NUM_POSSESS_SLOTS
	local buttonList = {}

	--make a frame that fits the size of all microbuttons
	local frame = CreateFrame("Frame", "FreeUI_StanceBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.buttonSizeBig + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetHeight(cfg.buttonSizeBig + 2*cfg.padding)
	frame:SetScale(1)

	local function positionBars()
		if InCombatLockdown() then return end
		local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
		if leftShown and rightShown then
			frame:SetPoint("BOTTOM", 'FreeUI_ActionBar3', "TOP", 0, 0)
		elseif leftShown and not rightShown then
			frame:SetPoint("BOTTOM", 'FreeUI_ActionBar2', "TOP", 0, 0)
		elseif rightShown and not leftShown then
			frame:SetPoint("BOTTOM", 'FreeUI_ActionBar3', "TOP", 0, 0)
		elseif not rightShown and not leftShown then
			frame:SetPoint("BOTTOM", 'FreeUI_ActionBar1', "TOP", 0, 0)
		end
	end
	hooksecurefunc("MultiActionBar_Update", positionBars)

	--STANCE BAR

	--move the buttons into position and reparent them
	StanceBarFrame:SetParent(frame)
	StanceBarFrame:EnableMouse(false)
	StanceBarLeft:SetTexture(nil)
	StanceBarMiddle:SetTexture(nil)
	StanceBarRight:SetTexture(nil)

	for i = 1, num do
		local button = _G["StanceButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.buttonSizeBig, cfg.buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
		else
			local previous = _G["StanceButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
	end

	--POSSESS BAR

	--move the buttons into position and reparent them
	PossessBarFrame:SetParent(frame)
	PossessBarFrame:EnableMouse(false)
	PossessBackground1:SetTexture(nil)
	PossessBackground2:SetTexture(nil)

	for i = 1, NUM_POSSESS_SLOTS do
		local button = _G["PossessButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.buttonSizeBig, cfg.buttonSizeBig)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
		else
			local previous = _G["PossessButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	if cfg.stanceBarEnable then
		frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show"
	else
		frame.frameVisibility = "hide"
	end
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

end