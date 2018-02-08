local _, private = ...

-- [[ WoW API ]]
local C_LootHistory = _G.C_LootHistory

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

function private.FrameXML.LootHistory()
    local r, g, b = C.r, C.g, C.b

    local LootHistoryFrame = _G.LootHistoryFrame

    for i = 1, 9 do
        _G.select(i, LootHistoryFrame:GetRegions()):Hide()
    end
    LootHistoryFrame.LootIcon:Hide()
    LootHistoryFrame.Divider:SetAlpha(0)
    _G.LootHistoryFrameScrollFrame:GetRegions():Hide()

    LootHistoryFrame.Label:ClearAllPoints()
    LootHistoryFrame.Label:SetPoint("TOP", LootHistoryFrame, "TOP", 0, -8)

    F.CreateBD(LootHistoryFrame)

    F.ReskinClose(LootHistoryFrame.CloseButton)
    F.ReskinScroll(_G.LootHistoryFrameScrollFrameScrollBar)

    -- [[ Resize button ]]

    LootHistoryFrame.ResizeButton:SetNormalTexture("")
    LootHistoryFrame.ResizeButton:SetHeight(8)

    do
        local line1 = LootHistoryFrame.ResizeButton:CreateTexture()
        line1:SetTexture(C.media.backdrop)
        line1:SetVertexColor(.7, .7, .7)
        line1:SetSize(30, 1)
        line1:SetPoint("TOP")

        local line2 = LootHistoryFrame.ResizeButton:CreateTexture()
        line2:SetTexture(C.media.backdrop)
        line2:SetVertexColor(.7, .7, .7)
        line2:SetSize(30, 1)
        line2:SetPoint("TOP", 0, -3)

        LootHistoryFrame.ResizeButton:HookScript("OnEnter", function(self)
            line1:SetVertexColor(r, g, b)
            line2:SetVertexColor(r, g, b)
        end)

        LootHistoryFrame.ResizeButton:HookScript("OnLeave", function(self)
            line1:SetVertexColor(.7, .7, .7)
            line2:SetVertexColor(.7, .7, .7)
        end)
    end

    -- [[ Item frame ]]

    _G.hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, frame)
        local rollID, _, _, isDone, winnerIdx = C_LootHistory.GetItem(frame.itemIdx)
        local expanded = self.expandedRolls[rollID]

        if not frame.styled then
            frame.Divider:Hide()
            frame.NameBorderLeft:Hide()
            frame.NameBorderRight:Hide()
            frame.NameBorderMid:Hide()
            frame.IconBorder:Hide()

            frame.WinnerRoll:SetTextColor(.9, .9, .9)

            frame.Icon:SetTexCoord(.08, .92, .08, .92)
            frame.Icon:SetDrawLayer("ARTWORK")
            frame.bg = F.CreateBG(frame.Icon)
            frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())

            F.ReskinExpandOrCollapse(frame.ToggleButton)
            frame.styled = true
        end

        if isDone and not expanded and winnerIdx then
            local name, class = C_LootHistory.GetPlayerInfo(frame.itemIdx, winnerIdx)
            if name then
                local colour = _G.CUSTOM_CLASS_COLORS[class]
                frame.WinnerName:SetVertexColor(colour.r, colour.g, colour.b)
            end
        end

        frame.bg:SetVertexColor(frame.IconBorder:GetVertexColor())
    end)

    -- [[ Player frame ]]

    _G.hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(_, playerFrame)
        if not playerFrame.styled then
            playerFrame.RollText:SetTextColor(.9, .9, .9)
            playerFrame.WinMark:SetDesaturated(true)

            playerFrame.styled = true
        end

        if playerFrame.playerIdx then
            local name, class, _, _, isWinner = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)

            if name then
                local colour = _G.CUSTOM_CLASS_COLORS[class]
                playerFrame.PlayerName:SetTextColor(colour.r, colour.g, colour.b)

                if isWinner then
                    playerFrame.WinMark:SetVertexColor(colour.r, colour.g, colour.b)
                end
            end
        end
    end)

    -- [[ Dropdown ]]

    _G.LootHistoryDropDown.initialize = function(self)
        local info = _G.UIDropDownMenu_CreateInfo()
        info.isTitle = 1
        info.text = _G.MASTER_LOOTER
        info.fontObject = _G.GameFontNormalLeft
        info.notCheckable = 1
        _G.UIDropDownMenu_AddButton(info)

        info = _G.UIDropDownMenu_CreateInfo()
        info.notCheckable = 1
        local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
        local colorStr = _G.CUSTOM_CLASS_COLORS[class].colorStr
        info.text = _G.MASTER_LOOTER_GIVE_TO:format(colorStr..name.."|r")
        info.func = _G.LootHistoryDropDown_OnClick
        _G.UIDropDownMenu_AddButton(info)
    end
end
