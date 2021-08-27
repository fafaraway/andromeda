local _G = getfenv(0)
local wipe = _G.table.wipe
local CreateFrame = _G.CreateFrame
local GetLocale = _G.GetLocale

local FreeUI = select(2, ...)
FreeUI[3] = FreeUI[1].Libs.ACL:GetLocale('FreeUI', GetLocale())

local F, C = unpack(FreeUI)

do
    F:RegisterModule('Tooltip')
    F:RegisterModule('GUI')
    F:RegisterModule('Unitframe')
    F:RegisterModule('Nameplate')
end

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
            wipe(C.DB)
            C.DB['ShadowLands'] = true
        end
    else
        C.DB = _G.FREE_PDB[_G.FREE_ADB['ProfileIndex'][C.MyFullName] - 1]
    end
    InitialSettings(C.CharacterSettings, C.DB, true)

    F:SetupUIScale(true)

    local GUI = F:GetModule('GUI')
    if not GUI.TexturesList[_G.FREE_ADB.TextureStyle] then
        _G.FREE_ADB.TextureStyle = 1 -- reset value if not exists
    end
    C.Assets.statusbar_tex = GUI.TexturesList[_G.FREE_ADB.TextureStyle].texture

    self:UnregisterAllEvents()
end)



