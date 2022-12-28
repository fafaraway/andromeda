local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')
local oUF = F.Libs.oUF

local invalidPrio = -1

function UNITFRAME:CreateRaidAuras(self)
    -- Indicators
    UNITFRAME:CreateAurasIndicator(self)
    UNITFRAME:CreateSpellsIndicator(self)
    UNITFRAME:CreateBuffsIndicator(self)
    UNITFRAME:CreateDebuffsIndicator(self)

    -- RaidAuras Util
    local frame = CreateFrame('Frame', nil, self)
    frame:SetSize(1, 1)
    frame:SetPoint('CENTER')

    self.RaidAuras = frame
    self.RaidAuras.PostUpdate = UNITFRAME.RaidAurasPostUpdate
end

function UNITFRAME.RaidAurasPostUpdate(element, unit)
    local self = element.__owner
    local auras = self.AurasIndicator
    local spells = self.SpellsIndicator
    local debuffs = self.DebuffsIndicator
    local buffs = self.BuffsIndicator

    local enableSpells = C.DB.Unitframe.CornerIndicator
    local auraIndex, debuffIndex, buffIndex = 0, 0, 0
    local numBuffs = element.buffList.num
    local numDebuffs = element.debuffList.num

    element.isInCombat = UnitAffectingCombat('player')

    if C.DB.Unitframe.DispellType ~= 3 or C.DB.Unitframe.InstanceAuras then
        UNITFRAME.AurasIndicator_UpdatePriority(self, numDebuffs, unit)
        UNITFRAME.AurasIndicator_HideButtons(self)

        for i = 1, numDebuffs do
            local button = auras.buttons[i]
            if not button then
                break
            end

            local aura = element.debuffList[i]
            if aura.priority > invalidPrio then
                auraIndex = auraIndex + 1
                UNITFRAME:AurasIndicator_UpdateButton(button, aura)
            end
        end
    end

    UNITFRAME.SpellsIndicator_HideButtons(self)

    for i = auraIndex + 1, numDebuffs do
        local aura = element.debuffList[i]
        local value = enableSpells and UNITFRAME.CornerSpellsList[aura.spellID]
        if value and (value[3] or aura.isPlayerAura) then
            local button = spells[value[1]]
            if button then
                UNITFRAME:SpellsIndicator_UpdateButton(button, aura, value[2][1], value[2][2], value[2][3])
            end
        elseif debuffs.enable and debuffIndex < 4 and UNITFRAME.DebuffsIndicator_Filter(element, aura) then
            debuffIndex = debuffIndex + 1
            UNITFRAME.DebuffsIndicator_UpdateButton(self, debuffIndex, aura)
        end
    end

    UNITFRAME.DebuffsIndicator_HideButtons(self, debuffIndex + 1, 3)

    for i = 1, numBuffs do
        local aura = element.buffList[i]
        local value = enableSpells and UNITFRAME.CornerSpellsList[aura.spellID]
        if value and (value[3] or aura.isPlayerAura) then
            local button = spells[value[1]]
            if button then
                UNITFRAME:SpellsIndicator_UpdateButton(button, aura, value[2][1], value[2][2], value[2][3])
            end
        elseif buffs.enable and buffIndex < 4 and UNITFRAME.BuffsIndicator_Filter(element, aura) then
            buffIndex = buffIndex + 1
            UNITFRAME.BuffsIndicator_UpdateButton(self, buffIndex, aura)
        end
    end

    UNITFRAME.BuffsIndicator_HideButtons(self, buffIndex + 1, 3)
end

function UNITFRAME:RaidAuras_UpdateOptions()
    for _, frame in pairs(oUF.objects) do
        if frame.unitStyle == 'party' or frame.unitStyle == 'raid' then
            UNITFRAME.AurasIndicator_UpdateOptions(frame)
            UNITFRAME.SpellsIndicator_UpdateOptions(frame)
            UNITFRAME.DebuffsIndicator_UpdateOptions(frame)
            UNITFRAME.BuffsIndicator_UpdateOptions(frame)
        end
    end
end
