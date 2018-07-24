local F, C, L = unpack(select(2, ...))

local module = F:RegisterModule("chat")








local hooks = {}
local chatEvents = {
	"CHAT_MSG_CHANNEL_JOIN",
	"CHAT_MSG_CHANNEL_LEAVE",
	"CHAT_MSG_CHANNEL_NOTICE",
	"CHAT_MSG_CHANNEL_NOTICE_USER",
	"CHAT_MSG_CHANNEL_LIST"
}




local maxLines = 1024
local maxWidth, maxHeight = UIParent:GetWidth(), UIParent:GetHeight()

local function skinChat(self)
	if not self or (self and self.styled) then return end

	local name = self:GetName()
	local fontSize = select(2, self:GetFont())
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetMaxResize(maxWidth, maxHeight)
	self:SetMinResize(100, 50)
	self:SetFont(C.font.chat, fontSize, "OUTLINE")
	self:SetShadowColor(0, 0, 0, 0)
	self:SetShadowOffset(1, -1)
	self:SetClampRectInsets(0, 0, 0, 0)
	self:SetClampedToScreen(false)
	if self:GetMaxLines() < maxLines then
		self:SetMaxLines(maxLines)
	end

	local eb = _G[name.."EditBox"]
	eb:SetAltArrowKeyMode(false)
	eb:ClearAllPoints()
	eb:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 24)
	eb:SetPoint("TOPRIGHT", self, "TOPRIGHT", -15, 54)
	F.CreateBD(eb)
	F.CreateSD(eb)
	F.CreateTex(eb)
	for i = 3, 8 do
		select(i, eb:GetRegions()):SetAlpha(0)
	end

	local lang = _G[name.."EditBoxLanguage"]
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint("TOPLEFT", eb, "TOPRIGHT", 2, 0)
	lang:SetPoint("BOTTOMRIGHT", eb, "BOTTOMRIGHT", 28, 0)
	F.CreateBD(lang)
	F.CreateSD(lang)
	F.CreateTex(lang)




	F.HideObject(self.buttonFrame)
	F.HideObject(self.ScrollBar)
	F.HideObject(self.ScrollToBottomButton)

	self.styled = true
end



local function scrollChat(frame, delta)
	--Faster Scroll
	if IsControlKeyDown()  then
		--Faster scrolling by triggering a few scroll up in a loop
		if ( delta > 0 ) then
			for i = 1,5 do frame:ScrollUp(); end;
		elseif ( delta < 0 ) then
			for i = 1,5 do frame:ScrollDown(); end;
		end
	elseif IsAltKeyDown() then
		--Scroll to the top or bottom
		if ( delta > 0 ) then
			frame:ScrollToTop();
		elseif ( delta < 0 ) then
			frame:ScrollToBottom();
		end
	else
		--Normal Scroll
		if delta > 0 then
			frame:ScrollUp()
		elseif delta < 0 then
			frame:ScrollDown()
		end
	end
end



local function EnableFading(i)
	local chatFrameNumber = ("ChatFrame%d"):format(i);
	local ChatFrameNumberFrame = _G[chatFrameNumber];
	
	ChatFrameNumberFrame:SetFading(true);
	ChatFrameNumberFrame:SetTimeVisible(10);
	ChatFrameNumberFrame:SetFadeDuration(10);
end

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


local function GetColor(className, isLocal)
	if isLocal then
		local found
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == className then className = k found = true break end
		end
		if not found then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == className then className = k break end
			end
		end
	end
	local tbl = C.classcolours[className]
	local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

local changeBNetName = function(misc, id, moreMisc, fakeName, tag, colon)
		local gameAccount = select(6, BNGetFriendInfoByID(id))
		if gameAccount then
			local _, charName, _, _, _, _, _, englishClass = BNGetGameAccountInfo(gameAccount)
			if englishClass and englishClass ~= "" then
				fakeName = "|cFF"..GetColor(englishClass, true)..fakeName.."|r"
			end
	end
	return misc..id..moreMisc..fakeName..tag..(colon == ":" and ":" or colon)
end

local function AddMessage(frame, text, red, green, blue, lineID, addToTop, accessID, extraData)
	local editMessage = true
	for i, v in ipairs(chatEvents) do
		if(event == v) then
			editMessage = false
			break
		end
	end

	if(editMessage) then
		text = text:gsub("%[Guild%]", "g")
		text = text:gsub("%[Party%]", "p")
		text = text:gsub("%[Party Leader%]", "P")
		text = text:gsub("%[Dungeon Guide%]", "P")
		text = text:gsub("%[Raid%]", "r")
		text = text:gsub("%[Raid Leader%]", "RL")
		text = text:gsub("%[Raid Warning%]", "RW")
		text = text:gsub("%[Officer%]", "o")
		text = text:gsub("%[Instance%]", "i")
		text = text:gsub("%[Instance Leader%]", "I")
		text = text:gsub("%[(%d+)%..-%]", "%1")
		text = text:gsub("(|Hplayer.*|h) whispers", "From %1")
		text = text:gsub("To (|Hplayer.*|h)", "To %1")
		text = text:gsub("(|Hplayer.*|h) says:", "%1:")
		text = text:gsub("(|Hplayer.*|h) yells", "%1")
		text = text:gsub("(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)", changeBNetName)
		text = text:gsub("|H(.-)|h%[(.-)%]|h", "|H%1|h%2|h")
	end

	return hooks[frame](frame, text, red, green, blue, lineID, addToTop, accessID, extraData)
