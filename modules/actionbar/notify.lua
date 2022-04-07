local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local debugMode = false

local function SendNotifyMessage(msg)
    if debugMode and C.DEV_MODE then
        F:Print(msg, true)
    elseif IsPartyLFG() then
        SendChatMessage(msg, 'INSTANCE_CHAT')
    elseif IsInRaid() then
        SendChatMessage(msg, 'RAID')
    elseif IsInGroup() then
        SendChatMessage(msg, 'PARTY')
    end
end

local function GetRemainTime(second)
    if second > 60 then
        return string.format('%d:%.2d', second / 60, second % 60)
    else
        return string.format('%ds', second)
    end
end

local lastCDSend = 0
function ACTIONBAR:SendCurrentSpell(thisTime, spellID)
    local start, duration = GetSpellCooldown(spellID)
    local spellLink = GetSpellLink(spellID)
    if start and duration > 0 then
        local remain = start + duration - thisTime
        SendNotifyMessage(string.format(L['%s cooldown remaining %s.'], spellLink, GetRemainTime(remain)))
    else
        SendNotifyMessage(string.format(L['%s is now available.'], spellLink))
    end
end

function ACTIONBAR:SendCurrentItem(thisTime, itemID, itemLink)
    local start, duration = GetItemCooldown(itemID)
    if start and duration > 0 then
        local remain = start + duration - thisTime
        SendNotifyMessage(string.format(L['%s cooldown remaining %s.'], itemLink, GetRemainTime(remain)))
    else
        SendNotifyMessage(string.format(L['%s is now available.'], itemLink))
    end
end

function ACTIONBAR:AnalyzeButtonCooldown()
    if not C.DB.Actionbar.CooldownNotify then
        return
    end
    if not IsInGroup() then
        return
    end

    local thisTime = GetTime()
    if thisTime - lastCDSend < 1.5 then
        return
    end
    lastCDSend = thisTime

    local spellType, id = GetActionInfo(self.action)
    if spellType == 'spell' then
        ACTIONBAR:SendCurrentSpell(thisTime, id)
    elseif spellType == 'item' then
        local itemName, itemLink = GetItemInfo(id)
        ACTIONBAR:SendCurrentItem(thisTime, id, itemLink or itemName)
    elseif spellType == 'macro' then
        local spellID = GetMacroSpell(id)
        local _, itemLink = GetMacroItem(id)
        local itemID = itemLink and GetItemInfoFromHyperlink(itemLink)
        if spellID then
            ACTIONBAR:SendCurrentSpell(thisTime, spellID)
        elseif itemID then
            ACTIONBAR:SendCurrentItem(thisTime, itemID, itemLink)
        end
    end
end

function ACTIONBAR:CooldownNotify()
    if not C.DB.Actionbar.Enable then
        return
    end

    for _, button in pairs(ACTIONBAR.buttons) do
        button:HookScript('OnMouseWheel', ACTIONBAR.AnalyzeButtonCooldown)
    end
end
