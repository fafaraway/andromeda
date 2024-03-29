local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    -- Ready check
    F.SetBD(_G.ReadyCheckFrame)
    _G.ReadyCheckPortrait:SetAlpha(0)
    select(2, _G.ReadyCheckListenerFrame:GetRegions()):Hide()

    _G.ReadyCheckFrame:HookScript('OnShow', function(self)
        if self.initiator and UnitIsUnit('player', self.initiator) then
            self:Hide()
        end
    end)

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
