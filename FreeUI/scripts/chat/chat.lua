local F, C, L = unpack(select(2, ...))
local CHAT = F:RegisterModule('Chat')


local tostring, pairs, ipairs, strsub, strlower = tostring, pairs, ipairs, string.sub, string.lower

function CHAT:RestyleChatFrame()
	if not self or (self and self.styled) then return end

	local name = self:GetName()

	if C.chat.fading then
		self:SetFading(true)
		self:SetTimeVisible(C.chat.fadingVisible)
		self:SetFadeDuration(C.chat.fadingDuration)
	end
	
	local fontSize = select(2, self:GetFont())
	if C.chat.fontOutline then
		self:SetFont(C.font.chat, fontSize, 'OUTLINE')
		self:SetShadowColor(0, 0, 0, 0)
	else
		self:SetFont(C.font.chat, fontSize, nil)
		self:SetShadowColor(0, 0, 0, 1)
		self:SetShadowOffset(2, -2)
	end
	
	self:SetClampedToScreen(false)
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
	self:SetMinResize(100, 50)
	if self:GetMaxLines() < 1024 then
		self:SetMaxLines(1024)
	end

	local eb = _G[name..'EditBox']
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 2, 24)
	eb:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -13, 48)

	eb.bd = F.CreateBDFrame(eb)
	F.CreateSD(eb.bd)

	for i = 3, 8 do
		select(i, eb:GetRegions()):SetAlpha(0)
	end

	local lang = _G[name..'EditBoxLanguage']
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint('TOPLEFT', eb, 'TOPRIGHT', 4, 0)
	lang:SetPoint('BOTTOMRIGHT', eb, 'BOTTOMRIGHT', 30, 0)
	F.CreateBD(lang)
	F.CreateSD(lang)

	F.StripTextures(self)
	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)

	self.styled = true
end


local cycles = {
	{ chatType = 'SAY', use = function() return 1 end },
	{ chatType = 'PARTY', use = function() return IsInGroup() end },
	{ chatType = 'RAID', use = function() return IsInRaid() end },
	{ chatType = 'INSTANCE_CHAT', use = function() return IsPartyLFG() end },
	{ chatType = 'GUILD', use = function() return IsInGuild() end },
	{ chatType = 'CHANNEL', use = function(_, editbox)
		if GetCVar('portal') ~= 'CN' then return false end
		local channels, inWorldChannel, number = {GetChannelList()}
		for i = 1, #channels do
			if channels[i] == '大脚世界频道' then
				inWorldChannel = true
				number = channels[i-1]
				break
			end
		end
		if inWorldChannel then
			editbox:SetAttribute('channelTarget', number)
			return true
		else
			return false
		end
	end },
	{ chatType = 'SAY', use = function() return 1 end },
}

local function UpdateTabChannelSwitch()
	if strsub(tostring(self:GetText()), 1, 1) == '/' then return end
	local currChatType = self:GetAttribute('chatType')
	for i, curr in ipairs(cycles) do
		if curr.chatType == currChatType then
			local h, r, step = i+1, #cycles, 1
			if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
			for j = h, r, step do
				if cycles[j]:use(self, currChatType) then
					self:SetAttribute('chatType', cycles[j].chatType)
					ChatEdit_UpdateHeader(self)
					return
				end
			end
		end
	end
end

local function QuickMouseScroll(dir)
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
end

local function UpdateTimestamp()
	local timeStamp = F.HexRGB(unpack(C.chat.timeStampColor))..'%H:%M|r '
	if C.chat.timeStamp then
		SetCVar('showTimestamps', timeStamp)
	elseif GetCVar('showTimestamps') == timeStamp then
		SetCVar('showTimestamps', 'none')
	end
end

local function UpdateEditBoxBorderColor()
	hooksecurefunc('ChatEdit_UpdateHeader', function()
		local editBox = ChatEdit_ChooseBoxForSend()
		local mType = editBox:GetAttribute('chatType')
		if mType == 'CHANNEL' then
			local id = GetChannelName(editBox:GetAttribute('channelTarget'))
			if id == 0 then
				editBox.bd:SetBackdropBorderColor(0, 0, 0)
			else
				editBox.bd:SetBackdropBorderColor(ChatTypeInfo[mType..id].r,ChatTypeInfo[mType..id].g,ChatTypeInfo[mType..id].b)
			end
		elseif mType == 'SAY' then
			editBox.bd:SetBackdropBorderColor(0, 0, 0)
		else
			editBox.bd:SetBackdropBorderColor(ChatTypeInfo[mType].r,ChatTypeInfo[mType].g,ChatTypeInfo[mType].b)
		end
	end)
