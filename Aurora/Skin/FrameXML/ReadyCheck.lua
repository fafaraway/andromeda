local _, private = ...

local Aurora = private.Aurora
local F = Aurora[1]

function private.FrameXML.ReadyCheck()
    _G.ReadyCheckFrame:SetSize(300, 80)

    F.CreateBD(_G.ReadyCheckListenerFrame)
    F.CreateSD(_G.ReadyCheckListenerFrame)
    _G.ReadyCheckPortrait:SetAlpha(0)
    _G.select(2, _G.ReadyCheckListenerFrame:GetRegions()):Hide()
    _G.ReadyCheckFrameText:SetPoint("CENTER", _G.ReadyCheckListenerFrame, "TOP", 0, -25)

    F.Reskin(_G.ReadyCheckFrameYesButton)
    _G.ReadyCheckFrameYesButton:SetPoint("TOPRIGHT", _G.ReadyCheckListenerFrame, "TOP", -5, -45)
    F.Reskin(_G.ReadyCheckFrameNoButton)
    _G.ReadyCheckFrameNoButton:SetPoint("TOPLEFT", _G.ReadyCheckListenerFrame, "TOP", 5, -45)
end
