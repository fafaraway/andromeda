local F, C = unpack(select(2, ...))
local CHAT = F:GetModule('CHAT')


local maxLines = 1024
local maxWidth, maxHeight = UIParent:GetWidth(), UIParent:GetHeight()
local tostring, pairs, ipairs, strsub, strlower = tostring, pairs, ipairs, string.sub, string.lower
local IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown = IsInGroup, IsInRaid, IsPartyLFG, IsInGuild, IsShiftKeyDown, IsControlKeyDown
local ChatEdit_UpdateHeader, GetChannelList, GetCVar, SetCVar, Ambiguate = ChatEdit_UpdateHeader, GetChannelList, GetCVar, SetCVar, Ambiguate
local GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant = GetNumGuildMembers, GetGuildRosterInfo, IsGuildMember, UnitIsGroupLeader, UnitIsGroupAssistant
local CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected = CanCooperateWithGameAccount, BNInviteFriend, BNFeaturesEnabledAndConnected
local C_BattleNet_GetAccountInfoByID = C_BattleNet.GetAccountInfoByID
local InviteToGroup = C_PartyInfo.InviteUnit


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
	ChatFrame1:SetPoint('BOTTOMLEFT', UIParent, 'BOTTOMLEFT', FreeADB['ui_gap'], FreeADB['ui_gap'])
	ChatFrame1:SetSize(FreeDB.chat.window_width, FreeDB.chat.window_height)

	isScaling = false
end

--[[ function CHAT:TabSetAlpha(alpha)
	if alpha ~= 1 and (not self.isDocked or GeneralDockManager.selected:GetID() == self:GetID()) then
		self:SetAlpha(1)
	elseif alpha < .6 then
		self:SetAlpha(.6)
	end
end

function CHAT:UpdateTabColors(selected)
	if selected then
		self:GetFontString():SetTextColor(C.r, C.g, C.b)
	else
		self:GetFontString():SetTextColor(.5, .5, .5)
	end
end ]]

function CHAT:RestyleChatFrame()
	if not self or (self and self.styled) then return end

	local name = self:GetName()

	if FreeDB.chat.fade_out then
		self:SetFading(true)
		self:SetTimeVisible(FreeDB.chat.fading_visible)
		self:SetFadeDuration(FreeDB.chat.fading_duration)
	end

	local fontSize = select(2, self:GetFont())
	if FreeDB.chat.font_outline then
		self:SetFont(C.Assets.Fonts.Chat, fontSize, 'OUTLINE')
		self:SetShadowColor(0, 0, 0, 0)
	else
		self:SetFont(C.Assets.Fonts.Chat, fontSize, nil)
		self:SetShadowColor(0, 0, 0, 1)
		self:SetShadowOffset(2, -2)
	end

	self:SetClampedToScreen(false)
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(maxWidth, maxHeight)
	self:SetMinResize(100, 50)
	if self:GetMaxLines() < maxLines then
		self:SetMaxLines(maxLines)
	end

	local eb = _G[name..'EditBox']
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 4, 26)
	eb:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -17, 50)

	eb.bd = F.CreateBDFrame(eb, .6, true)

	for i = 3, 8 do
		select(i, eb:GetRegions()):SetAlpha(0)
	end

	local lang = _G[name..'EditBoxLanguage']
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint('TOPLEFT', eb, 'TOPRIGHT', 5, 0)
	lang:SetPoint('BOTTOMRIGHT', eb, 'BOTTOMRIGHT', 29, 0)
	lang.bd = F.CreateBDFrame(lang, .6, true)

	-- local tab = _G[name..'Tab']
	-- tab:SetAlpha(1)
	-- local tabFs = tab:GetFontString()
	-- F.StripTextures(tab, 7)
	-- hooksecurefunc(tab, 'SetAlpha', CHAT.TabSetAlpha)

	-- if FreeDB.chat.outline then
	-- 	tabFs:SetFont(C.Assets.Fonts.Chat, 12, 'OUTLINE')
	-- 	tabFs:SetShadowColor(0, 0, 0, 0)
	-- else
	-- 	tabFs:SetFont(C.Assets.Fonts.Chat, 12)
	-- 	tabFs:SetShadowColor(0, 0, 0, 1)
	-- 	tabFs:SetShadowOffset(2, -2)
	-- end

	if FreeDB.chat.lock_position then F.StripTextures(self) end

	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)



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
hooksecurefunc('ChatEdit_CustomTabPressed', CHAT.UpdateTabChannelSwitch)

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
hooksecurefunc('FloatingChatFrame_OnMouseScroll', CHAT.QuickMouseScroll)

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

