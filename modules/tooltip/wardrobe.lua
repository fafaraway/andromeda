--[[
    Show VisualID SourceID ItemID on WardrobeCollectionFrame
    Credit silverwind
    https://github.com/silverwind/idTip
]]

local _G = _G
local unpack = unpack
local select = select
local tinsert = tinsert
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame

local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local kinds = {
    item = 'ItemID',
    visual = 'VisualID',
    source = 'SourceID'
}

function TOOLTIP:Contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function TOOLTIP:AddLine(tooltip, id, kind)
    if not id or id == '' then
        return
    end
    if type(id) == 'table' and #id == 1 then
        id = id[1]
    end

    -- Check if we already added to this tooltip. Happens on the talent frame
    local frame, text
    for i = 1, 15 do
        frame = _G[tooltip:GetName() .. 'TextLeft' .. i]
        if frame then
            text = frame:GetText()
        end
        if text and string.find(text, kind .. ':') then
            return
        end
    end

    local left, right
    if type(id) == 'table' then
        left = _G.NORMAL_FONT_COLOR_CODE .. kind .. 's:' .. _G.FONT_COLOR_CODE_CLOSE
        right = _G.HIGHLIGHT_FONT_COLOR_CODE .. table.concat(id, ', ') .. _G.FONT_COLOR_CODE_CLOSE
    else
        left = _G.NORMAL_FONT_COLOR_CODE .. kind .. ':' .. _G.FONT_COLOR_CODE_CLOSE
        right = _G.HIGHLIGHT_FONT_COLOR_CODE .. id .. _G.FONT_COLOR_CODE_CLOSE
    end

    tooltip:AddDoubleLine(left, right)
    tooltip:Show()
end

function TOOLTIP:GetIDs(sources)
    local visualIDs = {}
    local sourceIDs = {}
    local itemIDs = {}

    for i = 1, #sources do
        if sources[i].visualID and not TOOLTIP:Contains(visualIDs, sources[i].visualID) then
            tinsert(visualIDs, sources[i].visualID)
        end
        if sources[i].sourceID and not TOOLTIP:Contains(visualIDs, sources[i].sourceID) then
            tinsert(sourceIDs, sources[i].sourceID)
        end
        if sources[i].itemID and not TOOLTIP:Contains(visualIDs, sources[i].itemID) then
            tinsert(itemIDs, sources[i].itemID)
        end
    end

    _G.GameTooltip:AddLine(' ')

    if #visualIDs ~= 0 then
        TOOLTIP:AddLine(_G.GameTooltip, visualIDs, kinds.visual)
    end
    if #sourceIDs ~= 0 then
        TOOLTIP:AddLine(_G.GameTooltip, sourceIDs, kinds.source)
    end
    if #itemIDs ~= 0 then
        TOOLTIP:AddLine(_G.GameTooltip, itemIDs, kinds.item)
    end
end

function TOOLTIP:OnEvent(_, addon)
    if not C.IsDeveloper then return end
    if addon == 'Blizzard_Collections' then
        hooksecurefunc('WardrobeCollectionFrame_SetAppearanceTooltip', TOOLTIP.GetIDs)
    end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', TOOLTIP.OnEvent)
