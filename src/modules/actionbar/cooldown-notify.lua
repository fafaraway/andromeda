local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local function SendNotifyMessage(msg)
    if IsPartyLFG() then
        SendChatMessage(msg, 'INSTANCE_CHAT')
    elseif IsInRaid() then
        SendChatMessage(msg, 'RAID')
    elseif IsInGroup() then
        SendChatMessage(msg, 'PARTY')
    end
end

local function GetRemainTime(second)
    if second > 60 then
        return format('%d:%.2d', second / 60, second % 60)
    else
        return format('%ds', second)
    end
end

local lastCDSend = 0
function ACTIONBAR:SendCurrentSpell(thisTime, spellID)
    local spellLink = GetSpellLink(spellID)
    local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellID)
    if charges and maxCharges then
        if charges ~= maxCharges then
            local remain = chargeStart + chargeDuration - thisTime
            SendChatMessage(format(L['%s %s/%s next charge remaining %s.'], spellLink, charges, maxCharges, GetRemainTime(remain)), 'PARTY')
        else
            SendChatMessage(format(L['%s %s/%s all charges ready.'], spellLink, charges, maxCharges), 'PARTY')
        end
    else
        local start, duration = GetSpellCooldown(spellID)
        if start and duration > 0 then
            local remain = start + duration - thisTime
            SendChatMessage(format(L['%s cooldown remaining %s.'], spellLink, GetRemainTime(remain)), 'PARTY')
        else
            SendChatMessage(format(L['%s is now available.'], spellLink), 'PARTY')
        end
    end
end

function ACTIONBAR:SendCurrentItem(thisTime, itemID, itemLink)
    local start, duration = GetItemCooldown(itemID)
    if start and duration > 0 then
        local remain = start + duration - thisTime
        SendNotifyMessage(format(L['%s cooldown remaining %s.'], itemLink, GetRemainTime(remain)))
    else
        SendNotifyMessage(format(L['%s is now available.'], itemLink))
    end
end

function ACTIONBAR:AnalyzeButtonCooldown()
    if not self._state_action then -- no action for pet actionbar
        return
    end
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

    local spellType, id = GetActionInfo(self._state_action)
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
