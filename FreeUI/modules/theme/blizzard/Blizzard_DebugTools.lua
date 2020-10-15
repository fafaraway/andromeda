local F, C = unpack(select(2, ...))

local function reskinTableAttribute(frame)
	if frame.styled then return end

	F.StripTextures(frame)
	F.SetBD(frame)
	F.ReskinClose(frame.CloseButton)
	F.ReskinCheck(frame.VisibilityButton)
	F.ReskinCheck(frame.HighlightButton)
	F.ReskinCheck(frame.DynamicUpdateButton)
	F.ReskinInput(frame.FilterBox)

	F.ReskinArrow(frame.OpenParentButton, "up")
	F.ReskinArrow(frame.NavigateBackwardButton, "left")
	F.ReskinArrow(frame.NavigateForwardButton, "right")
	F.ReskinArrow(frame.DuplicateButton, "up")

	frame.NavigateBackwardButton:ClearAllPoints()
	frame.NavigateBackwardButton:SetPoint("LEFT", frame.OpenParentButton, "RIGHT")
	frame.NavigateForwardButton:ClearAllPoints()
	frame.NavigateForwardButton:SetPoint("LEFT", frame.NavigateBackwardButton, "RIGHT")
	frame.DuplicateButton:ClearAllPoints()
	frame.DuplicateButton:SetPoint("LEFT", frame.NavigateForwardButton, "RIGHT")

	F.StripTextures(frame.ScrollFrameArt)
	F.CreateBDFrame(frame.ScrollFrameArt, .25)
	F.ReskinScroll(frame.LinesScrollFrame.ScrollBar)

	frame.styled = true
end

C.Themes["Blizzard_DebugTools"] = function()
	-- EventTraceFrame
	F.StripTextures(EventTraceFrame)
	F.SetBD(EventTraceFrame)
	F.ReskinClose(EventTraceFrameCloseButton, EventTraceFrame, -7, -7)

	local bg, bu = EventTraceFrameScroll:GetRegions()
	bg:Hide()
	bu:SetAlpha(0)
	bu:SetWidth(16)
	bu.bg = F.CreateBDFrame(EventTraceFrame, 0, true)
	bu.bg:SetAllPoints(bu)

	-- Table Attribute Display

	reskinTableAttribute(TableAttributeDisplay)
	hooksecurefunc(TableInspectorMixin, "InspectTable", reskinTableAttribute)
end
