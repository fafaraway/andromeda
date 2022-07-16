local F, C = unpack(select(2, ...))
local EL = F:RegisterModule('EnhancedLoot')

local iconsize = 32
local width = 140
local sq, ss, sn, st

local lootFrame = CreateFrame('Button', C.ADDON_TITLE .. 'LootFrame', _G.UIParent, 'BackdropTemplate')
lootFrame:SetFrameStrata('HIGH')
lootFrame:SetClampedToScreen(true)
lootFrame:SetWidth(width)
lootFrame:SetHeight(64)
lootFrame:Hide()
tinsert(_G.UISpecialFrames, C.ADDON_TITLE .. 'LootFrame')

lootFrame.slots = {}

local OnEnter = function(self)
    local slot = self:GetID()
    if GetLootSlotType(slot) == _G.LOOT_SLOT_ITEM then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:SetLootItem(slot)
        _G.CursorUpdate(self)
    end
end

local OnLeave = function(self)
    _G.GameTooltip:Hide()
    ResetCursor()
end

local OnClick = function(self)
    if IsModifiedClick() then
        _G.HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
    else
        _G.StaticPopup_Hide('CONFIRM_LOOT_DISTRIBUTION')
        ss = self:GetID()
        sq = self.quality
        sn = self.name:GetText()
        st = self.icon:GetTexture()

        _G.LootFrame.selectedLootButton = self:GetName()
        _G.LootFrame.selectedSlot = ss
        _G.LootFrame.selectedQuality = sq
        _G.LootFrame.selectedItemName = sn
        _G.LootFrame.selectedTexture = st

        LootSlot(ss)
    end
end

local OnUpdate = function(self)
    if _G.GameTooltip:IsOwned(self) then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:SetLootItem(self:GetID())
        _G.CursorOnUpdate(self)
    end
end

local CreateLootSlot = function(id)
    local frame = CreateFrame('Button', C.ADDON_TITLE .. 'LootSlot' .. id, lootFrame, 'BackdropTemplate')
    frame:SetPoint('TOP', lootFrame, 0, -((id - 1) * (iconsize + 1)))
    frame:SetPoint('RIGHT')
    frame:SetPoint('LEFT')
    frame:SetHeight(24)
    frame:SetFrameStrata('HIGH')
    frame:SetFrameLevel(20)
    frame:SetID(id)
    lootFrame.slots[id] = frame

    frame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    frame:SetScript('OnEnter', OnEnter)
    frame:SetScript('OnLeave', OnLeave)
    frame:SetScript('OnClick', OnClick)
    frame:SetScript('OnUpdate', OnUpdate)

    frame.bg = F.SetBD(frame)

    local iconFrame = CreateFrame('Frame', nil, frame)
    iconFrame:SetHeight(iconsize)
    iconFrame:SetWidth(iconsize)
    iconFrame:SetFrameStrata('HIGH')
    iconFrame:SetFrameLevel(20)
    iconFrame:ClearAllPoints()
    iconFrame:SetPoint('RIGHT', frame, 'LEFT', -4, 0)
    iconFrame.bg = F.SetBD(iconFrame)
    frame.iconFrame = iconFrame

    local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TEX_COORD))
    icon:SetInside(iconFrame)
    frame.icon = icon

    local outline = _G.ANDROMEDA_ADB.FontOutline

    local count = F.CreateFS(iconFrame, C.Assets.Font.Regular, 12, true, nil, nil, true, 'TOP', 1, -2)
    frame.count = count

    local name = F.CreateFS(frame, C.Assets.Font.Regular, 12, outline, nil, nil, outline or 'THICK')
    name:SetPoint('RIGHT', frame)
    name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
    name:SetJustifyH('LEFT')
    name:SetNonSpaceWrap(true)
    frame.name = name

    return frame
end

local AnchorLootSlots = function(self)
    local shownSlots = 0
    for i = 1, #self.slots do
        local frame = self.slots[i]
        if frame:IsShown() then
            shownSlots = shownSlots + 1

            frame:SetPoint('TOP', lootFrame, 4, (-8 + iconsize) - (shownSlots * (iconsize + 4)))
        end
    end

    self:SetHeight(max(shownSlots * iconsize + 16, 20))
end

lootFrame.LOOT_CLOSED = function(self)
    _G.StaticPopup_Hide('LOOT_BIND')
    self:Hide()

    for _, v in next, self.slots do
        v:Hide()
    end
