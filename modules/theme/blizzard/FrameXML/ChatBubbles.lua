local F, C = unpack(select(2, ...))

local pairs, GetCVarBool = pairs, GetCVarBool
local C_ChatBubbles_GetAllChatBubbles = C_ChatBubbles.GetAllChatBubbles

local function updateBorderColor(frame)
	local r, g, b = frame.String:GetTextColor()
	if frame.__shadow then
		frame.__shadow:SetBackdropBorderColor(r, g, b, .75)
	end
end

local function reskinChatBubble(chatbubble)
	if chatbubble.styled then return end

	local frame = chatbubble:GetChildren()
	if frame and not frame:IsForbidden() then
		frame.__bg = F.CreateBDFrame(frame)
		frame.__bg:SetScale(UIParent:GetEffectiveScale())
		frame.__bg:SetInside(frame, 6, 6)
		if frame.__shadow then
			frame.__shadow = F.CreateSD(frame.__bg)
			frame.__shadow:SetBackdropBorderColor(.02, .02, .02, .25)
		end
		F.CreateTex(frame.__bg)
		frame:HookScript('OnShow', updateBorderColor)
		frame:DisableDrawLayer("BORDER")
		frame.Tail:SetAlpha(0)

		updateBorderColor(frame)
	end

	chatbubble.styled = true
end

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	local events = {
		CHAT_MSG_SAY = "chatBubbles",
		CHAT_MSG_YELL = "chatBubbles",
		CHAT_MSG_MONSTER_SAY = "chatBubbles",
		CHAT_MSG_MONSTER_YELL = "chatBubbles",
		CHAT_MSG_PARTY = "chatBubblesParty",
		CHAT_MSG_PARTY_LEADER = "chatBubblesParty",
		CHAT_MSG_MONSTER_PARTY = "chatBubblesParty",
	}

	local bubbleHook = CreateFrame("Frame")
	for event in next, events do
		bubbleHook:RegisterEvent(event)
	end
	bubbleHook:SetScript("OnEvent", function(self, event)
		if GetCVarBool(events[event]) then
			self.elapsed = 0
			self:Show()
		end
	end)

	bubbleHook:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > .1 then
			for _, chatbubble in pairs(C_ChatBubbles_GetAllChatBubbles()) do
				reskinChatBubble(chatbubble)
			end

			self:Hide()
		end
	end)
	bubbleHook:Hide()
end)
