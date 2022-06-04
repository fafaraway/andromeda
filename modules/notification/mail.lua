local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local hasMail = false
local function NewMailNotify()
    local newMail = HasNewMail()
    if hasMail ~= newMail then
        hasMail = newMail
        if hasMail then
            F:CreateNotification(_G.MAIL_LABEL, _G.HAVE_MAIL, nil, 'Interface\\ICONS\\INV_Letter_20')
        end
    end
end

function NOTIFICATION:NewMailNotify()
    if not C.DB.Notification.NewMail then
        return
    end

    F:RegisterEvent('UPDATE_PENDING_MAIL', NewMailNotify)
end
