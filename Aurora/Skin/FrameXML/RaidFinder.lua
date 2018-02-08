local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.RaidFinder()
    _G.RaidFinderFrameRoleBackground:Hide()
    _G.RaidFinderFrameBtnCornerRight:Hide()
    _G.RaidFinderFrameButtonBottomBorder:Hide()

    _G.RaidFinderFrameRoleInset:DisableDrawLayer("BORDER")
    _G.RaidFinderFrameRoleInsetBg:Hide()


    _G.RaidFinderFrameBottomInset:DisableDrawLayer("BORDER")
    _G.RaidFinderFrameBottomInsetBg:Hide()

    _G.RaidFinderQueueFrameBackground:Hide()

    --[[ skinned in LFGFrame.lua
        RaidFinderQueueFrameRoleButtonTank
        RaidFinderQueueFrameRoleButtonHealer
        RaidFinderQueueFrameRoleButtonDPS
        RaidFinderQueueFrameRoleButtonLeader
    ]]

    F.ReskinDropDown(_G.RaidFinderQueueFrameSelectionDropDown)
    F.ReskinScroll(_G.RaidFinderQueueFrameScrollFrameScrollBar)
    _G.RaidFinderQueueFrameScrollFrameScrollBackground:Hide()
    _G.RaidFinderQueueFrameScrollFrameScrollBackgroundTopLeft:Hide()
    _G.RaidFinderQueueFrameScrollFrameScrollBackgroundBottomRight:Hide()


    F.Reskin(_G.RaidFinderQueueFramePartyBackfillBackfillButton)
    F.Reskin(_G.RaidFinderQueueFramePartyBackfillNoBackfillButton)
    F.Reskin(_G.RaidFinderQueueFrameIneligibleFrameLeaveQueueButton)

    F.Reskin(_G.RaidFinderFrameFindRaidButton)
end
