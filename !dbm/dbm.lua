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

local load = CreateFrame("Frame")
load:RegisterEvent("ADDON_LOADED")
load:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "DBM-GUI" then return end
	self:UnregisterEvent("ADDON_LOADED")

	DBM_GUI_OptionsFrameHeader:SetTexture(nil)
	DBM_GUI_OptionsFramePanelContainer:SetBackdrop(nil)
	DBM_GUI_OptionsFrameBossMods:DisableDrawLayer("BACKGROUND")
	DBM_GUI_OptionsFrameDBMOptions:DisableDrawLayer("BACKGROUND")

	for i = 1, 2 do
		_G["DBM_GUI_OptionsFrameTab"..i.."Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
	end

	local count = 1

	local function styleDBM()
		local option = _G["DBM_GUI_Option_"..count]
		while option do
			local objType = option:GetObjectType()
			if objType == "CheckButton" then
				F.ReskinCheck(option)
			elseif objType == "Slider" then
				F.ReskinSlider(option)
			elseif objType == "EditBox" then
				F.ReskinInput(option)
			elseif option:GetName():find("DropDown") then
				F.ReskinDropDown(option)
			elseif objType == "Button" then
				F.Reskin(option)
			elseif objType == "Frame" then
				option:SetBackdrop(nil)
			end

			count = count + 1
			option = _G["DBM_GUI_Option_"..count]
			if not option then
				option = _G["DBM_GUI_DropDown"..count]
			end
		end
	end

	DBM:RegisterOnGuiLoadCallback(function()
		styleDBM()
		hooksecurefunc(DBM_GUI, "UpdateModList", styleDBM)
		DBM_GUI_OptionsFrameBossMods:HookScript("OnShow", styleDBM)
	end)

	hooksecurefunc(DBM_GUI_OptionsFrame, "DisplayButton", function(button, element)
		-- bit of a hack, can't get the API to work
		local pushed = element.toggle:GetPushedTexture():GetTexture()
		if pushed and pushed:find("Plus") then
			element.toggle.plusShown = true
		else
			element.toggle.plusShown = false
		end

		if not element.styled then
			F.ReskinExpandOrCollapse(element.toggle)
			element.toggle:GetPushedTexture():SetAlpha(0)

			element.styled = true
		end

		element.toggle.plus:SetShown(element.toggle.plusShown)
	end)

	F.CreateBD(DBM_GUI_OptionsFrame)
	F.CreateSD(DBM_GUI_OptionsFrame)
	F.Reskin(DBM_GUI_OptionsFrameOkay)
	F.ReskinScroll(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)

	load = nil
end)