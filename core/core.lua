local _G = _G
local tinsert = tinsert
local unpack = unpack
local CreateFrame = CreateFrame
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetLocale = GetLocale

local F, C, L = unpack(select(2, ...))


do
    F:RegisterModule('Tutorial')
    F:RegisterModule('GUI')
    F:RegisterModule('Layout')
    F:RegisterModule('Theme')
    F:RegisterModule('Blizzard')
    F:RegisterModule('General')
    F:RegisterModule('Actionbar')
    F:RegisterModule('Cooldown')
    F:RegisterModule('Aura')
    F:RegisterModule('Chat')
    F:RegisterModule('Combat')
    F:RegisterModule('Infobar')
    F:RegisterModule('Inventory')


    F:RegisterModule('Notification')
    F:RegisterModule('Announcement')



    F:RegisterModule('Quest')
end

do
    F.Modules = {}

    F.Modules.Tutorial = F:GetModule('Tutorial')
    F.Modules.GUI = F:GetModule('GUI')
    F.Modules.Layout = F:GetModule('Layout')
    F.THEME = F:GetModule('Theme')
    F.BLIZZARD = F:GetModule('Blizzard')
    F.MISC = F:GetModule('General')
    F.ACTIONBAR = F:GetModule('Actionbar')
    F.COOLDOWN = F:GetModule('Cooldown')
    F.AURA = F:GetModule('Aura')
    F.CHAT = F:GetModule('Chat')
    F.COMBAT = F:GetModule('Combat')
    F.INFOBAR = F:GetModule('Infobar')
    F.INVENTORY = F:GetModule('Inventory')


    F.NOTIFICATION = F:GetModule('Notification')
    F.ANNOUNCEMENT = F:GetModule('Announcement')

    F.QUEST = F:GetModule('Quest')
end
