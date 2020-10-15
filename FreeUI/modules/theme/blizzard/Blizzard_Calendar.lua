local F, C = unpack(select(2, ...))

local function ReskinEventList(frame)
	F.StripTextures(frame)
	F.CreateBDFrame(frame, .25)
end

local function ReskinCalendarPage(frame)
	F.StripTextures(frame)
	F.SetBD(frame)
	F.StripTextures(frame.Header)
end

C.Themes["Blizzard_Calendar"] = function()
	local r, g, b = C.r, C.g, C.b

	for i = 1, 42 do
		local dayButtonName = "CalendarDayButton"..i
		local bu = _G[dayButtonName]
		bu:DisableDrawLayer("BACKGROUND")
		bu:SetHighlightTexture(C.Assets.bd_tex)
		local bg = F.CreateBDFrame(bu, .25)
		bg:SetInside()
		local hl = bu:GetHighlightTexture()
		hl:SetVertexColor(r, g, b, .25)
		hl:SetInside(bg)
		hl.SetAlpha = F.Dummy

		_G[dayButtonName.."DarkFrame"]:SetAlpha(.5)
		_G[dayButtonName.."EventTexture"]:SetInside(bg)
		_G[dayButtonName.."EventBackgroundTexture"]:SetAlpha(0)
		_G[dayButtonName.."OverlayFrameTexture"]:SetInside(bg)

		local eventButtonIndex = 1
		local eventButton = _G[dayButtonName.."EventButton"..eventButtonIndex]
		while eventButton do
			eventButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
			eventButton.black:SetTexture(nil)
			eventButtonIndex = eventButtonIndex + 1
			eventButton = _G[dayButtonName.."EventButton"..eventButtonIndex]
		end
	end

	for i = 1, 7 do
		_G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
	end

	CalendarViewEventDivider:Hide()
	CalendarCreateEventDivider:Hide()
	CalendarCreateEventFrameButtonBackground:Hide()
	CalendarCreateEventMassInviteButtonBorder:Hide()
	CalendarCreateEventCreateButtonBorder:Hide()
	F.ReskinIcon(CalendarCreateEventIcon)
	CalendarCreateEventIcon.SetTexCoord = F.Dummy
	CalendarEventPickerCloseButtonBorder:Hide()
	CalendarCreateEventRaidInviteButtonBorder:Hide()
	CalendarMonthBackground:SetAlpha(0)
	CalendarYearBackground:SetAlpha(0)
	CalendarFrameModalOverlay:SetAlpha(.25)
	CalendarViewHolidayInfoTexture:SetAlpha(0)
	CalendarTexturePickerAcceptButtonBorder:Hide()
	CalendarTexturePickerCancelButtonBorder:Hide()
	F.StripTextures(CalendarClassTotalsButton)

	F.StripTextures(CalendarFrame)
	F.SetBD(CalendarFrame, nil, 9, 0, -7, 1)
	F.CreateBDFrame(CalendarClassTotalsButton)

	ReskinEventList(CalendarViewEventInviteList)
	ReskinEventList(CalendarViewEventDescriptionContainer)
	ReskinEventList(CalendarCreateEventInviteList)
	ReskinEventList(CalendarCreateEventDescriptionContainer)

	ReskinCalendarPage(CalendarViewHolidayFrame)
	ReskinCalendarPage(CalendarCreateEventFrame)
	ReskinCalendarPage(CalendarViewEventFrame)
	ReskinCalendarPage(CalendarTexturePickerFrame)
	ReskinCalendarPage(CalendarEventPickerFrame)
	ReskinCalendarPage(CalendarViewRaidFrame)

	local frames = {
		CalendarViewEventTitleFrame,
		CalendarViewHolidayTitleFrame,
		CalendarViewRaidTitleFrame,
		CalendarCreateEventTitleFrame,
		CalendarTexturePickerTitleFrame,
		CalendarMassInviteTitleFrame
	}
	for _, titleFrame in next, frames do
		F.StripTextures(titleFrame)
		local parent = titleFrame:GetParent()
		F.StripTextures(parent)
		F.SetBD(parent)
	end

	CalendarWeekdaySelectedTexture:SetDesaturated(true)
	CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)

	hooksecurefunc("CalendarFrame_SetToday", function()
		CalendarTodayFrame:SetAllPoints()
	end)

	CalendarTodayFrame:SetScript("OnUpdate", nil)
	CalendarTodayTextureGlow:Hide()
	CalendarTodayTexture:Hide()

	local bg = F.CreateBDFrame(CalendarTodayFrame, 0)
	bg:SetInside()
	bg:SetBackdropBorderColor(r, g, b)

	for i, class in ipairs(CLASS_SORT_ORDER) do
		local bu = _G["CalendarClassButton"..i]
		bu:GetRegions():Hide()
		F.CreateBDFrame(bu)

		local tcoords = CLASS_ICON_TCOORDS[class]
		local ic = bu:GetNormalTexture()
		ic:SetTexCoord(tcoords[1] + 0.015, tcoords[2] - 0.02, tcoords[3] + 0.018, tcoords[4] - 0.02)
	end

	F.StripTextures(CalendarFilterFrame)
	local bg = F.CreateBDFrame(CalendarFilterFrame, 0, true)
	bg:SetPoint("TOPLEFT", 35, -1)
	bg:SetPoint("BOTTOMRIGHT", -18, 1)
	F.ReskinArrow(CalendarFilterButton, "down")

	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", -6, -24)
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
	CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)

	CalendarCreateEventHourDropDown:SetWidth(80)
	CalendarCreateEventMinuteDropDown:SetWidth(80)
	CalendarCreateEventAMPMDropDown:SetWidth(90)

	local line = CalendarMassInviteFrame:CreateTexture(nil, "BACKGROUND")
	line:SetSize(240, C.Mult)
	line:SetPoint("TOP", CalendarMassInviteFrame, "TOP", 0, -150)
	line:SetTexture(C.Assets.bd_tex)
	line:SetVertexColor(0, 0, 0)

	CalendarMassInviteFrame:ClearAllPoints()
	CalendarMassInviteFrame:SetPoint("BOTTOMLEFT", CalendarCreateEventFrame, "BOTTOMRIGHT", 28, 0)
	CalendarTexturePickerFrame:ClearAllPoints()
	CalendarTexturePickerFrame:SetPoint("TOPLEFT", CalendarCreateEventFrame, "TOPRIGHT", 28, 0)

	local cbuttons = {
		"CalendarViewEventAcceptButton",
		"CalendarViewEventTentativeButton",
		"CalendarViewEventDeclineButton",
		"CalendarViewEventRemoveButton",
		"CalendarCreateEventMassInviteButton",
		"CalendarCreateEventCreateButton",
		"CalendarCreateEventInviteButton",
		"CalendarEventPickerCloseButton",
		"CalendarCreateEventRaidInviteButton",
		"CalendarTexturePickerAcceptButton",
		"CalendarTexturePickerCancelButton",
		"CalendarMassInviteAcceptButton"
	}
	for i = 1, #cbuttons do
		local cbutton = _G[cbuttons[i]]
		if not cbutton then
			print(cbuttons[i])
		else
			F.Reskin(cbutton)
		end
	end

	CalendarViewEventAcceptButton.flashTexture:SetTexture("")
	CalendarViewEventTentativeButton.flashTexture:SetTexture("")
	CalendarViewEventDeclineButton.flashTexture:SetTexture("")

	F.ReskinClose(CalendarCloseButton, CalendarFrame, -14, -4)
	F.ReskinClose(CalendarCreateEventCloseButton)
	F.ReskinClose(CalendarViewEventCloseButton)
	F.ReskinClose(CalendarViewHolidayCloseButton)
	F.ReskinClose(CalendarViewRaidCloseButton)
	F.ReskinClose(CalendarMassInviteCloseButton)
	F.ReskinScroll(CalendarTexturePickerScrollBar)
	F.ReskinScroll(CalendarViewEventInviteListScrollFrameScrollBar)
	F.ReskinScroll(CalendarViewEventDescriptionScrollFrameScrollBar)
	F.ReskinScroll(CalendarCreateEventInviteListScrollFrameScrollBar)
	F.ReskinScroll(CalendarCreateEventDescriptionScrollFrameScrollBar)
	F.ReskinDropDown(CalendarCreateEventCommunityDropDown)
	F.ReskinDropDown(CalendarCreateEventTypeDropDown)
	F.ReskinDropDown(CalendarCreateEventHourDropDown)
	F.ReskinDropDown(CalendarCreateEventMinuteDropDown)
	F.ReskinDropDown(CalendarCreateEventAMPMDropDown)
	F.ReskinDropDown(CalendarCreateEventDifficultyOptionDropDown)
	F.ReskinDropDown(CalendarMassInviteCommunityDropDown)
	F.ReskinDropDown(CalendarMassInviteRankMenu)
	F.ReskinInput(CalendarCreateEventTitleEdit)
	F.ReskinInput(CalendarCreateEventInviteEdit)
	F.ReskinInput(CalendarMassInviteMinLevelEdit)
	F.ReskinInput(CalendarMassInviteMaxLevelEdit)
	F.ReskinArrow(CalendarPrevMonthButton, "left")
	F.ReskinArrow(CalendarNextMonthButton, "right")
	CalendarPrevMonthButton:SetSize(19, 19)
	CalendarNextMonthButton:SetSize(19, 19)
	F.ReskinCheck(CalendarCreateEventLockEventCheck)

	CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)
end
