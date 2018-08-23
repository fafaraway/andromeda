local F, C = unpack(select(2, ...))
local module = F:RegisterModule("uiscale")

-- UI scale
local function ForceUIScale()
	--F.HideOption(Advanced_UseUIScale)
	--F.HideOption(Advanced_UIScaleSlider)

	local scale = C.misc.uiScale
	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	if C.misc.uiScaleAuto then
		scale = 768 / pysHeight
		C.misc.uiScale = scale
	end

	_G.SetCVar("useUiScale", 0)
	_G.SetCVar("uiScale", scale)
	_G.UIParent:SetScale(scale)

	local function RestoreUIScale(scale)
		_G.UIParent:SetScale(scale)
		if C.chat.lockPosition then
			ChatFrame1:ClearAllPoints()
			ChatFrame1:SetPoint(unpack(C.chat.position))
		end
	end

	F:RegisterEvent("UI_SCALE_CHANGED", function()
		C_Timer.After(1, function()
			if UIParent:GetScale() ~= scale then
				RestoreUIScale(scale)
			end
		end)
	end)


	--local cvarScale, parentScale = _G.GetCVar("uiscale"), _G.UIParent:GetScale()
	--print(cvarScale)
	--print(parentScale)
end



function module:OnLogin()
	ForceUIScale()
end