local F, C, L = unpack(select(2, ...))

if not C.chat.minimizeButton then return end

local mb = CreateFrame('Button',nil,UIParent)
mb:SetSize(16,16)

mb.t = F.CreateFS(mb, 'pixel', nil, '-', nil, 'yellow', true, 'CENTER', 2, 1)

mb:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', 10, 10)
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


mb:HookScript("OnEnter", function(self)
	GameTooltip:SetOwner(mb, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", mb, "TOPRIGHT", 2, 2)
	
	if ChatHide  == false then
		GameTooltip:AddDoubleLine(" ", C.LeftButton..L["CHAT_HIDE"].." ", 1,1,1, .9, .82, .62)

		local inchannel = false
		local channels = {GetChannelList()}
		for i = 1, #channels do
			if channels[i] == '大脚世界频道' then
				inchannel = true
				break
			end
		end
		if inchannel then
			GameTooltip:AddDoubleLine(" ", C.RightButton..L["CHAT_LEAVE_WC"].." ", 1,1,1, .9, .82, .62)
		else
			GameTooltip:AddDoubleLine(" ", C.RightButton..L["CHAT_JOIN_WC"].." ", 1,1,1, .9, .82, .62)
		end
	elseif ChatHide == true then
		GameTooltip:AddDoubleLine(" ", C.LeftButton..L["CHAT_SHOW"].." ", 1,1,1, .9, .82, .62)
	end

	GameTooltip:Show()
end)

mb:HookScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

mb:SetScript('OnClick', function(self, button)
	if ChatHide == false then

		mb.t:SetText('+')
		--QuickJoinToastButton:Hide()
		--GeneralDockManager:Hide()
		--ChatFrameMenuButton:Hide()
		ChatFrame1.FontStringContainer:Hide()
		--ChatFrameChannelButton:Hide()
		--ChatFrameToggleVoiceMuteButton:Hide()
		--ChatFrameToggleVoiceDeafenButton:Hide()

		for i=1, NUM_CHAT_WINDOWS do
			_G['ChatFrame'..i..'']:SetAlpha(0)
			_G['ChatFrame'..i..'ButtonFrame']:Hide()
			_G['ChatFrame'..i..'EditBox']:Hide()
			_G['ChatFrame'..i..'']:Hide()
		end

		ChatHide = true

	elseif ChatHide == true then

		mb.t:SetText('-')
		--QuickJoinToastButton:Show()
		--GeneralDockManager:Show()
		--ChatFrameMenuButton:Show()
		ChatFrame1:Show()
		ChatFrame1.FontStringContainer:Show()
		--ChatFrameChannelButton:Show()
		--ChatFrameToggleVoiceMuteButton:Show()
		--ChatFrameToggleVoiceDeafenButton:Show()

		for i=1, NUM_CHAT_WINDOWS do
			_G['ChatFrame'..i..'']:SetAlpha(1)
			_G['ChatFrame'..i..'ButtonFrame']:Show()
		end

		ChatHide = false
	end
end)
