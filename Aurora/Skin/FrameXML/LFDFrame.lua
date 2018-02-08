local _, private = ...

-- [[ Core ]]
local F = _G.unpack(private.Aurora)

function private.FrameXML.LFDFrame()
    --[[ LFDRoleCheckPopup ]]--
    F.CreateBD(_G.LFDRoleCheckPopup)
    F.CreateSD(_G.LFDRoleCheckPopup)

    --[[ skinned in LFGFrame.lua
        LFDRoleCheckPopupRoleButtonTank
        LFDRoleCheckPopupRoleButtonHealer
        LFDRoleCheckPopupRoleButtonDPS
        LFDRoleCheckPopupRoleButtonLeader
    ]]

    F.Reskin(_G.LFDRoleCheckPopupAcceptButton)
    F.Reskin(_G.LFDRoleCheckPopupDeclineButton)

    --[[ LFDReadyCheckPopup ]]--

    --[[ LFDParentFrame ]]--
    local LFDParentFrame = _G.LFDParentFrame
    LFDParentFrame:DisableDrawLayer("BACKGROUND")
    LFDParentFrame:DisableDrawLayer("BORDER")
    LFDParentFrame:DisableDrawLayer("OVERLAY")

    LFDParentFrame.Inset:DisableDrawLayer("BACKGROUND")
    LFDParentFrame.Inset:DisableDrawLayer("BORDER")

    _G.LFDQueueFrameBackground:Hide()

    --[[ skinned in LFGFrame.lua
        LFDParentFrameRoleButtonTank
        LFDParentFrameRoleButtonHealer
        LFDParentFrameRoleButtonDPS
        LFDParentFrameRoleButtonLeader
    ]]

    F.ReskinDropDown(_G.LFDQueueFrameTypeDropDown)

    -- Random Queue
    F.ReskinScroll(_G.LFDQueueFrameRandomScrollFrameScrollBar)
    _G.LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", _G.LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
    _G.LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
    _G.LFDQueueFrameRandomScrollFrameScrollBackgroundTopLeft:Hide()
    _G.LFDQueueFrameRandomScrollFrameScrollBackgroundBottomRight:Hide()

    -- Specific Queue
    F.ReskinScroll(_G.LFDQueueFrameSpecificListScrollFrameScrollBar)
    _G.LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", _G.LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
    _G.LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
    _G.LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()

    F.Reskin(_G.LFDQueueFrameFindGroupButton)
    F.Reskin(_G.LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton)
end
