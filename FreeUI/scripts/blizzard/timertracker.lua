local F, C, L = unpack(select(2, ...))
local BLIZZARD = F:GetModule('Blizzard')


local function SkinIt(bar)
	for i = 1, bar:GetNumRegions() do
		local region = select(i, bar:GetRegions())
		if region:GetObjectType() == 'Texture' then
			region:SetTexture(nil)
		elseif region:GetObjectType() == 'FontString' then
			F.SetFS(region)
		end
	end

	bar:SetSize(200, 20)

	bar:SetStatusBarTexture(C.media.sbTex)
	bar:SetStatusBarColor(0.7, 0, 0)

	bar.bg = F.CreateBDFrame(bar)
	bar.glow = F.CreateSD(bar.bg)
end

local function SkinBlizzTimer()
	for _, b in pairs(TimerTracker.timerList) do
		if b['bar'] and not b['bar'].skinned then
			SkinIt(b['bar'])
			b['bar'].skinned = true
		end
	end
end

local f = CreateFrame('Frame')
f:RegisterEvent('START_TIMER')
f:SetScript('OnEvent', SkinBlizzTimer)