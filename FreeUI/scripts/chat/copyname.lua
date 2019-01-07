local F, C = unpack(select(2, ...))
if not C.chat.enable then return end

local UnitPopupButtonsExtra = {
	['NAME_COPY'] = { text = COPY_NAME },
}

for k, v in pairs(UnitPopupButtonsExtra) do
	UnitPopupButtons[k] = v
end

tinsert(UnitPopupMenus['FRIEND'], 1, 'NAME_COPY')
tinsert(UnitPopupMenus['CHAT_ROSTER'], 1, 'NAME_COPY')
tinsert(UnitPopupMenus['GUILD'], 1, 'NAME_COPY')

local function popupClick(_, info)
	local editBox
	local name, server = UnitName(info.unit)
	if info.value == 'NAME_COPY' then
		if server and server ~= '' then name = name..'-'..server end

		if SendMailNameEditBox and SendMailNameEditBox:IsVisible() then
			SendMailNameEditBox:SetText(name)
			SendMailNameEditBox:HighlightText()
		else
			editBox = ChatEdit_ChooseBoxForSend()
			local hasText = (editBox:GetText() ~= '')
			ChatEdit_ActivateChat(editBox)
			editBox:Insert(name)
			if not hasText then editBox:HighlightText() end
		end
	end
end

hooksecurefunc('UnitPopup_ShowMenu', function(_, _, unit)
	if UIDROPDOWNMENU_MENU_LEVEL > 1 then return end
	if unit and (unit == 'target' or string.find(unit, 'party') or string.find(unit, 'raid')) then
		local info


		info = UIDropDownMenu_CreateInfo()
		info.text = UnitPopupButtonsExtra['NAME_COPY'].text
		info.arg1 = {value = 'NAME_COPY', unit = unit}
		info.func = popupClick
		info.notCheckable = true
		UIDropDownMenu_AddButton(info)
	end
end)

hooksecurefunc('UnitPopup_OnClick', function(self)
	local unit = UIDROPDOWNMENU_INIT_MENU.unit
	local name = UIDROPDOWNMENU_INIT_MENU.name
	local server = UIDROPDOWNMENU_INIT_MENU.server
	local fullname = name
	local editBox
	if server and (not unit or UnitRealmRelationship(unit) ~= LE_REALM_RELATION_SAME) then
		fullname = name..'-'..server
	end
	if self.value == 'NAME_COPY' then
		if SendMailNameEditBox and SendMailNameEditBox:IsVisible() then
			SendMailNameEditBox:SetText(fullname)
			SendMailNameEditBox:HighlightText()
		else
			editBox = ChatEdit_ChooseBoxForSend()
			local hasText = (editBox:GetText() ~= '')
			ChatEdit_ActivateChat(editBox)
			editBox:Insert(fullname)
			if not hasText then editBox:HighlightText() end
		end
	end
end)