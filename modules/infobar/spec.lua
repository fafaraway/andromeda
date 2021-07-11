local _G = _G
local unpack = unpack
local select = select
local format = format
local wipe = wipe
local SetLootSpecialization = SetLootSpecialization
local SetSpecialization = SetSpecialization
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetLootSpecialization = GetLootSpecialization
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetTalentInfo = GetTalentInfo
local GetPvpTalentInfoByID = GetPvpTalentInfoByID
local ToggleTalentFrame = ToggleTalentFrame
local C_SpecializationInfo_CanPlayerUsePVPTalentUI = C_SpecializationInfo.CanPlayerUsePVPTalentUI
local C_SpecializationInfo_GetAllSelectedPvpTalentIDs = C_SpecializationInfo.GetAllSelectedPvpTalentIDs
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local EasyMenu = EasyMenu

local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('Infobar')

local pvpTalents
local pvpIconTexture = C_CurrencyInfo_GetCurrencyInfo(104).iconFileID

local menuList = {
    {text = _G.CHOOSE_SPECIALIZATION, isTitle = true, notCheckable = true},
    {text = _G.SPECIALIZATION, hasArrow = true, notCheckable = true},
    {text = _G.SELECT_LOOT_SPECIALIZATION, hasArrow = true, notCheckable = true}
}

local function AddIcon(texture)
    texture = texture and '|T' .. texture .. ':12:16:0:0:50:50:4:46:4:46|t' or ''
    return texture
end

local function ClickFunc(i, isLoot)
    if not i then
        return
    end
    if isLoot then
        SetLootSpecialization(i)
    else
        SetSpecialization(i)
    end
    _G.DropDownList1:Hide()
end

local function Button_OnMouseUp(self, btn)
    local specIndex = GetSpecialization()
    if not specIndex or specIndex == 5 then
        return
    end

    if btn == 'LeftButton' then
        ToggleTalentFrame(2)
    else
        menuList[2].menuList = {{}, {}, {}, {}}
        menuList[3].menuList = {{}, {}, {}, {}, {}}
        local specList, lootList = menuList[2].menuList, menuList[3].menuList
        local spec, specName = GetSpecializationInfo(specIndex)
        local lootSpec = GetLootSpecialization()
        lootList[1] = {text = format(_G.LOOT_SPECIALIZATION_DEFAULT, specName), func = function()
                ClickFunc(0, true)
            end, checked = lootSpec == 0 and true or false}

        for i = 1, 4 do
            local id, name = GetSpecializationInfo(i)
            if id then
                specList[i].text = name
                if id == spec then
                    specList[i].func = function()
                        ClickFunc()
                    end
                    specList[i].checked = true
                else
                    specList[i].func = function()
                        ClickFunc(i)
                    end
                    specList[i].checked = false
                end
                lootList[i + 1] = {text = name, func = function()
                        ClickFunc(id, true)
                    end, checked = id == lootSpec and true or false}
            else
                specList[i] = nil
                lootList[i + 1] = nil
            end
        end

        EasyMenu(menuList, F.EasyMenu, self, -80, 100, 'MENU', 1)
        _G.GameTooltip:Hide()
    end
end

local function Button_OnEvent(self)
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
            self.Text:SetText(format(_G.CLUB_FINDER_SPEC .. ': ' .. C.MyColor .. '%s  |r' .. L['Loot'] .. ':' .. C.MyColor .. ' %s', name, name))
        else
            self.Text:SetText(format(_G.CLUB_FINDER_SPEC .. ': ' .. C.MyColor .. '%s  |r' .. L['Loot'] .. ':' .. C.MyColor .. ' %s', name, lootname))
        end

        -- INFOBAR:ShowButton(self)
    else
        self.Text:SetText(format(_G.CLUB_FINDER_SPEC .. ': ' .. C.MyColor .. '%s  |r', _G.NONE))

        -- INFOBAR:HideButton(self)
    end
end

local function Button_OnEnter(self)
    if not GetSpecialization() then
        return
    end

    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.TALENTS_BUTTON, .9, .8, .6)
    _G.GameTooltip:AddLine(' ')

    local _, specName, _, specIcon = GetSpecializationInfo(GetSpecialization())
    _G.GameTooltip:AddLine(AddIcon(specIcon) .. ' ' .. specName, .6, .8, 1)

    for t = 1, _G.MAX_TALENT_TIERS do
        for c = 1, 3 do
            local _, name, icon, selected = GetTalentInfo(t, c, 1)
            if selected then
                _G.GameTooltip:AddLine(AddIcon(icon) .. ' ' .. name, 1, 1, 1)
            end
        end
    end

    if C_SpecializationInfo_CanPlayerUsePVPTalentUI() then
        pvpTalents = C_SpecializationInfo_GetAllSelectedPvpTalentIDs()
        if #pvpTalents > 0 then
            _G.GameTooltip:AddLine(' ')
            _G.GameTooltip:AddLine(AddIcon(pvpIconTexture) .. ' ' .. _G.PVP_TALENTS, .6, .8, 1)
            for _, talentID in next, pvpTalents do
                local _, name, icon, _, _, _, unlocked = GetPvpTalentInfoByID(talentID)
                if name and unlocked then
                    _G.GameTooltip:AddLine(AddIcon(icon) .. ' ' .. name, 1, 1, 1)
                end
            end
        end

        wipe(pvpTalents)
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Toggle Talent Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right .. L['Change Specialization & Loot'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateSpecBlock()
    if not C.DB.Infobar.Spec then
        return
    end

    local bu = INFOBAR:AddBlock('', 'RIGHT', 220)
    bu:HookScript('OnMouseUp', Button_OnMouseUp)
    bu:HookScript('OnEvent', Button_OnEvent)
    bu:HookScript('OnEnter', Button_OnEnter)
    bu:HookScript('OnLeave', Button_OnLeave)

    bu:RegisterEvent('PLAYER_ENTERING_WORLD')
    bu:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
    bu:RegisterEvent('PLAYER_LOOT_SPEC_UPDATED')
end
