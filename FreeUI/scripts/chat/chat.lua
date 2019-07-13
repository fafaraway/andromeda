local F, C, L = unpack(select(2, ...))

local CHAT = F:RegisterModule('Chat')

local maxLines = 1024
local maxWidth, maxHeight = UIParent:GetWidth(), UIParent:GetHeight()
local tostring, pairs, ipairs, strsub, strlower = tostring, pairs, ipairs, string.sub, string.lower
local IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown = IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown
local ChatEdit_UpdateHeader, GetChatWindowInfo, GetChannelList, GetCVar, SetCVar, Ambiguate = ChatEdit_UpdateHeader, GetChatWindowInfo, GetChannelList, GetCVar, SetCVar, Ambiguate
local GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant, InviteToGroup = GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant, InviteToGroup
local BNGetFriendInfoByID, BNGetGameAccountInfo, CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected = BNGetFriendInfoByID, BNGetGameAccountInfo, CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected


function CHAT:ReskinChatFrame()
	if not self or (self and self.styled) then return end

	local name = self:GetName()
	local fontSize = select(2, self:GetFont())
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(maxWidth, maxHeight)
	self:SetMinResize(100, 50)
	
	if C.chat.useOutline then
		self:SetFont(C.font.chat, fontSize, 'OUTLINE')
		self:SetShadowColor(0, 0, 0, 0)
	else
		self:SetFont(C.font.chat, fontSize, nil)
		self:SetShadowColor(0, 0, 0, 1)
		self:SetShadowOffset(2, -2)
	end
	
	self:SetClampedToScreen(false)
	if self:GetMaxLines() < maxLines then
		self:SetMaxLines(maxLines)
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

	F.StripTextures(self)
	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)

	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15,15,15,-15)

	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-50,50,50,-50)

	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-50,50,50,-50)
	
	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-50,50,50,-50)

	self.styled = true
end


local cycles = {
	{ chatType = "SAY", use = function() return 1 end },
	{ chatType = "PARTY", use = function() return IsInGroup() end },
	{ chatType = "RAID", use = function() return IsInRaid() end },
	{ chatType = "INSTANCE_CHAT", use = function() return IsPartyLFG() end },
	{ chatType = "GUILD", use = function() return IsInGuild() end },
	{ chatType = "CHANNEL", use = function(_, editbox)
		if GetCVar("portal") ~= "CN" then return false end
		local channels, inWorldChannel, number = {GetChannelList()}
		for i = 1, #channels do
			if channels[i] == "大脚世界频道" then
				inWorldChannel = true
				number = channels[i-1]
				break
			end
		end
		if inWorldChannel then
			editbox:SetAttribute("channelTarget", number)
			return true
		else
			return false
		end
	end },
	{ chatType = "SAY", use = function() return 1 end },
}

function CHAT:UpdateTabChannelSwitch()
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
	local currChatType = self:GetAttribute("chatType")
	for i, curr in ipairs(cycles) do
		if curr.chatType == currChatType then
			local h, r, step = i+1, #cycles, 1
			if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
			for j = h, r, step do
				if cycles[j]:use(self, currChatType) then
					self:SetAttribute("chatType", cycles[j].chatType)
					ChatEdit_UpdateHeader(self)
					return
				end
			end
		end
	end
end
hooksecurefunc("ChatEdit_CustomTabPressed", CHAT.UpdateTabChannelSwitch)

function CHAT:QuickMouseScroll(dir)
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
hooksecurefunc("FloatingChatFrame_OnMouseScroll", CHAT.QuickMouseScroll)

local DefaultSetItemRef = SetItemRef
function SetItemRef(link, ...)
	local type, value = link:match('(%a+):(.+)')
	if IsAltKeyDown() and type == 'player' then
		InviteUnit(value:match('([^:]+)'))
	else
		return DefaultSetItemRef(link, ...)
	end
end

local function WhisperSticky()
	if C.chat.whisperSticky then
		ChatTypeInfo["WHISPER"].sticky = 1
		ChatTypeInfo["BN_WHISPER"].sticky = 1
	else
		ChatTypeInfo["WHISPER"].sticky = 0
		ChatTypeInfo["BN_WHISPER"].sticky = 0
	end
end

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

local function UpdateTimestamp()
	local greyStamp = C.GreyColor..'%H:%M|r '
	if C.chat.timeStamp then
		SetCVar('showTimestamps', greyStamp)
	elseif GetCVar('showTimestamps') == greyStamp then
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
end

	

function CHAT:OnLogin()
	if not C.chat.enable then return end

	for i = 1, NUM_CHAT_WINDOWS do
		self.ReskinChatFrame(_G["ChatFrame"..i])

		local chatFrameNumber = ('ChatFrame%d'):format(i)
		local chatFrameNumberFrame = _G[chatFrameNumber]
		if C.chat.lineFading then
			chatFrameNumberFrame:SetFading(true)
			chatFrameNumberFrame:SetTimeVisible(C.chat.timeVisible)
			chatFrameNumberFrame:SetFadeDuration(C.chat.fadeDuration)
		end
	end

	hooksecurefunc("FCF_OpenTemporaryWindow", function()
		for _, chatFrameName in next, CHAT_FRAMES do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				self.ReskinChatFrame(frame)
			end
		end
	end)


	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end

	

	SetCVar("chatStyle", "classic")
	F.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)


	local function HideForever(f)
		f:SetScript('OnShow', f.Hide)
		f:Hide()
	end

	HideForever(ChatFrameMenuButton)
	HideForever(QuickJoinToastButton)
	HideForever(GeneralDockManagerOverflowButton)
	HideForever(ChatFrameChannelButton)
	HideForever(ChatFrameToggleVoiceDeafenButton)
	HideForever(ChatFrameToggleVoiceMuteButton)

	if C.chat.lockPosition then
		ChatFrame1:SetPoint(unpack(C.chat.position))
	end

	WhisperSticky()
	WhisperTarget()
	UpdateTimestamp()
	UpdateEditBoxBorderColor()
	ResizeChatFrame()
	
	self:Filter()
	self:Abbreviate()
	self:WhisperSound()
	self:ItemLink()
	self:RealLink()
	self:ChatButton()
	self:UrlCopy()
	self:NameCopy()
	self:Tab()
	self:Spamagemeter()

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
end