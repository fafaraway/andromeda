local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule("chat")

local msgHooks = {}
local maxLines = 1024
local maxWidth, maxHeight = UIParent:GetWidth(), UIParent:GetHeight()

local function skinChat(self)
	if not self or (self and self.styled) then return end

	local name = self:GetName()
	local fontSize = select(2, self:GetFont())
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(maxWidth, maxHeight)
	self:SetMinResize(100, 50)
	
	if C.chat.outline then
		self:SetFont(C.font.chat, fontSize, "OUTLINE")
		self:SetShadowColor(0, 0, 0, 0)
	else
		self:SetFont(C.font.chat, fontSize, nil)
		self:SetShadowColor(0, 0, 0, 1)
		self:SetShadowOffset(2, -2)
	end
	
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetClampedToScreen(false)
	if self:GetMaxLines() < maxLines then
		self:SetMaxLines(maxLines)
	end

	local eb = _G[name.."EditBox"]
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 2, 24)
	eb:SetPoint("TOPRIGHT", self, "TOPRIGHT", -13, 48)

	local bd = CreateFrame("Frame", nil, eb)
	bd:SetPoint("TOPLEFT", -1, 1)
	bd:SetPoint("BOTTOMRIGHT", 1, -1)
	bd:SetFrameLevel(eb:GetFrameLevel() - 1)
	F.CreateTex(bd)
	F.CreateBD(bd)
	F.CreateSD(bd)
	eb.bd = bd
	for i = 3, 8 do
		select(i, eb:GetRegions()):SetAlpha(0)
	end

	local lang = _G[name.."EditBoxLanguage"]
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint("TOPLEFT", eb, "TOPRIGHT", 4, 0)
	lang:SetPoint("BOTTOMRIGHT", eb, "BOTTOMRIGHT", 30, 0)
	F.CreateBD(lang)
	F.CreateSD(lang)
	F.CreateTex(lang)

	F.StripTextures(self)
	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)

	--if C.chat.lockPosition then
	--	ChatFrame1:ClearAllPoints()
	--	ChatFrame1:SetPoint(unpack(C.chat.position))
	--end

	self.styled = true
end


-- Quick Scroll
hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(self, dir)
	if dir > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsControlKeyDown() then
			self:ScrollUp()
			self:ScrollUp()
		end
	else
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsControlKeyDown() then
			self:ScrollDown()
			self:ScrollDown()
		end
	end
end)

-- chat frame fading
local function EnableFading(i)
	local chatFrameNumber = ("ChatFrame%d"):format(i);
	local ChatFrameNumberFrame = _G[chatFrameNumber];
	
	ChatFrameNumberFrame:SetFading(true);
	ChatFrameNumberFrame:SetTimeVisible(10);
	ChatFrameNumberFrame:SetFadeDuration(10);
end

-- alt click invite
local DefaultSetItemRef = SetItemRef
function SetItemRef(link, ...)
	local type, value = link:match("(%a+):(.+)")
	--print(type)
	if IsAltKeyDown() and type == "player" then
		InviteUnit(value:match("([^:]+)"))
	elseif (type == "url") then
		local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
		if not eb then return end
		eb:Show()
		eb:SetText(value)
		eb:SetFocus()
		eb:HighlightText()
	else
		return DefaultSetItemRef(link, ...)
	end
end

-- whisper to target
hooksecurefunc('ChatEdit_OnSpacePressed', function(self)
	if(string.sub(self:GetText(), 1, 3) == '/tt' and (UnitCanCooperate('player', 'target') or UnitIsUnit('player', 'target'))) then
		self:SetText(SLASH_SMART_WHISPER1 .. ' ' .. GetUnitName('target', true):gsub(' ', '') .. ' ')
		ChatEdit_ParseText(self, 0)
	end
end)

SLASH_TELLTARGET1 = '/tt'
SlashCmdList.TELLTARGET = function(str)
	if(UnitCanCooperate('player', 'target')) then
		SendChatMessage(str, 'WHISPER', GetDefaultLanguage('player'), GetUnitName('target', true):gsub(' ', ''))
	end
