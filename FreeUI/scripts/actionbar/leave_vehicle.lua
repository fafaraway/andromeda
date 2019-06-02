local F, C = unpack(select(2, ...))
local Bar = F:GetModule("Actionbar")


function Bar:CreateLeaveVehicle()
	local cfg = C.actionbar
	local padding = cfg.padding*C.Mult
	local margin = cfg.margin*C.Mult

	local num = 1
	local buttonList = {}

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "FreeUI_LeaveVehicleBar", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*C.unitframe.player_height + (num-1)*margin + 2*padding)
	frame:SetHeight(C.unitframe.player_height + 2*padding)
	--frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 100)
	frame:SetScale(1)


	--the button
	local button = CreateFrame("CheckButton", "FreeUI_LeaveVehicleButton", frame, "ActionButtonTemplate, SecureHandlerClickTemplate")
	table.insert(buttonList, button) --add the button object to the list

	button:SetSize(C.unitframe.player_height, C.unitframe.player_height)
	button:SetPoint("BOTTOMLEFT", frame, padding, padding)

	button:RegisterForClicks("AnyUp")
	button.icon:SetTexture(nil)
	--[[button.icon:SetTexCoord(.216, .784, .216, .784)
	button:SetNormalTexture(nil)
	button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	button:GetPushedTexture():SetTexture(C.media.checked)]]
	--F.CreateBD(button)
	F.CreateSD(button)
	F.ReskinClose(button)

	local function onClick(self)
		if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end
		self:SetChecked(false)
	end
	button:SetScript("OnClick", onClick)
	button:SetScript("OnEnter", MainMenuBarVehicleLeaveButton_OnEnter)
	button:SetScript("OnLeave", F.HideTooltip)

	--frame visibility
	frame.frameVisibility = "[canexitvehicle]c;[mounted]m;n"
	RegisterStateDriver(frame, "exit", frame.frameVisibility)

	frame:SetAttribute("_onstate-exit", [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
	if not CanExitVehicle() then frame:Hide() end
end