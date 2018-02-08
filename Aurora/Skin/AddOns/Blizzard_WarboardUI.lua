local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next max floor

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin
local F, C = _G.unpack(Aurora)

do --[[ AddOns\Blizzard_WarboardUI.lua ]]
    local WarboardQuestChoiceFrameMixin do
        WarboardQuestChoiceFrameMixin = {}
        function WarboardQuestChoiceFrameMixin:OnHeightChanged(heightDiff)
            private.debug("WarboardQuestChoiceFrameMixin:OnHeightChanged", heightDiff)
            local initOptionHeaderTextHeight = Scale.Value(self.initOptionHeaderTextHeight)
            local maxHeaderTextHeight = initOptionHeaderTextHeight
            private.debug("initOptionHeaderTextHeight", initOptionHeaderTextHeight)

            for _, option in next, self.Options do
                maxHeaderTextHeight = max(maxHeaderTextHeight, option.Header.Text:GetHeight())
            end
            private.debug("maxHeaderTextHeight", maxHeaderTextHeight)

            local headerTextDifference = floor(maxHeaderTextHeight) - initOptionHeaderTextHeight
            private.debug("headerTextDifference", headerTextDifference)

            for _, option in next, self.Options do
                Scale.RawSetHeight(option.Header.Text, maxHeaderTextHeight)
                Scale.RawSetHeight(option, option:GetHeight() + headerTextDifference)
                Scale.RawSetHeight(option.Header.Background, Scale.Value(self.initOptionBackgroundHeight) + heightDiff + headerTextDifference)
            end
        end
        function WarboardQuestChoiceFrameMixin:Update()
            private.debug("WarboardQuestChoiceFrameMixin:Update")
            Hook.QuestChoiceFrameMixin.Update(self)

            local _, _, numOptions = _G.GetQuestChoiceInfo()

            if (numOptions == 1) then
                local textWidth = self.Title.Text:GetWidth()
                local neededWidth = max(120, (textWidth/2) - 40)

                local newWidth = (neededWidth*2)+430
                self.fixedWidth = max(600, newWidth)
                self.leftPadding = ((self.fixedWidth - self.Option1:GetWidth()) / 2) - 4
                self.Title:SetPoint("LEFT", self.Option1, "LEFT", -neededWidth, 0)
                self.Title:SetPoint("RIGHT", self.Option1, "RIGHT", neededWidth, 0)
            else
                self.fixedWidth = 600
                self.Title:SetPoint("LEFT", self.Option1, "LEFT", -3, 0)
                self.Title:SetPoint("RIGHT", self.Options[numOptions], "RIGHT", 3, 0)
            end
            self:Layout()
        end
    end
    Hook.WarboardQuestChoiceFrameMixin = WarboardQuestChoiceFrameMixin
end

do --[[ AddOns\Blizzard_WarboardUI.xml ]]
    function Skin.WarboardQuestChoiceOptionTemplate(button)
        button.Nail:Hide()
        button.Artwork:ClearAllPoints()
        button.Artwork:SetPoint("TOPLEFT", 31, -31)
        button.Artwork:SetPoint("BOTTOMRIGHT", button, "TOPRIGHT", -31, -112)
        button.Border:Hide()

        -- Skin.UIPanelButtonTemplate(button.OptionButton)
        F.Reskin(button.OptionButton)

        button.Header.Background:Hide()
        button.Header.Text:SetTextColor(.9, .9, .9)
        button.OptionText:SetTextColor(.9, .9, .9)

        --[[ Scale ]]--
        button:SetSize(240, 332)
        button.OptionButton:SetSize(175, 22)
        button.OptionButton:SetPoint("BOTTOM", 0, 46)
        button.Header.Text:SetWidth(180)
        button.Header.Text:SetPoint("TOP", button.Artwork, "BOTTOM", 0, -21)
        button.OptionText:SetWidth(180)
        button.OptionText:SetPoint("TOP", button.Header.Text, "BOTTOM", 0, -12)
        button.OptionText:SetPoint("BOTTOM", button.OptionButton, "TOP", 0, 39)
        button.OptionText:SetText("Text")
    end
end

function private.AddOns.Blizzard_WarboardUI()
    local WarboardQuestChoiceFrame = _G.WarboardQuestChoiceFrame
    -- Skin.HorizontalLayoutFrame(WarboardQuestChoiceFrame)
    F.CreateBD(WarboardQuestChoiceFrame)
    F.CreateSD(WarboardQuestChoiceFrame)
    _G.Mixin(WarboardQuestChoiceFrame, Hook.WarboardQuestChoiceFrameMixin)

    WarboardQuestChoiceFrame.Top:Hide()
    WarboardQuestChoiceFrame.Bottom:Hide()
    WarboardQuestChoiceFrame.Left:Hide()
    WarboardQuestChoiceFrame.Right:Hide()

    WarboardQuestChoiceFrame.Header:SetAlpha(0)

    _G.WarboardQuestChoiceFrameTopRightCorner:Hide()
    WarboardQuestChoiceFrame.topLeftCorner:Hide()
    WarboardQuestChoiceFrame.topBorderBar:Hide()
    _G.WarboardQuestChoiceFrameBotRightCorner:Hide()
    _G.WarboardQuestChoiceFrameBotLeftCorner:Hide()
    _G.WarboardQuestChoiceFrameBottomBorder:Hide()
    WarboardQuestChoiceFrame.leftBorderBar:Hide()
    _G.WarboardQuestChoiceFrameRightBorder:Hide()

    Base.SetBackdrop(WarboardQuestChoiceFrame)

    WarboardQuestChoiceFrame.GarrCorners:Hide()

    for _, option in next, WarboardQuestChoiceFrame.Options do
        Skin.WarboardQuestChoiceOptionTemplate(option)
    end

    WarboardQuestChoiceFrame.Background:Hide()
    WarboardQuestChoiceFrame.Title.Left:Hide()
    WarboardQuestChoiceFrame.Title.Right:Hide()
    WarboardQuestChoiceFrame.Title.Middle:Hide()

    Skin.UIPanelCloseButton(WarboardQuestChoiceFrame.CloseButton)
    WarboardQuestChoiceFrame.CloseButton:SetPoint("TOPRIGHT", -10, -10)

    --[[ Scale ]]--
    WarboardQuestChoiceFrame.Header:SetSize(354, 105)
    WarboardQuestChoiceFrame.Header:SetPoint("TOP", 0, 72)
    WarboardQuestChoiceFrame.Title:SetSize(500, 85)
end
