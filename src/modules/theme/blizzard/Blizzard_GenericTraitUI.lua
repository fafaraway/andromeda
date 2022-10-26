local F, C = unpack(select(2, ...))

C.Themes['Blizzard_GenericTraitUI'] = function()
    local frame = _G.GenericTraitFrame

    F.StripTextures(frame)
    F.ReskinClose(frame.CloseButton)
    F.SetBD(frame)

    F.ReplaceIconString(frame.Currency.UnspentPointsCount)
    hooksecurefunc(frame.Currency.UnspentPointsCount, 'SetText', F.ReplaceIconString)
end
