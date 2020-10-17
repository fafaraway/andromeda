local F, C, L = unpack(select(2, ...))
local ANNOUNCEMENT = F.ANNOUNCEMENT


local battleRez = {
	[61999] = true,		-- Raise Ally
	[20484] = true,		-- Rebirth
	[20707] = true,		-- Soulstone
	[265116] = true,	-- 不穩定的時間轉移器（工程學）
    [345130] = true		-- Disposable Spectrophasic Reanimator（工程學）
}

local repair = {
	[22700] = true,		-- 修理機器人74A型
	[44389] = true,		-- 修理機器人110G型
	[54711] = true,		-- 廢料機器人
	[67826] = true,		-- 吉福斯
	[126459] = true,	-- 布靈登4000型
	[161414] = true,	-- 布靈登5000型
	[200061] = true,	-- 召唤里弗斯
	[200204] = true,	-- 自動鐵錘模式(里弗斯)
	[200205] = true,	-- 自動鐵錘模式(里弗斯)
	[200210] = true,	-- 故障检测模式(里弗斯)
	[200211] = true,	-- 故障检测模式(里弗斯)
	[200212] = true,	-- 烟花表演模式(里弗斯)
	[200214] = true,	-- 烟花表演模式(里弗斯)
	[200215] = true,	-- 零食发放模式(里弗斯)
	[200216] = true,	-- 零食发放模式(里弗斯)
	[200217] = true,	-- 华丽模式(布靈登6000型)(里弗斯)
	[200218] = true,	-- 华丽模式(布靈登6000型)(里弗斯)
	[200219] = true,	-- 驾驶战斗模式(里弗斯)
	[200220] = true,	-- 驾驶战斗模式(里弗斯)
	[200221] = true,	-- 虫洞发生器模式(里弗斯)
	[200222] = true,	-- 虫洞发生器模式(里弗斯)
	[200223] = true,	-- 热砧模式(里弗斯)
	[200225] = true,	-- 热砧模式(里弗斯)
	[199109] = true,	-- 自動鐵錘

}

local mail = {
	[261602] = true,	-- Katy Stampwhistle
	[54710] = true,		-- MOLL-E
}

local codex = {
	[226241] = true,	-- 宁神圣典
	[256230] = true,	-- 静心圣典
}

local feast = {
	[185709] = true,  -- Sugar-Crusted Fish Feast
	[126492] = true,  -- 燒烤盛宴
	[126494] = true,  -- 豪华燒烤盛宴
	[126495] = true,  -- 快炒盛宴
	[126496] = true,  -- 豪华快炒盛宴
	[126501] = true,  -- 烘烤盛宴
	[126502] = true,  -- 豪华烘烤盛宴
	[126497] = true,  -- 燉煮盛宴
	[126498] = true,  -- 豪华燉煮盛宴
	[126499] = true,  -- 蒸煮盛宴
	[126500] = true,  -- 豪華蒸煮盛宴
	[104958] = true,  -- 熊貓人盛宴
	[126503] = true,  -- 美酒盛宴
	[126504] = true,  -- 豪華美酒盛宴
	[145166] = true,  -- 拉麵推車
	[145169] = true,  -- 豪華拉麵推車
	[145196] = true,  -- 熊貓人國寶級拉麵推車
	[188036] = true,  -- 灵魂药锅
	[201351] = true,  -- 丰盛大餐
	[201352] = true,  -- 苏拉玛奢华大餐
	[259409] = true,  -- 海帆盛宴
	[259410] = true,  -- 船长盛宴佳肴
	[286050] = true,  -- 血潤盛宴
	[297048] = true,  -- 饿了没
}

local cauldron = {
	[276972] = true,	-- 神秘大鍋
}

local refreshment = {
	[190336] = true,	-- Conjure Refreshment
}

