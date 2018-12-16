local F, C, L = unpack(select(2, ...))
local module = F:GetModule('reminder')

local FeastSpells = {
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
	[127851] = true,  -- 灵魂药锅
	[133578] = true,  -- 丰盛大餐
	[133579] = true,  -- 苏拉玛奢华大餐
	[156525] = true,  -- 海帆盛宴
	[156526] = true,  -- 船长盛宴佳肴
	[162519] = true,  -- 秘法药锅
	[185709] = true,  -- 焦糖鱼宴
	[259409] = true,  -- 海帆盛宴
	[259410] = true,  -- 船长盛宴
	[276972] = true,  -- 秘法药锅
	[286050] = true,  -- 鲜血大餐
}

local Bots = {
	[22700] = true,		-- 修理機器人74A型
	[44389] = true,		-- 修理機器人110G型
	[54711] = true,		-- 廢料機器人
	[67826] = true,		-- 吉福斯
	[126459] = true,	-- 布靈登4000型
	[161414] = true,	-- 布靈登5000型
	[198989] = true,	-- 布靈登6000型
	[132514] = true,	-- 自動鐵錘
	[141333] = true,	-- 宁神圣典
	[153646] = true,	-- 静心圣典
}

local Toys = {
	[61031] = true,		-- 玩具火車組
	[49844] = true,		-- 恐酒遙控器
}

local PortalSpells = {
	[10059] = true,		-- 暴風城
	[11416] = true,		-- 鐵爐堡
	[11419] = true,		-- 達納蘇斯
	[32266] = true,		-- 艾克索達
	[49360] = true,		-- 塞拉摩
	[33691] = true,		-- 撒塔斯
	[88345] = true,		-- 托巴拉德
	[132620] = true,	-- 恆春谷
	[176246] = true,	-- 暴風之盾

	[11417] = true,		-- 奧格瑪
	[11420] = true,		-- 雷霆崖
	[11418] = true,		-- 幽暗城
	[32267] = true,		-- 銀月城
	[49361] = true,		-- 斯通納德
	[35717] = true,		-- 撒塔斯
	[88346] = true,		-- 托巴拉德
	[132626] = true,	-- 恆春谷
	[176244] = true,	-- 戰爭之矛

	[53142] = true,		-- 達拉然
	[120146] = true,	-- 遠古達拉然
}



function module:Spell()
	if not C.reminder.spell then return end

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self, event)
		local inInstance, instanceType = IsInInstance()
		local _, subEvent, _, _, srcName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo() 
		if not IsInGroup() or instanceType ~= 'party' or InCombatLockdown() or not subEvent or not spellID or not srcName then return end
		if not UnitInRaid(srcName) and not UnitInParty(srcName) then return end

		local srcName = srcName:gsub('%-[^|]+', '')
		if subEvent == 'SPELL_CAST_SUCCESS' then
			if FeastSpells[spellID] then 
				SendChatMessage(format(L['Feast'], srcName, GetSpellLink(spellID)), say)
			elseif spellID == 43987 then -- Conjure Refreshment Table
				SendChatMessage(format(L['RefreshmentTable'], srcName, GetSpellLink(spellID)), say)
			elseif spellID == 698 then -- Ritual of Summoning
				SendChatMessage(format(L['RitualOfSummoning'], srcName, GetSpellLink(spellID)), say)
			elseif spellID == 226241 then -- 宁神圣典
				SendChatMessage(format(L['Feast'], srcName, GetSpellLink(spellID)), say)
			elseif spellID == 256230 then -- 静心圣典
				SendChatMessage(format(L['Feast'], srcName, GetSpellLink(spellID)), say)
			end
		elseif subEvent == 'SPELL_SUMMON' then
			if Bots[spellID] then
				SendChatMessage(format(L['BotToy'], srcName, GetSpellLink(spellID)), say)
			end
		elseif subEvent == 'SPELL_CREATE' then
			if spellID == 54710 then -- MOLL-E
				SendChatMessage(format(L['BotToy'], srcName, GetSpellLink(spellID)), say)
			elseif spellID == 29893 then -- Create Soulwell
				SendChatMessage(format(L['SoulWell'], srcName, GetSpellLink(spellID)), say)
			elseif Toys[spellID] then
				SendChatMessage(format(L['BotToy'], srcName, GetSpellLink(spellID)), say)
			elseif PortalSpells[spellID] then
				SendChatMessage(format(L['Portal'], srcName, GetSpellLink(spellID)), say)
			end
		end
	end)
end