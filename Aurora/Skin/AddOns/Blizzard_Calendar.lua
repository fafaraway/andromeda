local _, private = ...

-- [[ Lua Globals ]]
local select, pairs, ipairs = _G.select, _G.pairs, _G.ipairs

-- [[ WoW API ]]
local hooksecurefunc, CreateFrame = _G.hooksecurefunc, _G.CreateFrame
local IsAddOnLoaded = _G.IsAddOnLoaded

-- [[ Core ]]
local Aurora = private.Aurora
local F, C = _G.unpack(Aurora)

function private.AddOns.Blizzard_Calendar()
    local r, g, b = C.r, C.g, C.b

    _G.CalendarFrame:DisableDrawLayer("BORDER")

    for i = 1, 9 do
        select(i, _G.CalendarViewEventFrame:GetRegions()):Hide()
    end
    select(15, _G.CalendarViewEventFrame:GetRegions()):Hide()

    for i = 1, 9 do
        select(i, _G.CalendarViewHolidayFrame:GetRegions()):Hide()
        select(i, _G.CalendarViewRaidFrame:GetRegions()):Hide()
    end

    for i = 1, 3 do
        select(i, _G.CalendarCreateEventTitleFrame:GetRegions()):Hide()
        select(i, _G.CalendarViewEventTitleFrame:GetRegions()):Hide()
        select(i, _G.CalendarViewHolidayTitleFrame:GetRegions()):Hide()
        select(i, _G.CalendarViewRaidTitleFrame:GetRegions()):Hide()
        select(i, _G.CalendarMassInviteTitleFrame:GetRegions()):Hide()
    end

    for i = 1, 42 do
        _G["CalendarDayButton"..i.."DarkFrame"]:SetAlpha(.5)
        local bu = _G["CalendarDayButton"..i]
        bu:DisableDrawLayer("BACKGROUND")
        bu:SetHighlightTexture(C.media.backdrop)
        local hl = bu:GetHighlightTexture()
        hl:SetVertexColor(r, g, b, .2)
        hl.SetAlpha = F.dummy
        hl:SetPoint("TOPLEFT", -1, 1)
        hl:SetPoint("BOTTOMRIGHT")
    end

    for i = 1, 7 do
        _G["CalendarWeekday"..i.."Background"]:SetAlpha(0)
    end

    _G.CalendarViewEventDivider:Hide()
    _G.CalendarCreateEventDivider:Hide()
    _G.CalendarViewEventInviteList:GetRegions():Hide()
    _G.CalendarViewEventDescriptionContainer:GetRegions():Hide()
    select(5, _G.CalendarCreateEventCloseButton:GetRegions()):Hide()
    select(5, _G.CalendarViewEventCloseButton:GetRegions()):Hide()
    select(5, _G.CalendarViewHolidayCloseButton:GetRegions()):Hide()
    select(5, _G.CalendarViewRaidCloseButton:GetRegions()):Hide()
    select(5, _G.CalendarMassInviteCloseButton:GetRegions()):Hide()
    _G.CalendarCreateEventBackground:Hide()
    _G.CalendarCreateEventFrameButtonBackground:Hide()
    _G.CalendarCreateEventMassInviteButtonBorder:Hide()
    _G.CalendarCreateEventCreateButtonBorder:Hide()
    _G.CalendarEventPickerTitleFrameBackgroundLeft:Hide()
    _G.CalendarEventPickerTitleFrameBackgroundMiddle:Hide()
    _G.CalendarEventPickerTitleFrameBackgroundRight:Hide()
    _G.CalendarEventPickerFrameButtonBackground:Hide()
    _G.CalendarEventPickerCloseButtonBorder:Hide()
    _G.CalendarCreateEventRaidInviteButtonBorder:Hide()
    _G.CalendarMonthBackground:SetAlpha(0)
    _G.CalendarYearBackground:SetAlpha(0)
    _G.CalendarFrameModalOverlay:SetAlpha(.25)
    _G.CalendarViewHolidayInfoTexture:SetAlpha(0)
    _G.CalendarTexturePickerTitleFrameBackgroundLeft:Hide()
    _G.CalendarTexturePickerTitleFrameBackgroundMiddle:Hide()
    _G.CalendarTexturePickerTitleFrameBackgroundRight:Hide()
    _G.CalendarTexturePickerFrameButtonBackground:Hide()
    _G.CalendarTexturePickerAcceptButtonBorder:Hide()
    _G.CalendarTexturePickerCancelButtonBorder:Hide()
    _G.CalendarClassTotalsButtonBackgroundTop:Hide()
    _G.CalendarClassTotalsButtonBackgroundMiddle:Hide()
    _G.CalendarClassTotalsButtonBackgroundBottom:Hide()
    _G.CalendarFilterFrameLeft:Hide()
    _G.CalendarFilterFrameMiddle:Hide()
    _G.CalendarFilterFrameRight:Hide()
        _G.CalendarMassInviteFrameDivider:Hide()

    F.SetBD(_G.CalendarFrame, 12, 0, -9, 4)
    F.CreateBD(_G.CalendarViewEventFrame)
    F.CreateBD(_G.CalendarViewHolidayFrame)
    F.CreateBD(_G.CalendarViewRaidFrame)
    F.CreateBD(_G.CalendarCreateEventFrame)
    F.CreateBD(_G.CalendarClassTotalsButton)
    F.CreateBD(_G.CalendarTexturePickerFrame)
    F.CreateBD(_G.CalendarViewEventInviteList, .25)
    F.CreateBD(_G.CalendarViewEventDescriptionContainer, .25)
    F.CreateBD(_G.CalendarCreateEventInviteList, .25)
    F.CreateBD(_G.CalendarCreateEventDescriptionContainer, .25)
    F.CreateBD(_G.CalendarEventPickerFrame, .25)
    F.CreateBD(_G.CalendarMassInviteFrame)

    _G.CalendarWeekdaySelectedTexture:SetDesaturated(true)
    _G.CalendarWeekdaySelectedTexture:SetVertexColor(r, g, b)

    hooksecurefunc("CalendarFrame_SetToday", function()
        _G.CalendarTodayFrame:SetAllPoints()
    end)

    _G.CalendarTodayFrame:SetScript("OnUpdate", nil)
    _G.CalendarTodayTextureGlow:Hide()
    _G.CalendarTodayTexture:Hide()

    _G.CalendarTodayFrame:SetBackdrop({
        edgeFile = C.media.backdrop,
        edgeSize = 1,
    })
    _G.CalendarTodayFrame:SetBackdropBorderColor(r, g, b)

    for i, class in ipairs(_G.CLASS_SORT_ORDER) do
        local bu = _G["CalendarClassButton"..i]
        bu:GetRegions():Hide()
        F.CreateBG(bu)

        local ic = bu:GetNormalTexture()
        ic:SetTexCoord(_G.unpack(Aurora.classIcons[class]))
    end

    local bd = CreateFrame("Frame", nil, _G.CalendarFilterFrame)
    bd:SetPoint("TOPLEFT", 40, 0)
    bd:SetPoint("BOTTOMRIGHT", -19, 0)
    bd:SetFrameLevel(_G.CalendarFilterFrame:GetFrameLevel()-1)
    F.CreateBD(bd, 0)

    F.CreateGradient(bd)

    local downtex = _G.CalendarFilterButton:CreateTexture(nil, "ARTWORK")
    downtex:SetTexture(C.media.arrowDown)
    downtex:SetSize(8, 8)
    downtex:SetPoint("CENTER")
    downtex:SetVertexColor(1, 1, 1)

    for i = 1, 6 do
        local vline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
        vline:SetHeight(546)
        vline:SetWidth(1)
        vline:SetPoint("TOP", _G["CalendarDayButton"..i], "TOPRIGHT")
        F.CreateBD(vline)
    end
    for i = 1, 36, 7 do
        local hline = CreateFrame("Frame", nil, _G["CalendarDayButton"..i])
        hline:SetWidth(637)
        hline:SetHeight(1)
        hline:SetPoint("LEFT", _G["CalendarDayButton"..i], "TOPLEFT")
        F.CreateBD(hline)
    end

    if not(IsAddOnLoaded("CowTip") or IsAddOnLoaded("TipTac") or IsAddOnLoaded("FreebTip") or IsAddOnLoaded("lolTip") or IsAddOnLoaded("StarTip") or IsAddOnLoaded("TipTop")) then
        local tooltips = {_G.CalendarContextMenu, _G.CalendarInviteStatusContextMenu}

        for _, tooltip in pairs(tooltips) do
            tooltip:SetBackdrop(nil)
            local bg = CreateFrame("Frame", nil, tooltip)
            bg:SetPoint("TOPLEFT", 2, -2)
            bg:SetPoint("BOTTOMRIGHT", -1, 2)
            bg:SetFrameLevel(tooltip:GetFrameLevel()-1)
            F.CreateBD(bg)
        end
    end

    _G.CalendarViewEventFrame:SetPoint("TOPLEFT", _G.CalendarFrame, "TOPRIGHT", -8, -24)
    _G.CalendarViewHolidayFrame:SetPoint("TOPLEFT", _G.CalendarFrame, "TOPRIGHT", -8, -24)
    _G.CalendarViewRaidFrame:SetPoint("TOPLEFT", _G.CalendarFrame, "TOPRIGHT", -8, -24)
    _G.CalendarCreateEventFrame:SetPoint("TOPLEFT", _G.CalendarFrame, "TOPRIGHT", -8, -24)
    _G.CalendarCreateEventInviteButton:SetPoint("TOPLEFT", _G.CalendarCreateEventInviteEdit, "TOPRIGHT", 1, 1)
    _G.CalendarClassButton1:SetPoint("TOPLEFT", _G.CalendarClassButtonContainer, "TOPLEFT", 5, 0)

    _G.CalendarCreateEventHourDropDown:SetWidth(80)
    _G.CalendarCreateEventMinuteDropDown:SetWidth(80)
    _G.CalendarCreateEventAMPMDropDown:SetWidth(90)

    local line = _G.CalendarMassInviteFrame:CreateTexture(nil, "BACKGROUND")
    line:SetSize(240, 1)
    line:SetPoint("TOP", _G.CalendarMassInviteFrame, "TOP", 0, -150)
    line:SetTexture(C.media.backdrop)
    line:SetVertexColor(0, 0, 0)

    _G.CalendarMassInviteFrame:ClearAllPoints()
    _G.CalendarMassInviteFrame:SetPoint("BOTTOMLEFT", _G.CalendarCreateEventCreateButton, "TOPRIGHT", 10, 0)

    _G.CalendarTexturePickerFrame:ClearAllPoints()
    _G.CalendarTexturePickerFrame:SetPoint("TOPLEFT", _G.CalendarFrame, "TOPRIGHT", 311, -24)

    local cbuttons = {"CalendarViewEventAcceptButton", "CalendarViewEventTentativeButton", "CalendarViewEventDeclineButton", "CalendarViewEventRemoveButton", "CalendarCreateEventMassInviteButton", "CalendarCreateEventCreateButton", "CalendarCreateEventInviteButton", "CalendarEventPickerCloseButton", "CalendarCreateEventRaidInviteButton", "CalendarTexturePickerAcceptButton", "CalendarTexturePickerCancelButton", "CalendarFilterButton", "CalendarMassInviteGuildAcceptButton"}
    for i = 1, #cbuttons do
        local cbutton = _G[cbuttons[i]]
        F.Reskin(cbutton)
    end

    _G.CalendarViewEventAcceptButton.flashTexture:SetTexture("")
    _G.CalendarViewEventTentativeButton.flashTexture:SetTexture("")
    _G.CalendarViewEventDeclineButton.flashTexture:SetTexture("")

    F.ReskinClose(_G.CalendarCloseButton, "TOPRIGHT", _G.CalendarFrame, "TOPRIGHT", -14, -4)
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
    F.ReskinDropDown(_G.CalendarCreateEventTypeDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventHourDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventMinuteDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventAMPMDropDown)
    F.ReskinDropDown(_G.CalendarCreateEventDifficultyOptionDropDown)
    F.ReskinDropDown(_G.CalendarMassInviteGuildRankMenu)
    F.ReskinInput(_G.CalendarCreateEventTitleEdit)
    F.ReskinInput(_G.CalendarCreateEventInviteEdit)
    F.ReskinInput(_G.CalendarMassInviteGuildMinLevelEdit)
    F.ReskinInput(_G.CalendarMassInviteGuildMaxLevelEdit)
    F.ReskinArrow(_G.CalendarPrevMonthButton, "Left")
    F.ReskinArrow(_G.CalendarNextMonthButton, "Right")
    _G.CalendarPrevMonthButton:SetSize(19, 19)
    _G.CalendarNextMonthButton:SetSize(19, 19)
    F.ReskinCheck(_G.CalendarCreateEventLockEventCheck)

    _G.CalendarCreateEventDifficultyOptionDropDown:SetWidth(150)
end
