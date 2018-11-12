local F, C, L = unpack(select(2, ...))
local module = F:GetModule("infobar")
if not C.infoBar.enable then return end

local FreeUIDMButton = module.FreeUIDMButton

FreeUIDMButton = module:addButton("Toggle Skada", module.POSITION_LEFT, function(self, button)
	if IsAddOnLoaded("Skada") then
		if button == "LeftButton" then
			Skada:SetActive(true)
		elseif button == "RightButton" then
			Skada:SetActive(false)
		elseif button == "MiddleButton" then
			Skada:Reset()
		end
	else
		EnableAddOn("Skada")
		DEFAULT_CHAT_FRAME:AddMessage("FreeUI: |cffffffffSkada enabled. Type|r /rl |cfffffffffor the changes to apply.|r", C.r, C.g, C.b)
	end
end)

FreeUIDMButton:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(Minimap, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -33)

	GameTooltip:ClearLines()
	GameTooltip:AddLine("DM", .9, .82, .62)
	GameTooltip:AddLine(" ")

	if IsAddOnLoaded("Skada") then
		GameTooltip:AddDoubleLine(" ", C.LineString)
		GameTooltip:AddDoubleLine(" ", C.LeftButton.."Skada:SetActive".." ", 1,1,1, .9, .82, .62)
		GameTooltip:AddDoubleLine(" ", C.RightButton.."Skada:SetInactive".." ", 1,1,1, .9, .82, .62)
		GameTooltip:AddDoubleLine(" ", C.MiddleButton.."Skada:Reset".." ", 1,1,1, .9, .82, .62)
		GameTooltip:Show()
	end
end)

FreeUIDMButton:HookScript("OnLeave", function(self)
	GameTooltip:Hide()
end)