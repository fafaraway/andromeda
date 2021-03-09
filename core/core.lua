local _G = _G
local tinsert = tinsert
local unpack = unpack
local CreateFrame = CreateFrame
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local addonName, engine = ...
local F = unpack(engine)

_G[addonName] = engine

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

    tinsert(initQueue, module)
    return module
end

function F:GetModule(name)
    if not modules[name] then
        print('Module <' .. name .. '> does not exist.')
        return
    end

    return modules[name]
end

do
    F.OUF = engine.oUF
    F.cargBags = engine.cargBags

    F:RegisterModule('INSTALL')
    F:RegisterModule('GUI')
    F:RegisterModule('MOVER')
    F:RegisterModule('LOGO')
    F:RegisterModule('THEME')
    F:RegisterModule('BLIZZARD')
    F:RegisterModule('MISC')
    F:RegisterModule('ACTIONBAR')
    F:RegisterModule('COOLDOWN')
    F:RegisterModule('AURA')
    F:RegisterModule('CHAT')
    F:RegisterModule('COMBAT')
    F:RegisterModule('INFOBAR')
    F:RegisterModule('INVENTORY')
    F:RegisterModule('MAP')
    F:RegisterModule('NOTIFICATION')
    F:RegisterModule('ANNOUNCEMENT')
    F:RegisterModule('TOOLTIP')
    F:RegisterModule('UNITFRAME')
    F:RegisterModule('NAMEPLATE')
    F:RegisterModule('QUEST')
end

do
    F.INSTALL = F:GetModule('INSTALL')
    F.GUI = F:GetModule('GUI')
    F.MOVER = F:GetModule('MOVER')
    F.LOGO = F:GetModule('LOGO')
    F.THEME = F:GetModule('THEME')
    F.BLIZZARD = F:GetModule('BLIZZARD')
    F.MISC = F:GetModule('MISC')
    F.ACTIONBAR = F:GetModule('ACTIONBAR')
    F.COOLDOWN = F:GetModule('COOLDOWN')
    F.AURA = F:GetModule('AURA')
    F.CHAT = F:GetModule('CHAT')
    F.COMBAT = F:GetModule('COMBAT')
    F.INFOBAR = F:GetModule('INFOBAR')
    F.INVENTORY = F:GetModule('INVENTORY')
    F.MAP = F:GetModule('MAP')
    F.NOTIFICATION = F:GetModule('NOTIFICATION')
    F.ANNOUNCEMENT = F:GetModule('ANNOUNCEMENT')
    F.TOOLTIP = F:GetModule('TOOLTIP')
    F.UNITFRAME = F:GetModule('UNITFRAME')
    F.NAMEPLATE = F:GetModule('NAMEPLATE')
    F.QUEST = F:GetModule('QUEST')
end

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

    F:AddLib('RangeCheck', 'LibRangeCheck-2.0')
    F:AddLib('Base64', 'LibBase64-1.0')
    F:AddLib('LibDropDown', 'LibDropDown')
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
