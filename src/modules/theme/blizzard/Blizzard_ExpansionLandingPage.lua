local F, C = unpack(select(2, ...))

local function skinFactionCategory(button)
    if button.UnlockedState and not button.styled then
        button.UnlockedState.WatchFactionButton:SetSize(28, 28)
        F.ReskinCheck(button.UnlockedState.WatchFactionButton)
        button.UnlockedState.WatchFactionButton.Label:SetFontObject(_G.Game18Font)
        button.styled = true
    end
end

C.Themes['Blizzard_AdventureMap'] = function()
    local frame = _G.ExpansionLandingPage
    local panel

    frame:HookScript('OnShow', function()
        if not panel then
            if frame.Overlay then
                for i = 1, frame.Overlay:GetNumChildren() do
                    local child = select(i, frame.Overlay:GetChildren())
                    if child.DragonridingPanel then
                        panel = child
                        break
                    end
                end
            end
        end

        if panel and not panel.styled then
            panel.NineSlice:SetAlpha(0)
            panel.Background:SetAlpha(0)
            F.SetBD(panel)

            if panel.DragonridingPanel then
                F.ReskinButton(panel.DragonridingPanel.SkillsButton)
            end

            if panel.CloseButton then
                F.ReskinClose(panel.CloseButton)
            end

            if panel.MajorFactionList then
                F.ReskinTrimScroll(panel.MajorFactionList.ScrollBar)
                panel.MajorFactionList.ScrollBox:ForEachFrame(skinFactionCategory)
                hooksecurefunc(panel.MajorFactionList.ScrollBox, 'Update', function(self)
                    self:ForEachFrame(skinFactionCategory)
                end)
            end

            panel.styled = true
        end
    end)
end
