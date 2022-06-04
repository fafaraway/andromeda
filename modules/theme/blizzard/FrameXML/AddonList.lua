local F, C = unpack(select(2, ...))

table.insert(C.BlizzThemes, function()
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    F.ReskinPortraitFrame(_G.AddonList)
    F.Reskin(_G.AddonListEnableAllButton)
    F.Reskin(_G.AddonListDisableAllButton)
    F.Reskin(_G.AddonListCancelButton)
    F.Reskin(_G.AddonListOkayButton)
    F.ReskinCheck(_G.AddonListForceLoad)
    F.ReskinDropDown(_G.AddonCharacterDropDown)
    F.ReskinScroll(_G.AddonListScrollFrameScrollBar)

    _G.AddonListForceLoad:SetSize(26, 26)
    _G.AddonCharacterDropDown:SetWidth(170)

    for i = 1, _G.MAX_ADDONS_DISPLAYED do
        local checkbox = _G['AddonListEntry' .. i .. 'Enabled']
        F.ReskinCheck(checkbox, false, true)
        F.Reskin(_G['AddonListEntry' .. i .. 'Load'])
    end

    hooksecurefunc('AddonList_Update', function()
        for i = 1, _G.MAX_ADDONS_DISPLAYED do
            local entry = _G['AddonListEntry' .. i]
            if entry and entry:IsShown() then
                local checkbox = _G['AddonListEntry' .. i .. 'Enabled']
                if checkbox.forceSaturation then
                    local tex = checkbox:GetCheckedTexture()
                    if checkbox.state == 2 then
                        tex:SetDesaturated(true)
                        tex:SetVertexColor(C.r, C.g, C.b)
                    elseif checkbox.state == 1 then
                        tex:SetVertexColor(1, 0.8, 0, 0.8)
                    end
                end
            end
        end
    end)
end)
