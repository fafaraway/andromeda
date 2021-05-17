local _G = _G
local tinsert = tinsert
local unpack = unpack
local CreateFrame = CreateFrame
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetLocale = GetLocale

local F, C, L = unpack(select(2, ...))


do






    F:RegisterModule('Chat')
    F:RegisterModule('Combat')

    F:RegisterModule('Inventory')


    F:RegisterModule('Notification')
    F:RegisterModule('Announcement')



end

do







    F.CHAT = F:GetModule('Chat')
    F.COMBAT = F:GetModule('Combat')

    F.INVENTORY = F:GetModule('Inventory')


    F.NOTIFICATION = F:GetModule('Notification')
    F.ANNOUNCEMENT = F:GetModule('Announcement')

end
