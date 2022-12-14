--[[

    █████╗ ███╗   ██╗██████╗ ██████╗  ██████╗ ███╗   ███╗███████╗██████╗  █████╗
    ██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██╔════╝██╔══██╗██╔══██╗
    ███████║██╔██╗ ██║██║  ██║██████╔╝██║   ██║██╔████╔██║█████╗  ██║  ██║███████║
    ██╔══██║██║╚██╗██║██║  ██║██╔══██╗██║   ██║██║╚██╔╝██║██╔══╝  ██║  ██║██╔══██║
    ██║  ██║██║ ╚████║██████╔╝██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗██████╔╝██║  ██║
    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝

--]]

do
    -- binding header
    _G.BINDING_HEADER_ANDROMEDA = GetAddOnMetadata(..., 'Title')
end

local addonName, engine = ...
local aceAddon, aceAddonMinor = _G.LibStub('AceAddon-3.0')

engine[1] = aceAddon:NewAddon(addonName, 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')
engine[2] = {}
engine[3] = {}

_G['ANDROMEDA_ADB'] = {} -- account variables
_G['ANDROMEDA_PDB'] = {} -- profile variables
_G['ANDROMEDA_CDB'] = {} -- character variables

-- allow other addons to access andromeda engine
-- for example: local F, C, L = unpack(_G.ANDROMEDA)
_G[strupper(addonName)] = engine

local F, C = engine[1], engine[2]

do
    -- when packager packages a new version for release
    -- '@project-version@' is replaced with the version number
    -- which is the latest tag
    engine.version = '@project-version@'

    if strfind(engine.version, 'project%-version') then
        engine.version = 'development'
    end

    C.ADDON_VERSION = engine.version
    C.IS_DEVELOPER = C.ADDON_VERSION == 'development'

    -- ADDON_NAME is the name of the addon folder, which is 'andromeda'
    -- ADDON_TITLE is the title of the addon, which is 'AndromedaUI'
    C.ADDON_NAME = tostring(addonName)
    C.COLORFUL_ADDON_TITLE = GetAddOnMetadata(C.ADDON_NAME, 'Title')
    C.ADDON_TITLE = gsub(C.COLORFUL_ADDON_TITLE, '|c........([^|]+)|r', '%1')
end

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
    F:AddLib('AceLocale', 'AceLocale-3.0')
    F:AddLib('LibActionButton', 'LibActionButton-1.0')
    F:AddLib('LibButtonGlow', 'LibButtonGlow-1.0')
    F:AddLib('LibCustomGlow', 'LibCustomGlow-1.0')
    F:AddLib('LibRangeCheck', 'LibRangeCheck-2.0')
    F:AddLib('LibSharedMedia', 'LibSharedMedia-3.0')
    F:AddLib('LibBase64', 'LibBase64-1.0')

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
        F:Debug(format(L["module '%s' has been registered."], name))

        return
    end

    local module = {}
    module.name = name
    modules[name] = module

    tinsert(initQueue, module)

    return module
end

function F:GetModule(name)
    if not modules[name] then
        local L = engine[3]
        F:Debug(format(L["module '%s' does not exist."], name))

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
            F:Debug(format(L["module '%s' does not loaded."], module.name))
        end
    end

    F.Modules = modules

    if F.InitCallback then
        F:InitCallback()
    end

    F:Printf(L['version: %s loaded.'], C.ADDON_VERSION)
end)
