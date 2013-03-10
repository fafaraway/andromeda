local F, C, L = unpack(FreeUI)

local function InitStyle()
	hooksecurefunc(DBT, "CreateBar", function(self)
		for bar in self:GetBarIterator() do
			if not bar.styled then
				local frame = bar.frame
				local name = frame:GetName()

				local tbar = _G[name.."Bar"]
				local texture = _G[name.."BarTexture"]
				local text = _G[name.."BarName"]
				local timer = _G[name.."BarTimer"]

				tbar:SetHeight(16)

				F.CreateBDFrame(tbar, 0)

				texture:SetTexture(C.media.texture)
				texture.SetTexture = F.dummy
				text:SetPoint("CENTER")
				text:SetPoint("LEFT", 4, 0)
				text:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
				text:SetShadowColor(0, 0, 0, 0)
				text.SetFont = F.dummy
				timer:SetPoint("CENTER")
				timer:SetPoint("RIGHT", -4, 0)
				timer:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
				timer:SetShadowColor(0, 0, 0, 0)
				timer.SetFont = F.dummy

				bar.styled = true
			end
		end
	end)

	local firstInfo = true
	hooksecurefunc(DBM.InfoFrame, "Show", function()
		if firstInfo then
			DBMInfoFrame:SetBackdrop(nil)
			local bd = CreateFrame("Frame", nil, DBMInfoFrame)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT")
			bd:SetFrameLevel(DBMInfoFrame:GetFrameLevel()-1)
			F.CreateBD(bd)

			firstInfo = false
		end
	end)

	local firstRange = true
	hooksecurefunc(DBM.RangeCheck, "Show", function()
		if firstRange then
			DBMRangeCheck:SetBackdrop(nil)
			local bd = CreateFrame("Frame", nil, DBMRangeCheck)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT")
			bd:SetFrameLevel(DBMRangeCheck:GetFrameLevel()-1)
			F.CreateBD(bd)

			firstRange = false
		end
	end)

	hooksecurefunc(DBM.BossHealth, "Show", function()
		local anchor = DBMBossHealthDropdown:GetParent()
		if not anchor.styled then
			local header = anchor:GetRegions()
			header:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			header:SetTextColor(1, 1, 1)
			header:SetShadowOffset(0, 0)

			anchor.styled = true
		end
	end)

	local count = 1

	local styleBar = function()
		local bar = _G["DBM_BossHealth_Bar_"..count]

		while bar do
			if not bar.styled then
				local name = bar:GetName()
				local sb = _G[name.."Bar"]
				local text = _G[name.."BarName"]
				local timer = _G[name.."BarTimer"]

				_G[name.."BarBackground"]:Hide()
				_G[name.."BarBorder"]:SetNormalTexture("")

				sb:SetStatusBarTexture(C.media.texture)

				text:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
				text:SetShadowOffset(0, 0)
				timer:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
				timer:SetShadowOffset(0, 0)

				F.CreateBDFrame(sb)

				bar.styled = true
			end

			count = count + 1
			bar = _G["DBM_BossHealth_Bar_"..count]
		end
	end

	hooksecurefunc(DBM.BossHealth, "AddBoss", styleBar)
	hooksecurefunc(DBM.BossHealth, "UpdateSettings", styleBar)
end

if IsAddOnLoaded("DBM-Core") then
	InitStyle()
else
	local load = CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "DBM-Core" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyle()

		load = nil
	end)
end