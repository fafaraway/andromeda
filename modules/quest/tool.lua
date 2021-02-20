-- https://www.wowhead.com/quest=59585/well-make-an-aspirant-out-of-you

local _G = _G
local unpack = unpack
local select = select
local gsub = gsub
local GetOverrideBarSkin = GetOverrideBarSkin
local GetActionInfo = GetActionInfo
local GetSpellInfo = GetSpellInfo
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID

local F, C = unpack(select(2, ...))
local QUEST = F.QUEST

local hasFound
local function resetActionButtons()
    if not hasFound then
        return
    end
    for i = 1, 3 do
        F.HideOverlayGlow(_G['ActionButton' .. i])
    end
    hasFound = nil
end

local function OnEvent(_, msg)
    if not GetOverrideBarSkin() or not C_QuestLog_GetLogIndexForQuestID(59585) then
        resetActionButtons()
        return
    end

    msg = gsub(msg, '[。%.]', '')

    for i = 1, 3 do
        local button = _G['ActionButton' .. i]
        local _, spellID = GetActionInfo(button.action)
        local name = spellID and GetSpellInfo(spellID)
        if name and name == msg then
            F.ShowOverlayGlow(button)
        else
            F.HideOverlayGlow(button)
        end
    end

    hasFound = true
end

function QUEST:WorldQuestTool()
    if not C.DB.Actionbar.Enable then
        return
    end

    F:RegisterEvent('CHAT_MSG_MONSTER_SAY', OnEvent)
    F:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN', resetActionButtons)
end
