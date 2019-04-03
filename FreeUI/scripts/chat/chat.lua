local F, C, L = unpack(select(2, ...))
if not C.chat.enable then return end
local module = F:RegisterModule('Chat')


local tostring, pairs, ipairs, strsub, strlower = tostring, pairs, ipairs, string.sub, string.lower

local function SkinChat(self)
	if not self or (self and self.styled) then return end

	local name = self:GetName()
	local fontSize = select(2, self:GetFont())
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
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

hooksecurefunc("ChatEdit_CustomTabPressed", function(self)
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
end)


local function ScrollChat(frame, delta)
	if IsControlKeyDown() then --Faster Scroll
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


local function EnableFading(i)
	if not C.chat.lineFading then return end

	local chatFrameNumber = ('ChatFrame%d'):format(i)
	local ChatFrameNumberFrame = _G[chatFrameNumber]
	
	ChatFrameNumberFrame:SetFading(true)
	ChatFrameNumberFrame:SetTimeVisible(C.chat.timeVisible)
	ChatFrameNumberFrame:SetFadeDuration(C.chat.fadeDuration)
end


local function DisableHoldAlt(i)
	local chatFrameNumber = ('ChatFrame%d'):format(i)
	local chatFrameNumberEditBox = _G[chatFrameNumber..'EditBox']
	
	chatFrameNumberEditBox:SetAltArrowKeyMode(false)
end


-- alt click name to invite
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

local stickyTypeChannels = {}
stickyTypeChannels = {
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
local function ChannelsSticky()
	if not C.chat.channelSticky then return end

	for i, v in pairs(stickyTypeChannels) do
		ChatTypeInfo[i].sticky = v
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

	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end

	SetCVar("chatStyle", "classic")
	F.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

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

	ToggleChatColorNamesByClassGroup(true, 'SAY')
	ToggleChatColorNamesByClassGroup(true, 'EMOTE')
	ToggleChatColorNamesByClassGroup(true, 'YELL')
	ToggleChatColorNamesByClassGroup(true, 'GUILD')
	ToggleChatColorNamesByClassGroup(true, 'OFFICER')
	ToggleChatColorNamesByClassGroup(true, 'GUILD_ACHIEVEMENT')
	ToggleChatColorNamesByClassGroup(true, 'ACHIEVEMENT')
	ToggleChatColorNamesByClassGroup(true, 'WHISPER')
	ToggleChatColorNamesByClassGroup(true, 'PARTY')
	ToggleChatColorNamesByClassGroup(true, 'PARTY_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'RAID')
	ToggleChatColorNamesByClassGroup(true, 'RAID_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'RAID_WARNING')
	ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND')
	ToggleChatColorNamesByClassGroup(true, 'BATTLEGROUND_LEADER')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL1')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL2')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL3')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL4')
	ToggleChatColorNamesByClassGroup(true, 'CHANNEL5')
	ToggleChatColorNamesByClassGroup(true, 'INSTANCE_CHAT')
	ToggleChatColorNamesByClassGroup(true, 'INSTANCE_CHAT_LEADER')


	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-15,15,15,-15)

	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-50,50,50,-50)
	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-50,50,50,-50)
	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-50,50,50,-50)

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
		F:RegisterEvent("UI_SCALE_CHANGED", function()
			ChatFrame1:SetPoint(unpack(C.chat.position))
		end)
	end

	UpdateTimestamp()
	UpdateEditBoxBorderColor()
	WhisperTarget()
	ChannelsSticky()
	
	self:Filter()
	self:Abbreviate()
	self:Whisper()
	self:ItemLink()
	self:RealLink()
	self:Button()
	self:UrlCopy()
	self:NameCopy()
	self:Tab()
	self:Spamagemeter()
end