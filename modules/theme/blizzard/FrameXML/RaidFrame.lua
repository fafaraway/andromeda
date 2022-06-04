local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    F.StripTextures(_G.RaidInfoFrame)
    F.SetBD(_G.RaidInfoFrame)
    F.ReskinCheck(_G.RaidFrameAllAssistCheckButton)
    F.StripTextures(_G.RaidInfoFrame.Header)

    _G.RaidInfoFrame:SetPoint('TOPLEFT', _G.RaidFrame, 'TOPRIGHT', 1, -28)
    _G.RaidInfoDetailFooter:Hide()
    _G.RaidInfoDetailHeader:Hide()
    _G.RaidInfoDetailCorner:Hide()

    F.Reskin(_G.RaidFrameRaidInfoButton)
    F.Reskin(_G.RaidFrameConvertToRaidButton)
    F.Reskin(_G.RaidInfoExtendButton)
    F.Reskin(_G.RaidInfoCancelButton)
    F.ReskinClose(_G.RaidInfoCloseButton)
    F.ReskinScroll(_G.RaidInfoScrollFrameScrollBar)
    F.ReskinClose(_G.RaidParentFrameCloseButton)

    F.ReskinPortraitFrame(_G.RaidParentFrame)
    _G.RaidInfoInstanceLabel:DisableDrawLayer('BACKGROUND')
    _G.RaidInfoIDLabel:DisableDrawLayer('BACKGROUND')
end)
