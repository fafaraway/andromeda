local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    _G.InboxFrameBg:Hide()
    _G.ItemTextPrevPageButton:GetRegions():Hide()
    _G.ItemTextNextPageButton:GetRegions():Hide()
    _G.ItemTextMaterialTopLeft:SetAlpha(0)
    _G.ItemTextMaterialTopRight:SetAlpha(0)
    _G.ItemTextMaterialBotLeft:SetAlpha(0)
    _G.ItemTextMaterialBotRight:SetAlpha(0)

    F.ReskinPortraitFrame(_G.ItemTextFrame)
    F.ReskinScroll(_G.ItemTextScrollFrameScrollBar)
    F.ReskinArrow(_G.ItemTextPrevPageButton, 'left')
    F.ReskinArrow(_G.ItemTextNextPageButton, 'right')
    _G.ItemTextFramePageBg:SetAlpha(0)
    _G.ItemTextPageText:SetTextColor(1, 1, 1)
    _G.ItemTextPageText.SetTextColor = nop
end)
