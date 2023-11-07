local F, C, L = unpack(select(2, ...))
local ER = F:RegisterModule('EnhancedReputation')

-- #FIXME

local rep = {}
local extraRep = {}

local repMsg = '%s (%d/%d): %+d ' .. L['Reputation']
local paraMsg = C.GREEN_COLOR .. '%s (%d/10000): %+d ' .. L['Paragon Reputation'] .. '|r'
local cacheMsg = C.RED_COLOR
    .. '%s (%d/10000): %+d '
    .. L['Paragon Reputation']
    .. ' ('
    .. L['Max Reputation - Receive Reward.']
    .. ')|r'

local function CreateMessage(msg)
    local info = _G.ChatTypeInfo['COMBAT_FACTION_CHANGE']
    for i = 1, 4, 1 do
        local chatframe = getglobal('ChatFrame' .. i)
        for _, v in pairs(chatframe.messageTypeList) do
            if v == 'COMBAT_FACTION_CHANGE' then
                chatframe:AddMessage(msg, info.r, info.g, info.b, info.id)
                break
            end
        end
    end
end

local function InitExtraRep(factionID, name)
    local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
    if not extraRep[name] then
        extraRep[name] = currentValue % threshold
        if hasRewardPending then
            extraRep[name] = extraRep[name] + threshold
        end
    end
    if extraRep[name] > threshold and not hasRewardPending then
        extraRep[name] = extraRep[name] - threshold
    end
end

local value = 0
local function UpdateRep(self)
    local numFactions = GetNumFactions(self)
    for i = 1, numFactions, 1 do
        local name, _, _, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID = GetFactionInfo(i)

        if barValue >= 42000 then
            local hasParagon = C_Reputation.IsFactionParagon(factionID)
            if hasParagon then
                InitExtraRep(factionID, name)
                local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
                value = currentValue % threshold
                if hasRewardPending then
                    value = value + threshold
                end
                local extraChange = value - extraRep[name]
                if extraChange > 0 and value < 10000 then
                    extraRep[name] = value
                    local extra_msg = format(paraMsg, name, value, extraChange)
                    CreateMessage(extra_msg)
                end
                if extraChange ~= 0 and value > 10000 then
                    extraRep[name] = value
                    local extra_msg2 = format(cacheMsg, name, value, extraChange)
                    CreateMessage(extra_msg2)
                end
            end
        elseif name and not isHeader or hasRep then
            if not rep[name] then
                rep[name] = barValue
            end

            local change = barValue - rep[name]
            if change > 0 then
                rep[name] = barValue
                local msg = format(repMsg, name, barValue - barMin, barMax - barMin, change)
                CreateMessage(msg)
            end
        end
    end
end

local function HookParagonRep()
    local numFactions = GetNumFactions()
    local factionOffset = FauxScrollFrame_GetOffset(_G.ReputationListScrollFrame)

    for i = 1, _G.NUM_FACTIONS_DISPLAYED, 1 do
        local factionIndex = factionOffset + i
        local factionRow = _G['ReputationBar' .. i]
        local factionBar = _G['ReputationBar' .. i .. 'ReputationBar']
        local factionStanding = _G['ReputationBar' .. i .. 'ReputationBarFactionStanding']

        if factionIndex <= numFactions then
            local name, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
            if factionID and C_Reputation.IsFactionParagon(factionID) then
                local currentValue, threshold, rewardQuestID, hasRewardPending = C_Reputation.GetFactionParagonInfo(
                    factionID
                )
                factionRow.questID = rewardQuestID
                local r, g, b = 0.9, 0.8, 0.6

                if currentValue then
                    local barValue = mod(currentValue, threshold)
                    if hasRewardPending then
                        local paragonFrame = _G.ReputationFrame.paragonFramesPool:Acquire()
                        paragonFrame.factionID = factionID
                        paragonFrame:SetPoint('RIGHT', factionRow, 11, 0)
                        paragonFrame.Glow:SetShown(true)
                        paragonFrame.Check:SetShown(true)
                        paragonFrame:Show()
                        barValue = barValue + threshold
                    end

                    factionBar:SetMinMaxValues(0, threshold)
                    factionBar:SetValue(barValue)
                    factionBar:SetStatusBarColor(r, g, b)
                    factionRow.rolloverText = C.INFO_COLOR
                        .. format(_G.REPUTATION_PROGRESS_FORMAT, barValue, threshold)

                    if hasRewardPending then
                        barValue = barValue - threshold
                        factionStanding:SetText('+' .. BreakUpLargeNumbers(barValue))
                        factionRow.standingText = '+' .. BreakUpLargeNumbers(barValue)
                    else
                        barValue = threshold - barValue
                        factionStanding:SetText(BreakUpLargeNumbers(barValue))
                        factionRow.standingText = BreakUpLargeNumbers(barValue)
                    end
                    factionRow.rolloverText = nil

                    if factionIndex == GetSelectedFaction() and _G.ReputationDetailFrame:IsShown() then
                        local count = floor(currentValue / threshold)
                        if hasRewardPending then
                            count = count - 1
                        end
                        if count > 0 then
                            _G.ReputationDetailFactionName:SetText(name .. ' |cffffffffx' .. count .. '|r')
                        end
                    end
                end
            else
                factionRow.questID = nil
            end
        else
            factionRow:Hide()
        end
    end
end

function ER:OnLogin()
    F:RegisterEvent('UPDATE_FACTION', UpdateRep)

    ChatFrame_AddMessageEventFilter('CHAT_MSG_COMBAT_FACTION_CHANGE', function()
        return true
    end)

    hooksecurefunc('ReputationFrame_Update', HookParagonRep)
end
