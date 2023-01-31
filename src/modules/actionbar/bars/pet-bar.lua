local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

local function hasPetActionHighlightMark(index)
    return _G.PET_ACTION_HIGHLIGHT_MARKS[index]
end

function ACTIONBAR:UpdatePetBar()
    local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
    for i = 1, _G.NUM_PET_ACTION_SLOTS, 1 do
        petActionButton = self.actionButtons[i]
        petActionIcon = petActionButton.icon
        petAutoCastableTexture = petActionButton.AutoCastable
        petAutoCastShine = petActionButton.AutoCastShine

        local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(i)
        if not isToken then
            petActionIcon:SetTexture(texture)
            petActionButton.tooltipName = name
        else
            petActionIcon:SetTexture(_G[texture])
            petActionButton.tooltipName = _G[name]
        end
        petActionButton.isToken = isToken
        if spellID then
            local spell = Spell:CreateFromSpellID(spellID)
            petActionButton.spellDataLoadedCancelFunc = spell:ContinueWithCancelOnSpellLoad(function()
                petActionButton.tooltipSubtext = spell:GetSpellSubtext()
            end)
        end
        if isActive then
            if IsPetAttackAction(i) then
                petActionButton:StartFlash()
                -- the checked texture looks a little confusing at full alpha (looks like you have an extra ability selected)
                petActionButton:GetCheckedTexture():SetAlpha(0.5)
            else
                petActionButton:StopFlash()
                petActionButton:GetCheckedTexture():SetAlpha(1.0)
            end
            petActionButton:SetChecked(true)
        else
            petActionButton:StopFlash()
            petActionButton:SetChecked(false)
        end
        if autoCastAllowed then
            petAutoCastableTexture:Show()
        else
            petAutoCastableTexture:Hide()
        end
        if autoCastEnabled then
            AutoCastShine_AutoCastStart(petAutoCastShine)
        else
            AutoCastShine_AutoCastStop(petAutoCastShine)
        end
        if texture then
            if GetPetActionSlotUsable(i) then
                petActionIcon:SetVertexColor(1, 1, 1)
            else
                petActionIcon:SetVertexColor(0.4, 0.4, 0.4)
            end
            petActionIcon:Show()
        else
            petActionIcon:Hide()
        end

        SharedActionButton_RefreshSpellHighlight(petActionButton, hasPetActionHighlightMark(i))
    end
    self:UpdateCooldowns()
    self.rangeTimer = -1
end

function ACTIONBAR.PetBarOnEvent(event)
    if event == 'PET_BAR_UPDATE_COOLDOWN' then
        _G.PetActionBar:UpdateCooldowns()
    else
        ACTIONBAR.UpdatePetBar(_G.PetActionBar)
    end
end

function ACTIONBAR:CreatePetBar()
    if not C.DB['Actionbar']['BarPet'] then
        return
    end

    local margin = C.DB['Actionbar']['ButtonMargin']
    local num = _G.NUM_PET_ACTION_SLOTS
    local buttonList = {}

    local frame = CreateFrame('Frame', C.ADDON_TITLE .. 'ActionBarPet', _G.UIParent, 'SecureHandlerStateTemplate')
    frame.mover = F.Mover(frame, L['PetBar'], 'PetBar', { 'BOTTOM', _G[C.ADDON_TITLE .. 'ActionBar2'], 'TOP', 0, margin })
    ACTIONBAR.movers[10] = frame.mover

    for i = 1, num do
        local button = _G['PetActionButton' .. i]
        button:SetParent(frame)
        tinsert(buttonList, button)
        tinsert(ACTIONBAR.buttons, button)

        local hotkey = button.HotKey
        if hotkey then
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT')
        end
    end
    frame.buttons = buttonList

    frame.frameVisibility = '[petbattle][overridebar][vehicleui][possessbar][shapeshift] hide; [pet] show; hide'
    RegisterStateDriver(frame, 'visibility', frame.frameVisibility)

    -- Fix pet bar updating
    ACTIONBAR:PetBarOnEvent()

    F:RegisterEvent('UNIT_PET', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('UNIT_FLAGS', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PET_UI_UPDATE', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PET_BAR_UPDATE', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PLAYER_CONTROL_LOST', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PLAYER_CONTROL_GAINED', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PLAYER_TARGET_CHANGED', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PET_BAR_UPDATE_USABLE', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PET_BAR_UPDATE_COOLDOWN', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PLAYER_MOUNT_DISPLAY_CHANGED', ACTIONBAR.PetBarOnEvent)
    F:RegisterEvent('PLAYER_FARSIGHT_FOCUS_CHANGED', ACTIONBAR.PetBarOnEvent)
end
