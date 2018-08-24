local F, C = unpack(select(2, ...))
local Bar = F:GetModule("actionbars")
local cfg = C.actionbars

function Bar:CreatePetbar()

	local num = NUM_PET_ACTION_SLOTS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_PetActionBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.buttonSizeSmall + (num-1)*cfg.margin + 2*cfg.padding)
	frame:SetHeight(cfg.buttonSizeSmall + 2*cfg.padding)
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
		else
			frame:SetPoint("BOTTOM", 'FreeUI_ActionBar1', "TOP", 0, 0)
		end
	end
	hooksecurefunc("MultiActionBar_Update", positionBars)

	--move the buttons into position and reparent them
	PetActionBarFrame:SetParent(frame)
	PetActionBarFrame:EnableMouse(false)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)

	for i = 1, num do
		local button = _G["PetActionButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(cfg.buttonSizeSmall, cfg.buttonSizeSmall)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("LEFT", frame, cfg.padding, 0)
		else
			local previous = _G["PetActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", cfg.margin, 0)
		end
		--cooldown fix
		local cd = _G["PetActionButton"..i.."Cooldown"]
		cd:SetAllPoints(button)
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create the mouseover functionality
	if cfg.petBar_mouseOver then
		F.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end