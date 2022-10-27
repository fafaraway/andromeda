local F, C = unpack(select(2, ...))

local function replaceGossipFormat(button, textFormat, text)
    local newFormat, count = gsub(textFormat, '000000', 'ffffff')
    if count > 0 then
        button:SetFormattedText(newFormat, text)
    end
end

local replacedGossipColor = {
    ['000000'] = 'ffffff',
    ['414141'] = '7b8489', -- lighter color for some gossip options
}
local function replaceGossipText(button, text)
    if text and text ~= '' then
        local newText, count = gsub(text, ':32:32:0:0', ':32:32:0:0:64:64:5:59:5:59') -- replace icon texture
        if count > 0 then
            text = newText
            button:SetFormattedText('%s', text)
        end

        local colorStr, rawText = strmatch(text, '|c[fF][fF](%x%x%x%x%x%x)(.-)|r')
        colorStr = replacedGossipColor[colorStr]
        if colorStr and rawText then
            button:SetFormattedText('|cff%s%s|r', colorStr, rawText)
        end
    end
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local GossipFrame = _G.GossipFrame

    _G.QuestFont:SetTextColor(1, 1, 1)

    if C.IS_NEW_PATCH then
        F.Reskin(GossipFrame.GreetingPanel.GoodbyeButton)
        F.ReskinTrimScroll(GossipFrame.GreetingPanel.ScrollBar)

        hooksecurefunc(GossipFrame.GreetingPanel.ScrollBox, 'Update', function(self)
            for i = 1, self.ScrollTarget:GetNumChildren() do
                local button = select(i, self.ScrollTarget:GetChildren())
                if not button.styled then
                    local buttonText = select(3, button:GetRegions()) -- no parentKey atm
                    if buttonText and buttonText:IsObjectType('FontString') then
                        replaceGossipText(button, button:GetText())
                        hooksecurefunc(button, 'SetText', replaceGossipText)
                        hooksecurefunc(button, 'SetFormattedText', replaceGossipFormat)
                    end

                    button.styled = true
                end
            end
        end)

        -- #TODO
        for i = 1, 4 do
            local notch = GossipFrame.FriendshipStatusBar['Notch' .. i]
            if notch then
                notch:SetColorTexture(0, 0, 0)
                notch:SetSize(C.MULT, 16)
            end
        end
    else
        _G.GossipGreetingText:SetTextColor(1, 1, 1)
        _G.NPCFriendshipStatusBar.icon:SetPoint('TOPLEFT', -30, 7)
        F.StripTextures(_G.NPCFriendshipStatusBar, 4)
        _G.NPCFriendshipStatusBar:SetStatusBarTexture(C.Assets.Textures.StatusbarNormal)
        F.CreateBDFrame(_G.NPCFriendshipStatusBar, 0.25)

        for i = 1, 4 do
            local notch = _G.NPCFriendshipStatusBar['Notch' .. i]
            if notch then
                notch:SetColorTexture(0, 0, 0)
                notch:SetSize(1, 16)
            end
        end

        F.Reskin(_G.GossipFrameGreetingGoodbyeButton)
        F.ReskinScroll(_G.GossipGreetingScrollFrameScrollBar)

        hooksecurefunc('GossipFrameUpdate', function()
            for button in _G.GossipFrame.titleButtonPool:EnumerateActive() do
                if not button.styled then
                    replaceGossipText(button, button:GetText())
                    hooksecurefunc(button, 'SetText', replaceGossipText)
                    hooksecurefunc(button, 'SetFormattedText', replaceGossipFormat)

                    button.styled = true
                end
            end
        end)
    end

    _G.GossipFrameInset:Hide()
    if _G.GossipFrame.Background then
        _G.GossipFrame.Background:Hide()
    end
    F.ReskinPortraitFrame(_G.GossipFrame)

    -- Text on QuestFrame
    _G.QuestFrameGreetingPanel:HookScript('OnShow', function(self)
        for button in self.titleButtonPool:EnumerateActive() do
            if not button.styled then
                replaceGossipText(button, button:GetText())
                hooksecurefunc(button, 'SetFormattedText', replaceGossipFormat)

                button.styled = true
            end
        end
    end)
end)
