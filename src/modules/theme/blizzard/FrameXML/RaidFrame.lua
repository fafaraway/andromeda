local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    F.StripTextures(_G.RaidInfoFrame)
    F.SetBD(_G.RaidInfoFrame)
    F.ReskinCheckbox(_G.RaidFrameAllAssistCheckButton)
    F.StripTextures(_G.RaidInfoFrame.Header)

    _G.RaidInfoFrame:SetPoint('TOPLEFT', _G.RaidFrame, 'TOPRIGHT', 1, -28)
    _G.RaidInfoDetailFooter:Hide()
    _G.RaidInfoDetailHeader:Hide()

    F.ReskinButton(_G.RaidFrameRaidInfoButton)
    F.ReskinButton(_G.RaidFrameConvertToRaidButton)
    F.ReskinButton(_G.RaidInfoExtendButton)
    F.ReskinButton(_G.RaidInfoCancelButton)
    F.ReskinClose(_G.RaidInfoCloseButton)
    F.ReskinTrimScroll(_G.RaidInfoFrame.ScrollBar)
    F.ReskinClose(_G.RaidParentFrameCloseButton)

    F.ReskinPortraitFrame(_G.RaidParentFrame)
    _G.RaidInfoInstanceLabel:DisableDrawLayer('BACKGROUND')
    _G.RaidInfoIDLabel:DisableDrawLayer('BACKGROUND')
end)
