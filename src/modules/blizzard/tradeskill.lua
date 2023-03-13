local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local RUNEFORGING_ID = 53428
local PICK_LOCK = 1804
local CHEF_HAT = 134020
local THERMAL_ANVIL = 87216
local tabList = {}

local onlyPrimary = {
    [171] = true, -- Alchemy
    [182] = true, -- Herbalism
    [186] = true, -- Mining
    [202] = true, -- Engineering
    [356] = true, -- Fishing
    [393] = true, -- Skinning
}

function BLIZZARD:UpdateProfessions()
    local prof1, prof2, _, fish, cook = GetProfessions()
    local profs = { prof1, prof2, fish, cook }

    if C.MY_CLASS == 'DEATHKNIGHT' then
        BLIZZARD:TradeTabs_Create(RUNEFORGING_ID)
    elseif C.MY_CLASS == 'ROGUE' and IsPlayerSpell(PICK_LOCK) then
        BLIZZARD:TradeTabs_Create(PICK_LOCK)
    end

    local isCook
    for _, prof in pairs(profs) do
        local _, _, _, _, numSpells, spelloffset, skillLine = GetProfessionInfo(prof)
        if skillLine == 185 then
            isCook = true
        end

        numSpells = onlyPrimary[skillLine] and 1 or numSpells
        if numSpells > 0 then
            for i = 1, numSpells do
                local slotID = i + spelloffset
                if not IsPassiveSpell(slotID, _G.BOOKTYPE_PROFESSION) then
                    local spellID = select(2, GetSpellBookItemInfo(slotID, _G.BOOKTYPE_PROFESSION))
                    if i == 1 then
                        BLIZZARD:TradeTabs_Create(spellID)
                    else
                        BLIZZARD:TradeTabs_Create(spellID)
                    end
                end
            end
        end
    end

    if isCook and PlayerHasToy(CHEF_HAT) and C_ToyBox.IsToyUsable(CHEF_HAT) then
        BLIZZARD:TradeTabs_Create(nil, CHEF_HAT)
    end
    if GetItemCount(THERMAL_ANVIL) > 0 then
        BLIZZARD:TradeTabs_Create(nil, nil, THERMAL_ANVIL)
    end
end

function BLIZZARD:TradeTabs_Update()
    for _, tab in pairs(tabList) do
        local spellID = tab.spellID
        local itemID = tab.itemID

        if IsCurrentSpell(spellID) then
            tab:SetChecked(true)
            tab.cover:Show()
        else
            tab:SetChecked(false)
            tab.cover:Hide()
        end

        local start, duration
        if itemID then
            start, duration = GetItemCooldown(itemID)
        else
            start, duration = GetSpellCooldown(spellID)
        end
        if start and duration and duration > 1.5 then
            tab.CD:SetCooldown(start, duration)
        end
    end
end

function BLIZZARD:TradeTabs_Reskin()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    for _, tab in pairs(tabList) do
        tab:SetCheckedTexture(C.Assets.Textures.ButtonChecked)
        tab:GetRegions():Hide()
        F.CreateBDFrame(tab)
        local texture = tab:GetNormalTexture()
        if texture then
            texture:SetTexCoord(unpack(C.TEX_COORD))
        end
    end
end

local index = 1
function BLIZZARD:TradeTabs_Create(spellID, toyID, itemID)
    local name, _, texture
    if toyID then
        _, name, texture = C_ToyBox.GetToyInfo(toyID)
    elseif itemID then
        name, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
    else
        name, _, texture = GetSpellInfo(spellID)
    end
    if not name then
        return
    end -- precaution

    local tab = CreateFrame('CheckButton', nil, _G.ProfessionsFrame, 'SpellBookSkillLineTabTemplate, SecureActionButtonTemplate')
    tab.tooltip = name
    tab.spellID = spellID
    tab.itemID = toyID or itemID
    tab.type = (toyID and 'toy') or (itemID and 'item') or 'spell'
    tab:RegisterForClicks('AnyDown')

    if spellID == 818 then -- cooking fire
        tab:SetAttribute('type', 'macro')
        tab:SetAttribute('macrotext', '/cast [@player]' .. name)
    else
        tab:SetAttribute('type', tab.type)
        tab:SetAttribute(tab.type, spellID or name)
    end
    tab:SetNormalTexture(texture)
    tab:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
    tab:Show()

    tab.CD = CreateFrame('Cooldown', nil, tab, 'CooldownFrameTemplate')
    tab.CD:SetAllPoints()

    tab.cover = CreateFrame('Frame', nil, tab)
    tab.cover:SetAllPoints()
    tab.cover:EnableMouse(true)

    tab:SetPoint('TOPLEFT', _G.ProfessionsFrame, 'TOPRIGHT', 3, -index * 42)
    tinsert(tabList, tab)
    index = index + 1
