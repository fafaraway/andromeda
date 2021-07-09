local _G = _G
local unpack = unpack
local select = select
local UnitIsPlayer = UnitIsPlayer
local UnitIsUnit = UnitIsUnit
local UnitAura = UnitAura
local hooksecurefunc = hooksecurefunc
local C_MountJournal_GetMountIDs = C_MountJournal.GetMountIDs
local C_MountJournal_GetMountInfoByID = C_MountJournal.GetMountInfoByID
local C_MountJournal_GetMountInfoExtraByID = C_MountJournal.GetMountInfoExtraByID

local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local mountCache = {}

local function GetMountIDS()
    for _, mountID in ipairs(C_MountJournal_GetMountIDs()) do
        mountCache[select(2, C_MountJournal_GetMountInfoByID(mountID))] = mountID
    end
end

F:RegisterEvent('PLAYER_LOGIN', GetMountIDS)

local function GetMountInfo(self, ...)
    if not UnitIsPlayer(...) or UnitIsUnit(..., 'player') then
        return
    end
    local id = select(10, UnitAura(...))

    if id and mountCache[id] then
        local text = _G.NOT_COLLECTED
        local r, g, b = 1, 0, 0
        local collected = select(11, C_MountJournal_GetMountInfoByID(mountCache[id]))

        if collected then
            text = _G.COLLECTED
            r, g, b = 0, 1, 0
        end

        self:AddLine(' ')
        self:AddLine(text, r, g, b)

        local sourceText = select(3, C_MountJournal_GetMountInfoExtraByID(mountCache[id]))
        self:AddLine(sourceText, 1, 1, 1)
        self:Show()
    end
end

function TOOLTIP:MountSource()
    if not C.DB.Tooltip.MountSource then
        return
    end

    hooksecurefunc(_G.GameTooltip, 'SetUnitAura', GetMountInfo)
end

