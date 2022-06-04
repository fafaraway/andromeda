local F, C = unpack(select(2, ...))

C.Themes['Blizzard_BattlefieldMap'] = function()
    local BattlefieldMapFrame = _G.BattlefieldMapFrame
    local BorderFrame = BattlefieldMapFrame.BorderFrame

    F.StripTextures(BorderFrame)
    F.SetBD(BattlefieldMapFrame, nil, -1, 3, -1, 2)
    F.ReskinClose(BorderFrame.CloseButton)

    F.StripTextures(_G.OpacityFrame)
    F.SetBD(_G.OpacityFrame)
    F.ReskinSlider(_G.OpacityFrameSlider, true)
end
