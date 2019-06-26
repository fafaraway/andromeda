local F, C = unpack(select(2, ...))
local Bar = F:GetModule('Actionbar')


function Bar:CreatePetbar()
	local cfg = C.actionbar
	local buttonSize = cfg.buttonSizeSmall*C.Mult
	local padding = cfg.padding*C.Mult
	local margin = (cfg.margin+4)*C.Mult

	local num = NUM_PET_ACTION_SLOTS
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame('Frame', 'FreeUI_PetActionBar', UIParent, 'SecureHandlerStateTemplate')
	frame:SetWidth(num*buttonSize + (num-1)*(margin+2) + 2*padding)
	frame:SetHeight(buttonSize + 2*padding)
	frame:SetScale(1)

	local function positionBars()
		if InCombatLockdown() then return end
		local leftShown, rightShown = MultiBarBottomLeft:IsShown(), MultiBarBottomRight:IsShown()
		if leftShown and rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		elseif leftShown and not rightShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar2', 'TOP', 0, 0)
		elseif rightShown and not leftShown then
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar3', 'TOP', 0, 0)
		else
			frame:SetPoint('BOTTOM', 'FreeUI_ActionBar1', 'TOP', 0, 0)
		end
	end
	hooksecurefunc('MultiActionBar_Update', positionBars)

	--move the buttons into position and reparent them
	PetActionBarFrame:SetParent(frame)
	PetActionBarFrame:EnableMouse(false)
	SlidingActionBarTexture0:SetTexture(nil)
	SlidingActionBarTexture1:SetTexture(nil)

	for i = 1, num do
		local button = _G['PetActionButton'..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(buttonSize, buttonSize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('LEFT', frame, padding, 0)
		else
			local previous = _G['PetActionButton'..i-1]
			button:SetPoint('LEFT', previous, 'RIGHT', margin+2, 0)
		end
		--cooldown fix
		local cd = _G['PetActionButton'..i..'Cooldown']
		cd:SetAllPoints(button)
	end

	--show/hide the frame on a given state driver
	if cfg.petBar then
		frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists][shapeshift] hide; [pet] show; hide'
	else
		frame.frameVisibility = 'hide'
	end
	RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

	--create the mouseover functionality
	if cfg.petBar and cfg.petBarMouseover then
		F.CreateButtonFrameFader(frame, buttonList, F.fader)
	end
end