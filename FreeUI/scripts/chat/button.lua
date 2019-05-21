local F, C, L = unpack(select(2, ...))
if not C.chat.enable then return end
local module = F:GetModule('Chat')



function module:ChatButton()
	if not C.chat.chatButton then return end
	
	local gsub, format, tconcat, tostring = string.gsub, string.format, table.concat, tostring

	local lines = {}
	local frame = CreateFrame('Frame', 'FreeUIChatCopy', UIParent)
	frame:SetPoint('CENTER')
	frame:SetSize(700, 400)
	frame:Hide()
	frame:SetFrameStrata('DIALOG')
	F.CreateMF(frame)
	F.CreateBD(frame, .7)
	F.CreateSD(frame)
	F.CreateTex(frame)
	frame.close = CreateFrame('Button', nil, frame, 'UIPanelCloseButton')
	frame.close:SetPoint('TOPRIGHT', frame)

	local scrollArea = CreateFrame('ScrollFrame', 'ChatCopyScrollFrame', frame, 'UIPanelScrollFrameTemplate')
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 10)

	local editBox = CreateFrame('EditBox', nil, frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont(C.font.normal, 14)
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

	local function getChatLines(frame)
		local index = 1
		for i = 1, frame:GetNumMessages() do
			local msg, r, g, b = frame:GetMessageInfo(i)
			if msg and not isMessageProtected(msg) then
				r, g, b = r or 1, g or 1, b or 1
				msg = colorReplace(msg, r, g, b)
				lines[index] = tostring(msg)
				index = index + 1
			end
		end

		return index - 1
	end

	F.ReskinClose(frame.close)
	F.ReskinScroll(ChatCopyScrollFrameScrollBar)


	local mb = CreateFrame('Button',nil,UIParent)
	mb:SetSize(16,16)
	mb:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 10, 10)
	mb.t = F.CreateFS(mb, 'pixel', '-', nil, 'yellow', true, 'CENTER', 2, 1)
	F.Reskin(mb)
	mb:Show()

	local ChatHide = false
	mb:SetScript('OnMouseDown', function(self, button)
		if ChatHide == false then
			if button == 'LeftButton' then
				mb.t:SetText('-')
			end
		elseif ChatHide == true then
			if button == 'LeftButton' then
				mb.t:SetText('+')
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
			if not frame:IsShown() then
				local chatframe = SELECTED_DOCK_FRAME
				local _, fontSize = chatframe:GetFont()
				FCF_SetChatWindowFontSize(chatframe, chatframe, .01)
				frame:Show()

				local lineCt = getChatLines(chatframe)
				local text = tconcat(lines, ' \n', 1, lineCt)
				FCF_SetChatWindowFontSize(chatframe, chatframe, fontSize)
				editBox:SetText(text)
			else
				frame:Hide()
			end
		end
	end)

	mb:SetScript('OnMouseUp', function(self, button)
		if ChatHide  == false then
			if button == 'LeftButton' then
				mb.t:SetText('-')
			end
		elseif ChatHide == true then
			if button == 'LeftButton' then
				mb.t:SetText('+')
			end
		end
	end)

	mb:HookScript('OnEnter', function(self)
		GameTooltip:SetOwner(mb, 'ANCHOR_NONE')
		GameTooltip:SetPoint('BOTTOMLEFT', mb, 'TOPRIGHT', 2, 2)
		
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

	mb:HookScript('OnLeave', function(self)
		GameTooltip:Hide()
	end)

	mb:SetScript('OnClick', function(self, button)
		if ChatHide == false then
			mb.t:SetText('+')
			ChatFrame1.FontStringContainer:Hide()

			for i=1, NUM_CHAT_WINDOWS do
				_G['ChatFrame'..i..'']:SetAlpha(0)
				_G['ChatFrame'..i..'ButtonFrame']:Hide()
				_G['ChatFrame'..i..'EditBox']:Hide()
				_G['ChatFrame'..i..'']:Hide()
			end

			ChatHide = true
		elseif ChatHide == true then
			mb.t:SetText('-')
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




