local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local PlaySound = PlaySound
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestIDForLogIndex = C_QuestLog.GetQuestIDForLogIndex
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_IsComplete = C_QuestLog.IsComplete
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest
local SOUNDKIT_ALARM_CLOCK_WARNING_3 = SOUNDKIT.ALARM_CLOCK_WARNING_3

local F, C = unpack(select(2, ...))
local QUEST = F.QUEST

local completedQuest = {}
local initComplete

function QUEST:FindQuestComplete()
    for i = 1, C_QuestLog_GetNumQuestLogEntries() do
        local questID = C_QuestLog_GetQuestIDForLogIndex(i)
        local title = C_QuestLog_GetTitleForQuestID(questID)
        local isComplete = C_QuestLog_IsComplete(questID)
        local isWorldQuest = C_QuestLog_IsWorldQuest(questID)
        if title and isComplete and not completedQuest[questID] and not isWorldQuest then
            if initComplete then
                PlaySound(SOUNDKIT_ALARM_CLOCK_WARNING_3, 'Master')
            end
            completedQuest[questID] = true
        end
    end
    initComplete = true
end

function QUEST:FindWorldQuestComplete(questID)
    if C_QuestLog_IsWorldQuest(questID) then
        local title = C_QuestLog_GetTitleForQuestID(questID)
        if title and not completedQuest[questID] then
            PlaySound(SOUNDKIT_ALARM_CLOCK_WARNING_3, 'Master')
            completedQuest[questID] = true
        end
    end
end

function QUEST:CompleteSound()
    if C.DB.Quest.CompleteSound then
        F:RegisterEvent('QUEST_LOG_UPDATE', QUEST.FindQuestComplete)
        F:RegisterEvent('QUEST_TURNED_IN', QUEST.FindWorldQuestComplete)
    else
        wipe(completedQuest)
        F:UnregisterEvent('QUEST_LOG_UPDATE', QUEST.FindQuestComplete)
        F:UnregisterEvent('QUEST_TURNED_IN', QUEST.FindWorldQuestComplete)
    end
end

function QUEST:OnLogin()
    QUEST:CompleteSound()
end
