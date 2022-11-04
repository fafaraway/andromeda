local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local pvpTalents
local pvpIconTexture = C_CurrencyInfo.GetCurrencyInfo(104).iconFileID
local currentSpecIndex, currentLootIndex, newMenu, numSpecs, numLocal

local function addIcon(texture)
    texture = texture and '|T' .. texture .. ':12:16:0:0:50:50:4:46:4:46|t' or ''
    return texture
end

local function selectSpec(_, specIndex)
    if currentSpecIndex == specIndex then
        return
    end
    SetSpecialization(specIndex)
    _G.DropDownList1:Hide()
end

local function checkSpec(self)
    return currentSpecIndex == self.arg1
end

local function selectLootSpec(_, index)
    SetLootSpecialization(index)
    _G.DropDownList1:Hide()
end

local function checkLootSpec(self)
    return currentLootIndex == self.arg1
end

local function refreshDefaultLootSpec()
    if not currentSpecIndex or currentSpecIndex == 5 then
        return
    end
    local mult = 3 + numSpecs
    newMenu[numLocal - mult].text = format(_G.LOOT_SPECIALIZATION_DEFAULT, select(2, GetSpecializationInfo(currentSpecIndex)))
end

local function selectCurrentConfig(_, configID, specID)
    if InCombatLockdown() then
        _G.UIErrorsFrame:AddMessage(C.INFO_COLOR .. _G.ERR_NOT_IN_COMBAT)
        return
    end

    if configID == _G.Constants.TraitConsts.STARTER_BUILD_TRAIT_CONFIG_ID then
        C_ClassTalents.SetStarterBuildActive(true)
    else
        C_ClassTalents.LoadConfig(configID, true)
        C_ClassTalents.SetStarterBuildActive(false)
    end

    C_ClassTalents.UpdateLastSelectedSavedConfigID(specID or GetSpecializationInfo(currentSpecIndex), configID)
end

local function checkCurrentConfig(self)
    return C_ClassTalents.GetLastSelectedSavedConfigID(self.arg2) == self.arg1
end

local function refreshAllTraits()
    local numConfig = numLocal or 0
    local specID = GetSpecializationInfo(currentSpecIndex)
    local configIDs = specID and C_ClassTalents.GetConfigIDsBySpecID(specID)
    if configIDs then
        for i = 1, #configIDs do
            local configID = configIDs[i]
            if configID then
                local info = C_Traits.GetConfigInfo(configID)
                numConfig = numConfig + 1
                if not newMenu[numConfig] then
                    newMenu[numConfig] = {}
                end
                newMenu[numConfig].text = info.name
                newMenu[numConfig].arg1 = configID
                newMenu[numConfig].arg2 = specID
                newMenu[numConfig].func = selectCurrentConfig
                newMenu[numConfig].checked = checkCurrentConfig
            end
        end
    end

    for i = numConfig + 1, #newMenu do
        if newMenu[i] then
            newMenu[i].text = nil
        end
    end
end

local seperatorMenu = {
    text = '',
    isTitle = true,
    notCheckable = true,
    iconOnly = true,
    icon = 'Interface\\Common\\UI-TooltipDivider-Transparent',
    iconInfo = {
        tCoordLeft = 0,
        tCoordRight = 1,
        tCoordTop = 0,
        tCoordBottom = 1,
        tSizeX = 0,
        tSizeY = 8,
        tFitDropDownSizeX = true,
    },
}

local function BuildSpecMenu()
    if newMenu then
        return
    end

    newMenu = {
        { text = _G.SPECIALIZATION, isTitle = true, notCheckable = true },
        seperatorMenu,
        { text = _G.SELECT_LOOT_SPECIALIZATION, isTitle = true, notCheckable = true },
        { text = '', arg1 = 0, func = selectLootSpec, checked = checkLootSpec },
    }

    for i = 1, 4 do
        local id, name = GetSpecializationInfo(i)
        if id then
            numSpecs = (numSpecs or 0) + 1
            tinsert(newMenu, i + 1, { text = name, arg1 = i, func = selectSpec, checked = checkSpec })
            tinsert(newMenu, { text = name, arg1 = id, func = selectLootSpec, checked = checkLootSpec })
        end
    end

    tinsert(newMenu, seperatorMenu)
    tinsert(newMenu, { text = GetSpellInfo(384255), isTitle = true, notCheckable = true })
    tinsert(newMenu, {
        text = _G.BLUE_FONT_COLOR:WrapTextInColorCode(_G.TALENT_FRAME_DROP_DOWN_STARTER_BUILD),
        func = selectCurrentConfig,
        arg1 = _G.Constants.TraitConsts.STARTER_BUILD_TRAIT_CONFIG_ID,
        checked = function()
            return C_ClassTalents.GetStarterBuildActive()
        end,
    })

    numLocal = #newMenu

    refreshDefaultLootSpec()
    F:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', refreshDefaultLootSpec)

    refreshAllTraits()
    F:RegisterEvent('TRAIT_CONFIG_DELETED', refreshAllTraits)
    F:RegisterEvent('TRAIT_CONFIG_UPDATED', refreshAllTraits)
    F:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED', refreshAllTraits)
