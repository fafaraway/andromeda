--[[
-- Credits: Vika, Cladhaire, Tekkub
]]

local parent, ns = ...
local oUF = ns.oUF

local _PATTERN = '%[..-%]+'

local _ENV = {
	Hex = function(r, g, b)
		if type(r) == "table" then
			if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
	end,
	ColorGradient = oUF.ColorGradient,
}
local _PROXY = setmetatable(_ENV, {__index = _G})

local tagStrings = {
	["dead"] = [[function(u)
		if(UnitIsDead(u)) then
			return 'Dead'
		elseif(UnitIsGhost(u)) then
			return 'Ghost'
		end
	end]],

	["missinghp"] = [[function(u)
		local current = UnitHealthMax(u) - UnitHealth(u)
		if(current > 0) then
			return current
		end
	end]],

	["missingpp"] = [[function(u)
		local current = UnitPowerMax(u) - UnitPower(u)
		if(current > 0) then
			return current
		end
	end]],

	["name"] = [[function(u, r)
		return UnitName(r or u)
	end]],

	["offline"] = [[function(u)
		if(not UnitIsConnected(u)) then
			return 'Offline'
		end
	end]],
}

local tags = setmetatable(
	{
		curhp = UnitHealth,
		curpp = UnitPower,
		maxhp = UnitHealthMax,
		maxpp = UnitPowerMax,
		class = UnitClass,
		faction = UnitFactionGroup,
		race = UnitRace,
	},

	{
		__index = function(self, key)
			local tagFunc = tagStrings[key]
			if(tagFunc) then
				local func, err = loadstring('return ' .. tagFunc)
				if(func) then
					func = func()

					-- Want to trigger __newindex, so no rawset.
					self[key] = func
					tagStrings[key] = nil

					return func
				else
					error(err, 3)
				end
			end
		end,
		__newindex = function(self, key, val)
			if(type(val) == 'string') then
				tagStrings[key] = val
			elseif(type(val) == 'function') then
				-- So we don't clash with any custom envs.
				if(getfenv(val) == _G) then
					setfenv(val, _PROXY)
				end

				rawset(self, key, val)
			end
		end,
	}
)

_ENV._TAGS = tags

local tagEvents = {
	["dead"]                = "UNIT_HEALTH",
	["missinghp"]           = "UNIT_HEALTH UNIT_MAXHEALTH",
	["name"]                = "UNIT_NAME_UPDATE",
	["missingpp"]           = 'UNIT_MAXPOWER UNIT_POWER',
	["offline"]             = "UNIT_HEALTH UNIT_CONNECTION",
}

local unitlessEvents = {
	PLAYER_LEVEL_UP = true,
	PLAYER_UPDATE_RESTING = true,
	PLAYER_TARGET_CHANGED = true,

	PARTY_LEADER_CHANGED = true,

	RAID_ROSTER_UPDATE = true,

	UNIT_COMBO_POINTS = true
}

local events = {}
local frame = CreateFrame"Frame"
frame:SetScript('OnEvent', function(self, event, unit)
	local strings = events[event]
	if(strings) then
		for k, fontstring in next, strings do
			if(fontstring:IsVisible() and (unitlessEvents[event] or fontstring.parent.unit == unit)) then
				fontstring:UpdateTag()
			end
		end
	end
end)

local OnUpdates = {}
local eventlessUnits = {}

local createOnUpdate = function(timer)
	local OnUpdate = OnUpdates[timer]

	if(not OnUpdate) then
		local total = timer
		local frame = CreateFrame'Frame'
		local strings = eventlessUnits[timer]

		frame:SetScript('OnUpdate', function(self, elapsed)
			if(total >= timer) then
				for k, fs in next, strings do
					if(fs.parent:IsShown() and UnitExists(fs.parent.unit)) then
						fs:UpdateTag()
					end
				end

				total = 0
			end

			total = total + elapsed
		end)

		OnUpdates[timer] = frame
	end
end

local OnShow = function(self)
	for _, fs in next, self.__tags do
		fs:UpdateTag()
	end
end

local getTagName = function(tag)
	local s = (tag:match('>+()') or 2)
	local e = tag:match('.*()<+')
	e = (e and e - 1) or -2

	return tag:sub(s, e), s, e
end

local RegisterEvent = function(fontstr, event)
	if(not events[event]) then events[event] = {} end

	frame:RegisterEvent(event)
	table.insert(events[event], fontstr)
end

local RegisterEvents = function(fontstr, tagstr)
	for tag in tagstr:gmatch(_PATTERN) do
		tag = getTagName(tag)
		local tagevents = tagEvents[tag]
		if(tagevents) then
			for event in tagevents:gmatch'%S+' do
				RegisterEvent(fontstr, event)
			end
		end
	end
end

