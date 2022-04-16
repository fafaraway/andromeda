local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F:GetModule('Announcement')

local debugMode = false
local completedQuest = {}
local initComplete

local function GetQuestLinkOrName(questID)
    return GetQuestLink(questID) or C_QuestLog.GetTitleForQuestID(questID) or ''
end

local function acceptText(questID, daily)
    local title = GetQuestLinkOrName(questID)
    if daily then
        return string.format('%s [%s]%s', L['Quest accept:'], _G.DAILY, title)
    else
        return string.format('%s %s', L['Quest accept:'], title)
    end
end

local function completeText(questID)
    return string.format('%s %s', GetQuestLinkOrName(questID), _G.QUEST_COMPLETE)
end

local function sendQuestMsg(msg)
    if debugMode and C.DEV_MODE then
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
    pattern = string.gsub(pattern, '%(', '%%%1')
    pattern = string.gsub(pattern, '%)', '%%%1')
    pattern = string.gsub(pattern, '%%%d?$?.', '(.+)')
    return string.format('^%s$', pattern)
end

local questMatches = {
    ['Found'] = getPattern(_G.ERR_QUEST_ADD_FOUND_SII),
    ['Item'] = getPattern(_G.ERR_QUEST_ADD_ITEM_SII),
    ['Kill'] = getPattern(_G.ERR_QUEST_ADD_KILL_SII),
    ['PKill'] = getPattern(_G.ERR_QUEST_ADD_PLAYER_KILL_SII),
    ['ObjectiveComplete'] = getPattern(_G.ERR_QUEST_OBJECTIVE_COMPLETE_S),
    ['QuestComplete'] = getPattern(_G.ERR_QUEST_COMPLETE_S),
    ['QuestFailed'] = getPattern(_G.ERR_QUEST_FAILED_S),
}

function ANNOUNCEMENT:FindQuestProgress(_, msg)
    for _, pattern in pairs(questMatches) do
        if string.match(msg, pattern) then
            local _, _, _, cur, max = string.find(msg, '(.*)[:：]%s*([-%d]+)%s*/%s*([-%d]+)%s*$')
            cur, max = tonumber(cur), tonumber(max)
            if cur and max and max >= 10 then
                if math.fmod(cur, math.floor(max / 5)) == 0 then
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
    if C_QuestLog.IsWorldQuest(questID) and WQcache[questID] then
        return
    end
    WQcache[questID] = true

    local tagInfo = C_QuestLog.GetQuestTagInfo(questID)
    if tagInfo and tagInfo.worldQuestType == _G.LE_QUEST_TAG_TYPE_PROFESSION then
        return
    end

    local questLogIndex = C_QuestLog.GetLogIndexForQuestID(questID)
    if questLogIndex then
        local info = C_QuestLog.GetInfo(questLogIndex)
        if info then
            sendQuestMsg(acceptText(questID, info.frequency == _G.LE_QUEST_FREQUENCY_DAILY))
        end
    end
end

function ANNOUNCEMENT:FindQuestComplete()
    for i = 1, C_QuestLog.GetNumQuestLogEntries() do
        local questID = C_QuestLog.GetQuestIDForLogIndex(i)
        local isComplete = questID and C_QuestLog.IsComplete(questID)
        if isComplete and not completedQuest[questID] and not C_QuestLog.IsWorldQuest(questID) then
            if initComplete then
                sendQuestMsg(completeText(questID))
            end
            completedQuest[questID] = true
        end
    end
    initComplete = true
end

function ANNOUNCEMENT:FindWorldQuestComplete(questID)
    if C_QuestLog.IsWorldQuest(questID) then
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
        table.wipe(completedQuest)
        F:UnregisterEvent('QUEST_ACCEPTED', ANNOUNCEMENT.FindQuestAccept)
        F:UnregisterEvent('QUEST_LOG_UPDATE', ANNOUNCEMENT.FindQuestComplete)
        F:UnregisterEvent('QUEST_TURNED_IN', ANNOUNCEMENT.FindWorldQuestComplete)
        F:UnregisterEvent('UI_INFO_MESSAGE', ANNOUNCEMENT.FindQuestProgress)
    end
end
