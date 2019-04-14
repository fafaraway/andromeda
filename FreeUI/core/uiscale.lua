local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule('UIScale')

function module:SetupUIScale()
	local _, height = GetPhysicalScreenSize()
	local scale = C.general.uiScale

	if C.general.uiScaleAuto then
		scale = 768 / height
	end

	scale = tonumber(string.sub(scale, 0, 7))

	C.Mult = 768 / height / scale
	C.general.uiScale = scale

	SetCVar('useUiScale', 1)

	if scale < 0.64 then
		SetCVar('uiScale', 1)
		UIParent:SetScale(scale)
	else
		SetCVar('uiScale', scale)
	end
end
module:SetupUIScale()

function module:OnLogin()
	if FreeUIConfig['installComplete'] ~= true then return end

	if C.general.uiScaleAuto then
		F.HideOption(Advanced_UseUIScale)
		F.HideOption(Advanced_UIScaleSlider)
	end
	
	self:SetupUIScale()

	F:RegisterEvent('UI_SCALE_CHANGED', module.SetupUIScale)


	--print('cvar_useUiScale - '.._G.GetCVar('useUiScale'))
	--print('cvar_uiScale - '.._G.GetCVar('uiscale'))
	--print('UIParent_Scale - '.._G.UIParent:GetScale())
	--print(C.general.uiScale)

	--print(C.Mult)
end



