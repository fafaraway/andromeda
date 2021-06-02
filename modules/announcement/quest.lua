local _G = _G
local unpack = unpack
local select = select
local format = format
local floor = floor
local mod = mod
local wipe = wipe
local gsub = gsub
local strfind = strfind
local strmatch = strmatch
local CreateFrame = CreateFrame
local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_IsComplete = C_QuestLog.IsComplete
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_GetQuestIDForLogIndex = C_QuestLog.GetQuestIDForLogIndex
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local LE_QUEST_TAG_TYPE_PROFESSION = Enum.QuestTagType.Profession
local LE_QUEST_FREQUENCY_DAILY = Enum.QuestFrequency.Daily
local GetQuestLink = GetQuestLink
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local SendChatMessage = SendChatMessage
local ERR_QUEST_ADD_FOUND_SII = ERR_QUEST_ADD_FOUND_SII
local ERR_QUEST_ADD_ITEM_SII = ERR_QUEST_ADD_ITEM_SII
local ERR_QUEST_ADD_KILL_SII = ERR_QUEST_ADD_KILL_SII
local ERR_QUEST_ADD_PLAYER_KILL_SII = ERR_QUEST_ADD_PLAYER_KILL_SII
local ERR_QUEST_OBJECTIVE_COMPLETE_S = ERR_QUEST_OBJECTIVE_COMPLETE_S
local ERR_QUEST_COMPLETE_S = ERR_QUEST_COMPLETE_S
local ERR_QUEST_FAILED_S = ERR_QUEST_FAILED_S
local DAILY = DAILY
local QUEST_COMPLETE = QUEST_COMPLETE

local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F:GetModule('Announcement')

local debugMode = false
local completedQuest = {}
local initComplete

local created
local function CreateCheckBox()
    if created then
        return
    end
    local bu = CreateFrame('CheckButton', nil, _G.WorldMapFrame.BorderFrame, 'InterfaceOptionsCheckButtonTemplate')
    bu:SetPoint('TOPRIGHT', -270, -4)
    bu:SetSize(20, 20)
    bu:SetHitRectInsets(-5, -5, -5, -5)
    F.ReskinCheck(bu, true)
    bu.text = F.CreateFS(bu, C.Assets.Fonts.Regular, 11, nil, L['Announce progress'], 'YELLOW', true, 'LEFT', 22, 0)
    bu:SetChecked(C.DB.Announcement.Quest)
    bu:SetScript('OnClick', function(self)
        C.DB.Announcement.Quest = self:GetChecked()
        ANNOUNCEMENT:AnnounceQuest()
    end)
    bu.title = L['Announce progress']
    F.AddTooltip(bu, 'ANCHOR_TOPRIGHT', L['|nLet your teammates know the progress of quests.'], 'BLUE')

    created = true
end
_G.WorldMapFrame:HookScript('OnShow', CreateCheckBox)

local function GetQuestLinkOrName(questID)
    return GetQuestLink(questID) or C_QuestLog_GetTitleForQuestID(questID) or ''
end

local function acceptText(questID, daily)
    local title = GetQuestLinkOrName(questID)
    if daily then
        return format('%s [%s]%s', L['Quest accept:'], DAILY, title)
    else
        return format('%s %s', L['Quest accept:'], title)
    end
end

local function completeText(questID)
    return format('%s %s', GetQuestLinkOrName(questID), QUEST_COMPLETE)
end

local function sendQuestMsg(msg)
    if debugMode and C.IsDeveloper then
        F:Debug(msg)
    elseif IsPartyLFG() then
        SendChatMessage(msg, 'INSTANCE_CHAT')
    elseif IsInRaid() then
        SendChatMessage(msg, 'RAID')
    elseif IsInGroup() then
        SendChatMessage(msg, 'PARTY')
    end
end

local function getPattern(pattern)
    pattern = gsub(pattern, '%(', '%%%1')
    pattern = gsub(pattern, '%)', '%%%1')
    pattern = gsub(pattern, '%%%d?$?.', '(.+)')
    return format('^%s$', pattern)
