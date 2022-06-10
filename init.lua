--[[
    ____________ _____ _____ _   _ _____
    |  ___| ___ \  ___|  ___| | | |_   _|
    | |_  | |_/ / |__ | |__ | | | | | |
    |  _| |    /|  __||  __|| | | | | |
    | |   | |\ \| |___| |___| |_| |_| |_
    \_|   \_| \_\____/\____/ \___/ \___/
]]

do
    _G.BINDING_HEADER_FREEUI = GetAddOnMetadata(..., 'Title')
    _G.BINDING_NAME_FREEUI_TOGGLE_GUI = 'GUI'
end

local addonName, engine = ...
local aceAddon, aceAddonMinor = _G.LibStub('AceAddon-3.0')

engine.version = '@project-version@'

engine[1] = aceAddon:NewAddon(addonName, 'AceTimer-3.0')
engine[2] = {}
engine[3] = {}

_G.FREE_ADB = {} -- Account variables
_G.FREE_PDB = {}
_G.FREE_DB = {} -- Character variables

_G[addonName] = engine -- Allow other addon access


local F, C = engine[1], engine[2]

do
    if strfind(engine.version, 'project%-version') then
        engine.version = 'development'
    end
end

C.ADDON_NAME = tostring(addonName)
C.ADDON_VERSION = engine.version
C.IS_DEVELOPER = C.ADDON_VERSION == 'development'


-- Libraries
do
    F.Libs = {}
    F.LibsMinor = {}

    function F:AddLib(name, major, minor)
        if not name then
            return
        end

        -- in this case: `major` is the lib table and `minor` is the minor version
        if type(major) == 'table' and type(minor) == 'number' then
            F.Libs[name], F.LibsMinor[name] = major, minor
        else -- in this case: `major` is the lib name and `minor` is the silent switch
            F.Libs[name], F.LibsMinor[name] = _G.LibStub(major, minor)
        end
    end

    F:AddLib('AceAddon', aceAddon, aceAddonMinor)
    F:AddLib('ACL', 'AceLocale-3.0')
    F:AddLib('LBG', 'LibButtonGlow-1.0')
    F:AddLib('LRC', 'LibRangeCheck-2.0')
    F:AddLib('LSM', 'LibSharedMedia-3.0')
    F:AddLib('LDD', 'LibDropDown')
    F:AddLib('Base64', 'LibBase64-1.0')

    F.Libs.oUF = engine.oUF
    F.Libs.cargBags = engine.cargBags
end


-- Events
local events = {}
local host = CreateFrame('Frame')
host:SetScript('OnEvent', function(_, event, ...)
    for func in pairs(events[event]) do
        if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
            func(event, CombatLogGetCurrentEventInfo())
        else
            func(event, ...)
        end
    end
end)

function F:RegisterEvent(event, func, unit1, unit2)
    if event == 'CLEU' then
        event = 'COMBAT_LOG_EVENT_UNFILTERED'
    end

    if not events[event] then
        events[event] = {}
        if unit1 then
            host:RegisterUnitEvent(event, unit1, unit2)
        else
            host:RegisterEvent(event)
        end
    end

    events[event][func] = true
end

function F:UnregisterEvent(event, func)
    if event == 'CLEU' then
        event = 'COMBAT_LOG_EVENT_UNFILTERED'
    end

    local funcs = events[event]
    if funcs and funcs[func] then
        funcs[func] = nil

        if not next(funcs) then
            events[event] = nil
            host:UnregisterEvent(event)
        end
    end
end

-- Modules
local modules, initQueue = {}, {}
function F:RegisterModule(name)
    if modules[name] then
        local L = engine[3]
        F:Debug(string.format(L["module '%s' has been registered."], name))

        return
    end

    local module = {}
    module.name = name
    modules[name] = module

    table.insert(initQueue, module)

    return module
end

function F:GetModule(name)
    if not modules[name] then
        local L = engine[3]
        F:Debug(string.format(L["module '%s' does not exist."], name))

        return
    end

    return modules[name]
end

F:RegisterEvent('PLAYER_LOGIN', function()
    if C.DB.InstallationComplete then
        F:SetupUIScale()
        F:RegisterEvent('UI_SCALE_CHANGED', F.UpdatePixelScale)
    else
        F:SetupUIScale(true)
    end

    local L = engine[3]
    for _, module in next, initQueue do
        if module.OnLogin then
            module:OnLogin()
        else
            F:Debug(string.format(L["module '%s' does not loaded."], module.name))
        end
    end

    F.Modules = modules

    F:Printf(L['version: %s loaded.'], C.ADDON_VERSION)
end)
