local _G = _G
local unpack = unpack
local select = select
local SetRaidTarget = SetRaidTarget
local IsControlKeyDown = IsControlKeyDown
local IsAltKeyDown = IsAltKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local UnitExists = UnitExists
local UnitIsGroupLeader = UnitIsGroupLeader
local UnitIsGroupAssistant = UnitIsGroupAssistant
local GetRaidTargetIndex = GetRaidTargetIndex
local EasyMenu = EasyMenu
local RAID_TARGET_NONE = RAID_TARGET_NONE

local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('COMBAT')

local menuList = {
    {
        text = RAID_TARGET_NONE,
        func = function()
            SetRaidTarget('target', 0)
        end,
    },
    {
        text = F.RGBToHex(1, .92, 0) .. _G.RAID_TARGET_1 .. ' ' .. _G.ICON_LIST[1] .. '12|t',
        func = function()
            SetRaidTarget('target', 1)
        end,
    },
    {
        text = F.RGBToHex(.98, .57, 0) .. _G.RAID_TARGET_2 .. ' ' .. _G.ICON_LIST[2] .. '12|t',
        func = function()
            SetRaidTarget('target', 2)
        end,
    },
    {
        text = F.RGBToHex(.83, .22, .9) .. _G.RAID_TARGET_3 .. ' ' .. _G.ICON_LIST[3] .. '12|t',
        func = function()
            SetRaidTarget('target', 3)
        end,
    },
    {
        text = F.RGBToHex(.04, .95, 0) .. _G.RAID_TARGET_4 .. ' ' .. _G.ICON_LIST[4] .. '12|t',
        func = function()
            SetRaidTarget('target', 4)
        end,
    },
    {
        text = F.RGBToHex(.7, .82, .875) .. _G.RAID_TARGET_5 .. ' ' .. _G.ICON_LIST[5] .. '12|t',
        func = function()
            SetRaidTarget('target', 5)
        end,
    },
    {
        text = F.RGBToHex(0, .71, 1) .. _G.RAID_TARGET_6 .. ' ' .. _G.ICON_LIST[6] .. '12|t',
        func = function()
            SetRaidTarget('target', 6)
        end,
    },
    {
        text = F.RGBToHex(1, .24, .168) .. _G.RAID_TARGET_7 .. ' ' .. _G.ICON_LIST[7] .. '12|t',
        func = function()
            SetRaidTarget('target', 7)
        end,
    },
    {
        text = F.RGBToHex(.98, .98, .98) .. _G.RAID_TARGET_8 .. ' ' .. _G.ICON_LIST[8] .. '12|t',
        func = function()
            SetRaidTarget('target', 8)
        end,
    },
}

local function getModifiedKey()
    local index = C.DB.combat.EasyMarkKey
    if index == 1 then
        return IsControlKeyDown()
    elseif index == 2 then
        return IsAltKeyDown()
    elseif index == 3 then
        return IsShiftKeyDown()
    elseif index == 4 then
        return false
    end
end

function COMBAT:Marker()
    if not C.DB.combat.EasyMark then
        return
    end

    _G.WorldFrame:HookScript('OnMouseDown', function(_, btn)
        if btn == 'LeftButton' and getModifiedKey() and UnitExists('mouseover') then
            if not IsInGroup() or (IsInGroup() and not IsInRaid()) or UnitIsGroupLeader('player') or UnitIsGroupAssistant('player') then
                local ricon = GetRaidTargetIndex('mouseover')
                for i = 1, 8 do
                    if ricon == i then
                        menuList[i + 1].checked = true
                    else
                        menuList[i + 1].checked = false
                    end
                end
                EasyMenu(menuList, F.EasyMenu, 'cursor', 0, 0, 'MENU', 1)
            end
        end
    end)
end

