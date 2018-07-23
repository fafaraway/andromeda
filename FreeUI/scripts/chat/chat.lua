local F, C, L = unpack(select(2, ...))

local _G = _G

local chatFont = {
	C.font.chat,
	14,
	"OUTLINE"
}


DEFAULT_CHATFRAME_ALPHA = 0
CHAT_FRAME_FADE_OUT_TIME = CHAT_FRAME_FADE_TIME -- speed up fading out
CHAT_TAB_HIDE_DELAY = CHAT_TAB_SHOW_DELAY -- ditto

for i = 1, 23 do
	CHAT_FONT_HEIGHTS[i] = i+7
end

local hooks = {}
local chatEvents = {
	"CHAT_MSG_CHANNEL_JOIN",
	"CHAT_MSG_CHANNEL_LEAVE",
	"CHAT_MSG_CHANNEL_NOTICE",
	"CHAT_MSG_CHANNEL_NOTICE_USER",
	"CHAT_MSG_CHANNEL_LIST"
}

local function HideForever(f)
	f:SetScript("OnShow", f.Hide)
	f:Hide()
end

HideForever(ChatFrameMenuButton)
HideForever(QuickJoinToastButton)
HideForever(GeneralDockManagerOverflowButton)

local function skinChat(self)
	if not self or (self and self.styled) then return end






	HideForever(self.buttonFrame)
	HideForever(self.ScrollBar)
	HideForever(self.ScrollToBottomButton)

	self.styled = true
end

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


local eFrame = CreateFrame("frame","ChatEvent_Frame",UIParent)
eFrame:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

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

function eFrame:PLAYER_LOGIN()
	--turn off profanity filter
	SetCVar("profanityFilter", 0)

	--sticky channels
	-- for k, v in pairs(StickyTypeChannels) do
	--   ChatTypeInfo[k].sticky = v;
	-- end

	--toggle class colors
	for i,v in pairs(CHAT_CONFIG_CHAT_LEFT) do
		ToggleChatColorNamesByClassGroup(true, v.type)
	end

	--this is to toggle class colors for all the global channels that is not listed under CHAT_CONFIG_CHAT_LEFT
	for iCh = 1, 15 do
		ToggleChatColorNamesByClassGroup(true, "CHANNEL"..iCh)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local n = ("ChatFrame%d"):format(i)
		local f = _G[n]

		if f then

			--add font shadows
			local font, size = f:GetFont()
			f:SetFont(chatFont[1], size, chatFont[3])
			-- f:SetShadowColor(0, 0, 0, 0)

			--few changes
			f:EnableMouseWheel(true)
			f:SetScript('OnMouseWheel', scrollChat)
			f:SetClampRectInsets(0,0,0,0)

		end
	end

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
end

local function EnableFading(i)
	local chatFrameNumber = ("ChatFrame%d"):format(i);
	local ChatFrameNumberFrame = _G[chatFrameNumber];
	
	ChatFrameNumberFrame:SetFading(true);
	ChatFrameNumberFrame:SetTimeVisible(10);
	ChatFrameNumberFrame:SetFadeDuration(10);
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

--[[local function toggleDown(f)
	-- if f:GetCurrentScroll()> 0 then
	-- 	_G[f:GetName().."ButtonFrameBottomButton"]:Show()
	-- else
	_G[f:GetName().."ButtonFrameBottomButton"]:Hide()
	-- end
end]]

local function reskinMinimize(f)
	f:SetSize(16, 16)
	F.Reskin(f)
	local minus = F.CreateFS(f)
	minus:SetPoint("CENTER", 1, 0)
	minus:SetText("-")
end

local function StyleWindow(f)
	local frame = _G[f]
	if frame.reskinned then return end
	frame.reskinned = true

	--local down = _G[f.."ButtonFrameBottomButton"]
	--down:SetPoint("BOTTOM")
	--down:Hide()

	--HideForever(_G[f.."ButtonFrameUpButton"])
	--HideForever(_G[f.."ButtonFrameDownButton"])

	--frame:HookScript("OnMessageScrollChanged", toggleDown)
	--frame:HookScript("OnShow", toggleDown)

	frame:SetFading(false)

	-- frame:SetFont(chatFont, 14, "OUTLINE")
	-- frame:SetShadowOffset(0, 0, 0, 0)

	frame:SetMinResize(0,0)
	frame:SetMaxResize(0,0)

	frame.editBox:ClearAllPoints()
	frame.editBox:SetPoint("BOTTOMLEFT",  _G.ChatFrame1, "TOPLEFT", -5, 18)
	frame.editBox:SetPoint("BOTTOMRIGHT", _G.ChatFrame1, "TOPRIGHT", 5, 18)
	frame.editBox:SetFont(unpack(chatFont))
	frame.editBox.header:SetFont(unpack(chatFont))
	frame.editBox.header:SetShadowColor(0, 0, 0, 0)
	frame.editBox:SetShadowColor(0, 0, 0, 0)

	frame.editBox:SetAltArrowKeyMode(false)

	_G[f.."EditBoxFocusLeft"]:SetAlpha(0)
 	_G[f.."EditBoxFocusRight"]:SetAlpha(0)
 	_G[f.."EditBoxFocusMid"]:SetAlpha(0)

	local ebg = CreateFrame("Frame", nil, frame.editBox)
	ebg:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	ebg:SetBackdropColor(0, 0, 0, .4)
	ebg:SetPoint("TOPLEFT", frame.editBox, 4, -4)
	ebg:SetPoint("BOTTOMRIGHT", frame.editBox, -4, 4)
	ebg:SetFrameStrata("BACKGROUND")
	ebg:SetFrameLevel(0)
	frame.editBox.ebg = ebg

	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[f..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	--Hide the new editbox "ghost"
	_G[f.."EditBoxLeft"]:SetAlpha(0)
	_G[f.."EditBoxRight"]:SetAlpha(0)
	_G[f.."EditBoxMid"]:SetAlpha(0)

	frame:SetClampRectInsets(0, 0, 0, 0)

	local name = frame:GetName()

	local lang = _G[name.."EditBoxLanguage"]
	lang:GetRegions():SetAlpha(0)
	lang:SetPoint("TOPLEFT", frame.editBox, "TOPRIGHT", -2, 0)
	lang:SetPoint("BOTTOMRIGHT", frame.editBox, "BOTTOMRIGHT", 28, 0)
	F.CreateBD(lang)
	

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

	-- minimize button
	reskinMinimize(frame.buttonFrame.minimizeButton)

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

-- From Tukui
hooksecurefunc("ChatEdit_UpdateHeader", function()
	local editBox = ChatEdit_ChooseBoxForSend()
	local mType = editBox:GetAttribute("chatType")
	if mType == "CHANNEL" then
		local id = GetChannelName(editBox:GetAttribute("channelTarget"))
		if id == 0 then
			editBox.ebg:SetBackdropBorderColor(0, 0, 0)
		else
			editBox.ebg:SetBackdropBorderColor(ChatTypeInfo[mType..id].r,ChatTypeInfo[mType..id].g,ChatTypeInfo[mType..id].b)
		end
	elseif mType == "SAY" then
		editBox.ebg:SetBackdropBorderColor(0, 0, 0)
	else
		editBox.ebg:SetBackdropBorderColor(ChatTypeInfo[mType].r,ChatTypeInfo[mType].g,ChatTypeInfo[mType].b)
	end
end)

BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -1, 56)
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

if IsLoggedIn() then eFrame:PLAYER_LOGIN() else eFrame:RegisterEvent("PLAYER_LOGIN") end
