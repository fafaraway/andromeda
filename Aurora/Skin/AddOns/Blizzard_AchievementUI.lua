local _, private = ...

-- luacheck: globals select next
-- luacheck: globals hooksecurefunc

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

local F, C = _G.unpack(private.Aurora)

local function SkinSearchPreview(button)
    button:GetNormalTexture():SetColorTexture(0.1, 0.1, 0.1, .5)
    button:GetPushedTexture():SetColorTexture(0.1, 0.1, 0.1, .5)

    local r, g, b = Aurora.highlightColor:GetRGB()
    button.selectedTexture:SetColorTexture(r, g, b, 0.5)
end

do --[[ AddOns\Blizzard_AchievementUI.lua ]]
    local IN_GUILD_VIEW = false
    local redR, redG, redB, redA = 1, 0, 0, .2
    local blueR, blueG, blueB, blueA = 0, 1, 1, .2

    function Hook.AchievementFrame_UpdateTabs(clickedTab)
        for i = 1, 3 do
            _G["AchievementFrameTab"..i]:SetPoint("CENTER")
        end
    end
    function Hook.AchievementFrameBaseTab_OnClick()
        if _G.AchievementFrameGuildEmblemLeft:IsShown() then
            _G.AchievementFrameGuildEmblemLeft:SetVertexColor(1, 1, 1, 0.25)
            _G.AchievementFrameGuildEmblemRight:SetVertexColor(1, 1, 1, 0.25)
            IN_GUILD_VIEW = true
        else
            IN_GUILD_VIEW = false
        end
    end
    function Hook.AchievementButton_UpdatePlusMinusTexture(button)
        if button:IsForbidden() then return end -- twitter achievement share is protected
        if button.plusMinus:IsShown() then
            button._auroraPlusMinus:Show()
            if button.collapsed then
                button._auroraPlusMinus.plus:Show()
            else
                button._auroraPlusMinus.plus:Hide()
            end
        elseif button._auroraPlusMinus then
            button._auroraPlusMinus:Hide()
        end
    end
    function Hook.AchievementButton_Saturate(self)
        if IN_GUILD_VIEW then
            Base.SetBackdropColor(self, redR, redG, redB, redA)
        else
            if self.accountWide then
                Base.SetBackdropColor(self, blueR, blueG, blueB, blueA)
            else
                Base.SetBackdropColor(self, redR, redG, redB, redA)
            end
        end

        if self.description then
            self.description:SetTextColor(.9, .9, .9)
            self.description:SetShadowOffset(1, -1)
        end
    end
    function Hook.AchievementButton_Desaturate(self)
        if IN_GUILD_VIEW then
            Base.SetBackdropColor(self, redR * 0.6, redG * 0.6, redB * 0.6, redA)
        else
            if self.accountWide then
                Base.SetBackdropColor(self, blueR * 0.6, blueG * 0.6, blueB * 0.6, blueA)
            else
                Base.SetBackdropColor(self, redR * 0.6, redG * 0.6, redB * 0.6, redA)
            end
        end
    end

    local numMini = 0
    function Hook.AchievementButton_GetMiniAchievement(index)
        if index > numMini then
            Skin.MiniAchievementTemplate(_G["AchievementFrameMiniAchievement" .. index])
            numMini = numMini + 1
        end
    end
    local numProgress = 0
    function Hook.AchievementButton_GetProgressBar(index, renderOffScreen)
        if index > numProgress then
            local offscreenName = ""
            if renderOffScreen then
                offscreenName = "OffScreen"
            end

            Skin.AchievementProgressBarTemplate(_G["AchievementFrameProgressBar" .. offscreenName .. index])
            numProgress = numProgress + 1
        end
    end
    local numMeta = 0
    function Hook.AchievementButton_GetMeta(index, renderOffScreen)
        if index > numMeta then
            local offscreenName = ""
            if renderOffScreen then
                offscreenName = "OffScreen"
            end

            Skin.MetaCriteriaTemplate(_G["AchievementFrameMeta" .. offscreenName .. index])
            numMeta = numMeta + 1
        end
    end

    function Hook.AchievementFrameStats_SetStat(button, category, index, colorIndex, isSummary)
        if not button.id then return end
        if not colorIndex then
            colorIndex = index
        end

        if (colorIndex % 2) == 1 then
            button.background:Hide()
        else
            button.background:SetColorTexture(1, 1, 1, 0.25)
        end
    end
    function Hook.AchievementFrameStats_SetHeader(button, id)
        button.background:Show()
        button.background:SetAlpha(1.0)
        button.background:SetBlendMode("DISABLE")
        button.background:SetColorTexture(Aurora.buttonColor:GetRGB())
    end

    local numAchievements = 0
    function Hook.AchievementFrameSummary_UpdateAchievements(...)
        for i = numAchievements + 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
            local button = _G["AchievementFrameSummaryAchievement"..i]
            if button then
                if i > 1 then
                    local anchorTo = _G["AchievementFrameSummaryAchievement"..i-1];
                    button:SetPoint("TOPLEFT", anchorTo, "BOTTOMLEFT", 0, -2 );
                    button:SetPoint("TOPRIGHT", anchorTo, "BOTTOMRIGHT", 0, -2 );
                end
                numAchievements = numAchievements + 1
            end
        end
    end

    Hook.AchievementFrameComparisonStats_SetStat = Hook.AchievementFrameStats_SetStat
    Hook.AchievementFrameComparisonStats_SetHeader = Hook.AchievementFrameStats_SetHeader
