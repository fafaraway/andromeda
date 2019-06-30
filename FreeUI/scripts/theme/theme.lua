local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule('Theme')


if IsAddOnLoaded('Aurora') or IsAddOnLoaded('AuroraClassic') then
	print('FreeUI includes an efficient built-in module of theme.')
	print("It's highly recommended that you disable Aurora.")
	return
end

C.themes = {}
C.themes['FreeUI'] = {}


local loader = CreateFrame('Frame')
loader:RegisterEvent('ADDON_LOADED')
loader:SetScript('OnEvent', function(self, event, addon)
	if not C.appearance.enableTheme then return end

	local addonModule = C.themes[addon]
	if addonModule then
		if type(addonModule) == 'function' then
			addonModule()
		else
			for _, moduleFunc in pairs(addonModule) do
				moduleFunc()
			end
		end
	end
end)


function module:Vignette()
	if not C.appearance.enableVignette then return end

	self.f = CreateFrame('Frame', 'ShadowBackground')
	self.f:SetPoint('TOPLEFT')
	self.f:SetPoint('BOTTOMRIGHT')
	self.f:SetFrameLevel(0)
	self.f:SetFrameStrata('BACKGROUND')
	self.f.tex = self.f:CreateTexture()
	self.f.tex:SetTexture(C.AssetsPath..'vignette.tga')
	self.f.tex:SetAllPoints(f)

	self.f:SetAlpha(C.appearance.vignetteAlpha)
end



function module:LoadWithAddOn(addonName, value, func)
	local function loadFunc(event, addon)

		if event == 'PLAYER_ENTERING_WORLD' then
			F:UnregisterEvent(event, loadFunc)
			if IsAddOnLoaded(addonName) then
				func()
				F:UnregisterEvent('ADDON_LOADED', loadFunc)
			end
		elseif event == 'ADDON_LOADED' and addon == addonName then
			func()
			F:UnregisterEvent(event, loadFunc)
		end
	end

	F:RegisterEvent('PLAYER_ENTERING_WORLD', loadFunc)
	F:RegisterEvent('ADDON_LOADED', loadFunc)
end

function module:OnLogin()
	self:ReskinDBM()
	self:ReskinSkada()
	self:ReskinBW()
	self:ReskinPGF()
end


