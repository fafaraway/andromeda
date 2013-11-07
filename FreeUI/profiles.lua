local F, C, L = unpack(select(2, ...))

--[[
	This file allows you to override any option in options.lua, or append to it, for example to the buffTracker table.
	Since this file is mostly blank, it will most likely updated.
	You can therefore simply copy and paste it every time you update the UI, and keep your settings, unless mentioned otherwise.

	To override an option in a table which uses key-value pairs, format it like this:
	C.general.autorepair_guild = true

	To override an option in a table which uses indexes (=the table is simply a summary of values), use this:
	C.buffTracker.PALADIN[1] = {spellId = 59578, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3}
	(if you are adding a table for a new class, you have to use C.buffTracker.NEWCLASSHERE = {} first)

	To append an option to an existing table, use this format:
	tinsert(C.buffTracker.PALADIN, {spellId = 114250, unitId = "player", isMine = 1, filter = "HELPFUL", slot = 3})

	To remove an element from an existing table (in this case the first):
	tremove(C.buffTracker.PALADIN, 1)
]]

local name = C.myName
local class = C.myClass
local realm = C.myRealm