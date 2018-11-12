local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule('chat')



local function SkinChat(self)
	if not self or (self and self.styled) then return end

	local name = self:GetName()
	local fontSize = select(2, self:GetFont())
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
	self:SetMinResize(100, 50)
	
	if C.chat.fontOutline then
		self:SetFont(C.font.chat, fontSize, 'OUTLINE')
		self:SetShadowColor(0, 0, 0, 0)
	else
		self:SetFont(C.font.chat, fontSize, nil)
		self:SetShadowColor(0, 0, 0, 1)
		self:SetShadowOffset(2, -2)
	end
	
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetClampedToScreen(false)
	if self:GetMaxLines() < 1024 then
		self:SetMaxLines(1024)
	end

	local eb = _G[name..'EditBox']
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 2, 24)
	eb:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -13, 48)

	local bd = CreateFrame('Frame', nil, eb)
	bd:SetPoint('TOPLEFT', -1, 1)
	bd:SetPoint('BOTTOMRIGHT', 1, -1)
	bd:SetFrameLevel(eb:GetFrameLevel() - 1)
	F.CreateTex(bd)
	F.CreateBD(bd, .3)
	F.CreateSD(bd)
	eb.bd = bd
	for i = 3, 8 do
		select(i, eb:GetRegions()):SetAlpha(0)
	end

	local lang = _G[name..'EditBoxLanguage']
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint('TOPLEFT', eb, 'TOPRIGHT', 4, 0)
	lang:SetPoint('BOTTOMRIGHT', eb, 'BOTTOMRIGHT', 30, 0)
	F.CreateBD(lang)
	F.CreateSD(lang)
	F.CreateTex(lang)

	F.StripTextures(self)
	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)

	self.styled = true
end


-- scroll helper
local function ScrollChat(frame, delta)
	if IsControlKeyDown()  then--Faster Scroll
		if ( delta > 0 ) then --Faster scrolling by triggering a few scroll up in a loop
			for i = 1,5 do 
				frame:ScrollUp()
			end
		elseif ( delta < 0 ) then
			for i = 1,5 do 
				frame:ScrollDown()
			end
		end
	elseif IsAltKeyDown() then
		if ( delta > 0 ) then --Scroll to the top or bottom
			frame:ScrollToTop()
		elseif ( delta < 0 ) then
			frame:ScrollToBottom()
		end
	else
		if delta > 0 then --Normal Scroll
			frame:ScrollUp()
		elseif delta < 0 then
			frame:ScrollDown()
		end
	end
end

local function MakeScrollingDynamic(i)
	local chatFrameNumber = ('ChatFrame%d'):format(i)
	local ChatFrameNumberFrame = _G[chatFrameNumber]
	
	ChatFrameNumberFrame:EnableMouseWheel(true)
	ChatFrameNumberFrame:SetScript('OnMouseWheel', ScrollChat)
end

-- 
local function EnableClearCommand()
	SLASH_CLEARCHAT1, SLASH_CLEARCHAT2 = '/c', '/clear';
	
	function SlashCmdList.CLEARCHAT()
		for i = 1, NUM_CHAT_WINDOWS do
			local chatFrameNumber = ('ChatFrame%d'):format(i)
			local ChatFrameNumberFrame = _G[chatFrameNumber]
			ChatFrameNumberFrame:Clear()
		end
	end
end

-- chat frame fading
local function EnableFading(i)
	if not C.chat.lineFading then return end

	local chatFrameNumber = ('ChatFrame%d'):format(i)
	local ChatFrameNumberFrame = _G[chatFrameNumber]
	
	ChatFrameNumberFrame:SetFading(true)
	ChatFrameNumberFrame:SetTimeVisible(C.chat.timeVisible)
	ChatFrameNumberFrame:SetFadeDuration(C.chat.fadeDuration)
end

--
local function DisableHoldAlt(i)
	local chatFrameNumber = ('ChatFrame%d'):format(i)
	local chatFrameNumberEditBox = _G[chatFrameNumber..'EditBox']
	
	chatFrameNumberEditBox:SetAltArrowKeyMode(false)
end

