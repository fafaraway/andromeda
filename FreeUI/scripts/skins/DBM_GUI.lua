local F, C = unpack(select(2, ...))

local function InitStyleDBMGUI()
	_G.DBM_GUI_OptionsFrameHeader:SetTexture(nil)
	_G.DBM_GUI_OptionsFramePanelContainer:SetBackdrop(nil)
	_G.DBM_GUI_OptionsFrameBossMods:DisableDrawLayer("BACKGROUND")
	_G.DBM_GUI_OptionsFrameDBMOptions:DisableDrawLayer("BACKGROUND")

	for i = 1, 2 do
		_G["DBM_GUI_OptionsFrameTab"..i.."Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
	end

	local optionCount = 1

	local function styleDBM()
		local option = _G["DBM_GUI_Option_"..optionCount]
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
				local name = option:GetName()
				local button, bg = option:GetChildren()
				bg:SetPoint("TOPLEFT", _G[name.."Left"], 18, -20)
				bg:SetPoint("BOTTOMRIGHT", _G[name.."Right"], -16, 24)

				button:ClearAllPoints()
				button:SetPoint("RIGHT", bg, 0, 0)
			elseif objType == "Button" then
				F.Reskin(option)
			elseif objType == "Frame" then
				option:SetBackdrop(nil)
			end

			optionCount = optionCount + 1
			option = _G["DBM_GUI_Option_"..optionCount]
			if not option then
				option = _G["DBM_GUI_DropDown"..optionCount]
			end
		end
	end

	_G.DBM:RegisterOnGuiLoadCallback(function()
		--print("DBMSkin: RegisterOnGuiLoadCallback")
		styleDBM()
		_G.hooksecurefunc(_G.DBM_GUI, "UpdateModList", styleDBM)
		_G.DBM_GUI_OptionsFrameBossMods:HookScript("OnShow", styleDBM)
	end)

	_G.hooksecurefunc(_G.DBM_GUI_OptionsFrame, "DisplayButton", function(button, element)
		-- bit of a hack, can't get the API to work
		local pushed = element.toggle:GetPushedTexture():GetTexture()

		if not element.styled then
			F.ReskinExpandOrCollapse(element.toggle)
			element.toggle:GetPushedTexture():SetAlpha(0)

			element.styled = true
		end

		--element.toggle.plus:SetShown(pushed and pushed:find("Plus"))
	end)

	local MAX_BUTTONS = 10
	_G.hooksecurefunc(_G.DBM_GUI_DropDown, "ShowMenu", function(dropdown, values)
		--print("DBMSkin: ShowMenu", dropdown, values)
		local button = dropdown.buttons[1]
		local _, _, _, x = button:GetPoint()
		for i = 1, MAX_BUTTONS do
			if i + dropdown.offset <= #values then
				if values[i+dropdown.offset].value == dropdown.dropdown.value then
					local text = dropdown.buttons[i]:GetText()
					local _, j = text:find("Check:0")
					_ = text:sub(j+3)
				end

				local highlight = _G[dropdown.buttons[i]:GetName().."Highlight"]
				highlight:SetColorTexture(C.r, C.g, C.b, .2)
				highlight:SetPoint("TOPLEFT", -x, 0)
				highlight:SetPoint("BOTTOMRIGHT", dropdown:GetWidth() - button:GetWidth() - x - 1, 0)
			end
		end

		if dropdown.text:IsShown() then
			dropdown:SetHeight(dropdown:GetHeight() + 5)
			dropdown.text:SetPoint("BOTTOM", dropdown, "BOTTOM", 0, 3)
		end
	end)

	F.CreateBD(_G.DBM_GUI_DropDown)
	F.CreateBD(_G.DBM_GUI_OptionsFrame)
	F.CreateSD(_G.DBM_GUI_OptionsFrame)
	F.Reskin(_G.DBM_GUI_OptionsFrameWebsiteButton)
	F.Reskin(_G.DBM_GUI_OptionsFrameOkay)
	F.ReskinScroll(_G.DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
end


if IsAddOnLoaded("DBM-GUI") then
	InitStyleDBMGUI()
else
	local load = CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "DBM-GUI" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyleDBMGUI()

		load = nil
	end)
end