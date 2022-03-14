local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')
local oUF = F.Libs.oUF

local repairCostString = string.gsub(_G.REPAIR_COST, _G.HEADER_COLON, ' ')
local lowDurabilityCap = .25

local localSlots = {
    [1] = {1, _G.INVTYPE_HEAD, 1000},
    [2] = {3, _G.INVTYPE_SHOULDER, 1000},
    [3] = {5, _G.INVTYPE_CHEST, 1000},
    [4] = {6, _G.INVTYPE_WAIST, 1000},
    [5] = {9, _G.INVTYPE_WRIST, 1000},
    [6] = {10, L['Hands'], 1000},
    [7] = {7, _G.INVTYPE_LEGS, 1000},
    [8] = {8, L['Feet'], 1000},
    [9] = {16, _G.INVTYPE_WEAPONMAINHAND, 1000},
    [10] = {17, _G.INVTYPE_WEAPONOFFHAND, 1000}
}

local function sortSlots(a, b)
    if a and b then
        return (a[3] == b[3] and a[1] < b[1]) or (a[3] < b[3])
    end
end

local function UpdateAllSlots()
    local numSlots = 0
    for i = 1, 10 do
        localSlots[i][3] = 1000
        local index = localSlots[i][1]
        if GetInventoryItemLink('player', index) then
            local current, max = GetInventoryItemDurability(index)
            if current then
                localSlots[i][3] = current / max
                numSlots = numSlots + 1
            end
            local iconTexture = GetInventoryItemTexture('player', index) or 134400
            localSlots[i][4] = '|T' .. iconTexture .. ':13:15:0:0:50:50:4:46:4:46|t ' or ''
        end
    end
    table.sort(localSlots, sortSlots)

    return numSlots
end

local function isLowDurability()
    for i = 1, 10 do
        if localSlots[i][3] < lowDurabilityCap then
            return true
        end
    end
end

local function getDurabilityColor(cur, max)
    local r, g, b = oUF:RGBColorGradient(cur, max, 1, 0, 0, 1, 1, 0, 0, 1, 0)
    return r, g, b
end

local function Block_OnEvent(self, event)
    if UpdateAllSlots() > 0 then
        local r, g, b = getDurabilityColor(math.floor(localSlots[1][3] * 100), 100)
        self.text:SetText(string.format('%s: %s%s', L['Durability'], F:RGBToHex(r, g, b) .. math.floor(localSlots[1][3] * 100), '%'))
    else
        self.text:SetText(string.format('%s: %s', L['Durability'], C.InfoColor .. _G.NONE))
    end

    if C.DB.Notification.Enable and C.DB.Notification.LowDurability and not InCombatLockdown() then
        if isLowDurability() then
            F:CreateNotification(_G.MINIMAP_TRACKING_REPAIR, L['You have slots in low durability!'], nil, 'Interface\\ICONS\\Ability_Repair')
        end
    end
end

local function Block_OnMouseUp(self)
    ToggleCharacter('PaperDollFrame')
end

local function Block_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.DURABILITY, .9, .8, .6)
    _G.GameTooltip:AddLine(' ')

    local totalCost = 0
    for i = 1, 10 do
        if localSlots[i][3] ~= 1000 then
            local slot = localSlots[i][1]
            local cur = math.floor(localSlots[i][3] * 100)
            local slotIcon = localSlots[i][4]
            _G.GameTooltip:AddDoubleLine(slotIcon .. localSlots[i][2], cur .. '%', 1, 1, 1, getDurabilityColor(cur, 100))

            F.ScanTip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
            totalCost = totalCost + select(3, F.ScanTip:SetInventoryItem('player', slot))
        end
    end

    if totalCost > 0 then
        _G.GameTooltip:AddLine(' ')
        _G.GameTooltip:AddDoubleLine(repairCostString, GetMoneyString(totalCost), .6, .8, 1, 1, 1, 1)
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.Textures.MouseLeftBtn .. L['Toggle Character Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Block_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateDurabilityBlock()
    if not C.DB.Infobar.Durability then
        return
    end

    local du = INFOBAR:RegisterNewBlock('durability', 'LEFT', 150)
    du.onEvent = Block_OnEvent
    du.onEnter = Block_OnEnter
    du.onLeave = Block_OnLeave
    du.onMouseUp = Block_OnMouseUp
    du.eventList = {'PLAYER_ENTERING_WORLD', 'UPDATE_INVENTORY_DURABILITY', 'PLAYER_REGEN_ENABLED'}

    INFOBAR.Durabiliy = du
end