-- url
local function DetectUrls()
	local newAddMsg = {}
	local function AddMessage(frame, message, ...)
		
		if (message) then
			message = gsub(message, '([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')
			message = gsub(message, ' ([_A-Za-z0-9-%.]+@[_A-Za-z0-9-]+%.+[_A-Za-z0-9-%.]+)%s?', '|cffffffff|Hurl:%1|h[%1]|h|r')
			message = gsub(message, ' (%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)%s?', '|cffffffff|Hurl:%1|h[%1]|h|r')
			message = gsub(message, ' (%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)%s?', '|cffffffff|Hurl:%1|h[%1]|h|r')
			return newAddMsg[frame:GetName()](frame, message, ...)
		end
	end

	for i = 1, NUM_CHAT_WINDOWS do
		
		if i ~= 2 then
			local frame = _G[format('%s%d', 'ChatFrame', i)]
			newAddMsg[format('%s%d', 'ChatFrame', i)] = frame.AddMessage
			frame.AddMessage = AddMessage
		end
	end
	
	local orig = ChatFrame_OnHyperlinkShow
	function ChatFrame_OnHyperlinkShow(frame, link, text, button)
		local type, value = link:match('(%a+):(.+)')
		
		if ( type == 'url' ) then
			local editBox = _G[frame:GetName()..'EditBox']
			if editBox then
				editBox:Show()
				editBox:SetText(value)
				editBox:SetFocus()
				editBox:HighlightText()
			end
		else
			orig(self, link, text, button)
		end
	end
end

-- alt click invite
local DefaultSetItemRef = SetItemRef
function SetItemRef(link, ...)
	local type, value = link:match('(%a+):(.+)')
	--print(type)
	if IsAltKeyDown() and type == 'player' then
		InviteUnit(value:match('([^:]+)'))
	else
		return DefaultSetItemRef(link, ...)
	end
end

-- sticky
module.StickyTypeChannels = {
	SAY = 1,
	YELL = 0,
	EMOTE = 0,
	PARTY = 1,
	PARTY_LEADER = 1,
	RAID = 1,
	GUILD = 1,
	OFFICER = 1,
	WHISPER = 1,
	BN_WHISPER = 1,
	CHANNEL = 1,
	INSTANCE_CHAT = 1,
	INSTANCE_CHAT_LEADER = 1,
}
local function MakeChannelsSticky()
	if not C.chat.channelSticky then return end

	for i, v in pairs(module.StickyTypeChannels) do
		ChatTypeInfo[i].sticky = v
	end
end

-- whisper to target
local function WhisperTarget()
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
end

-- time stamp
local function UpdateTimeStamp()
	local greyStamp = C.GreyColor..'%H:%M|r '
	if C.chat.timeStamp then
		SetCVar('showTimestamps', greyStamp)
	else
		SetCVar('showTimestamps', 'none')
	end
end

-- lock position
local function ForceChatSettings()
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint(unpack(C.chat.position))

	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G['ChatFrame'..i]
		ChatFrame_RemoveMessageGroup(cf, 'CHANNEL')
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, true)
end

-- hide useless buttons
local function HideForever(f)
	f:SetScript('OnShow', f.Hide)
	f:Hide()
end
local function RemoveUselessButtons()
	HideForever(ChatFrameMenuButton)
	HideForever(QuickJoinToastButton)
	HideForever(GeneralDockManagerOverflowButton)

	if not  C.chat.voiceButtons then
		HideForever(ChatFrameChannelButton)
		HideForever(ChatFrameToggleVoiceDeafenButton)
		HideForever(ChatFrameToggleVoiceMuteButton)
	end
end

-- update chat edit box border color
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

-- don't cut the toastframe
local function AdjustBNToastFrame()
	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15,15,15,-15)
end

-- voice chat stuff
local function AdjustVoiceChatFrame()
	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-50,50,50,-50)
	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-50,50,50,-50)
	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-50,50,50,-50)
end

-- selectable font size
local function SetUpFont()
	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end
end

--
local function EasyResizing()
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

	

function module:OnLogin()
	for i = 1, NUM_CHAT_WINDOWS do
		local chatFrameNumber = ('ChatFrame%d'):format(i)
		local ChatFrameNumberFrame = _G[chatFrameNumber]

		if ChatFrameNumberFrame then
			SkinChat(_G['ChatFrame'..i])

			MakeScrollingDynamic(i)
			EnableFading(i)
			DisableHoldAlt(i)
		end
	end

	hooksecurefunc('FCF_OpenTemporaryWindow', function()
		for _, chatFrameName in next, CHAT_FRAMES do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				skinChat(frame)
			end
		end
	end)

	self:ChatFilter()
	self:ChatAbbreviate()
	self:WhisperSound()
	self:ChatStrings()
	self:ChatBubble()
	self:ItemLinkLevel()
	self:RealLinks()

	UpdateTimeStamp()
	EnableClearCommand()
	DetectUrls()
	MakeChannelsSticky()
	RemoveUselessButtons()
	UpdateEditBoxBorderColor()
	WhisperTarget()
	AdjustBNToastFrame()
	AdjustVoiceChatFrame()
	SetUpFont()
	EasyResizing()

	if C.chat.lockPosition then
		ForceChatSettings()
	end

	SetCVar('chatStyle', 'classic')
	F.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end

	SetCVar('profanityFilter', 0)
end