local portals = {
	-- Alliance
	[10059] = true,		-- Stormwind
	[11416] = true,		-- Ironforge
	[11419] = true,		-- Darnassus
	[32266] = true,		-- Exodar
	[49360] = true,		-- Theramore
	[33691] = true,		-- Shattrath
	[88345] = true,		-- Tol Barad
	[132620] = true,	-- Vale of Eternal Blossoms
	[176246] = true,	-- Stormshield
	[281400] = true,	-- Boralus
	-- Horde
	[11417] = true,		-- Orgrimmar
	[11420] = true,		-- Thunder Bluff
	[11418] = true,		-- Undercity
	[32267] = true,		-- Silvermoon
	[49361] = true,		-- Stonard
	[35717] = true,		-- Shattrath
	[88346] = true,		-- Tol Barad
	[132626] = true,	-- Vale of Eternal Blossoms
	[176244] = true,	-- Warspear
	[281402] = true,	-- Dazar'alor
	-- Alliance/Horde
	[53142] = true,		-- Dalaran
	[120146] = true,	-- Ancient Dalaran
	[224871] = true,	-- Dalaran, Broken Isles
}

local toys = {
	[61031] = true,		-- 玩具火車組
	[49844] = true,		-- 恐酒遙控器
}

local function CheckChannel()
	return IsPartyLFG() and 'INSTANCE_CHAT' or IsInRaid() and 'RAID' or 'PARTY'
end

local debugMode = false
local function SendMsg(text)
	if debugMode then
		F.Print(text)
	end

	--SendChatMessage(text, CheckChannel())
	SendChatMessage(text, 'SAY')
end

function ANNOUNCEMENT:UpdateEvents(...)
	local _, event, _, sourceGUID, sourceName, _, _, _, destName, _, _, sourceSpellId, _, _, targetSpellId = ...
	local isMine = (sourceGUID == UnitGUID('player') or sourceGUID == UnitGUID('pet'))

	if sourceName then sourceName = sourceName:gsub('%-[^|]+', '') end
	if destName then destName = destName:gsub('%-[^|]+', '') end

	if event == 'SPELL_INTERRUPT' then
		if not (FreeDB.announcement.interrupt and isMine) then return end

		SendMsg(format(L['ANNOUNCEMENT_INTERRUPT'], destName, GetSpellLink(targetSpellId)))
	end

	if event == 'SPELL_DISPEL' then
		if not (FreeDB.announcement.dispel and isMine) then return end

		SendMsg(format(L['ANNOUNCEMENT_DISPEL'], destName, GetSpellLink(targetSpellId)))
	end

	if event == 'SPELL_STOLEN' then
		if not (FreeDB.announcement.stolen and isMine) then return end

		SendMsg(format(L['ANNOUNCEMENT_STOLEN'], destName, GetSpellLink(targetSpellId)))
	end

	if event == 'SPELL_CAST_SUCCESS' then
		if FreeDB.announcement.feast and feast[sourceSpellId] then
			SendChatMessage(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.cauldron and cauldron[sourceSpellId] then
			SendChatMessage(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.refreshment and refreshment[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.battle_resurrection and battleRez[sourceSpellId] then
			if destName == nil then
				SendMsg(format(L['ANNOUNCEMENT_BATTLE_RESURRECTION'], sourceName, GetSpellLink(sourceSpellId)))
			else
				SendMsg(format(L['ANNOUNCEMENT_BATTLE_RESURRECTION_TARGET'], sourceName, GetSpellLink(sourceSpellId), destName))
			end
		end
	end

	if event == 'SPELL_SUMMON' then
		if FreeDB.announcement.mail and mail[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.repair and repair[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.codex and codex[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end
	end

	if event == 'SPELL_CREATE' then
		if FreeDB.announcement.portal and portals[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.soulwell and (sourceSpellId == 29893) then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.mail and mail[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end

		if FreeDB.announcement.toy and toys[sourceSpellId] then
			SendMsg(format(L['ANNOUNCEMENT_CASTED'], sourceName, GetSpellLink(sourceSpellId)))
		end
	end
end

function ANNOUNCEMENT:OnLogin()
	if not (IsInInstance() and IsInGroup()) then return end

	if FreeDB.announcement.enable then
		F:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.UpdateEvents)
	else
		F:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', ANNOUNCEMENT.UpdateEvents)
	end
end
