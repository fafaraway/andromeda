local addOnName, engine = ...

local F = engine[1]
local C = engine[2]

-- Get locale strings from AceLocale
engine[3] = F.Libs.ACL:GetLocale(addOnName, GetLocale())

-- Prepare modules
do
    F.UnitFrame = F:RegisterModule('UnitFrame')
    F.WorldMap = F:RegisterModule('WorldMap')
    F.Minimap = F:RegisterModule('Minimap')
    F.Tooltip = F:RegisterModule('Tooltip')
    F.GUI = F:RegisterModule('GUI')
    F.Quest = F:RegisterModule('Quest')
    F.Inventory = F:RegisterModule('Inventory')
    F.InfoBar = F:RegisterModule('InfoBar')
    F.ActionBar = F:RegisterModule('ActionBar')
    F.Announcement = F:RegisterModule('Announcement')
    F.Aura = F:RegisterModule('Aura')
    F.Chat = F:RegisterModule('Chat')
    F.Combat = F:RegisterModule('Combat')
    F.Cooldown = F:RegisterModule('Cooldown')
    F.Notification = F:RegisterModule('Notification')
    F.Theme = F:RegisterModule('Theme')
    F.Blizzard = F:RegisterModule('Blizzard')
    F.Nameplate = F:RegisterModule('Nameplate')
    F.Vignetting = F:RegisterModule('Vignetting')
    F.Camera = F:RegisterModule('Camera')
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
    if addon ~= 'FreeUI' then
        return
    end

    InitialSettings(C.AccountSettings, _G.FREE_ADB)
    if not next(_G.FREE_PDB) then
        for i = 1, 5 do
            _G.FREE_PDB[i] = {}
        end
    end

    if not _G.FREE_ADB['ProfileIndex'][C.MyFullName] then
        _G.FREE_ADB['ProfileIndex'][C.MyFullName] = 1
    end

    if _G.FREE_ADB['ProfileIndex'][C.MyFullName] == 1 then
        C.DB = _G.FREE_DB
        if not C.DB['ShadowLands'] then
            table.wipe(C.DB)
            C.DB['ShadowLands'] = true
        end
    else
        C.DB = _G.FREE_PDB[_G.FREE_ADB['ProfileIndex'][C.MyFullName] - 1]
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



