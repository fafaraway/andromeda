local _, ns = ...
local F, C, L = unpack(ns)

--[[
	This file allows you to override any option in options.lua, or append to it.
	You can therefore simply copy and paste it every time you update the UI, and keep your settings, unless mentioned otherwise.

	To override an option in a table which uses key-value pairs, format it like this:
	C.bags.enable = true
]]

local playerName = UnitName('player')
local playerClass = select(2, UnitClass('player'))
local playerRealm = GetRealmName()

--[[
-- override font
C.font.normal = 'Fonts\\冬青黑体旧字形W6_1.otf'
C.font.damage = 'Fonts\\damage.ttf'
C.font.header = 'Fonts\\header.ttf'
C.font.chat = 'Fonts\\冬青黑体旧字形W6_1.otf'

-- add chat filter keywords
C.chat.filterList = '艾尔文森林美食协会 光明十字军 暗影之殇 Excalibur 亦可赛艇 墨雪 夙愿 柳岩客栈 黄金梅利 新公会 豪门夜宴 猎户星座 星空之下 小号的天堂 守護之魂 爱与家庭 曙乂光 迪奥布斯 星辉 孤城 荣丶耀 众神之颠 扰频 刷屏 招人 招收 收人 主收 薪呺 澳廸 邦打 散拿'

-- enable glassy unitframes
C.unitframes.transMode = true

-- enable separate cast bar for player
C.unitframes.cbSeparate = true

-- reposition player unitframe
C.unitframes.player_pos = {'CENTER', UIParent, 'CENTER', 0, -240}

-- enalbe all-in-one bag style
C.bags.itemFilter = false

-- actionbars setting
C.actionbars.bar3Fade = true
C.actionbars.sideBarEnable = false
C.actionbars.stanceBarEnable = false

if playerClass == 'DEMONHUNTER' or playerClass == 'PALADIN' then
	C.actionbars.layoutSimple = true
	--C.unitframes.enableFrameVisibility = true
	--C.unitframes.player_frameVisibility = '[mod:shift] show; hide'
	--C.unitframes.party_showSolo = true
end

if playerClass == 'PALADIN' then
	C.bags.itemFilter = false
end

]]
