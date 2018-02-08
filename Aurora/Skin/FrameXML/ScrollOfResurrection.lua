local _, private = ...

-- [[ Lua Globals ]]
local select = _G.select

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.ScrollOfResurrection()
    local ScrollOfResurrectionSelectionFrame = _G.ScrollOfResurrectionSelectionFrame
    _G.ScrollOfResurrectionSelectionFrameBackground:Hide()
    F.CreateBD(ScrollOfResurrectionSelectionFrame)
    F.ReskinInput(ScrollOfResurrectionSelectionFrame.targetEditBox)

    F.CreateBD(ScrollOfResurrectionSelectionFrame.list, .25)
    F.ReskinScroll(ScrollOfResurrectionSelectionFrame.list.scrollFrame.scrollBar)

    F.Reskin(_G.ScrollOfResurrectionSelectionFrameAcceptButton)
    F.Reskin(_G.ScrollOfResurrectionSelectionFrameCancelButton)

    local ScrollOfResurrectionFrame = _G.ScrollOfResurrectionFrame
    F.CreateBD(ScrollOfResurrectionFrame)
    F.ReskinInput(ScrollOfResurrectionFrame.targetEditBox)
    for i = 1, 9 do
        select(i, ScrollOfResurrectionFrame.noteFrame:GetRegions()):Hide()
    end
    F.Reskin(_G.ScrollOfResurrectionFrameAcceptButton)
    F.Reskin(_G.ScrollOfResurrectionFrameCancelButton)
end
