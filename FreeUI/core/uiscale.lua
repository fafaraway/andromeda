local F, C = unpack(select(2, ...))
local module = F:RegisterModule("uiscale")

-- UI scale
local function ForceUIScale()
	F.HideOption(Advanced_UseUIScale)
	F.HideOption(Advanced_UIScaleSlider)

	local scale = C.misc.uiScale
	local pysWidth, pysHeight = _G.GetPhysicalScreenSize()
	if C.misc.uiScaleAuto then
		scale = 768 / pysHeight
		local minScale = .64
		if pysHeight > 1080 then minScale = .5 end
		if scale < minScale then scale = minScale end
		C.misc.uiScale = scale
	end

	SetCVar("useUiScale", 1)
	if scale < .64 then
		UIParent:SetScale(scale)
	else
		SetCVar("uiScale", scale)
	end

	-- Restore from Auto-scaling
	local function RestoreUIScale(scale)
		UIParent:SetScale(scale)
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint(unpack(C.chat.position))
	end

	F:RegisterEvent("UI_SCALE_CHANGED", function()
		if scale < .64 then RestoreUIScale(scale) end

		C_Timer.After(1, function()
			if scale < .64 and UIParent:GetScale() ~= scale then
				RestoreUIScale(scale)
			end
		end)
	end)
end

F.AddOptionsCallback("general", "uiScaleAuto", function()
	if C.misc.uiScaleAuto then
		F:RegisterEvent("UI_SCALE_CHANGED", ForceUIScale)
		ForceUIScale()
	else
		F:UnregisterEvent("UI_SCALE_CHANGED", ForceUIScale)
	end
end)

function module:OnLogin()

	ForceUIScale()

end