end

-- time stamp
local function updateTimestamp()
	local greyStamp = C.greyColor.."%H:%M|r "
	if C.chat.timeStamp then
		SetCVar("showTimestamps", greyStamp)
	else
		SetCVar("showTimestamps", "none")
	end
end
F.UpdateTimestamp = updateTimestamp

-- lock position
local function ForceChatSettings()
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint(unpack(C.chat.position))

	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		ChatFrame_RemoveMessageGroup(cf, "CHANNEL")
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, true)
end


function module:OnLogin()
	for i = 1, NUM_CHAT_WINDOWS do
		skinChat(_G["ChatFrame"..i])
	end

	hooksecurefunc("FCF_OpenTemporaryWindow", function()
		for _, chatFrameName in next, CHAT_FRAMES do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				skinChat(frame)
			end
		end
	end)

	-- update chat edit box border color
	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local editBox = ChatEdit_ChooseBoxForSend()
		local mType = editBox:GetAttribute("chatType")
		if mType == "CHANNEL" then
			local id = GetChannelName(editBox:GetAttribute("channelTarget"))
			if id == 0 then
				editBox.bd:SetBackdropBorderColor(0, 0, 0)
			else
				editBox.bd:SetBackdropBorderColor(ChatTypeInfo[mType..id].r,ChatTypeInfo[mType..id].g,ChatTypeInfo[mType..id].b)
			end
		elseif mType == "SAY" then
			editBox.bd:SetBackdropBorderColor(0, 0, 0)
		else
			editBox.bd:SetBackdropBorderColor(ChatTypeInfo[mType].r,ChatTypeInfo[mType].g,ChatTypeInfo[mType].b)
		end
	end)

	-- Font size
	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end

	-- Default
	SetCVar("chatStyle", "classic")
	F.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

	-- Sticky
	if C.chat.sticky then
		ChatTypeInfo.SAY.sticky = 1
		ChatTypeInfo.EMOTE.sticky = 1
		ChatTypeInfo.YELL.sticky = 1
		ChatTypeInfo.PARTY.sticky = 1
		ChatTypeInfo.PARTY_LEADER.sticky = 1
		ChatTypeInfo.GUILD.sticky = 1
		ChatTypeInfo.OFFICER.sticky = 1
		ChatTypeInfo.RAID.sticky = 1
		ChatTypeInfo.RAID_WARNING.sticky = 1
		ChatTypeInfo.INSTANCE_CHAT.sticky = 1
		ChatTypeInfo.INSTANCE_CHAT_LEADER.sticky = 1
		ChatTypeInfo.WHISPER.sticky = 1
		ChatTypeInfo.BN_WHISPER.sticky = 1
		ChatTypeInfo.CHANNEL.sticky = 1
	end

	-- don't cut the toastframe
	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15,15,15,-15)

	-- voice chat stuff
	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-50,50,50,-50)
	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-50,50,50,-50)
	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-50,50,50,-50)

	-- Easy Resizing
	ChatFrame1Tab:HookScript("OnMouseDown", function(_, btn)
		if btn == "LeftButton" then
			if select(8, GetChatWindowInfo(1)) then
				ChatFrame1:StartSizing("TOP")
			end
		end
	end)
	ChatFrame1Tab:SetScript("OnMouseUp", function(_, btn)
		if btn == "LeftButton" then
			ChatFrame1:StopMovingOrSizing()
			FCF_SavePositionAndDimensions(ChatFrame1)
		end
	end)

	local function HideForever(f)
		f:SetScript("OnShow", f.Hide)
		f:Hide()
	end

	HideForever(ChatFrameMenuButton)
	HideForever(QuickJoinToastButton)
	HideForever(GeneralDockManagerOverflowButton)
	HideForever(ChatFrameChannelButton)
	HideForever(ChatFrameToggleVoiceDeafenButton)
	HideForever(ChatFrameToggleVoiceMuteButton)

	if C.chat.lockPosition then
		ForceChatSettings()
	end

	self:ChatFilter()
	updateTimestamp()

	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end

	SetCVar("profanityFilter", 0)

end