local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()

	local function styleBubble(frame)
		if frame:IsForbidden() then return end
		for i = 1, frame:GetNumRegions() do
			local region = select(i, frame:GetRegions())
			if region:GetObjectType() == "Texture" then
				region:SetTexture(nil)
			elseif region:GetObjectType() == "FontString" then
				frame.text = region

				region:SetFont(C.media.font, 22)
				region:SetShadowColor(0, 0, 0, 1)
			end
		end

		local r, g, b = frame.text:GetTextColor()

		F.CreateBD(frame)
		F.CreateSD(frame)
		frame:SetScale(UIParent:GetScale())
	end

	local function findChatBubble(msg)
		local chatbubbles = C_ChatBubbles.GetAllChatBubbles()
		for index = 1, #chatbubbles do
			local chatbubble = chatbubbles[index]
			for i = 1, chatbubble:GetNumRegions() do
				local region = select(i, chatbubble:GetRegions())
				if region:GetObjectType() == "FontString" and region:GetText() == msg then
					return chatbubble
				end
			end
		end
	end

	local events = {
		CHAT_MSG_SAY = "chatBubbles",
		CHAT_MSG_YELL = "chatBubbles",
		CHAT_MSG_MONSTER_SAY = "chatBubbles",
		CHAT_MSG_MONSTER_YELL = "chatBubbles",
		CHAT_MSG_PARTY = "chatBubblesParty",
		CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
		CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
	}

	local channels = {
		CHAT_MSG_SAY = "SAY",
		CHAT_MSG_YELL = "YELL",
		CHAT_MSG_PARTY = "PARTY",
		CHAT_MSG_PARTY_LEADER = "PARTY_LEADER",
		CHAT_MSG_MONSTER_SAY = "MONSTER_SAY",
		CHAT_MSG_MONSTER_YELL = "MONSTER_YELL",
		CHAT_MSG_MONSTER_PARTY = "MONSTER_PARTY",
	}

	local bubbleHook = CreateFrame("Frame")
	for event in next, events do
		bubbleHook:RegisterEvent(event)
	end

	bubbleHook:SetScript("OnEvent", function(self, event, msg)
		if GetCVarBool(events[event]) then
			self.elapsed = 0
			self.msg = msg
			local channel = channels[event]
			if channel then
				local info = ChatTypeInfo[channel]
				self.color = {info.r, info.g, info.b}
			else
				self.color = nil
			end
			self:Show()
		end
	end)


	bubbleHook:SetScript("OnUpdate", function(self, elapsed)
		local _, instanceType = IsInInstance()
		if not instanceType == "none" then return end

		self.elapsed = self.elapsed + elapsed
		local chatbubble = findChatBubble(self.msg)
		if chatbubble or self.elapsed > .3 then
			self:Hide()
			if chatbubble then
				if not chatbubble.styled then
					styleBubble(chatbubble)
					chatbubble.styled = true
				end

				if self.color then
					if chatbubble.Shadow then
						chatbubble.Shadow:SetBackdropBorderColor(unpack(self.color))
					else
						chatbubble:SetBackdropBorderColor(unpack(self.color))
					end
				else
					if chatbubble.Shadow then
						chatbubble.Shadow:SetBackdropBorderColor(0, 0, 0)
					else
						chatbubble:SetBackdropBorderColor(0, 0, 0)
					end
				end
			end
		end
	end)



	bubbleHook:Hide()

end)