local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

function UNITFRAME:SpellsIndicator_OnUpdate(elapsed)
    F.CooldownOnUpdate(self, elapsed, true)
end

UNITFRAME.CornerSpellsList = {}
function UNITFRAME:UpdateCornerSpellsList()
    wipe(UNITFRAME.CornerSpellsList)

    for spellID, value in pairs(C.CornerSpellsList[C.MY_CLASS]) do
        local modData = _G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS]
        if not (modData and modData[spellID]) then
            local r, g, b = unpack(value[2])
            UNITFRAME.CornerSpellsList[spellID] = { value[1], { r, g, b }, value[3] }
        end
    end

    for spellID, value in pairs(_G.ANDROMEDA_ADB['CornerSpellsList'][C.MY_CLASS]) do
        if next(value) then
            local r, g, b = unpack(value[2])
            UNITFRAME.CornerSpellsList[spellID] = { value[1], { r, g, b }, value[3] }
        end
    end
end

local anchors = {
    'TOPLEFT',
    'TOP',
    'TOPRIGHT',
    'LEFT',
    'RIGHT',
    'BOTTOMLEFT',
    'BOTTOM',
    'BOTTOMRIGHT',
}

function UNITFRAME:CreateSpellsIndicator(self)
    local spellSize = C.DB.Unitframe.CornerIndicatorSize or 6

    local buttons = {}
    for _, anchor in pairs(anchors) do
        local button = CreateFrame('Frame', nil, self.Health)
        button:SetFrameLevel(self:GetFrameLevel() + 10)
        button:SetSize(spellSize, spellSize)
        button:SetPoint(anchor)
        button:Hide()

        button.icon = button:CreateTexture(nil, 'BORDER')
        button.icon:SetAllPoints()
        button.bg = F.ReskinIcon(button.icon)

        button.cd = CreateFrame('Cooldown', nil, button, 'CooldownFrameTemplate')
        button.cd:SetAllPoints()
        button.cd:SetReverse(true)
        button.cd:SetHideCountdownNumbers(true)

        button.anchor = anchor
        buttons[anchor] = button

        UNITFRAME:RefreshBuffIndicator(button)
    end

    self.SpellsIndicator = buttons

    UNITFRAME.SpellsIndicator_UpdateOptions(self)
end

function UNITFRAME:SpellsIndicator_UpdateButton(button, aura, r, g, b)
    if aura.duration and aura.duration > 0 then
        button.cd:SetCooldown(aura.expiration - aura.duration, aura.duration)
        button.cd:Show()
    else
        button.cd:Hide()
    end

    button.icon:SetVertexColor(r, g, b)

    button:Show()
end

function UNITFRAME:SpellsIndicator_HideButtons()
    for _, button in pairs(self.SpellsIndicator) do
        button:Hide()
    end
end

function UNITFRAME:RefreshBuffIndicator(bu)
    bu:SetScript('OnUpdate', nil)

    bu.icon:SetTexture(C.Assets.Textures.Backdrop)
    bu.icon:Show()
    bu.cd:Show()
    bu.bg:Show()
end

function UNITFRAME:SpellsIndicator_UpdateOptions()
    local spells = self.SpellsIndicator
    if not spells then
        return
    end

    for anchor, button in pairs(spells) do
        button:SetScale(C.DB.Unitframe.CornerIndicatorScale)
        UNITFRAME:RefreshBuffIndicator(button)
    end
end
