-- by Alza

local F, C, L = unpack(select(2, ...))

for i = 1, 3 do
	local barname = "MirrorTimer"..i
	local bar = _G[barname]

	bar:SetParent(UIParent)
	bar:SetScale(1)
	bar:SetHeight(16)

	local bg = CreateFrame("Frame", nil, bar)
	bg:SetPoint("TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(bar:GetFrameLevel()-1)
	F.CreateBD(bg)

	bar:GetRegions():Hide()

	_G[barname.."Border"]:Hide()

	_G[barname.."Text"] = F.CreateFS(bar, 8)
	_G[barname.."Text"]:ClearAllPoints()
	_G[barname.."Text"]:SetPoint("CENTER", _G[barname.."StatusBar"])

	_G[barname.."StatusBar"]:ClearAllPoints()
	_G[barname.."StatusBar"]:SetAllPoints(bar)
	_G[barname.."StatusBar"]:SetStatusBarTexture(C.media.texture)
end

-- by Tukz

local function SkinIt(bar)
	for i = 1, bar:GetNumRegions() do
		local region = select(i, bar:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			region:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			region:SetShadowColor(0, 0, 0, 0)
		end
	end

	bar:SetStatusBarTexture(C.media.texture)
	--bar:SetStatusBarColor(170/255, 10/255, 10/255)

	bar.bg = CreateFrame("Frame", nil, bar)
	bar.bg:SetPoint("TOPLEFT", -1, 1)
	bar.bg:SetPoint("BOTTOMRIGHT", 1, -1)
	bar.bg:SetFrameLevel(0)
	F.CreateBD(bar.bg)
end


local function SkinBlizzTimer(self, event)
	for _, b in pairs(TimerTracker.timerList) do
		if not b["bar"].skinned then
			SkinIt(b["bar"])
			b["bar"].skinned = true
		end
	end
end

local load = CreateFrame("Frame")
load:RegisterEvent("START_TIMER")
load:SetScript("OnEvent", SkinBlizzTimer)