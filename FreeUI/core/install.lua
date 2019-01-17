local F, C, L = unpack(select(2, ...))


local smoothing = {}
local function Smooth(self, value)
	local _, max = self:GetMinMaxValues()
	if value == self:GetValue() or (self._max and self._max ~= max) then
		smoothing[self] = nil
		self:SetValue_(value)
	else
		smoothing[self] = value
	end
	self._max = max
end

local function SmoothBar(bar)
	bar.SetValue_ = bar.SetValue
	bar.SetValue = Smooth
end

local smoother, min, max = CreateFrame('Frame'), math.min, math.max
smoother:SetScript('OnUpdate', function()
	local rate = GetFramerate()
	local limit = 30/rate
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/3, max(value-cur, limit))
		if new ~= new then
			-- Mad hax to prevent QNAN.
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 2 then
			bar:SetValue_(value)
			smoothing[bar] = nil
		end
	end
end)

local function PixelPerfect()

	local scale
	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	local fixedHeight = 768 / pysHeight

	scale = tonumber(floor(fixedHeight*100 + .5)/100)

	SetCVar("useUiScale", 1)
	SetCVar("uiScale", scale)
	UIParent:SetScale(scale)
end

function F:HelloWorld()
	local f = CreateFrame("Frame", "FreeUI_InstallFrame", UIParent)
	f:SetSize(400, 500)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	F.CreateBD(f)
	F.CreateSD(f)

	local sb = CreateFrame("StatusBar", nil, f)
	sb:SetPoint("BOTTOM", f, "BOTTOM", 0, 60)
	sb:SetSize(320, 20)
	sb:SetStatusBarTexture(C.media.sbTex)
	sb:Hide()
	SmoothBar(sb)

	local sbd = CreateFrame("Frame", nil, sb)
	sbd:SetPoint("TOPLEFT", sb, -1, 1)
	sbd:SetPoint("BOTTOMRIGHT", sb, 1, -1)
	sbd:SetFrameLevel(sb:GetFrameLevel()-1)
	F.CreateBD(sbd, .25)

	local header = f:CreateFontString(nil, "OVERLAY")
	header:SetFontObject(GameFontHighlightLarge)
	header:SetPoint("TOP", f, "TOP", 0, -20)

	local body = f:CreateFontString(nil, "OVERLAY")
	body:SetFontObject(GameFontHighlight)
	body:SetJustifyH("LEFT")
	body:SetWidth(f:GetWidth()-40)
	body:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -60)

	local credits = F.CreateFSAlt(f, 'pixel', "", true, false, "BOTTOM", 0, 4)
	credits:SetText("|cff808080<|rFree|cff9c84efUI|r|cff808080>|r by |cffe8155cHaleth|r and |cff37b1d6Solor|r")

	local sbt = F.CreateFSAlt(sb, 'pixel', "", true, false, "CENTER", 0, 0)

	local option1 = CreateFrame("Button", "FreeUI_Install_Option1", f, "UIPanelButtonTemplate")
	option1:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 40, 20)
	option1:SetSize(128, 25)

	local option2 = CreateFrame("Button", "FreeUI_Install_Option2", f, "UIPanelButtonTemplate")
	option2:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -40, 20)
	option2:SetSize(128, 25)

	local close = CreateFrame("Button", "FreeUI_Install_CloseButton", f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
	close:SetScript("OnClick", function()
		UIFrameFade(f,{
			mode = "OUT",
			timeToFade = 0.5,
			finishedFunc = function(f) f:SetAlpha(1); f:Hide() end,
			finishedArg1 = f,
		})
	end)

	F.Reskin(option1)
	F.Reskin(option2)
	F.ReskinClose(close)



	local step4 = function()
		sb:SetValue(400)
		PlaySoundFile("Sound\\interface\\LevelUp.wav")
		header:SetText("Success!")
		body:SetText("Installation is complete.\n\nPlease click the 'Finish' button to reload the UI.\n\nEnjoy!")
		sbt:SetText("4/4")
		option1:Hide()
		option2:SetText("Finish")

		option2:SetScript("OnClick", function()
			FreeUIConfig["installComplete"] = true
			ReloadUI()
		end)
	end

	local step3 = function()
		sb:SetValue(300)
		header:SetText("3. Chat")
		body:SetText("The third and final step applies the chat settings.\n\nThis step is recommended for any user.")
		sbt:SetText("3/4")

		option1:SetScript("OnClick", step4)
		option2:SetScript("OnClick", function()
			F:ForceChatSettings()
			step4()
		end)
	end

	local step2 = function()
		sb:SetValue(200)
		header:SetText("2. UI Scale")
		body:SetText("The second step applies the correct UI scale.\n\nThis step is recommended for any user.")
		sbt:SetText("2/4")

		option1:SetScript("OnClick", step3)
		option2:SetScript("OnClick", function()
			PixelPerfect()
			step3()
		end)
	end

	local step1 = function()
		sb:SetMinMaxValues(0, 400)
		sb:Show()
		sb:SetValue(0)
		sb:SetValue(100)
		sb:GetStatusBarTexture():SetGradient("VERTICAL", C.r, C.g, C.b, C.r, C.g, C.b)
		header:SetText("1. CVars")
		body:SetText("These steps will apply the correct setup for FreeUI.\n\nThe first step applies the essential settings.\n\nThis is recommended for any user, unless you want to apply only a specific part of the settings.\n\nClick 'Continue' to apply the settings, or click 'Skip' if you wish to skip this step.")
		sbt:SetText("1/4")

		option1:Show()

		option1:SetText("Skip")
		option2:SetText("Continue")

		option1:SetScript("OnClick", step2)
		option2:SetScript("OnClick", function()
			F:ForceDefaultSettings()
			step2()
		end)
	end




	local tut4 = function()
		sb:SetValue(600)
		header:SetText("4. Finished")
		body:SetText("WIP")

		sbt:SetText("4/4")

		option1:Show()

		option1:SetText("Close")
		option2:SetText("Install")

		option1:SetScript("OnClick", function()
			UIFrameFade(f,{
				mode = "OUT",
				timeToFade = 0.5,
				finishedFunc = function(f) f:Hide() end,
				finishedArg1 = f,
			})
		end)
		option2:SetScript("OnClick", step1)
	end

	local tut3 = function()
		sb:SetValue(300)
		header:SetText("3. Features")
		body:SetText("WIP")

		sbt:SetText("3/4")

		option2:SetScript("OnClick", tut4)
	end

	local tut2 = function()
		sb:SetValue(200)
		header:SetText("2. Unit frames")
		body:SetText("WIP")

		sbt:SetText("2/4")

		option2:SetScript("OnClick", tut3)
	end

	local tut1 = function()
		sb:SetMinMaxValues(0, 600)
		sb:Show()
		sb:SetValue(100)
		sb:GetStatusBarTexture():SetGradient("VERTICAL", C.r, C.g, C.b, C.r, C.g, C.b)
		header:SetText("1. Essentials")
		body:SetText("WIP")

		sbt:SetText("1/4")

		option1:Hide()

		option2:SetText("Next")

		option2:SetScript("OnClick", tut2)
	end




	header:SetText("Hello")
	body:SetText("Thank you for choosing FreeUI!\n\nIn just a moment, you can get started. All that's needed is for the correct settings to be applied. Don't worry, none of your personal preferences will be changed.\n\nYou can also take a brief tutorial on some of the features of FreeUI, which is recommended if you're a new user.\n\nPress the 'Tutorial' button to do so now, or press 'Install' to go straight to the setup.")


	option1:SetText("Tutorial")
	option2:SetText("Install")

	option1:SetScript("OnClick", tut1)
	option2:SetScript("OnClick", step1)
end
	



--function module:OnLogin()
--	if not FreeUIConfig["Install"] then
--		FreeUIConfig["Install"] = {}
--F:HelloWorld()
--	end
	
--print(FreeUIConfig["Install"]["Complete"])
	
--end


local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, addon)
	if FreeUIConfig["installComplete"] == true then return end
	F:HelloWorld()
end)