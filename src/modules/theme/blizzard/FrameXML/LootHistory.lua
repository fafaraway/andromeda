local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    local r, g, b = C.r, C.g, C.b

    local LootHistoryFrame = _G.GroupLootHistoryFrame or _G.LootHistoryFrame

    if not LootHistoryFrame then
        return
    end

    if not C.IS_NEW_PATCH_10_1 then
        LootHistoryFrame.Label:ClearAllPoints()
        LootHistoryFrame.Label:SetPoint('TOP', LootHistoryFrame, 'TOP', 0, -8)
        F.ReskinClose(LootHistoryFrame.CloseButton)
    end

    F.StripTextures(LootHistoryFrame)
    F.SetBD(LootHistoryFrame)
    if C.IS_NEW_PATCH_10_1 then
        F.ReskinClose(LootHistoryFrame.ClosePanelButton)
        F.ReskinTrimScroll(LootHistoryFrame.ScrollBar)
    else
        F.ReskinScroll(_G.LootHistoryFrameScrollFrameScrollBar)
    end

    -- [[ Resize button ]]

    F.StripTextures(LootHistoryFrame.ResizeButton)
    LootHistoryFrame.ResizeButton:SetHeight(8)

    do
        local line1 = LootHistoryFrame.ResizeButton:CreateTexture()
        line1:SetTexture(C.Assets.Textures.Backdrop)
        line1:SetVertexColor(0.7, 0.7, 0.7)
        line1:SetSize(30, C.MULT)
        line1:SetPoint('TOP', 0, -2)

        local line2 = LootHistoryFrame.ResizeButton:CreateTexture()
        line2:SetTexture(C.Assets.Textures.Backdrop)
        line2:SetVertexColor(0.7, 0.7, 0.7)
        line2:SetSize(30, C.MULT)
        line2:SetPoint('TOP', 0, -5)

        LootHistoryFrame.ResizeButton:HookScript('OnEnter', function()
            line1:SetVertexColor(r, g, b)
            line2:SetVertexColor(r, g, b)
        end)

        LootHistoryFrame.ResizeButton:HookScript('OnLeave', function()
            line1:SetVertexColor(0.7, 0.7, 0.7)
            line2:SetVertexColor(0.7, 0.7, 0.7)
        end)
    end

    -- [[ Item frame ]]

    if C.IS_NEW_PATCH_10_1 then
    else
        hooksecurefunc('LootHistoryFrame_UpdateItemFrame', function(self, frame)
            local rollID, _, _, isDone, winnerIdx = C_LootHistory.GetItem(frame.itemIdx)
            local expanded = self.expandedRolls[rollID]

            if not frame.styled then
                frame.Divider:Hide()
                frame.NameBorderLeft:Hide()
                frame.NameBorderRight:Hide()
                frame.NameBorderMid:Hide()
                frame.WinnerRoll:SetTextColor(0.9, 0.9, 0.9)

                frame.bg = F.ReskinIcon(frame.Icon)
                F.ReskinIconBorder(frame.IconBorder)

                F.ReskinCollapse(frame.ToggleButton)
                frame.ToggleButton:GetNormalTexture():SetAlpha(0)
                frame.ToggleButton:GetPushedTexture():SetAlpha(0)
                frame.ToggleButton:GetDisabledTexture():SetAlpha(0)

                frame.WinnerName:SetFontObject(_G.Game13Font)
                frame.WinnerRoll:SetWidth(28)
                frame.WinnerRoll:SetFontObject(_G.Game13Font)

                frame.styled = true
            end

            if isDone and not expanded and winnerIdx then
                local name, class = C_LootHistory.GetPlayerInfo(frame.itemIdx, winnerIdx)
                if name then
                    local color = C.ClassColors[class]
                    frame.WinnerName:SetVertexColor(color.r, color.g, color.b)
                end
            end
        end)

        hooksecurefunc('LootHistoryFrame_UpdatePlayerFrame', function(_, playerFrame)
            if not playerFrame.styled then
                playerFrame.PlayerName:SetWordWrap(false)
                playerFrame.PlayerName:SetFontObject(_G.Game13Font)
                playerFrame.RollText:SetTextColor(0.9, 0.9, 0.9)
                playerFrame.RollText:SetWidth(28)
                playerFrame.RollText:SetFontObject(_G.Game13Font)
                playerFrame.WinMark:SetDesaturated(true)
                playerFrame.WinMark:SetAtlas('checkmark-minimal')

                playerFrame.styled = true
            end

            if playerFrame.playerIdx then
                local name, class, _, _, isWinner = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)

                if name then
                    local color = C.ClassColors[class]
                    playerFrame.PlayerName:SetTextColor(color.r, color.g, color.b)

                    if isWinner then
                        playerFrame.WinMark:SetVertexColor(color.r, color.g, color.b)
                    end
                end
            end
        end)

        -- [[ Dropdown ]]

        _G.LootHistoryDropDown.initialize = function(self)
            local info = UIDropDownMenu_CreateInfo()
            info.isTitle = 1
            info.text = _G.MASTER_LOOTER
            info.fontObject = _G.GameFontNormalLeft
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info)

            info = UIDropDownMenu_CreateInfo()
            info.notCheckable = 1
            local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
            local classColor = C.ClassColors[class]
            local colorCode = classColor.colorStr
            info.text = string.format(_G.MASTER_LOOTER_GIVE_TO, colorCode .. name .. '|r')
            info.func = LootHistoryDropDown_OnClick
            UIDropDownMenu_AddButton(info)
        end
    end
end)
