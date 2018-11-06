local F, C = unpack(select(2, ...))
local module = F:RegisterModule("actionbars")
local cfg = C.actionbars

function module:OnLogin()

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar1", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.buttonSizeNormal + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetHeight(cfg.buttonSizeNormal + 2*cfg.padding)

	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 6)
	frame:SetScale(1)

	for i = 1, num do
		local button = _G["ActionButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetParent(frame)
		button:SetSize(cfg.buttonSizeNormal, cfg.buttonSizeNormal)
		button:ClearAllPoints()

		if i == 1 then
			button:SetPoint("BOTTOMLEFT", frame, cfg.padding, cfg.padding)
		else
			local previous = _G["ActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	if cfg.layoutSimple then
		frame.frameVisibility = "[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar] show; hide"
		F.CreateButtonFrameFader(frame, buttonList, cfg.faderOnShow)
	else
		frame.frameVisibility = "[petbattle] hide; show"
	end
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)


	--fix stupid blizzard
	local function ToggleButtonGrid()
		if InCombatLockdown() then return end
		local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
		for _, button in next, buttonList do
			button:SetAttribute("showgrid", showgrid)
			ActionButton_ShowGrid(button)
		end
	end
	hooksecurefunc("MultiActionBar_UpdateGridVisibility", ToggleButtonGrid)

	--_onstate-page state driver
	local actionPage = "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
	local buttonName = "ActionButton"
	for i, button in next, buttonList do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
		buttons = table.new()
		for i = 1, %d do
			table.insert(buttons, self:GetFrameRef("%s"..i))
		end
	]]):format(num, buttonName))

	frame:SetAttribute("_onstate-page", [[
		for i, button in next, buttons do
			button:SetAttribute("actionpage", newstate)
		end
	]])
	RegisterStateDriver(frame, "page", actionPage)

	local function vehicleFix()
		if InCombatLockdown() then return end
		if HasVehicleActionBar() or HasOverrideActionBar() then
			for _, button in next, buttonList do
				ActionButton_Update(button)
			end
		end
	end
	F:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", vehicleFix)
	F:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", vehicleFix)

	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreatePetbar()
	self:CreateStancebar()
	self:CreateExtrabar()
	self:CreateLeaveVehicle()
	self:HideBlizz()
end