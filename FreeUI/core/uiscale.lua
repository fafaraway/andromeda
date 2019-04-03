local F, C, L = unpack(select(2, ...))


local uiScale
uiScale = 768 / C.ScreenHeight
uiScale = tonumber(string.sub(uiScale, 0, 5))

local mult = 768 / C.ScreenHeight / uiScale
local Scale = function(x)
	return mult * math.floor(x / mult + 0.5)
end
C.Scale = function(x) return Scale(x) end
C.Mult = mult
C.noScaleMult = C.Mult * uiScale



function F:SetupUIScale()
	if C.general.uiScaleAuto then
		F.HideOption(Advanced_UseUIScale)
		F.HideOption(Advanced_UIScaleSlider)
		SetCVar('useUiScale', 0)
		UIParent:SetScale(uiScale)
	else
		SetCVar('useUiScale', 1)
		SetCVar('uiScale', C.general.uiScale)
	end
end


local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript('OnEvent', function(self, event, addon)
	if FreeUIConfig['installComplete'] ~= true then return end

	F:SetupUIScale()

	--print('cvarScale - '.._G.GetCVar('uiscale'))
	--print('parentScale - '.._G.UIParent:GetScale())
	--print(C.general.uiScale)
	--print(uiScale)
	--print(C.Mult)
end)