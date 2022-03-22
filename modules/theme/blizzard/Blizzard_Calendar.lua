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

C.Themes['Blizzard_Calendar'] = function()
    local r, g, b = C.r, C.g, C.b

    for i = 1, 42 do
        local dayButtonName = 'CalendarDayButton' .. i
        local bu = _G[dayButtonName]
        bu:DisableDrawLayer('BACKGROUND')
        bu:SetHighlightTexture(C.Assets.Textures.Backdrop)
        local bg = F.CreateBDFrame(bu, .25)
        bg:SetInside()
        local hl = bu:GetHighlightTexture()
        hl:SetVertexColor(r, g, b, .25)
        hl:SetInside(bg)
        hl.SetAlpha = nop

        _G[dayButtonName .. 'DarkFrame']:SetAlpha(.5)
        _G[dayButtonName .. 'EventTexture']:SetInside(bg)
        _G[dayButtonName .. 'EventBackgroundTexture']:SetAlpha(0)
        _G[dayButtonName .. 'OverlayFrameTexture']:SetInside(bg)

        local eventButtonIndex = 1
        local eventButton = _G[dayButtonName .. 'EventButton' .. eventButtonIndex]
        while eventButton do
            eventButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
            eventButton.black:SetTexture(nil)
            eventButtonIndex = eventButtonIndex + 1
            eventButton = _G[dayButtonName .. 'EventButton' .. eventButtonIndex]
        end
    end

    for i = 1, 7 do
        _G['CalendarWeekday' .. i .. 'Background']:SetAlpha(0)
    end

    _G.CalendarViewEventDivider:Hide()
    _G.CalendarCreateEventDivider:Hide()
    _G.CalendarCreateEventFrameButtonBackground:Hide()
    _G.CalendarCreateEventMassInviteButtonBorder:Hide()
    _G.CalendarCreateEventCreateButtonBorder:Hide()
    F.ReskinIcon(_G.CalendarCreateEventIcon)
    _G.CalendarCreateEventIcon.SetTexCoord = nop
    _G.CalendarEventPickerCloseButtonBorder:Hide()
    _G.CalendarCreateEventRaidInviteButtonBorder:Hide()
    _G.CalendarMonthBackground:SetAlpha(0)
    _G.CalendarYearBackground:SetAlpha(0)
    _G.CalendarFrameModalOverlay:SetAlpha(.25)
    _G.CalendarViewHolidayInfoTexture:SetAlpha(0)
    _G.CalendarTexturePickerAcceptButtonBorder:Hide()
    _G.CalendarTexturePickerCancelButtonBorder:Hide()
    F.StripTextures(_G.CalendarClassTotalsButton)

    F.StripTextures(_G.CalendarFrame)
    F.SetBD(_G.CalendarFrame, nil, 9, 0, -7, 1)
    F.CreateBDFrame(_G.CalendarClassTotalsButton)

    ReskinEventList(_G.CalendarViewEventInviteList)
    ReskinEventList(_G.CalendarViewEventDescriptionContainer)
    ReskinEventList(_G.CalendarCreateEventInviteList)
    ReskinEventList(_G.CalendarCreateEventDescriptionContainer)

    ReskinCalendarPage(_G.CalendarViewHolidayFrame)
    ReskinCalendarPage(_G.CalendarCreateEventFrame)
    ReskinCalendarPage(_G.CalendarViewEventFrame)
    ReskinCalendarPage(_G.CalendarTexturePickerFrame)
    ReskinCalendarPage(_G.CalendarEventPickerFrame)
    ReskinCalendarPage(_G.CalendarViewRaidFrame)

    local frames = {
        _G.CalendarViewEventTitleFrame,
        _G.CalendarViewHolidayTitleFrame,
        _G.CalendarViewRaidTitleFrame,
        _G.CalendarCreateEventTitleFrame,
        _G.CalendarTexturePickerTitleFrame,
        _G.CalendarMassInviteTitleFrame
    }
    for _, titleFrame in next, frames do
        F.StripTextures(titleFrame)
        local parent = titleFrame:GetParent()
        F.StripTextures(parent)
        F.SetBD(parent)
    end

    _G.CalendarWeekdaySelectedTexture:SetDesaturated(true)
    _G.CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)

    hooksecurefunc(
        'CalendarFrame_SetToday',
        function()
            _G.CalendarTodayFrame:SetAllPoints()
        end
    )

    _G.CalendarTodayFrame:SetScript('OnUpdate', nil)
    _G.CalendarTodayTextureGlow:Hide()
    _G.CalendarTodayTexture:Hide()

    local bg = F.CreateBDFrame(_G.CalendarTodayFrame, 0)
    bg:SetInside()
    bg:SetBackdropBorderColor(r, g, b)

    for i, class in ipairs(_G.CLASS_SORT_ORDER) do
        local bu = _G['CalendarClassButton' .. i]
        bu:GetRegions():Hide()
        F.CreateBDFrame(bu)
        F.ClassIconTexCoord(bu:GetNormalTexture(), class)
    end

    F.StripTextures(_G.CalendarFilterFrame)
    local bg = F.CreateBDFrame(_G.CalendarFilterFrame, 0, true)
    bg:SetPoint('TOPLEFT', 35, -1)
    bg:SetPoint('BOTTOMRIGHT', -18, 1)
    F.ReskinArrow(_G.CalendarFilterButton, 'down')

    _G.CalendarViewEventFrame:SetPoint('TOPLEFT', _G.CalendarFrame, 'TOPRIGHT', -6, -24)
    _G.CalendarViewHolidayFrame:SetPoint('TOPLEFT', _G.CalendarFrame, 'TOPRIGHT', -6, -24)
    _G.CalendarViewRaidFrame:SetPoint('TOPLEFT', _G.CalendarFrame, 'TOPRIGHT', -6, -24)
    _G.CalendarCreateEventFrame:SetPoint('TOPLEFT', _G.CalendarFrame, 'TOPRIGHT', -6, -24)
    _G.CalendarCreateEventInviteButton:SetPoint('TOPLEFT', _G.CalendarCreateEventInviteEdit, 'TOPRIGHT', 1, 1)
    _G.CalendarClassButton1:SetPoint('TOPLEFT', _G.CalendarClassButtonContainer, 'TOPLEFT', 5, 0)

    _G.CalendarCreateEventHourDropDown:SetWidth(80)
    _G.CalendarCreateEventMinuteDropDown:SetWidth(80)
    _G.CalendarCreateEventAMPMDropDown:SetWidth(90)

    local line = _G.CalendarMassInviteFrame:CreateTexture(nil, 'BACKGROUND')
    line:SetSize(240, C.Mult)
    line:SetPoint('TOP', _G.CalendarMassInviteFrame, 'TOP', 0, -150)
    line:SetTexture(C.Assets.Textures.Backdrop)
    line:SetVertexColor(0, 0, 0)

    _G.CalendarMassInviteFrame:ClearAllPoints()
    _G.CalendarMassInviteFrame:SetPoint('BOTTOMLEFT', _G.CalendarCreateEventFrame, 'BOTTOMRIGHT', 28, 0)
    _G.CalendarTexturePickerFrame:ClearAllPoints()
    _G.CalendarTexturePickerFrame:SetPoint('TOPLEFT', _G.CalendarCreateEventFrame, 'TOPRIGHT', 28, 0)

    local cbuttons = {
        'CalendarViewEventAcceptButton',
        'CalendarViewEventTentativeButton',
        'CalendarViewEventDeclineButton',
        'CalendarViewEventRemoveButton',
        'CalendarCreateEventMassInviteButton',
        'CalendarCreateEventCreateButton',
        'CalendarCreateEventInviteButton',
        'CalendarEventPickerCloseButton',
        'CalendarCreateEventRaidInviteButton',
        'CalendarTexturePickerAcceptButton',
        'CalendarTexturePickerCancelButton',
        'CalendarMassInviteAcceptButton'
    }
    for i = 1, #cbuttons do
        local cbutton = _G[cbuttons[i]]
        if not cbutton then
            print(cbuttons[i])
        else
            F.Reskin(cbutton)
        end
    end

    _G.CalendarViewEventAcceptButton.flashTexture:SetTexture('')
    _G.CalendarViewEventTentativeButton.flashTexture:SetTexture('')
    _G.CalendarViewEventDeclineButton.flashTexture:SetTexture('')

    F.ReskinClose(_G.CalendarCloseButton, _G.CalendarFrame, -14, -4)
    F.ReskinClose(_G.CalendarCreateEventCloseButton)
    F.ReskinClose(_G.CalendarViewEventCloseButton)
    F.ReskinClose(_G.CalendarViewHolidayCloseButton)
    F.ReskinClose(_G.CalendarViewRaidCloseButton)
    F.ReskinClose(_G.CalendarMassInviteCloseButton)
    F.ReskinScroll(_G.CalendarTexturePickerScrollBar)
    F.ReskinScroll(_G.CalendarViewEventInviteListScrollFrameScrollBar)
    F.ReskinScroll(_G.CalendarViewEventDescriptionScrollFrameScrollBar)
    F.ReskinScroll(_G.CalendarCreateEventInviteListScrollFrameScrollBar)
    F.ReskinScroll(_G.CalendarCreateEventDescriptionScrollFrameScrollBar)
    F.ReskinDropDown(_G.CalendarCreateEventCommunityDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventTypeDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventHourDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventMinuteDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventAMPMDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventDifficultyOptionDropDown)
    F.ReskinDropDown(_G.CalendarMassInviteCommunityDropDown)
    F.ReskinDropDown(_G.CalendarMassInviteRankMenu)
    F.ReskinInput(_G.CalendarCreateEventTitleEdit)
    F.ReskinInput(_G.CalendarCreateEventInviteEdit)
    F.ReskinInput(_G.CalendarMassInviteMinLevelEdit)
    F.ReskinInput(_G.CalendarMassInviteMaxLevelEdit)
    F.ReskinArrow(_G.CalendarPrevMonthButton, 'left')
    F.ReskinArrow(_G.CalendarNextMonthButton, 'right')
    _G.CalendarPrevMonthButton:SetSize(19, 19)
    _G.CalendarNextMonthButton:SetSize(19, 19)
    F.ReskinCheck(_G.CalendarCreateEventLockEventCheck)

    _G.CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)
end
