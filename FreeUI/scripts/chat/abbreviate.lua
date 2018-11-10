local F, C, L = unpack(select(2, ...))
local module = F:GetModule('chat')


local gsub, match, format = string.gsub, string.match, string.format
local hooks = {}

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
	local tbl = C.classColors[className]
	local color = ('%02x%02x%02x'):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

local function FormatBNPlayer(misc, id, moreMisc, fakeName, tag, colon)
		local gameAccount = select(6, BNGetFriendInfoByID(id))
		if gameAccount then
			local _, charName, _, _, _, _, _, englishClass = BNGetGameAccountInfo(gameAccount)
			if englishClass and englishClass ~= '' then
				fakeName = '|cFF'..GetColor(englishClass, true)..fakeName..'|r'
			end
	end
	return misc..id..moreMisc..fakeName..tag..(colon == ':' and ':' or colon)
end

local function FormatPlayer(info, name)
	return format('|Hplayer:%s|h%s|h', info, gsub(name, '%-[^|]+', ''))
end



local function AddMessage(self, message, ...)
	message = gsub(message, '%[(%d+)%. 大脚世界频道%]', '世界')
	message = gsub(message, '%[(%d+)%. 大腳世界頻道%]', '世界')
	message = gsub(message, '%[(%d+)%. BigfootWorldChannel%]', 'world')

	-- shorten channel
	message = gsub(message, '|h%[(%d+)%. .-%]|h', '|h%1.|h')

	message = gsub(message, '|Hplayer:(.-)|h%[(.-)%]|h', FormatPlayer)
	message = gsub(message, '(|HBNplayer:%S-|k:)(%d-)(:%S-|h)%[(%S-)%](|?h?)(:?)', FormatBNPlayer)

	-- remove brackets from item and spell links
	--message = gsub(message, '|r|h:(.+)|cff(.+)|H(.+)|h%[(.+)%]|h|r', '|r|h:%1%4')

	return hooks[self](self, message, ...)
end

function module:ChatAbbreviate()
	for index = 1, NUM_CHAT_WINDOWS do
		if(index ~= 2) then
			local ChatFrame = _G['ChatFrame' .. index]
			hooks[ChatFrame] = ChatFrame.AddMessage
			ChatFrame.AddMessage = AddMessage
		end
	end
end





