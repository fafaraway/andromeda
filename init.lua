--[[
    ____________ _____ _____ _   _ _____
    |  ___| ___ \  ___|  ___| | | |_   _|
    | |_  | |_/ / |__ | |__ | | | | | |
    |  _| |    /|  __||  __|| | | | | |
    | |   | |\ \| |___| |___| |_| |_| |_
    \_|   \_| \_\____/\____/ \___/ \___/
]]

local _G = _G
local GetAddOnMetadata = GetAddOnMetadata

_G.BINDING_HEADER_FREEUI = GetAddOnMetadata(..., 'Title')
_G.BINDING_NAME_TOGGLE_FREEUI_GUI = 'Toggle FreeUI Config Panel'

local _, engine = ...

_G.FreeUI = engine

engine[1] = {} -- F, Functions
engine[2] = {} -- C, Constants/Config
engine[3] = {} -- L, Localisation

_G.FREE_ADB = {}
_G.FREE_PDB = {}
_G.FREE_GOLDCOUNT = {}
_G.FREE_KEYSTONE = {}

_G.FREE_DB = {}
_G.FREE_SPELLBINDING = {}


do
    engine[1].Libs = {}
    engine[1].LibsMinor = {}

    local function AddLib(name, major, minor)
        if not name then
            return
        end

        -- in this case: `major` is the lib table and `minor` is the minor version
        if type(major) == 'table' and type(minor) == 'number' then
            engine[1].Libs[name], engine[1].LibsMinor[name] = major, minor
        else -- in this case: `major` is the lib name and `minor` is the silent switch
            engine[1].Libs[name], engine[1].LibsMinor[name] = _G.LibStub(major, minor)
        end
    end

    AddLib('ACL', 'AceLocale-3.0')
    AddLib('LBG', 'LibButtonGlow-1.0')
    AddLib('LRC', 'LibRangeCheck-2.0')
    AddLib('LRI', 'LibRealmInfo')
    AddLib('LDD', 'LibDropDown')
    AddLib('Base64', 'LibBase64-1.0')

    engine[1].Libs.oUF = engine.oUF
    engine[1].Libs.cargBags = engine.cargBags
end
