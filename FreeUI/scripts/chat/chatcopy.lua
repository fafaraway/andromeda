local F, C, L = unpack(select(2, ...))
local CHAT = F:GetModule('Chat')


local gsub, format, tconcat, tostring = string.gsub, string.format, table.concat, tostring

function CHAT:ChatCopy()
	if not C.chat.chatCopy then return end
	
	local lines = {}
	local f = CreateFrame('Frame', 'FreeUIChatCopy', UIParent)
	f:SetFrameStrata('DIALOG')
	f:SetPoint('CENTER')
	f:SetSize(700, 400)
	f:Hide()
	
	F.CreateMF(f)
	F.CreateBD(f)
	F.CreateSD(f)

	f.close = CreateFrame('Button', nil, f, 'UIPanelCloseButton')
	f.close:SetPoint('TOPRIGHT', f)
	F.ReskinClose(f.close)

	local scrollArea = CreateFrame('ScrollFrame', 'ChatCopyScrollFrame', f, 'UIPanelScrollFrameTemplate')
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 10)
	F.ReskinScroll(ChatCopyScrollFrameScrollBar)

	local editBox = CreateFrame('EditBox', nil, f)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont(C.font.normal, 14)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript('OnEscapePressed', function() f:Hide() end)
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

	local function canChangeMessage(arg1, id)
		if id and arg1 == '' then return id end
	end

	local function isMessageProtected(msg)
		return msg and (msg ~= gsub(msg, '(:?|?)|K(.-)|k', canChangeMessage))
	end

	local function colorReplace(msg, r, g, b)
		local hexRGB = F.HexRGB(r, g, b)
		local hexReplace = format('|r%s', hexRGB)
		msg = gsub(msg, '|r', hexReplace)
		msg = format('%s%s|r', hexRGB, msg)

		return msg
	end

	local function getChatLines(f)
		local index = 1
		for i = 1, f:GetNumMessages() do
			local msg, r, g, b = f:GetMessageInfo(i)
			if msg and not isMessageProtected(msg) then
				r, g, b = r or 1, g or 1, b or 1
				msg = colorReplace(msg, r, g, b)
				lines[index] = tostring(msg)
				index = index + 1
			end
		end

		return index - 1
	end

	
	


	local bu = CreateFrame('Button', nil, UIParent)
	bu:SetSize(16, 16)
	bu:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 10, 10)
	bu.text = F.CreateFS(bu, 'pixel', '-', nil, 'yellow', true, 'CENTER', 2, 1)
	F.Reskin(bu)
	bu:Show()

	local ChatHide = false
	bu:SetScript('OnMouseDown', function(self, button)
		if ChatHide == false then
			if button == 'LeftButton' then
				bu.text:SetText('-')
			end
		elseif ChatHide == true then
			if button == 'LeftButton' then
				bu.text:SetText('+')
			end
		end

		if C.Client == 'zhCN' and button == 'RightButton' and ChatHide == false then
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
				print('|cffFF0000离开|r 大脚世界频道')  
			else
				JoinPermanentChannel('大脚世界频道' ,nil ,1)
				ChatFrame_AddChannel(ChatFrame1, '大脚世界频道')
				ChatFrame_RemoveMessageGroup(ChatFrame1, 'CHANNEL')
				print('|cff7FFF00加入|r 大脚世界频道')
			end
		end

		if button == 'MiddleButton' then
			if not f:IsShown() then
				local chatframe = SELECTED_DOCK_FRAME
				local _, fontSize = chatframe:GetFont()
				FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
				f:Show()

				local lineCt = getChatLines(chatframe)
				local text = tconcat(lines, ' \n', 1, lineCt)
				FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
				editBox:SetText(text)
			else
				f:Hide()
			end
		end
	end)

	bu:SetScript('OnMouseUp', function(self, button)
		if ChatHide  == false then
			if button == 'LeftButton' then
				bu.text:SetText('-')
			end
		elseif ChatHide == true then
			if button == 'LeftButton' then
				bu.text:SetText('+')
			end
		end
	end)

	bu:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(bu, 'ANCHOR_NONE')
		GameTooltip:SetPoint('BOTTOMLEFT', bu, 'TOPRIGHT', 2, 2)
		
		if ChatHide  == false then
			GameTooltip:AddDoubleLine(' ', C.LeftButton..L['CHAT_HIDE']..' ', 1,1,1, .9, .8, .6)

			local inchannel = false
			local channels = {GetChannelList()}
			for i = 1, #channels do
				if channels[i] == '大脚世界频道' then
					inchannel = true
					break
				end
			end
			if inchannel then
				GameTooltip:AddDoubleLine(' ', C.RightButton..L['CHAT_LEAVE_WC']..' ', 1,1,1, .9, .8, .6)
			else
				GameTooltip:AddDoubleLine(' ', C.RightButton..L['CHAT_JOIN_WC']..' ', 1,1,1, .9, .8, .6)
			end

			GameTooltip:AddDoubleLine(' ', C.MiddleButton..L['CHAT_COPY']..' ', 1,1,1, .9, .8, .6)
		elseif ChatHide == true then
			GameTooltip:AddDoubleLine(' ', C.LeftButton..L['CHAT_SHOW']..' ', 1,1,1, .9, .8, .6)
		end

		GameTooltip:Show()
	end)

	bu:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)

	bu:SetScript('OnClick', function(self, button)
		if ChatHide == false then
			bu.text:SetText('+')
			ChatFrame1.FontStringContainer:Hide()

			for i=1, NUM_CHAT_WINDOWS do
				_G['ChatFrame'..i..'']:SetAlpha(0)
				_G['ChatFrame'..i..'ButtonFrame']:Hide()
				_G['ChatFrame'..i..'EditBox']:Hide()
				_G['ChatFrame'..i..'']:Hide()
			end

			ChatHide = true
		elseif ChatHide == true then
			bu.text:SetText('-')
			ChatFrame1:Show()
			ChatFrame1.FontStringContainer:Show()

			for i=1, NUM_CHAT_WINDOWS do
				_G['ChatFrame'..i..'']:SetAlpha(1)
				_G['ChatFrame'..i..'ButtonFrame']:Show()
			end

			ChatHide = false
		end
	end)
end




