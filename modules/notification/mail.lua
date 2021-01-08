local F, C, L = unpack(select(2, ...))
local NOTIFICATION = F.NOTIFICATION

local hasMail = false
local function MailNotification()
	local newMail = HasNewMail()
	if hasMail ~= newMail then
		hasMail = newMail
		if hasMail then
			F:CreateNotification(MAIL_LABEL, C.BlueColor .. HAVE_MAIL, nil, 'Interface\\ICONS\\INV_Letter_20')
		end
	end
end

function NOTIFICATION:NewMail()
	if not C.DB.notification.new_mail then
		return
	end

	--F:RegisterEvent('PLAYER_ENTERING_WORLD', MailNotification)
	F:RegisterEvent('UPDATE_PENDING_MAIL', MailNotification)
end
