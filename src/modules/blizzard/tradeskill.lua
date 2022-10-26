local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')

local RUNEFORGING_ID = 53428
local PICK_LOCK = 1804
local CHEF_HAT = 134020
local THERMAL_ANVIL = 87216
local ENCHANTING_VELLUM = 38682
local tabList = {}

local onlyPrimary = {
    [171] = true, -- Alchemy
    [202] = true, -- Engineering
    [182] = true, -- Herbalism
    [393] = true, -- Skinning
    [356] = true, -- Fishing
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

    local parent = C.IS_NEW_PATCH and _G.ProfessionsFrame or _G.TradeSkillFrame

    local tab = CreateFrame('CheckButton', nil, parent, 'SpellBookSkillLineTabTemplate, SecureActionButtonTemplate')
    tab.tooltip = name
    tab.spellID = spellID
    tab.itemID = toyID or itemID
    tab.type = (toyID and 'toy') or (itemID and 'item') or 'spell'

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

    tab:SetPoint('TOPLEFT', parent, 'TOPRIGHT', 3, -index * 42)
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

    local parent = C.IS_NEW_PATCH and _G.ProfessionsFrame.CraftingPage or _G.TradeSkillFrame

    local buttons = {}
    for index, value in pairs(buttonList) do
        local bu = CreateFrame('Button', nil, parent, 'BackdropTemplate')
        bu:SetSize(22, 22)
        if C.IS_NEW_PATCH then
            bu:SetPoint('BOTTOMRIGHT', _G.ProfessionsFrame.CraftingPage.RecipeList.FilterButton, 'TOPRIGHT', -(index - 1) * 27, 10)
        else
            bu:SetPoint('RIGHT', _G.TradeSkillFrame.FilterButton, 'LEFT', -5 - (index - 1) * 27, 0)
        end
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

function BLIZZARD:TradeTabs_OnLoad()
    BLIZZARD:UpdateProfessions()

    BLIZZARD:TradeTabs_Reskin()
    BLIZZARD:TradeTabs_Update()
    F:RegisterEvent('TRADE_SKILL_SHOW', BLIZZARD.TradeTabs_Update)
    F:RegisterEvent('TRADE_SKILL_CLOSE', BLIZZARD.TradeTabs_Update)
    F:RegisterEvent('CURRENT_SPELL_CAST_CHANGED', BLIZZARD.TradeTabs_Update)

    BLIZZARD:TradeTabs_FilterIcons()
    BLIZZARD:TradeTabs_QuickEnchanting()
end

function BLIZZARD.TradeTabs_OnEvent(event, addon)
    if event == 'ADDON_LOADED' and addon == 'Blizzard_TradeSkillUI' then
        F:UnregisterEvent(event, BLIZZARD.TradeTabs_OnEvent)

        if InCombatLockdown() then
            F:RegisterEvent('PLAYER_REGEN_ENABLED', BLIZZARD.TradeTabs_OnEvent)
        else
            BLIZZARD:TradeTabs_OnLoad()
        end
    elseif event == 'PLAYER_REGEN_ENABLED' then
        F:UnregisterEvent(event, BLIZZARD.TradeTabs_OnEvent)
        BLIZZARD:TradeTabs_OnLoad()
    end
end

local isEnchanting
local tooltipString = '|cffffffff%s(%d)'
local function IsRecipeEnchanting(self)
    isEnchanting = nil

    local recipeID = self.selectedRecipeID
    local recipeInfo = recipeID and C_TradeSkillUI.GetRecipeInfo(recipeID)
    if recipeInfo and recipeInfo.alternateVerb then
        local parentSkillLineID = select(6, C_TradeSkillUI.GetTradeSkillLine())
        if parentSkillLineID == 333 then
            isEnchanting = true
            self.CreateButton.tooltip = format(tooltipString, L['Right click to use vellum'], GetItemCount(ENCHANTING_VELLUM))
        end
    end
end

function BLIZZARD:TradeTabs_QuickEnchanting()
    if C.IS_NEW_PATCH then
        if _G.ProfessionsFrame.CraftingPage.ValidateControls then
            hooksecurefunc(_G.ProfessionsFrame.CraftingPage, 'ValidateControls', function(self)
                isEnchanting = nil
                local currentRecipeInfo = self.SchematicForm:GetRecipeInfo()
                if currentRecipeInfo and currentRecipeInfo.alternateVerb then
                    local professionInfo = _G.ProfessionsFrame:GetProfessionInfo()
                    if professionInfo and professionInfo.parentProfessionID == 333 then
                        isEnchanting = true
                        self.CreateButton.tooltipText = format(tooltipString, L['Right click to use vellum'], GetItemCount(ENCHANTING_VELLUM))
                    end
                end
            end)
        end

        local createButton = _G.ProfessionsFrame.CraftingPage.CreateButton
        createButton:RegisterForClicks('AnyUp')
        createButton:HookScript('OnClick', function(_, btn)
            if btn == 'RightButton' and isEnchanting then
                UseItemByName(ENCHANTING_VELLUM)
            end
        end)
    else
        if not _G.TradeSkillFrame then
            return
        end

        local detailsFrame = _G.TradeSkillFrame.DetailsFrame
        hooksecurefunc(detailsFrame, 'RefreshDisplay', IsRecipeEnchanting)

        local createButton = detailsFrame.CreateButton
        createButton:RegisterForClicks('AnyUp')
        createButton:HookScript('OnClick', function(_, btn)
            if btn == 'RightButton' and isEnchanting then
                UseItemByName(ENCHANTING_VELLUM)
            end
        end)
    end
end

function BLIZZARD:TradeTabs()
    if not C.DB.General.TradeTabs then
        return
    end

    if C.IS_NEW_PATCH then
        if _G.ProfessionsFrame then
            BLIZZARD:TradeTabs_OnLoad()
        end
    else
        F:RegisterEvent('ADDON_LOADED', BLIZZARD.TradeTabs_OnEvent)
    end
end

BLIZZARD:RegisterBlizz('TradeTabs', BLIZZARD.TradeTabs)
