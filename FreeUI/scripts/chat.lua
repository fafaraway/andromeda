local F, C, L = unpack(select(2, ...))

local _G = _G

DEFAULT_CHATFRAME_ALPHA = 0
CHAT_FRAME_FADE_OUT_TIME = CHAT_FRAME_FADE_TIME -- speed up fading out
CHAT_TAB_HIDE_DELAY = CHAT_TAB_SHOW_DELAY -- ditto

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
HideForever(FriendsMicroButton)
HideForever(GeneralDockManagerOverflowButton)

ChatTypeInfo.SAY.sticky = 1
ChatTypeInfo.EMOTE.sticky = 1
ChatTypeInfo.YELL.sticky = 1
ChatTypeInfo.PARTY.sticky = 1
ChatTypeInfo.GUILD.sticky = 1
ChatTypeInfo.OFFICER.sticky = 1
ChatTypeInfo.RAID.sticky = 1
ChatTypeInfo.RAID_WARNING.sticky = 1
ChatTypeInfo.BATTLEGROUND.sticky = 1
ChatTypeInfo.WHISPER.sticky = 1
ChatTypeInfo.BN_WHISPER.sticky = 1
ChatTypeInfo.CHANNEL.sticky = 1

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
	local _, charName, _, _, _, _, _, englishClass = BNGetToonInfo(id)
	if englishClass ~= "" then
		fakeName = "|cFF"..GetColor(englishClass, true)..fakeName.."|r"
	end
	return misc..id..moreMisc..fakeName..tag..(colon == ":" and ":" or colon)
end

local function AddMessage(frame, text, r, g, b, id)
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
		text = text:gsub("%[Battleground%]", "bg")
		text = text:gsub("%[Battleground Leader%]", "BG")
		text = text:gsub("%[(%d+)%..-%]", "%1")
		text = text:gsub("(|Hplayer.*|h) whispers", "From %1")
		text = text:gsub("To (|Hplayer.*|h)", "To %1")
		text = text:gsub("(|Hplayer.*|h) says", "%1")
		text = text:gsub("(|Hplayer.*|h) yells", "%1")
		text = text:gsub("(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)", changeBNetName)
		text = text:gsub("|H(.-)|h%[(.-)%]|h", "|H%1|h%2|h")
	end

	return hooks[frame](frame, text, r, g, b, id)
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

local function toggleDown(f)
	if f:GetCurrentScroll() > 0 then
		_G[f:GetName().."ButtonFrameBottomButton"]:Show()
	else
		_G[f:GetName().."ButtonFrameBottomButton"]:Hide()
	end
end

local function reskinMinimize(f)
	f:SetSize(16, 16)
	F.Reskin(f)
	local minus = F.CreateFS(f, 8)
	minus:SetPoint("CENTER", 1, 0)
	minus:SetText("-")
end

local function StyleWindow(f)
	local frame = _G[f]
	if frame.reskinned then return end
	frame.reskinned = true

	local down = _G[f.."ButtonFrameBottomButton"]

	down:SetPoint("BOTTOM")
	down:Hide()
	HideForever(_G[f.."ButtonFrameUpButton"])
	HideForever(_G[f.."ButtonFrameDownButton"])

	frame:HookScript("OnMessageScrollChanged", toggleDown)
	frame:HookScript("OnShow", toggleDown)

	frame:SetFading(false)

	frame:SetFont(C.media.font2, 13, "THINOUTLINE")
	frame:SetShadowOffset(0, 0, 0, 0)

	frame:SetMinResize(0,0)
	frame:SetMaxResize(0,0)

	frame.editBox:ClearAllPoints()
	frame.editBox:SetPoint("BOTTOMLEFT",  _G.ChatFrame1, "TOPLEFT", -5, 18)
	frame.editBox:SetPoint("BOTTOMRIGHT", _G.ChatFrame1, "TOPRIGHT", 5, 18)
	frame.editBox:SetFont(C.media.font2, 13, "THINOUTLINE")
	frame.editBox.header:SetFont(C.media.font2, 13, "THINOUTLINE")
	frame.editBox.header:SetShadowColor(0, 0, 0, 0)
	frame.editBox:SetShadowColor(0, 0, 0, 0)

	frame.editBox:SetAltArrowKeyMode(nil)

	local x=({_G[f.."EditBox"]:GetRegions()})
	x[9]:SetAlpha(0)
	x[10]:SetAlpha(0)
	x[11]:SetAlpha(0)

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

	-- real ID conversation
	if frame.conversationButton then
		frame.conversationButton:ClearAllPoints()
		frame.conversationButton:SetPoint("TOP")
		frame.conversationButton:SetSize(16, 16)
		frame.conversationButton.SetPoint = F.dummy
		F.Reskin(frame.conversationButton)
		local plus = F.CreateFS(frame.conversationButton, 8)
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
		editBox.ebg:SetBackdropBorderColor(ChatTypeInfo[mType..id].r,ChatTypeInfo[mType..id].g,ChatTypeInfo[mType..id].b)
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

	if ( info and info.colorNameByClass and arg12 ~= "" ) then
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

--Copy when you shift click tab
local lines = {}

local frame = CreateFrame("Frame", "BCMCopyFrame", UIParent)
frame:SetWidth(ChatFrame1:GetWidth() + 35)
frame:SetHeight(350)
frame:SetPoint("LEFT", UIParent, "LEFT", 50, 0)
frame:SetFrameStrata("DIALOG")
frame:Hide()

F.CreateBD(frame)

local editBox = CreateFrame("EditBox", "BCMCopyBox", frame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(20000)
editBox:EnableMouse(true)
editBox:SetAutoFocus(true)
editBox:SetFont(C.media.font2, 13, "THINOUTLINE")
editBox:SetWidth(ChatFrame1:GetWidth())
editBox:SetScript("OnEscapePressed", function() frame:Hide() wipe(lines) end)

local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", frame, "UIPanelScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)
scrollArea:SetScrollChild(editBox)

local function GetLines(...)
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if(region:GetObjectType()=="FontString") then
			lines[ct] = gsub(tostring(region:GetText()), "\124T.-\124t", "")
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	frame:Show()
	editBox:SetText(text)
end

ChatFrame1Tab:HookScript("OnClick", function()
	if(IsShiftKeyDown()) then
		Copy(ChatFrame1)
	end
end)

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