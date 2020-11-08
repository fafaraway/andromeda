local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


local GetNumQuestLeaderBoards = GetNumQuestLeaderBoards
local GetQuestLink = GetQuestLink
local GetQuestLogLeaderBoard = GetQuestLogLeaderBoard

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo

local lastList


local function GetQuestsList()
	local quests = {}

	for questIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
		local questInfo = C_QuestLog_GetInfo(questIndex)
		local skip = questInfo.isHeader or questInfo.isBounty or questInfo.isHidden
		-- isHeader: 任务分类(比如, '高嶺-高嶺部族' 任务, '高嶺'要排除掉)
		-- isBounty: 箱子任务(比如, '夜落精灵' 任务)
		-- isHidden: 自动接取的每周任务(比如, '征服者的獎勵' 每周 PvP 任务)

		if not skip then
			local tagInfo = C_QuestLog_GetQuestTagInfo(questInfo.questID)

			-- 基础任务信息, 用于后续生成句子使用
			quests[questInfo.questID] = {
				title = questInfo.title,
				questID = questInfo.questID,
				level = questInfo.level,
				suggestedGroup = questInfo.suggestedGroup,
				isComplete = questInfo.isComplete,
				frequency = questInfo.frequency,
				tag = tagInfo and tagInfo.tagName,
				worldQuestType = tagInfo and tagInfo.worldQuestType,
				link = GetQuestLink(questInfo.questID)
			}

			-- 任务进度 (比如 1/2 杀死熊怪)
			for queryIndex = 1, GetNumQuestLeaderBoards(questIndex) do
				local queryText = GetQuestLogLeaderBoard(queryIndex, questIndex)
				local _, _, numItems, numNeeded, itemName = strfind(queryText, '(%d+)/(%d+) ?(.*)')
				quests[questInfo.questID][queryIndex] = {
					item = itemName,
					numItems = numItems,
					numNeeded = numNeeded
				}
			end
		end
	end

	return quests
end


function ANNOUNCEMENT:QuestLogUpdate()
	local currentList = GetQuestsList()

	if not lastList then
		lastList = currentList
		return
	end

	for questID, questCache in pairs(currentList) do
		local mainInfo = ''
		local extraInfo = ''
		local mainInfoColored = ''
		local extraInfoColored = ''
		local needAnnounce = false
		local isDetailInfo = false

		if questCache.frequency == 1 then -- 每日
			extraInfo = extraInfo .. '[' .. _G.DAILY .. ']'
			extraInfoColored = extraInfoColored .. F.CreateColorString('[' .. _G.DAILY .. ']', {r = 105/255, g = 178/255, b = 226/255})
		elseif questCache.frequency == 2 then -- 每周
			extraInfo = extraInfo .. '[' .. _G.WEEKLY .. ']'
			extraInfoColored = extraInfoColored .. F.CreateColorString('[' .. _G.WEEKLY .. ']', {r = 226/255, g = 105/255, b = 61/255})
		end

		if questCache.suggestedGroup > 1 then -- 多人
			extraInfo = extraInfo .. '[' .. questCache.suggestedGroup .. ']'
			extraInfoColored =
				extraInfoColored .. F.CreateColorString('[' .. questCache.suggestedGroup .. ']', {r = 208/255, g = 38/255, b = 50/255})
		end

		if questCache.level then -- 等级
			if questCache.level ~= C.MaxLevel then
				extraInfo = extraInfo .. '[' .. questCache.level .. ']'
				extraInfoColored = extraInfoColored .. F.CreateColorString('[' .. questCache.level .. ']', {r = 206/255, g = 175/255, b = 82/255})
			end
		end

		if questCache.tag then -- 任务分类
			extraInfo = extraInfo .. '[' .. questCache.tag .. ']'
			extraInfoColored = extraInfoColored .. F.CreateColorString('[' .. questCache.tag .. ']', {r = 1, g = 1, b = 1})
		end

		local questCacheOld = lastList[questID]

		if questCacheOld then
			if not questCacheOld.isComplete then -- 之前未完成
				if questCache.isComplete then
					mainInfo = questCache.title .. ' ' .. F.CreateColorString(L['ANNOUNCEMENT_QUEST_COMPLETED'], {r = 0.5, g = 1, b = 0.5})
					mainInfoColored = questCache.link .. ' ' .. F.CreateColorString(L['ANNOUNCEMENT_QUEST_COMPLETED'], {r = 0.5, g = 1, b = 0.5})
					needAnnounce = true
				elseif #questCacheOld > 0 and #questCache > 0 then -- 循环记录的任务完成条件
					for queryIndex = 1, #questCache do
						if
							questCache[queryIndex] and questCacheOld[queryIndex] and questCache[queryIndex].numItems and
								questCacheOld[queryIndex].numItems and
								questCache[queryIndex].numItems > questCacheOld[queryIndex].numItems
						 then -- 任务有了新的进展
							local progressColor = {
								r = 1 - 0.5 * questCache[queryIndex].numItems / questCache[queryIndex].numNeeded,
								g = 0.5 + 0.5 * questCache[queryIndex].numItems / questCache[queryIndex].numNeeded,
								b = 0.5
							}

							local subGoalIsCompleted = questCache[queryIndex].numItems == questCache[queryIndex].numNeeded

							if subGoalIsCompleted then
								local progressInfo = questCache[queryIndex].numItems .. '/' .. questCache[queryIndex].numNeeded
								local progressInfoColored = progressInfo
								if subGoalIsCompleted then
									local redayCheckIcon = '|TInterface/RaidFrame/ReadyCheck-Ready:15:15:-1:2:64:64:6:60:8:60|t'
									progressInfoColored = progressInfoColored .. redayCheckIcon
								else
									isDetailInfo = true
								end

								mainInfo = questCache.link .. ' ' .. questCache[queryIndex].item .. ' '
								mainInfoColored = questCache.link .. ' ' .. questCache[queryIndex].item .. ' '

								mainInfo = mainInfo .. progressInfo
								mainInfoColored = mainInfoColored .. F.CreateColorString(progressInfoColored, progressColor)
								needAnnounce = true
							end
						end
					end
				end
			end
		else -- 新的任务
			if not questCache.worldQuestType then -- 屏蔽世界任务的接收, 路过不报告
				mainInfo = questCache.link .. ' ' .. L['ANNOUNCEMENT_QUEST_ACCEPTED']
				mainInfoColored = questCache.link .. ' ' .. F.CreateColorString(L['ANNOUNCEMENT_QUEST_ACCEPTED'], {r = 1.000, g = 0.980, b = 0.396})
				needAnnounce = true
			end
		end

		if needAnnounce then
			local message = extraInfo .. mainInfo
			ANNOUNCEMENT:SendMessage(message, ANNOUNCEMENT:GetChannel())

			if not isDetailInfo then -- 具体进度系统会提示
				local messageColored = extraInfoColored .. mainInfoColored
				_G.UIErrorsFrame:AddMessage(messageColored)
			end
		end
	end

	lastList = currentList
end

function ANNOUNCEMENT:UpdateQuestAnnounce()
	if C.DB.announcement.quest then
		F:RegisterEvent('QUEST_LOG_UPDATE', ANNOUNCEMENT.QuestLogUpdate)
	else
		F:UnregisterEvent('QUEST_LOG_UPDATE', ANNOUNCEMENT.QuestLogUpdate)
	end
end
