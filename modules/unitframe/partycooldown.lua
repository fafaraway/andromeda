local _G = _G
local unpack = unpack
local select = select
local wipe = wipe
local split = split
local format = format
local CreateFrame = CreateFrame
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local GetSpellCooldown = GetSpellCooldown
local IsPartyLFG = IsPartyLFG
local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local UnitGUID = UnitGUID
local C_ChatInfo_SendAddonMessage = C_ChatInfo.SendAddonMessage
local C_ChatInfo_RegisterAddonMessagePrefix = C_ChatInfo.RegisterAddonMessagePrefix

local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('Unitframe')

UNITFRAME.PartySpellsList = {}
function UNITFRAME:UpdatePartyWatcherSpells()
    wipe(UNITFRAME.PartySpellsList)

    for spellID, duration in pairs(C.PartySpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modDuration = _G.FREE_ADB['PartySpellsList'][spellID]
            if not modDuration or modDuration > 0 then
                UNITFRAME.PartySpellsList[spellID] = duration
            end
        end
    end

    for spellID, duration in pairs(_G.FREE_ADB['PartySpellsList']) do
        if duration > 0 then
            UNITFRAME.PartySpellsList[spellID] = duration
        end
    end
end

local watchingList = {}
function UNITFRAME:PartyWatcherPostUpdate(button, unit, spellID)
    local guid = UnitGUID(unit)
    if not watchingList[guid] then
        watchingList[guid] = {}
    end
    watchingList[guid][spellID] = button
end

function UNITFRAME:HandleCDMessage(...)
    local prefix, msg = ...
    if prefix ~= 'ZenTracker' then
        return
    end

    local _, msgType, guid, spellID, duration, remaining = split(':', msg)
    if msgType == 'U' then
        spellID = tonumber(spellID)
        duration = tonumber(duration)
        remaining = tonumber(remaining)
        local button = watchingList[guid] and watchingList[guid][spellID]
        if button then
            local start = GetTime() + remaining - duration
            if start > 0 and duration > 1.5 then
                button.CD:SetCooldown(start, duration)
            end
        end
    end
end

local lastUpdate = 0
function UNITFRAME:SendCDMessage()
    local thisTime = GetTime()
    if thisTime - lastUpdate >= 5 then
        local value = watchingList[UNITFRAME.myGUID]
        if value then
            for spellID in pairs(value) do
                local start, duration, enabled = GetSpellCooldown(spellID)
                if enabled ~= 0 and start ~= 0 then
                    local remaining = start + duration - thisTime
                    if remaining < 0 then
                        remaining = 0
                    end
                    C_ChatInfo_SendAddonMessage('ZenTracker', format('3:U:%s:%d:%.2f:%.2f:%s', UNITFRAME.myGUID, spellID, duration, remaining, '-'), IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY')
                    -- sync to others
                end
            end
        end
        lastUpdate = thisTime
    end
end

local lastSyncTime = 0
function UNITFRAME:UpdateSyncStatus()
    if IsInGroup() and not IsInRaid() and C.DB.Unitframe.PartyWatcherSync then
        local thisTime = GetTime()
        if thisTime - lastSyncTime > 5 then
            C_ChatInfo_SendAddonMessage('ZenTracker', format('3:H:%s:0::0:1', UNITFRAME.myGUID), IsPartyLFG() and 'INSTANCE_CHAT' or 'PARTY')
            -- handshake to ZenTracker
            lastSyncTime = thisTime
        end
        F:RegisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCDMessage)
    else
        F:UnregisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCDMessage)
    end
end

function UNITFRAME:SyncWithZenTracker()
    if not C.DB.Unitframe.PartyWatcherSync then
        return
    end

    UNITFRAME.myGUID = UnitGUID('player')
    C_ChatInfo_RegisterAddonMessagePrefix('ZenTracker')
    F:RegisterEvent('CHAT_MSG_ADDON', UNITFRAME.HandleCDMessage)

    UNITFRAME:UpdateSyncStatus()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', UNITFRAME.UpdateSyncStatus)
end

function UNITFRAME:CreatePartyWatcher(self)
    if not C.DB.Unitframe.PartyWatcher then
        return
    end

    local buttons = {}
    local maxIcons = 4
    local iconSize = (C.DB.Unitframe.PartyHealthHeight + C.DB.Unitframe.PartyPowerHeight + C.Mult) * .75
    local partyHorizon = C.DB.Unitframe.PartyHorizon

    for i = 1, maxIcons do
        local bu = CreateFrame('Frame', nil, self)
        bu:SetSize(iconSize, iconSize)
        F.AuraIcon(bu)
        bu.CD:SetReverse(false)
        if i == 1 then
            if partyHorizon then
                bu:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -3)
            else
                bu:SetPoint('RIGHT', self, 'LEFT', -3, 0)
            end
        else
            if partyHorizon then
                bu:SetPoint('LEFT', buttons[i - 1], 'RIGHT', 3, 0)
            else
                bu:SetPoint('RIGHT', buttons[i - 1], 'LEFT', -3, 0)
            end
        end
        bu:Hide()

        buttons[i] = bu
    end

    buttons.__max = maxIcons
    buttons.PartySpells = UNITFRAME.PartySpellsList
    buttons.TalentCDFix = C.TalentCDFixList
    self.PartyWatcher = buttons
    if C.DB.Unitframe.PartyWatcherSync then
        self.PartyWatcher.PostUpdate = UNITFRAME.PartyWatcherPostUpdate
    end
end

function UNITFRAME:CheckPartySpells()
    for spellID, duration in pairs(C.PartySpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modDuration = _G.FREE_ADB['PartySpellsList'][spellID]
            if modDuration and modDuration == duration then
                _G.FREE_ADB['PartySpellsList'][spellID] = nil
            end
        else
            if C.IsDeveloper then
                F:Debug('Invalid Party Spell ID: ' .. spellID)
            end
        end
    end
end
