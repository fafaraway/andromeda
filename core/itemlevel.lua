local F = unpack(select(2, ...))

local iLvlDB = {}
local itemLevelString = '^' .. string.gsub(_G.ITEM_LEVEL, '%%d', '')
local enchantString = string.gsub(_G.ENCHANTED_TOOLTIP_LINE, '%%s', '(.+)')
local essenceTextureID = 2975691
local essenceDescription = GetSpellDescription(277253)

local tip = CreateFrame('GameTooltip', 'FreeUIScanTooltip', nil, 'GameTooltipTemplate')
F.ScanTip = tip

function F:InspectItemTextures()
    if not tip.gems then
        tip.gems = {}
    else
        table.wipe(tip.gems)
    end

    if not tip.essences then
        tip.essences = {}
    else
        for _, essences in pairs(tip.essences) do
            table.wipe(essences)
        end
    end

    local step = 1
    for i = 1, 10 do
        local tex = _G[tip:GetName() .. 'Texture' .. i]
        local texture = tex and tex:IsShown() and tex:GetTexture()
        if texture then
            if texture == essenceTextureID then
                local selected = (tip.gems[i - 1] ~= essenceTextureID and tip.gems[i - 1]) or nil
                if not tip.essences[step] then
                    tip.essences[step] = {}
                end
                tip.essences[step][1] = selected -- essence texture if selected or nil
                tip.essences[step][2] = tex:GetAtlas() -- atlas place 'tooltip-heartofazerothessence-major' or 'tooltip-heartofazerothessence-minor'
                tip.essences[step][3] = texture -- border texture placed by the atlas

                step = step + 1
                if selected then
                    tip.gems[i - 1] = nil
                end
            else
                tip.gems[i] = texture
            end
        end
    end

    return tip.gems, tip.essences
end

function F:InspectItemInfo(text, slotInfo)
    local itemLevel = string.find(text, itemLevelString) and string.match(text, '(%d+)%)?$')
    if itemLevel then
        slotInfo.iLvl = tonumber(itemLevel)
    end

    local enchant = string.match(text, enchantString)
    if enchant then
        slotInfo.enchantText = enchant
    end
end

function F:CollectEssenceInfo(index, lineText, slotInfo)
    local step = 1
    local essence = slotInfo.essences[step]
    if
        essence
        and next(essence)
        and (
            string.find(lineText, _G.ITEM_SPELL_TRIGGER_ONEQUIP, nil, true)
            and string.find(lineText, essenceDescription, nil, true)
        )
    then
        for i = 5, 2, -1 do
            local line = _G[tip:GetName() .. 'TextLeft' .. index - i]
            local text = line and line:GetText()

            if text and (not string.match(text, '^[ +]')) and essence and next(essence) then
                local r, g, b = line:GetTextColor()
                essence[4] = r
                essence[5] = g
                essence[6] = b

                step = step + 1
                essence = slotInfo.essences[step]
            end
        end
    end
end

function F.GetItemLevel(link, arg1, arg2, fullScan)
    if fullScan then
        tip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
        tip:SetInventoryItem(arg1, arg2)

        if not tip.slotInfo then
            tip.slotInfo = {}
        else
            table.wipe(tip.slotInfo)
        end

        local slotInfo = tip.slotInfo
        slotInfo.gems, slotInfo.essences = F:InspectItemTextures()

        for i = 1, tip:NumLines() do
            local line = _G[tip:GetName() .. 'TextLeft' .. i]
            if not line then
                break
            end

            local text = line:GetText()
            if text then
                if i == 1 and text == _G.RETRIEVING_ITEM_INFO then
                    return 'tooSoon'
                else
                    F:InspectItemInfo(text, slotInfo)
                    F:CollectEssenceInfo(i, text, slotInfo)
                end
            end
        end

        return slotInfo
    else
        if iLvlDB[link] then
            return iLvlDB[link]
        end

        tip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
        if arg1 and type(arg1) == 'string' then
            tip:SetInventoryItem(arg1, arg2)
        elseif arg1 and type(arg1) == 'number' then
            tip:SetBagItem(arg1, arg2)
        else
            tip:SetHyperlink(link)
        end

        local firstLine = _G.FreeUIScanTooltipTextLeft1:GetText()
        if firstLine == _G.RETRIEVING_ITEM_INFO then
            return 'tooSoon'
        end

        for i = 2, 5 do
            local line = _G[tip:GetName() .. 'TextLeft' .. i]
            if not line then
                break
            end

            local text = line:GetText()
            local found = text and string.find(text, itemLevelString)
            if found then
                local level = string.match(text, '(%d+)%)?$')
                iLvlDB[link] = tonumber(level)
                break
            end
        end

        return iLvlDB[link]
    end
end
