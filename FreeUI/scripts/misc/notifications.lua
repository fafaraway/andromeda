local F, C, L = unpack(select(2, ...))
local module = F:GetModule('misc')

local format = string.format
local pairs = pairs

function module:AddAlerts()
	self:InterruptAlert()
	self:UsefulSpellAlert()
	self:ResAlert()
	self:SappedAlert()
end


-- interrupt/stolen/dispel alert
function module:InterruptAlert()
	if not C.misc.interruptAlert then return end

	local interruptSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\Shutupfool.ogg'
	local dispelSound = 'Interface\\AddOns\\FreeUI\\assets\\sound\\buzz.ogg'

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self)
		local _, event, _, sourceGUID, _, _, _, _, destName, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		local inInstance, instanceType = IsInInstance()
		if ((sourceGUID == UnitGUID('player')) or (sourceGUID == UnitGUID('pet'))) then
			if (event == 'SPELL_INTERRUPT') then
				if C.misc.interruptSound then
					PlaySoundFile(interruptSound, 'Master')
				end
				if inInstance and C.misc.interruptNotify and (instanceType ~= 'pvp' and instanceType ~= 'arena') then
					SendChatMessage(L['interrupted']..destName..' '..GetSpellLink(spellID), say)
				end
			elseif (event == 'SPELL_DISPEL') then
				if C.misc.dispelSound then
					PlaySoundFile(dispelSound, 'Master')
				end
				if inInstance and C.misc.interruptNotify and (instanceType ~= 'pvp' and instanceType ~= 'arena') then
					SendChatMessage(L['dispeled']..destName..' '..GetSpellLink(spellID), say)
				end
			elseif (event == 'SPELL_STOLEN') then
				if C.misc.dispelSound then
					PlaySoundFile(dispelSound, 'Master')
				end
				if inInstance and C.misc.interruptNotify and (instanceType ~= 'pvp' and instanceType ~= 'arena') then
					SendChatMessage(L['stolen']..destName..' '..GetSpellLink(spellID), say)
				end
			end
		end
	end)
end


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



function module:UsefulSpellAlert()
	if not C.misc.usefulSpellAlert then return end

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self, event)
		local inInstance, instanceType = IsInInstance()
		local _, subEvent, _, _, srcName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo() 
		if not IsInGroup() or not inInstance or InCombatLockdown() or not subEvent or not spellID or not srcName then return end
		if not UnitInRaid(srcName) and not UnitInParty(srcName) then return end

		local srcName = srcName:gsub('%-[^|]+', '')
		if subEvent == 'SPELL_CAST_SUCCESS' then

			if FeastSpells[spellID] then 
				SendChatMessage(format(L['Feast'], srcName, GetSpellLink(spellID)), say)
			end

			if spellID == 43987 then
				SendChatMessage(format(L['RefreshmentTable'], srcName, GetSpellLink(spellID)), say)

			elseif spellID == 698 then
				SendChatMessage(format(L['RitualOfSummoning'], srcName, GetSpellLink(spellID)), say)
			end
		elseif subEvent == 'SPELL_SUMMON' then

			if Bots[spellID] then
				SendChatMessage(format(L['BotToy'], srcName, GetSpellLink(spellID)), say)
			end
		elseif subEvent == 'SPELL_CREATE' then

			if spellID == 54710 then -- MOLL-E
				SendChatMessage(format(L['BotToy'], srcName, GetSpellLink(spellID)), say)

			elseif spellID == 29893 then
				SendChatMessage(format(L['SoulWell'], srcName, GetSpellLink(spellID)), say)

			elseif Toys[spellID] then
				SendChatMessage(format(L['BotToy'], srcName, GetSpellLink(spellID)), say)

			elseif PortalSpells[spellID] then
				SendChatMessage(format(L['Portal'], srcName, GetSpellLink(spellID)), say)
			end
		end
	end)
end


local CombatResSpells = {
	[61999] = true,	-- 盟友復生
	[20484] = true,	-- 復生
	[20707] = true,	-- 靈魂石
}
local TransferThreatSpells = {
	[34477] = true,	-- 誤導
	[57934] = true,	-- 偷天換日
}


