local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.QuickJoin()
    local QuickJoinFrame = _G.QuickJoinFrame
    _G.QuickJoinScrollFrameTop:Hide()
    _G.QuickJoinScrollFrameMiddle:Hide()
    _G.QuickJoinScrollFrameBottom:Hide()
    F.ReskinScroll(QuickJoinFrame.ScrollFrame.scrollBar)
    F.Reskin(QuickJoinFrame.JoinQueueButton)
end
