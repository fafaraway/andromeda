local F, C = unpack(select(2, ...))

local module = F:GetModule("blizzard")


function module:PositionUIWidgets()
	_G.UIWidgetTopCenterContainerFrame:ClearAllPoints()
	_G.UIWidgetTopCenterContainerFrame:SetPoint("TOP", UIParent, "TOP", 0, -30)
	_G.UIWidgetTopCenterContainerFrame.ignoreFramePositionManager = true

	local belowMiniMapcontainer = _G["UIWidgetBelowMinimapContainerFrame"]

	local belowMiniMapHolder = CreateFrame("Frame", "BelowMinimapContainerHolder", UIParent)
	belowMiniMapHolder:SetPoint("TOP", UIParent, "TOP", 0, -120)
	belowMiniMapHolder:SetSize(170, 20)


	belowMiniMapcontainer:ClearAllPoints()
	belowMiniMapcontainer:SetPoint("CENTER", belowMiniMapHolder, "CENTER")
	belowMiniMapcontainer:SetParent(belowMiniMapHolder)
	belowMiniMapcontainer.ignoreFramePositionManager = true

	-- Reposition capture bar on layout update
	hooksecurefunc(_G["UIWidgetManager"].registeredWidgetSetContainers[2], "layoutFunc", function(widgetContainer, sortedWidgets, ...)
		widgetContainer:ClearAllPoints()

		if widgetContainer:GetWidth() ~= belowMiniMapHolder:GetWidth() then
			belowMiniMapHolder:SetWidth(widgetContainer:GetWidth())
		end
	end)

	-- And this one cause UIParentManageFramePositions() repositions the widget constantly
	hooksecurefunc(belowMiniMapcontainer, "ClearAllPoints", function(self)
		self:SetPoint("CENTER", belowMiniMapHolder, "CENTER")
	end)
end