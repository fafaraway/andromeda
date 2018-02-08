local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.SplashFrame()
    local SplashFrame = _G.SplashFrame
    F.Reskin(SplashFrame.BottomCloseButton)
    F.ReskinClose(SplashFrame.TopCloseButton)

    SplashFrame.TopCloseButton:ClearAllPoints()

    SplashFrame.TopCloseButton:SetPoint("TOPRIGHT", SplashFrame, "TOPRIGHT", -18, -18)
end
