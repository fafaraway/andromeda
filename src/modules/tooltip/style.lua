local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

function TOOLTIP:ReskinTooltip()
    if not self then
        return
    end
    if self:IsForbidden() then
        return
    end
    self:SetScale(1)

    if not self.tipStyled then
        self:HideBackdrop()
        self:DisableDrawLayer('BACKGROUND')
        self.bg = F.SetBD(self)
        self.bg:SetInside(self)
        self.bg:SetFrameLevel(self:GetFrameLevel())

        if self.StatusBar then
            TOOLTIP.ReskinStatusBar(self)
        end

        self.tipStyled = true
    end

    local color = _G.ANDROMEDA_ADB.BackdropColor
    local alpha = C.DB.Tooltip.BackdropAlpha
    self.bg:SetBackdropColor(color.r, color.g, color.b, alpha)
    F.SetBorderColor(self.bg)
    if self.bg.__shadow then
        self.bg.__shadow:SetBackdropBorderColor(0, 0, 0, 0.25)
    end

    if C.DB.Tooltip.BorderColor and self.GetItem then
        local _, item = self:GetItem()
        if item then
            local quality = select(3, GetItemInfo(item))
            local qualityColor = C.QualityColors[quality or 1]
            if qualityColor then
                self.bg:SetBackdropBorderColor(qualityColor.r, qualityColor.g, qualityColor.b, 0.6)
                if self.bg.__shadow then
                    self.bg.__shadow:SetBackdropBorderColor(qualityColor.r, qualityColor.g, qualityColor.b, 0.25)
                end
            end
        end
    end
end

local function RestyleFont(obj, font, size)
    local outline = _G.ANDROMEDA_ADB.FontOutline

    obj:SetFont(font, size, outline and 'OUTLINE')
    obj:SetShadowColor(0, 0, 0, 1)
    obj:SetShadowOffset(1, -1)
end

function TOOLTIP:FixRecipeItemNameWidth()
    local name = self:GetName()
    for i = 1, self:NumLines() do
        local line = _G[name .. 'TextLeft' .. i]
        if line:GetHeight() > 40 then
            line:SetWidth(line:GetWidth() + 1)
        end
    end
end

function TOOLTIP:SetupFonts()
    local textSize = 14
    local headerSize = 16

    RestyleFont(_G.GameTooltipHeaderText, C.Assets.Fonts.Bold, headerSize)
    RestyleFont(_G.GameTooltipText, C.Assets.Fonts.Regular, textSize)
    RestyleFont(_G.GameTooltipTextSmall, C.Assets.Fonts.Regular, textSize)

    if not _G.GameTooltip.hasMoney then
        _G.SetTooltipMoney(_G.GameTooltip, 1, nil, '', '')
        _G.SetTooltipMoney(_G.GameTooltip, 1, nil, '', '')
        _G.GameTooltip_ClearMoney(_G.GameTooltip)
    end

    if _G.GameTooltip.hasMoney then
        for i = 1, _G.GameTooltip.numMoneyFrames do
            RestyleFont(_G['GameTooltipMoneyFrame' .. i .. 'PrefixText'], C.Assets.Fonts.Regular, textSize)
            RestyleFont(_G['GameTooltipMoneyFrame' .. i .. 'SuffixText'], C.Assets.Fonts.Regular, textSize)
        end
    end

    for _, tt in ipairs(_G.GameTooltip.shoppingTooltips) do
        for i = 1, tt:GetNumRegions() do
            local region = select(i, tt:GetRegions())
            if region:IsObjectType('FontString') then
                RestyleFont(region, C.Assets.Fonts.Regular, textSize)
            end
        end
    end

    _G.GameTooltip:HookScript('OnTooltipSetItem', TOOLTIP.FixRecipeItemNameWidth)
end

-- Tooltip Registration
local tipTable = {}
function TOOLTIP:RegisterTooltips(addon, func)
    tipTable[addon] = func
end

