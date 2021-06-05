local _G = _G
local unpack = unpack
local select = select
local HasNewMail = HasNewMail
local MAIL_LABEL = MAIL_LABEL
local HAVE_MAIL = HAVE_MAIL

local F, C = unpack(select(2, ...))
local NOTIFICATION = F:GetModule('Notification')

local hasMail = false
local function NewMailNotify()
    local newMail = HasNewMail()
    if hasMail ~= newMail then
        hasMail = newMail
        if hasMail then
            F:CreateNotification(MAIL_LABEL, HAVE_MAIL, nil, 'Interface\\ICONS\\INV_Letter_20')
        end
    end
end

function NOTIFICATION:NewMailNotify()
    if not C.DB.Notification.NewMail then
        return
    end

    F:RegisterEvent('UPDATE_PENDING_MAIL', NewMailNotify)
end