end

local Insert = function(self, str, ...)
	if type(str) == "string" then
		str = str:gsub("|H(.-)|h[%[]?(.-)[%]]?|h", "|H%1|h[%2]|h")
	end

	return hooks[self](self, str, ...)
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CURRENCY", function(self, event, message, ...)
	local currencyID, currencyName, currencyAmount = message:match'currency:(%d+)', message:match'|h(.+)|h', message:match' x%d+'
	return false, ("+ |cffffffff|Hcurrency:%d|h%s|h|r%s"):format(currencyID, currencyName, currencyAmount or ""), ...
end)





local function StyleWindow(f)
	local frame = _G[f]
	if frame.reskinned then return end
	frame.reskinned = true

	
	

	-- real ID conversation
	if frame.conversationButton then
		frame.conversationButton:ClearAllPoints()
		frame.conversationButton:SetPoint("TOP")
		frame.conversationButton:SetSize(16, 16)
		frame.conversationButton.SetPoint = F.dummy
		F.Reskin(frame.conversationButton)
		local plus = F.CreateFS(frame.conversationButton)
		plus:SetPoint("CENTER", 1, 0)
		plus:SetText("+")
	end



	hooks[frame] = frame.AddMessage
	frame.AddMessage = AddMessage

	hooks[frame.editBox] = frame.editBox.Insert
	frame.editBox.Insert = Insert

end

for i = 1, NUM_CHAT_WINDOWS do
	StyleWindow(("ChatFrame%d"):format(i))
end

hooksecurefunc("FCF_SetTemporaryWindowType", function(f)
	StyleWindow(f:GetName())
end)



