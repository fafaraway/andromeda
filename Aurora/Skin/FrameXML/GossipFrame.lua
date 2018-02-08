local _, private = ...

-- [[ Core ]]
local Aurora = private.Aurora
local Hook, Skin = Aurora.Hook, Aurora.Skin

local F = _G.unpack(private.Aurora)

do --[[ FrameXML\GossipFrame.lua ]]
    local availDataPerQuest, activeDataPerQuest = 7, 6
    function Hook.GossipFrameAvailableQuestsUpdate(...)
        local numAvailQuestsData = _G.select("#", ...)
        local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numAvailQuestsData / availDataPerQuest)
        for i = 1, numAvailQuestsData, availDataPerQuest do
            local titleText, _, isTrivial = _G.select(i, ...)
            local titleButton = _G["GossipTitleButton" .. buttonIndex]
            if isTrivial then
                titleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, titleText)
            else
                titleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, titleText)
            end
            buttonIndex = buttonIndex + 1
        end
    end
    function Hook.GossipFrameActiveQuestsUpdate(...)
        local numActiveQuestsData = _G.select("#", ...)
        local buttonIndex = (_G.GossipFrame.buttonIndex - 1) - (numActiveQuestsData / activeDataPerQuest)
        for i = 1, numActiveQuestsData, activeDataPerQuest do
            local titleText, _, isTrivial = _G.select(i, ...)
            local titleButton = _G["GossipTitleButton" .. buttonIndex]
            if isTrivial then
                titleButton:SetFormattedText(private.TRIVIAL_QUEST_DISPLAY, titleText)
            else
                titleButton:SetFormattedText(private.NORMAL_QUEST_DISPLAY, titleText)
            end
            buttonIndex = buttonIndex + 1
        end
    end
end

do --[[ FrameXML\GossipFrame.xml ]]
    function Skin.GossipFramePanelTemplate(frame)
        local name = frame:GetName()
        frame:SetPoint("BOTTOMRIGHT")

        _G[name.."MaterialTopLeft"]:SetAlpha(0)
        _G[name.."MaterialTopRight"]:SetAlpha(0)
        _G[name.."MaterialBotLeft"]:SetAlpha(0)
        _G[name.."MaterialBotRight"]:SetAlpha(0)
    end
    function Skin.GossipTitleButtonTemplate(button)
        local highlight = button:GetHighlightTexture()
        local r, g, b = Aurora.highlightColor:GetRGB()
        highlight:SetColorTexture(r, g, b, 0.2)
    end
end

function private.FrameXML.GossipFrame()
    _G.hooksecurefunc("GossipFrameAvailableQuestsUpdate", Hook.GossipFrameAvailableQuestsUpdate)
    _G.hooksecurefunc("GossipFrameActiveQuestsUpdate", Hook.GossipFrameActiveQuestsUpdate)

    --[[ GossipFrame ]]--
    Skin.ButtonFrameTemplate(_G.GossipFrame)
    F.CreateBD(_G.GossipFrame)
    F.CreateSD(_G.GossipFrame)

    -- BlizzWTF: This texture doesn't have a handle because the name it's been given already exists via the template
    _G.select(19, _G.GossipFrame:GetRegions()):Hide() -- GossipFrameBg

    -- BlizzWTF: This should use the title text included in the template
    _G.GossipFrameNpcNameText:SetAllPoints(_G.GossipFrame.TitleText)

    Skin.GossipFramePanelTemplate(_G.GossipFrameGreetingPanel)
    F.Reskin(_G.GossipFrameGreetingGoodbyeButton)
    _G.GossipFrameGreetingGoodbyeButton:SetPoint("BOTTOMRIGHT", -4, 4)

    Skin.UIPanelScrollFrameTemplate(_G.GossipGreetingScrollFrame)
    _G.GossipGreetingScrollFrame:SetPoint("TOPLEFT", _G.GossipFrame, 4, -(private.FRAME_TITLE_HEIGHT + 4))
    _G.GossipGreetingScrollFrame:SetPoint("BOTTOMRIGHT", _G.GossipFrame, -23, 30)

    _G.GossipGreetingScrollFrameTop:Hide()
    _G.GossipGreetingScrollFrameBottom:Hide()
    _G.GossipGreetingScrollFrameMiddle:Hide()

    for i = 1, _G.NUMGOSSIPBUTTONS do
        Skin.GossipTitleButtonTemplate(_G["GossipTitleButton"..i])
    end


    --[[ NPCFriendshipStatusBar ]]--
    _G.NPCFriendshipStatusBar:GetRegions():Hide()
    _G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -20, 7)
    for i = 1, 4 do
        local notch = _G["NPCFriendshipStatusBarNotch"..i]
        notch:SetColorTexture(0, 0, 0)
        notch:SetSize(1, 16)
    end

    local bg = _G.select(7, _G.NPCFriendshipStatusBar:GetRegions())
    bg:SetPoint("TOPLEFT", -1, 1)
    bg:SetPoint("BOTTOMRIGHT", 1, -1)
end
