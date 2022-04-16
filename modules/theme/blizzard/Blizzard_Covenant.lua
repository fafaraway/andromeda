local F, C = unpack(select(2, ...))

C.Themes['Blizzard_CovenantPreviewUI'] = function()
    local CovenantPreviewFrame = CovenantPreviewFrame
    F.Reskin(CovenantPreviewFrame.SelectButton)

    local infoPanel = CovenantPreviewFrame.InfoPanel
    infoPanel.Name:SetTextColor(1, 0.8, 0)
    infoPanel.Location:SetTextColor(1, 1, 1)
    infoPanel.Description:SetTextColor(1, 1, 1)
    infoPanel.AbilitiesFrame.AbilitiesLabel:SetTextColor(1, 0.8, 0)
    infoPanel.SoulbindsFrame.SoulbindsLabel:SetTextColor(1, 0.8, 0)
    infoPanel.CovenantFeatureFrame.Label:SetTextColor(1, 0.8, 0)

    hooksecurefunc(CovenantPreviewFrame, 'TryShow', function(self)
        if not self.bg then
            self.Background:SetAlpha(0)
            self.BorderFrame:SetAlpha(0)
            self.Title:DisableDrawLayer('BACKGROUND')
            self.Title.Text:SetTextColor(1, 0.8, 0)
            self.Title.Text:SetFontObject(SystemFont_Huge1)
            self.ModelSceneContainer.ModelSceneBorder:SetAlpha(0)
            F.CreateBDFrame(self.Title, 0.25)
            F.ReskinClose(self.CloseButton)
            self.bg = F.SetBD(self)
        end
        self.CloseButton:SetPoint('TOPRIGHT', -6, -6)
    end)
end

-- Blizzard_CovenantSanctum

local function reskinTalentsList(self)
    for frame in self.talentPool:EnumerateActive() do
        if not frame.bg then
            frame.Border:SetAlpha(0)
            frame.IconBorder:SetAlpha(0)
            frame.TierBorder:SetAlpha(0)
            frame.Background:SetAlpha(0)
            frame.bg = F.CreateBDFrame(frame, 0.25)
            frame.bg:SetInside()
            frame.Highlight:SetColorTexture(1, 1, 1, 0.25)
            frame.Highlight:SetInside(frame.bg)
            F.ReskinIcon(frame.Icon)
            frame.Icon:SetPoint('TOPLEFT', 7, -7)

            F.ReplaceIconString(frame.InfoText)
            hooksecurefunc(frame.InfoText, 'SetText', F.ReplaceIconString)
        end
    end
end

local function replaceCurrencies(displayGroup)
    for frame in displayGroup.currencyFramePool:EnumerateActive() do
        if not frame.styled then
            F.ReplaceIconString(frame.Text)
            hooksecurefunc(frame.Text, 'SetText', F.ReplaceIconString)

            frame.styled = true
        end
    end
end

C.Themes['Blizzard_CovenantSanctum'] = function()
    local CovenantSanctumFrame = CovenantSanctumFrame

    CovenantSanctumFrame:HookScript('OnShow', function(self)
        if not self.bg then
            self.bg = F.SetBD(self)
            self.NineSlice:SetAlpha(0)
            self.LevelFrame.Background:SetAlpha(0)
            F.ReskinClose(self.CloseButton)
        end
    end)

    local upgradesTab = CovenantSanctumFrame.UpgradesTab
    upgradesTab.Background:SetAlpha(0)
    F.CreateBDFrame(upgradesTab.Background, 0.25)
    F.Reskin(upgradesTab.DepositButton)
    for _, frame in ipairs(upgradesTab.Upgrades) do
        if frame.TierBorder then
            frame.TierBorder:SetAlpha(0)
        end
    end
    upgradesTab.CurrencyBackground:SetAlpha(0)
    replaceCurrencies(upgradesTab.CurrencyDisplayGroup)

    local talentsList = upgradesTab.TalentsList
    talentsList.Divider:SetAlpha(0)
    F.CreateBDFrame(talentsList, 0.25)
    talentsList.BackgroundTile:SetAlpha(0)
    talentsList.IntroBox.Background:Hide()
    F.Reskin(talentsList.UpgradeButton)
    hooksecurefunc(talentsList, 'Refresh', reskinTalentsList)
end

-- Covenant renown
C.Themes['Blizzard_CovenantRenown'] = function()
    hooksecurefunc(CovenantRenownFrame, 'SetUpCovenantData', function(self)
        F.StripTextures(self)

        if not self.styled then
            F.SetBD(self)
            F.ReskinClose(self.CloseButton)

            self.styled = true
        end
    end)
end
