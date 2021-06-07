local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc

local F, C = unpack(select(2, ...))

tinsert(
    C.BlizzThemes,
    function()
        F.ReskinPortraitFrame(_G.QuestFrame)

        _G.QuestFrameDetailPanel:DisableDrawLayer('BACKGROUND')
        _G.QuestFrameProgressPanel:DisableDrawLayer('BACKGROUND')
        _G.QuestFrameRewardPanel:DisableDrawLayer('BACKGROUND')
        _G.QuestFrameGreetingPanel:DisableDrawLayer('BACKGROUND')
        _G.QuestFrameDetailPanel:DisableDrawLayer('BORDER')
        _G.QuestFrameRewardPanel:DisableDrawLayer('BORDER')
        _G.QuestLogPopupDetailFrame.SealMaterialBG:SetAlpha(0)
        _G.QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
        _G.QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
        _G.QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
        _G.QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)
        hooksecurefunc(
            'QuestFrame_SetMaterial',
            function(frame)
                _G[frame:GetName() .. 'MaterialTopLeft']:Hide()
                _G[frame:GetName() .. 'MaterialTopRight']:Hide()
                _G[frame:GetName() .. 'MaterialBotLeft']:Hide()
                _G[frame:GetName() .. 'MaterialBotRight']:Hide()
            end
        )

        local line = _G.QuestFrameGreetingPanel:CreateTexture()
        line:SetColorTexture(1, 1, 1, .25)
        line:SetSize(256, C.Mult)
        line:SetPoint('CENTER', _G.QuestGreetingFrameHorizontalBreak)
        _G.QuestGreetingFrameHorizontalBreak:SetTexture('')
        _G.QuestFrameGreetingPanel:HookScript(
            'OnShow',
            function()
                line:SetShown(_G.QuestGreetingFrameHorizontalBreak:IsShown())
            end
        )

        for i = 1, _G.MAX_REQUIRED_ITEMS do
            local button = _G['QuestProgressItem' .. i]
            F.ReskinIcon(button.Icon)
            button.NameFrame:Hide()
        end

        _G.QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

        hooksecurefunc(
            _G.QuestProgressRequiredMoneyText,
            'SetTextColor',
            function(self, r)
                if r == 0 then
                    self:SetTextColor(.8, .8, .8)
                elseif r == .2 then
                    self:SetTextColor(1, 1, 1)
                end
            end
        )

        for _, questButton in pairs(
            {'QuestFrameAcceptButton', 'QuestFrameDeclineButton', 'QuestFrameCompleteQuestButton', 'QuestFrameCompleteButton', 'QuestFrameGoodbyeButton', 'QuestFrameGreetingGoodbyeButton'}
        ) do
            F.Reskin(_G[questButton])
        end
        F.ReskinScroll(_G.QuestProgressScrollFrameScrollBar)
        F.ReskinScroll(_G.QuestRewardScrollFrameScrollBar)
        F.ReskinScroll(_G.QuestDetailScrollFrameScrollBar)
        F.ReskinScroll(_G.QuestGreetingScrollFrameScrollBar)

        -- Text colour stuff

        _G.QuestProgressRequiredItemsText:SetTextColor(1, .8, 0)
        _G.QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
        _G.QuestProgressTitleText:SetTextColor(1, .8, 0)
        _G.QuestProgressTitleText:SetShadowColor(0, 0, 0)
        _G.QuestProgressTitleText.SetTextColor = F.Dummy
        _G.QuestProgressText:SetTextColor(1, 1, 1)
        _G.QuestProgressText.SetTextColor = F.Dummy
        _G.GreetingText:SetTextColor(1, 1, 1)
        _G.GreetingText.SetTextColor = F.Dummy
        _G.AvailableQuestsText:SetTextColor(1, .8, 0)
        _G.AvailableQuestsText.SetTextColor = F.Dummy
        _G.AvailableQuestsText:SetShadowColor(0, 0, 0)
        _G.CurrentQuestsText:SetTextColor(1, 1, 1)
        _G.CurrentQuestsText.SetTextColor = F.Dummy
        _G.CurrentQuestsText:SetShadowColor(0, 0, 0)

        -- Quest NPC model

        F.StripTextures(_G.QuestModelScene)
        F.SetBD(_G.QuestModelScene)
        F.StripTextures(_G.QuestNPCModelTextFrame)
        F.SetBD(_G.QuestNPCModelTextFrame)

        if C.IsNewPatch then
            hooksecurefunc(
                'QuestFrame_ShowQuestPortrait',
                function(parentFrame, _, _, _, _, _, x, y)
                    x = x + 6
                    _G.QuestModelScene:SetPoint('TOPLEFT', parentFrame, 'TOPRIGHT', x, y)
                end
            )
        else
            hooksecurefunc(
                'QuestFrame_ShowQuestPortrait',
                function(parentFrame, _, _, _, _, x, y)
                    x = x + 6
                    _G.QuestModelScene:SetPoint('TOPLEFT', parentFrame, 'TOPRIGHT', x, y)
                end
            )
        end
    end
)
