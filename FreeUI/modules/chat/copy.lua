local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('CHAT')


local _G = getfenv(0)
local strfind, strmatch, strsub, gsub = string.find, string.match, string.sub, string.gsub
local strsplit, strlen = string.split, string.len
local format, tconcat, tostring = string.format, table.concat, tostring
local IsModifierKeyDown, IsAltKeyDown, IsControlKeyDown, IsModifiedClick = IsModifierKeyDown, IsAltKeyDown, IsControlKeyDown, IsModifiedClick
local GuildInvite, BNInviteFriend = GuildInvite, BNInviteFriend
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local ScrollFrameTemplate_OnMouseWheel = ScrollFrameTemplate_OnMouseWheel
local CanCooperateWithGameAccount = CanCooperateWithGameAccount
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local InviteToGroup = C_PartyInfo.InviteUnit

local chatHide = false
local lines, menu, frame, editBox = {}

local function canChangeMessage(arg1, id)
	if id and arg1 == '' then return id end
end

local function isMessageProtected(msg)
	return msg and (msg ~= gsub(msg, '(:?|?)|K(.-)|k', canChangeMessage))
end

local function colorReplace(msg, r, g, b)
	local hexRGB = F.RGBToHex(r, g, b)
	local hexReplace = format('|r%s', hexRGB)
	msg = gsub(msg, '|r', hexReplace)
	msg = format('%s%s|r', hexRGB, msg)

	return msg
end

function CHAT:GetChatLines()
	local index = 1
	for i = 1, self:GetNumMessages() do
		local msg, r, g, b = self:GetMessageInfo(i)
		if msg and not isMessageProtected(msg) then
			r, g, b = r or 1, g or 1, b or 1
			msg = colorReplace(msg, r, g, b)
			lines[index] = tostring(msg)
			index = index + 1
		end
	end

	return index - 1
end

function CHAT:ChatCopy_OnClick(btn)
	if btn == 'LeftButton' then
		if chatHide == false then
			ChatFrame1:Hide()
			GeneralDockManager:Hide()

			chatHide = true
		elseif chatHide == true then

			ChatFrame1:Show()
			GeneralDockManager:Show()

			chatHide = false
		end
	elseif btn == 'RightButton' then
		if not C.isCNPortal then return end
		if chatHide == true then return end

		local inchannel = false
		local channels = {GetChannelList()}
		for i = 1, #channels do
			if channels[i] == '大脚世界频道' then
				inchannel = true
				break
			end
		end
		if inchannel then
			LeaveChannelByName('大脚世界频道')
			F.Print(C.RedColor..'离开|r '..'世界频道')
		else
			JoinPermanentChannel('大脚世界频道' ,nil ,1)
			ChatFrame_AddChannel(ChatFrame1, '大脚世界频道')
			ChatFrame_RemoveMessageGroup(ChatFrame1, 'CHANNEL')
			F.Print(C.GreenColor..'加入|r '..'世界频道')
		end
	else
		if not frame:IsShown() then
			local chatframe = _G.SELECTED_DOCK_FRAME
			local _, fontSize = chatframe:GetFont()
			FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
			frame:Show()

			local lineCt = CHAT.GetChatLines(chatframe)
			local text = tconcat(lines, ' \n', 1, lineCt)
			FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
			editBox:SetText(text)
		else
			frame:Hide()
		end
	end
end

function CHAT:ChatCopy_Create()
	frame = CreateFrame('Frame', 'FreeUI_ChatCopy', UIParent)
	frame:SetPoint('CENTER')
	frame:SetSize(700, 400)
	frame:Hide()
	frame:SetFrameStrata('DIALOG')
	F.CreateMF(frame)
	F.SetBD(frame)
	frame.close = CreateFrame('Button', nil, frame, 'UIPanelCloseButton')
	frame.close:SetPoint('TOPRIGHT', frame)

	local scrollArea = CreateFrame('ScrollFrame', 'ChatCopyScrollFrame', frame, 'UIPanelScrollFrameTemplate', 'BackdropTemplate')
	scrollArea:SetPoint('TOPLEFT', 10, -30)
	scrollArea:SetPoint('BOTTOMRIGHT', -28, 10)

	editBox = CreateFrame('EditBox', nil, frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont(C.Assets.Fonts.Regular, 12)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript('OnEscapePressed', function() frame:Hide() end)
	editBox:SetScript('OnTextChanged', function(_, userInput)
		if userInput then return end
		local _, max = scrollArea.ScrollBar:GetMinMaxValues()
		for i = 1, max do
			ScrollFrameTemplate_OnMouseWheel(scrollArea, -1)
		end
	end)

	scrollArea:SetScrollChild(editBox)
	scrollArea:HookScript('OnVerticalScroll', function(self, offset)
		editBox:SetHitRectInsets(0, 0, offset, (editBox:GetHeight() - offset - self:GetHeight()))
	end)

	local copy = CreateFrame('Button', nil, UIParent)
	copy:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPLEFT', -6, 0)
	copy:SetSize(20, 20)
	F.Reskin(copy)
	copy.Icon = copy:CreateTexture(nil, 'ARTWORK')
	copy.Icon:SetPoint('TOPLEFT', 2, -2)
	copy.Icon:SetPoint('BOTTOMRIGHT', -2, 2)
	copy.Icon:SetTexture('Interface\\Buttons\\UI-GuildButton-PublicNote-Up')
	copy:RegisterForClicks('AnyUp')
	copy:SetScript('OnClick', self.ChatCopy_OnClick)

	copy:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(copy, 'ANCHOR_TOPRIGHT')
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(' ', C.LineString)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_left..L['CHAT_TOGGLE_PANEL']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_right..L['CHAT_TOGGLE_WC']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:AddDoubleLine(' ', C.Assets.mouse_middle..L['CHAT_COPY']..' ', 1,1,1, .9, .8, .6)
		GameTooltip:Show()
	end)

	copy:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)


	F.ReskinClose(frame.close)
	F.ReskinScroll(ChatCopyScrollFrameScrollBar)
