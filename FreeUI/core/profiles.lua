local F, C = unpack(select(2, ...))


C.DevsList = {
	['呂碧城-白银之手'] = true,
}

local function isDeveloper()
	return C.DevsList[C.MyName..'-'..C.MyRealm]
end

C.isDeveloper = isDeveloper()

if C.isDeveloper then
	--C.Actionbar.bar1_visibility = '[mod:shift][@vehicle,exists][overridebar][shapeshift][vehicleui][possessbar,@vehicle,exists] show; hide'
end

if C.isDeveloper then
	C.Assets.Fonts.Normal = 'Fonts\\FreeUI\\normal.ttf'
	C.Assets.Fonts.Header = 'Fonts\\FreeUI\\header.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\FreeUI\\chat.ttf'
	C.Assets.Fonts.Number = 'Fonts\\FreeUI\\number.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\FreeUI\\combat.ttf'
elseif C.Client == 'zhCN' then
	C.Assets.Fonts.Normal = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Header = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Number = 'Fonts\\ARKai_T.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\ARKai_C.ttf'
elseif C.Client == 'zhTW' then
	C.Assets.Fonts.Normal = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Header = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Number = 'Fonts\\blei00d.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\bKAI00M.ttf'
elseif C.Client == 'koKR' then
	C.Assets.Fonts.Normal = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Header = 'Fonts\\2002B.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Number = 'Fonts\\2002.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\K_Damage.ttf'
elseif C.Client == 'ruRU' then
	C.Assets.Fonts.Normal = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Header = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Chat   = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Number = 'Fonts\\FRIZQT___CYR.ttf'
	C.Assets.Fonts.Combat = 'Fonts\\FRIZQT___CYR.ttf'
end




F:RegisterEvent('PLAYER_ENTERING_WORLD', function()

end)

