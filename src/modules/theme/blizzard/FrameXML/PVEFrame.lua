local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
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
        F.ReskinButton(bu)
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

    for i = 1, 3 do
        local tab = _G['PVEFrameTab' .. i]
        if tab then
            F.ReskinTab(tab)

            if i ~= 1 then
                tab:ClearAllPoints()
                tab:SetPoint('TOPLEFT', _G['PVEFrameTab' .. (i - 1)], 'TOPRIGHT', -10, 0)
            end
        end
    end
end)