local UnregisterEvents = function(fontstr)
	for event, data in pairs(events) do
		for k, tagfsstr in pairs(data) do
			if(tagfsstr == fontstr) then
				if(#data == 1) then
					frame:UnregisterEvent(event)
				end

				table.remove(data, k)
			end
		end
	end
end

local tagPool = {}
local funcPool = {}
local tmp = {}

local Tag = function(self, fs, tagstr)
	if(not fs or not tagstr) then return end

	if(not self.__tags) then
		self.__tags = {}
		table.insert(self.__elements, OnShow)
	else
		-- Since people ignore everything that's good practice - unregister the tag
		-- if it already exists.
		for _, tag in pairs(self.__tags) do
			if(fs == tag) then
				-- We don't need to remove it from the __tags table as Untag handles
				-- that for us.
				self:Untag(fs)
			end
		end
	end

	fs.parent = self

	local func = tagPool[tagstr]
	if(not func) then
		local format, numTags = tagstr:gsub('%%', '%%%%'):gsub(_PATTERN, '%%s')
		local args = {}

		for bracket in tagstr:gmatch(_PATTERN) do
			local tagFunc = funcPool[bracket] or tags[bracket:sub(2, -2)]
			if(not tagFunc) then
				local tagName, s, e = getTagName(bracket)

				local tag = tags[tagName]
				if(tag) then
					s = s - 2
					e = e + 2

					if(s ~= 0 and e ~= 0) then
						local pre = bracket:sub(2, s)
						local ap = bracket:sub(e, -2)

						tagFunc = function(u,r)
							local str = tag(u,r)
							if(str) then
								return pre..str..ap
							end
						end
					elseif(s ~= 0) then
						local pre = bracket:sub(2, s)

						tagFunc = function(u,r)
							local str = tag(u,r)
							if(str) then
								return pre..str
							end
						end
					elseif(e ~= 0) then
						local ap = bracket:sub(e, -2)

						tagFunc = function(u,r)
							local str = tag(u,r)
							if(str) then
								return str..ap
							end
						end
					end

					funcPool[bracket] = tagFunc
				end
			end

			if(tagFunc) then
				table.insert(args, tagFunc)
			else
				return error(('Attempted to use invalid tag %s.'):format(bracket), 3)
			end
		end

		if(numTags == 1) then
			func = function(self)
				local parent = self.parent
				local realUnit
				if(self.overrideUnit) then
					realUnit = parent.realUnit
				end

				_ENV._COLORS = parent.colors
				return self:SetFormattedText(
					format,
					args[1](parent.unit, realUnit) or ''
				)
			end
		elseif(numTags == 2) then
			func = function(self)
				local parent = self.parent
				local unit = parent.unit
				local realUnit
				if(self.overrideUnit) then
					realUnit = parent.realUnit
				end

				_ENV._COLORS = parent.colors
				return self:SetFormattedText(
					format,
					args[1](unit, realUnit) or '',
					args[2](unit, realUnit) or ''
				)
			end
		elseif(numTags == 3) then
			func = function(self)
				local parent = self.parent
				local unit = parent.unit
				local realUnit
				if(self.overrideUnit) then
					realUnit = parent.realUnit
				end

				_ENV._COLORS = parent.colors
				return self:SetFormattedText(
					format,
					args[1](unit, realUnit) or '',
					args[2](unit, realUnit) or '',
					args[3](unit, realUnit) or ''
				)
			end
		else
			func = function(self)
				local parent = self.parent
				local unit = parent.unit
				local realUnit
				if(self.overrideUnit) then
					realUnit = parent.realUnit
				end

				_ENV._COLORS = parent.colors
				for i, func in next, args do
					tmp[i] = func(unit, realUnit) or ''
				end

				-- We do 1, numTags because tmp can hold several unneeded variables.
				return self:SetFormattedText(format, unpack(tmp, 1, numTags))
			end
		end

		tagPool[tagstr] = func
	end
	fs.UpdateTag = func

	local unit = self.unit
	if((unit and unit:match'%w+target') or fs.frequentUpdates) then
		local timer
		if(type(fs.frequentUpdates) == 'number') then
			timer = fs.frequentUpdates
		else
			timer = .5
		end

		if(not eventlessUnits[timer]) then eventlessUnits[timer] = {} end
		table.insert(eventlessUnits[timer], fs)

		createOnUpdate(timer)
	else
		RegisterEvents(fs, tagstr)
	end

	table.insert(self.__tags, fs)
end

local Untag = function(self, fs)
	if(not fs) then return end

	UnregisterEvents(fs)
	for _, timers in next, eventlessUnits do
		for k, fontstr in next, timers do
			if(fs == fontstr) then
				table.remove(timers, k)
			end
		end
	end

	for k, fontstr in next, self.__tags do
		if(fontstr == fs) then
			table.remove(self.__tags, k)
		end
	end

	fs.UpdateTag = nil
end

oUF.Tags = {
	Methods = tags,
	Events = tagEvents,
	SharedEvents = unitlessEvents,

}
oUF:RegisterMetaFunction('Tag', Tag)
oUF:RegisterMetaFunction('Untag', Untag)