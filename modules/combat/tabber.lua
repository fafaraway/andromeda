-- Auto change Tab key to only target enemy players
-- RE/TabBinder by Veev/AcidWeb

local F, C = unpack(select(2, ...))
local COMBAT = F:GetModule('Combat')

local RTB_Fail, RTB_DefaultKey = false, true
local LastTargetKey, TargetKey, CurrentBind, Success

local function OnEvent(self, event, ...)
    if
        event == 'ZONE_CHANGED_NEW_AREA'
        or (event == 'PLAYER_REGEN_ENABLED' and RTB_Fail)
        or event == 'DUEL_REQUESTED'
        or event == 'DUEL_FINISHED'
        or event == 'CHAT_MSG_SYSTEM'
    then
        if event == 'CHAT_MSG_SYSTEM' and ... == _G.ERR_DUEL_REQUESTED then
            event = 'DUEL_REQUESTED'
        elseif event == 'CHAT_MSG_SYSTEM' then
            return
        end

        local BindSet = GetCurrentBindingSet()
        if BindSet ~= 1 and BindSet ~= 2 then
            return
        end

        if InCombatLockdown() then
            RTB_Fail = true
            return
        end

        local PVPType = GetZonePVPInfo()
        local _, ZoneType = IsInInstance()

        TargetKey = GetBindingKey('TARGETNEARESTENEMYPLAYER')
        if TargetKey == nil then
            TargetKey = GetBindingKey('TARGETNEARESTENEMY')
        end
        if TargetKey == nil and RTB_DefaultKey then
            TargetKey = 'TAB'
        end

        LastTargetKey = GetBindingKey('TARGETPREVIOUSENEMYPLAYER')
        if LastTargetKey == nil then
            LastTargetKey = GetBindingKey('TARGETPREVIOUSENEMY')
        end
        if LastTargetKey == nil and RTB_DefaultKey then
            LastTargetKey = 'SHIFT-TAB'
        end

        if TargetKey then
            CurrentBind = GetBindingAction(TargetKey)
        end

        if ZoneType == 'arena' or ZoneType == 'pvp' or PVPType == 'combat' or event == 'DUEL_REQUESTED' then
            if CurrentBind ~= 'TARGETNEARESTENEMYPLAYER' then
                if TargetKey == nil then
                    Success = true
                else
                    Success = SetBinding(TargetKey, 'TARGETNEARESTENEMYPLAYER')
                end
                if LastTargetKey then
                    SetBinding(LastTargetKey, 'TARGETPREVIOUSENEMYPLAYER')
                end
                if Success then
                    SaveBindings(BindSet)
                    RTB_Fail = false
                else
                    RTB_Fail = true
                end
            end
        else
            if CurrentBind ~= 'TARGETNEARESTENEMY' then
                if TargetKey == nil then
                    Success = true
                else
                    Success = SetBinding(TargetKey, 'TARGETNEARESTENEMY')
                end
                if LastTargetKey then
                    SetBinding(LastTargetKey, 'TARGETPREVIOUSENEMY')
                end
                if Success then
                    SaveBindings(BindSet)
                    RTB_Fail = false
                else
                    RTB_Fail = true
                end
            end
        end
    end
end

function COMBAT:SmartTab()
    if not C.DB.Combat.SmartTab then
        return
    end

    F:RegisterEvent('PLAYER_ENTERING_WORLD', OnEvent)
    F:RegisterEvent('ZONE_CHANGED_NEW_AREA', OnEvent)
    F:RegisterEvent('PLAYER_REGEN_ENABLED', OnEvent)
    F:RegisterEvent('DUEL_REQUESTED', OnEvent)
    F:RegisterEvent('DUEL_FINISHED', OnEvent)
    F:RegisterEvent('CHAT_MSG_SYSTEM', OnEvent)
end
