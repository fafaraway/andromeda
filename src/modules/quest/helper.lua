local F, C, L = unpack(select(2, ...))
local QH = F:RegisterModule('QuestHelper')
local LBG = F.Libs.LBG

local watchQuests = {
    -- check npc
    [60739] = true, -- https://www.wowhead.com/quest=60739/tough-crowd
    [62453] = true, -- https://www.wowhead.com/quest=62453/into-the-unknown
    -- glow
    [59585] = true, -- https://www.wowhead.com/quest=59585/well-make-an-aspirant-out-of-you
    [64271] = true, -- https://www.wowhead.com/quest=64271/a-more-civilized-way
}

local activeQuests = {}

local questNPCs = {
    [170080] = true, -- Boggart
    [174498] = true, -- Shimmersod
}

function QH:QuestTool_Init()
    for questID, value in pairs(watchQuests) do
        if C_QuestLog.GetLogIndexForQuestID(questID) then
            activeQuests[questID] = value
        end
    end
end

function QH:QuestTool_Accept(questID)
    if watchQuests[questID] then
        activeQuests[questID] = watchQuests[questID]
    end
end

function QH:QuestTool_Remove(questID)
    if watchQuests[questID] then
        activeQuests[questID] = nil
    end
end

local fixedStrings = { ['横扫'] = '低扫', ['突刺'] = '突袭' }
local function isActionMatch(msg, text)
    return text and strfind(msg, text)
end

function QH:QuestTool_SetGlow(msg)
    if GetOverrideBarSkin() and (activeQuests[59585] or activeQuests[64271]) then
        for i = 1, 3 do
            local button = _G['ActionButton' .. i]
            local _, spellID = GetActionInfo(button.action)
            local name = spellID and GetSpellInfo(spellID)
            if fixedStrings[name] and isActionMatch(msg, fixedStrings[name]) or isActionMatch(msg, name) then
                LBG.ShowOverlayGlow(button)
            else
                LBG.HideOverlayGlow(button)
            end
        end
        QH.isGlowing = true
    else
        QH:QuestTool_ClearGlow()
    end
end

function QH:QuestTool_ClearGlow()
    if QH.isGlowing then
        QH.isGlowing = nil
        for i = 1, 3 do
            LBG.HideOverlayGlow(_G['ActionButton' .. i])
        end
    end
end

function QH:QuestTool_SetQuestUnit()
    if not activeQuests[60739] and not activeQuests[62453] then
        return
    end

    local guid = UnitGUID('mouseover')
    local npcID = guid and F:GetNpcId(guid)
    if questNPCs[npcID] then
        self:AddLine(L['This is TRUE.'])
    end
end

function QH:OnLogin()
    local handler = CreateFrame('Frame', nil, _G.UIParent)
    QH.QuestHandler = handler

    local text = F.CreateFS(handler, C.Assets.Fonts.Bold, 20, nil, nil, nil, 'THICK')
    text:ClearAllPoints()
    text:SetPoint('TOP', _G.UIParent, 0, -200)
    text:SetWidth(800)
    text:SetWordWrap(true)
    text:Hide()
    QH.QuestTip = text

    -- Check existing quests
    QH:QuestTool_Init()
    F:RegisterEvent('QUEST_ACCEPTED', QH.QuestTool_Accept)
    F:RegisterEvent('QUEST_REMOVED', QH.QuestTool_Remove)

    -- Override button quests
    if C.DB.Actionbar.Enable then
        F:RegisterEvent('CHAT_MSG_MONSTER_SAY', QH.QuestTool_SetGlow)
        F:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', QH.QuestTool_ClearGlow)
    end

    -- Check npc in quests
    _G.TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, QH.QuestTool_SetQuestUnit)

    -- Auto gossip
    local firstStep
    F:RegisterEvent('GOSSIP_SHOW', function()
        local guid = UnitGUID('npc')
        local npcID = guid and F:GetNpcId(guid)
        if npcID == 174498 then
            C_GossipInfo.SelectOption(3)
        elseif npcID == 174371 then
            if GetItemCount(183961) == 0 then
                return
            end
            if C_GossipInfo.GetNumOptions() ~= 5 then
                return
            end
            if firstStep then
                C_GossipInfo.SelectOption(5)
            else
                C_GossipInfo.SelectOption(2)
                firstStep = true
            end
        end
    end)
end
