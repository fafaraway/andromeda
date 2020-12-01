local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


local margin, padding = 3, 3

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = F.Mover(frame, L.GUI.MOVER.STANCE_BAR, 'StanceBar', frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function ACTIONBAR:CreateStancebar()
	local num = _G.NUM_STANCE_SLOTS
	local size = C.DB.actionbar.button_size_big
	local NUM_POSSESS_SLOTS = _G.NUM_POSSESS_SLOTS
	local buttonList = {}

	local frame = CreateFrame('Frame', 'FreeUI_ActionBarStance', UIParent, 'SecureHandlerStateTemplate')
	local anchor = _G.FreeUI_ActionBar2
	frame.Pos = {'BOTTOMLEFT', anchor, 'TOPLEFT', 0, margin}

	-- StanceBar
	if C.DB.actionbar.stance_bar then
		_G.StanceBarFrame:SetParent(frame)
		_G.StanceBarFrame:EnableMouse(false)
		_G.StanceBarLeft:SetTexture(nil)
		_G.StanceBarMiddle:SetTexture(nil)
		_G.StanceBarRight:SetTexture(nil)

		for i = 1, num do
			local button = _G['StanceButton'..i]
			tinsert(buttonList, button)
			tinsert(ACTIONBAR.buttons, button)
			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint('BOTTOMLEFT', frame, padding, padding)
			else
				local previous = _G['StanceButton'..i-1]
				button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
			end
		end
	end

	-- PossessBar
	_G.PossessBarFrame:SetParent(frame)
	_G.PossessBarFrame:EnableMouse(false)
	_G.PossessBackground1:SetTexture(nil)
	_G.PossessBackground2:SetTexture(nil)

	for i = 1, NUM_POSSESS_SLOTS do
		local button = _G['PossessButton'..i]
		tinsert(buttonList, button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['PossessButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, size, num)

	if C.DB.actionbar.stance_bar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end
