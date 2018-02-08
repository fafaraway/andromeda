local _, private = ...

-- [[ WoW API ]]
local hooksecurefunc = _G.hooksecurefunc

-- [[ Core ]]
local Aurora = private.Aurora
local F = _G.unpack(Aurora)
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\QuestFrame.lua ]]
    function Hook.QuestFrame_UpdatePortraitText(text)
        if text and text ~= "" then
            _G.QuestNPCModelText:SetWidth(191)
            local textHeight = _G.QuestNPCModelText:GetHeight()
            local scrollHeight = _G.QuestNPCModelTextScrollFrame:GetHeight()
            if textHeight > scrollHeight then
                _G.QuestNPCModelTextScrollChildFrame:SetHeight(textHeight + 10)
                _G.QuestNPCModelText:SetWidth(176)
            else
                _G.QuestNPCModelTextScrollChildFrame:SetHeight(textHeight)
            end
        end
    end
    function Hook.QuestFrame_ShowQuestPortrait(parentFrame, portrait, text, name, x, y)
        if parentFrame == _G.WorldMapFrame then
            x = x + 2
        else
            x = x + 5
        end

        _G.QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
    end
end

do --[[ FrameXML\QuestFrameTemplates.xml ]]
    function Skin.QuestFramePanelTemplate(frame)
    end
    function Skin.QuestItemTemplate(button)
    end
    function Skin.QuestSpellTemplate(button)
    end
    function Skin.QuestTitleButtonTemplate(button)
    end
    function Skin.QuestScrollFrameTemplate(scrollframe)
    end
end

