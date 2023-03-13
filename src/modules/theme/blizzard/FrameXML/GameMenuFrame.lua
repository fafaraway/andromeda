local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local GameMenuFrame = _G.GameMenuFrame
    F.StripTextures(GameMenuFrame.Header)
    GameMenuFrame.Header:ClearAllPoints()
    GameMenuFrame.Header:SetPoint('TOP', GameMenuFrame, 0, 7)
    F.SetBD(GameMenuFrame)
    GameMenuFrame.Border:Hide()

    local buttons = {
        'GameMenuButtonHelp',
        'GameMenuButtonWhatsNew',
        'GameMenuButtonStore',
        'GameMenuButtonMacros',
        'GameMenuButtonAddons',
        'GameMenuButtonLogout',
        'GameMenuButtonQuit',
        'GameMenuButtonContinue',
        'GameMenuButtonSettings',
        'GameMenuButtonEditMode',
    }

    for _, buttonName in next, buttons do
        local button = _G[buttonName]
        if button then
            F.ReskinButton(button)
        end
    end
end)
