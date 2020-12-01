local F, C, L = unpack(select(2, ...))
local THEME = F:GetModule('THEME')


C.Themes = {}
C.BlizzThemes = {}


function THEME:LoadDefaultSkins()
	if IsAddOnLoaded('AuroraClassic') or IsAddOnLoaded('Aurora') or IsAddOnLoaded('Skinner') then return end

	for _, func in pairs(C.BlizzThemes) do
		func()
	end
	wipe(C.BlizzThemes)

	if not FREE_ADB.reskin_blizz then return end

	for addonName, func in pairs(C.Themes) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			func()
			C.Themes[addonName] = nil
		end
	end

	F:RegisterEvent('ADDON_LOADED', function(_, addonName)
		local func = C.Themes[addonName]
		if func then
			func()
			C.Themes[addonName] = nil
		end
	end)
end


local pollingRate, numLines = 0.05, 15
local lines = {}
for i = 1, numLines do
	local line = _G.UIParent:CreateLine()
	line:SetThickness(_G.Lerp(5, 1, (i - 1)/numLines))
	line:SetColorTexture(1, 1, 1)

	local startA, endA = _G.Lerp(1, 0, (i - 1)/numLines), _G.Lerp(1, 0, i/numLines)
	line:SetGradientAlpha("HORIZONTAL", 1, 1, 1, startA, 1, 1, 1, endA)

	lines[i] = {line = line, x = 0, y = 0}
end

local function GetLength(startX, startY, endX, endY)
	local dx, dy = endX - startX, endY - startY

	if dx < 0 then
		dx, dy = -dx, -dy
	end

	return sqrt((dx * dx) + (dy * dy))
end

local function UpdateTrail()
	local startX, startY = _G.GetScaledCursorPosition()

	for i = 1, numLines do
		local info = lines[i]

		local endX, endY = info.x, info.y
		if GetLength(startX, startY, endX, endY) < 0.1 then
			info.line:Hide()
		else
			info.line:Show()
			info.line:SetStartPoint("BOTTOMLEFT", _G.UIParent, startX, startY)
			info.line:SetEndPoint("BOTTOMLEFT", _G.UIParent, endX, endY)
		end

		info.x, info.y = startX, startY
		startX, startY = endX, endY
	end
end


function THEME:CursorTrail()
	if not FREE_ADB.cursor_trail then return end

	_G.C_Timer.NewTicker(pollingRate, UpdateTrail)
end


function THEME:Vignetting()
	if not FREE_ADB.vignetting then return end
	if FREE_ADB.vignetting_alpha == 0 then return end

	local f = CreateFrame('Frame')
	f:SetPoint('TOPLEFT')
	f:SetPoint('BOTTOMRIGHT')
	f:SetFrameLevel(0)
	f:SetFrameStrata('BACKGROUND')
	f.tex = f:CreateTexture()
	f.tex:SetTexture(C.Assets.vig_tex)
	f.tex:SetAllPoints(f)

	f:SetAlpha(FREE_ADB.vignetting_alpha)
end

function THEME:OnLogin()
	self:LoadDefaultSkins()

	self:CursorTrail()
	self:Vignetting()

	self:ReskinDBM()
	self:ReskinPGF()
	self:ReskinREHack()
end


function THEME:LoadWithAddOn(addonName, value, func)
	local function loadFunc(event, addon)
		if not FREE_ADB[value] then return end

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