TOOLTIP:RegisterTooltips(C.ADDON_NAME, function()
    local tooltips = {
        _G.ChatMenu,
        _G.EmoteMenu,
        _G.LanguageMenu,
        _G.VoiceMacroMenu,
        _G.GameTooltip,
        _G.EmbeddedItemTooltip,
        _G.ItemRefTooltip,
        _G.ItemRefShoppingTooltip1,
        _G.ItemRefShoppingTooltip2,
        _G.ShoppingTooltip1,
        _G.ShoppingTooltip2,
        _G.AutoCompleteBox,
        _G.FriendsTooltip,
        _G.QuestScrollFrame.StoryTooltip,
        _G.QuestScrollFrame.CampaignTooltip,
        _G.GeneralDockManagerOverflowButtonList,
        _G.ReputationParagonTooltip,
        _G.NamePlateTooltip,
        _G.QueueStatusFrame,
        _G.FloatingGarrisonFollowerTooltip,
        _G.FloatingGarrisonFollowerAbilityTooltip,
        _G.FloatingGarrisonMissionTooltip,
        _G.GarrisonFollowerAbilityTooltip,
        _G.GarrisonFollowerTooltip,
        _G.FloatingGarrisonShipyardFollowerTooltip,
        _G.GarrisonShipyardFollowerTooltip,
        _G.BattlePetTooltip,
        _G.PetBattlePrimaryAbilityTooltip,
        _G.PetBattlePrimaryUnitTooltip,
        _G.FloatingBattlePetTooltip,
        _G.FloatingPetBattleAbilityTooltip,
        _G.IMECandidatesFrame,
        _G.QuickKeybindTooltip,
        _G.GameSmallHeaderTooltip,
    }

    for _, tip in pairs(tooltips) do
        tip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    end

    -- DropdownMenu
    local dropdowns = { 'DropDownList', 'L_DropDownList', 'Lib_DropDownList' }
    local function reskinDropdown()
        for _, name in pairs(dropdowns) do
            for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
                local menu = _G[name .. i .. 'MenuBackdrop']
                if menu and not menu.styled then
                    menu:HookScript('OnShow', TOOLTIP.ReskinTooltip)
                    menu.styled = true
                end
            end
        end
    end
    hooksecurefunc('UIDropDownMenu_CreateFrames', reskinDropdown)

    -- IME
    _G.IMECandidatesFrame.selection:SetVertexColor(C.r, C.g, C.b)

    -- Pet Tooltip
    _G.PetBattlePrimaryUnitTooltip:HookScript('OnShow', function(self)
        self.Border:SetAlpha(0)
        if not self.iconStyled then
            if self.glow then
                self.glow:Hide()
            end
            self.Icon:SetTexCoord(unpack(C.TEX_COORD))
            self.iconStyled = true
        end
    end)

    hooksecurefunc('PetBattleUnitTooltip_UpdateForUnit', function(self)
        local nextBuff, nextDebuff = 1, 1
        for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
            local _, _, _, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
            if isBuff and self.Buffs then
                local frame = self.Buffs.frames[nextBuff]
                if frame and frame.Icon then
                    frame.Icon:SetTexCoord(unpack(C.TEX_COORD))
                end
                nextBuff = nextBuff + 1
            elseif not isBuff and self.Debuffs then
                local frame = self.Debuffs.frames[nextDebuff]
                if frame and frame.Icon then
                    frame.DebuffBorder:Hide()
                    frame.Icon:SetTexCoord(unpack(C.TEX_COORD))
                end
                nextDebuff = nextDebuff + 1
            end
        end
    end)

    -- Others
    F:Delay(5, function()
        -- BagSync
        if _G.BSYC_EventAlertTooltip then
            TOOLTIP.ReskinTooltip(_G.BSYC_EventAlertTooltip)
        end
        -- Lib
        if _G.LibDBIconTooltip then
            TOOLTIP.ReskinTooltip(_G.LibDBIconTooltip)
        end
        if _G.AceConfigDialogTooltip then
            TOOLTIP.ReskinTooltip(_G.AceConfigDialogTooltip)
        end
        -- TomTom
        if _G.TomTomTooltip then
            TOOLTIP.ReskinTooltip(_G.TomTomTooltip)
        end
        -- RareScanner
        if _G.RSMapItemToolTip then
            TOOLTIP.ReskinTooltip(_G.RSMapItemToolTip)
        end
        if _G.LootBarToolTip then
            TOOLTIP.ReskinTooltip(_G.LootBarToolTip)
        end
        -- Narcissus
        if _G.NarciGameTooltip then
            TOOLTIP.ReskinTooltip(_G.NarciGameTooltip)
        end
        -- Altoholic
        if _G.AltoTooltip then
            TOOLTIP.ReskinTooltip(_G.AltoTooltip)
        end
    end)

    if IsAddOnLoaded('BattlePetBreedID') then
        hooksecurefunc('BPBID_SetBreedTooltip', function(parent)
            if parent == _G.FloatingBattlePetTooltip then
                TOOLTIP.ReskinTooltip(_G.BPBID_BreedTooltip2)
            else
                TOOLTIP.ReskinTooltip(_G.BPBID_BreedTooltip)
            end
        end)
    end

    -- MDT and DT
    if _G.MDT and _G.MDT.ShowInterface then
        local styledMDT
        hooksecurefunc(_G.MDT, 'ShowInterface', function()
            if not styledMDT then
                TOOLTIP.ReskinTooltip(_G.MDT.tooltip)
                TOOLTIP.ReskinTooltip(_G.MDT.pullTooltip)
                styledMDT = true
            end
        end)
    end
end)