end

function BLIZZARD:TradeTabs_FilterIcons()
    local buttonList = {
        [1] = {
            'Atlas:bags-greenarrow',
            _G.TRADESKILL_FILTER_HAS_SKILL_UP,
            C_TradeSkillUI.GetOnlyShowSkillUpRecipes,
            C_TradeSkillUI.SetOnlyShowSkillUpRecipes,
        },
        [2] = {
            'Interface\\RAIDFRAME\\ReadyCheck-Ready',
            _G.CRAFT_IS_MAKEABLE,
            C_TradeSkillUI.GetOnlyShowMakeableRecipes,
            C_TradeSkillUI.SetOnlyShowMakeableRecipes,
        },
    }

    local function filterClick(self)
        local value = self.__value
        if value[3]() then
            value[4](false)
            F.SetBorderColor(self.bg)
        else
            value[4](true)
            self.bg:SetBackdropBorderColor(1, 0.8, 0)
        end
    end

    local buttons = {}
    for index, value in pairs(buttonList) do
        local bu = CreateFrame('Button', nil, _G.ProfessionsFrame.CraftingPage.RecipeList, 'BackdropTemplate')
        bu:SetSize(22, 22)
        bu:SetPoint('BOTTOMRIGHT', _G.ProfessionsFrame.CraftingPage.RecipeList.FilterButton, 'TOPRIGHT', -(index - 1) * 27, 10)
        F.PixelIcon(bu, value[1], true)
        F.AddTooltip(bu, 'ANCHOR_TOP', value[2])
        bu.__value = value
        bu:SetScript('OnClick', filterClick)

        buttons[index] = bu
    end

    local function updateFilterStatus()
        for index, value in pairs(buttonList) do
            if value[3]() then
                buttons[index].bg:SetBackdropBorderColor(1, 0.8, 0)
            else
                F.SetBorderColor(buttons[index].bg)
            end
        end
    end
    F:RegisterEvent('TRADE_SKILL_LIST_UPDATE', updateFilterStatus)
end

local init
function BLIZZARD:TradeTabs_OnLoad()
    init = true

    BLIZZARD:UpdateProfessions()

    BLIZZARD:TradeTabs_Reskin()
    BLIZZARD:TradeTabs_Update()
    F:RegisterEvent('TRADE_SKILL_SHOW', BLIZZARD.TradeTabs_Update)
    F:RegisterEvent('TRADE_SKILL_CLOSE', BLIZZARD.TradeTabs_Update)
    F:RegisterEvent('CURRENT_SPELL_CAST_CHANGED', BLIZZARD.TradeTabs_Update)

    BLIZZARD:TradeTabs_FilterIcons()

    F:UnregisterEvent('PLAYER_REGEN_ENABLED', BLIZZARD.TradeTabs_OnLoad)
end

function BLIZZARD:TradeTabs()
    if not C.DB.General.TradeTabs then
        return
    end

    if not _G.ProfessionsFrame then
        return
    end

    _G.ProfessionsFrame:HookScript('OnShow', function()
        if init then
            return
        end
        if InCombatLockdown() then
            F:RegisterEvent('PLAYER_REGEN_ENABLED', BLIZZARD.TradeTabs_OnLoad)
        else
            BLIZZARD:TradeTabs_OnLoad()
        end
    end)
end

BLIZZARD:RegisterBlizz('TradeTabs', BLIZZARD.TradeTabs)
