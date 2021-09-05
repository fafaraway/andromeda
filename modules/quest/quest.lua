local F, C = unpack(select(2, ...))
local QUEST = F:RegisterModule('Quest')

local completedQuest = {}
local initComplete

function QUEST:CheckNormalQuest()
    for i = 1, C_QuestLog.GetNumQuestLogEntries() do
        local questID = C_QuestLog.GetQuestIDForLogIndex(i)
        local title = C_QuestLog.GetTitleForQuestID(questID)
        local isComplete = C_QuestLog.IsComplete(questID)
        local isWorldQuest = C_QuestLog.IsWorldQuest(questID)
        if title and isComplete and not completedQuest[questID] and not isWorldQuest then
            if initComplete then
                PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, 'Master')
            end
            completedQuest[questID] = true
        end
    end
    initComplete = true
end

function QUEST:CheckWorldQuest(questID)
    if C_QuestLog.IsWorldQuest(questID) then
        local title = C_QuestLog.GetTitleForQuestID(questID)
        if title and not completedQuest[questID] then
            PlaySound(SOUNDKIT.ALARM_CLOCK_WARNING_3, 'Master')
            completedQuest[questID] = true
        end
    end
end

function QUEST:OnLogin()
    if C.DB.Quest.CompletedSound then
        F:RegisterEvent('QUEST_LOG_UPDATE', QUEST.CheckNormalQuest)
        F:RegisterEvent('QUEST_TURNED_IN', QUEST.CheckWorldQuest)
    else
        table.wipe(completedQuest)
        F:UnregisterEvent('QUEST_LOG_UPDATE', QUEST.CheckNormalQuest)
        F:UnregisterEvent('QUEST_TURNED_IN', QUEST.CheckWorldQuest)
    end
end
