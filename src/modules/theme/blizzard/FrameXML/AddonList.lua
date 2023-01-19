local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    F.ReskinPortraitFrame(_G.AddonList)
    F.Reskin(_G.AddonListEnableAllButton)
    F.Reskin(_G.AddonListDisableAllButton)
    F.Reskin(_G.AddonListCancelButton)
    F.Reskin(_G.AddonListOkayButton)
    F.ReskinCheckButton(_G.AddonListForceLoad)
    F.ReskinDropDown(_G.AddonCharacterDropDown)
    F.ReskinTrimScroll(_G.AddonList.ScrollBar)

    _G.AddonListForceLoad:SetSize(16, 16)
    _G.AddonCharacterDropDown:SetWidth(170)

    local function forceSaturation(self, _, force)
        if force then
            return
        end
        self:SetVertexColor(C.r, C.g, C.b)
        self:SetDesaturated(true, true)
    end

    hooksecurefunc(_G.AddonList.ScrollBox, 'Update', function(self)
        for i = 1, self.ScrollTarget:GetNumChildren() do
            local child = select(i, self.ScrollTarget:GetChildren())
            if not child.styled then
                F.ReskinCheckButton(child.Enabled, true)
                child.Enabled:SetSize(14, 14)
                F.Reskin(child.LoadAddonButton)
                hooksecurefunc(child.Enabled:GetCheckedTexture(), 'SetDesaturated', forceSaturation)

                child.styled = true
            end
        end
    end)

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
