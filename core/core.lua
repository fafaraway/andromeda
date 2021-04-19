local _G = _G
local tinsert = tinsert
local unpack = unpack
local CreateFrame = CreateFrame
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local _, engine = ...
local F = unpack(engine)


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
    F:RegisterModule('Tutorial')
    F:RegisterModule('GUI')
    F:RegisterModule('Layout')
    F:RegisterModule('LOGO')
    F:RegisterModule('Theme')
    F:RegisterModule('Blizzard')
    F:RegisterModule('General')
    F:RegisterModule('Actionbar')
    F:RegisterModule('Cooldown')
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
    F.Modules = {}

    F.INSTALL = F:GetModule('Tutorial')
    F.GUI = F:GetModule('GUI')
    F.MOVER = F:GetModule('Layout')
    F.LOGO = F:GetModule('LOGO')
    F.THEME = F:GetModule('Theme')
    F.BLIZZARD = F:GetModule('Blizzard')
    F.MISC = F:GetModule('General')
    F.ACTIONBAR = F:GetModule('Actionbar')
    F.COOLDOWN = F:GetModule('Cooldown')
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
