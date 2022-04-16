local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    TimeManagerGlobe:Hide()
    TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(unpack(C.TEX_COORD))
    TimeManagerStopwatchCheck:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    TimeManagerStopwatchCheck:SetCheckedTexture(C.Assets.Button.Checked)
    F.CreateBDFrame(TimeManagerStopwatchCheck)

    TimeManagerAlarmHourDropDown:SetWidth(80)
    TimeManagerAlarmMinuteDropDown:SetWidth(80)
    TimeManagerAlarmAMPMDropDown:SetWidth(90)

    F.ReskinPortraitFrame(TimeManagerFrame)
    F.ReskinDropDown(TimeManagerAlarmHourDropDown)
    F.ReskinDropDown(TimeManagerAlarmMinuteDropDown)
    F.ReskinDropDown(TimeManagerAlarmAMPMDropDown)
    F.ReskinInput(TimeManagerAlarmMessageEditBox)
    F.ReskinCheck(TimeManagerAlarmEnabledButton)
    F.ReskinCheck(TimeManagerMilitaryTimeCheck)
    F.ReskinCheck(TimeManagerLocalTimeCheck)

    F.StripTextures(StopwatchFrame)
    F.StripTextures(StopwatchTabFrame)
    F.SetBD(StopwatchFrame)
    F.ReskinClose(StopwatchCloseButton, StopwatchFrame, -2, -2)

    local reset = StopwatchResetButton
    reset:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.27, 0.75)
    reset:SetSize(18, 18)
    reset:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    reset:SetPoint('BOTTOMRIGHT', -5, 7)
    local play = StopwatchPlayPauseButton
    play:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.27, 0.75)
    play:SetSize(18, 18)
    play:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    play:SetPoint('RIGHT', reset, 'LEFT', -2, 0)
end)
