local F, C, L = unpack(FreeUI)

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

hooksecurefunc(DBM.BossHealth, "Show", function()
	local anchor = DBMBossHealthDropdown:GetParent()
	if not anchor.styled then
		local header = anchor:GetRegions()
		if header:IsObjectType("FontString") then
			header:SetFont(C.media.font, 8, "OUTLINEMONOCHROME")
			header:SetTextColor(1, 1, 1)
			header:SetShadowOffset(0, 0)
			anchor.styled = true
		end
	end
end)

local count = 1

local styleBar = function()
	local bar = _G[format("DBM_BossHealth_Bar_%d", count)]

	while bar do
		if not bar.styled then
			local name = bar:GetName()
			local sb = _G[name.."Bar"]
			local text = _G[name.."BarName"]
			local timer = _G[name.."BarTimer"]

			local prev = _G[format("DBM_BossHealth_Bar_%d", count-1)]

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
		bar = _G[format("DBM_BossHealth_Bar_%d", count)]
	end
end

hooksecurefunc(DBM.BossHealth, "AddBoss", styleBar)
hooksecurefunc(DBM.BossHealth, "UpdateSettings", styleBar)