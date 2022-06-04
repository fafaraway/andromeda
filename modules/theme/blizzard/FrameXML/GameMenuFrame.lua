local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    local GameMenuFrame = _G.GameMenuFrame
    F.StripTextures(GameMenuFrame.Header)
    GameMenuFrame.Header:ClearAllPoints()
    GameMenuFrame.Header:SetPoint('TOP', GameMenuFrame, 0, 7)
    F.SetBD(GameMenuFrame)
    GameMenuFrame.Border:Hide()

    local buttons = {
        _G.GameMenuButtonHelp,
        _G.GameMenuButtonWhatsNew,
        _G.GameMenuButtonStore,
        _G.GameMenuButtonOptions,
        _G.GameMenuButtonUIOptions,
        _G.GameMenuButtonKeybindings,
        _G.GameMenuButtonMacros,
        _G.GameMenuButtonAddons,
        _G.GameMenuButtonLogout,
        _G.GameMenuButtonQuit,
        _G.GameMenuButtonContinue,
    }

    for _, button in next, buttons do
        F.Reskin(button)
    end
end)
