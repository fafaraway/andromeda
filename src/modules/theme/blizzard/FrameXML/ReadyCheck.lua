local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    -- Ready check
    F.StripTextures(_G.ReadyCheckListenerFrame)
    F.SetBD(_G.ReadyCheckListenerFrame, nil, 30, -1, 1, -1)
    _G.ReadyCheckPortrait:SetAlpha(0)

    F.ReskinButton(_G.ReadyCheckFrameYesButton)
    F.ReskinButton(_G.ReadyCheckFrameNoButton)

    -- Role poll
    F.StripTextures(_G.RolePollPopup)
    F.SetBD(_G.RolePollPopup)
    F.ReskinButton(_G.RolePollPopupAcceptButton)
    F.ReskinClose(_G.RolePollPopupCloseButton)

    F.ReskinRole(_G.RolePollPopupRoleButtonTank, 'TANK')
    F.ReskinRole(_G.RolePollPopupRoleButtonHealer, 'HEALER')
    F.ReskinRole(_G.RolePollPopupRoleButtonDPS, 'DPS')
end)
