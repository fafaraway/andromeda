-- Credit: aduth
-- https://github.com/aduth/Doom_CooldownPulse

local F, C, L = unpack(select(2, ...))
local CDP = F:RegisterModule('CooldownPulse')

local fadeInTime, fadeOutTime, maxAlpha = 0.3, 0.3, 1
local animScale, iconSize, holdTime, threshold = 2, 24, 0.3, 3
local elapsed, runtimer = 0, 0
local cooldowns, animating, watching = {}, {}, {}
local itemSpells, ignoredSpells = {}, {}

local FRAME
local TEXTURE

FRAME = CreateFrame('Frame', C.ADDON_TITLE .. 'CooldownPulseFrame', _G.UIParent, 'BackdropTemplate')
FRAME:SetSize(iconSize, iconSize)

TEXTURE = FRAME:CreateTexture(nil, 'ARTWORK')
TEXTURE:SetAllPoints()

local function tcount(tab)
    local n = 0
    for _ in pairs(tab) do
        n = n + 1
    end

    return n
end

local function memoize(f)
    local cache = nil

    local memoized = {}

    local function get()
        if cache == nil then
            cache = f()
        end

        return cache
    end

    memoized.resetCache = function()
        cache = nil
    end

    setmetatable(memoized, { __call = get })

    return memoized
end

local function getPetActionIndexByName(name)
    for i = 1, _G.NUM_PET_ACTION_SLOTS, 1 do
        if GetPetActionInfo(i) == name then
            return i
        end
    end

    return nil
end

local function trackItemSpell(itemID)
    local _, spellID = GetItemSpell(itemID)
    if spellID then
        itemSpells[spellID] = itemID
        return true
    else
        return false
    end
end

local function isAnimatingCooldownByName(name)
    for i, details in pairs(animating) do
        if details[3] == name then
            return true
        end
    end

    return false
end

local function onUpdate(_, update)
    elapsed = elapsed + update
    if elapsed > 0.05 then
        for i, v in pairs(watching) do
            if GetTime() >= v[1] + 0.5 then
                local getCooldownDetails
                if v[2] == 'spell' then
                    getCooldownDetails = memoize(function()
                        local start, duration, enabled = GetSpellCooldown(v[3])
                        return {
                            name = GetSpellInfo(v[3]),
                            texture = GetSpellTexture(v[3]),
                            start = start,
                            duration = duration,
                            enabled = enabled,
                        }
                    end)
                elseif v[2] == 'item' then
                    getCooldownDetails = memoize(function()
                        local start, duration, enabled = C_Container.GetItemCooldown(i)
                        return {
                            name = GetItemInfo(i),
                            texture = v[3],
                            start = start,
                            duration = duration,
                            enabled = enabled,
                        }
                    end)
                elseif v[2] == 'pet' then
                    getCooldownDetails = memoize(function()
                        local name, texture = GetPetActionInfo(v[3])
                        local start, duration, enabled = GetPetActionCooldown(v[3])
                        return {
                            name = name,
                            texture = texture,
                            isPet = true,
                            start = start,
                            duration = duration,
                            enabled = enabled,
                        }
                    end)
                end

                local cooldown = getCooldownDetails()
                if ignoredSpells[cooldown.name] then
                    watching[i] = nil
                else
                    if cooldown.enabled ~= 0 then
                        if cooldown.duration and cooldown.duration > threshold and cooldown.texture then
                            cooldowns[i] = getCooldownDetails
                        end
                    end

                    if not (cooldown.enabled == 0 and v[2] == 'spell') then
                        watching[i] = nil
                    end
                end
            end
        end

        for i, getCooldownDetails in pairs(cooldowns) do
            local cooldown = getCooldownDetails()
            if cooldown.start then
                local remaining = cooldown.duration - (GetTime() - cooldown.start)
                if remaining <= 0 then
                    if not isAnimatingCooldownByName(cooldown.name) then
                        tinsert(animating, {cooldown.texture,cooldown.isPet,cooldown.name})
                    end

                    cooldowns[i] = nil
                end
            else
                cooldowns[i] = nil
            end
        end

        elapsed = 0
        if #animating == 0 and tcount(watching) == 0 and tcount(cooldowns) == 0 then
            FRAME:SetScript('OnUpdate', nil)
            return
        end
    end

    if #animating > 0 then
        runtimer = runtimer + update
        if runtimer > (fadeInTime + holdTime + fadeOutTime) then
            tremove(animating, 1)
            runtimer = 0
            TEXTURE:SetTexture(nil)
            FRAME.bg:Hide()
        else
            if not TEXTURE:GetTexture() then
                TEXTURE:SetTexture(animating[1][1])
                TEXTURE:SetTexCoord(unpack(C.TEX_COORD))
            end

            local alpha = maxAlpha
            if runtimer < fadeInTime then
                alpha = maxAlpha * (runtimer / fadeInTime)
            elseif runtimer >= fadeInTime + holdTime then
                alpha = maxAlpha - (maxAlpha * ((runtimer - holdTime - fadeInTime) / fadeOutTime))
            end

            FRAME:SetAlpha(alpha)
            local scale = iconSize + (iconSize * ((animScale - 1) * (runtimer / (fadeInTime + holdTime + fadeOutTime))))
            FRAME:SetWidth(scale)
            FRAME:SetHeight(scale)
            FRAME.bg:Show()
        end
    end
