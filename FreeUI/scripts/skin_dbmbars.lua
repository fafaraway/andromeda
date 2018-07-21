local F, C, L = unpack(select(2, ...))

local function InitStyleDBM()
	if not IsAddOnLoaded("DBM-Core") then return end

	local buttonsize = 22
	local function SkinBars(self)
		for bar in self:GetBarIterator() do
			if not bar.injected then
				local frame		= bar.frame
				local tbar		= _G[frame:GetName().."Bar"]
				local spark		= _G[frame:GetName().."BarSpark"]
				local texture	= _G[frame:GetName().."BarTexture"]
				local icon1		= _G[frame:GetName().."BarIcon1"]
				local icon2		= _G[frame:GetName().."BarIcon2"]
				local name		= _G[frame:GetName().."BarName"]
				local timer		= _G[frame:GetName().."BarTimer"]

				if not (icon1.overlay) then
					icon1.overlay = CreateFrame("Frame", "$parentIcon1Overlay", tbar)
					icon1.overlay:SetSize(buttonsize+2, buttonsize+2)
					icon1.overlay:SetFrameStrata("BACKGROUND")
					icon1.overlay:SetPoint("BOTTOMRIGHT", tbar, "BOTTOMLEFT", -buttonsize/6, -3)

					local backdroptex = icon1.overlay:CreateTexture(nil, "BORDER")
					backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
					backdroptex:SetPoint("TOPLEFT", icon1.overlay, "TOPLEFT", 1, -1)
					backdroptex:SetPoint("BOTTOMRIGHT", icon1.overlay, "BOTTOMRIGHT", -1, 1)
					backdroptex:SetTexCoord(.08, .92, .08, .92)
					F.CreateSD(icon1.overlay)
				end

				if not (icon2.overlay) then
					icon2.overlay = CreateFrame("Frame", "$parentIcon2Overlay", tbar)
					icon2.overlay:SetSize(buttonsize+2, buttonsize+2)
					icon2.overlay:SetPoint("BOTTOMLEFT", tbar, "BOTTOMRIGHT", buttonsize/6, -3)

					local backdroptex = icon2.overlay:CreateTexture(nil, "BORDER")
					backdroptex:SetTexture([=[Interface\Icons\Spell_Nature_WispSplode]=])
					backdroptex:SetPoint("TOPLEFT", icon2.overlay, "TOPLEFT", 1, -1)
					backdroptex:SetPoint("BOTTOMRIGHT", icon2.overlay, "BOTTOMRIGHT", -1, 1)
					backdroptex:SetTexCoord(.08, .92, .08, .92)
					F.CreateSD(icon2.overlay)
				end

				if bar.color then
					tbar:SetStatusBarColor(bar.color.r, bar.color.g, bar.color.b)
				else
					tbar:SetStatusBarColor(bar.owner.options.StartColorR, bar.owner.options.StartColorG, bar.owner.options.StartColorB)
				end

				if bar.enlarged then frame:SetWidth(bar.owner.options.HugeWidth) else frame:SetWidth(bar.owner.options.Width) end
				if bar.enlarged then tbar:SetWidth(bar.owner.options.HugeWidth) else tbar:SetWidth(bar.owner.options.Width) end

				if not frame.styled then
					frame:SetScale(1)
					frame.SetScale = F.dummy
					frame:SetHeight(buttonsize/2)
					frame.SetHeight = F.dummy
					if not frame.bg then
						frame.bg = CreateFrame("Frame", nil, frame)
						frame.bg:SetAllPoints()
					end
					F.CreateSD(frame.bg)
					F.CreateBD(frame.bg, .4)
					frame.styled = true
				end

				if not spark.killed then
					spark:SetAlpha(0)
					spark:SetTexture(nil)
					spark.killed = true
				end

				if not icon1.styled then
					icon1:SetTexCoord(.08, .92, .08, .92)
					icon1:ClearAllPoints()
					icon1:SetPoint("TOPLEFT", icon1.overlay, 1, -1)
					icon1:SetPoint("BOTTOMRIGHT", icon1.overlay, -1, 1)
					icon1.SetSize = F.dummy
					icon1.styled = true
					F.CreateBG(icon1)
				end

				if not icon2.styled then
					icon2:SetTexCoord(.08, .92, .08, .92)
					icon2:ClearAllPoints()
					icon2:SetPoint("TOPLEFT", icon2.overlay, 1, -1)
					icon2:SetPoint("BOTTOMRIGHT", icon2.overlay, -1, 1)
					icon2.SetSize = F.dummy
					icon2.styled = true
					-- F.CreateBG(icon2)
				end

				if not texture.styled then
					texture:SetTexture(C.media.texture)
					texture.styled = true
				end

				tbar:SetStatusBarTexture(C.media.texture)
				if not tbar.styled then
					tbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
					tbar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
					tbar.SetPoint = F.dummy
					tbar.styled = true

					tbar.Spark = tbar:CreateTexture(nil, "OVERLAY")
					tbar.Spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
					tbar.Spark:SetBlendMode("ADD")
					tbar.Spark:SetAlpha(.8)
					tbar.Spark:SetPoint("TOPLEFT", tbar:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
					tbar.Spark:SetPoint("BOTTOMRIGHT", tbar:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
				end

				if not name.styled then
					name:ClearAllPoints()
					name:SetPoint("LEFT", frame, "LEFT", 2, 14)
					name:SetPoint("RIGHT", frame, "LEFT", tbar:GetWidth()*.85, 8)
					name.SetPoint = F.dummy
					-- F.SetFS(name)
					name:SetFont(C.font.normal, 12, "OUTLINE")
					name.SetFont = F.dummy
					name:SetJustifyH("LEFT")
					name:SetWordWrap(false)
					name:SetShadowColor(0, 0, 0, 0)
					name.styled = true
				end

				if not timer.styled then
					timer:ClearAllPoints()
					timer:SetPoint("RIGHT", frame, "RIGHT", -2, 12)
					timer.SetPoint = F.dummy
					F.SetFS(timer)
					timer.SetFont = F.dummy
					timer:SetJustifyH("RIGHT")
					timer:SetShadowColor(0, 0, 0, 0)
					timer.styled = true
				end

				if bar.owner.options.IconLeft then icon1:Show() icon1.overlay:Show() else icon1:Hide() icon1.overlay:Hide() end
				if bar.owner.options.IconRight then icon2:Show() icon2.overlay:Show() else icon2:Hide() icon2.overlay:Hide() end
				tbar:SetAlpha(1)
				frame:SetAlpha(1)
				texture:SetAlpha(1)
				frame:Show()
				bar:Update(0)
				bar.injected = true
			end
		end
	end

	hooksecurefunc(DBT, "CreateBar", SkinBars)
	-- hooksecurefunc(DBM.BossHealth, "Show", SkinBossTitle)
	-- hooksecurefunc(DBM.BossHealth, "AddBoss", SkinBoss)
	-- hooksecurefunc(DBM.BossHealth, "UpdateSettings", SkinBoss)

	local function SkinRange()
		if DBMRangeCheckRadar and not DBMRangeCheckRadar.styled then
			local bg = F.CreateBDFrame(DBMRangeCheckRadar, .3)


			DBMRangeCheckRadar.styled = true
		end

		if DBMRangeCheck and not DBMRangeCheck.styled then
			F.CreateBDFrame(DBMRangeCheck)

			DBMRangeCheck.SetBackdropColor = F.Dummy
			DBMRangeCheck.SetBackdropBorderColor = F.Dummy

			DBMRangeCheck.styled = true
		end
	end
	hooksecurefunc(DBM.RangeCheck, "Show", SkinRange)

	hooksecurefunc(DBM.InfoFrame, "Show", function()
		DBMInfoFrame:SetBackdrop(nil)
		local bd = CreateFrame("Frame", nil, DBMInfoFrame)
		bd:SetPoint("TOPLEFT")
		bd:SetPoint("BOTTOMRIGHT")
		bd:SetFrameLevel(DBMInfoFrame:GetFrameLevel()-1)
		F.CreateBDFrame(bd, .45)

	end)

	local RaidNotice_AddMessage_ = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(noticeFrame, textString, colorInfo)
		if textString:find("|T") then
            if textString:match(":(%d+):(%d+)") then
                local size1, size2 = textString:match(":(%d+):(%d+)")
                size1, size2 = size1 + 3, size2 + 3
                textString = string.gsub(textString,":(%d+):(%d+)",":"..size1..":"..size2..":0:0:64:64:5:59:5:59")
            elseif textString:match(":(%d+)|t") then
                local size = textString:match(":(%d+)|t")
                size = size + 3
                textString = string.gsub(textString,":(%d+)|t",":"..size..":"..size..":0:0:64:64:5:59:5:59|t")
            end
		end
		return RaidNotice_AddMessage_(noticeFrame, textString, colorInfo)
	end


end

if IsAddOnLoaded("DBM-Core") then
	InitStyleDBM()
else
	local load = CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "DBM-Core" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyleDBM()

		load = nil
	end)
end