end

local questMatches = {
    ['Found'] = getPattern(ERR_QUEST_ADD_FOUND_SII),
    ['Item'] = getPattern(ERR_QUEST_ADD_ITEM_SII),
    ['Kill'] = getPattern(ERR_QUEST_ADD_KILL_SII),
    ['PKill'] = getPattern(ERR_QUEST_ADD_PLAYER_KILL_SII),
    ['ObjectiveComplete'] = getPattern(ERR_QUEST_OBJECTIVE_COMPLETE_S),
    ['QuestComplete'] = getPattern(ERR_QUEST_COMPLETE_S),
    ['QuestFailed'] = getPattern(ERR_QUEST_FAILED_S),
}

function ANNOUNCEMENT:FindQuestProgress(_, msg)
    for _, pattern in pairs(questMatches) do
        if strmatch(msg, pattern) then
            local _, _, _, cur, max = strfind(msg, '(.*)[:：]%s*([-%d]+)%s*/%s*([-%d]+)%s*$')
            cur, max = tonumber(cur), tonumber(max)
            if cur and max and max >= 10 then
                if mod(cur, floor(max / 5)) == 0 then
                    sendQuestMsg(msg)
                end
            else
                sendQuestMsg(msg)
            end
            break
        end
    end
end

local WQcache = {}
function ANNOUNCEMENT:FindQuestAccept(questID)
    if not questID then
        return
    end
    if C_QuestLog_IsWorldQuest(questID) and WQcache[questID] then
        return
    end
    WQcache[questID] = true

    local tagInfo = C_QuestLog_GetQuestTagInfo(questID)
    if tagInfo and tagInfo.worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION then
        return
    end

    local questLogIndex = C_QuestLog_GetLogIndexForQuestID(questID)
    if questLogIndex then
        local info = C_QuestLog_GetInfo(questLogIndex)
        if info then
            sendQuestMsg(acceptText(questID, info.frequency == LE_QUEST_FREQUENCY_DAILY))
        end
    end
end

function ANNOUNCEMENT:FindQuestComplete()
    for i = 1, C_QuestLog_GetNumQuestLogEntries() do
        local questID = C_QuestLog_GetQuestIDForLogIndex(i)
        local isComplete = questID and C_QuestLog_IsComplete(questID)
        if isComplete and not completedQuest[questID] and not C_QuestLog_IsWorldQuest(questID) then
            if initComplete then
                sendQuestMsg(completeText(questID))
            end
            completedQuest[questID] = true
        end
    end
    initComplete = true
end

function ANNOUNCEMENT:FindWorldQuestComplete(questID)
    if C_QuestLog_IsWorldQuest(questID) then
        if questID and not completedQuest[questID] then
            sendQuestMsg(completeText(questID))
            completedQuest[questID] = true
        end
    end
end

function ANNOUNCEMENT:AnnounceQuest()
    if C.DB.Announcement.Quest then
        F:RegisterEvent('QUEST_ACCEPTED', ANNOUNCEMENT.FindQuestAccept)
        F:RegisterEvent('QUEST_LOG_UPDATE', ANNOUNCEMENT.FindQuestComplete)
        F:RegisterEvent('QUEST_TURNED_IN', ANNOUNCEMENT.FindWorldQuestComplete)
        F:RegisterEvent('UI_INFO_MESSAGE', ANNOUNCEMENT.FindQuestProgress)
    else
        wipe(completedQuest)
        F:UnregisterEvent('QUEST_ACCEPTED', ANNOUNCEMENT.FindQuestAccept)
        F:UnregisterEvent('QUEST_LOG_UPDATE', ANNOUNCEMENT.FindQuestComplete)
        F:UnregisterEvent('QUEST_TURNED_IN', ANNOUNCEMENT.FindWorldQuestComplete)
        F:UnregisterEvent('UI_INFO_MESSAGE', ANNOUNCEMENT.FindQuestProgress)
    end
end
