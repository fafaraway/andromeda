local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.AddOns.Blizzard_TradeSkillUI()
    local TradeSkillFrame = _G.TradeSkillFrame
    F.ReskinPortraitFrame(TradeSkillFrame)
    F.CreateBD(_G.TradeSkillFrame)
    F.CreateSD(_G.TradeSkillFrame)

    local rankFrame = TradeSkillFrame.RankFrame
    rankFrame.BorderLeft:Hide()
    rankFrame.BorderRight:Hide()
    rankFrame.BorderMid:Hide()
    rankFrame.Background:SetColorTexture(0.1, 0.1, 0.75, 0.25)
    rankFrame:SetStatusBarTexture(C.media.backdrop)
    rankFrame.SetStatusBarColor = F.dummy
    rankFrame:GetStatusBarTexture():SetGradient("VERTICAL", .1, .3, .9, .2, .4, 1)
    F.CreateBDFrame(rankFrame)

    F.ReskinInput(TradeSkillFrame.SearchBox)
    F.ReskinFilterButton(TradeSkillFrame.FilterButton)
    TradeSkillFrame.FilterButton:SetPoint("TOPRIGHT", -7, -55)

    F.ReskinArrow(TradeSkillFrame.LinkToButton, "Right")
    TradeSkillFrame.LinkToButton:SetPoint("BOTTOMRIGHT", TradeSkillFrame.FilterButton, "TOPRIGHT", 0, 6)

    --[[ Recipe List ]]--
    local recipeInset = TradeSkillFrame.RecipeInset
    recipeInset.Bg:Hide()
    recipeInset:DisableDrawLayer("BORDER")
    local recipeList = TradeSkillFrame.RecipeList
    F.ReskinScroll(recipeList.scrollBar, "TradeSkillFrame")
    for i = 1, #recipeList.Tabs do
        local tab = recipeList.Tabs[i]
        tab.LeftDisabled:SetAlpha(0)
        tab.MiddleDisabled:SetAlpha(0)
        tab.RightDisabled:SetAlpha(0)

        tab.Left:SetAlpha(0)
        tab.Middle:SetAlpha(0)
        tab.Right:SetAlpha(0)
    end

    hooksecurefunc(recipeList, "RefreshDisplay", function(self)
        for i = 1, #self.buttons do
            local tradeSkillButton = self.buttons[i]
            if not tradeSkillButton._auroraSkinned then
                F.ReskinExpandOrCollapse(tradeSkillButton)
                tradeSkillButton._auroraSkinned = true
            end
            tradeSkillButton:SetHighlightTexture("")
        end
    end)

    --[[ Recipe Details ]]--
    local detailsInset = TradeSkillFrame.DetailsInset
    detailsInset.Bg:Hide()
    detailsInset:DisableDrawLayer("BORDER")
    local detailsFrame = TradeSkillFrame.DetailsFrame
    detailsFrame.Background:Hide()
    F.ReskinScroll(detailsFrame.ScrollBar, "TradeSkillFrame")
    F.Reskin(detailsFrame.CreateAllButton)
    F.Reskin(detailsFrame.ViewGuildCraftersButton)
    F.Reskin(detailsFrame.ExitButton)
    F.Reskin(detailsFrame.CreateButton)
    F.ReskinInput(detailsFrame.CreateMultipleInputBox)
    detailsFrame.CreateMultipleInputBox:DisableDrawLayer("BACKGROUND")
    F.ReskinArrow(detailsFrame.CreateMultipleInputBox.IncrementButton, "Right")
    F.ReskinArrow(detailsFrame.CreateMultipleInputBox.DecrementButton, "Left")

    local contents = detailsFrame.Contents
    contents.ResultIcon.ResultBorder:Hide()
    hooksecurefunc(contents.ResultIcon, "SetNormalTexture", function(self)
        if not self._auroraSkinned then
            self._auroraIconBorder = F.ReskinIcon(self:GetNormalTexture())
            self._auroraSkinned = true
        end
    end)
    for i = 1, #contents.Reagents do
        local reagent = contents.Reagents[i]
        reagent.Icon:SetTexCoord(.08, .92, .08, .92)
        F.CreateBDFrame(reagent.Icon)
        reagent.NameFrame:Hide()
        local bg = F.CreateBDFrame(reagent.NameFrame, .2)
        bg:SetPoint("TOPLEFT", reagent.Icon, "TOPRIGHT", 2, 1)
        bg:SetPoint("BOTTOMRIGHT", -4, 1)
    end
end