end

lootFrame.LOOT_OPENED = function(self, _, autoloot)
    self:Show()

    if not self:IsShown() then
        CloseLoot(not autoloot)
    end

    local x, y = GetCursorPosition()
    x = x / self:GetEffectiveScale()
    y = y / self:GetEffectiveScale()

    self:ClearAllPoints()
    self:SetPoint('TOPLEFT', nil, 'BOTTOMLEFT', x - 40, y + 20)
    self:Raise()

    local maxQuality = 0
    local items = GetNumLootItems()

    if items > 0 then
        for i = 1, items do
            local slot = lootFrame.slots[i] or CreateLootSlot(i)
            local lootIcon, lootName, lootQuantity, _, lootQuality, _, isQuestItem, questID, isActive = GetLootSlotInfo(
                i
            )
            if lootIcon then
                local color = _G.ITEM_QUALITY_COLORS[lootQuality]
                local r, g, b = color.r, color.g, color.b

                if GetLootSlotType(i) == _G.LOOT_SLOT_MONEY then
                    lootName = lootName:gsub('\n', ', ')
                end

                if lootQuantity and lootQuantity > 1 then
                    slot.count:SetText(lootQuantity)
                    slot.count:Show()
                else
                    slot.count:Hide()
                end

                if lootQuality == 0 or lootQuality == 1 then
                    slot.iconFrame.bg:SetBackdropBorderColor(0, 0, 0)
                    if slot.iconFrame.bg.__shadow then
                        slot.iconFrame.bg.__shadow:SetBackdropBorderColor(0, 0, 0, 0.25)
                    end
                else
                    slot.iconFrame.bg:SetBackdropBorderColor(r, g, b)
                    if slot.iconFrame.bg.__shadow then
                        slot.iconFrame.bg.__shadow:SetBackdropBorderColor(r, g, b, 0.25)
                    end
                end

                if questID and not isActive then
                    slot.bg:SetBackdropColor(0.5, 0.5, 0, 0.5)
                    slot.name:SetTextColor(1, 1, 0)
                elseif questID or isQuestItem then
                    slot.bg:SetBackdropColor(0.5, 0.5, 0, 0.5)
                    slot.name:SetTextColor(r, g, b)
                else
                    slot.bg:SetBackdropColor(0, 0, 0, 0.5)
                    slot.name:SetTextColor(r, g, b)
                end

                slot.lootQuality = lootQuality
                slot.isQuestItem = isQuestItem

                if lootQuantity > 1 then
                    slot.name:SetText(lootName .. ' (' .. lootQuantity .. ')')
                else
                    slot.name:SetText(lootName)
                end

                slot.name:SetWordWrap(false)
                slot.icon:SetTexture(lootIcon)

                maxQuality = max(maxQuality, lootQuality)

                slot:Enable()
                slot:Show()
            end
        end
    else
        self:Hide()
    end

    AnchorLootSlots(self)
end

lootFrame.LOOT_SLOT_CLEARED = function(self, _, slot)
    if not self:IsShown() then
        return
    end
    lootFrame.slots[slot]:Hide()
    AnchorLootSlots(self)
end

lootFrame.OPEN_MASTER_LOOT_LIST = function(self)
    _G.ToggleDropDownMenu(1, nil, _G.GroupLootDropDown, lootFrame.slots[ss], 0, 0)
end

lootFrame.UPDATE_MASTER_LOOT_LIST = function(self)
    _G.MasterLooterFrame_UpdatePlayers()
end

function EL:OnLogin()
    if not C.DB.General.EnhancedLoot then
        return
    end

    lootFrame:SetScript('OnHide', function(self)
        _G.StaticPopup_Hide('CONFIRM_LOOT_DISTRIBUTION')
        CloseLoot()
    end)

    lootFrame:SetScript('OnEvent', function(self, event, ...)
        self[event](self, event, ...)
    end)

    lootFrame:RegisterEvent('LOOT_OPENED')
    lootFrame:RegisterEvent('LOOT_SLOT_CLEARED')
    lootFrame:RegisterEvent('LOOT_CLOSED')
    lootFrame:RegisterEvent('OPEN_MASTER_LOOT_LIST')
    lootFrame:RegisterEvent('UPDATE_MASTER_LOOT_LIST')

    _G.LootFrame:UnregisterAllEvents()
end
