local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')

local event = CreateFrame('Frame')

function event:PLAYER_REGEN_ENABLED()
    CHAT:CombatEnd()
end

function event:PLAYER_REGEN_DISABLED()
    CHAT:CombatStart()
end

function event:PET_BATTLE_CLOSE()
    CHAT:CombatEnd()
end

function event:PET_BATTLE_OPENING_START()
    CHAT:CombatStart()
end

function CHAT:CombatStart()
    F:UIFrameFadeOut(_G.ChatFrame1, 0.1, _G.ChatFrame1:GetAlpha(), 0)

    _G.GeneralDockManager:Hide()

    if CHAT.ChannelBar then
        CHAT.ChannelBar:Hide()
    end
end

function CHAT:CombatEnd()
    F:UIFrameFadeIn(_G.ChatFrame1, 0.1, _G.ChatFrame1:GetAlpha(), 1)

    _G.GeneralDockManager:Show()

    if CHAT.ChannelBar then
        CHAT.ChannelBar:Show()
    end
end

function CHAT:HideInCombat()
    if not C.DB.Chat.HideInCombat then
        return
    end

    event:RegisterEvent('PLAYER_REGEN_ENABLED')
    event:RegisterEvent('PLAYER_REGEN_DISABLED')
    event:RegisterEvent('PLAYER_LOGIN')
    event:RegisterEvent('PET_BATTLE_CLOSE')
    event:RegisterEvent('PET_BATTLE_OPENING_START')
    event:SetScript('OnEvent', function(self, event, ...)
        self[event](self, ...)
    end)
end
