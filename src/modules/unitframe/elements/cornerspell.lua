local F, C = unpack(select(2, ...))
local UNITFRAME = F:GetModule('UnitFrame')

local counterOffsets = {
    ['TOPLEFT'] = { { 6, 1 }, { 'LEFT', 'RIGHT', -2, 0 } },
    ['TOPRIGHT'] = { { -6, 1 }, { 'RIGHT', 'LEFT', 2, 0 } },
    ['BOTTOMLEFT'] = { { 6, 1 }, { 'LEFT', 'RIGHT', -2, 0 } },
    ['BOTTOMRIGHT'] = { { -6, 1 }, { 'RIGHT', 'LEFT', 2, 0 } },
    ['LEFT'] = { { 6, 1 }, { 'LEFT', 'RIGHT', -2, 0 } },
    ['RIGHT'] = { { -6, 1 }, { 'RIGHT', 'LEFT', 2, 0 } },
    ['TOP'] = { { 0, 0 }, { 'RIGHT', 'LEFT', 2, 0 } },
    ['BOTTOM'] = { { 0, 0 }, { 'RIGHT', 'LEFT', 2, 0 } },
}

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

function UNITFRAME:CreateSpellsIndicator(self)
    local spellSize = 8

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

        local font = C.Assets.Fonts.Small
        local fontSize = 11
        button.timer = F.CreateFS(button, font, fontSize, true, nil, nil, true, 'CENTER', -counterOffsets[anchor][2][3], 0)
        button.count = F.CreateFS(button, font, fontSize, true, nil, nil, true)

        button.anchor = anchor
        buttons[anchor] = button

        UNITFRAME:RefreshBuffIndicator(button)
    end

    self.SpellsIndicator = buttons

    UNITFRAME.SpellsIndicator_UpdateOptions(self)
end

function UNITFRAME:SpellsIndicator_UpdateButton(button, aura, r, g, b)
    if C.DB.Unitframe.CornerSpellType == 3 then
        if aura.duration and aura.duration > 0 then
            button.expiration = aura.expiration
            button:SetScript('OnUpdate', UNITFRAME.SpellsIndicator_OnUpdate)
        else
            button:SetScript('OnUpdate', nil)
        end

        button.timer:SetTextColor(r, g, b)
    else
        if aura.duration and aura.duration > 0 then
            button.cd:SetCooldown(aura.expiration - aura.duration, aura.duration)
            button.cd:Show()
        else
            button.cd:Hide()
        end

        if C.DB.Unitframe.CornerSpellType == 1 then
            button.icon:SetVertexColor(r, g, b)
        else
            button.icon:SetTexture(aura.texture)
        end
    end

    button.count:SetText(aura.count > 1 and aura.count or '')
    button:Show()
end

function UNITFRAME:SpellsIndicator_HideButtons()
    for _, button in pairs(self.SpellsIndicator) do
        button:Hide()
    end
end

function UNITFRAME:RefreshBuffIndicator(bu)
    if C.DB.Unitframe.CornerSpellType == 3 then
        local point, anchorPoint, x, y = unpack(counterOffsets[bu.anchor][2])
        bu.timer:Show()
        bu.count:ClearAllPoints()
        bu.count:SetPoint(point, bu.timer, anchorPoint, x, y)
        bu.icon:Hide()
        bu.cd:Hide()
        bu.bg:Hide()
    else
        bu:SetScript('OnUpdate', nil)
        bu.timer:Hide()
        bu.count:ClearAllPoints()
        bu.count:SetPoint('CENTER', unpack(counterOffsets[bu.anchor][1]))

        if C.DB.Unitframe.CornerSpellType == 1 then
            bu.icon:SetTexture(C.Assets.Textures.StatusbarFlat)
        else
            bu.icon:SetVertexColor(1, 1, 1)
        end

        bu.icon:Show()
        bu.cd:Show()
        bu.bg:Show()
    end
end

function UNITFRAME:SpellsIndicator_UpdateOptions()
    local spells = self.SpellsIndicator
    if not spells then
        return
    end

    for anchor, button in pairs(spells) do
        button:SetScale(C.DB.Unitframe.CornerSpellScale)
        UNITFRAME:RefreshBuffIndicator(button)
    end
end
