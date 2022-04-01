local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

UNITFRAME.CornerSpellsList = {}
function UNITFRAME:UpdateCornerSpells()
    table.wipe(UNITFRAME.CornerSpellsList)

    for spellID, value in pairs(C.CornerSpellsList[C.MyClass]) do
        local modData = _G.FREE_ADB['CornerSpellsList'][C.MyClass]
        if not (modData and modData[spellID]) then
            local r, g, b = unpack(value[2])
            UNITFRAME.CornerSpellsList[spellID] = {value[1], {r, g, b}, value[3]}
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['CornerSpellsList'][C.MyClass]) do
        if next(value) then
            local r, g, b = unpack(value[2])
            UNITFRAME.CornerSpellsList[spellID] = {value[1], {r, g, b}, value[3]}
        end
    end
end

UNITFRAME.BloodlustList = {}
for _, spellID in pairs(C.BloodlustList) do
    UNITFRAME.BloodlustList[spellID] = {'BOTTOMLEFT', {1, .8, 0}, true}
end

local found = {}
local auraFilter = {'HELPFUL', 'HARMFUL'}

function UNITFRAME:UpdateCornerIndicator(event, unit)
    if event == 'UNIT_AURA' and self.unit ~= unit then
        return
    end

    local spellList = UNITFRAME.CornerSpellsList
    local buttons = self.BuffIndicator
    unit = self.unit

    table.wipe(found)
    for _, filter in next, auraFilter do
        for i = 1, 32 do
            local name, _, _, _, duration, expiration, caster, _, _, spellID = UnitAura(unit, i, filter)
            if not name then
                break
            end
            local value = spellList[spellID] or (C.MyRole ~= 'Healer' and UNITFRAME.BloodlustList[spellID])
            if value and (value[3] or caster == 'player' or caster == 'pet') then
                local bu = buttons[value[1]]
                if bu then
                    if duration and duration > 0 then
                        bu.cd:SetCooldown(expiration - duration, duration)
                        bu.cd:Show()
                    else
                        bu.cd:Hide()
                    end

                    bu.icon:SetVertexColor(unpack(value[2]))

                    -- bu.count:SetText(count > 1 and count)
                    bu:Show()
                    found[bu.anchor] = true
                end
            end
        end
    end

    for _, bu in pairs(buttons) do
        if not found[bu.anchor] then
            bu:Hide()
        end
    end
end

function UNITFRAME:RefreshCornerIndicator(bu)
    bu:SetScript('OnUpdate', nil)
    bu.icon:SetTexture(C.Assets.Textures.Backdrop)
    bu.icon:Show()
    bu.cd:Show()
    bu.bg:Show()
end

function UNITFRAME:CreateCornerIndicator(self)
    if not C.DB.Unitframe.CornerIndicator then
        return
    end

    local parent = CreateFrame('Frame', nil, self.Health)
    parent:SetPoint('TOPLEFT', 4, -4)
    parent:SetPoint('BOTTOMRIGHT', -4, 4)

    local anchors = {'TOPLEFT', 'TOP', 'TOPRIGHT', 'LEFT', 'RIGHT', 'BOTTOMLEFT', 'BOTTOM', 'BOTTOMRIGHT'}
    local buttons = {}
    for _, anchor in pairs(anchors) do
        local bu = CreateFrame('Frame', nil, parent)
        bu:SetFrameLevel(self:GetFrameLevel() + 10)
        bu:SetSize(5, 5)
        bu:SetScale(C.DB.Unitframe.CornerIndicatorScale)
        bu:SetPoint(anchor)
        bu:Hide()

        bu.bg = F.CreateBDFrame(bu)
        bu.icon = bu:CreateTexture(nil, 'BORDER')
        bu.icon:SetInside(bu.bg)
        bu.icon:SetTexCoord(unpack(C.TexCoord))
        bu.cd = CreateFrame('Cooldown', nil, bu, 'CooldownFrameTemplate')
        bu.cd:SetAllPoints(bu.bg)
        bu.cd:SetReverse(true)
        bu.cd:SetHideCountdownNumbers(true)

        bu.anchor = anchor
        buttons[anchor] = bu

        UNITFRAME:RefreshCornerIndicator(bu)
    end

    self.BuffIndicator = buttons
    self:RegisterEvent('UNIT_AURA', UNITFRAME.UpdateCornerIndicator)
    self:RegisterEvent('GROUP_ROSTER_UPDATE', UNITFRAME.UpdateCornerIndicator, true)
end

function UNITFRAME:RefreshRaidFrameIcons()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'raid' then
            if frame.RaidDebuffs then
                frame.RaidDebuffs:SetScale(C.DB.Unitframe.RaidDebuffsScale)
            end
            if frame.BuffIndicator then
                for _, bu in pairs(frame.BuffIndicator) do
                    bu:SetScale(C.DB.Unitframe.CornerIndicatorScale)
                    UNITFRAME:RefreshCornerIndicator(bu)
                end
            end
        end
    end
end

function UNITFRAME:CheckCornerSpells()
    if not _G.FREE_ADB['CornerSpellsList'][C.MyClass] then
        _G.FREE_ADB['CornerSpellsList'][C.MyClass] = {}
    end
    local data = C.CornerSpellsList[C.MyClass]
    if not data then
        return
    end

    for spellID, _ in pairs(data) do
        local name = GetSpellInfo(spellID)
        if not name then
            if C.IsDeveloper then
                F:DebugPrint('Invalid Corner Spell ID: ' .. spellID)
            end
        end
    end

    for spellID, value in pairs(_G.FREE_ADB['CornerSpellsList'][C.MyClass]) do
        if not next(value) and C.CornerBuffs[C.MyClass][spellID] == nil then
            _G.FREE_ADB['CornerSpellsList'][C.MyClass][spellID] = nil
        end
    end
end
