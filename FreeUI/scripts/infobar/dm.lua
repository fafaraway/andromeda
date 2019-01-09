local F, C, L = unpack(select(2, ...))
local module = F:GetModule("infobar")
if not C.infoBar.enable then return end

local FreeUIDMButton = module.FreeUIDMButton

FreeUIDMButton = module:addButton("Toggle Skada", module.POSITION_LEFT, 120, function(self, button)
	if button == "LeftButton" then
		Skada:SetActive(true)
	elseif button == "RightButton" then
		Skada:SetActive(false)
	elseif button == "MiddleButton" then
		Skada:Reset()
	end
end)

FreeUIDMButton:RegisterEvent("PLAYER_ENTERING_WORLD")
FreeUIDMButton:SetScript("OnEvent", function(self)
	if IsAddOnLoaded("Skada") then
		module:showButton(self)
	else
		module:hideButton(self)
	end
end)

FreeUIDMButton:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -15)
	GameTooltip:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -33)

	GameTooltip:ClearLines()
	GameTooltip:AddLine("Skada", .9, .82, .62)
	GameTooltip:AddLine(" ")

	GameTooltip:AddDoubleLine(" ", C.LineString)
	GameTooltip:AddDoubleLine(" ", C.LeftButton.."Skada:SetActive".." ", 1,1,1, .9, .82, .62)
	GameTooltip:AddDoubleLine(" ", C.RightButton.."Skada:SetInactive".." ", 1,1,1, .9, .82, .62)
	GameTooltip:AddDoubleLine(" ", C.MiddleButton.."Skada:Reset".." ", 1,1,1, .9, .82, .62)
	GameTooltip:Show()
end)

FreeUIDMButton:HookScript("OnLeave", function(self)
	GameTooltip:Hide()
end)