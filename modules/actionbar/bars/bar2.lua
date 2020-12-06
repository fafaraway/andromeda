local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


local margin, padding = 3, 3

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = F.Mover(frame, SHOW_MULTIBAR1_TEXT, "Bar2", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function ACTIONBAR:CreateBar2()
	local num = NUM_ACTIONBAR_BUTTONS
	local size = C.DB.actionbar.button_size_normal
	local buttonList = {}

	local frame = CreateFrame("Frame", "FreeUI_ActionBar2", UIParent, "SecureHandlerStateTemplate")
	frame.Pos = {"BOTTOM", _G.FreeUI_ActionBar1, "TOP", 0, -margin}

	local tex = frame:CreateTexture(nil, 'OVERLAY')
	tex:SetPoint('BOTTOMLEFT', frame, 'TOPLEFT', 0, -padding)
	tex:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', 0, -padding)
	tex:SetHeight(30)
	tex:SetTexture(C.Assets.glow_tex)
	tex:SetVertexColor(0, 0, 0, .5)

	MultiBarBottomLeft:SetParent(frame)
	MultiBarBottomLeft:EnableMouse(false)
	MultiBarBottomLeft.QuickKeybindGlow:SetTexture("")

	for i = 1, num do
		local button = _G["MultiBarBottomLeftButton"..i]
		tinsert(buttonList, button)
		tinsert(ACTIONBAR.buttons, button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, padding, padding)
		else
			local previous = _G["MultiBarBottomLeftButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, size, num)

	if C.DB.actionbar.bar2 then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)
end
