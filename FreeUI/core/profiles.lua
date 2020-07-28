local F, C = unpack(select(2, ...))



C.isDeveloper = true
if not C.isDeveloper then return end

C.Actionbar.bar1_visibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'
C.Actionbar.bar2 = false
C.Actionbar.bar3 = false

C.Unitframe.player_hide_tags = true
C.Unitframe.enable_pet = false
C.Unitframe.player_height = 7
C.Unitframe.target_height = 7


-- Override fonts
C.Assets.Fonts.Normal = 'Fonts\\FreeUI\\sarasa_newjune_semibold.ttf'
C.Assets.Fonts.Header = 'Fonts\\FreeUI\\header.ttf'
C.Assets.Fonts.Chat   = 'Fonts\\New folder\\Naowh.ttf'
C.Assets.Fonts.Number = 'Fonts\\FreeUI\\sarasa_tccc.ttf'

STANDARD_TEXT_FONT = 'Fonts\\FreeUI\\sarasa_newjune_semibold.ttf'
UNIT_NAME_FONT     = 'Fonts\\FreeUI\\header.ttf'
DAMAGE_TEXT_FONT   = 'Fonts\\FreeUI\\damage.ttf'


-- disbale talent alert
function MainMenuMicroButton_AreAlertsEffectivelyEnabled()
	return false
end

F:RegisterEvent('PLAYER_ENTERING_WORLD', function()
	--[[ F.Print('C.ScreenWidth '..C.ScreenWidth)
	F.Print('C.ScreenHeight '..C.ScreenHeight)
	F.Print('C.Mult '..C.Mult)
	F.Print('uiScale '..C.General.uiScale)
	F.Print('UIParentScale '..UIParent:GetScale()) ]]
end)

