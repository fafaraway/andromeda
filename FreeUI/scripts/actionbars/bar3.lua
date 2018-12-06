local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbars

function Bar:CreateBar3()

	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_ActionBar3", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.buttonSizeNormal + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetHeight(cfg.buttonSizeNormal + 2*cfg.padding)

	frame:SetScale(1)

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
		else
			local previous = _G["MultiBarBottomRightButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create the mouseover functionality
	if cfg.bar3Fade then
		F.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	--fix stupid blizzard
	local updateAfterCombat
	local function ToggleButtonGrid()
		if InCombatLockdown() then
			updateAfterCombat = true
			F:RegisterEvent("PLAYER_REGEN_ENABLED", ToggleButtonGrid)
		else
			local showgrid = tonumber(GetCVar("alwaysShowActionBars"))
			for _, button in next, buttonList do
				button:SetAttribute("showgrid", showgrid)
				ActionButton_ShowGrid(button)
			end
			if updateAfterCombat then
				F:UnregisterEvent("PLAYER_REGEN_ENABLED", ToggleButtonGrid)
				updateAfterCombat = false
			end
		end
	end
	hooksecurefunc("MultiActionBar_UpdateGrid", ToggleButtonGrid)
end