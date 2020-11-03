local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR


local margin, padding = 3, 3

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(size + 2*padding)
	frame:SetHeight(num*size + (num-1)*margin + 2*padding)
	if not frame.mover then
		frame.mover = F.Mover(frame, SHOW_MULTIBAR4_TEXT, 'Bar5', frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function ACTIONBAR:CreateBar5()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local size = C.DB.actionbar.button_size_normal

	local frame = CreateFrame('Frame', 'FreeUI_ActionBar5', UIParent, 'SecureHandlerStateTemplate')
	frame.Pos = {'RIGHT', _G.FreeUI_ActionBar4, 'LEFT', margin, 0}

	MultiBarLeft:SetParent(frame)
	MultiBarLeft:EnableMouse(false)
	MultiBarLeft.QuickKeybindGlow:SetTexture('')

	for i = 1, num do
		local button = _G['MultiBarLeftButton'..i]
		tinsert(buttonList, button)
		tinsert(ACTIONBAR.buttons, button)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPRIGHT', frame, -padding, -padding)
		else
			local previous = _G['MultiBarLeftButton'..i-1]
			button:SetPoint('TOP', previous, 'BOTTOM', 0, -margin)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, size, num)

	frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; show'
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	if C.DB.actionbar.bar5_fade then
		frame.fader = {
			enable = C.DB.actionbar.bar5_fade,
			fadeInAlpha = C.DB.actionbar.bar5_fade_in_alpha,
			fadeOutAlpha = C.DB.actionbar.bar5_fade_out_alpha,
			arena = C.DB.actionbar.bar5_fade_arena,
			instance = C.DB.actionbar.bar5_fade_instance,
			combat = C.DB.actionbar.bar5_fade_combat,
			target = C.DB.actionbar.bar5_fade_target,
			hover = C.DB.actionbar.bar5_fade_hover,
		}

		ACTIONBAR.CreateButtonFrameFader(frame, buttonList, frame.fader)
	end
end
