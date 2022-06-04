local F, C = unpack(select(2, ...))

C.Themes['Blizzard_ObliterumUI'] = function()
    local obliterum = _G.ObliterumForgeFrame

    F.ReskinPortraitFrame(obliterum)
    F.Reskin(obliterum.ObliterateButton)
    F.ReskinIcon(obliterum.ItemSlot.Icon)
end
