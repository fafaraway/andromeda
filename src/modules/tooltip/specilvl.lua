local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local isPending = _G.LFG_LIST_LOADING
local specPrefix = C.INFO_COLOR .. _G.SPECIALIZATION .. ':|r '
local levelPrefix = C.INFO_COLOR .. _G.STAT_AVERAGE_ITEM_LEVEL .. ':|r '

local resetTime, frequency = 900, 0.5
local cache, weapon, currentUNIT, currentGUID = {}, {}

TOOLTIP.tierSets = { -- t30
    -- HUNTER
    [200390] = true,
    [200392] = true,
    [200387] = true,
    [200389] = true,
    [200391] = true,
    -- WARRIOR
    [200426] = true,
    [200428] = true,
    [200423] = true,
    [200425] = true,
    [200427] = true,
    -- PALADIN
    [200417] = true,
    [200419] = true,
    [200414] = true,
    [200416] = true,
    [200418] = true,
    -- ROGUE
    [200372] = true,
    [200374] = true,
    [200369] = true,
    [200371] = true,
    [200373] = true,
    -- PRIEST
    [200327] = true,
    [200329] = true,
    [200324] = true,
    [200326] = true,
    [200328] = true,
    -- DK
    [200408] = true,
    [200410] = true,
    [200405] = true,
    [200407] = true,
    [200409] = true,
    -- SHAMAN
    [200399] = true,
    [200401] = true,
    [200396] = true,
    [200398] = true,
    [200400] = true,
    -- MAGE
    [200318] = true,
    [200320] = true,
    [200315] = true,
    [200317] = true,
    [200319] = true,
    -- WARLOCK
    [200336] = true,
    [200338] = true,
    [200333] = true,
    [200335] = true,
    [200337] = true,
    -- MONK
    [200363] = true,
    [200365] = true,
    [200360] = true,
    [200362] = true,
    [200364] = true,
    -- DRUID
    [200354] = true,
    [200356] = true,
    [200351] = true,
    [200353] = true,
    [200355] = true,
    -- DH
    [200345] = true,
    [200347] = true,
    [200342] = true,
    [200344] = true,
    [200346] = true,
    -- EVOKER
    [200381] = true,
    [200383] = true,
    [200378] = true,
    [200380] = true,
    [200382] = true,
}

local formatSets = {
    [1] = ' |cff14b200(1/4)', -- green
    [2] = ' |cff0091f2(2/4)', -- blue
    [3] = ' |cff0091f2(3/4)', -- blue
    [4] = ' |cffc745f9(4/4)', -- purple
    [5] = ' |cffc745f9(5/5)', -- purple
}

function TOOLTIP:InspectOnUpdate(elapsed)
    self.elapsed = (self.elapsed or frequency) + elapsed
    if self.elapsed > frequency then
        self.elapsed = 0
        self:Hide()
        ClearInspectPlayer()

        if currentUNIT and UnitGUID(currentUNIT) == currentGUID then
            F:RegisterEvent('INSPECT_READY', TOOLTIP.GetInspectInfo)
            NotifyInspect(currentUNIT)
        end
    end
end

local updater = CreateFrame('Frame')
updater:SetScript('OnUpdate', TOOLTIP.InspectOnUpdate)
updater:Hide()

local lastTime = 0
function TOOLTIP:GetInspectInfo(...)
    if self == 'UNIT_INVENTORY_CHANGED' then
        local thisTime = GetTime()
        if thisTime - lastTime > 0.1 then
            lastTime = thisTime

            local unit = ...
            if UnitGUID(unit) == currentGUID then
                TOOLTIP:InspectUnit(unit, true)
            end
        end
    elseif self == 'INSPECT_READY' then
        local guid = ...
        if guid == currentGUID then
            local spec = TOOLTIP:GetUnitSpec(currentUNIT)
            local level = TOOLTIP:GetUnitItemLevel(currentUNIT)
            cache[guid].spec = spec
            cache[guid].level = level
            cache[guid].getTime = GetTime()

            if spec and level then
                TOOLTIP:SetupSpecLevel(spec, level)
            else
                TOOLTIP:InspectUnit(currentUNIT, true)
            end
        end
        F:UnregisterEvent(self, TOOLTIP.GetInspectInfo)
    end
end
F:RegisterEvent('UNIT_INVENTORY_CHANGED', TOOLTIP.GetInspectInfo)

function TOOLTIP:SetupSpecLevel(spec, level)
    local _, unit = _G.GameTooltip:GetUnit()
    if not unit or UnitGUID(unit) ~= currentGUID then
        return
    end

    local specLine, levelLine
    for i = 2, _G.GameTooltip:NumLines() do
        local line = _G['GameTooltipTextLeft' .. i]
        local text = line:GetText()
        if text and strfind(text, specPrefix) then
            specLine = line
        elseif text and strfind(text, levelPrefix) then
            levelLine = line
        end
    end

    local r, g, b = F:UnitColor(unit)
    local hexColor = F:RgbToHex(r, g, b)

    spec = specPrefix .. (spec or isPending)
    if specLine then
        specLine:SetText(hexColor .. spec)
    else
        _G.GameTooltip:AddLine(hexColor .. spec)
    end

    level = levelPrefix .. (level or isPending)
    if levelLine then
        levelLine:SetText(level)
    else
        _G.GameTooltip:AddLine(level)
    end
end

