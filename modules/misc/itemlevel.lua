local F, C = unpack(select(2, ...))
local IL = F:RegisterModule('ItemLevel')
local TT = F:GetModule('Tooltip')

local inspectSlots = {
    'Head',
    'Neck',
    'Shoulder',
    'Shirt',
    'Chest',
    'Waist',
    'Legs',
    'Feet',
    'Wrist',
    'Hands',
    'Finger0',
    'Finger1',
    'Trinket0',
    'Trinket1',
    'Back',
    'MainHand',
    'SecondaryHand'
}

function IL:GetSlotAnchor(index)
    if not index then
        return
    end

    if index <= 5 or index == 9 or index == 15 then
        return 'BOTTOMLEFT', 40, 20
    elseif index == 16 then
        return 'BOTTOMRIGHT', -40, 2
    elseif index == 17 then
        return 'BOTTOMLEFT', 40, 2
    else
        return 'BOTTOMRIGHT', -40, 20
    end
end

function IL:CreateItemTexture(slot, relF, x, y)
    local icon = slot:CreateTexture()
    icon:SetPoint(relF, x, y)
    icon:SetSize(14, 14)
    icon:SetTexCoord(unpack(C.TexCoord))
    icon.bg = F.ReskinIcon(icon)
    icon.bg:SetFrameLevel(3)
    icon.bg:Hide()

    return icon
end

function IL:CreateItemString(frame, strType)
    if frame.fontCreated then
        return
    end

    for index, slot in pairs(inspectSlots) do
        if index ~= 4 then
            local slotFrame = _G[strType .. slot .. 'Slot']
            slotFrame.iLvlText = F.CreateFS(slotFrame, C.Assets.Fonts.Condensed, 11, true, '', nil, true)
            slotFrame.iLvlText:ClearAllPoints()
            slotFrame.iLvlText:SetPoint('BOTTOMRIGHT', slotFrame, -1, 1)
            local relF, x, y = IL:GetSlotAnchor(index)
            slotFrame.enchantText = F.CreateFS(slotFrame, C.Assets.Fonts.Condensed, 11, nil, '', nil, true)
            slotFrame.enchantText:ClearAllPoints()
            slotFrame.enchantText:SetPoint(relF, slotFrame, x, y)
            slotFrame.enchantText:SetTextColor(0, 1, 0)
            for i = 1, 10 do
                local offset = (i - 1) * 18 + 5
                local iconX = x > 0 and x + offset or x - offset
                local iconY = index > 15 and 20 or 2
                slotFrame['textureIcon' .. i] = IL:CreateItemTexture(slotFrame, relF, iconX, iconY)
            end
        end
    end

    frame.fontCreated = true
end

local azeriteSlots = {
    [1] = true,
    [3] = true,
    [5] = true
}

local locationCache = {}
local function GetSlotItemLocation(id)
    if not azeriteSlots[id] then
        return
    end

    local itemLocation = locationCache[id]
    if not itemLocation then
        itemLocation = _G.ItemLocation:CreateFromEquipmentSlot(id)
        locationCache[id] = itemLocation
    end
    return itemLocation
end

function IL:ItemLevel_UpdateTraits(button, id, link)
    local empoweredItemLocation = GetSlotItemLocation(id)
    if not empoweredItemLocation then
        return
    end

    local allTierInfo = TT:Azerite_UpdateTier(link)
    if not allTierInfo then
        return
    end

    for i = 1, 2 do
        local powerIDs = allTierInfo[i] and allTierInfo[i].azeritePowerIDs
        if not powerIDs or powerIDs[1] == 13 then
            break
        end

        for _, powerID in pairs(powerIDs) do
            local selected = C_AzeriteEmpoweredItem.IsPowerSelected(empoweredItemLocation, powerID)
            if selected then
                local spellID = TT:Azerite_PowerToSpell(powerID)
                local name, _, icon = GetSpellInfo(spellID)
                local texture = button['textureIcon' .. i]
                if name and texture then
                    texture:SetTexture(icon)
                    texture.bg:Show()
                end
            end
        end
    end
end

