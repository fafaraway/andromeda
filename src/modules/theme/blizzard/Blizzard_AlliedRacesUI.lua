local F, C = unpack(select(2, ...))

C.Themes['Blizzard_AlliedRacesUI'] = function()
    local AlliedRacesFrame = _G.AlliedRacesFrame
    F.ReskinPortraitFrame(AlliedRacesFrame)
    select(2, AlliedRacesFrame.ModelScene:GetRegions()):Hide()

    local scrollFrame = AlliedRacesFrame.RaceInfoFrame.ScrollFrame
    if C.IS_NEW_PATCH_10_1 then
        F.ReskinTrimScroll(scrollFrame.ScrollBar)
    else
        F.ReskinScroll(scrollFrame.ScrollBar)
        scrollFrame.ScrollBar.ScrollUpBorder:Hide()
        scrollFrame.ScrollBar.ScrollDownBorder:Hide()
    end
    AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, 0.8, 0)
    scrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
    scrollFrame.Child.RacialTraitsLabel:SetTextColor(1, 0.8, 0)

    AlliedRacesFrame:HookScript('OnShow', function()
        local parent = scrollFrame.Child
        for i = 1, parent:GetNumChildren() do
            local bu = select(i, parent:GetChildren())

            if bu.Icon and not bu.styled then
                select(3, bu:GetRegions()):Hide()
                F.ReskinIcon(bu.Icon)
                bu.Text:SetTextColor(1, 1, 1)

                bu.styled = true
            end
        end
    end)
end
