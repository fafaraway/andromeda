local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local r, g, b = C.r, C.g, C.b

    for i = 1, 6 do
        select(i, _G.GhostFrame:GetRegions()):Hide()
    end
    F.ReskinIcon(_G.GhostFrameContentsFrameIcon)

    local bg = F.SetBD(_G.GhostFrame, 0)
    F.CreateGradient(bg)
    _G.GhostFrame:SetHighlightTexture(C.Assets.Texture.Backdrop)
    _G.GhostFrame:GetHighlightTexture():SetVertexColor(r, g, b, 0.25)
end)
