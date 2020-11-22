local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F.ACTIONBAR






local margin, padding = 3, 3



local function UpdateActionbarScale(bar)
	local frame = _G["FreeUI_Action"..bar]
	if not frame then return end

	local size = frame.buttonSize * C.DB.actionbar.scale
	frame:SetFrameSize(size)
	for _, button in pairs(frame.buttonList) do
		button:SetSize(size, size)
	end
end

function ACTIONBAR:UpdateAllScale()
	if not C.DB.actionbar.enable then return end

	UpdateActionbarScale("Bar1")
	UpdateActionbarScale("Bar2")
	UpdateActionbarScale("Bar3")
	UpdateActionbarScale("Bar4")
	UpdateActionbarScale("Bar5")

	UpdateActionbarScale("BarExit")
	UpdateActionbarScale("BarPet")
	UpdateActionbarScale("BarStance")
end

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = F.Mover(frame, L.GUI.MOVER.MAIN_BAR, "Bar1", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function ACTIONBAR:CreateBar1()
	local num = NUM_ACTIONBAR_BUTTONS
	local size = C.DB.actionbar.button_size_normal
	local buttonList = {}

	local frame = CreateFrame('Frame', 'FreeUI_ActionBar1', UIParent, 'SecureHandlerStateTemplate')
	frame.Pos = {'BOTTOM', UIParent, 'BOTTOM', 0, C.UIGap}

	local tex = frame:CreateTexture(nil, 'OVERLAY')
	tex:SetPoint('TOPLEFT', frame, 'BOTTOMLEFT', 0, padding)
	tex:SetPoint('TOPRIGHT', frame, 'BOTTOMRIGHT', 0, padding)
	tex:SetHeight(30)
	tex:SetTexture(C.Assets.glow_tex)
	tex:SetRotation(rad(180))
	tex:SetVertexColor(0, 0, 0, .5)

	for i = 1, num do
		local button = _G['ActionButton'..i]
		tinsert(buttonList, button)
		tinsert(ACTIONBAR.buttons, button)
		button:SetParent(frame)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint('BOTTOMLEFT', frame, padding, padding)
		else
			local previous = _G['ActionButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, size, num)

	--frame.frameVisibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'

	if C.DB.actionbar.bar1 then
		frame.frameVisibility = '[petbattle] hide; show'
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	local actionPage = "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
	local buttonName = "ActionButton"
	for i, button in next, buttonList do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
		buttons = table.new()
		for i = 1, %d do
			tinsert(buttons, self:GetFrameRef("%s"..i))
		end
	]]):format(num, buttonName))

	frame:SetAttribute("_onstate-page", [[
		for _, button in next, buttons do
			button:SetAttribute("actionpage", newstate)
		end
	]])
	RegisterStateDriver(frame, "page", actionPage)

	-- Fix button texture, need reviewed
	local function FixActionBarTexture()
		for _, button in next, buttonList do
			local icon = button.icon
			local texture = GetActionTexture(button.action)
			if texture then
				icon:SetTexture(texture)
				icon:SetVertexColor(1, 1, 1) -- force it turn bright, needs review
				icon:Show()
			else
				icon:Hide()
			end
		end
	end

	F:RegisterEvent("SPELL_UPDATE_ICON", FixActionBarTexture)
	F:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", FixActionBarTexture)
	F:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", FixActionBarTexture)
end






function ACTIONBAR:OnLogin()
	if not C.DB.actionbar.enable then return end

	ACTIONBAR.buttons = {}

	ACTIONBAR:CreateBar1()
	ACTIONBAR:CreateBar2()
	ACTIONBAR:CreateBar3()
	ACTIONBAR:CreateBar4()
	ACTIONBAR:CreateBar5()
	ACTIONBAR:CreatePetbar()
	ACTIONBAR:CreateStancebar()
	ACTIONBAR:CreateExtrabar()
	ACTIONBAR:CreateLeaveVehicleBar()
	ACTIONBAR:CreateCustomBar()
	ACTIONBAR:RemoveBlizzArt()
	ACTIONBAR:RestyleButtons()
	ACTIONBAR:UpdateAllScale()
	ACTIONBAR:UpdateActionBarFade()
end
