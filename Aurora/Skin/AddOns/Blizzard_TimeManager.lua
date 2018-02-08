local _, private = ...

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_TimeManager()
    _G.TimeManagerGlobe:Hide()
    _G.StopwatchFrameBackgroundLeft:Hide()
    _G.select(2, _G.StopwatchFrame:GetRegions()):Hide()
    _G.StopwatchTabFrameLeft:Hide()
    _G.StopwatchTabFrameMiddle:Hide()
    _G.StopwatchTabFrameRight:Hide()

    _G.TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
    _G.TimeManagerStopwatchCheck:SetCheckedTexture(C.media.checked)
    F.CreateBG(_G.TimeManagerStopwatchCheck)

    _G.TimeManagerAlarmHourDropDown:SetWidth(80)
    _G.TimeManagerAlarmMinuteDropDown:SetWidth(80)
    _G.TimeManagerAlarmAMPMDropDown:SetWidth(90)

    F.ReskinPortraitFrame(_G.TimeManagerFrame, true)
    F.CreateBD(_G.TimeManagerFrame)
    F.CreateSD(_G.TimeManagerFrame)

    F.CreateBD(_G.StopwatchFrame)
    F.CreateSD(_G.StopwatchFrame)
    F.ReskinDropDown(_G.TimeManagerAlarmHourDropDown)
    F.ReskinDropDown(_G.TimeManagerAlarmMinuteDropDown)
    F.ReskinDropDown(_G.TimeManagerAlarmAMPMDropDown)
    F.ReskinInput(_G.TimeManagerAlarmMessageEditBox)
    F.ReskinCheck(_G.TimeManagerAlarmEnabledButton)
    F.ReskinCheck(_G.TimeManagerMilitaryTimeCheck)
    F.ReskinCheck(_G.TimeManagerLocalTimeCheck)
    F.ReskinClose(_G.StopwatchCloseButton, "TOPRIGHT", _G.StopwatchFrame, "TOPRIGHT", -2, -2)
end
