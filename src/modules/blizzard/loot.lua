-- Credit: Haste
-- https://github.com/haste/Butsu

local F, C, L = unpack(select(2, ...))
local EL = F:RegisterModule('EnhancedLoot')
local LBG = F.Libs.LBG

local lootFrame
local iconSize = 32
local slotWidth = 160
local slotHeight = 64

local coinTextureIDs = {
    [133784] = true,
    [133785] = true,
    [133786] = true,
    [133787] = true,
    [133788] = true,
    [133789] = true,
}

local function OnEnter(slot)
    local id = slot:GetID()
    if LootSlotHasItem(id) then
        _G.GameTooltip:SetOwner(slot, 'ANCHOR_RIGHT')
        _G.GameTooltip:SetLootItem(id)

        CursorUpdate(slot)
    end

    slot.drop:Show()
    slot.drop:SetVertexColor(1, 1, 0)
end

local function OnLeave(slot)
    if slot.quality and (slot.quality > 1) then
        local color = _G.ITEM_QUALITY_COLORS[slot.quality]
        slot.drop:SetVertexColor(color.r, color.g, color.b)
    else
        slot.drop:Hide()
    end

    _G.GameTooltip:Hide()

    ResetCursor()
end

local function OnClick(slot)
    local frame = _G.LootFrame
    frame.selectedQuality = slot.quality
    frame.selectedItemName = slot.name:GetText()
    frame.selectedTexture = slot.icon:GetTexture()
    frame.selectedLootButton = slot:GetName()
    frame.selectedSlot = slot:GetID()

    if IsModifiedClick() then
        _G.HandleModifiedItemClick(GetLootSlotLink(frame.selectedSlot))
    else
        StaticPopup_Hide('CONFIRM_LOOT_DISTRIBUTION')
        LootSlot(frame.selectedSlot)
    end
end

local function OnShow(slot)
    if _G.GameTooltip:IsOwned(slot) then
        _G.GameTooltip:SetOwner(slot, 'ANCHOR_RIGHT')
        _G.GameTooltip:SetLootItem(slot:GetID())

        CursorOnUpdate(slot)
    end
end

local function CreateLootSlot(id)
    local size = (iconSize - 2)

    local frame = CreateFrame('Button', C.ADDON_TITLE .. 'LootSlot' .. id, lootFrame)
    frame:SetPoint('LEFT', 8, 0)
    frame:SetPoint('RIGHT', -8, 0)
    frame:SetHeight(size)
    frame:SetID(id)
    frame.bg = F.SetBD(frame)

    frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    frame:SetScript('OnEnter', OnEnter)
    frame:SetScript('OnLeave', OnLeave)
    frame:SetScript('OnClick', OnClick)
    frame:SetScript('OnShow', OnShow)

    local iconFrame = CreateFrame('Frame', nil, frame)
    iconFrame:SetSize(size, size)
    iconFrame:SetPoint('RIGHT', frame, 'LEFT', -4, 0)
    iconFrame.bg = F.SetBD(iconFrame)
    frame.iconFrame = iconFrame

    local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TEX_COORD))
    icon:SetInside(iconFrame)
    frame.icon = icon

    local outline = _G.ANDROMEDA_ADB.FontOutline

    local count = F.CreateFS(iconFrame, C.Assets.Fonts.Regular, 12, true, nil, nil, true, 'TOP', 1, -2)
    frame.count = count

    local name = F.CreateFS(frame, C.Assets.Fonts.Regular, 12, outline, nil, nil, outline or 'THICK')
    name:SetPoint('RIGHT', frame)
    name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
    name:SetJustifyH('LEFT')
    name:SetNonSpaceWrap(true)
    frame.name = name

    local drop = frame:CreateTexture(nil, 'ARTWORK')
    drop:SetTexture('Interface\\QuestFrame\\UI-QuestLogTitleHighlight')
    drop:SetPoint('LEFT', icon, 'RIGHT', 0, 0)
    drop:SetPoint('RIGHT', frame)
    drop:SetAllPoints(frame)
    drop:SetAlpha(0.3)
    frame.drop = drop

    local questTexture = iconFrame:CreateTexture(nil, 'OVERLAY')
    questTexture:SetInside()
    questTexture:SetTexture(_G.TEXTURE_ITEM_QUEST_BANG)
    questTexture:SetTexCoord(unpack(C.TEX_COORD))
    frame.questTexture = questTexture

    lootFrame.slots[id] = frame

    return frame
