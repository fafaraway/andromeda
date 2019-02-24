local F, C, L = unpack(select(2, ...))
local module = F:RegisterModule("Theme")

if IsAddOnLoaded("Aurora") or IsAddOnLoaded("AuroraClassic") then
	print("FreeUI includes an efficient built-in module of theme.")
	print("It's highly recommended that you disable Aurora.")
	return
end

C.themes = {}
C.themes["FreeUI"] = {}

-- mirror bar
local function ReskinMirrorBar(timer, value, maxvalue, scale, paused, label)
	local previous
	for i = 1, MIRRORTIMER_NUMTIMERS, 1 do
		local frame = _G["MirrorTimer"..i]
		if not frame.isSkinned then
			F.StripTextures(frame, true)
			frame:SetSize(200*C.Mult, 16*C.Mult)

			local bg = F.CreateBDFrame(frame)
			F.CreateSD(bg)

			local statusbar = _G["MirrorTimer"..i.."StatusBar"]
			statusbar:SetAllPoints()
			statusbar:SetStatusBarTexture(C.media.sbTex)
		
			local text = _G["MirrorTimer"..i.."Text"]
			text:ClearAllPoints()
			text:SetPoint("CENTER", statusbar)
			
			if C.Client == 'zhCN' or C.Client == 'zhTW' then
				text:SetFont(C.font.normal, 12)
				text:SetShadowColor(0,0,0,1)
				text:SetShadowOffset(2, -2)
			else
				F.SetFS(text)
				text:SetShadowColor(0,0,0,1)
				text:SetShadowOffset(1, -1)
			end

			if previous then
				frame:SetPoint("TOP", previous, "BOTTOM", 0, -5)
			end
			previous = frame
			
			frame.isSkinned = true
		end
	end
end
hooksecurefunc("MirrorTimer_Show", ReskinMirrorBar)

-- timer tracker
local function ReskinTimerTrakcer(bar)
	bar:SetHeight(16)
	bar:SetWidth(200)

	for i = 1, bar:GetNumRegions() do
		local region = _G.select(i, bar:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			F.SetFS(region)
		end
	end

	bar:SetStatusBarTexture(C.media.sbTex)
	bar:SetStatusBarColor(1, 0, 0)

	local bg = F.CreateBDFrame(bar)
	F.CreateSD(bg)
end

local f = _G.CreateFrame("Frame")
f:RegisterEvent("START_TIMER")
f:SetScript("OnEvent", function()
	for _, timer in _G.ipairs(_G.TimerTracker.timerList) do
		if timer.bar and not timer.skinned then
			ReskinTimerTrakcer(timer.bar)
			timer.skinned = true
		end
	end
end)



local Skin = CreateFrame("Frame", nil, UIParent)
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	if not C.appearance.enableTheme then return end
	
	local addonModule = C.themes[addon]
	if addonModule then
		if type(addonModule) == "function" then
			addonModule()
		else
			for _, moduleFunc in pairs(addonModule) do
				moduleFunc()
			end
		end
	end
end)

function module:LoadWithAddOn(addonName, value, func)
	local function loadFunc(event, addon)

		if event == "PLAYER_ENTERING_WORLD" then
			F:UnregisterEvent(event, loadFunc)
			if IsAddOnLoaded(addonName) then
				func()
				F:UnregisterEvent("ADDON_LOADED", loadFunc)
			end
		elseif event == "ADDON_LOADED" and addon == addonName then
			func()
			F:UnregisterEvent(event, loadFunc)
		end
	end

	F:RegisterEvent("PLAYER_ENTERING_WORLD", loadFunc)
	F:RegisterEvent("ADDON_LOADED", loadFunc)
end

function module:OnLogin()
	self:ReskinDBM()
	self:ReskinSkada()
	self:ReskinBigWigs()
	self:ReskinPGF()
end