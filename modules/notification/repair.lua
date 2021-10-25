local _G = _G
local unpack = unpack
local select = select

local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')
local INFOBAR = F:GetModule('InfoBar')

function NOTIFICATION:RepairNotify()
    if C.DB.Notification.LowDurability then
        F:RegisterEvent('PLAYER_ENTERING_WORLD', INFOBAR.RepairNotify)
        F:RegisterEvent('PLAYER_REGEN_ENABLED', INFOBAR.RepairNotify)
    end
end
