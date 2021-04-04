local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local format = format
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetProfessions = GetProfessions
local GetSpellBookItemInfo = GetSpellBookItemInfo
local GetProfessionInfo = GetProfessionInfo
local GetItemCount = GetItemCount
local GetItemCooldown = GetItemCooldown
local GetSpellCooldown = GetSpellCooldown
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local IsPlayerSpell = IsPlayerSpell
local IsPassiveSpell = IsPassiveSpell
local IsCurrentSpell = IsCurrentSpell
local InCombatLockdown = InCombatLockdown
local UseItemByName = UseItemByName
local PlayerHasToy = PlayerHasToy
local BOOKTYPE_PROFESSION = BOOKTYPE_PROFESSION
local C_ToyBox_IsToyUsable = C_ToyBox.IsToyUsable
local C_ToyBox_GetToyInfo = C_ToyBox.GetToyInfo
local TRADESKILL_FILTER_HAS_SKILL_UP = TRADESKILL_FILTER_HAS_SKILL_UP
local CRAFT_IS_MAKEABLE = CRAFT_IS_MAKEABLE
local C_TradeSkillUI_GetOnlyShowSkillUpRecipes = C_TradeSkillUI.GetOnlyShowSkillUpRecipes
local C_TradeSkillUI_SetOnlyShowSkillUpRecipes = C_TradeSkillUI.SetOnlyShowSkillUpRecipes
local C_TradeSkillUI_GetOnlyShowMakeableRecipes = C_TradeSkillUI.GetOnlyShowMakeableRecipes
local C_TradeSkillUI_SetOnlyShowMakeableRecipes = C_TradeSkillUI.SetOnlyShowMakeableRecipes
local C_TradeSkillUI_GetRecipeInfo = C_TradeSkillUI.GetRecipeInfo
local C_TradeSkillUI_GetTradeSkillLine = C_TradeSkillUI.GetTradeSkillLine

local F, C, L = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD

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
    local profs = {prof1, prof2, fish, cook}

    if C.MyClass == 'DEATHKNIGHT' then
        BLIZZARD:TradeTabs_Create(RUNEFORGING_ID)
    elseif C.MyClass == 'ROGUE' and IsPlayerSpell(PICK_LOCK) then
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
                if not IsPassiveSpell(slotID, BOOKTYPE_PROFESSION) then
                    local spellID = select(2, GetSpellBookItemInfo(slotID, BOOKTYPE_PROFESSION))
                    if i == 1 then
                        BLIZZARD:TradeTabs_Create(spellID)
                    else
                        BLIZZARD:TradeTabs_Create(spellID)
                    end
                end
            end
        end
    end

    if isCook and PlayerHasToy(CHEF_HAT) and C_ToyBox_IsToyUsable(CHEF_HAT) then
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
    if not _G.FREE_ADB.ReskinBlizz then
        return
    end

    for _, tab in pairs(tabList) do
        tab:SetCheckedTexture(C.Assets.button_checked)
        tab:GetRegions():Hide()
        F.CreateBDFrame(tab)
        local texture = tab:GetNormalTexture()
        if texture then
            texture:SetTexCoord(unpack(C.TexCoord))
        end
    end
end

local index = 1
function BLIZZARD:TradeTabs_Create(spellID, toyID, itemID)
    local name, _, texture
    if toyID then
        _, name, texture = C_ToyBox_GetToyInfo(toyID)
    elseif itemID then
        name, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
    else
        name, _, texture = GetSpellInfo(spellID)
    end

    local tab = CreateFrame('CheckButton', nil, _G.TradeSkillFrame, 'SpellBookSkillLineTabTemplate, SecureActionButtonTemplate')
    tab.tooltip = name
    tab.spellID = spellID
    tab.itemID = toyID or itemID
    tab.type = (toyID and 'toy') or (itemID and 'item') or 'spell'
    tab:SetAttribute('type', tab.type)
    tab:SetAttribute(tab.type, spellID or name)
    tab:SetNormalTexture(texture)
    tab:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
    tab:Show()

    tab.CD = CreateFrame('Cooldown', nil, tab, 'CooldownFrameTemplate')
    tab.CD:SetAllPoints()

    tab.cover = CreateFrame('Frame', nil, tab)
    tab.cover:SetAllPoints()
    tab.cover:EnableMouse(true)

    tab:SetPoint('TOPLEFT', _G.TradeSkillFrame, 'TOPRIGHT', 3, -index * 42)
    tinsert(tabList, tab)
    index = index + 1
end

function BLIZZARD:TradeTabs_FilterIcons()
    local buttonList = {
        [1] = {'Atlas:bags-greenarrow', TRADESKILL_FILTER_HAS_SKILL_UP, C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes},
        [2] = {'Interface\\RAIDFRAME\\ReadyCheck-Ready', CRAFT_IS_MAKEABLE, C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes},
    }

    local function filterClick(self)
        local value = self.__value
        if value[3]() then
            value[4](false)
            self.bg:SetBackdropBorderColor(0, 0, 0)
        else
            value[4](true)
            self.bg:SetBackdropBorderColor(1, .8, 0)
        end
    end

    local buttons = {}
    for index, value in pairs(buttonList) do
        local bu = CreateFrame('Button', nil, _G.TradeSkillFrame, 'BackdropTemplate')
        bu:SetSize(22, 22)
        bu:SetPoint('RIGHT', _G.TradeSkillFrame.FilterButton, 'LEFT', -5 - (index - 1) * 27, 0)
        F.PixelIcon(bu, value[1], true)
        F.AddTooltip(bu, 'ANCHOR_TOP', value[2])
        bu.__value = value
        bu:SetScript('OnClick', filterClick)

        buttons[index] = bu
    end

    local function updateFilterStatus()
        for index, value in pairs(buttonList) do
            if value[3]() then
                buttons[index].bg:SetBackdropBorderColor(1, .8, 0)
            else
                buttons[index].bg:SetBackdropBorderColor(0, 0, 0)
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
    local recipeInfo = recipeID and C_TradeSkillUI_GetRecipeInfo(recipeID)
    if recipeInfo and recipeInfo.alternateVerb then
        local parentSkillLineID = select(6, C_TradeSkillUI_GetTradeSkillLine())
        if parentSkillLineID == 333 then
            isEnchanting = true
            self.CreateButton.tooltip = format(tooltipString, L.BLIZZARD.USE_VELLUM, GetItemCount(ENCHANTING_VELLUM))
        end
    end
end

function BLIZZARD:TradeTabs_QuickEnchanting()
    if not _G.TradeSkillFrame then
        return
    end

    local detailsFrame = _G.TradeSkillFrame.DetailsFrame
    hooksecurefunc(detailsFrame, 'RefreshDisplay', IsRecipeEnchanting)

    local createButton = detailsFrame.CreateButton
    createButton:RegisterForClicks('AnyUp')
    createButton:HookScript('OnClick', function(self, btn)
        if btn == 'RightButton' and isEnchanting then
            UseItemByName(ENCHANTING_VELLUM)
        end
    end)
end

function BLIZZARD:TradeTabs()
    if not C.DB.blizzard.tradeskill_tabs then
        return
    end

    F:RegisterEvent('ADDON_LOADED', BLIZZARD.TradeTabs_OnEvent)
end

BLIZZARD:RegisterBlizz('TradeTabs', BLIZZARD.TradeTabs)
