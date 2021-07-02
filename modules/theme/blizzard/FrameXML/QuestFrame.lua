local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestCurrencyInfo = GetQuestCurrencyInfo

local F, C = unpack(select(2, ...))

local function UpdateProgressItemQuality(self)
    local button = self.__owner
    local index = button.__id
    local buttonType = button.type
    local objectType = button.objectType

    local quality
    if objectType == 'item' then
        quality = select(4, GetQuestItemInfo(buttonType, index))
    elseif objectType == 'currency' then
        quality = select(4, GetQuestCurrencyInfo(buttonType, index))
    end

    local color = C.QualityColors[quality or 1]
    button.bg:SetBackdropBorderColor(color.r, color.g, color.b)
end

tinsert(
    C.BlizzThemes,
    function()
        F.ReskinPortraitFrame(_G.QuestFrame)

        F.StripTextures(_G.QuestFrameDetailPanel, 0)
        F.StripTextures(_G.QuestFrameRewardPanel, 0)
        F.StripTextures(_G.QuestFrameProgressPanel, 0)
        F.StripTextures(_G.QuestFrameGreetingPanel, 0)

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
            button.NameFrame:Hide()
            button.bg = F.ReskinIcon(button.Icon)
            button.__id = i
            button.Icon.__owner = button
            hooksecurefunc(button.Icon, 'SetTexture', UpdateProgressItemQuality)

            local bg = F.CreateBDFrame(button, .25)
            bg:SetPoint('TOPLEFT', button.bg, 'TOPRIGHT', 2, 0)
            bg:SetPoint('BOTTOMRIGHT', button.bg, 100, 0)
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

        F.Reskin(_G.QuestFrameAcceptButton)
        F.Reskin(_G.QuestFrameDeclineButton)
        F.Reskin(_G.QuestFrameCompleteQuestButton)
        F.Reskin(_G.QuestFrameCompleteButton)
        F.Reskin(_G.QuestFrameGoodbyeButton)
        F.Reskin(_G.QuestFrameGreetingGoodbyeButton)

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
        F.StripTextures(_G.QuestNPCModelTextFrame)
        local bg = F.SetBD(_G.QuestModelScene)
        bg:SetOutside(nil, nil, nil, _G.QuestNPCModelTextFrame)

        hooksecurefunc(
            'QuestFrame_ShowQuestPortrait',
            function(parentFrame, _, _, _, _, _, x, y)
                x = x + 6
                _G.QuestModelScene:SetPoint('TOPLEFT', parentFrame, 'TOPRIGHT', x, y)
            end
        )
    end
)