TOOLTIP:RegisterTooltips('Blizzard_DebugTools', function()
    TOOLTIP.ReskinTooltip(_G.FrameStackTooltip)
    _G.FrameStackTooltip:SetScale(_G.UIParent:GetScale())
end)

TOOLTIP:RegisterTooltips('Blizzard_EventTrace', function()
    TOOLTIP.ReskinTooltip(_G.EventTraceTooltip)
end)

TOOLTIP:RegisterTooltips('Blizzard_Collections', function()
    _G.PetJournalPrimaryAbilityTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    _G.PetJournalSecondaryAbilityTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    _G.PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
    _G.PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
    _G.PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
    _G.PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
end)

TOOLTIP:RegisterTooltips('Blizzard_GarrisonUI', function()
    local gt = {
        _G.GarrisonMissionMechanicTooltip,
        _G.GarrisonMissionMechanicFollowerCounterTooltip,
        _G.GarrisonShipyardMapMissionTooltip,
        _G.GarrisonBonusAreaTooltip,
        _G.GarrisonBuildingFrame.BuildingLevelTooltip,
        _G.GarrisonFollowerAbilityWithoutCountersTooltip,
        _G.GarrisonFollowerMissionAbilityWithoutCountersTooltip,
    }
    for _, f in pairs(gt) do
        f:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    end
end)

TOOLTIP:RegisterTooltips('Blizzard_PVPUI', function()
    _G.ConquestTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
end)

TOOLTIP:RegisterTooltips('Blizzard_Contribution', function()
    _G.ContributionBuffTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    _G.ContributionBuffTooltip.Icon:SetTexCoord(unpack(C.TEX_COORD))
    _G.ContributionBuffTooltip.Border:SetAlpha(0)
end)

TOOLTIP:RegisterTooltips('Blizzard_EncounterJournal', function()
    _G.EncounterJournalTooltip:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    _G.EncounterJournalTooltip.Item1.icon:SetTexCoord(unpack(C.TEX_COORD))
    _G.EncounterJournalTooltip.Item1.IconBorder:SetAlpha(0)
    _G.EncounterJournalTooltip.Item2.icon:SetTexCoord(unpack(C.TEX_COORD))
    _G.EncounterJournalTooltip.Item2.IconBorder:SetAlpha(0)
end)

TOOLTIP:RegisterTooltips('Blizzard_Calendar', function()
    _G.CalendarContextMenu:HookScript('OnShow', TOOLTIP.ReskinTooltip)
    _G.CalendarInviteStatusContextMenu:HookScript('OnShow', TOOLTIP.ReskinTooltip)
end)

function TOOLTIP:AddonStyled(addon)
    if tipTable[addon] then
        tipTable[addon]()
        tipTable[addon] = nil
    end
end
F:RegisterEvent('ADDON_LOADED', TOOLTIP.AddonStyled)