end

function FRAME:ADDON_LOADED()
    for _, v in pairs(ignoredSpells) do
        ignoredSpells[v] = true
    end

    self:UnregisterEvent('ADDON_LOADED')
end

function FRAME:SPELL_UPDATE_COOLDOWN()
    for _, getCooldownDetails in pairs(cooldowns) do
        getCooldownDetails.resetCache()
    end
end

function FRAME:UNIT_SPELLCAST_SUCCEEDED(unit, _, spellID)
    if unit == 'player' then
        local itemID = itemSpells[spellID]
        if itemID then
            local texture = select(10, GetItemInfo(itemID))
            watching[itemID] = { GetTime(), 'item', texture }
            itemSpells[spellID] = nil
        else
            watching[spellID] = { GetTime(), 'spell', spellID }
        end

        if not self:IsMouseEnabled() then
            self:SetScript('OnUpdate', onUpdate)
        end
    end
end

function FRAME:COMBAT_LOG_EVENT_UNFILTERED()
    local _, eventType, _, _, _, sourceFlags, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
    local isPet = _G.bit.band(sourceFlags, _G.COMBATLOG_OBJECT_TYPE_PET) == _G.COMBATLOG_OBJECT_TYPE_PET
    local isMine = _G.bit.band(sourceFlags, _G.COMBATLOG_OBJECT_AFFILIATION_MINE) == _G.COMBATLOG_OBJECT_AFFILIATION_MINE

    if eventType == 'SPELL_CAST_SUCCESS' then
        if isPet and isMine then
            local name = GetSpellInfo(spellID)
            local index = getPetActionIndexByName(name)
            if index and not select(6, GetPetActionInfo(index)) then
                watching[spellID] = { GetTime(), 'pet', index }
            elseif not index and spellID then
                watching[spellID] = { GetTime(), 'spell', spellID }
            else
                return
            end

            if not self:IsMouseEnabled() then
                self:SetScript('OnUpdate', onUpdate)
            end
        end
    end
end

function FRAME:PLAYER_ENTERING_WORLD()
    local inInstance, instanceType = IsInInstance()
    if inInstance and instanceType == 'arena' then
        self:SetScript('OnUpdate', nil)
        wipe(cooldowns)
        wipe(watching)
    end
end

function FRAME:PLAYER_SPECIALIZATION_CHANGED(unit)
    if unit == 'player' then
        wipe(cooldowns)
        wipe(watching)
    end
end

function CDP:OnLogin()
    if not C.DB.Combat.CooldownPulse then
        return
    end

    FRAME.bg = F.SetBD(FRAME)
    FRAME.bg:Hide()

    local mover = F.Mover(FRAME, L['CooldownPulse'], 'CooldownPulse', { 'CENTER', _G.UIParent }, iconSize, iconSize)
    FRAME:ClearAllPoints()
    FRAME:SetPoint('CENTER', mover)

    FRAME:SetScript('OnEvent', function(self, event, ...)
        self[event](self, ...)
    end)
    FRAME:RegisterEvent('ADDON_LOADED')
    FRAME:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED')
    FRAME:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
    FRAME:RegisterEvent('SPELL_UPDATE_COOLDOWN')
    FRAME:RegisterEvent('PLAYER_ENTERING_WORLD')
    FRAME:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')

    hooksecurefunc('UseAction', function(slot)
        local actionType, itemID = GetActionInfo(slot)
        if actionType == 'item' and not trackItemSpell(itemID) then
            local texture = GetActionTexture(slot)
            watching[itemID] = { GetTime(), 'item', texture }
        end
    end)

    hooksecurefunc('UseInventoryItem', function(slot)
        local itemID = GetInventoryItemID('player', slot)
        if itemID and not trackItemSpell(itemID) then
            local texture = GetInventoryItemTexture('player', slot)
            watching[itemID] = { GetTime(), 'item', texture }
        end
    end)

    hooksecurefunc(C_Container, 'UseContainerItem', function(bag, slot)
        local itemID = C_Container.GetContainerItemID(bag, slot)
        if itemID and not trackItemSpell(itemID) then
            local texture = select(10, GetItemInfo(itemID))
            watching[itemID] = { GetTime(), 'item', texture }
        end
    end)
end

F:RegisterSlashCommand('/cdpulse', function()
    tinsert(animating, { GetSpellTexture(87214) })
    FRAME:SetScript('OnUpdate', onUpdate)
end)
