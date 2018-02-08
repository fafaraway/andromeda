local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ChannelFrame()
    _G.ChannelFrameLeftInset:DisableDrawLayer("BORDER")
    _G.ChannelFrameLeftInsetBg:Hide()
    _G.ChannelFrameRightInset:DisableDrawLayer("BORDER")
    _G.ChannelFrameRightInsetBg:Hide()
    F.Reskin(_G.ChannelFrameNewButton)

    _G.ChannelRosterScrollFrameTop:SetAlpha(0)
    _G.ChannelRosterScrollFrameBottom:SetAlpha(0)
    F.ReskinScroll(_G.ChannelRosterScrollFrameScrollBar)
    for i = 1, _G.MAX_DISPLAY_CHANNEL_BUTTONS do
        _G["ChannelButton"..i]:SetNormalTexture("")
    end


    F.CreateBD(_G.ChannelFrameDaughterFrame)
    _G.ChannelFrameDaughterFrameTitlebar:Hide()
    _G.ChannelFrameDaughterFrameCorner:Hide()
    F.ReskinInput(_G.ChannelFrameDaughterFrameChannelName)
    F.ReskinInput(_G.ChannelFrameDaughterFrameChannelPassword)
    F.ReskinClose(_G.ChannelFrameDaughterFrameDetailCloseButton)
    F.Reskin(_G.ChannelFrameDaughterFrameOkayButton)
    F.Reskin(_G.ChannelFrameDaughterFrameCancelButton)
end
