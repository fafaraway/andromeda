local _G = _G
local unpack = unpack
local select = select
local CreateFrame = CreateFrame
local GetLootSlotType = GetLootSlotType
local CursorUpdate = CursorUpdate
local CursorOnUpdate = CursorOnUpdate
local ResetCursor = ResetCursor
local GetCursorPosition = GetCursorPosition
local IsModifiedClick = IsModifiedClick
local HandleModifiedItemClick = HandleModifiedItemClick
local GetLootSlotLink = GetLootSlotLink
local StaticPopup_Hide = StaticPopup_Hide
local LootSlot = LootSlot
local CloseLoot = CloseLoot
local GetNumLootItems = GetNumLootItems
local GetLootSlotInfo = GetLootSlotInfo
local ToggleDropDownMenu = ToggleDropDownMenu
local MasterLooterFrame_UpdatePlayers = MasterLooterFrame_UpdatePlayers

local F, C = unpack(select(2, ...))
local BLIZZARD = F.BLIZZARD

local iconsize = 32
local width = 140
local sq, ss, sn, st

local LootFrameADV = CreateFrame('Button', 'FreeUI_Loot', _G.UIParent, 'BackdropTemplate')
LootFrameADV:SetFrameStrata('HIGH')
LootFrameADV:SetClampedToScreen(true)
LootFrameADV:SetWidth(width)
LootFrameADV:SetHeight(64)
LootFrameADV:Hide()

LootFrameADV.slots = {}

local OnEnter = function(self)
    local slot = self:GetID()
    if GetLootSlotType(slot) == _G.LOOT_SLOT_ITEM then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:SetLootItem(slot)
        CursorUpdate(self)
    end
end

local OnLeave = function(self)
    _G.GameTooltip:Hide()
    ResetCursor()
end

local OnClick = function(self)
    if (IsModifiedClick()) then
        HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
    else
        StaticPopup_Hide 'CONFIRM_LOOT_DISTRIBUTION'
        ss = self:GetID()
        sq = self.quality
        sn = self.name:GetText()
        st = self.icon:GetTexture()

        _G.LootFrame.selectedLootButton = self:GetName();
        _G.LootFrame.selectedSlot = ss;
        _G.LootFrame.selectedQuality = sq;
        _G.LootFrame.selectedItemName = sn;
        _G.LootFrame.selectedTexture = st;

        LootSlot(ss)
    end
end

local OnUpdate = function(self)
    if _G.GameTooltip:IsOwned(self) then
        _G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        _G.GameTooltip:SetLootItem(self:GetID())
        CursorOnUpdate(self)
    end
end

local createSlot = function(id)
    local frame = CreateFrame('Button', 'FreeUI_Loot_Slot' .. id, LootFrameADV, 'BackdropTemplate')
    frame:SetPoint('TOP', LootFrameADV, 0, -((id - 1) * (iconsize + 1)))
    frame:SetPoint('RIGHT')
    frame:SetPoint('LEFT')
    frame:SetHeight(24)
    frame:SetFrameStrata('HIGH')
    frame:SetFrameLevel(20)
    frame:SetID(id)
    LootFrameADV.slots[id] = frame

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
    iconFrame:SetPoint('RIGHT', frame, 'LEFT', -2, 0)

    local icon = iconFrame:CreateTexture(nil, 'ARTWORK')
    icon:SetTexCoord(unpack(C.TexCoord))
    icon:SetPoint('TOPLEFT', C.Mult, -C.Mult)
    icon:SetPoint('BOTTOMRIGHT', -C.Mult, C.Mult)
    F.SetBD(icon)
    frame.icon = icon

    local count = F.CreateFS(iconFrame, C.Assets.Fonts.Regular, 11, 'OUTLINE', '', nil, true, 'TOP', 1, -2)
    frame.count = count

    local name = F.CreateFS(frame, C.Assets.Fonts.Regular, 12, true)
    name:SetPoint('RIGHT', frame)
    name:SetPoint('LEFT', icon, 'RIGHT', 8, 0)
    name:SetJustifyH('LEFT')
    name:SetNonSpaceWrap(true)
    frame.name = name

    return frame
end

local anchorSlots = function(self)
    local shownSlots = 0
    for i = 1, #self.slots do
        local frame = self.slots[i]
        if (frame:IsShown()) then
            shownSlots = shownSlots + 1

            frame:SetPoint('TOP', LootFrameADV, 4, (-8 + iconsize) - (shownSlots * (iconsize + 4)))
        end
    end

    self:SetHeight(math.max(shownSlots * iconsize + 16, 20))
end

LootFrameADV.LOOT_CLOSED = function(self)
    StaticPopup_Hide 'LOOT_BIND'
    self:Hide()

    for _, v in next, self.slots do
        v:Hide()
    end
end

LootFrameADV.LOOT_OPENED = function(self, event, autoloot)
    self:Show()

    if (not self:IsShown()) then
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

    if (items > 0) then
        for i = 1, items do
            local slot = LootFrameADV.slots[i] or createSlot(i)
            local lootIcon, lootName, lootQuantity, _, lootQuality, _, isQuestItem, questID, isActive = GetLootSlotInfo(i)
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

                if questID and not isActive then
                    slot.bg:SetBackdropColor(.5, .5, 0, .5)
                    slot.name:SetTextColor(1, 1, 0)
                elseif questID or isQuestItem then
                    slot.bg:SetBackdropColor(.5, .5, 0, .5)
                    slot.name:SetTextColor(r, g, b)
                else
                    slot.bg:SetBackdropColor(0, 0, 0, .5)
                    slot.name:SetTextColor(r, g, b)
                end

                slot.lootQuality = lootQuality
                slot.isQuestItem = isQuestItem

                slot.name:SetText(lootName)
                slot.icon:SetTexture(lootIcon)

                maxQuality = math.max(maxQuality, lootQuality)

                slot:Enable()
                slot:Show()
            end
        end
    else
        self:Hide()
    end

    anchorSlots(self)
end

LootFrameADV.LOOT_SLOT_CLEARED = function(self, event, slot)
    if (not self:IsShown()) then
        return
    end
    LootFrameADV.slots[slot]:Hide()
    anchorSlots(self)
end

LootFrameADV.OPEN_MASTER_LOOT_LIST = function(self)
    ToggleDropDownMenu(1, nil, _G.GroupLootDropDown, LootFrameADV.slots[ss], 0, 0)
end

LootFrameADV.UPDATE_MASTER_LOOT_LIST = function(self)
    MasterLooterFrame_UpdatePlayers()
end

function BLIZZARD:LootFrame()
    LootFrameADV:SetScript('OnHide', function(self)
        StaticPopup_Hide 'CONFIRM_LOOT_DISTRIBUTION'
        CloseLoot()
    end)

    LootFrameADV:SetScript('OnEvent', function(self, event, ...)
        self[event](self, event, ...)
    end)

    LootFrameADV:RegisterEvent 'LOOT_OPENED'
    LootFrameADV:RegisterEvent 'LOOT_SLOT_CLEARED'
    LootFrameADV:RegisterEvent 'LOOT_CLOSED'
    LootFrameADV:RegisterEvent 'OPEN_MASTER_LOOT_LIST'
    LootFrameADV:RegisterEvent 'UPDATE_MASTER_LOOT_LIST'

    _G.LootFrame:UnregisterAllEvents()
    table.insert(_G.UISpecialFrames, 'FreeUI_Loot')
end
BLIZZARD:RegisterBlizz('LootFrame', BLIZZARD.LootFrame)