function module:ResAlert()
	if not C.misc.resAlert then return end

	local frame = CreateFrame('Frame')
	frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	frame:SetScript('OnEvent', function(self, event)	
		local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
		local _, _, difficultyID = GetInstanceInfo()
		
		if event ~= 'SPELL_CAST_SUCCESS' then return end
		
		if destName then destName = destName:gsub('%-[^|]+', '') end
		if sourceName then sourceName = sourceName:gsub('%-[^|]+', '') else return end
		
		if difficultyID ~= 0 then
			if CombatResSpells[spellID] then
				if destName == nil then
					SendChatMessage(format(L['ResNoTarget'], sourceName, GetSpellLink(spellID)), say)
				else
					SendChatMessage(format(L['ResTarget'], sourceName, GetSpellLink(spellID), destName), say)
				end
			end
		end

	end)
end


function module:SappedAlert()
	if not C.misc.sappedAlert then return end

	local frame = CreateFrame('Frame')
	local _, playerName
	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	frame:RegisterEvent('PLAYER_LOGIN')
	frame:SetScript('OnEvent',function(_, event, ...)
		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			local _, event, _, _, sourceName, _, _, _, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
			if spellID == 6770 and destName == playerName and (event == 'SPELL_AURA_APPLIED' or event == 'SPELL_AURA_REFRESH') then
				SendChatMessage('{rt8} '..(GetSpellLink(6770) or 'Sapped')..' {rt8}','SAY')
				if sourceName then DEFAULT_CHAT_FRAME:AddMessage((GetSpellLink(6770) or 'Sapped')..' -- '..sourceName) end
			end
		elseif event == 'PLAYER_ENTERING_WORLD' then
			local _, instanceType, _, _, _, _, _, instanceMapID = GetInstanceInfo()
			if instanceType == 'scenario' or instanceType == 'party' or instanceType == 'raid' then
				if frame:IsEventRegistered('ZONE_CHANGED') then
					frame:UnregisterEvent('ZONE_CHANGED')
					frame:UnregisterEvent('ZONE_CHANGED_INDOORS')
					frame:UnregisterEvent('ZONE_CHANGED_NEW_AREA')
				end
				if frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
				if frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:UnregisterEvent('PLAYER_REGEN_DISABLED') end
				if frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:UnregisterEvent('PLAYER_REGEN_ENABLED') end
			elseif instanceType == 'arena' or instanceType == 'pvp' then
				if frame:IsEventRegistered('ZONE_CHANGED') then
					frame:UnregisterEvent('ZONE_CHANGED')
					frame:UnregisterEvent('ZONE_CHANGED_INDOORS')
					frame:UnregisterEvent('ZONE_CHANGED_NEW_AREA')
				end
				if not frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:RegisterEvent('PLAYER_REGEN_DISABLED') end
				if not frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:RegisterEvent('PLAYER_REGEN_ENABLED') end
				if not InCombatLockdown() and not frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
			else
				if not frame:IsEventRegistered('ZONE_CHANGED') then
					frame:RegisterEvent('ZONE_CHANGED')
					frame:RegisterEvent('ZONE_CHANGED_INDOORS')
					frame:RegisterEvent('ZONE_CHANGED_NEW_AREA')
				end
				if IsResting() then
					if frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
					if frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:UnregisterEvent('PLAYER_REGEN_DISABLED') end
					if frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:UnregisterEvent('PLAYER_REGEN_ENABLED') end
				else
					if not frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:RegisterEvent('PLAYER_REGEN_DISABLED') end
					if not frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:RegisterEvent('PLAYER_REGEN_ENABLED') end
					if not InCombatLockdown() and not frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
				end
			end
		elseif event == 'PLAYER_LOGIN' then
			playerName = GetUnitName('player')
			frame:UnregisterEvent('PLAYER_LOGIN')
		elseif event == 'PLAYER_REGEN_DISABLED' then
			frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		elseif event == 'PLAYER_REGEN_ENABLED' then
			frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
		else
			C_Timer.After(5, function()
				if IsResting() then
					if frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
					if frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:UnregisterEvent('PLAYER_REGEN_DISABLED') end
					if frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:UnregisterEvent('PLAYER_REGEN_ENABLED') end
				else
					if not frame:IsEventRegistered('PLAYER_REGEN_DISABLED') then frame:RegisterEvent('PLAYER_REGEN_DISABLED') end
					if not frame:IsEventRegistered('PLAYER_REGEN_ENABLED') then frame:RegisterEvent('PLAYER_REGEN_ENABLED') end
					if not InCombatLockdown() and not frame:IsEventRegistered('COMBAT_LOG_EVENT_UNFILTERED') then frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED') end
				end
			end)
		end
	end)
end
