local F, C, L = unpack(select(2, ...))
local UISCALE = F:RegisterModule('UIScale')


local min, max, tonumber = math.min, math.max, tonumber


local function clipScale(scale)
	return tonumber(format("%.5f", scale))
end

local function GetPerfectScale()
	local _, height = GetPhysicalScreenSize()
	local scale = C.general.uiScale
	local bestScale = max(.4, min(1.15, 768 / height))
	local pixelScale = 768 / height

	if C.general.uiScaleAuto then scale = clipScale(bestScale) end

	C.Mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	return scale
end

local isScaling = false
function UISCALE:SetupUIScale()
	if isScaling then return end
	isScaling = true

	local scale = GetPerfectScale()
	local parentScale = UIParent:GetScale()
	if scale ~= parentScale then
		UIParent:SetScale(scale)
	end

	C.general.uiScale = clipScale(scale)

	isScaling = false
end
UISCALE:SetupUIScale()


function UISCALE:OnLogin()
	if FreeUIConfig['installComplete'] ~= true then return end

	if C.general.uiScaleAuto then
		F.HideOption(Advanced_UseUIScale)
		F.HideOption(Advanced_UIScaleSlider)
	end
	
	self:SetupUIScale()



	--print('cvar_useUiScale - '.._G.GetCVar('useUiScale'))
	--print('cvar_uiScale - '.._G.GetCVar('uiscale'))
	--print('UIParent_Scale - '.._G.UIParent:GetScale())
	--print(C.general.uiScale)

	--print(C.Mult)
end



