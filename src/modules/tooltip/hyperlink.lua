local F, C, L = unpack(select(2, ...))
local TOOLTIP = F:GetModule('Tooltip')

local orig1, orig2, sectionInfo = {}, {}, {}
local linkTypes = {
    item = true,
    enchant = true,
    spell = true,
    quest = true,
    unit = true,
    talent = true,
    achievement = true,
    glyph = true,
    instancelock = true,
    currency = true,
    keystone = true,
    azessence = true,
    mawpower = true,
    conduit = true,
}

function TOOLTIP:HyperLink_SetPet(link)
    _G.GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', -3, 5)
    _G.GameTooltip:Show()
    local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(':', link)
    _G.BattlePetToolTip_Show(tonumber(speciesID), tonumber(level), tonumber(breedQuality), tonumber(maxHealth), tonumber(power), tonumber(speed))
end

function TOOLTIP:HyperLink_GetSectionInfo(id)
    local info = sectionInfo[id]
    if not info then
        info = C_EncounterJournal.GetSectionInfo(id)
        sectionInfo[id] = info
    end
    return info
end

function TOOLTIP:HyperLink_SetJournal(link)
    local _, idType, id, diffID = strsplit(':', link)
    local name, description, icon, idString
    if idType == '0' then
        name, description = EJ_GetInstanceInfo(id)
        idString = _G.INSTANCE .. 'ID:'
    elseif idType == '1' then
        name, description = EJ_GetEncounterInfo(id)
        idString = _G.BOSS .. 'ID:'
    elseif idType == '2' then
        local info = TOOLTIP:HyperLink_GetSectionInfo(id)
        name, description, icon = info.title, info.description, info.abilityIcon
        name = icon and '|T' .. icon .. ':20:20:0:0:64:64:5:59:5:59:20|t ' .. name or name
        idString = L['Section'] .. 'ID:'
    end
    if not name then
        return
    end

    _G.GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', -3, 5)
    _G.GameTooltip:AddDoubleLine(name, GetDifficultyInfo(diffID))
    _G.GameTooltip:AddLine(description, 1, 1, 1, 1)
    _G.GameTooltip:AddLine(' ')
    _G.GameTooltip:AddDoubleLine(idString, C.INFO_COLOR .. id)
    _G.GameTooltip:Show()
end

function TOOLTIP:HyperLink_SetTypes(link)
    _G.GameTooltip.__isHoverTip = true
    _G.GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT', -3, 5)
    _G.GameTooltip:SetHyperlink(link)
    _G.GameTooltip:Show()
end

function TOOLTIP:HyperLink_OnEnter(link, ...)
    local linkType = strmatch(link, '^([^:]+)')
    if linkType then
        if linkType == 'battlepet' then
            TOOLTIP.HyperLink_SetPet(self, link)
        elseif linkType == 'journal' then
            TOOLTIP.HyperLink_SetJournal(self, link)
        elseif linkTypes[linkType] then
            TOOLTIP.HyperLink_SetTypes(self, link)
        end
    end

    if orig1[self] then
        return orig1[self](self, link, ...)
    end
end

function TOOLTIP:HyperLink_OnLeave(_, ...)
    _G.BattlePetTooltip:Hide()
    _G.GameTooltip:Hide()
    _G.GameTooltip.__isHoverTip = nil

    if orig2[self] then
        return orig2[self](self, ...)
    end
end

local function HookCommunitiesFrame(event, addon)
    if addon == 'Blizzard_Communities' then
        _G.CommunitiesFrame.Chat.MessageFrame:SetScript('OnHyperlinkEnter', TOOLTIP.HyperLink_OnEnter)
        _G.CommunitiesFrame.Chat.MessageFrame:SetScript('OnHyperlinkLeave', TOOLTIP.HyperLink_OnLeave)

        F:UnregisterEvent(event, HookCommunitiesFrame)
    end
end

function TOOLTIP:HyperLink()
    for i = 1, _G.NUM_CHAT_WINDOWS do
        local frame = _G['ChatFrame' .. i]
        orig1[frame] = frame:GetScript('OnHyperlinkEnter')
        frame:SetScript('OnHyperlinkEnter', TOOLTIP.HyperLink_OnEnter)
        orig2[frame] = frame:GetScript('OnHyperlinkLeave')
        frame:SetScript('OnHyperlinkLeave', TOOLTIP.HyperLink_OnLeave)
    end

    F:RegisterEvent('ADDON_LOADED', HookCommunitiesFrame)
end