end

local function AnchorLootSlots(frame)
    local shownSlots = 0

    for _, slot in next, frame.slots do
        if slot:IsShown() then
            shownSlots = shownSlots + 1

            slot:SetPoint('TOP', lootFrame, 4, (-8 + iconSize) - (shownSlots * (iconSize + 4)))
        end
    end

    frame:SetHeight(max(shownSlots * iconSize + 16, 20))
end

function EL.LOOT_CLOSED()
    StaticPopup_Hide('LOOT_BIND')
    lootFrame:Hide()

    for _, slot in next, lootFrame.slots do
        slot:Hide()
    end
end

function EL.LOOT_OPENED(_, autoloot)
    lootFrame:Show()

    if not lootFrame:IsShown() then
        CloseLoot(not autoloot)
    end

    if IsFishingLoot() then
        lootFrame.title:SetText(L['Fishy Loot'])
    elseif not UnitIsFriend('player', 'target') and UnitIsDead('target') then
        lootFrame.title:SetText(UnitName('target'))
    else
        lootFrame.title:SetText(_G.LOOT)
    end

    local x, y = GetCursorPosition()
    x = x / lootFrame:GetEffectiveScale()
    y = y / lootFrame:GetEffectiveScale()

    lootFrame:ClearAllPoints()
    lootFrame:SetPoint('TOPLEFT', _G.UIParent, 'BOTTOMLEFT', x - 40, y + 20)
    lootFrame:Raise()

    local maxQuality = 0
    local maxWidth = 0
    local numItems = GetNumLootItems()

    if numItems > 0 then
        for i = 1, numItems do
            local slot = lootFrame.slots[i] or CreateLootSlot(i)
            local lootIcon, lootName, lootQuantity, _, lootQuality, _, isQuestItem, questID, isActive = GetLootSlotInfo(i)
            local color = _G.ITEM_QUALITY_COLORS[lootQuality or 0]

            if coinTextureIDs[lootIcon] then
                lootName = lootName:gsub('\n', ', ')
            end

            if lootIcon then
                if GetLootSlotType(i) == _G.LOOT_SLOT_MONEY then
                    lootName = lootName:gsub('\n', ', ')
                end

                if lootQuantity and lootQuantity > 1 then
                    slot.count:SetText(lootQuantity)
                    slot.count:Show()
                else
                    slot.count:Hide()
                end

                if lootQuality and (lootQuality > 1) then
                    slot.iconFrame.bg:SetBackdropBorderColor(color.r, color.g, color.b)
                    if slot.iconFrame.bg.__shadow then
                        slot.iconFrame.bg.__shadow:SetBackdropBorderColor(color.r, color.g, color.b, 0.25)
                    end

                    slot.drop:SetVertexColor(color.r, color.g, color.b)
                    slot.drop:Show()
                else
                    slot.iconFrame.bg:SetBackdropBorderColor(0, 0, 0)
                    if slot.iconFrame.bg.__shadow then
                        slot.iconFrame.bg.__shadow:SetBackdropBorderColor(0, 0, 0, 0.25)
                    end

                    slot.drop:Hide()
                end

                slot.quality = lootQuality
                slot.name:SetTextColor(color.r, color.g, color.b)
                slot.icon:SetTexture(lootIcon)
                -- slot.name:SetWordWrap(false)

                if lootQuantity > 1 then
                    slot.name:SetText(lootName .. ' (' .. lootQuantity .. ')')
                else
                    slot.name:SetText(lootName)
                end

                maxWidth = max(maxWidth, slot.name:GetStringWidth())

                if lootQuality then
                    maxQuality = max(maxQuality, lootQuality)
                end

                local questTexture = slot.questTexture
                if questID and not isActive then
                    questTexture:Show()
                    LBG.ShowOverlayGlow(slot.iconFrame)
                elseif questID or isQuestItem then
                    questTexture:Hide()
                    LBG.ShowOverlayGlow(slot.iconFrame)
                else
                    questTexture:Hide()
                    LBG.HideOverlayGlow(slot.iconFrame)
                end

                if lootIcon then
                    slot:Enable()
                    slot:Show()
                end
            end
        end
    else
        local slot = lootFrame.slots[1] or CreateLootSlot(1)
        local color = _G.ITEM_QUALITY_COLORS[0]

        slot.name:SetText(L['No Loot'])
        slot.name:SetTextColor(color.r, color.g, color.b)
        slot.icon:SetTexture()

        maxWidth = max(maxWidth, slot.name:GetStringWidth())

        slot.count:Hide()
        slot.drop:Hide()
        slot:Disable()
        slot:Show()
    end

    AnchorLootSlots(lootFrame)

    lootFrame:SetWidth(max(maxWidth + 60, lootFrame.title:GetStringWidth() + 5))
