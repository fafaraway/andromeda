local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')

local totemNpcIDs = {
    -- [npcID] = { spellID, duration }
    [2630] = { 2484, 20 }, -- Earthbind
    [60561] = { 51485, 20 }, -- Earthgrab
    [3527] = { 5394, 15 }, -- Healing Stream
    [6112] = { 8512, 120 }, -- Windfury
    [97369] = { 192222, 15 }, -- Liquid Magma
    [5913] = { 8143, 10 }, -- Tremor
    [5925] = { 204336, 3 }, -- Grounding
    [78001] = { 157153, 15 }, -- Cloudburst
    [53006] = { 98008, 6 }, -- Spirit Link
    [59764] = { 108280, 12 }, -- Healing Tide
    [61245] = { 192058, 2 }, -- Static Charge
    [100943] = { 198838, 15 }, -- Earthen Wall
    [97285] = { 192077, 15 }, -- Wind Rush
    [105451] = { 204331, 15 }, -- Counterstrike
    [104818] = { 207399, 30 }, -- Ancestral
    [105427] = { 204330, 15 }, -- Skyfury
    [179867] = { 355580, 6 }, -- Static Field
    [166523] = { 324386, 30 }, -- Vesper Totem (Kyrian)
    -- Warrior
    [119052] = { 236320, 15 }, -- War Banner
    --Priest
    [101398] = { 211522, 12 }, -- Psyfiend
}

local showDuration = true
local showCooldownCount = true
local showFriendlyTotems = true

local activeTotems = {}
local totemStartTimes = setmetatable({ __mode = 'v' }, {})

local function GetNpcIDByGuid(guid)
    local _, _, _, _, _, npcID = strsplit('-', guid)
    return tonumber(npcID)
end

local function CheckCombatLog()
    local _, eventType, _, _, _, _, _, dstGUID, _, _, _ = CombatLogGetCurrentEventInfo()

    if eventType == 'SPELL_SUMMON' then
        local npcID = GetNpcIDByGuid(dstGUID)
        if npcID and totemNpcIDs[npcID] then
            totemStartTimes[dstGUID] = GetTime()
        end
    end
end
F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', CheckCombatLog)

local function CreateTotemIcon(nameplate)
    local frame = CreateFrame('Frame', nil, nameplate)
    frame:SetSize(32, 32)
    frame:SetPoint('CENTER', nameplate)

    local icon = frame:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TEX_COORD))
    icon:SetAllPoints()

    F.SetBD(frame)

    local cd = CreateFrame('Cooldown', nil, frame, 'CooldownFrameTemplate')
    if not showCooldownCount then
        cd.noCooldownCount = true -- disable OmniCC for this cooldown
        cd:SetHideCountdownNumbers(true)
    end
    cd:SetReverse(true)
    cd:SetDrawEdge(false)
    cd:SetAllPoints(frame)

    frame.cooldown = cd
    frame.icon = icon

    return frame
end

function NAMEPLATE.UpdateTotemIcon(self, event, unit)
    if not C.DB.Nameplate.TotemIcon then
        return
    end

    local np = C_NamePlate.GetNamePlateForUnit(unit)
    local guid = UnitGUID(unit)
    local npcID = GetNpcIDByGuid(guid)

    if event == 'NAME_PLATE_UNIT_ADDED' then
        if npcID and totemNpcIDs[npcID] then
            if not showFriendlyTotems then
                local isFriendly = UnitReaction(unit, 'player') >= 4
                if isFriendly then
                    return
                end
            end

            if not np.totemIcon then
                np.totemIcon = CreateTotemIcon(np)
            end

            local iconFrame = np.totemIcon
            iconFrame:Show()

            local totemData = totemNpcIDs[npcID]
            local spellID, duration = unpack(totemData)

            local tex = GetSpellTexture(spellID)

            iconFrame.icon:SetTexture(tex)
            local startTime = totemStartTimes[guid]
            if startTime and showDuration then
                iconFrame.cooldown:SetCooldown(startTime, duration)
                iconFrame.cooldown:Show()
            end

            activeTotems[guid] = np

            if self.NameTag then
                self.NameTag:Hide()
            end
        else
            if self.NameTag then
                self.NameTag:Show()
            end
        end
    elseif event == 'NAME_PLATE_UNIT_REMOVED' then
        if np.totemIcon then
            np.totemIcon:Hide()

            activeTotems[guid] = nil
        end
    end
end
