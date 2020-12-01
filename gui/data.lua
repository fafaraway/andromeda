local F, C, L = unpack(select(2, ...))
local GUI = F:GetModule('GUI')
local LibBase64 = F.Libs.Base64

local dataFrame

function GUI:ExportData()
	local text = 'FreeUISettings:'..C.AddonVersion..':'..C.MyName..':'..C.MyClass
	for KEY, VALUE in pairs(C.DB) do
		if type(VALUE) == 'table' then
			for key, value in pairs(VALUE) do
				if type(value) == 'table' then
					if value.r then
						for k, v in pairs(value) do
							text = text..';'..KEY..':'..key..':'..k..':'..v
						end

					elseif KEY == 'ui_anchor' then
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
					if C.DB[KEY][key] ~= C.CharacterSettings[KEY][key] then -- don't export default settings
						text = text..';'..KEY..':'..key..':'..tostring(value)
					end
				end
			end
		end
	end

	for KEY, VALUE in pairs(FREE_ADB) do
		if KEY == 'custom_junk_list' then
			text = text..';ACCOUNT:'..KEY
			for spellID in pairs(VALUE) do
				text = text..':'..spellID
			end
		elseif KEY == 'raid_debuffs' then
			for instName, value in pairs(VALUE) do
				for spellID, prio in pairs(value) do
					text = text..';ACCOUNT:'..KEY..':'..instName..':'..spellID..':'..prio
				end
			end
		elseif KEY == 'nameplate_aura_filter_list' then
			for index, value in pairs(VALUE) do
				text = text..';ACCOUNT:'..KEY..':'..index
				for spellID in pairs(value) do
					text = text..':'..spellID
				end
			end
		elseif KEY == 'corner_buffs' then
			for class, value in pairs(VALUE) do
				for spellID, data in pairs(value) do
					if not bloodlustFilter[spellID] and class == C.MyClass then
						local anchor, color, filter = unpack(data)
						text = text..';ACCOUNT:'..KEY..':'..class..':'..spellID..':'..anchor..':'..color[1]..':'..color[2]..':'..color[3]..':'..tostring(filter or false)
					end
				end
			end
		elseif KEY == 'party_spells' then
			text = text..';ACCOUNT:'..KEY
			for spellID, duration in pairs(VALUE) do
				local name = GetSpellInfo(spellID)
				if name then
					text = text..':'..spellID..':'..duration
				end
			end
		elseif KEY == 'profile_index' or KEY == 'profile_names' then
			for k, v in pairs(VALUE) do
				text = text..';ACCOUNT:'..KEY..':'..k..':'..v
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

local function ReloadDefaultSettings()
	for i, j in pairs(C.CharacterSettings) do
		if type(j) == 'table' then
			if not C.DB[i] then C.DB[i] = {} end
			for k, v in pairs(j) do
				C.DB[i][k] = v
			end
		else
			C.DB[i] = j
		end
	end
	C.DB['BFA'] = true -- don't empty data on next loading
end

