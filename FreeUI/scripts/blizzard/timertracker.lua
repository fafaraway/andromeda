local F, C, L = unpack(select(2, ...))


local function SkinBar(bar)
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

	bar:SetStatusBarTexture(C.media.texture)
	bar:SetStatusBarColor(1, 0, 0)

	local bg = F.CreateBDFrame(bar)
	F.CreateSD(bg)
end

local f = _G.CreateFrame("Frame")
f:RegisterEvent("START_TIMER")
f:SetScript("OnEvent", function()
	for _, timer in _G.ipairs(_G.TimerTracker.timerList) do
		if timer.bar and not timer.skinned then
			SkinBar(timer.bar)
			timer.skinned = true
		end
	end
end)