end

do --[[ AddOns\Blizzard_AchievementUI.xml ]]
    function Skin.AchievementSearchPreviewButton(button)
        SkinSearchPreview(button)

        button.iconFrame:SetAlpha(0)
        Base.CropIcon(button.icon, button)
    end
    function Skin.AchievementFullSearchResultsButton(button)
        button.iconFrame:SetAlpha(0)
        Base.CropIcon(button.icon, button)

        local r, g, b = Aurora.highlightColor:GetRGB()
        button:GetHighlightTexture():SetColorTexture(r, g, b, 0.2)
    end
    function Skin.AchievementFrameSummaryCategoryTemplate(statusbar)
        local name = statusbar:GetName()
        statusbar.label:SetPoint("LEFT", 6, 0)
        statusbar.text:SetPoint("RIGHT", -6, 0)

        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        local r, g, b = Aurora.highlightColor:GetRGB()
        _G[name.."ButtonHighlightLeft"]:Hide()
        _G[name.."ButtonHighlightRight"]:Hide()

        local highlight = _G[name.."ButtonHighlightMiddle"]
        highlight:SetAllPoints()
        highlight:SetColorTexture(r, g, b, 0.2)

        Base.SetTexture(_G[name.."Bar"], "gradientUp")
    end
    function Skin.AchievementCheckButtonTemplate(checkbutton)
        checkbutton:SetSize(11, 11)

        checkbutton:SetNormalTexture("")
        checkbutton:SetPushedTexture("")
        checkbutton:SetHighlightTexture("")

        _G[checkbutton:GetName().."Text"]:SetPoint("LEFT", checkbutton, "RIGHT", 2, 0)

        local check = checkbutton:GetCheckedTexture()
        check:SetSize(21, 21)
        check:ClearAllPoints()
        check:SetPoint("CENTER")
        check:SetDesaturated(true)
        check:SetVertexColor(Aurora.highlightColor:GetRGB())

        Base.SetBackdrop(checkbutton)
        Base.SetHighlight(checkbutton, "backdrop")
    end
    function Skin.AchievementFrameTabButtonTemplate(button)
        local name = button:GetName()
        button:SetHeight(28)

        _G[name.."LeftDisabled"]:SetTexture("")
        _G[name.."MiddleDisabled"]:SetTexture("")
        _G[name.."RightDisabled"]:SetTexture("")
        _G[name.."Left"]:SetTexture("")
        _G[name.."Middle"]:SetTexture("")
        _G[name.."Right"]:SetTexture("")
        _G[name.."LeftHighlight"]:SetTexture("")
        _G[name.."MiddleHighlight"]:SetTexture("")
        _G[name.."RightHighlight"]:SetTexture("")

        button.text:ClearAllPoints()
        button.text:SetPoint("TOPLEFT")
        button.text:SetPoint("BOTTOMRIGHT")
        --button.text:SetPoint("CENTER")

        Base.SetBackdrop(button)
        Base.SetHighlight(button, "backdrop")
        button._auroraTabResize = true
    end
    function Skin.MiniAchievementTemplate(frame)
        Base.CropIcon(frame.icon, frame)
        frame.border:Hide()
    end
    function Skin.MetaCriteriaTemplate(button)
        Base.CropIcon(button.icon, button)
        button.border:Hide()
    end
    function Skin.AchievementProgressBarTemplate(statusbar)
        local name = statusbar:GetName()

        _G[name.."BorderLeft"]:Hide()
        _G[name.."BorderRight"]:Hide()
        _G[name.."BorderCenter"]:Hide()

        Base.SetTexture(statusbar:GetStatusBarTexture(), "gradientUp")
    end
    function Skin.AchievementHeaderStatusBarTemplate(statusbar)
        local name = statusbar:GetName()

        _G[name.."Left"]:Hide()
        _G[name.."Right"]:Hide()
        _G[name.."Middle"]:Hide()

        Base.SetTexture(statusbar:GetStatusBarTexture(), "gradientUp")
    end
    function Skin.AchievementCategoryTemplate(button)
        Base.SetBackdrop(button, Aurora.buttonColor:GetRGBA())
        button.background:Hide()

        button.label:SetPoint("BOTTOMLEFT", 6, 0)
        button.label:SetPoint("TOPRIGHT")
        button.label:SetJustifyV("MIDDLE")

        local r, g, b = Aurora.highlightColor:GetRGB()
        local highlight = button:GetHighlightTexture()
        highlight:SetColorTexture(r, g, b, .3)
        highlight:SetPoint("BOTTOMRIGHT")
    end
    function Skin.AchievementIconFrameTemplate(frame)
        frame.bling:Hide()
        Base.CropIcon(frame.texture, frame)
        frame.frame:Hide()
    end
    function Skin.AchievementTemplate(button)
        hooksecurefunc(button, "Saturate", Hook.AchievementButton_Saturate)
        hooksecurefunc(button, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(button, Aurora.frameColor:GetRGBA())
        button.background:Hide()

        local name = button:GetName()

        _G[name.."BottomLeftTsunami"]:Hide()
        _G[name.."BottomRightTsunami"]:Hide()
        _G[name.."TopLeftTsunami"]:Hide()
        _G[name.."TopRightTsunami"]:Hide()
        _G[name.."BottomTsunami1"]:Hide()
        _G[name.."TopTsunami1"]:Hide()

        button.titleBar:Hide()
        button.glow:Hide()
        button.rewardBackground:SetAlpha(0)
        button.guildCornerL:Hide()
        button.guildCornerR:Hide()
        button.plusMinus:SetAlpha(0)

        local plusMinus = _G.CreateFrame("Frame", nil, button)
        Base.SetBackdrop(plusMinus, Aurora.buttonColor:GetRGB())
        plusMinus:SetAllPoints(button.plusMinus)

        plusMinus.plus = plusMinus:CreateTexture(nil, "ARTWORK")
        plusMinus.plus:SetSize(1, 7)
        plusMinus.plus:SetPoint("CENTER")
        plusMinus.plus:SetColorTexture(1, 1, 1)

        plusMinus.minus = plusMinus:CreateTexture(nil, "ARTWORK")
        plusMinus.minus:SetSize(7, 1)
        plusMinus.minus:SetPoint("CENTER")
        plusMinus.minus:SetColorTexture(1, 1, 1)
        button._auroraPlusMinus = plusMinus

        Base.SetBackdrop(button.highlight, 0, 0, 0, .2)
        button.highlight:DisableDrawLayer("OVERLAY")
        button.highlight:ClearAllPoints()
        button.highlight:SetPoint("TOPLEFT", 1, -1)
        button.highlight:SetPoint("BOTTOMRIGHT", -1, 1)

        Skin.AchievementIconFrameTemplate(button.icon)
        Skin.AchievementCheckButtonTemplate(button.tracked)
    end
    function Skin.ComparisonPlayerTemplate(frame)
        hooksecurefunc(frame, "Saturate", Hook.AchievementButton_Saturate)
        hooksecurefunc(frame, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(frame, Aurora.frameColor:GetRGBA())
        frame.background:Hide()
        frame.titleBar:Hide()
        frame.glow:Hide()

        Skin.AchievementIconFrameTemplate(frame.icon)
    end
    function Skin.SummaryAchievementTemplate(frame)
        frame:SetHeight(44)
        frame.icon:SetPoint("TOPLEFT", -1, -1)
        frame.shield:SetPoint("TOPRIGHT", -5, -2)

        Skin.ComparisonPlayerTemplate(frame)

        Base.SetBackdrop(frame.highlight, 0, 0, 0, .1)
        frame.highlight:DisableDrawLayer("OVERLAY")
        frame.highlight:ClearAllPoints()
        frame.highlight:SetPoint("TOPLEFT", 1, -1)
        frame.highlight:SetPoint("BOTTOMRIGHT", -1, 1)
    end
    function Skin.ComparisonTemplate(frame)
        Skin.ComparisonPlayerTemplate(frame.player)

        hooksecurefunc(frame.friend, "Saturate", Hook.AchievementButton_Saturate)
        hooksecurefunc(frame.friend, "Desaturate", Hook.AchievementButton_Desaturate)

        Base.SetBackdrop(frame.friend, Aurora.frameColor:GetRGBA())
        frame.friend.background:Hide()
        frame.friend.titleBar:Hide()
        frame.friend.glow:Hide()

        Skin.AchievementIconFrameTemplate(frame.friend.icon)
    end
    function Skin.StatTemplate(button)
        button.left:SetAlpha(0)
        button.middle:SetAlpha(0)
        button.right:SetAlpha(0)

        local r, g, b = Aurora.highlightColor:GetRGB()
        button:GetHighlightTexture():SetColorTexture(r, g, b, 0.2)
    end
    function Skin.ComparisonStatTemplate(frame)
        frame.left:SetAlpha(0)
        frame.middle:SetAlpha(0)
        frame.right:SetAlpha(0)

        frame.left2:SetAlpha(0)
        frame.middle2:SetAlpha(0)
        frame.right2:SetAlpha(0)
    end
end

function private.AddOns.Blizzard_AchievementUI()
    hooksecurefunc("AchievementFrame_UpdateTabs", Hook.AchievementFrame_UpdateTabs)
    hooksecurefunc("AchievementFrameBaseTab_OnClick", Hook.AchievementFrameBaseTab_OnClick)
    hooksecurefunc("AchievementButton_UpdatePlusMinusTexture", Hook.AchievementButton_UpdatePlusMinusTexture)
    hooksecurefunc("AchievementButton_GetMiniAchievement", Hook.AchievementButton_GetMiniAchievement)
    hooksecurefunc("AchievementButton_GetProgressBar", Hook.AchievementButton_GetProgressBar)
    hooksecurefunc("AchievementButton_GetMeta", Hook.AchievementButton_GetMeta)
    hooksecurefunc("AchievementFrameSummary_UpdateAchievements", Hook.AchievementFrameSummary_UpdateAchievements)
    hooksecurefunc("AchievementFrameStats_SetStat", Hook.AchievementFrameStats_SetStat)
    hooksecurefunc("AchievementFrameStats_SetHeader", Hook.AchievementFrameStats_SetHeader)
    hooksecurefunc("AchievementFrameComparisonStats_SetStat", Hook.AchievementFrameComparisonStats_SetStat)
    hooksecurefunc("AchievementFrameComparisonStats_SetHeader", Hook.AchievementFrameComparisonStats_SetHeader)

    hooksecurefunc("AchievementComparisonPlayerButton_Saturate", function(self)
        if not self._auroraSkinned then
            Skin.SummaryAchievementTemplate(self)
            self._auroraSkinned = true
        end
        Hook.AchievementButton_Saturate(self)
    end)
    hooksecurefunc("AchievementComparisonPlayerButton_Desaturate", function(self)
        if not self._auroraSkinned then
            Skin.SummaryAchievementTemplate(self)
            self._auroraSkinned = true
        end
        Hook.AchievementButton_Desaturate(self)
    end)

    -- AchievementFrame
    Base.SetBackdrop(_G.AchievementFrame)

    _G.AchievementFrameBackground:Hide()

    _G.AchievementFrameMetalBorderLeft:Hide()
    _G.AchievementFrameMetalBorderRight:Hide()
    _G.AchievementFrameMetalBorderBottom:Hide()
    _G.AchievementFrameMetalBorderTop:Hide()
    _G.AchievementFrameCategoriesBG:Hide()

    _G.AchievementFrameWaterMark:SetDesaturated(true)
    _G.AchievementFrameWaterMark:SetAlpha(0.5)

    _G.AchievementFrameGuildEmblemLeft:SetAlpha(0.5)
    _G.AchievementFrameGuildEmblemRight:SetAlpha(0.5)

    _G.AchievementFrameMetalBorderTopLeft:Hide()
    _G.AchievementFrameMetalBorderTopRight:Hide()
    _G.AchievementFrameMetalBorderBottomLeft:Hide()
    _G.AchievementFrameMetalBorderBottomRight:Hide()
    _G.AchievementFrameWoodBorderTopLeft:Hide()
    _G.AchievementFrameWoodBorderTopRight:Hide()
    _G.AchievementFrameWoodBorderBottomLeft:Hide()
    _G.AchievementFrameWoodBorderBottomRight:Hide()



    _G.AchievementFrameHeaderLeft:Hide()
    _G.AchievementFrameHeaderRight:Hide()

    _G.AchievementFrameHeaderPointBorder:Hide()
    _G.AchievementFrameHeaderTitle:Hide()
    _G.AchievementFrameHeaderLeftDDLInset:SetAlpha(0)
    _G.AchievementFrameHeaderRightDDLInset:SetAlpha(0)

    _G.AchievementFrameHeaderPoints:SetPoint("TOP", _G.AchievementFrame)
    _G.AchievementFrameHeaderPoints:SetPoint("BOTTOM", _G.AchievementFrame, "TOP", 0, -24)



    Base.SetBackdrop(_G.AchievementFrameCategories, Aurora.frameColor:GetRGBA())
    Skin.HybridScrollBarTemplate(_G.AchievementFrameCategoriesContainerScrollBar)
    _G.AchievementFrameCategoriesContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameCategoriesContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameCategoriesContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameCategoriesContainer, "BOTTOMRIGHT", 0, 12)



    Base.SetBackdrop(_G.AchievementFrameAchievements, Aurora.frameColor:GetRGBA())
    _G.AchievementFrameAchievementsBackground:Hide()
    select(3, _G.AchievementFrameAchievements:GetRegions()):Hide()

    Skin.HybridScrollBarTemplate(_G.AchievementFrameAchievementsContainerScrollBar)
    _G.AchievementFrameAchievementsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameAchievementsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameAchievementsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameAchievementsContainer, "BOTTOMRIGHT", 0, 12)
    select(2, _G.AchievementFrameAchievements:GetChildren()):Hide()



    Base.SetBackdrop(_G.AchievementFrameStats, Aurora.frameColor:GetRGBA())
    _G.AchievementFrameStatsBG:Hide()
    Skin.HybridScrollBarTemplate(_G.AchievementFrameStatsContainerScrollBar)
    _G.AchievementFrameStatsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameStatsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameStatsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameStatsContainer, "BOTTOMRIGHT", 0, 12)
    select(3, _G.AchievementFrameStats:GetChildren()):Hide()



    Base.SetBackdrop(_G.AchievementFrameSummary, Aurora.frameColor:GetRGBA())
    _G.AchievementFrameSummaryBackground:Hide()
    _G.AchievementFrameSummary:GetChildren():Hide()

    _G.AchievementFrameSummaryAchievementsHeaderHeader:Hide()

    _G.AchievementFrameSummaryCategoriesHeaderTexture:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarTitle:SetPoint("LEFT", 6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarText:SetPoint("RIGHT", -6, 0)
    _G.AchievementFrameSummaryCategoriesStatusBarLeft:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarRight:Hide()
    _G.AchievementFrameSummaryCategoriesStatusBarMiddle:Hide()
    Base.SetTexture(_G.AchievementFrameSummaryCategoriesStatusBarBar, "gradientUp")
    for i = 1, 12 do
        Skin.AchievementFrameSummaryCategoryTemplate(_G["AchievementFrameSummaryCategoriesCategory"..i])
    end



    Base.SetBackdrop(_G.AchievementFrameComparison, Aurora.frameColor:GetRGBA())
    _G.AchievementFrameComparisonHeader:SetPoint("BOTTOMLEFT", _G.AchievementFrameComparisonSummaryFriend, "TOPLEFT")
    _G.AchievementFrameComparisonHeader:SetPoint("BOTTOMRIGHT", _G.AchievementFrameComparisonSummaryFriend, "TOPRIGHT")
    _G.AchievementFrameComparisonHeader:SetHeight(private.FRAME_TITLE_HEIGHT * 2)
    _G.AchievementFrameComparisonHeaderBG:Hide()
    _G.AchievementFrameComparisonHeaderPortrait:Hide()
    _G.AchievementFrameComparisonHeaderPortraitBg:Hide()
    _G.AchievementFrameComparisonHeaderName:ClearAllPoints()
    _G.AchievementFrameComparisonHeaderName:SetPoint("TOP")
    _G.AchievementFrameComparisonHeaderName:SetHeight(private.FRAME_TITLE_HEIGHT)
    _G.AchievementFrameComparisonHeaderPoints:ClearAllPoints()
    _G.AchievementFrameComparisonHeaderPoints:SetPoint("TOP", "$parentName", "BOTTOM", 0, 0)
    _G.AchievementFrameComparisonHeaderPoints:SetHeight(private.FRAME_TITLE_HEIGHT)

    _G.AchievementFrameComparisonSummary:SetHeight(24)

    for _, unit in next, {"Player", "Friend"} do
        local summery = _G["AchievementFrameComparisonSummary"..unit]
        summery:SetHeight(24)
        summery:SetBackdrop(nil)
        _G["AchievementFrameComparisonSummary"..unit.."Background"]:Hide()
        Skin.AchievementHeaderStatusBarTemplate(summery.statusBar)
        summery.statusBar:ClearAllPoints()
        summery.statusBar:SetPoint("TOPLEFT")
        summery.statusBar:SetPoint("BOTTOMRIGHT")
    end

    Skin.HybridScrollBarTemplate(_G.AchievementFrameComparisonContainerScrollBar)
    _G.AchievementFrameComparisonContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameComparisonContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameComparisonContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameComparisonContainer, "BOTTOMRIGHT", 0, 12)

    Skin.HybridScrollBarTemplate(_G.AchievementFrameComparisonStatsContainerScrollBar)
    _G.AchievementFrameComparisonStatsContainerScrollBar:SetPoint("TOPLEFT", _G.AchievementFrameComparisonStatsContainer, "TOPRIGHT", 0, -12)
    _G.AchievementFrameComparisonStatsContainerScrollBar:SetPoint("BOTTOMLEFT", _G.AchievementFrameComparisonStatsContainer, "BOTTOMRIGHT", 0, 12)

    select(5, _G.AchievementFrameComparison:GetChildren()):Hide()

    _G.AchievementFrameComparisonBackground:Hide()
    _G.AchievementFrameComparisonDark:SetAlpha(0)
    _G.AchievementFrameComparisonWatermark:SetAlpha(0)



    Skin.UIPanelCloseButton(_G.AchievementFrameCloseButton)
    _G.AchievementFrameCloseButton:SetPoint("TOPRIGHT", -3, -3)

    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab1)
    _G.AchievementFrameTab1:ClearAllPoints()
    _G.AchievementFrameTab1:SetPoint("TOPLEFT", _G.AchievementFrame, "BOTTOMLEFT", 20, -1)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab2)
    _G.AchievementFrameTab2:ClearAllPoints()
    _G.AchievementFrameTab2:SetPoint("TOPLEFT", _G.AchievementFrameTab1, "TOPRIGHT", 1, 0)
    Skin.AchievementFrameTabButtonTemplate(_G.AchievementFrameTab3)
    _G.AchievementFrameTab3:ClearAllPoints()
    _G.AchievementFrameTab3:SetPoint("TOPLEFT", _G.AchievementFrameTab2, "TOPRIGHT", 1, 0)


    _G.AchievementFrameFilterDropDown:SetPoint("TOPLEFT", 148, 4)
    _G.AchievementFrameFilterDropDown:SetHeight(16)
    --private.FindUsage(_G.AchievementFrameFilterDropDown, "SetHeight")

    local filterBG = _G.CreateFrame("Frame", nil, _G.AchievementFrameFilterDropDown)
    filterBG:SetPoint("TOPLEFT", 0, -6)
    filterBG:SetPoint("BOTTOMRIGHT", _G.AchievementFrameFilterDropDownButton, "BOTTOMLEFT", 1, 0)
    filterBG:SetFrameLevel(_G.AchievementFrameFilterDropDown:GetFrameLevel()-1)
    Base.SetBackdrop(filterBG, Aurora.frameColor:GetRGBA())

    _G.AchievementFrameFilterDropDownText:SetPoint("LEFT", filterBG, 5, 0)

    Base.SetBackdrop(_G.AchievementFrameFilterDropDownButton, Aurora.buttonColor:GetRGBA())
    _G.AchievementFrameFilterDropDownButton:SetPoint("TOPRIGHT", 0, -6)
    _G.AchievementFrameFilterDropDownButton:SetSize(16, 16)
    _G.AchievementFrameFilterDropDownButton:SetNormalTexture("")
    _G.AchievementFrameFilterDropDownButton:SetHighlightTexture("")
    _G.AchievementFrameFilterDropDownButton:SetPushedTexture("")

    local filterArrow = _G.AchievementFrameFilterDropDownButton:CreateTexture(nil, "ARTWORK")
    filterArrow:SetPoint("TOPLEFT", 4, -6)
    filterArrow:SetPoint("BOTTOMRIGHT", -5, 7)
    Base.SetTexture(filterArrow, "arrowDown")

    _G.AchievementFrameFilterDropDownButton._auroraHighlight = {filterArrow}
    Base.SetHighlight(_G.AchievementFrameFilterDropDownButton, "texture")

    Skin.SearchBoxTemplate(_G.AchievementFrame.searchBox)
    _G.AchievementFrame.searchBox:ClearAllPoints()
    _G.AchievementFrame.searchBox:SetPoint("TOPRIGHT", -148, 5)

    local prevContainer = _G.AchievementFrame.searchPreviewContainer
    prevContainer:DisableDrawLayer("OVERLAY")
    local prevContainerBG = _G.CreateFrame("Frame", nil, prevContainer)
    prevContainerBG:SetPoint("TOPRIGHT", 1, 1)
    prevContainerBG:SetPoint("BOTTOMLEFT", prevContainer.borderAnchor, 6, 4)
    prevContainerBG:SetFrameLevel(prevContainer:GetFrameLevel() - 1)
    Base.SetBackdrop(prevContainerBG, Aurora.frameColor:GetRGBA())

    for i = 1, #_G.AchievementFrame.searchPreview do
        Skin.AchievementSearchPreviewButton(_G.AchievementFrame.searchPreview[i])
    end
    SkinSearchPreview(_G.AchievementFrame.showAllSearchResults)

    local searchResults = _G.AchievementFrame.searchResults
    Base.SetBackdrop(searchResults)
    searchResults:GetRegions():Hide() -- background

    local titleText = searchResults.titleText
    titleText:ClearAllPoints()
    titleText:SetPoint("TOPLEFT")
    titleText:SetPoint("BOTTOMRIGHT", searchResults, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    searchResults.topLeftCorner:Hide()
    searchResults.topRightCorner:Hide()
    searchResults.topBorder:Hide()
    searchResults.bottomLeftCorner:Hide()
    searchResults.bottomRightCorner:Hide()
    searchResults.bottomBorder:Hide()
    searchResults.leftBorder:Hide()
    searchResults.rightBorder:Hide()
    searchResults.topTileStreaks:Hide()
    searchResults.topLeftCorner2:Hide()
    searchResults.topRightCorner2:Hide()
    searchResults.topBorder2:Hide()

    Skin.UIPanelCloseButton(searchResults.closeButton)
    searchResults.closeButton:SetPoint("TOPRIGHT", -3, -3)
    Skin.HybridScrollBarTrimTemplate(searchResults.scrollFrame.scrollBar)

    F.CreateBD(_G.AchievementFrame)
    F.CreateSD(_G.AchievementFrame)
end