end

local function ResizeChatFrame()
	ChatFrame1Tab:HookScript('OnMouseDown', function(_, btn)
		if btn == 'LeftButton' then
			if select(8, GetChatWindowInfo(1)) then
				ChatFrame1:StartSizing('TOP')
			end
		end
	end)
	ChatFrame1Tab:SetScript('OnMouseUp', function(_, btn)
		if btn == 'LeftButton' then
			ChatFrame1:StopMovingOrSizing()
			FCF_SavePositionAndDimensions(ChatFrame1)
		end
	end)
end

local DefaultSetItemRef = SetItemRef
function SetItemRef(link, ...)
	local type, value = link:match('(%a+):(.+)')
	if IsAltKeyDown() and type == 'player' then
		InviteUnit(value:match('([^:]+)'))
	else
		return DefaultSetItemRef(link, ...)
	end
end

local function HideForever(f)
	f:SetScript('OnShow', f.Hide)
	f:Hide()
end
	

function CHAT:OnLogin()
	if not C.chat.enable then return end

	-- Restyle chatframes
	for i = 1, NUM_CHAT_WINDOWS do
		self.RestyleChatFrame(_G['ChatFrame'..i])
	end

	-- Restyle temp chat (BN, WHISPER) when needed
	local function RestyleTempChat()
		local frame = FCF_GetCurrentChatFrame()
		if frame.styled then return end
		RestyleChatFrame(frame)
	end
	hooksecurefunc('FCF_OpenTemporaryWindow', RestyleTempChat)

	-- Lock chatframe anchor
	if C.chat.lockPosition then
		ChatFrame1:SetPoint(unpack(C.chat.position))
	end

	-- Disable pet battle tab
	local old = FCFManager_GetNumDedicatedFrames
	function FCFManager_GetNumDedicatedFrames(...)
		return select(1, ...) ~= 'PET_BATTLE_COMBAT_LOG' and old(...) or 1
	end

	-- Remove player's realm name
	local function RemoveRealmName(self, event, msg, author, ...)
		local realm = string.gsub(C.Realm, ' ', '')
		if msg:find('-' .. realm) then
			return false, gsub(msg, '%-'..realm, ''), author, ...
		end
	end
	ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', RemoveRealmName)

	-- More selectable font size
	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end

	-- Use classic chat style for default
	SetCVar('chatStyle', 'classic')
	F.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

	hooksecurefunc('FloatingChatFrame_OnMouseScroll', QuickMouseScroll)
	hooksecurefunc('ChatEdit_CustomTabPressed', UpdateTabChannelSwitch)

	HideForever(ChatFrameMenuButton)
	HideForever(QuickJoinToastButton)
	HideForever(GeneralDockManagerOverflowButton)

	if C.chat.hideVoiceButtons then
		HideForever(ChatFrameChannelButton)
		HideForever(ChatFrameToggleVoiceDeafenButton)
		HideForever(ChatFrameToggleVoiceMuteButton)
	end

	UpdateTimestamp()
	UpdateEditBoxBorderColor()
	ResizeChatFrame()
	
	self:RestyleTabs()
	self:ChatFilter()
	self:Abbreviate()
	self:ChatCopy()
	self:UrlCopy()
	self:NameCopy()
	self:Spamagemeter()
	self:ItemLinks()
	self:WhisperSticky()
	self:WhisperTarget()
	self:WhisperAlert()

	if C.chat.autoBubble then
		local function UpdateBubble()
			local name, instType = GetInstanceInfo()
			if name and instType == 'raid' then
				SetCVar('chatBubbles', 1)
			else
				SetCVar('chatBubbles', 0)
			end
		end
		UpdateBubble()
		F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateBubble)
	end

	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-50, 50, 50, -50)

	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-50, 50, 50, -50)

	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-50, 50, 50, -50)
	
	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-50, 50, 50, -50)
end