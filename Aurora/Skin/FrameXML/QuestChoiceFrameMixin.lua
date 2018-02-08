local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals max

--[[ Core ]]
local Aurora = private.Aurora
local Hook, Scale = Aurora.Hook, Aurora.Scale

do --[[ FrameXML\QuestChoiceFrameMixin.lua ]]
    local QuestChoiceFrameMixin do
        QuestChoiceFrameMixin = {}
        function QuestChoiceFrameMixin:Update()
            private.debug("QuestChoiceFrameMixin:Update")
            self.hasPendingUpdate = false

            local choiceID, questionText, numOptions = _G.GetQuestChoiceInfo()
            if (not choiceID or choiceID == 0) then
                self:Hide()
                return
            end
            self.choiceID = choiceID
            self.QuestionText:SetText(questionText)

            for i=1, numOptions do
                local optID, buttonText, description, header, artFile, confirmationText = _G.GetQuestChoiceOptionInfo(i)
                local option = self.Options[i]
                option.optID = optID
                option.OptionButton:SetText(buttonText)
                Scale.RawSetWidth(option.OptionText, option.OptionText:GetWidth())
                option.OptionText:SetText(description)
                if header and #header > 0 then
                    option.Header:Show()
                    option.Header.Text:SetHeight(0)
                    option.Header.Text:SetText(header)
                else
                    option.Header:Hide()
                end
                option.Artwork:SetTexture(artFile)
                option.confirmationText = confirmationText
            end

            self:ShowRewards(numOptions)

            --make window taller if there is too much stuff
            local initOptionHeight = Scale.Value(self.initOptionHeight or _G.INIT_OPTION_HEIGHT)
            local optionStaticHeight = Scale.Value(self.optionStaticHeight or _G.OPTION_STATIC_HEIGHT)
            local maxHeight = initOptionHeight
            private.debug("initOptionHeight", initOptionHeight)
            private.debug("optionStaticHeight", optionStaticHeight)
            for i=1, numOptions do
                local option = self.Options[i]
                local currHeight = optionStaticHeight

                currHeight = currHeight + option.OptionText:GetContentHeight()
                if (option.Rewards) then
                    currHeight = currHeight + option.Rewards:GetHeight() + Scale.Value(25)
                end
                private.debug("currHeight", currHeight)
                maxHeight = max(currHeight, maxHeight)
            end
            for i=1, numOptions do
                local option = self.Options[i]
                private.debug("maxHeight", maxHeight)
                Scale.RawSetHeight(option, maxHeight)
            end
            local heightDiff = maxHeight - initOptionHeight
            heightDiff = max(heightDiff, 0)
            local initWindowHeight = Scale.Value(self.initWindowHeight or _G.INIT_WINDOW_HEIGHT)
            Scale.RawSetHeight(self, initWindowHeight + heightDiff)
            if (self.OnHeightChanged) then
                self:OnHeightChanged(heightDiff)
            end

            for i = 1, #self.Options do
                self.Options[i]:SetShown(i <= numOptions)
            end
            if numOptions == 1 then
                self.leftPadding = (self.fixedWidth - self.Option1:GetWidth()) / 2
                self.rightPadding = 0
                self.spacing = 0
            elseif numOptions == 4 then
                self.leftPadding = 50
                self.rightPadding = 50
                self.spacing = 20
            else
                self.leftPadding = self.defaultLeftPadding
                self.rightPadding = self.defaultRightPadding
                self.spacing = self.defaultSpacing
            end

            self:Layout()
        end

        function QuestChoiceFrameMixin:ShowRewards(numOptions)
            private.debug("QuestChoiceFrameMixin:ShowRewards", numOptions)
            for i=1, numOptions do
                local rewardFrame = self["Option"..i].Rewards
                local height = Scale.Value(_G.INIT_REWARDS_HEIGHT)
                local _, _, _, _, _, numItems, numCurrencies, _, numReps = _G.GetQuestChoiceRewardInfo(i)

                if (numItems ~= 0) then
                    local itemID, name, texture, quantity, quality, itemLink = _G.GetQuestChoiceRewardItem(i, 1) --for now there is only ever 1 item by design
                    if itemID then
                        rewardFrame.Item.itemID = itemID
                        rewardFrame.Item:Show()
                        rewardFrame.Item.Name:SetText(name)
                        _G.SetItemButtonCount(rewardFrame.Item, quantity)
                        _G.SetItemButtonTexture(rewardFrame.Item, texture)
                        _G.SetItemButtonQuality(rewardFrame.Item, quality, itemID)
                        rewardFrame.Item.itemLink = itemLink
                        height = height + rewardFrame.Item:GetHeight()
                    else
                        rewardFrame.Item:Hide()
                    end
                else
                    rewardFrame.Item:Hide()
                end

                if (numCurrencies ~= 0) then
                    local width, currency
                    local totalWidth = 0
                    for j=1, numCurrencies do
                        currency = rewardFrame.Currencies["Currency"..j]
                        local currID, texture, quantity = _G.GetQuestChoiceRewardCurrency(i, j) --there should only be one currency reward
                        currency.currencyID = currID
                        currency.Icon:SetTexture(texture)
                        currency.Quantity:SetText(quantity)
                        --set width of currency frame to barely hold icon and string
                        width = currency.Icon:GetWidth() + Scale.Value(_G.CURRENCY_SPACING) + currency.Quantity:GetWidth()
                        Scale.RawSetSize(currency, width, Scale.Value(_G.CURRENCY_HEIGHT))
                        totalWidth = totalWidth + width
                    end
                    --calculate amount of space between each currency, and adjust positions
                    local space = (rewardFrame.Currencies:GetWidth() - totalWidth) / (numCurrencies + 1)
                    currency = rewardFrame.Currencies.Currency1
                    Scale.RawSetPoint(currency, "TOPLEFT", rewardFrame.Currencies, "TOPLEFT", space, 0)
                    local prevFrame = currency
                    for j=2, numCurrencies do
                        currency = rewardFrame.Currencies["Currency"..j]
                        Scale.RawSetPoint(currency, "LEFT", prevFrame, "RIGHT", space, 0)
                        prevFrame = currency
                        currency:Show()
                    end
                    --hide extra currency frames
                    for j=numCurrencies+1, _G.MAX_CURRENCIES do
                        currency = rewardFrame.Currencies["Currency"..j]
                        currency:Hide()
                        currency.currencyID = nil
                    end
                    --show currencies and reanchor if there are no item rewards
                    rewardFrame.Currencies:Show()
                    if (numItems == 0) then
                        rewardFrame.Currencies:SetPoint("TOPLEFT", rewardFrame, "TOPLEFT", 0, -5)
                    else
                        rewardFrame.Currencies:SetPoint("TOPLEFT", rewardFrame.Item, "BOTTOMLEFT", -30, -5)
                    end
                    height =  height + rewardFrame.Currencies:GetHeight()
                else
                    rewardFrame.Currencies:Hide()
                end


                if (numReps ~= 0) then
                    local repFrame = rewardFrame.ReputationsFrame.Reputation1
                    local factionFrame = repFrame.Faction
                    local amountFrame = repFrame.Amount
                    local dummyString = self.DummyString
                    local factionID, quantity = _G.GetQuestChoiceRewardFaction(i, 1) --there should only be one reputation reward
                    local factionName = _G.REWARD_REPUTATION:format(_G.GetFactionInfoByID(factionID))
                    dummyString:SetText(factionName)
                    factionFrame:SetText(factionName)
                    amountFrame:SetText(quantity)
                    local amountWidth = amountFrame:GetWidth()
                    local factionWidth = dummyString:GetWidth()

                    local REWARDS_WIDTH = Scale.Value(_G.REWARDS_WIDTH)
                    if ((amountWidth + factionWidth) > REWARDS_WIDTH) then
                        Scale.RawSetWidth(factionFrame, REWARDS_WIDTH - amountWidth - Scale.Value(5))
                        repFrame.tooltip = factionName
                    else
                        factionFrame:SetWidth(factionWidth)
                        repFrame.tooltip = nil
                    end
                    rewardFrame.ReputationsFrame:Show()
                    height = height + rewardFrame.ReputationsFrame:GetHeight()
                else
                    rewardFrame.ReputationsFrame:Hide()
                end
                Scale.RawSetHeight(rewardFrame, height)
            end
        end
    end
    Hook.QuestChoiceFrameMixin = QuestChoiceFrameMixin

    function Hook.QuestChoiceOptionText_SetText(self, text)
        self:SetWidth(self:GetWidth())
        self:SetText(text)
    end
end

function private.FrameXML.QuestChoiceFrameMixin()
    _G.Mixin(_G.QuestChoiceFrameMixin, Hook.QuestChoiceFrameMixin)
end
