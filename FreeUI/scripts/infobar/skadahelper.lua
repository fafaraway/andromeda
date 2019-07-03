local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')


local FreeUIDMButton = INFOBAR.FreeUIDMButton


function INFOBAR:SkadaHelper()
	if not C.infobar.enable then return end
	if not C.infobar.skadaHelper then return end

	FreeUIDMButton = INFOBAR:addButton('Toggle Skada', INFOBAR.POSITION_LEFT, 120, function(self, button)
		if button == 'LeftButton' then
			Skada:SetActive(true)
		elseif button == 'RightButton' then
			Skada:SetActive(false)
		elseif button == 'MiddleButton' then
			Skada:Reset()
		end
	end)

	FreeUIDMButton:RegisterEvent('PLAYER_ENTERING_WORLD')
	FreeUIDMButton:SetScript('OnEvent', function(self)
		if IsAddOnLoaded('Skada') then
			INFOBAR:showButton(self)
		else
			INFOBAR:hideButton(self)
		end
	end)

	FreeUIDMButton:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, 'ANCHOR_BOTTOM', 0, -15)
		GameTooltip:SetPoint('TOPRIGHT', Minimap, 'TOPLEFT', -5, -33)

		GameTooltip:ClearLines()
		GameTooltip:AddLine('Skada', .9, .8, .6)
		GameTooltip:AddLine(' ')

		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.LeftButton..'Skada:SetActive'..' ', 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.RightButton..'Skada:SetInactive'..' ', 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.MiddleButton..'Skada:Reset'..' ', 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	FreeUIDMButton:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)
end