function GUI:ImportData()
	local profile = dataFrame.editBox:GetText()
	if LibBase64:IsBase64(profile) then profile = LibBase64:Decode(profile) end
	local options = {strsplit(';', profile)}
	local title, _, _, class = strsplit(':', options[1])
	if title ~= 'FreeUISettings' then
		UIErrorsFrame:AddMessage(C.RedColor..L.GUI.PROFILE.IMPORT_ERROR)
		return
	end

	-- we don't export default settings, so need to reload it
	ReloadDefaultSettings()

	for i = 2, #options do
		local option = options[i]
		local key, value, arg1 = strsplit(':', option)
		if arg1 == 'true' or arg1 == 'false' then
			C.DB[key][value] = toBoolean(arg1)
		elseif arg1 == 'EMPTYTABLE' then
			C.DB[key][value] = {}
		elseif strfind(value, 'Color') and (arg1 == 'r' or arg1 == 'g' or arg1 == 'b') then
			local color = select(4, strsplit(':', option))
			if C.DB[key][value] then
				C.DB[key][value][arg1] = tonumber(color)
			end
		elseif value == 'favourite_items' then
			local items = {select(3, strsplit(':', option))}
			for _, itemID in next, items do
				C.DB[key][value][tonumber(itemID)] = true
			end
		elseif key == 'ui_anchor' then
			local relFrom, parent, relTo, x, y = select(3, strsplit(':', option))
			value = tonumber(value) or value
			x = tonumber(x)
			y = tonumber(y)
			C.DB[key][value] = {relFrom, parent, relTo, x, y}
		elseif key == 'ACCOUNT' then
			if value == 'raid_aura_watch' or value == 'custom_junk_list' then
				local spells = {select(3, strsplit(':', option))}
				for _, spellID in next, spells do
					FREE_ADB[value][tonumber(spellID)] = true
				end
			elseif value == 'raid_debuffs' then
				local instName, spellID, priority = select(3, strsplit(':', option))
				if not FREE_ADB[value][instName] then FREE_ADB[value][instName] = {} end
				FREE_ADB[value][instName][tonumber(spellID)] = tonumber(priority)
			elseif value == 'nameplate_aura_filter_list' then
				local spells = {select(4, strsplit(':', option))}
				for _, spellID in next, spells do
					FREE_ADB[value][tonumber(arg1)][tonumber(spellID)] = true
				end
			elseif value == 'corner_buffs' then
				local class, spellID, anchor, r, g, b, filter = select(3, strsplit(':', option))
				spellID = tonumber(spellID)
				r = tonumber(r)
				g = tonumber(g)
				b = tonumber(b)
				filter = toBoolean(filter)
				if not FREE_ADB[value][class] then FREE_ADB[value][class] = {} end
				FREE_ADB[value][class][spellID] = {anchor, {r, g, b}, filter}
			elseif value == 'party_spells' then
				local options = {strsplit(':', option)}
				local index = 3
				local spellID = options[index]
				while spellID do
					local duration = options[index+1]
					FREE_ADB[value][tonumber(spellID)] = tonumber(duration) or 0
					index = index + 2
					spellID = options[index]
				end
			elseif value == 'profile_index' then
				local name, index = select(3, strsplit(':', option))
				FREE_ADB[value][name] = tonumber(index)
			elseif value == 'profile_names' then
				local index, name = select(3, strsplit(':', option))
				FREE_ADB[value][tonumber(index)] = name
			end
		elseif tonumber(arg1) then
			if value == 'countdown' then
				C.DB[key][value] = arg1
			else
				C.DB[key][value] = tonumber(arg1)
			end
		end
	end
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

StaticPopupDialogs['FREEUI_IMPORT'] = {
	text = L.GUI.PROFILE.IMPORT_WARNING,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		GUI:ImportData()
		ReloadUI()
	end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = false,
}

function GUI:CreateDataFrame()
	if dataFrame then dataFrame:Show() return end

	dataFrame = CreateFrame('Frame', 'FreeUI_Data', UIParent)
	dataFrame:SetPoint('CENTER')
	dataFrame:SetSize(500, 500)
	dataFrame:SetFrameStrata('DIALOG')
	F.CreateMF(dataFrame)
	F.SetBD(dataFrame)
	dataFrame.Header = F.CreateFS(dataFrame, C.Assets.Fonts.Regular, 14, nil, L.GUI.PROFILE.EXPORT_HEADER, 'YELLOW', true, 'TOP', 0, -5)

	local scrollArea = CreateFrame('ScrollFrame', nil, dataFrame, 'UIPanelScrollFrameTemplate')
	scrollArea:SetPoint('TOPLEFT', 10, -30)
	scrollArea:SetPoint('BOTTOMRIGHT', -28, 40)
	F.CreateBDFrame(scrollArea, .25)
	F.ReskinScroll(scrollArea.ScrollBar)

	local editBox = CreateFrame('EditBox', nil, dataFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:SetTextInsets(5, 5, 5, 5)
	editBox:SetFont(C.Assets.Fonts.Regular, 12)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript('OnEscapePressed', function() dataFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	dataFrame.editBox = editBox

	local accept = F.CreateButton(dataFrame, 100, 20, OKAY)
	accept:SetPoint('BOTTOM', 0, 10)
	accept:SetScript('OnClick', function(self)
		if self.text:GetText() ~= OKAY and dataFrame.editBox:GetText() ~= '' then
			StaticPopup_Show('FREEUI_IMPORT')
		end
		dataFrame:Hide()
	end)

	accept:HookScript('OnEnter', function(self)
		if dataFrame.editBox:GetText() == '' then return end
		UpdateTooltip()

		GameTooltip:SetOwner(self, 'ANCHOR_TOP', 0, 10)
		GameTooltip:ClearLines()

		if dataFrame.version then
			GameTooltip:AddLine(L.GUI.PROFILE.INFO)
			GameTooltip:AddDoubleLine(L.GUI.PROFILE.VERSION, dataFrame.version, .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(L.GUI.PROFILE.CHARACTER, dataFrame.name, .6,.8,1, F.ClassColor(dataFrame.class))
		else
			GameTooltip:AddLine(L.GUI.PROFILE.EXCEPTION, 1,0,0)
		end

		GameTooltip:Show()
	end)

	accept:HookScript('OnLeave', F.HideTooltip)
	dataFrame.text = accept.text

	GUI.ProfileDataFrame = dataFrame
end
