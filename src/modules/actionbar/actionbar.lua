local F, C, L = unpack(select(2, ...))
local ACTIONBAR = F:GetModule('ActionBar')

function ACTIONBAR:OnLogin()
    ACTIONBAR.buttons = {}

    if not C.DB.Actionbar.Enable then
        return
    end

    -- make sure bar2 - bar5 are enabled in blizz options
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_2', true)
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_3', true)
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_4', true)
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_5', true)
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_6', true)
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_7', true)
    _G.Settings.SetValue('PROXY_SHOW_ACTIONBAR_8', true)

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
    ACTIONBAR:BarFader()

    if C_PetBattles.IsInBattle() then
        ACTIONBAR:ClearBindings()
    else
        ACTIONBAR:ReassignBindings()
    end

    F:RegisterEvent('UPDATE_BINDINGS', ACTIONBAR.ReassignBindings)
    F:RegisterEvent('PET_BATTLE_CLOSE', ACTIONBAR.ReassignBindings)
    F:RegisterEvent('PET_BATTLE_OPENING_DONE', ACTIONBAR.ClearBindings)
end
