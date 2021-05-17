local _G = _G
local unpack = unpack
local select = select
local hooksecurefunc = hooksecurefunc
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestCurrencyID = GetQuestCurrencyID
local GetQuestCurrencyInfo = GetQuestCurrencyInfo
local GetNumRewardSpells = GetNumRewardSpells
local CurrencyContainerUtil = CurrencyContainerUtil

local F, C = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

local function UpdateItemBorder(self)
    if not self.bg then
        return
    end

    if self.objectType == 'item' then
        local quality = select(4, GetQuestItemInfo(self.type, self:GetID()))
        local color = C.QualityColors[quality or 1]
        self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
    elseif self.objectType == 'currency' then
        local name, texture, numItems, quality = GetQuestCurrencyInfo(self.type, self:GetID())
        local currencyID = GetQuestCurrencyID(self.type, self:GetID())
        if name and texture and numItems and quality and currencyID then
            local currencyQuality = select(4, CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, numItems, name, texture, quality))
            local color = C.QualityColors[currencyQuality or 1]
            self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
        end
    else
        self.bg:SetBackdropBorderColor(0, 0, 0)
    end
end

local function ReskinItemButton(buttons)
    for i = 1, #buttons do
        local button = buttons[i]
        if button and not button.styled then
            button.Border:Hide()
            button.Mask:Hide()
            button.NameFrame:Hide()
            button.bg = F.ReskinIcon(button.Icon)
            button.textBg = F.CreateBDFrame(button, .25)
            button.textBg:SetPoint('TOPLEFT', button.bg, 'TOPRIGHT', 2, 0)
            button.textBg:SetPoint('BOTTOMRIGHT', -5, 1)

            button.styled = true
        end
        UpdateItemBorder(button)
    end
end

local function ReskinTitleButton(self, index)
    local button = self.Buttons[index]
    if button and not button.styled then
        F.StripTextures(button)
        F.Reskin(button)
        button.Overlay:Hide()
        button.Hilite:Hide()

        if index > 1 then
            button:ClearAllPoints()
            button:SetPoint('TOP', self.Buttons[index - 1], 'BOTTOM', 0, -3)
        end

        button.styled = true
    end
end

local function ReskinReward(self)
    local rewardsFrame = self.TalkBox.Elements.Content.RewardsFrame
    ReskinItemButton(rewardsFrame.Buttons)

    if GetNumRewardSpells() > 0 then
        -- follower
        for reward in rewardsFrame.followerRewardPool:EnumerateActive() do
            local portrait = reward.PortraitFrame
            if not reward.styled then
                F.ReskinGarrisonPortrait(portrait)
                reward.BG:Hide()
                portrait:SetPoint('TOPLEFT', 2, -5)
                reward.textBg = F.CreateBDFrame(reward, .25)
                reward.textBg:SetPoint('TOPLEFT', 0, -3)
                reward.textBg:SetPoint('BOTTOMRIGHT', 2, 7)
                reward.Class:SetPoint('TOPRIGHT', reward.textBg, 'TOPRIGHT', -C.Mult, -C.Mult)
                reward.Class:SetPoint('BOTTOMRIGHT', reward.textBg, 'BOTTOMRIGHT', -C.Mult, C.Mult)

                reward.styled = true
            end

            local color = C.QualityColors[portrait.quality or 1]
            portrait.squareBG:SetBackdropBorderColor(color.r, color.g, color.b)
            reward.Class:SetTexCoord(unpack(C.TexCoord))
        end

        -- spell
        for spellReward in rewardsFrame.spellRewardPool:EnumerateActive() do
            if not spellReward.styled then
                local icon = spellReward.Icon
                F.ReskinIcon(icon)

                local nameFrame = spellReward.NameFrame
                nameFrame:Hide()

                local bg = F.CreateBDFrame(nameFrame, .25)
                bg:SetPoint('TOPLEFT', icon, 'TOPRIGHT', 2, 1)
                bg:SetPoint('BOTTOMRIGHT', nameFrame, 'BOTTOMRIGHT', -24, 15)

                spellReward.styled = true
            end
        end
    end
end

local function ReskinProgress(self)
    ReskinItemButton(self.TalkBox.Elements.Progress.Buttons)
end

local function ReskinTooltip(self)
    for tooltip in self.Inspector.tooltipFramePool:EnumerateActive() do
        if not tooltip.styled then
            F.StripTextures(tooltip)
            local bg = F.SetBD(tooltip)
            bg:SetPoint('TOPLEFT', 0, 0)
            bg:SetPoint('BOTTOMRIGHT', 6, 0)
            tooltip.Icon.Border:SetAlpha(0)
            tooltip.Hilite:SetOutside(bg, 2, 2)
            tooltip.styled = true
        end
    end
end

local function ReskinImmersion()
    local cr, cg, cb = C.r, C.g, C.b

    local talkBox = _G.ImmersionFrame.TalkBox
    F.StripTextures(talkBox.PortraitFrame)
    F.StripTextures(talkBox.BackgroundFrame)
    F.StripTextures(talkBox.Hilite)

    local hilite = F.CreateBDFrame(talkBox.Hilite, 0)
    hilite:SetAllPoints(talkBox)
    hilite:SetBackdropColor(cr, cg, cb, .25)
    hilite:SetBackdropBorderColor(cr, cg, cb, 1)

    local mainFrame = talkBox.MainFrame
    F.StripTextures(mainFrame)
    F.SetBD(mainFrame, .45)

    local elements = talkBox.Elements
    F.StripTextures(elements)
    F.SetBD(elements, .45, 0, -12, 0, 0)
    elements.Content.RewardsFrame.ItemHighlight.Icon:SetAlpha(0)

    F.ReskinClose(mainFrame.CloseButton)
    F.StripTextures(mainFrame.Model)
    local bg = F.CreateBDFrame(mainFrame.Model, 0)
    bg:SetFrameLevel(mainFrame.Model:GetFrameLevel() + 1)

    local reputationBar = talkBox.ReputationBar
    reputationBar.icon:SetPoint('TOPLEFT', -30, 6)
    F.StripTextures(reputationBar)
    reputationBar:SetStatusBarTexture(C.Assets.statusbar_tex)
    F.CreateBDFrame(reputationBar, .25)

    for i = 1, 4 do
        local notch = _G['ImmersionFrameNotch' .. i]
        if notch then
            notch:SetColorTexture(0, 0, 0)
            notch:SetSize(C.Mult, 16)
        end
    end

    local indicator = mainFrame.Indicator
    indicator:SetScale(1)
    indicator:ClearAllPoints()
    indicator:SetPoint('RIGHT', mainFrame.CloseButton, 'LEFT', -3, 0)

    local titleButtons = _G.ImmersionFrame.TitleButtons
    hooksecurefunc(titleButtons, 'GetButton', ReskinTitleButton)

    hooksecurefunc(_G.ImmersionFrame, 'AddQuestInfo', ReskinReward)
    hooksecurefunc(_G.ImmersionFrame, 'QUEST_PROGRESS', ReskinProgress)
    hooksecurefunc(_G.ImmersionFrame, 'ShowItems', ReskinTooltip)
end

THEME:LoadWithAddOn('Immersion', 'ReskinImmersion', ReskinImmersion)
