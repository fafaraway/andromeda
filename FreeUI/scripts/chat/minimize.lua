local F, C = unpack(select(2, ...))

if not C.chat.minimize then return end

local mb = CreateFrame("Button",nil,UIParent)
mb:SetSize(16,16)
--mb.t=mb:CreateTexture(nil,"BORDER")
--mb.t:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-Minimize-Up.blp")
--mb.t:SetAllPoints(mb)
mb.t = F.CreateFS(mb, C.media.pixel, 8, 'OUTLINEMONOCHROME')
mb.t:SetText("-")
mb.t:SetTextColor(228/255, 225/255, 16/255)

mb:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 10, 10)
F.Reskin(mb)
mb:Show()

local ChatHide = false
mb:SetScript("onmousedown", function(self, button)
	if ChatHide  == false then
		if button == "LeftButton" then
			mb.t:SetText("-")
mb.t:SetTextColor(228/255, 225/255, 16/255)
		end
	elseif ChatHide == true then
		if button == "LeftButton" then
			mb.t:SetText("+")
mb.t:SetTextColor(228/255, 225/255, 16/255)
		end
	end
end)

mb:SetScript("onmouseup", function(self, button)
	if ChatHide  == false then
		if button == "LeftButton" then
			mb.t:SetText("-")
mb.t:SetTextColor(228/255, 225/255, 16/255)
		end
	elseif ChatHide == true then
		if button == "LeftButton" then
			mb.t:SetText("+")
mb.t:SetTextColor(228/255, 225/255, 16/255)
		end
	end
end)

mb:SetScript("OnMouseDown", function(self, button)
	if C.client == 'zhCN' and button == 'RightButton' then
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

mb:SetScript("onclick", function(self, button)
	if ChatHide == false then

		mb.t:SetText("+")
		mb.t:SetTextColor(228/255, 225/255, 16/255)
		--QuickJoinToastButton:Hide()
		--GeneralDockManager:Hide()
		--ChatFrameMenuButton:Hide()
		ChatFrame1.FontStringContainer:Hide()
		--ChatFrameChannelButton:Hide()
		--ChatFrameToggleVoiceMuteButton:Hide()
		--ChatFrameToggleVoiceDeafenButton:Hide()

		for i=1, NUM_CHAT_WINDOWS do
			_G["ChatFrame"..i..""]:SetAlpha(0)
			_G["ChatFrame"..i.."ButtonFrame"]:Hide()
			_G["ChatFrame"..i.."EditBox"]:Hide()
			_G["ChatFrame"..i..""]:Hide()
		end

		ChatHide = true

	elseif ChatHide == true then

		mb.t:SetText("-")
		mb.t:SetTextColor(228/255, 225/255, 16/255)
		--QuickJoinToastButton:Show()
		--GeneralDockManager:Show()
		--ChatFrameMenuButton:Show()
		ChatFrame1:Show()
		ChatFrame1.FontStringContainer:Show()
		--ChatFrameChannelButton:Show()
		--ChatFrameToggleVoiceMuteButton:Show()
		--ChatFrameToggleVoiceDeafenButton:Show()

		for i=1, NUM_CHAT_WINDOWS do
			_G["ChatFrame"..i..""]:SetAlpha(1)
			_G["ChatFrame"..i.."ButtonFrame"]:Show()
		end

		ChatHide = false
	end
end)
