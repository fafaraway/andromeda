--[[
    ____________ _____ _____ _   _ _____
    |  ___| ___ \  ___|  ___| | | |_   _|
    | |_  | |_/ / |__ | |__ | | | | | |
    |  _| |    /|  __||  __|| | | | | |
    | |   | |\ \| |___| |___| |_| |_| |_
    \_|   \_| \_\____/\____/ \___/ \___/
]]


_G.BINDING_HEADER_FREEUI = GetAddOnMetadata(..., 'Title')
_G.BINDING_NAME_FREEUI_TOGGLE_GUI = 'GUI'

local _, ns = ...

ns[1] = {} -- Functions
ns[2] = {} -- Constants/Config
ns[3] = {} -- Localization

_G.FREE_ADB = {} -- Account variables
_G.FREE_PDB = {}
_G.FREE_DB = {} -- Character variables

_G.FreeUI = ns -- Allow other addon access

local F, C = unpack(ns)

local addonVersion = '@project-version@'
if (addonVersion:find('project%-version')) then
    addonVersion = 'Development'
end
C.AddonVersion = addonVersion
C.IsDeveloper = C.AddonVersion == 'Development'

--[[ Libraries ]]

do
    F.Libs = {}
    F.LibsMinor = {}

    local function AddLib(name, major, minor)
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

    AddLib('ACL', 'AceLocale-3.0')
    AddLib('LBG', 'LibButtonGlow-1.0')
    AddLib('LRC', 'LibRangeCheck-2.0')
    AddLib('LRI', 'LibRealmInfo')
    AddLib('LSM', 'LibSharedMedia-3.0')
    AddLib('LDD', 'LibDropDown')
    AddLib('Base64', 'LibBase64-1.0')

    F.Libs.oUF = ns.oUF
    F.Libs.cargBags = ns.cargBags

    _G.LibStub('AceTimer-3.0'):Embed(F)
end

--[[ Events ]]

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
    local funcs = events[event]
    if funcs and funcs[func] then
        funcs[func] = nil

        if not next(funcs) then
            events[event] = nil
            host:UnregisterEvent(event)
        end
    end
end

--[[ Modules ]]

local modules, initQueue = {}, {}

function F:RegisterModule(name)
    if modules[name] then
        print('Module <' .. name .. '> has been registered.')
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
        print('Module <' .. name .. '> does not exist.')
        return
    end

    return modules[name]
end

F:RegisterEvent('PLAYER_LOGIN', function()
    for _, module in next, initQueue do
        if module.OnLogin then
            module:OnLogin()
        else
            print('Module <' .. module.name .. '> does not loaded.')
        end
    end

    F.Modules = modules
end)