function IL:ItemLevel_UpdateInfo(slotFrame, info, quality)
    local infoType = type(info)
    local level
    if infoType == 'table' then
        level = info.iLvl
    else
        level = info
    end

    if level and level > 1 and quality and quality > 1 then
        local color = C.QualityColors[quality]
        slotFrame.iLvlText:SetText(level)
        slotFrame.iLvlText:SetTextColor(color.r, color.g, color.b)
    end

    if infoType == 'table' then
        local enchant = info.enchantText
        if enchant then
            slotFrame.enchantText:SetText(enchant)
        end

        local gemStep, essenceStep = 1, 1
        for i = 1, 10 do
            local texture = slotFrame['textureIcon' .. i]
            local bg = texture.bg
            local gem = info.gems and info.gems[gemStep]
            local essence = not gem and (info.essences and info.essences[essenceStep])
            if gem then
                texture:SetTexture(gem)
                bg:SetBackdropBorderColor(0, 0, 0)
                bg:Show()

                gemStep = gemStep + 1
            elseif essence and next(essence) then
                local r = essence[4]
                local g = essence[5]
                local b = essence[6]
                if r and g and b then
                    bg:SetBackdropBorderColor(r, g, b)
                else
                    bg:SetBackdropBorderColor(0, 0, 0)
                end

                local selected = essence[1]
                texture:SetTexture(selected)
                bg:Show()

                essenceStep = essenceStep + 1
            end
        end
    end
end

function IL:ItemLevel_RefreshInfo(link, unit, index, slotFrame)
    C_Timer.After(
        .1,
        function()
            local quality = select(3, GetItemInfo(link))
            local info = F.GetItemLevel(link, unit, index, C.DB.General.GemEnchant)
            if info == 'tooSoon' then
                return
            end
            IL:ItemLevel_UpdateInfo(slotFrame, info, quality)
        end
    )
end

function IL:ItemLevel_SetupLevel(frame, strType, unit)
    if not UnitExists(unit) then
        return
    end

    IL:CreateItemString(frame, strType)

    for index, slot in pairs(inspectSlots) do
        if index ~= 4 then
            local slotFrame = _G[strType .. slot .. 'Slot']
            slotFrame.iLvlText:SetText('')
            slotFrame.enchantText:SetText('')
            for i = 1, 10 do
                local texture = slotFrame['textureIcon' .. i]
                texture:SetTexture(nil)
                texture.bg:Hide()
            end

            local link = GetInventoryItemLink(unit, index)
            if link then
                local quality = select(3, GetItemInfo(link))
                local info = F.GetItemLevel(link, unit, index, C.DB.General.GemEnchant)
                if info == 'tooSoon' then
                    IL:ItemLevel_RefreshInfo(link, unit, index, slotFrame)
                else
                    IL:ItemLevel_UpdateInfo(slotFrame, info, quality)
                end

                if strType == 'Character' then
                    IL:ItemLevel_UpdateTraits(slotFrame, index, link)
                end
            end
        end
    end
end

function IL:ItemLevel_UpdatePlayer()
    IL:ItemLevel_SetupLevel(_G.CharacterFrame, 'Character', 'player')
end

function IL:ItemLevel_UpdateInspect(...)
    local guid = ...
    if _G.InspectFrame and _G.InspectFrame.unit and UnitGUID(_G.InspectFrame.unit) == guid then
        IL:ItemLevel_SetupLevel(_G.InspectFrame, 'Inspect', _G.InspectFrame.unit)
    end
end

