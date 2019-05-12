local F, C, L = unpack(select(2, ...))
local module = F:GetModule("Theme")


function module:ReskinBigWigs()
	if not C.appearance.reskinBW then return end
	if not IsAddOnLoaded("BigWigs") then return end

	-- Force Settings
	if not BigWigs3DB then return end
	BigWigs3DB["namespaces"]["BigWigs_Plugins_Bars"]["profiles"]["Default"]["barStyle"] = "FreeUI"

	local function removeStyle(bar)
		bar.candyBarBackdrop:Hide()
		local height = bar:Get("bigwigs:restoreheight")
		if height then
			bar:SetHeight(height)
		end

		local tex = bar:Get("bigwigs:restoreicon")
		if tex then
			bar:SetIcon(tex)
			bar:Set("bigwigs:restoreicon", nil)
			bar.candyBarIconFrameBackdrop:Hide()
		end

		bar.candyBarDuration:ClearAllPoints()
		bar.candyBarDuration:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
		bar.candyBarDuration:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
		bar.candyBarLabel:ClearAllPoints()
		bar.candyBarLabel:SetPoint("TOPLEFT", bar.candyBarBar, "TOPLEFT", 2, 0)
		bar.candyBarLabel:SetPoint("BOTTOMRIGHT", bar.candyBarBar, "BOTTOMRIGHT", -2, 0)
	end

	local function styleBar(bar)
		local height = bar:GetHeight()
		bar:Set("bigwigs:restoreheight", height)
		bar:SetHeight(height/2)
		bar:SetTexture(C.media.sbTex)

		local bd = bar.candyBarBackdrop
		F.CreateBD(bd)
		F.CreateSD(bd)
		bd:ClearAllPoints()
		bd:SetPoint("TOPLEFT", bar, "TOPLEFT", -C.Mult, C.Mult)
		bd:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", C.Mult, -C.Mult)
		bd:Show()

		local tex = bar:GetIcon()
		if tex then
			local icon = bar.candyBarIconFrame
			bar:SetIcon(nil)
			icon:SetTexture(tex)
			icon:Show()
			if bar.iconPosition == "RIGHT" then
				icon:SetPoint("BOTTOMLEFT", bar, "BOTTOMRIGHT", 5, 0)
			else
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -5, 0)
			end
			icon:SetSize(height, height)
			bar:Set("bigwigs:restoreicon", tex)

			local iconBd = bar.candyBarIconFrameBackdrop
			F.CreateBD(iconBd)
			F.CreateSD(iconBd)
			iconBd:ClearAllPoints()
			iconBd:SetPoint("TOPLEFT", icon, "TOPLEFT", -C.Mult, C.Mult)
			iconBd:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", C.Mult, -C.Mult)
			iconBd:Show()
		end

		local label = bar.candyBarLabel
		local timer = bar.candyBarDuration

		if (C.Client == 'zhCN' or C.Client == 'zhTW') then
			if C.general.isDeveloper then
				label:SetFont(C.font.pixelCN, 10, 'OUTLINEMONOCHROME')
				label.SetFont = F.Dummy
				label:SetShadowColor(0, 0, 0, 1)
				label:SetShadowOffset(1, -1)
			else
				label:SetFont(C.font.normal, 11)
				label.SetFont = F.Dummy
				label:SetShadowColor(0, 0, 0, 1)
				label:SetShadowOffset(2, -2)
			end
		else
			F.SetFS(label)
			label.SetFont = F.Dummy
		end

		label:ClearAllPoints()
		label:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 8)
		label:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 8)

		F.SetFS(timer)
		timer.SetFont = F.Dummy
		timer:ClearAllPoints()
		timer:SetPoint("RIGHT", bar.candyBarBar, "RIGHT", -2, 8)
		timer:SetPoint("LEFT", bar.candyBarBar, "LEFT", 2, 8)
	end

	local function registerStyle()
		local bars = BigWigs:GetPlugin("Bars", true)
		bars:RegisterBarStyle("FreeUI", {
			apiVersion = 1,
			version = 2,
			GetSpacing = function(bar) return bar:GetHeight()+5 end,
			ApplyStyle = styleBar,
			BarStopped = removeStyle,
			GetStyleName = function() return "FreeUI" end,
		})
	end

	if IsAddOnLoaded("BigWigs_Plugins") then
		registerStyle()
	else
		local function loadStyle(event, addon)
			if addon == "BigWigs_Plugins" then
				registerStyle()
				F:UnregisterEvent(event, loadStyle)
			end
		end
		F:RegisterEvent("ADDON_LOADED", loadStyle)
	end
end