function TOOLTIP:GetUnitItemLevel(unit)
    if not unit or UnitGUID(unit) ~= currentGUID then
        return
    end

    local class = select(2, UnitClass(unit))
    local ilvl
    local boa, total, haveWeapon, twohand, sets = 0, 0, 0, 0, 0
    local delay, mainhand, offhand, hasArtifact
    weapon[1], weapon[2] = 0, 0

    for i = 1, 17 do
        if i ~= 4 then
            local itemTexture = GetInventoryItemTexture(unit, i)

            if itemTexture then
                local itemLink = GetInventoryItemLink(unit, i)

                if not itemLink then
                    delay = true
                else
                    local _, _, quality, level, _, _, _, _, slot = GetItemInfo(itemLink)
                    if not quality or not level then
                        delay = true
                    else
                        if quality == Enum.ItemQuality.Heirloom then
                            boa = boa + 1
                        end

                        local itemID = GetItemInfoFromHyperlink(itemLink)
                        if TOOLTIP.tierSets[itemID] then
                            sets = sets + 1
                        end

                        if unit ~= 'player' then
                            level = F.GetItemLevel(itemLink) or level
                            if i < 16 then
                                total = total + level
                            elseif i > 15 and quality == Enum.ItemQuality.Artifact then
                                local relics = { select(4, strsplit(':', itemLink)) }
                                for i = 1, 3 do
                                    local relicID = relics[i] ~= '' and relics[i]
                                    local relicLink = select(2, GetItemGem(itemLink, i))
                                    if relicID and not relicLink then
                                        delay = true
                                        break
                                    end
                                end
                            end

                            if i == 16 then
                                if quality == Enum.ItemQuality.Artifact then
                                    hasArtifact = true
                                end

                                weapon[1] = level
                                haveWeapon = haveWeapon + 1
                                if slot == 'INVTYPE_2HWEAPON' or slot == 'INVTYPE_RANGED' or (slot == 'INVTYPE_RANGEDRIGHT' and class == 'HUNTER') then
                                    mainhand = true
                                    twohand = twohand + 1
                                end
                            elseif i == 17 then
                                weapon[2] = level
                                haveWeapon = haveWeapon + 1
                                if slot == 'INVTYPE_2HWEAPON' then
                                    offhand = true
                                    twohand = twohand + 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if not delay then
        if unit == 'player' then
            ilvl = select(2, GetAverageItemLevel())
        else
            if hasArtifact or twohand == 2 then
                local higher = max(weapon[1], weapon[2])
                total = total + higher * 2
            elseif twohand == 1 and haveWeapon == 1 then
                total = total + weapon[1] * 2 + weapon[2] * 2
            elseif twohand == 1 and haveWeapon == 2 then
                if mainhand and weapon[1] >= weapon[2] then
                    total = total + weapon[1] * 2
                elseif offhand and weapon[2] >= weapon[1] then
                    total = total + weapon[2] * 2
                else
                    total = total + weapon[1] + weapon[2]
                end
            else
                total = total + weapon[1] + weapon[2]
            end
            ilvl = total / 16
        end

        if ilvl > 0 then
            ilvl = format('%.1f', ilvl)
        end
        if boa > 0 then
            ilvl = ilvl .. ' |cff00ccff(' .. boa .. _G.HEIRLOOMS .. ')'
        end
        if sets > 0 then
            ilvl = ilvl .. formatSets[sets]
        end
    else
        ilvl = nil
    end

    return ilvl
end

function TOOLTIP:GetUnitSpec(unit)
    if not unit or UnitGUID(unit) ~= currentGUID then
        return
    end

    local specName
    if unit == 'player' then
        local specIndex = GetSpecialization()
        if specIndex then
            specName = select(2, GetSpecializationInfo(specIndex))
        end
    else
        local specID = GetInspectSpecialization(unit)
        if specID and specID > 0 then
            specName = select(2, GetSpecializationInfoByID(specID))
        end
    end

    if specName == '' then
        specName = _G.NONE
    end

    return specName
end

function TOOLTIP:InspectUnit(unit, forced)
    local spec, level

    if UnitIsUnit(unit, 'player') then
        spec = self:GetUnitSpec('player')
        level = self:GetUnitItemLevel('player')
        self:SetupSpecLevel(spec, level)
    else
        if not unit or UnitGUID(unit) ~= currentGUID then
            return
        end
        if not UnitIsPlayer(unit) then
            return
        end

        local currentDB = cache[currentGUID]
        spec = currentDB.spec
        level = currentDB.level
        self:SetupSpecLevel(spec, level)

        if not C.DB.Tooltip.SpecIlvlByAlt and IsAltKeyDown() then
            forced = true
        end

        if spec and level and not forced and (GetTime() - currentDB.getTime < resetTime) then
            updater.elapsed = frequency
            return
        end

        if not UnitIsVisible(unit) or UnitIsDeadOrGhost('player') or UnitOnTaxi('player') then
            return
        end

        if _G.InspectFrame and _G.InspectFrame:IsShown() then
            return
        end

        self:SetupSpecLevel()
        updater:Show()
    end
end

function TOOLTIP:InspectUnitSpecAndLevel(unit)
    if not C.DB.Tooltip.SpecIlvl then
        return
    end
    if C.DB.Tooltip.PlayerInfoByAlt and not IsAltKeyDown() then
        return
    end

    if not unit or not CanInspect(unit) then
        return
    end

    currentUNIT, currentGUID = unit, UnitGUID(unit)
    if not cache[currentGUID] then
        cache[currentGUID] = {}
    end

    TOOLTIP:InspectUnit(unit)
end
