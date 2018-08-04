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
	F.CreateBD(eb, .5)
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





SlashCmdList["TELLTARGET"] = function(s)
	if(UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player")==GetDefaultLanguage("target"))then
		SendChatMessage(s, "WHISPER", nil, UnitName("target"))
	end
end
SLASH_TELLTARGET1 = "/tt"


--[[local function GetColor(className, isLocal)
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
end]]

local AddMessage = function(frame, text, ...)
	if type(text) == "string" then

		--local chatNum = string.match(text,"%d+") or ""
		--if not tonumber(chatNum) then chatNum = "" else chatNum = chatNum..":" end
		text = gsub(text, "%[%d+%. General.-%]", "GN")
		text = gsub(text, "%[%d+%. Trade.-%]", "TR")
		text = gsub(text, "%[%d+%. WorldDefense%]", "WD")
		text = gsub(text, "%[%d+%. LocalDefense.-%]", "LD")
		text = gsub(text, "%[%d+%. LookingForGroup%]", "LFG")
		text = gsub(text, "%[%d+%. GuildRecruitment.-%]", "GR")

		text = gsub(text, "%[(%d+)%. 大脚世界频道%]", "世界")
		text = gsub(text, "%[(%d+)%. 大腳世界頻道%]", "世界")

		--[[text = text:gsub("%[Guild%]", "g")
		text = text:gsub("%[Party%]", "p")
		text = text:gsub("%[Party Leader%]", "P")
		text = text:gsub("%[Dungeon Guide%]", "P")
		text = text:gsub("%[Raid%]", "r")
		text = text:gsub("%[Raid Leader%]", "RL")
		text = text:gsub("%[Raid Warning%]", "RW")
		text = text:gsub("%[Officer%]", "o")
		text = text:gsub("%[Instance%]", "i")
		text = text:gsub("%[Instance Leader%]", "IL")
		text = text:gsub("%[(%d+)%..-%]", "%1")
		text = text:gsub("(|Hplayer.*|h) whispers", "From %1")
		text = text:gsub("To (|Hplayer.*|h)", "To %1")

		text = text:gsub("(|Hplayer.*|h) says:", "%1:")
		text = text:gsub("(|Hplayer.*|h) yells", "%1")
		--text = text:gsub("(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)", changeBNetName)]]
		text = text:gsub("|H(.-)|h%[(.-)%]|h", "|H%1|h%2|h")

	end
	msgHooks[frame:GetName()].AddMessage(frame, text, ...)
end

local Insert = function(self, str, ...)
	if type(str) == "string" then
		str = str:gsub("|H(.-)|h[%[]?(.-)[%]]?|h", "|H%1|h[%2]|h")
	end

	return msgHooks[self](self, str, ...)
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CURRENCY", function(self, event, message, ...)
	local currencyID, currencyName, currencyAmount = message:match'currency:(%d+)', message:match'|h(.+)|h', message:match' x%d+'
	return false, ("+ |cffffffff|Hcurrency:%d|h%s|h|r%s"):format(currencyID, currencyName, currencyAmount or ""), ...
end)





function module:OnLogin()
	for i = 1, NUM_CHAT_WINDOWS do
		skinChat(_G["ChatFrame"..i])

		local n = ("ChatFrame%d"):format(i)
		local f = _G[n]

		if f ~= COMBATLOG and not msgHooks[n] then
			msgHooks[n] = {}
			msgHooks[n].AddMessage = f.AddMessage
			f.AddMessage = AddMessage
		end
	end

	hooksecurefunc("FCF_OpenTemporaryWindow", function()
		for _, chatFrameName in next, CHAT_FRAMES do
			local frame = _G[chatFrameName]
			if frame.isTemporary then
				skinChat(frame)
			end
		end
	end)

	--[[hooksecurefunc("FCFTab_UpdateColors", function(self, selected)
		if selected then
			self:GetFontString():SetTextColor(1, .8, 0)
		else
			self:GetFontString():SetTextColor(.5, .5, .5)
		end
	end)]]

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


	ACHIEVEMENT_BROADCAST = "%s achieved %s!"

	BN_INLINE_TOAST_FRIEND_OFFLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has gone |cffff0000offline|r."
	BN_INLINE_TOAST_FRIEND_ONLINE = "\124TInterface\\FriendsFrame\\UI-Toast-ToastIcons.tga:16:16:0:0:128:64:2:29:34:61\124t%s has come |cff00ff00online|r."

	CHAT_BN_WHISPER_GET = "From %s:\32"
	CHAT_BN_WHISPER_INFORM_GET = "To %s:\32"

	CHAT_FLAG_AFK = "[AFK] "
	CHAT_FLAG_DND = "[DND] "
	CHAT_FLAG_GM = "[GM] "

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

	CHAT_WHISPER_GET = "from %s: "
	CHAT_WHISPER_INFORM_GET = "to %s: "
	CHAT_BN_WHISPER_INFORM_GET = "to %s: "
	CHAT_BN_WHISPER_GET = "from %s: "

	CHAT_YELL_GET = "|Hchannel:Yell|h%s: "
	CHAT_SAY_GET = "|Hchannel:Say|h%s: "

	CHAT_BATTLEGROUND_GET			= "|Hchannel:Battleground|h[BG]|h %s: "
	CHAT_BATTLEGROUND_LEADER_GET 	= [[|Hchannel:Battleground|h[BG|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]]
	CHAT_GUILD_GET   				= "|Hchannel:Guild|h[G]|h %s: "
	CHAT_OFFICER_GET 				= "|Hchannel:Officer|h[O]|h %s: "
	CHAT_PARTY_GET        			= "|Hchannel:Party|h[P]|h %s: "
	CHAT_PARTY_LEADER_GET 			= [[|Hchannel:Party|h[P|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]]
	CHAT_PARTY_GUIDE_GET  			= CHAT_PARTY_LEADER_GET
	CHAT_RAID_GET         			= "|Hchannel:Raid|h[R]|h %s: "
	CHAT_RAID_LEADER_GET  			= [[|Hchannel:Raid|h[R|TInterface\GroupFrame\UI-Group-LeaderIcon:0|t]|h %s: ]]
	CHAT_RAID_WARNING_GET 			= [[|Hchannel:RaidWarning|h[RW|TInterface\GroupFrame\UI-GROUP-MAINASSISTICON:0|t]|h %s: ]]
	
	CHAT_MONSTER_PARTY_GET   		= CHAT_PARTY_GET
	CHAT_MONSTER_SAY_GET     		= CHAT_SAY_GET
	CHAT_MONSTER_WHISPER_GET 		= CHAT_WHISPER_GET
	CHAT_MONSTER_YELL_GET = CHAT_YELL_GET



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

	-- ProfanityFilter
	if not BNFeaturesEnabledAndConnected() then return end

	SetCVar("profanityFilter", 0)

	
end