local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    _G.TimeManagerGlobe:Hide()
    _G.TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(unpack(C.TEX_COORD))
    _G.TimeManagerStopwatchCheck:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    _G.TimeManagerStopwatchCheck:SetCheckedTexture(C.Assets.Button.Checked)
    F.CreateBDFrame(_G.TimeManagerStopwatchCheck)

    _G.TimeManagerAlarmHourDropDown:SetWidth(80)
    _G.TimeManagerAlarmMinuteDropDown:SetWidth(80)
    _G.TimeManagerAlarmAMPMDropDown:SetWidth(90)

    F.ReskinPortraitFrame(_G.TimeManagerFrame)
    F.ReskinDropDown(_G.TimeManagerAlarmHourDropDown)
    F.ReskinDropDown(_G.TimeManagerAlarmMinuteDropDown)
    F.ReskinDropDown(_G.TimeManagerAlarmAMPMDropDown)
    F.ReskinInput(_G.TimeManagerAlarmMessageEditBox)
    F.ReskinCheckbox(_G.TimeManagerAlarmEnabledButton)
    F.ReskinCheckbox(_G.TimeManagerMilitaryTimeCheck)
    F.ReskinCheckbox(_G.TimeManagerLocalTimeCheck)

    F.StripTextures(_G.StopwatchFrame)
    F.StripTextures(_G.StopwatchTabFrame)
    F.SetBD(_G.StopwatchFrame)
    F.ReskinClose(_G.StopwatchCloseButton, _G.StopwatchFrame, -2, -2)

    local reset = _G.StopwatchResetButton
    reset:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.27, 0.75)
    reset:SetSize(18, 18)
    reset:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    reset:SetPoint('BOTTOMRIGHT', -5, 7)
    local play = _G.StopwatchPlayPauseButton
    play:GetNormalTexture():SetTexCoord(0.25, 0.75, 0.27, 0.75)
    play:SetSize(18, 18)
    play:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    play:SetPoint('RIGHT', reset, 'LEFT', -2, 0)
end)
