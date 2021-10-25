local F, C, L = unpack(select(2, ...))
local INFOBAR = F:GetModule('InfoBar')

local showRepair = true
local slots = {
    [1] = {1, _G.INVTYPE_HEAD, 1000},
    [2] = {3, _G.INVTYPE_SHOULDER, 1000},
    [3] = {5, _G.INVTYPE_ROBE, 1000},
    [4] = {6, _G.INVTYPE_WAIST, 1000},
    [5] = {9, _G.INVTYPE_WRIST, 1000},
    [6] = {10, _G.INVTYPE_HAND, 1000},
    [7] = {7, _G.INVTYPE_LEGS, 1000},
    [8] = {8, _G.INVTYPE_FEET, 1000},
    [9] = {16, _G.INVTYPE_WEAPONMAINHAND, 1000},
    [10] = {17, _G.INVTYPE_WEAPONOFFHAND, 1000},
    [11] = {18, _G.INVTYPE_RANGED, 1000}
}

local function GetItemDurability()
    local numSlots = 0
    for i = 1, 11 do
        if GetInventoryItemLink('player', slots[i][1]) then
            local current, max = GetInventoryItemDurability(slots[i][1])
            if current then
                slots[i][3] = current / max
                numSlots = numSlots + 1
            end
        else
            slots[i][3] = 1000
        end
    end
    table.sort(
        slots,
        function(a, b)
            return a[3] < b[3]
        end
    )

    return numSlots
end

local function IsLowDurability()
    for i = 1, 11 do
        if slots[i][3] < .20 then
            return true
        end
    end
end

local function GradientColor(perc)
    perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
    local seg, relperc = math.modf(perc * 2)
    local r1, g1, b1, r2, g2, b2 = select(seg * 3 + 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0) -- R -> Y -> G
    local r, g, b = r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
    return string.format('|cff%02x%02x%02x', r * 255, g * 255, b * 255), r, g, b
end

local function ResetRepairNotify()
    showRepair = true
end

function INFOBAR:RepairNotify()
    if showRepair and IsLowDurability() then
        showRepair = false
        F:Delay(180, ResetRepairNotify)
        F:CreateNotification(_G.MINIMAP_TRACKING_REPAIR, L['The durability of the equipment is low.'], nil, 'Interface\\ICONS\\Ability_Repair')
    end
end

local function Button_OnEvent(self)
    local numSlots = GetItemDurability()

    if numSlots > 0 then
        self.Text:SetText(string.format(string.gsub(L['Durability'] .. ': [color]%d|r%%', '%[color%]', (GradientColor(math.floor(slots[1][3] * 100) / 100))), math.floor(slots[1][3] * 100)))
    else
        self.Text:SetText(L['Durability'] .. ': ' .. C.InfoColor .. _G.NONE)
    end
end

local function Button_OnMouseUp(self, btn)
    -- #TODO
    if btn == 'LeftButton' then
        F:Debug('left')
    elseif btn == 'RightButton' then
        F:Debug('right')
    elseif btn == 'MiddleButton' then
        F:Debug('middle')
    end
end

local function Button_OnEnter(self)
    local anchorTop = C.DB.Infobar.AnchorTop
    _G.GameTooltip:SetOwner(self, (anchorTop and 'ANCHOR_BOTTOM') or 'ANCHOR_TOP', 0, (anchorTop and -6) or 6)
    _G.GameTooltip:ClearLines()
    _G.GameTooltip:AddLine(_G.DURABILITY, .9, .8, .6)
    _G.GameTooltip:AddLine(' ')

    for i = 1, 10 do
        if slots[i][3] ~= 1000 then
            local green = slots[i][3] * 2
            local red = 1 - green
            local slotIcon = '|T' .. GetInventoryItemTexture('player', slots[i][1]) .. ':13:15:0:0:50:50:4:46:4:46|t ' or ''
            _G.GameTooltip:AddDoubleLine(slotIcon .. slots[i][2], math.floor(slots[i][3] * 100) .. '%', 1, 1, 1, red + 1, green, 0)
        end
    end

    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(' ', C.LineString)
    _G.GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left .. L['Toggle Character Panel'] .. ' ', 1, 1, 1, .9, .8, .6)
    _G.GameTooltip:Show()
end

local function Button_OnLeave(self)
    F:HideTooltip()
end

function INFOBAR:CreateDurabilityBlock()
    if not C.DB.Infobar.Durability then
        return
    end

    local bu = INFOBAR:AddBlock('', 'LEFT', 150)
    bu:HookScript('OnEvent', Button_OnEvent)
    bu:HookScript('OnMouseUp', Button_OnMouseUp)
    bu:HookScript('OnEnter', Button_OnEnter)
    bu:HookScript('OnLeave', Button_OnLeave)

    bu:RegisterEvent('PLAYER_ENTERING_WORLD')
    bu:RegisterEvent('UPDATE_INVENTORY_DURABILITY')
end
