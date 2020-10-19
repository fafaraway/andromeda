local F, C = unpack(select(2, ...))
local CHAT = F.CHAT


local tostring, pairs, ipairs, strsub, strlower = tostring, pairs, ipairs, string.sub, string.lower
local IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown = IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown
local ChatEdit_UpdateHeader, GetChannelList, GetCVar, SetCVar, Ambiguate = ChatEdit_UpdateHeader, GetChannelList, GetCVar, SetCVar, Ambiguate
local GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant = GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant
local CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected = CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local InviteToGroup = C_PartyInfo.InviteUnit

local maxLines = 1024
local isBattleNet


local isScaling = false
function CHAT:UpdateChatSize()
	if not FreeDB.chat.lock_position then return end
	if isScaling then return end
	isScaling = true

	if ChatFrame1:IsMovable() then
		ChatFrame1:SetUserPlaced(true)
	end

	if ChatFrame1.FontStringContainer then
		ChatFrame1.FontStringContainer:SetOutside(ChatFrame1)
	end

	if ChatFrame1:IsShown() then
		ChatFrame1:Hide()
		ChatFrame1:Show()
	end

	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', C.UIGap, C.UIGap)
	ChatFrame1:SetSize(FreeDB.chat.window_width, FreeDB.chat.window_height)

	isScaling = false
end

function CHAT:TabSetAlpha(alpha)
	if self.glow:IsShown() and alpha ~= 1 then
		self:SetAlpha(1)
	end
end

function CHAT:UpdateTabColors(selected)
	if self.glow:IsShown() then
		if self.whisperIndex == 1 then
			self.Text:SetTextColor(1, .5, 1)
		elseif self.whisperIndex == 2 then
			self.Text:SetTextColor(0, 1, .96)
		else
			self.Text:SetTextColor(1, .8, 0)
		end
	elseif selected then
		self.Text:SetTextColor(1, .8, 0)
		self.whisperIndex = 0
	else
		self.Text:SetTextColor(.5, .5, .5)
		self.whisperIndex = 0
	end
end

function CHAT:UpdateTabEventColors(event)
	local tab = _G[self:GetName()..'Tab']
	local selected = GeneralDockManager.selected:GetID() == tab:GetID()
	if event == 'CHAT_MSG_WHISPER' then
		tab.whisperIndex = 1
		CHAT.UpdateTabColors(tab, selected)
	elseif event == 'CHAT_MSG_BN_WHISPER' then
		tab.whisperIndex = 2
		CHAT.UpdateTabColors(tab, selected)
	end
end

function CHAT:RestyleChatFrame()
	if not self or self.styled then return end

	local name = self:GetName()

	if FreeDB.chat.fade_out then
		self:SetFading(true)
		self:SetTimeVisible(FreeDB.chat.fading_visible)
		self:SetFadeDuration(FreeDB.chat.fading_duration)
	end

	local fontSize = select(2, self:GetFont())
	self:SetFont(C.Assets.Fonts.Chat, fontSize, FreeDB.chat.font_outline and 'OUTLINE')
	self:SetShadowColor(0, 0, 0, FreeDB.chat.font_outline and 0 or 1)
	self:SetShadowOffset(2, -2)

	self:SetClampedToScreen(false)
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(C.ScreenWidth, C.ScreenHeight)
	self:SetMinResize(100, 50)
	if self:GetMaxLines() < maxLines then
		self:SetMaxLines(maxLines)
	end

	local eb = _G[name..'EditBox']
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 4, 26)
	eb:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -17, 50)

	eb.bd = F.SetBD(eb)

	for i = 3, 8 do
		select(i, eb:GetRegions()):SetAlpha(0)
	end

	local lang = _G[name..'EditBoxLanguage']
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint('TOPLEFT', eb, 'TOPRIGHT', 5, 0)
	lang:SetPoint('BOTTOMRIGHT', eb, 'BOTTOMRIGHT', 29, 0)
	lang.bd = F.SetBD(lang)

	local tab = _G[name..'Tab']
	tab:SetAlpha(1)
	tab.Text:SetFont(C.Assets.Fonts.Chat, 12, FreeDB.chat.outline and 'OUTLINE')
	tab.Text:SetShadowColor(0, 0, 0, FreeDB.chat.outline and 0 or 1)
	tab.Text:SetShadowOffset(2, -2)
	F.StripTextures(tab, 7)
	hooksecurefunc(tab, 'SetAlpha', CHAT.TabSetAlpha)

	F.StripTextures(self)

	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)

	F.HideObject(_G.ChatFrameMenuButton)
	F.HideObject(_G.QuickJoinToastButton)

	if FreeDB.chat.voice_button then
		_G.ChatFrameChannelButton:ClearAllPoints()
		_G.ChatFrameChannelButton:SetPoint('TOPRIGHT', _G.ChatFrame1, 'TOPLEFT', -6, -26)
		_G.ChatFrameChannelButton:SetParent(UIParent)
	else
		F.HideObject(_G.ChatFrameChannelButton)
		F.HideObject(_G.ChatFrameToggleVoiceDeafenButton)
		F.HideObject(_G.ChatFrameToggleVoiceMuteButton)
	end

	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-C.UIGap, C.UIGap, C.UIGap, -C.UIGap)

	self.oldAlpha = self.oldAlpha or 0 -- fix blizz error, need reviewed

	self.styled = true
