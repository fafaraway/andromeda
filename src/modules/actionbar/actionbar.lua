local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')


function ACTIONBAR:OnLogin()
    ACTIONBAR.buttons = {}

    if not C.DB['Actionbar']['Enable'] then
        return
    end

    ACTIONBAR.movers = {}

    ACTIONBAR:CreateBars()
    ACTIONBAR:CreateExtraBar()
    ACTIONBAR:CreateVehicleBar()
    ACTIONBAR:CreatePetBar()
    ACTIONBAR:CreateStanceBar()
    ACTIONBAR:RestyleButtons()
    ACTIONBAR:UpdateBarConfig()
    ACTIONBAR:UpdateVisibility()
    ACTIONBAR:UpdateAllSize()
    ACTIONBAR:RemoveBlizzStuff()
    ACTIONBAR:CooldownNotify()
    -- ACTIONBAR:BarFade()

    if C_PetBattles.IsInBattle() then
        ACTIONBAR:ClearBindings()
    else
        ACTIONBAR:ReassignBindings()
    end

    F:RegisterEvent('UPDATE_BINDINGS', ACTIONBAR.ReassignBindings)
    F:RegisterEvent('PET_BATTLE_CLOSE', ACTIONBAR.ReassignBindings)
    F:RegisterEvent('PET_BATTLE_OPENING_DONE', ACTIONBAR.ClearBindings)
end