local function updateChatBubble()
	local name, instType = GetInstanceInfo()
	if name and (instType == 'raid' or instType == 'party' or instType == 'scenario' or instType == 'pvp' or instType == 'arena') then
		SetCVar('chatBubbles', 1)
	else
		SetCVar('chatBubbles', 0)
	end
end

function CHAT:AutoToggleChatBubble()
	if FreeDB.chat.smart_bubble then
		F:RegisterEvent('PLAYER_ENTERING_WORLD', updateChatBubble)
	else
		F:UnregisterEvent('PLAYER_ENTERING_WORLD', updateChatBubble)
	end
end

-- alt + left click for group invite
-- ctrl + left click for guild invite
local function ClickToInvite(self, link, _, button)
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

	for i = 1, NUM_CHAT_WINDOWS do
		self.RestyleChatFrame(_G['ChatFrame'..i])
	end

	hooksecurefunc('FCF_OpenTemporaryWindow', function()
		for _, chatFrameName in next, CHAT_FRAMES do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				self.RestyleChatFrame(frame)
			end
		end
	end)

	--hooksecurefunc('FCFTab_UpdateColors', self.UpdateTabColors)

	-- Font size
	for i = 1, 15 do
		CHAT_FONT_HEIGHTS[i] = i + 9
	end

	-- Default
	SetCVar('chatStyle', 'classic')
	F.HideOption(InterfaceOptionsSocialPanelChatStyle)
	CombatLogQuickButtonFrame_CustomTexture:SetTexture(nil)

	-- Lock chatframe
	if FreeDB.chat.lock_position then
		self:UpdateChatSize()
		hooksecurefunc('FCF_SavePositionAndDimensions', self.UpdateChatSize)
		F:RegisterEvent('UI_SCALE_CHANGED', self.UpdateChatSize)
	end

	hooksecurefunc('ChatFrame_OnHyperlinkShow', ClickToInvite)

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
	self:RestyleTabs()





	BNToastFrame:SetClampedToScreen(true)
	BNToastFrame:SetClampRectInsets(-FreeADB['ui_gap'], FreeADB['ui_gap'], FreeADB['ui_gap'], -FreeADB['ui_gap'])

	VoiceChatPromptActivateChannel:SetClampedToScreen(true)
	VoiceChatPromptActivateChannel:SetClampRectInsets(-FreeADB['ui_gap'], FreeADB['ui_gap'], FreeADB['ui_gap'], -FreeADB['ui_gap'])

	VoiceChatChannelActivatedNotification:SetClampedToScreen(true)
	VoiceChatChannelActivatedNotification:SetClampRectInsets(-FreeADB['ui_gap'], FreeADB['ui_gap'], FreeADB['ui_gap'], -FreeADB['ui_gap'])

	ChatAlertFrame:SetClampedToScreen(true)
	ChatAlertFrame:SetClampRectInsets(-FreeADB['ui_gap'], FreeADB['ui_gap'], FreeADB['ui_gap'], -FreeADB['ui_gap'])

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

	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end

	if C.isCNPortal then
		ConsoleExec('portal TW')
	end
	SetCVar('profanityFilter', 0)
end
