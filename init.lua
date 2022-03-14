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

local addOnName, engine = ...
local aceAddon, aceAddonMinor = _G.LibStub('AceAddon-3.0')

engine[1] = aceAddon:NewAddon(addOnName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
engine[2] = {}
engine[3] = {}

_G.FREE_ADB = {} -- Account variables
_G.FREE_PDB = {}
_G.FREE_DB = {} -- Character variables

_G.FreeUI = engine -- Allow other addon access

local F, C = engine[1], engine[2]

local addonVersion = '@project-version@'
if (addonVersion:find('project%-version')) then
    addonVersion = 'Development'
end
C.AddonVersion = addonVersion
C.IsDeveloper = C.AddonVersion == 'Development'

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

--[[ function F:OnEnable()
    F:Initialize()
end

function F:CallLoadedModule(obj, silent, object, index)
    local name, func
    if type(obj) == 'table' then name, func = unpack(obj) else name = obj end
    local module = name and F:GetModule(name, silent)

    if not module then return end
    if func and type(func) == 'string' then
        F:CallLoadFunc(module[func], module)
    elseif func and type(func) == 'function' then
        F:CallLoadFunc(func, module)
    elseif module.Initialize then
        F:CallLoadFunc(module.Initialize, module)
    end

    if object and index then object[index] = nil end
end

function F:RegisterInitialModule(name, func)
    F.RegisteredInitialModules[#F.RegisteredInitialModules + 1] = (func and {name, func}) or name
end

function F:RegisterModule(name, func)
    if F.initialized then
        F:CallLoadedModule((func and {name, func}) or name)
    else
        F.RegisteredModules[#F.RegisteredModules + 1] = (func and {name, func}) or name
    end
end

function F:InitializeInitialModules()
    for index, object in ipairs(F.RegisteredInitialModules) do
        F:CallLoadedModule(object, true, F.RegisteredInitialModules, index)
    end
end

function F:InitializeModules()
    for index, object in ipairs(F.RegisteredModules) do
        F:CallLoadedModule(object, true, F.RegisteredModules, index)
    end
end

function F:Initialize()
    F:InitializeModules()
end ]]

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
        F:Print('Module <' .. name .. '> has been registered.')
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
        F:Print('Module <' .. name .. '> does not exist.')
        return
    end

    return modules[name]
end

F:RegisterEvent('PLAYER_LOGIN', function()
    if C.DB.InstallationComplete then
        F:SetupUIScale()
        F:RegisterEvent('UI_SCALE_CHANGED', F.UpdatePixelScale)

        _G.Display_UseUIScale:Kill()
        _G.Display_UIScaleSlider:Kill()
    else
        F:SetupUIScale(true)
    end

    for _, module in next, initQueue do
        if module.OnLogin then
            module:OnLogin()
        else
            F:Print('Module <' .. module.name .. '> does not loaded.')
        end
    end

    F.Modules = modules
    F:Print('Version: ' .. C.AddonVersion)
end)
