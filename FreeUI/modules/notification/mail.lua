local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('NOTIFICATION')


local hasMail = false
local function alertMail()
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			F:CreateNotification(L['NOTIFICATION_MAIL'], C.BlueColor..L['NOTIFICATION_NEW_MAIL'], nil, 'Interface\\ICONS\\INV_Letter_20')
		end
	end
end


function NOTIFICATION:NewMail()
	if not C.DB.notification.new_mail then return end

	local f = CreateFrame('Frame')
	f:RegisterEvent('UPDATE_PENDING_MAIL')
	f:RegisterEvent('PLAYER_ENTERING_WORLD')
	f:SetScript('OnEvent', function(self, event)
		if event == 'UPDATE_PENDING_MAIL' then
			alertMail()
		end
	end)
end
