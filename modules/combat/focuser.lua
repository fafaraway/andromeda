local _G = _G
local unpack = unpack
local select = select
local next = next
local strmatch = strmatch
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local SetOverrideBindingClick = SetOverrideBindingClick

local F, C = unpack(select(2, ...))
local COMBAT = F.COMBAT
local OUF = F.OUF

local modifier
local mouseButton = '1' -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any
local pending = {}

function COMBAT:Focuser_Setup()
    if not self or self.focuser then
        return
    end

    if self:GetName() and (not C.DB.combat.EasyFocusOnUnitframe and strmatch(self:GetName(), 'oUF_')) then
        return
    end

    if not InCombatLockdown() then
        local index = C.DB.combat.EasyFocusKey
        if index == 1 then
            modifier = 'control'
        elseif index == 2 then
            modifier = 'alt'
        elseif index == 3 then
            modifier = 'shift'
        elseif index == 4 then
            return
        end
        self:SetAttribute(modifier .. '-type' .. mouseButton, 'focus')
        self.focuser = true
        pending[self] = nil
    else
        pending[self] = true
    end
end

function COMBAT:Focuser_CreateFrameHook(name, _, template)
    if name and template == 'SecureUnitButtonTemplate' then
        COMBAT.Focuser_Setup(_G[name])
    end
end

function COMBAT.Focuser_OnEvent(event)
    if event == 'PLAYER_REGEN_ENABLED' then
        if next(pending) then
            for frame in next, pending do
                COMBAT.Focuser_Setup(frame)
            end
        end
    else
        for _, object in next, OUF.objects do
            if not object.focuser then
                COMBAT.Focuser_Setup(object)
            end
        end
    end
end

function COMBAT:Focuser()
    if not C.DB.combat.EasyFocus then
        return
    end

    local index = C.DB.combat.EasyFocusKey
    if index == 1 then
        modifier = 'control'
    elseif index == 2 then
        modifier = 'alt'
    elseif index == 3 then
        modifier = 'shift'
    elseif index == 4 then
        return
    end

    -- Keybinding override so that models can be shift/alt/ctrl+clicked
    local f = CreateFrame('CheckButton', 'FocuserButton', _G.UIParent, 'SecureActionButtonTemplate')
    f:SetAttribute('type1', 'macro')
    f:SetAttribute('macrotext', '/focus mouseover')
    SetOverrideBindingClick(_G.FocuserButton, true, modifier .. '-BUTTON' .. mouseButton, 'FocuserButton')

    hooksecurefunc('CreateFrame', COMBAT.Focuser_CreateFrameHook)

    COMBAT:Focuser_OnEvent()
    F:RegisterEvent('PLAYER_REGEN_ENABLED', COMBAT.Focuser_OnEvent)
    F:RegisterEvent('GROUP_ROSTER_UPDATE', COMBAT.Focuser_OnEvent)
end