end

function CHAT:ChatCopy()
	if not C.DB.chat.copy_button then return end

	self:ChatCopy_Create()
end



local foundurl = false

local function convertLink(text, value)
	return '|Hurl:'..tostring(value)..'|h'..C.InfoColor..text..'|r|h'
end

local function highlightURL(_, url)
	foundurl = true
	return ' '..convertLink('['..url..']', url)..' '
end

function CHAT:SearchForURL(text, ...)
	foundurl = false

	if strfind(text, '%pTInterface%p+') or strfind(text, '%pTINTERFACE%p+') then
		foundurl = true
	end

	if not foundurl then
		--192.168.1.1:1234
		text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)', highlightURL)
	end
	if not foundurl then
		--192.168.1.1
		text = gsub(text, '(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)', highlightURL)
	end
	if not foundurl then
		--www.teamspeak.com:3333
		text = gsub(text, '(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)', highlightURL)
	end
	if not foundurl then
		--http://www.google.com
		text = gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", highlightURL)
	end
	if not foundurl then
		--www.google.com
		text = gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", highlightURL)
	end
	if not foundurl then
		--lol@lol.com
		text = gsub(text, '(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)', highlightURL)
	end

	self.am(self, text, ...)
end

function CHAT:HyperlinkShowHook(link, _, button)
	local type, value = strmatch(link, '(%a+):(.+)')
	local hide
	if button == 'LeftButton' and IsModifierKeyDown() then
		if type == 'player' then
			local unit = strmatch(value, '([^:]+)')
			if IsAltKeyDown() then
				InviteToGroup(unit)
				hide = true
			elseif IsControlKeyDown() then
				GuildInvite(unit)
				hide = true
			end
		elseif type == 'BNplayer' then
			local _, bnID = strmatch(value, '([^:]*):([^:]*):')
			if not bnID then return end
			local accountInfo = C_BattleNet_GetAccountInfoByID(bnID)
			if not accountInfo then return end
			local gameAccountInfo = accountInfo.gameAccountInfo
			local gameID = gameAccountInfo.gameAccountID
			if gameID and CanCooperateWithGameAccount(accountInfo) then
				if IsAltKeyDown() then
					BNInviteFriend(gameID)
					hide = true
				elseif IsControlKeyDown() then
					local charName = gameAccountInfo.characterName
					local realmName = gameAccountInfo.realmName
					GuildInvite(charName..'-'..realmName)
					hide = true
				end
			end
		end
	elseif type == 'url' then
		local eb = LAST_ACTIVE_CHAT_EDIT_BOX or _G[self:GetName()..'EditBox']
		if eb then
			eb:Show()
			eb:SetText(value)
			eb:SetFocus()
			eb:HighlightText()
		end
	end

	if hide then ChatEdit_ClearChat(ChatFrame1.editBox) end
end

function CHAT.SetItemRefHook(link, _, button)
	if strsub(link, 1, 6) == 'player' and button == 'LeftButton' and IsModifiedClick('CHATLINK') then
		if not StaticPopup_Visible('ADD_IGNORE') and not StaticPopup_Visible('ADD_FRIEND') and not StaticPopup_Visible('ADD_GUILDMEMBER') and not StaticPopup_Visible('ADD_RAIDMEMBER') and not StaticPopup_Visible('CHANNEL_INVITE') and not ChatEdit_GetActiveWindow() then
			local namelink, fullname
			if strsub(link, 7, 8) == 'GM' then
				namelink = strsub(link, 10)
			elseif strsub(link, 7, 15) == 'Community' then
				namelink = strsub(link, 17)
			else
				namelink = strsub(link, 8)
			end
			if namelink then fullname = strsplit(':', namelink) end

			if fullname and strlen(fullname) > 0 then
				local name, server = strsplit('-', fullname)
				if server and server ~= C.MyRealm then name = fullname end

				if MailFrame and MailFrame:IsShown() then
					MailFrameTab_OnClick(nil, 2)
					SendMailNameEditBox:SetText(name)
					SendMailNameEditBox:HighlightText()
				else
					local editBox = ChatEdit_ChooseBoxForSend()
					local hasText = (editBox:GetText() ~= '')
					ChatEdit_ActivateChat(editBox)
					editBox:Insert(name)
					if not hasText then editBox:HighlightText() end
				end
			end
		end
	end
end


function CHAT:UrlCopy()
	for i = 1, NUM_CHAT_WINDOWS do
		if i ~= 2 then
			local chatFrame = _G['ChatFrame'..i]
			chatFrame.am = chatFrame.AddMessage
			chatFrame.AddMessage = self.SearchForURL
		end
	end

	local orig = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		if link and strsub(link, 0, 3) == 'url' then return end

		return orig(self, link, ...)
	end

	hooksecurefunc('ChatFrame_OnHyperlinkShow', self.HyperlinkShowHook)
	hooksecurefunc('SetItemRef', self.SetItemRefHook)
end




