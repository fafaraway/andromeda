local addonName, engine = ...

local F = engine[1]
local C = engine[2]

-- Get locale strings from AceLocale
engine[3] = F.Libs.ACL:GetLocale(addonName, GetLocale())

-- Prepare modules
do
    F:RegisterModule('ActionBar')
    F:RegisterModule('Announcement')
    F:RegisterModule('Aura')
    F:RegisterModule('Automation')
    F:RegisterModule('Blizzard')
    F:RegisterModule('Camera')
    F:RegisterModule('Chat')
    F:RegisterModule('Combat')
    F:RegisterModule('Cooldown')
    F:RegisterModule('GUI')
    F:RegisterModule('InfoBar')
    F:RegisterModule('Inventory')
    F:RegisterModule('Map')
    F:RegisterModule('Misc')
    F:RegisterModule('Nameplate')
    F:RegisterModule('Notification')
    F:RegisterModule('Quest')
    F:RegisterModule('Theme')
    F:RegisterModule('Tooltip')
    F:RegisterModule('UnitFrame')
    F:RegisterModule('Vignetting')
end

-- Initialize settings
local function InitialSettings(source, target, fullClean)
    for i, j in pairs(source) do
        if type(j) == 'table' then
            if target[i] == nil then
                target[i] = {}
            end
            for k, v in pairs(j) do
                if target[i][k] == nil then
                    target[i][k] = v
                end
            end
        else
            if target[i] == nil then
                target[i] = j
            end
        end
    end

    for i, j in pairs(target) do
        if source[i] == nil then
            target[i] = nil
        end
        if fullClean and type(j) == 'table' then
            for k, v in pairs(j) do
                if type(v) ~= 'table' and source[i] and source[i][k] == nil then
                    target[i][k] = nil
                end
            end
        end
    end
end

local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, _, addon)
    if addon ~= C.ADDON_NAME then
        return
    end

    InitialSettings(C.AccountSettings, _G.ANDROMEDA_ADB)
    if not next(_G.ANDROMEDA_PDB) then
        for i = 1, 5 do
            _G.ANDROMEDA_PDB[i] = {}
        end
    end

    if not _G.ANDROMEDA_ADB['ProfileIndex'][C.MY_FULL_NAME] then
        _G.ANDROMEDA_ADB['ProfileIndex'][C.MY_FULL_NAME] = 1
    end

    if _G.ANDROMEDA_ADB['ProfileIndex'][C.MY_FULL_NAME] == 1 then
        C.DB = _G.ANDROMEDA_CDB
        if not C.DB['ShadowLands'] then
            table.wipe(C.DB)
            C.DB['ShadowLands'] = true
        end
    else
        C.DB = _G.ANDROMEDA_PDB[_G.ANDROMEDA_ADB['ProfileIndex'][C.MY_FULL_NAME] - 1]
    end
    InitialSettings(C.CharacterSettings, C.DB, true)

    F:SetupUIScale(true)

    local GUI = F:GetModule('GUI')
    local NAMEPLATE = F:GetModule('Nameplate')
    if not GUI.TexturesList[C.DB.Nameplate.TextureStyle] then
        C.DB.Nameplate.TextureStyle = 1
    end
    NAMEPLATE.StatusBarTex = GUI.TexturesList[C.DB.Nameplate.TextureStyle].texture

    local UNITFRAME = F:GetModule('UnitFrame')
    if not GUI.TexturesList[C.DB.Unitframe.TextureStyle] then
        C.DB.Unitframe.TextureStyle = 1
    end
    UNITFRAME.StatusBarTex = GUI.TexturesList[C.DB.Unitframe.TextureStyle].texture

    self:UnregisterAllEvents()
end)
