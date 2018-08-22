local F, C = unpack(select(2, ...))
local module = F:RegisterModule("uiscale")

-- UI scale
local function ForceUIScale()
	F.HideOption(Advanced_UseUIScale)
	F.HideOption(Advanced_UIScaleSlider)

	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	local pixelScale = 768 / pysHeight

	SetCVar("useUiScale", C.misc.uiScale)

	local function RestoreUIScale(scale)
		if C.misc.uiScaleAuto then
			_G.UIParent:SetScale(pixelScale)
		else
			_G.UIParent:SetScale(C.misc.uiScale)
		end

		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint(unpack(C.chat.position))
	end

	F:RegisterEvent("PLAYER_ENTERING_WORLD", function()


		C_Timer.After(1, function()
			if _G.UIParent:GetScale() ~= pixelScale then
				RestoreUIScale(scale)
			end
		end)
	end)
end



function module:OnLogin()
	ForceUIScale()
end