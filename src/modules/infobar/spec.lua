local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local pvpTalents
local pvpIconTexture = C_CurrencyInfo.GetCurrencyInfo(104).iconFileID

local menuList = {
    { text = _G.CHOOSE_SPECIALIZATION, isTitle = true, notCheckable = true },
    {text = _G.SPECIALIZATION, hasArrow = true, notCheckable = true, menuList = {}},
    {text = _G.SELECT_LOOT_SPECIALIZATION, hasArrow = true, notCheckable = true, menuList = {}},
}

local function AddIcon(texture)
    texture = texture and '|T' .. texture .. ':12:16:0:0:50:50:4:46:4:46|t' or ''
    return texture
end

local function SelectSpec(_, specIndex)
    if GetSpecialization() == specIndex then
        return
    end
    SetSpecialization(specIndex)
    _G.DropDownList1:Hide()
end

local function CheckSpec(self)
    return GetSpecialization() == self.arg1
end

local function SelectLootSpec(_, index)
    SetLootSpecialization(index)
    _G.DropDownList1:Hide()
end

local function CheckLootSpec(self)
    return GetLootSpecialization() == self.arg1
end

local function BuildSpecMenu()
    local specList = menuList[2].menuList
    local lootList = menuList[3].menuList
    lootList[1] = { text = '', arg1 = 0, func = SelectLootSpec, checked = CheckLootSpec }

    for i = 1, 4 do
        local id, name = GetSpecializationInfo(i)
        if id then
            specList[i] = { text = name, arg1 = i, func = SelectSpec, checked = CheckSpec }
            lootList[i + 1] = { text = name, arg1 = id, func = SelectLootSpec, checked = CheckLootSpec }
        end
    end
end

local function Block_OnMouseUp(self, btn)
    local specIndex = GetSpecialization()
    if not specIndex or specIndex == 5 then
        return
    end

    if btn == 'LeftButton' then
        _G.ToggleTalentFrame(2)
    else
        if not menuList[1].created then
            BuildSpecMenu()
            menuList[1].created = true
        end
        menuList[3].menuList[1].text = format(_G.LOOT_SPECIALIZATION_DEFAULT, select(2, GetSpecializationInfo(specIndex)))

        EasyMenu(menuList, F.EasyMenu, self, -80, 100, 'MENU', 1)
        _G.GameTooltip:Hide()
    end
end

local function Block_OnEvent(self)
    local currentSpec = GetSpecialization()
    local lootSpecID = GetLootSpecialization()

    if currentSpec then
        local _, name = GetSpecializationInfo(currentSpec)
        if not name then
            return
        end
        local _, lootname = GetSpecializationInfoByID(lootSpecID)
        -- local role = GetSpecializationRole(currentSpec)
        -- local lootrole = GetSpecializationRoleByID(lootSpecID)

        if not lootname or name == lootname then
            self.text:SetText(
                string.format(
                    L['Spec'] .. ': ' .. C.MY_CLASS_COLOR .. '%s  |r' .. L['Loot'] .. ':' .. C.MY_CLASS_COLOR .. ' %s',
                    name,
                    name
                )
            )
        else
            self.text:SetText(
                string.format(
                    L['Spec'] .. ': ' .. C.MY_CLASS_COLOR .. '%s  |r' .. L['Loot'] .. ':' .. C.MY_CLASS_COLOR .. ' %s',
                    name,
                    lootname
                )
            )
        end
    else
        self.text:SetText(string.format(L['Spec'] .. ': ' .. C.MY_CLASS_COLOR .. '%s  |r', _G.NONE))
    end
end

local function Block_OnEnter(self)
    if not GetSpecialization() then
        return
    end

    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.TALENTS_BUTTON, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddLine(' ')

    local _, specName, _, specIcon = GetSpecializationInfo(GetSpecialization())
    _G.GameTooltip:AddLine(AddIcon(specIcon) .. ' ' .. specName, 0.6, 0.8, 1)

    for t = 1, _G.MAX_TALENT_TIERS do
        for c = 1, 3 do
            local _, name, icon, selected = GetTalentInfo(t, c, 1)
            if selected then
                _G.GameTooltip:AddLine(AddIcon(icon) .. ' ' .. name, 1, 1, 1)
            end
        end
    end

    if C_SpecializationInfo.CanPlayerUsePVPTalentUI() then
        pvpTalents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        if #pvpTalents > 0 then
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(AddIcon(pvpIconTexture) .. ' ' .. _G.PVP_TALENTS, 0.6, 0.8, 1)
            for _, talentID in next, pvpTalents do
                local _, name, icon, _, _, _, unlocked = GetPvpTalentInfoByID(talentID)
                if name and unlocked then
                    _G.GameTooltip:AddLine(AddIcon(icon) .. ' ' .. name, 1, 1, 1)
                end
            end
        end

        table.wipe(pvpTalents)
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Toggle Talent Panel'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddDoubleLine(
        ' ',
        C.MOUSE_RIGHT_BUTTON .. L['Change Specialization & Loot'] .. ' ',
        1,
        1,
        1,
        0.9,
        0.8,
        0.6
    )
    _G.GameTooltip:Show()
end

local function Block_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateSpecBlock()
    if not C.DB.Infobar.Spec then
        return
    end

    local spec = INFOBAR:RegisterNewBlock('specialization', 'RIGHT', 200)
    spec.onEvent = Block_OnEvent
    spec.onEnter = Block_OnEnter
    spec.onLeave = Block_OnLeave
    spec.onMouseUp = Block_OnMouseUp
    spec.eventList = { 'PLAYER_ENTERING_WORLD', 'ACTIVE_TALENT_GROUP_CHANGED', 'PLAYER_LOOT_SPEC_UPDATED' }
end
