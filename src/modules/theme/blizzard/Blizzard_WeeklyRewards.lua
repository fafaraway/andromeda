local F, C = unpack(select(2, ...))

-- /run UIParent_OnEvent({}, "WEEKLY_REWARDS_SHOW")

local function updateSelection(frame)
    if not frame.bg then
        return
    end

    if frame.SelectedTexture:IsShown() then
        frame.bg:SetBackdropBorderColor(1, 0.8, 0)
    else
        frame.bg:SetBackdropBorderColor(0, 0, 0)
    end
end

local iconColor = C.QualityColors[_G.LE_ITEM_QUALITY_EPIC or 4] -- epic color only
local function reskinRewardIcon(itemFrame)
    if not itemFrame.bg then
        itemFrame:DisableDrawLayer('BORDER')
        itemFrame.Icon:SetPoint('LEFT', 6, 0)
        itemFrame.bg = F.ReskinIcon(itemFrame.Icon)
        itemFrame.bg:SetBackdropBorderColor(iconColor.r, iconColor.g, iconColor.b)
    end
end

local function fixBg(anim) -- color reset for the first time game launched
    if anim.bg then
        anim.bg:SetBackdropColor(0, 0, 0, 0.25)
    end
end

local function ReskinActivityFrame(frame, isObject)
    if frame.Border then
        if isObject then
            frame.Border:SetAlpha(0)
            frame.SelectedTexture:SetAlpha(0)
            frame.LockIcon:SetVertexColor(C.r, C.g, C.b)
            hooksecurefunc(frame, 'SetSelectionState', updateSelection)
            hooksecurefunc(frame.ItemFrame, 'SetDisplayedItem', reskinRewardIcon)

            if frame.SheenAnim then
                frame.SheenAnim.bg = F.CreateBDFrame(frame.ItemFrame, 0.25)
                frame.SheenAnim:HookScript('OnFinished', fixBg)
            end
        else
            frame.Border:SetTexCoord(0.926, 1, 0, 1)
            frame.Border:SetSize(25, 137)
            frame.Border:SetPoint('LEFT', frame, 'RIGHT', 3, 0)
        end
    end

    if frame.Background then
        frame.bg = F.CreateBDFrame(frame.Background, 1)
    end
end

local function replaceIconString(self, text)
    if not text then
        text = self:GetText()
    end
    if not text or text == '' then
        return
    end

    local newText, count = gsub(text, '24:24:0:%-2', '14:14:0:0:64:64:5:59:5:59')
    if count > 0 then
        self:SetFormattedText('%s', newText)
    end
end

local function reskinConfirmIcon(frame)
    if frame.bg then
        return
    end
    frame.bg = F.ReskinIcon(frame.Icon)
    F.ReskinIconBorder(frame.IconBorder, true)
end

C.Themes['Blizzard_WeeklyRewards'] = function()
    local WeeklyRewardsFrame = _G.WeeklyRewardsFrame

    F.StripTextures(WeeklyRewardsFrame)
    F.SetBD(WeeklyRewardsFrame)
    F.ReskinClose(WeeklyRewardsFrame.CloseButton)
    F.StripTextures(WeeklyRewardsFrame.SelectRewardButton)
    F.Reskin(WeeklyRewardsFrame.SelectRewardButton)

    local headerFrame = WeeklyRewardsFrame.HeaderFrame
    F.StripTextures(headerFrame)
    F.CreateBDFrame(headerFrame, 0.25)
    headerFrame:SetPoint('TOP', 1, -42)
    headerFrame.Text:SetFontObject(_G.SystemFont_Huge1)

    ReskinActivityFrame(WeeklyRewardsFrame.RaidFrame)
    ReskinActivityFrame(WeeklyRewardsFrame.MythicFrame)
    ReskinActivityFrame(WeeklyRewardsFrame.PVPFrame)

    for _, frame in pairs(WeeklyRewardsFrame.Activities) do
        ReskinActivityFrame(frame, true)
    end

    hooksecurefunc(WeeklyRewardsFrame, 'SelectReward', function(self)
        local confirmFrame = self.confirmSelectionFrame
        if confirmFrame then
            if not confirmFrame.styled then
                reskinConfirmIcon(confirmFrame.ItemFrame)
                _G.WeeklyRewardsFrameNameFrame:Hide()
                confirmFrame.styled = true
            end

            local alsoItemsFrame = confirmFrame.AlsoItemsFrame
            if alsoItemsFrame.pool then
                for frame in alsoItemsFrame.pool:EnumerateActive() do
                    reskinConfirmIcon(frame)
                end
            end
        end
    end)

    local rewardText = WeeklyRewardsFrame.ConcessionFrame.RewardsFrame.Text
    replaceIconString(rewardText)
    hooksecurefunc(rewardText, 'SetText', replaceIconString)
end
