local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.RecruitAFriendFrame()
    local RecruitAFriendFrame = _G.RecruitAFriendFrame
    local RecruitAFriendSentFrame = _G.RecruitAFriendSentFrame

    RecruitAFriendFrame.NoteFrame:DisableDrawLayer("BACKGROUND")

    F.CreateBD(RecruitAFriendFrame)
    F.ReskinClose(_G.RecruitAFriendFrameCloseButton)
    F.Reskin(RecruitAFriendFrame.SendButton)
    F.ReskinInput(_G.RecruitAFriendNameEditBox)

    F.CreateBDFrame(RecruitAFriendFrame.NoteFrame, .25)

    F.CreateBD(RecruitAFriendSentFrame)
    F.Reskin(RecruitAFriendSentFrame.OKButton)
    F.ReskinClose(_G.RecruitAFriendSentFrameCloseButton)
end
