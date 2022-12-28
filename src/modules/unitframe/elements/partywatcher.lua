local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

UNITFRAME.PartySpellsList = {}
function UNITFRAME:UpdatePartyWatcherSpells()
    wipe(UNITFRAME.PartySpellsList)

    for spellID, duration in pairs(C.PartySpellsList) do
        local name = GetSpellInfo(spellID)
        if name then
            local modDuration = _G.ANDROMEDA_ADB['PartySpellsList'][spellID]

            if not modDuration or modDuration > 0 then
                UNITFRAME.PartySpellsList[spellID] = duration
            end
        end
    end

    for spellID, duration in pairs(_G.ANDROMEDA_ADB['PartySpellsList']) do
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

function UNITFRAME:HandleCooldownMsg(...)
    local prefix, msg = ...
    if prefix ~= 'ZenTracker' then
        return
    end

    local _, msgType, guid, spellID, duration, remaining = strsplit(':', msg)
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

local function sendSyncMsg(text)
    if IsInRaid() or not IsInGroup() then
        return
    end

    if not IsInGroup(_G.LE_PARTY_CATEGORY_HOME) and IsInGroup(_G.LE_PARTY_CATEGORY_INSTANCE) then
        C_ChatInfo.SendAddonMessage('ZenTracker', text, 'INSTANCE_CHAT')
    else
        C_ChatInfo.SendAddonMessage('ZenTracker', text, 'PARTY')
    end
end

local lastUpdate = 0
function UNITFRAME:SendCooldownMsg()
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

                    sendSyncMsg(
                        format('3:U:%s:%d:%.2f:%.2f:%s', UNITFRAME.myGUID, spellID, duration, remaining, '-')
                    ) -- sync to others
                end
            end
        end

        lastUpdate = thisTime
    end
end

local lastSyncTime = 0
function UNITFRAME:UpdateSyncStatus()
    if IsInGroup() and not IsInRaid() and C.DB.Unitframe.PartyFrame then
        local thisTime = GetTime()
        if thisTime - lastSyncTime > 5 then
            sendSyncMsg(format('3:H:%s:0::0:1', UNITFRAME.myGUID)) -- handshake to ZenTracker
            lastSyncTime = thisTime
        end
        F:RegisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCooldownMsg)
    else
        F:UnregisterEvent('SPELL_UPDATE_COOLDOWN', UNITFRAME.SendCooldownMsg)
    end
end

function UNITFRAME:SyncWithZenTracker()
    if not C.DB.Unitframe.PartyWatcherSync then
        return
    end

    UNITFRAME.myGUID = UnitGUID('player')
    C_ChatInfo.RegisterAddonMessagePrefix('ZenTracker')
    F:RegisterEvent('CHAT_MSG_ADDON', UNITFRAME.HandleCooldownMsg)

    UNITFRAME:UpdateSyncStatus()
    F:RegisterEvent('GROUP_ROSTER_UPDATE', UNITFRAME.UpdateSyncStatus)
end

local function UpdateWatcherAnchor(element)
    local self = element.__owner
    local horizon = C.DB.Unitframe.PartyDirec > 2
    local otherSide = C.DB.Unitframe.PartyWatcherOnRight
    local relF = horizon and 'BOTTOMLEFT' or 'RIGHT'
    local relT = horizon and 'TOPLEFT' or 'LEFT'
    local xOffset = horizon and 0 or -5
    local yOffset = horizon and 5 or 0
    local margin = horizon and 3 or -3
    if otherSide then
        relF = horizon and 'TOPLEFT' or 'LEFT'
        relT = horizon and 'BOTTOMLEFT' or 'RIGHT'
        xOffset = horizon and 0 or 5
        yOffset = horizon and -5 or 0
        margin = 3
    end
    local rel1 = not horizon and not otherSide and 'RIGHT' or 'LEFT'
    local rel2 = not horizon and not otherSide and 'LEFT' or 'RIGHT'
    local iconSize = C.DB.Unitframe.PartyAuraSize

    for i = 1, element.__max do
        local bu = element[i]
        bu:SetSize(iconSize, iconSize)
        bu:ClearAllPoints()
        if i == 1 then
            bu:SetPoint(relF, self, relT, xOffset, yOffset)
        elseif i == 4 and horizon then
            bu:SetPoint(relF, element[i - 3], relT, 0, otherSide and -margin or margin)
        else
            bu:SetPoint(rel1, element[i - 1], rel2, margin, 0)
        end
    end
end

function UNITFRAME:CreatePartyWatcher(self)
    if not C.DB.Unitframe.PartyWatcher then
        return
    end

    local buttons = {}
    local maxIcons = 6

    for i = 1, maxIcons do
        local bu = CreateFrame('Frame', C.ADDON_TITLE .. 'PartyWatcherButton' .. i, self)
        bu.CD = CreateFrame('Cooldown', C.ADDON_TITLE .. 'PartyWatcherButtonCooldown' .. i, bu, 'CooldownFrameTemplate')
        bu.CD:SetInside()
        bu.CD:SetReverse(false)
        F.PixelIcon(bu)
        F.CreateSD(bu)
        bu:Hide()

        buttons[i] = bu
    end

    buttons.__owner = self
    buttons.__max = maxIcons

    UpdateWatcherAnchor(buttons)
    buttons.UpdateAnchor = UpdateWatcherAnchor
    buttons.PartySpells = UNITFRAME.PartySpellsList
    buttons.TalentCDFix = C.TalentCDFixList

    self.PartyWatcher = buttons
    if C.DB.Unitframe.PartyWatcherSync then
        self.PartyWatcher.PostUpdate = UNITFRAME.PartyWatcherPostUpdate
    end
end


