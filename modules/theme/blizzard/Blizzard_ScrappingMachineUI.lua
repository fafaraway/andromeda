local F, C = unpack(select(2, ...))

C.Themes['Blizzard_ScrappingMachineUI'] = function()
    F.ReskinPortraitFrame(_G.ScrappingMachineFrame)
    F.Reskin(_G.ScrappingMachineFrame.ScrapButton)

    local ItemSlots = _G.ScrappingMachineFrame.ItemSlots
    F.StripTextures(ItemSlots)

    for button in pairs(ItemSlots.scrapButtons.activeObjects) do
        F.StripTextures(button)
        button.Icon:SetTexCoord(unpack(C.TEX_COORD))
        button.bg = F.CreateBDFrame(button.Icon, 0.25)
        F.ReskinIconBorder(button.IconBorder)
        local hl = button:GetHighlightTexture()
        hl:SetColorTexture(1, 1, 1, 0.25)
        hl:SetAllPoints(button.Icon)
    end
end
