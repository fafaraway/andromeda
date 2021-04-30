--[[
    Your achievement status in tooltip
]]

local _G = _G
local unpack = unpack
local select = select
local strfind = strfind
local format = format
local UnitGUID = UnitGUID
local GetAchievementInfo = GetAchievementInfo
local hooksecurefunc = hooksecurefunc

local F, C = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local function SetHyperlink(tooltip, refString)
    if select(3, strfind(refString, '(%a-):')) ~= 'achievement' then
        return
    end

    local _, _, achievementID = strfind(refString, ':(%d+):')
    local _, _, GUID = strfind(refString, ':%d+:(.-):')

    if GUID == UnitGUID('player') then
        tooltip:Show()
        return
    end

    tooltip:AddLine(' ')
    local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementID)

    if completed then
        if earnedBy then
            if earnedBy ~= '' then
                tooltip:AddLine(format(_G.ACHIEVEMENT_EARNED_BY, earnedBy))
            end
            if not wasEarnedByMe then
                tooltip:AddLine(format(_G.ACHIEVEMENT_NOT_COMPLETED_BY, C.MyName))
            elseif C.MyName ~= earnedBy then
                tooltip:AddLine(format(_G.ACHIEVEMENT_COMPLETED_BY, C.MyName))
            end
        end
    end
    tooltip:Show()
end

function TOOLTIP:Achievement()
    hooksecurefunc(_G.GameTooltip, 'SetHyperlink', SetHyperlink)
    hooksecurefunc(_G.ItemRefTooltip, 'SetHyperlink', SetHyperlink)
end

