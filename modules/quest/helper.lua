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
    -- mousewheel
    [60657] = 333960, -- https://www.wowhead.com/quest=60657/aid-from-above
    [64018] = 356464, -- https://www.wowhead.com/quest=64018/the-weight-of-stone
    -- others
    [62459] = true -- https://www.wowhead.com/quest=62459/go-beyond -- questItem = 183725
}

local activeQuests = {}

local questNPCs = {
    [170080] = true, -- Boggart
    [174498] = true -- Shimmersod
}

function QH:GetOverrideIndex(spellID)
    if spellID == 356464 then
        return 1, 2
    elseif spellID == 356151 or spellID == 333960 then
        return 1
    end
end

local function GetActionSpell(index)
    local button = _G['ActionButton' .. index]
    local _, spellID = GetActionInfo(button.action)
    return spellID
end

local function GetOverrideButton(index)
    return 'OverrideActionBarButton' .. index
end

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

function QH:QuestTool_IsMatch(questID, spellID)
    return activeQuests[questID] == spellID
end

local messages = {
    [356464] = L['Mouse scroll up on blue circles, mousewheel down on red circles, try harder!'],
    [333960] = L['Mouse scroll up on blue circles, try harder!'],
    [356151] = L['Mouse scroll up when Wilderling speeds up!']
}

function QH:QuestTool_SetAction()
    local spellID = GetActionSpell(1)
    if QH:QuestTool_IsMatch(60657, spellID) or QH:QuestTool_IsMatch(64018, spellID) or spellID == 356151 then
        if InCombatLockdown() then
            F:RegisterEvent('PLAYER_REGEN_ENABLED', QH.QuestTool_SetAction)
            QH.isDelay = true
        else
            local index1, index2 = QH:GetOverrideIndex(spellID)
            if index1 then
                ClearOverrideBindings(QH.QuestHandler)
                SetOverrideBindingClick(QH.QuestHandler, true, 'MOUSEWHEELUP', GetOverrideButton(index1))
                if index2 then
                    SetOverrideBindingClick(QH.QuestHandler, true, 'MOUSEWHEELDOWN', GetOverrideButton(index2))
                end

                QH.QuestTip:SetText(C.AddonName .. ': ' .. messages[spellID])
                QH.QuestTip:Show()
                QH.isHandling = true

                if QH.isDelay then
                    F:UnregisterEvent('PLAYER_REGEN_ENABLED', QH.QuestTool_SetAction)
                    QH.isDelay = nil
                end
            end
        end
    end
end

function QH:QuestTool_ClearAction()
    if QH.isHandling then
        QH.isHandling = nil
        ClearOverrideBindings(QH.QuestHandler)
        QH.QuestTip:Hide()
    end
end

local fixedStrings = {
    ['横扫'] = '低扫',
    ['突刺'] = '突袭'
}
local function isActionMatch(msg, text)
    return text and string.find(msg, text)
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
    local npcID = guid and F.GetNPCID(guid)
    if questNPCs[npcID] then
        self:AddLine(L['This is |cffff0000T|cffff7f00R|cffffff00U|cff00ff00E.'])
    end
end

function QH:QuestTool_UpdateBinding()
    if activeQuests[62459] and not IsResting() and C_QuestLog.GetDistanceSqToQuest(62459) < 35000 then
        SetBinding('MOUSEWHEELUP', 'EXTRAACTIONBUTTON1')
        QH.isBinding = true
        QH.QuestTip:SetText(C.ColoredAddonName .. ': ' .. L['Get close to butterflies and mouse scroll up.'])
        QH.QuestTip:Show()
    elseif QH.isBinding then
        SetBinding('MOUSEWHEELUP', QH.SavedKey)
        QH.isBinding = nil
        QH.QuestTip:Hide()
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

    -- Vehicle button quests
    C_Timer.After(10, QH.QuestTool_SetAction) -- may need this for ui reload
    F:RegisterEvent('UNIT_ENTERED_VEHICLE', QH.QuestTool_SetAction)
    F:RegisterEvent('UNIT_EXITED_VEHICLE', QH.QuestTool_ClearAction)

    -- Override button quests
    if C.DB.Actionbar.Enable then
        F:RegisterEvent('CHAT_MSG_MONSTER_SAY', QH.QuestTool_SetGlow)
        F:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', QH.QuestTool_ClearGlow)
    end

    -- Check npc in quests
    _G.GameTooltip:HookScript('OnTooltipSetUnit', QH.QuestTool_SetQuestUnit)

    -- Quest items
    QH.SavedKey = GetBindingFromClick('MOUSEWHEELUP')
    QH:QuestTool_UpdateBinding()
    F:RegisterEvent('ZONE_CHANGED', QH.QuestTool_UpdateBinding)
    F:RegisterEvent('ZONE_CHANGED_INDOORS', QH.QuestTool_UpdateBinding)

    -- Auto gossip
    local firstStep
    F:RegisterEvent(
        'GOSSIP_SHOW',
        function()
            local guid = UnitGUID('npc')
            local npcID = guid and F.GetNPCID(guid)
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
        end
    )
end