function private.FrameXML.QuestFrame()
    hooksecurefunc("QuestFrame_UpdatePortraitText", Hook.QuestFrame_UpdatePortraitText)
    hooksecurefunc("QuestFrame_ShowQuestPortrait", Hook.QuestFrame_ShowQuestPortrait)

    F.ReskinPortraitFrame(_G.QuestFrame, true)
    F.CreateSD(_G.QuestFrame)
    --[[ QuestFrame ]]

    hooksecurefunc("QuestFrame_SetMaterial", function(frame, material)
        private.debug("QuestFrame_SetMaterial", material)
        if material ~= "Parchment" then
            local name = frame:GetName()
            _G[name.."MaterialTopLeft"]:Hide()
            _G[name.."MaterialTopRight"]:Hide()
            _G[name.."MaterialBotLeft"]:Hide()
            _G[name.."MaterialBotRight"]:Hide()
        end
    end)

    --[[ Reward Panel ]]
    _G.QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
    _G.QuestFrameRewardPanel:DisableDrawLayer("BORDER")
    F.Reskin(_G.QuestFrameCompleteQuestButton)

    _G.QuestRewardScrollFrameTop:Hide()
    _G.QuestRewardScrollFrameBottom:Hide()
    _G.QuestRewardScrollFrameMiddle:Hide()
    F.ReskinScroll(_G.QuestRewardScrollFrame.ScrollBar)


    --[[ Progress Panel ]]
    _G.QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
    _G.QuestFrameProgressPanel:DisableDrawLayer("BORDER")

    F.Reskin(_G.QuestFrameGoodbyeButton)
    F.Reskin(_G.QuestFrameCompleteButton)

    _G.QuestProgressScrollFrameTop:Hide()
    _G.QuestProgressScrollFrameBottom:Hide()
    _G.QuestProgressScrollFrameMiddle:Hide()
    F.ReskinScroll(_G.QuestProgressScrollFrame.ScrollBar)

    _G.QuestProgressTitleText:SetTextColor(1, 1, 1)
    _G.QuestProgressTitleText:SetShadowColor(0, 0, 0)
    _G.QuestProgressTitleText.SetTextColor = F.dummy
    _G.QuestProgressText:SetTextColor(1, 1, 1)
    _G.QuestProgressText.SetTextColor = F.dummy
    _G.QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
    _G.QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
    hooksecurefunc(_G.QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
        if r == 0 then
            self:SetTextColor(.8, .8, .8)
        elseif r == .2 then
            self:SetTextColor(1, 1, 1)
        end
    end)

    for i = 1, _G.MAX_REQUIRED_ITEMS do
        local bu = _G["QuestProgressItem"..i]
        F.CreateBD(bu, .25)

        bu.Icon:SetPoint("TOPLEFT", 1, -1)
        bu.Icon:SetDrawLayer("OVERLAY")
        F.ReskinIcon(bu.Icon)

        bu.NameFrame:Hide()
        bu.Count:SetDrawLayer("OVERLAY")
    end


    --[[ Detail Panel ]]
    _G.QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
    _G.QuestFrameDetailPanel:DisableDrawLayer("BORDER")

    F.Reskin(_G.QuestFrameDeclineButton)
    F.Reskin(_G.QuestFrameAcceptButton)

    _G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off
    _G.QuestDetailScrollFrameTop:Hide()
    _G.QuestDetailScrollFrameBottom:Hide()
    _G.QuestDetailScrollFrameMiddle:Hide()
    F.ReskinScroll(_G.QuestDetailScrollFrame.ScrollBar)


    --[[ Greeting Panel ]]
    _G.QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
    F.Reskin(_G.QuestFrameGreetingGoodbyeButton)

    _G.QuestGreetingScrollFrameTop:Hide()
    _G.QuestGreetingScrollFrameBottom:Hide()
    _G.QuestGreetingScrollFrameMiddle:Hide()
    F.ReskinScroll(_G.QuestGreetingScrollFrame.ScrollBar)

    _G.GreetingText:SetTextColor(1, 1, 1)
    _G.GreetingText.SetTextColor = F.dummy
    _G.CurrentQuestsText:SetTextColor(1, 1, 1)
    _G.CurrentQuestsText.SetTextColor = F.dummy
    _G.CurrentQuestsText:SetShadowColor(0, 0, 0)
    _G.AvailableQuestsText:SetTextColor(1, 1, 1)
    _G.AvailableQuestsText.SetTextColor = F.dummy
    _G.AvailableQuestsText:SetShadowColor(0, 0, 0)

    local hRule = _G.QuestFrameGreetingPanel:CreateTexture()
    hRule:SetColorTexture(1, 1, 1, .2)
    hRule:SetSize(256, 1)
    hRule:SetPoint("CENTER", _G.QuestGreetingFrameHorizontalBreak)

    _G.QuestGreetingFrameHorizontalBreak:SetTexture("")

    local function UpdateGreetingPanel()
        hRule:SetShown(_G.QuestGreetingFrameHorizontalBreak:IsShown())
        local numActiveQuests = _G.GetNumActiveQuests()
        if numActiveQuests > 0 then
            for i = 1, numActiveQuests do
                local questTitleButton = _G["QuestTitleButton"..i]
                local title = _G.GetActiveTitle(i)
                if ( _G.IsActiveQuestTrivial(i) ) then
                    questTitleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, title)
                else
                    questTitleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, title)
                end
            end
        end

        local numAvailableQuests = _G.GetNumAvailableQuests()
        if numAvailableQuests > 0 then
            for i = numActiveQuests + 1, numActiveQuests + numAvailableQuests do
                local questTitleButton = _G["QuestTitleButton"..i]
                local title = _G.GetAvailableTitle(i - numActiveQuests)
                if _G.GetAvailableQuestInfo(i - numActiveQuests) then
                    questTitleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, title)
                else
                    questTitleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, title)
                end
            end
        end
    end
    _G.QuestFrameGreetingPanel:HookScript("OnShow", UpdateGreetingPanel)
    hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingPanel)

    -- [[ QuestNPCModel ]]--
    local QuestNPCModel = _G.QuestNPCModel

    local modelBackground = _G.CreateFrame("Frame", nil, _G.QuestNPCModel)
    modelBackground:SetPoint("TOPLEFT", -1, 1)
    modelBackground:SetPoint("BOTTOMRIGHT", 1, -2)
    modelBackground:SetFrameLevel(0)
    Base.SetBackdrop(modelBackground)

    _G.QuestNPCModelBg:Hide()
    _G.QuestNPCModelTopBg:Hide()
    _G.QuestNPCModelShadowOverlay:Hide()

    QuestNPCModel.BorderBottomLeft:Hide()
    QuestNPCModel.BorderBottomRight:Hide()
    QuestNPCModel.BorderTop:Hide()
    QuestNPCModel.BorderBottom:Hide()
    QuestNPCModel.BorderLeft:Hide()
    QuestNPCModel.BorderRight:Hide()

    _G.QuestNPCCornerTopLeft:Hide()
    _G.QuestNPCCornerTopRight:Hide()
    _G.QuestNPCCornerBottomLeft:Hide()
    _G.QuestNPCCornerBottomRight:Hide()

    _G.QuestNPCModelNameplate:SetAlpha(0)

    _G.QuestNPCModelNameText:SetPoint("TOPLEFT", modelBackground, "BOTTOMLEFT")
    _G.QuestNPCModelNameText:SetPoint("BOTTOMRIGHT", _G.QuestNPCModelTextFrame, "TOPRIGHT")

    _G.QuestNPCModelNameTooltipFrame:SetPoint("TOPLEFT", _G.QuestNPCModelNameText, 0, 1)
    _G.QuestNPCModelNameTooltipFrame:SetPoint("BOTTOMRIGHT", _G.QuestNPCModelNameText, 0, -1)
    _G.QuestNPCModelNameTooltipFrame:SetFrameLevel(0)
    Base.SetBackdrop(_G.QuestNPCModelNameTooltipFrame)

    local QuestNPCModelTextFrame = _G.QuestNPCModelTextFrame
    Base.SetBackdrop(QuestNPCModelTextFrame)
    QuestNPCModelTextFrame:SetPoint("TOPLEFT", _G.QuestNPCModelNameplate, "BOTTOMLEFT", -1, 12)
    QuestNPCModelTextFrame:SetWidth(200)
    _G.QuestNPCModelTextFrameBg:Hide()

    QuestNPCModelTextFrame.BorderBottomLeft:Hide()
    QuestNPCModelTextFrame.BorderBottomRight:Hide()
    QuestNPCModelTextFrame.BorderBottom:Hide()
    QuestNPCModelTextFrame.BorderLeft:Hide()
    QuestNPCModelTextFrame.BorderRight:Hide()

    local npcModelScroll = _G.QuestNPCModelTextScrollFrame
    Skin.UIPanelScrollFrameTemplate(npcModelScroll)
    npcModelScroll:SetPoint("TOPLEFT", 4, -4)
    npcModelScroll:SetPoint("BOTTOMRIGHT", -4, 4)

    npcModelScroll.ScrollBar._auroraThumb:Hide()
    npcModelScroll.ScrollBar:SetPoint("TOPLEFT", npcModelScroll, "TOPRIGHT", -14, -15)
    npcModelScroll.ScrollBar:SetPoint("BOTTOMLEFT", npcModelScroll, "BOTTOMRIGHT", -14, 15)
end