end

function EL.LOOT_SLOT_CLEARED(_, id)
    if not lootFrame:IsShown() then
        return
    end

    local slot = lootFrame.slots[id]
    if slot then
        slot:Hide()
    end

    AnchorLootSlots(lootFrame)
end

function EL.OPEN_MASTER_LOOT_LIST()
    MasterLooterFrame_Show(_G.LootFrame.selectedLootButton)
end

function EL.UPDATE_MASTER_LOOT_LIST()
    if _G.LootFrame.selectedLootButton then
        MasterLooterFrame_UpdatePlayers()
    end
end

local function OnHide()
    StaticPopup_Hide('CONFIRM_LOOT_DISTRIBUTION')
    CloseLoot()

    if _G.MasterLooterFrame then
        _G.MasterLooterFrame:Hide()
    end
end

do -- Faster auto loot
    local tDelay = 0
    local lootDelay = 0.3

    function EL.LOOT_READY()
        if GetCVarBool('autoLootDefault') ~= IsModifiedClick('AUTOLOOTTOGGLE') then
            if (GetTime() - tDelay) >= lootDelay then
                for i = GetNumLootItems(), 1, -1 do
                    LootSlot(i)
                end

                tDelay = GetTime()
            end
        end
    end
end

function EL:OnLogin()
    if C.DB.General.FasterAutoLoot then
        F:RegisterEvent('LOOT_READY', EL.LOOT_READY)
    end

    if not C.DB.General.EnhancedLoot then
        return
    end

    lootFrame = CreateFrame('Button', C.ADDON_TITLE .. 'LootFrame', _G.UIParent)
    lootFrame:SetFrameStrata('HIGH')
    lootFrame:SetClampedToScreen(true)
    lootFrame:SetSize(slotWidth, slotHeight)
    lootFrame:SetClampedToScreen(true)
    lootFrame:SetFrameStrata(_G.LootFrame:GetFrameStrata())
    lootFrame:SetToplevel(true)
    lootFrame:Hide()
    lootFrame:SetScript('OnHide', OnHide)

    lootFrame.title = F.CreateFS(lootFrame, C.Assets.Fonts.Bold, 12, 'OUTLINE')
    lootFrame.title:SetPoint('BOTTOMLEFT', lootFrame, 'TOPLEFT')

    lootFrame.slots = {}

    _G.LootFrame:UnregisterAllEvents()
    tinsert(_G.UISpecialFrames, C.ADDON_TITLE .. 'LootFrame')

    -- fix blizzard setpoint connection
    hooksecurefunc(_G.MasterLooterFrame, 'Hide', _G.MasterLooterFrame.ClearAllPoints)

    F:RegisterEvent('LOOT_OPENED', EL.LOOT_OPENED)
    F:RegisterEvent('LOOT_SLOT_CLEARED', EL.LOOT_SLOT_CLEARED)
    F:RegisterEvent('LOOT_CLOSED', EL.LOOT_CLOSED)
    F:RegisterEvent('OPEN_MASTER_LOOT_LIST', EL.OPEN_MASTER_LOOT_LIST)
    F:RegisterEvent('UPDATE_MASTER_LOOT_LIST', EL.UPDATE_MASTER_LOOT_LIST)
end
