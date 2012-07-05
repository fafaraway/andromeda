local F, C, L = unpack(select(2, ...))

--[[
	This file allows you to override any option in options.lua, or append to it, for example to the sFilter table.
	Since this file is mostly blank, it will most likely updated.
	You can therefore simply copy and paste it every time you update the UI, and keep your settings, unless mentioned otherwise.
	
	To override an option in a table which uses key-value pairs, format it like this:
	C.general.autorepair_guild = true
	
	To override an option in a table which uses indexes (=the table is simply a summary of values), use this:
	C.sfilter.PALADIN[1] = {spellId = 59578, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3}
	
	To append an option to an existing table, use this format:
	tinsert(C.sfilter.PALADIN, {spellId = 114250, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3})
	
	To remove an element from an existing table (in this case the first):
	tremove(C.sfilter.PALADIN, 1)
]]

-- Uncomment the line below if you want profiles based on character name
-- local n = UnitName("player")
local lvl = UnitLevel("player")
local class = select(2, UnitClass("player"))
local realm = GetRealmName()

-- I strongly recommend this, so you don't automatically pass on greens you might need
if lvl ~= 90 then
	C.general.autoroll = false
end

-- Show the extended cast bars for pure caster classes
if class == "MAGE" or class == "PRIEST" or class == "WARLOCK" then
	C.unitframes.castbar = 2
end