function IL:ItemLevel_FlyoutUpdate(bag, slot, quality)
    if not self.iLvl then
        self.iLvl = F.CreateFS(self, C.Assets.Fonts.Condensed, 11, true, '', nil, true, 'BOTTOMRIGHT', -1, 1)
    end

    if quality and quality <= 1 then
        return
    end

    local link, level
    if bag then
        link = GetContainerItemLink(bag, slot)
        level = F.GetItemLevel(link, bag, slot)
    else
        link = GetInventoryItemLink('player', slot)
        level = F.GetItemLevel(link, 'player', slot)
    end

    local color = C.QualityColors[quality or 0]
    self.iLvl:SetText(level)
    self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function IL:ItemLevel_FlyoutSetup()
    if self.iLvl then
        self.iLvl:SetText('')
    end

    local location = self.location
    if not location then
        return
    end

    if tonumber(location) then
        if location >= _G.EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
            return
        end

        local _, _, bags, voidStorage, slot, bag = _G.EquipmentManager_UnpackLocation(location)
        if voidStorage then
            return
        end
        local quality = select(13, _G.EquipmentManager_GetItemInfoByLocation(location))
        if bags then
            IL.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
        else
            IL.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
        end
    else
        local itemLocation = self:GetItemLocation()
        local quality = itemLocation and C_Item.GetItemQuality(itemLocation)
        if itemLocation:IsBagAndSlot() then
            local bag, slot = itemLocation:GetBagAndSlot()
            IL.ItemLevel_FlyoutUpdate(self, bag, slot, quality)
        elseif itemLocation:IsEquipmentSlot() then
            local slot = itemLocation:GetEquipmentSlot()
            IL.ItemLevel_FlyoutUpdate(self, nil, slot, quality)
        end
    end
end

function IL:ItemLevel_ScrappingUpdate()
    if not self.iLvl then
        self.iLvl = F.CreateFS(self, C.Assets.Fonts.Condensed, 11, true, '', nil, true, 'BOTTOMRIGHT', -1, 1)
    end
    if not self.itemLink then
        self.iLvl:SetText('')
        return
    end

    local quality = 1
    if self.itemLocation and not self.item:IsItemEmpty() and self.item:GetItemName() then
        quality = self.item:GetItemQuality()
    end
    local level = F.GetItemLevel(self.itemLink)
    local color = C.QualityColors[quality]
    self.iLvl:SetText(level)
    self.iLvl:SetTextColor(color.r, color.g, color.b)
end

function IL.ItemLevel_ScrappingShow(event, addon)
    if addon == 'Blizzard_ScrappingMachineUI' then
        for button in pairs(_G.ScrappingMachineFrame.ItemSlots.scrapButtons.activeObjects) do
            hooksecurefunc(button, 'RefreshIcon', IL.ItemLevel_ScrappingUpdate)
        end

        F:UnregisterEvent(event, IL.ItemLevel_ScrappingShow)
    end
end

function IL:ItemLevel_UpdateMerchant(link)
    if not self.iLvl then
        self.iLvl = F.CreateFS(self.ItemButton, C.Assets.Fonts.Condensed, 11, true, '', nil, true, 'BOTTOMRIGHT', -1, 1)
    end
    local quality = link and select(3, GetItemInfo(link)) or nil
    if quality and quality > 1 then
        local level = F.GetItemLevel(link)
        local color = C.QualityColors[quality]
        self.iLvl:SetText(level)
        self.iLvl:SetTextColor(color.r, color.g, color.b)
    end
end

function IL:OnLogin()
    if not C.DB.General.ItemLevel then
        return
    end

    -- iLvl on CharacterFrame
    _G.CharacterFrame:HookScript('OnShow', IL.ItemLevel_UpdatePlayer)
    F:RegisterEvent('PLAYER_EQUIPMENT_CHANGED', IL.ItemLevel_UpdatePlayer)

    -- iLvl on InspectFrame
    F:RegisterEvent('INSPECT_READY', IL.ItemLevel_UpdateInspect)

    -- iLvl on FlyoutButtons
    hooksecurefunc(
        'EquipmentFlyout_UpdateItems',
        function()
            for _, button in pairs(_G.EquipmentFlyoutFrame.buttons) do
                if button:IsShown() then
                    IL.ItemLevel_FlyoutSetup(button)
                end
            end
        end
    )

    -- iLvl on ScrappingMachineFrame
    F:RegisterEvent('ADDON_LOADED', IL.ItemLevel_ScrappingShow)

    -- iLvl on MerchantFrame
    hooksecurefunc('MerchantFrameItem_UpdateQuality', IL.ItemLevel_UpdateMerchant)
end