end

function CHAT:UpdateEditBoxBorderColor()
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

function CHAT:UpdateTabChannelSwitch()
	if not FreeDB.chat.tab_cycle then return end
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

function CHAT:ResizeChatFrame()
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

local function UpdateChatBubble()
	local name, instType = GetInstanceInfo()
	if name and (instType == 'raid' or instType == 'party' or instType == 'scenario' or instType == 'pvp' or instType == 'arena') then
		SetCVar('chatBubbles', 1)
	else
		SetCVar('chatBubbles', 0)
	end
end

function CHAT:AutoToggleChatBubble()
	if FreeDB.chat.smart_bubble then
		F:RegisterEvent('PLAYER_ENTERING_WORLD', UpdateChatBubble)
	else
		F:UnregisterEvent('PLAYER_ENTERING_WORLD', UpdateChatBubble)
	end
end

-- alt + left click for group invite
-- ctrl + left click for guild invite
function CHAT:ClickToInvite(link, _, button)
	if not FreeDB.chat.click_to_invite then return end

	local type, value = link:match('(%a+):(.+)')
	local hide

	if button == 'LeftButton' and IsModifierKeyDown() then
		if type == 'player' then
			local unit = value:match('([^:]+)')

			if IsAltKeyDown() then
				InviteToGroup(unit)

				hide = true
			elseif IsControlKeyDown() then
				GuildInvite(unit)

				hide = true
			end
		elseif type == 'BNplayer' then
			local _, bnID = value:match('([^:]*):([^:]*):')
			if not bnID then return end

			local accountInfo = C_BattleNet_GetAccountInfoByID(bnID)
			if not accountInfo then return end

			local gameAccountInfo = accountInfo.gameAccountInfo
			local gameID = gameAccountInfo.gameAccountID

			if gameID and CanCooperateWithGameAccount(accountInfo) then
				if IsAltKeyDown() then
					BNInviteFriend(gameID)

					hide = true
				elseif IsControlKeyDown() then
					local charName = gameAccountInfo.characterName
					local realmName = gameAccountInfo.realmName

					GuildInvite(charName..'-'..realmName)

					hide = true
				end
			end
		end
	else

		return
	end

	if hide then ChatEdit_ClearChat(ChatFrame1.editBox) end
end


function CHAT:OnLogin()
	if not FreeDB.chat.enable_chat then return end

	for i = 1, _G.NUM_CHAT_WINDOWS do
		self.RestyleChatFrame(_G['ChatFrame'..i])
	end

	hooksecurefunc('FCF_OpenTemporaryWindow', function()
		for _, chatFrameName in ipairs(_G.CHAT_FRAMES) do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				self.RestyleChatFrame(frame)
			end
		end
	end)

	-- update tabs
	hooksecurefunc('FCFTab_UpdateColors', self.UpdateTabColors)
	hooksecurefunc('FloatingChatFrame_OnEvent', self.UpdateTabEventColors)

	-- Font size
	for i = 1, 15 do
		_G.CHAT_FONT_HEIGHTS[i] = i + 9
	end

	-- Default
	F.HideOption(_G.InterfaceOptionsSocialPanelChatStyle)
	_G.CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

	-- Lock chatframe
	if FreeDB.chat.lock_position then
		self:UpdateChatSize()
		hooksecurefunc('FCF_SavePositionAndDimensions', self.UpdateChatSize)
		F:RegisterEvent('UI_SCALE_CHANGED', self.UpdateChatSize)
	end


	hooksecurefunc('ChatFrame_OnHyperlinkShow', CHAT.ClickToInvite)
	hooksecurefunc('ChatEdit_CustomTabPressed', CHAT.UpdateTabChannelSwitch)
	hooksecurefunc('FloatingChatFrame_OnMouseScroll', CHAT.QuickMouseScroll)


	self:UpdateEditBoxBorderColor()
	self:ResizeChatFrame()
	self:ChatFilter()
	self:Abbreviate()
	self:ChatCopy()
	self:UrlCopy()
	self:Spamagemeter()
	self:WhisperSticky()
	self:WhisperAlert()
	self:AutoToggleChatBubble()


	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end

	if C.isCNPortal then
		ConsoleExec('portal TW')
	end
	SetCVar('profanityFilter', 0)
end