end

local function Block_OnMouseUp(self, btn)
    if not currentSpecIndex or currentSpecIndex == 5 then
        return
    end

    if btn == 'LeftButton' then
        _G.ToggleTalentFrame(2)
    else
        BuildSpecMenu()
        EasyMenu(newMenu, F.EasyMenu, self, -80, 100, 'MENU', 1)
        _G.GameTooltip:Hide()
    end
end

local function Block_OnEvent(self)
    --[[ local currentSpec = GetSpecialization()
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
            self.text:SetText(format(L['Spec'] .. ': ' .. C.MY_CLASS_COLOR .. '%s  |r' .. L['Loot'] .. ':' .. C.MY_CLASS_COLOR .. ' %s', name, name))
        else
            self.text:SetText(format(L['Spec'] .. ': ' .. C.MY_CLASS_COLOR .. '%s  |r' .. L['Loot'] .. ':' .. C.MY_CLASS_COLOR .. ' %s', name, lootname))
        end
    else
        self.text:SetText(format(L['Spec'] .. ': ' .. C.MY_CLASS_COLOR .. '%s  |r', _G.NONE))
    end --]]

    currentSpecIndex = GetSpecialization()
    if currentSpecIndex and currentSpecIndex < 5 then
        local _, name, _, icon = GetSpecializationInfo(currentSpecIndex)
        if not name then
            return
        end
        currentLootIndex = GetLootSpecialization()
        if currentLootIndex == 0 then
            icon = addIcon(icon)
        else
            icon = addIcon(select(4, GetSpecializationInfoByID(currentLootIndex)))
        end
        self.text:SetText(C.MY_CLASS_COLOR .. name .. icon)
    else
        self.text:SetText(_G.SPECIALIZATION .. ': ' .. C.MY_CLASS_COLOR .. _G.NONE)
    end
end

local function Block_OnEnter(self)
    if not currentSpecIndex or currentSpecIndex == 5 then
        return
    end

    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.TALENTS_BUTTON, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddLine(' ')

    local specID, specName, _, specIcon = GetSpecializationInfo(currentSpecIndex)
    _G.GameTooltip:AddLine(addIcon(specIcon) .. ' ' .. specName, 0.6, 0.8, 1)

    for t = 1, _G.MAX_TALENT_TIERS do
        for c = 1, 3 do
            local _, name, icon, selected = GetTalentInfo(t, c, 1)
            if selected then
                _G.GameTooltip:AddLine(addIcon(icon) .. ' ' .. name, 1, 1, 1)
            end
        end
    end

    local configID = C_ClassTalents.GetLastSelectedSavedConfigID(specID)
    local info = configID and C_Traits.GetConfigInfo(configID)
    if info and info.name then
        _G.GameTooltip:AddLine('   (' .. info.name .. ')', 1, 1, 1)
    end

    if C_SpecializationInfo.CanPlayerUsePVPTalentUI() then
        pvpTalents = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
        if #pvpTalents > 0 then
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(addIcon(pvpIconTexture) .. ' ' .. _G.PVP_TALENTS, 0.6, 0.8, 1)
            for _, talentID in next, pvpTalents do
                local _, name, icon, _, _, _, unlocked = GetPvpTalentInfoByID(talentID)
                if name and unlocked then
                    _G.GameTooltip:AddLine(addIcon(icon) .. ' ' .. name, 1, 1, 1)
                end
            end
        end

        wipe(pvpTalents)
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LINE_STRING)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_LEFT_BUTTON .. L['Toggle Talent Panel'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
    _G.GameTooltip:AddDoubleLine(' ', C.MOUSE_RIGHT_BUTTON .. L['Change Specialization & Loot'] .. ' ', 1, 1, 1, 0.9, 0.8, 0.6)
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