SlashCmdList["TELLTARGET"] = function(s)
	if(UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player")==GetDefaultLanguage("target"))then
		SendChatMessage(s, "WHISPER", nil, UnitName("target"))
	end
end
SLASH_TELLTARGET1 = "/tt"



function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	local chatType = strsub(event, 10);
	if ( strsub(chatType, 1, 7) == "WHISPER" ) then
		chatType = "WHISPER";
	end
	if ( strsub(chatType, 1, 7) == "CHANNEL" ) then
		chatType = "CHANNEL"..arg8;
	end
	local info = ChatTypeInfo[chatType];

	--ambiguate guild chat names
	if (chatType == "GUILD") then
		arg2 = Ambiguate(arg2, "guild")
	else
		arg2 = Ambiguate(arg2, "none")
	end

	if ( info and info.colorNameByClass and arg12 ) then
		local localizedClass, englishClass, localizedRace, englishRace, sex = GetPlayerInfoByGUID(arg12)

		if ( englishClass ) then
			local classColorTable = C.classcolours[englishClass];
			if ( not classColorTable ) then
				return arg2;
			end
			return string.format("\124cff%.2x%.2x%.2x", classColorTable.r*255, classColorTable.g*255, classColorTable.b*255)..arg2.."\124r"
		end
	end

	return arg2;
end


-- Colour real ID links

local function GetLinkColor(data)
	local type, id, arg1 = string.match(data, '(%w+):(%d+)')
	if(type == 'item') then
		local _, _, quality = GetItemInfo(id)
		if(quality) then
			local _, _, _, hex = GetItemQualityColor(quality)
			return '|c' .. hex
		else
			-- Item is not cached yet, show a white color instead
			-- Would like to fix this somehow
			return '|cffffffff'
		end
	elseif(type == 'quest') then
		local _, _, level = string.match(data, '(%w+):(%d+):(%d+)')
		if not level then level = UnitLevel("player") end -- fix for account wide quests
		local color = GetQuestDifficultyColor(level)
		return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
	elseif(type == 'spell') then
		return '|cff71d5ff'
	elseif(type == 'achievement') then
		return '|cffffff00'
	elseif(type == 'trade' or type == 'enchant') then
		return '|cffffd000'
	elseif(type == 'instancelock') then
		return '|cffff8000'
	elseif(type == 'glyph' or type == 'journal') then
		return '|cff66bbff'
	elseif(type == 'talent') then
		return '|cff4e96f7'
	elseif(type == 'levelup') then
		return '|cffFF4E00'
	else
		return '|cffffffff'
	end
end

local function AddLinkColors(self, event, msg, ...)
	local data = string.match(msg, '|H(.-)|h(.-)|h')
	if(data) then
		local newmsg = string.gsub(msg, '|H(.-)|h(.-)|h', GetLinkColor(data) .. '|H%1|h%2|h|r')
		return false, newmsg, ...
	else
		return false, msg, ...
	end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER', AddLinkColors)
ChatFrame_AddMessageEventFilter('CHAT_MSG_BN_WHISPER_INFORM', AddLinkColors)




-- CHAT DROPDOWN MENU
-- special thanks to Tekkub for tekPlayerMenu

StaticPopupDialogs["COPYNAME"] = {
	text = "COPY NAME",
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

local function insertbefore(t, before, val)
	for k,v in ipairs(t) do if v == before then return table.insert(t, k, val) end end
	table.insert(t, val)
end

local clickers = {["COPYNAME"] = function(a1) Chat_DoCopyName(a1) end, ["WHO"] = SendWho, ["GUILD_INVITE"] = GuildInvite}

UnitPopupButtons["COPYNAME"] = {text = "Copy Name", dist = 0}
UnitPopupButtons["GUILD_INVITE"] = {text = "Guild Invite", dist = 0}
UnitPopupButtons["WHO"] = {text = "Who", dist = 0}

insertbefore(UnitPopupMenus["FRIEND"], "GUILD_PROMOTE", "GUILD_INVITE")
insertbefore(UnitPopupMenus["FRIEND"], "IGNORE", "COPYNAME")
insertbefore(UnitPopupMenus["FRIEND"], "IGNORE", "WHO")

hooksecurefunc("UnitPopup_HideButtons", function()
	local dropdownMenu = UIDROPDOWNMENU_INIT_MENU
	for i,v in pairs(UnitPopupMenus[dropdownMenu.which]) do
		if v == "GUILD_INVITE" then UnitPopupShown[i] = (not CanGuildInvite() or dropdownMenu.name == UnitName("player")) and 0 or 1
		elseif clickers[v] then UnitPopupShown[i] = (dropdownMenu.name == UnitName("player") and 0) or 1 end
	end
end)

hooksecurefunc("UnitPopup_OnClick", function(self)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
	local button = self.value
	if clickers[button] then clickers[button](dropdownFrame.name) end
	PlaySound("1115")
end)

function Chat_DoCopyName(name)
	local dialog = StaticPopup_Show("COPYNAME")
	local editbox = _G[dialog:GetName().."EditBox"]
	editbox:SetText(name or "")
	editbox:SetFocus()
	editbox:HighlightText()
	local button = _G[dialog:GetName().."Button2"]
	button:ClearAllPoints()
	button:SetPoint("CENTER", editbox, "CENTER", 0, -30)
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

	hooksecurefunc("FCFTab_UpdateColors", function(self, selected)
		if selected then
			self:GetFontString():SetTextColor(1, .8, 0)
		else
			self:GetFontString():SetTextColor(.5, .5, .5)
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
		--ChatTypeInfo["WHISPER"].sticky = 1
		--ChatTypeInfo["BN_WHISPER"].sticky = 1

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

	-- Add Elements
	self:ChatFilter()



	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end

	SetCVar("profanityFilter", 0)


	ACHIEVEMENT_BROADCAST = "%s achieved %s!"

	BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has gone |cffff0000offline|r."
	BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has come |cff00ff00online|r."

	CHAT_BN_WHISPER_GET = "From %s:\32"
	CHAT_BN_WHISPER_INFORM_GET = "To %s:\32"

	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "

	CHAT_YOU_CHANGED_NOTICE = "|Hchannel:%d|h[%s]|h"

	ERR_FRIEND_OFFLINE_S = "%s has gone |cffff0000offline|r."
	ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h has come |cff00ff00online|r."

	ERR_SKILL_UP_SI = "|cffffffff%s|r |cff00adf0%d|r"

	FACTION_STANDING_DECREASED = "%s -%d"
	FACTION_STANDING_INCREASED = "%s +%d"
	FACTION_STANDING_INCREASED_ACH_BONUS = "%s +%d (+%.1f)"
	FACTION_STANDING_INCREASED_ACH_PART = "(+%.1f)"
	FACTION_STANDING_INCREASED_BONUS = "%s + %d (+%.1f RAF)"
	FACTION_STANDING_INCREASED_DOUBLE_BONUS = "%s +%d (+%.1f RAF) (+%.1f)"
	FACTION_STANDING_INCREASED_REFER_PART = "(+%.1f RAF)"
	FACTION_STANDING_INCREASED_REST_PART = "(+%.1f Rested)"

	ERR_AUCTION_SOLD_S = "|cff1eff00%s|r |cffffffffsold.|r"



	DEFAULT_CHATFRAME_ALPHA = 0
	CHAT_FRAME_FADE_OUT_TIME = CHAT_FRAME_FADE_TIME
	CHAT_TAB_HIDE_DELAY = CHAT_TAB_SHOW_DELAY

	local function HideForever(f)
		f:SetScript("OnShow", f.Hide)
		f:Hide()
	end

	HideForever(ChatFrameMenuButton)
	HideForever(QuickJoinToastButton)
	HideForever(GeneralDockManagerOverflowButton)

	ForceChatSettings()

	
end