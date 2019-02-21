local _, ns = ...
local F, C, L = unpack(ns)

--[[
	This file allows you to override any option in options.lua, or append to it.
	You can therefore simply copy and paste it every time you update the UI, and keep your settings, unless mentioned otherwise.

	To override an option in a table which uses key-value pairs, format it like this:
	C.inventory.enable = true
]]

local playerName = UnitName('player')
local playerClass = select(2, UnitClass('player'))
local playerRealm = GetRealmName()


-- customize fonts path
--C.font.normal = 'Fonts\\FreeUI\\normal.otf'
--C.font.damage = 'Fonts\\FreeUI\\damage.ttf'
--C.font.header = 'Fonts\\FreeUI\\header.ttf'
--C.font.chat   = 'Fonts\\FreeUI\\normal.otf'

-- keywords for chat filter
--C.chat.filterList = '扰频 招人 招收 收人 主收 薪呺 澳廸 邦打 散拿'
--C.chat.timeVisible = 60

-- reposition player frame
--C.unitframe.player_pos = {'TOP', UIParent, 'CENTER', 0, -360}
