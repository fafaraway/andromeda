local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    local r, g, b = C.r, C.g, C.b

    _G.PVEFrameLeftInset:SetAlpha(0)
    _G.PVEFrameBlueBg:SetAlpha(0)
    _G.PVEFrame.shadows:SetAlpha(0)

    _G.PVEFrameTab1:ClearAllPoints()
    _G.PVEFrameTab1:SetPoint('TOPLEFT', _G.PVEFrame, 'BOTTOMLEFT', 10, 0)

    _G.GroupFinderFrameGroupButton1.icon:SetTexture('Interface\\Icons\\INV_Helmet_08')
    _G.GroupFinderFrameGroupButton2.icon:SetTexture('Interface\\Icons\\Icon_Scenarios')
    _G.GroupFinderFrameGroupButton3.icon:SetTexture('Interface\\Icons\\inv_helmet_06')

    for i = 1, 3 do
        local bu = _G.GroupFinderFrame['groupButton' .. i]

        bu.ring:Hide()
        F.Reskin(bu)
        bu.bg:SetColorTexture(r, g, b, 0.25)
        bu.bg:SetInside(bu.__bg)

        bu.icon:SetPoint('LEFT', bu, 'LEFT', 2, 0)
        bu.icon:SetSize(bu:GetHeight() - 4, bu:GetHeight() - 4)
        F.ReskinIcon(bu.icon)
    end

    hooksecurefunc('GroupFinderFrame_SelectGroupButton', function(index)
        for i = 1, 3 do
            local button = _G.GroupFinderFrame['groupButton' .. i]
            if i == index then
                button.bg:Show()
            else
                button.bg:Hide()
            end
        end
    end)

    F.ReskinPortraitFrame(_G.PVEFrame)
    F.ReskinTab(_G.PVEFrameTab1)
    F.ReskinTab(_G.PVEFrameTab2)
    F.ReskinTab(_G.PVEFrameTab3)
end)
