local F, C, L = unpack(FreeUI)

local function InitStyle()
	hooksecurefunc(DBT, "CreateBar", function(self)
		for bar in self:GetBarIterator() do
			local frame = bar.frame
			local name = frame:GetName().."Bar"
			local tbar = _G[name]
			local text = _G[name.."Name"]

			tbar:SetHeight(4)

			text:SetPoint("CENTER", 0, 10)
			text:SetPoint("LEFT", 2, 10)

			if not bar.styled then
				local texture = _G[name.."Texture"]
				local timer = _G[name.."Timer"]
				local spark = _G[name.."Spark"]
				local icon = _G[name.."Icon1"]

				F.CreateBDFrame(tbar, 0)

				texture:SetTexture(C.media.texture)
				texture.SetTexture = F.dummy

				F.SetFS(text)
				text.SetFont = F.dummy

				timer:SetPoint("CENTER", 0, 10)
				timer:SetPoint("RIGHT", -2, 10)
				F.SetFS(timer)
				timer.SetFont = F.dummy

				spark:SetSize(8, 16)
				spark.SetSize = F.dummy
				spark:SetTexture("Interface\\AddOns\\FreeUI\\media\\DBMSpark")

				icon:ClearAllPoints()
				icon:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -3, 0)
				icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(icon)

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
			F.CreateBDFrame(DBMRangeCheck)

			DBMRangeCheckRadar.background:SetTexture("")
			F.CreateBDFrame(DBMRangeCheckRadar)

			F.SetFS(DBMRangeCheckRadar.text)
			DBMRangeCheckRadar.text:SetTextColor(1, 1, 1)
			F.SetFS(DBMRangeCheckRadar.inRangeText)
			DBMRangeCheckRadar.inRangeText:SetTextColor(1, 1, 1)

			firstRange = false
		end
	end)

	hooksecurefunc(DBM.BossHealth, "Show", function()
		local anchor = DBMBossHealthDropdown:GetParent()
		if not anchor.styled then
			local header = anchor:GetRegions()
			F.SetFS(header)
			header:SetTextColor(1, 1, 1)

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

				F.SetFS(text)
				F.SetFS(timer)

				F.CreateBDFrame(sb)

				bar.styled = true
			end

			count = count + 1
			bar = _G["DBM_BossHealth_Bar_"..count]
		end
	end

	hooksecurefunc(DBM.BossHealth, "AddBoss", styleBar)
	hooksecurefunc(DBM.BossHealth, "UpdateSettings", styleBar)

	hooksecurefunc(DBM, "ShowUpdateReminder", function()
		-- no name or anything
		-- reverse loop because it's most likely to be somewhere at the end
		for i = UIParent:GetNumChildren(), 1, -1 do
			local frame = select(i, UIParent:GetChildren())

			local editBox = frame:GetChildren()
			if editBox and editBox:GetObjectType() == "EditBox" and editBox:GetText() == "http://www.deadlybossmods.com" and not frame.styled then
				F.CreateBD(frame)

				select(6, editBox:GetRegions()):Hide()
				select(7, editBox:GetRegions()):Hide()
				select(8, editBox:GetRegions()):Hide()

				local bg = F.CreateBDFrame(editBox, .25)
				bg:SetPoint("TOPLEFT", -2, -6)
				bg:SetPoint("BOTTOMRIGHT", 2, 8)

				F.Reskin(select(2, frame:GetChildren()))

				frame.styled = true
			end
		end
	end)
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