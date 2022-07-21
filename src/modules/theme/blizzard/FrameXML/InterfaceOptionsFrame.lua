local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    local styled

    _G.InterfaceOptionsFrame:HookScript('OnShow', function()
        if styled then
            return
        end

        F.StripTextures(_G.InterfaceOptionsFrameTab1)
        F.StripTextures(_G.InterfaceOptionsFrameTab2)
        F.StripTextures(_G.InterfaceOptionsFrameCategories)
        F.StripTextures(_G.InterfaceOptionsFramePanelContainer)
        F.StripTextures(_G.InterfaceOptionsFrameAddOns)

        F.SetBD(_G.InterfaceOptionsFrame)
        _G.InterfaceOptionsFrame.Border:Hide()
        F.StripTextures(_G.InterfaceOptionsFrame.Header)
        _G.InterfaceOptionsFrame.Header:ClearAllPoints()
        _G.InterfaceOptionsFrame.Header:SetPoint('TOP', _G.InterfaceOptionsFrame, 0, 0)

        F.Reskin(_G.InterfaceOptionsFrameDefaults)
        F.Reskin(_G.InterfaceOptionsFrameOkay)
        F.Reskin(_G.InterfaceOptionsFrameCancel)

        if _G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG then
            _G.CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()
        end

        local line = _G.InterfaceOptionsFrame:CreateTexture(nil, 'ARTWORK')
        line:SetSize(C.MULT, 546)
        line:SetPoint('LEFT', 205, 10)
        line:SetColorTexture(1, 1, 1, 0.25)

        local interfacePanels = {
            'InterfaceOptionsControlsPanel',
            'InterfaceOptionsCombatPanel',
            'InterfaceOptionsDisplayPanel',
            'InterfaceOptionsSocialPanel',
            'InterfaceOptionsActionBarsPanel',
            'InterfaceOptionsNamesPanel',
            'InterfaceOptionsNamesPanelFriendly',
            'InterfaceOptionsNamesPanelEnemy',
            'InterfaceOptionsNamesPanelUnitNameplates',
            'InterfaceOptionsCameraPanel',
            'InterfaceOptionsMousePanel',
            'InterfaceOptionsAccessibilityPanel',
            'InterfaceOptionsColorblindPanel',
            'CompactUnitFrameProfiles',
            'CompactUnitFrameProfilesGeneralOptionsFrame',
        }

        for _, name in pairs(interfacePanels) do
            local frame = _G[name]
            if frame then
                for i = 1, frame:GetNumChildren() do
                    local child = select(i, frame:GetChildren())
                    if child:IsObjectType('CheckButton') then
                        F.ReskinCheckbox(child)
                    elseif child:IsObjectType('Button') then
                        F.Reskin(child)
                    elseif child:IsObjectType('Slider') then
                        F.ReskinSlider(child)
                    elseif child:IsObjectType('Frame') and child.Left and child.Middle and child.Right then
                        F.ReskinDropDown(child)
                    end
                end
            else
                if C.IS_DEVELOPER then
                    print(name, 'not found.')
                end
            end
        end

        styled = true
    end)

    hooksecurefunc('InterfaceOptions_AddCategory', function()
        for i = 1, #_G.INTERFACEOPTIONS_ADDONCATEGORIES do
            local bu = _G['InterfaceOptionsFrameAddOnsButton' .. i .. 'Toggle']
            if bu and not bu.styled then
                F.ReskinCollapse(bu)
                bu:GetPushedTexture():SetAlpha(0)

                bu.styled = true
            end
        end
    end)
end)
