local F, C = unpack(select(2, ...))

local function ReskinConduitList(frame)
    local header = frame.CategoryButton.Container
    if header and not header.styled then
        header:DisableDrawLayer('BACKGROUND')
        local bg = F.CreateBDFrame(header, 0.25)
        bg:SetPoint('TOPLEFT', 2, 0)
        bg:SetPoint('BOTTOMRIGHT', 15, 0)

        header.styled = true
    end

    for button in frame.pool:EnumerateActive() do
        if button and not button.styled then
            button.Spec.IconOverlay:Hide()
            F.ReskinIcon(button.Spec.Icon):SetFrameLevel(8)

            button.styled = true
        end
    end
end

C.Themes['Blizzard_Soulbinds'] = function()
    local SoulbindViewer = _G.SoulbindViewer

    F.StripTextures(SoulbindViewer)
    SoulbindViewer.Background:SetAlpha(0)
    F.SetBD(SoulbindViewer)
    F.ReskinClose(SoulbindViewer.CloseButton)
    F.ReskinButton(SoulbindViewer.CommitConduitsButton)
    F.ReskinButton(SoulbindViewer.ActivateSoulbindButton)

    local numChildrenStyled = 0
    hooksecurefunc(SoulbindViewer.ConduitList.ScrollBox, 'Update', function(self)
        local numChildren = self.ScrollTarget:GetNumChildren()
        if numChildren > numChildrenStyled then
            for i = 1, numChildren do
                local list = select(i, self.ScrollTarget:GetChildren())
                if list and not list.hooked then
                    hooksecurefunc(list, 'Layout', ReskinConduitList)
                    list.hooked = true
                end
            end

            numChildrenStyled = numChildren
        end
    end)
end
