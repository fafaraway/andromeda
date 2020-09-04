local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local LibBase64 = F.Libs.Base64

local dataFrame

function GUI:ExportData()
	local text = 'FreeUISettings:'..C.Version..':'..C.MyName..':'..C.MyClass
	for KEY, VALUE in pairs(FreeDB) do
		if type(VALUE) == 'table' then
			for key, value in pairs(VALUE) do
				if type(value) == 'table' then
					if value.r then
						for k, v in pairs(value) do
							text = text..';'..KEY..':'..key..':'..k..':'..v
						end
					elseif KEY == 'ui_anchor' or KEY == 'click_cast' then
						text = text..';'..KEY..':'..key
						for _, v in ipairs(value) do
							text = text..':'..tostring(v)
						end
					elseif key == 'favourite_items' then
						text = text..';'..KEY..':'..key
						for itemID in pairs(value) do
							text = text..':'..tostring(itemID)
						end
					end
				else
					if FreeDB[KEY][key] ~= C.CharacterSettings[KEY][key] then
						text = text..';'..KEY..':'..key..':'..tostring(value)
					end
				end
			end
		end
	end

	for KEY, VALUE in pairs(FreeADB) do
		if KEY == 'custom_junk_list' then
			text = text..';ACCOUNT:'..KEY
			for spellID in pairs(VALUE) do
				text = text..':'..spellID
			end
		end
	end

	dataFrame.editBox:SetText(LibBase64:Encode(text))
	dataFrame.editBox:HighlightText()
end

local function toBoolean(value)
	if value == 'true' then
		return true
	elseif value == 'false' then
		return false
	end
end

function GUI:ImportData()
	local profile = dataFrame.editBox:GetText()
	if LibBase64:IsBase64(profile) then profile = LibBase64:Decode(profile) end
	local options = {strsplit(';', profile)}
	local title, _, _, _ = strsplit(':', options[1])

	if title ~= 'FreeUISettings' then
		UIErrorsFrame:AddMessage(C.RedColor..L['GUI_IMPORT_DATA_ERROR'])
		return
	end

	for i = 2, #options do
		local option = options[i]
		local key, value, arg1 = strsplit(':', option)
		if arg1 == 'true' or arg1 == 'false' then
			FreeDB[key][value] = toBoolean(arg1)
		elseif arg1 == 'EMPTYTABLE' then
			FreeDB[key][value] = {}
		elseif strfind(value, 'Color') and (arg1 == 'r' or arg1 == 'g' or arg1 == 'b') then
			local color = select(4, strsplit(':', option))
			if FreeDB[key][value] then
				FreeDB[key][value][arg1] = tonumber(color)
			end
		elseif value == 'favourite_items' then
			local items = {select(3, strsplit(':', option))}
			for _, itemID in next, items do
				FreeDB[key][value][tonumber(itemID)] = true
			end
		elseif key == 'ui_anchor' then
			local relFrom, parent, relTo, x, y = select(3, strsplit(':', option))
			value = tonumber(value) or value
			x = tonumber(x)
			y = tonumber(y)
			FreeDB[key][value] = {relFrom, parent, relTo, x, y}

		elseif key == 'ACCOUNT' then
			if value == 'custom_junk_list' then
				local spells = {select(3, strsplit(':', option))}
				for _, spellID in next, spells do
					FreeADB[value][tonumber(spellID)] = true
				end
			end
		end
	end

	ReloadUI()
end

local function UpdateTooltip()
	local profile = dataFrame.editBox:GetText()
	if LibBase64:IsBase64(profile) then profile = LibBase64:Decode(profile) end
	local option = strsplit(';', profile)
	local title, version, name, class = strsplit(':', option)
	if title == 'FreeUISettings' then
		dataFrame.version = version
		dataFrame.name = name
		dataFrame.class = class
	else
		dataFrame.version = nil
	end
end

function GUI:CreateDataFrame()
	if dataFrame then dataFrame:Show() return end

	dataFrame = CreateFrame('Frame', 'FreeUI_Data', UIParent)
	dataFrame:SetPoint('CENTER')
	dataFrame:SetSize(500, 500)
	dataFrame:SetFrameStrata('DIALOG')
	F.CreateMF(dataFrame)
	F.SetBD(dataFrame)
	dataFrame.Header = F.CreateFS(dataFrame, C.Assets.Fonts.Normal, 14, nil, L['GUI_DATA_EXPORT_HEADER'], 'YELLOW', true, 'TOP', 0, -5)

	local scrollArea = CreateFrame('ScrollFrame', nil, dataFrame, 'UIPanelScrollFrameTemplate')
	scrollArea:SetPoint('TOPLEFT', 10, -30)
	scrollArea:SetPoint('BOTTOMRIGHT', -28, 40)
	F.CreateBDFrame(scrollArea, .3)
	F.ReskinScroll(scrollArea.ScrollBar)

	local editBox = CreateFrame('EditBox', nil, dataFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:SetTextInsets(5, 5, 5, 5)
	editBox:SetFont(C.Assets.Fonts.Normal, 12)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript('OnEscapePressed', function() dataFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	dataFrame.editBox = editBox

	local accept = F.CreateButton(dataFrame, 100, 20, OKAY)
	accept:SetPoint('BOTTOM', 0, 10)
	accept:SetScript('OnClick', function(self)
		if self.text:GetText() ~= OKAY and dataFrame.editBox:GetText() ~= '' then
			StaticPopup_Show('FREEUI_IMPORT_DATA')
		end
		dataFrame:Hide()
	end)

	accept:HookScript('OnEnter', function(self)
		if dataFrame.editBox:GetText() == '' then return end
		UpdateTooltip()

		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 10)
		GameTooltip:ClearLines()

		if dataFrame.version then
			GameTooltip:AddLine(L['GUI_DATA_INFO'])
			GameTooltip:AddDoubleLine(L['GUI_DATA_VERSION'], dataFrame.version, .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(L['GUI_DATA_CHARACTER'], dataFrame.name, .6,.8,1, F.ClassColor(dataFrame.class))
		else
			GameTooltip:AddLine(L['GUI_DATA_EXCEPTION'], 1,0,0)
		end

		GameTooltip:Show()
	end)

	accept:HookScript('OnLeave', F.HideTooltip)
	dataFrame.text = accept.text
end
